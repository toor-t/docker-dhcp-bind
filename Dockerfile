FROM alpine:latest

COPY	init_config start_server stop_server /sbin/

RUN	apk update && apk add --no-cache openrc &&\
	sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
	echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
	sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
	sed -i '/tty/d' /etc/inittab &&\
	sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
	sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
	sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh &&\
	mkdir -p /run/openrc && touch /run/openrc/softlevel &&\
	apk add --no-cache rsyslog bind dhcp &&\
	chmod u+x /sbin/init_config &&\
	chmod u+x /sbin/start_server &&\
	chmod u+x /sbin/stop_server

VOLUME [ "/data" ]

ENTRYPOINT [ "/sbin/init" ]
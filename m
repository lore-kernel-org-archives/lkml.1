Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab0BDU7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:59:10 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47863 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab0BDU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:59:04 -0500
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for child processes
From: Kay Sievers <kay.sievers@vrfy.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1265298175.24100.8.camel@yio.site>
References: <20100202120457.GA19605@omega>
	 <1265298175.24100.8.camel@yio.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 21:59:26 +0100
Message-ID: <1265317166.2207.1.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:42 +0100, Kay Sievers wrote:

> Sounds good to me. And seems useful for all sorts of session tracking
> and "prettifying ps". :)

Here is the output of 'ps" with a wrapped gnome-session with the anchor
flag set. All the started programs stay childs of the session, instead
of becoming childs of init:

Thanks,
Kay

PID TTY      STAT   TIME COMMAND
    2 ?        S      0:00 [kthreadd]
    3 ?        S      0:00  \_ [migration/0]
    4 ?        S      0:00  \_ [ksoftirqd/0]
    5 ?        S      0:00  \_ [migration/1]
    6 ?        S      0:00  \_ [ksoftirqd/1]
    7 ?        S      0:00  \_ [events/0]
    8 ?        S      0:00  \_ [events/1]
    9 ?        S      0:00  \_ [khelper]
   10 ?        S      0:00  \_ [async/mgr]
   11 ?        S      0:00  \_ [sync_supers]
   12 ?        S      0:00  \_ [bdi-default]
   13 ?        S      0:00  \_ [kblockd/0]
   14 ?        S      0:00  \_ [kblockd/1]
   15 ?        S      0:00  \_ [kacpid]
   16 ?        S      0:00  \_ [kacpi_notify]
   17 ?        S      0:00  \_ [kacpi_hotplug]
   18 ?        S      0:00  \_ [ata/0]
   19 ?        S      0:00  \_ [ata/1]
   20 ?        S      0:00  \_ [ata_aux]
   21 ?        S      0:00  \_ [kseriod]
   24 ?        S      0:00  \_ [kondemand/0]
   25 ?        S      0:00  \_ [kondemand/1]
   26 ?        S      0:00  \_ [kswapd0]
   27 ?        S      0:00  \_ [aio/0]
   28 ?        S      0:00  \_ [aio/1]
   29 ?        S      0:00  \_ [crypto/0]
   30 ?        S      0:00  \_ [crypto/1]
   33 ?        S      0:00  \_ [scsi_eh_0]
   34 ?        S      0:00  \_ [scsi_eh_1]
   35 ?        S      0:00  \_ [scsi_eh_2]
   36 ?        S      0:00  \_ [scsi_eh_3]
   41 ?        S      0:00  \_ [kpsmoused]
   43 ?        S      0:00  \_ [jbd2/sda1-8]
   44 ?        S      0:00  \_ [ext4-dio-unwrit]
   45 ?        S      0:00  \_ [ext4-dio-unwrit]
  233 ?        S      0:00  \_ [ksuspend_usbd]
  238 ?        S      0:00  \_ [khubd]
  272 ?        S      0:00  \_ [cfg80211]
  283 ?        S      0:00  \_ [kvm-irqfd-clean]
  324 ?        S      0:00  \_ [ktpacpid]
  339 ?        S      0:00  \_ [iwlagn]
  340 ?        S      0:00  \_ [phy0]
  364 ?        S      0:00  \_ [i915]
  425 ?        S      0:00  \_ [hd-audio0]
  471 ?        S      0:00  \_ [flush-259:0]
  489 ?        S      0:00  \_ [usbhid_resumer]
  502 ?        S      0:00  \_ [scsi_eh_4]
  503 ?        S      0:00  \_ [usb-storage]
  514 ?        S      0:00  \_ [kauditd]
  526 ?        S      0:00  \_ [kstriped]
  564 ?        S      0:00  \_ [kjournald]
    1 ?        Ss     0:00 init [5]  
   96 ?        S<s    0:00 /sbin/udevd --daemon
  212 ?        S<     0:00  \_ /sbin/udevd --daemon
  213 ?        S<     0:00  \_ /sbin/udevd --daemon
  913 ?        Ss     0:00 /sbin/acpid
  920 ?        Ss     0:00 /bin/dbus-daemon --system
 1068 ?        Ss     0:00 avahi-daemon: running [yio.local]
 1086 ?        Sl     0:00 /sbin/rsyslogd -c 4 -f /etc/rsyslog.conf
 1091 ?        Ssl    0:00 /usr/sbin/console-kit-daemon
 1139 ?        Ss     0:00 /usr/sbin/sshd -o PidFile=/var/run/sshd.init.pid
 1234 ?        Ssl    0:00 /usr/sbin/nscd
 1252 ?        Ss     0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
 1255 ?        S      0:00 /usr/sbin/gdm
 1263 ?        S      0:00  \_ /usr/lib/gdm/gdm-simple-slave --display-id /org/gnome/DisplayManager/Display1
 1290 tty7     Ss+    0:15      \_ /usr/bin/Xorg :0 -br -verbose -auth /var/run/gdm/auth-for-gdm-t73y8a/database -nolisten tcp vt7
 1445 ?        S      0:00      \_ /usr/lib/gdm/gdm-session-worker
 1455 ?        Ssl    0:00          \_ /usr/bin/gnome-session
 1535 ?        Ss     0:00              \_ /usr/bin/gpg-agent --sh --daemon --write-env-file /home/kay/.gnupg/agent.info /usr/bin/ssh-agent /bin/bash /etc/X11/xinit/xinitrc
 1536 ?        Ss     0:00              \_ /usr/bin/ssh-agent /bin/bash /etc/X11/xinit/xinitrc
 1546 ?        S      0:00              \_ dbus-launch --exit-with-session /usr/bin/gnome-session
 1547 ?        Ss     0:00              \_ /bin/dbus-daemon --fork --print-pid 5 --print-address 9 --session
 1556 ?        S      0:00              \_ /usr/lib/GConf/2/gconfd-2
 1588 ?        Sl     0:00              \_ gnome-keyring-daemon --start --components=pkcs11
 1589 ?        SLl    0:00              \_ gnome-keyring-daemon --start --components=secrets
 1592 ?        Sl     0:00              \_ gnome-keyring-daemon --start --components=ssh
 1597 ?        Ssl    0:01              \_ /usr/lib/gnome-settings-daemon/gnome-settings-daemon
 1598 ?        Ss     0:00              \_ seahorse-daemon
 1604 ?        S      0:00              \_ /usr/lib64/gvfs/gvfsd
 1611 ?        Ssl    0:00              \_ /usr/lib64/gvfs//gvfs-fuse-daemon /home/kay/.gvfs
 1636 ?        S      0:01              \_ /usr/bin/metacity
 1642 ?        Ssl    0:00              \_ /usr/bin/pulseaudio --start --log-target=syslog
 1740 ?        S      0:00              |   \_ /usr/lib/pulse/gconf-helper
 1649 ?        S      0:01              \_ gnome-panel
 1651 ?        S      0:02              \_ nautilus
 1653 ?        Ssl    0:00              \_ /usr/lib/bonobo/bonobo-activation-server --ac-activate --ior-output-fd=18
 1668 ?        S      0:00              \_ python /usr/share/system-config-printer/applet.py
 1669 ?        S      0:03              \_ /usr/lib/gnome-main-menu/main-menu --oaf-activate-iid=OAFIID:GNOME_MainMenu_Factory --oaf-ior-fd=18
 1672 ?        S      0:00              \_ evolution-alarm-notify
 1673 ?        S      0:00              \_ /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
 1676 ?        S      0:00              \_ gnome-power-manager
 1678 ?        S      0:00              \_ gnome-volume-control-applet
 1681 ?        S      0:01              \_ nm-applet --sm-disable
 1684 ?        S      0:00              \_ /usr/lib/gdu-notification-daemon
 1687 ?        S      0:00              \_ bluetooth-applet
 1705 ?        S      0:00              \_ /usr/lib/notification-daemon-1.0/notification-daemon
 1712 ?        S      0:00              \_ /usr/lib/evolution-data-server/e-calendar-factory
 1714 ?        Ss     0:00              \_ gnome-screensaver
 1719 ?        S      0:00              \_ /usr/lib/evolution-data-server/e-addressbook-factory
 1726 ?        S      0:00              \_ /usr/lib64/gvfs/gvfs-gdu-volume-monitor
 1737 ?        S      0:00              \_ /usr/lib64/gvfs/gvfs-gphoto2-volume-monitor
 1745 ?        S      0:00              \_ /usr/lib64/gvfs/gvfsd-trash --spawner :1.8 /org/gtk/gvfs/exec_spaw/0
 1774 ?        S      0:00              \_ /usr/lib64/gvfs/gvfsd-burn --spawner :1.8 /org/gtk/gvfs/exec_spaw/1
 1786 ?        S      0:00              \_ /usr/lib64/gvfs/gvfsd-metadata
 1885 ?        Sl     0:01              \_ /usr/bin/gnome-terminal -x /bin/sh -c cd '/home/kay/Desktop' && exec $SHELL
 1927 ?        S      0:00              |   \_ gnome-pty-helper
 1928 pts/1    Ss     0:00              |   \_ /bin/bash
 2124 pts/1    R+     0:00              |       \_ ps afx
 1981 ?        S      0:01              \_ pidgin
 2014 ?        SLl    0:06              \_ evolution
 2065 ?        S      0:00              \_ /bin/sh /usr/bin/firefox
 2070 ?        Rl     0:04              |   \_ /usr/lib64/firefox/firefox
 2111 ?        S      0:01              \_ xchat
 2112 ?        S      0:00              |   \_ xchat
 2123 ?        S      0:00              |   \_ xchat
 2117 ?        S      0:00              \_ palimpsest
 1356 ?        Ss     0:00 /usr/lib/postfix/master
 1377 ?        S      0:00  \_ pickup -l -t fifo -u
 1390 ?        Ss     0:00 /usr/sbin/crond
 1434 ?        Ssl    0:00 /usr/sbin/NetworkManager
 1695 ?        S      0:00  \_ /sbin/dhclient -d -sf /usr/lib/NetworkManager/nm-dhcp-client.action -pf /var/run/dhclient-eth0.pid -lf /var/lib/dhcp/dhclient-73a36e75-368a-434c-b6c0-cfda0e3f1b50-eth0.lease -cf /var/run/nm-dhclient-eth0.conf eth0
 1438 ?        S      0:00 /usr/sbin/modem-manager
 1441 ?        S      0:00 /usr/sbin/wpa_supplicant -c /etc/wpa_supplicant/wpa_supplicant.conf -u -f /var/log/wpa_supplicant.log
 1443 ?        S      0:00 /usr/sbin/nm-system-settings --config /etc/NetworkManager/nm-system-settings.conf
 1550 ?        S      0:00 /usr/lib/DeviceKit-power/devkit-power-daemon
 1644 ?        SNl    0:00 /usr/lib/rtkit/rtkit-daemon
 1648 ?        S      0:06 /usr/lib/polkit-1/polkitd
 1707 ?        S      0:00 /usr/lib/DeviceKit-disks/devkit-disks-daemon
 1708 ?        S      0:00  \_ devkit-disks-daemon: polling /dev/sdb /dev/sdc
 1807 tty1     Ss+    0:00 /sbin/mingetty --noclear tty1
 1808 tty2     Ss+    0:00 /sbin/mingetty tty2
 1809 tty3     Ss+    0:00 /sbin/mingetty tty3
 1810 tty4     Ss+    0:00 /sbin/mingetty tty4
 1811 tty5     Ss+    0:00 /sbin/mingetty tty5
 1812 tty6     Ss+    0:00 /sbin/mingetty tty6



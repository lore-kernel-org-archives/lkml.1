Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXDUUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXDUUia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 16:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXDUUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 16:38:30 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:50923 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752817AbXDUUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 16:38:28 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, v4
Date: Sat, 21 Apr 2007 23:35:51 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
References: <20070420140457.GA14017@elte.hu>
In-Reply-To: <20070420140457.GA14017@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1575499.OQROWH0eL7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704212335.54318.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1575499.OQROWH0eL7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo;

20 Nis 2007 Cum tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,

I tried hard and found another problem for you :)

With Linus's current git + CFSv4 as soon as i start a guest in VirtualBox [=
1],=20
system enters the following loop;

=2D Whole system freeze ~5 secs.
=2D System works well ~5 secs
=2D Whole system freeze ~5 secs.

Again mainline has no issues but its %100 reproducible under CFSv4.

=46ollowing "ps aux" and "top" outputs grabbed while system works well, i c=
annot=20
do anything else while system freezes except moving mouse for fun :P

[caglar@zangetsu][~]> ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0      0     0 ?        Ss   22:26   0:00 init [3]
root         2  0.0  0.0      0     0 ?        S    22:26   0:00 [migration=
/0]
root         3  0.3  0.0      0     0 ?        SN   22:26   0:11 [ksoftirqd=
/0]
root         4  0.0  0.0      0     0 ?        S<   22:26   0:00 [events/0]
root         5  0.0  0.0      0     0 ?        S<   22:26   0:00 [khelper]
root         6  0.0  0.0      0     0 ?        S<   22:26   0:00 [kthread]
root        26  0.0  0.0      0     0 ?        S<   22:26   0:00 [kblockd/0]
root        27  0.0  0.0      0     0 ?        S<   22:26   0:00 [kacpid]
root       124  0.0  0.0      0     0 ?        S<   22:26   0:00 [kseriod]
root       137  0.0  0.0      0     0 ?        S<   22:26   0:00 [kapmd]
root       145  0.0  0.0      0     0 ?        S    22:26   0:00 [pdflush]
root       146  0.0  0.0      0     0 ?        S    22:26   0:00 [pdflush]
root       147  0.0  0.0      0     0 ?        S<   22:26   0:00 [kswapd0]
root       148  0.0  0.0      0     0 ?        S<   22:26   0:00 [aio/0]
root       802  0.0  0.0      0     0 ?        S<   22:26   0:00 [kpsmoused]
root       844  0.0  0.0      0     0 ?        S<   22:26   0:00 [ata/0]
root       845  0.0  0.0      0     0 ?        S<   22:26   0:00 [ata_aux]
root       856  0.0  0.0      0     0 ?        S<   22:26   0:01 [scsi_eh_0]
root       857  0.0  0.0      0     0 ?        S<   22:26   0:00 [scsi_eh_1]
root       869  0.0  0.0      0     0 ?        S<   22:26   0:00=20
[ksuspend_usbd]
root       872  0.0  0.0      0     0 ?        S<   22:26   0:00 [khubd]
root       919  0.0  0.0      0     0 ?        S<   22:26   0:00 [khpsbpkt]
root       927  0.0  0.0      0     0 ?        S<   22:26   0:00 [knodemgrd=
_0]
root       982  0.0  0.0      0     0 ?        S<   22:26   0:00 [xfslogd/0]
root       983  0.0  0.0      0     0 ?        S<   22:26   0:00 [xfsdatad/=
0]
root       985  0.0  0.0      0     0 ?        S<   22:26   0:00 [xfsbufd]
root       986  0.0  0.0      0     0 ?        S<   22:26   0:00 [xfssyncd]
root      1050  0.0  0.0      0     0 ?        S<s  22:26  =20
0:01 /sbin/udevd --daemon
root      2831  0.0  0.0      0     0 ?        S<   22:26   0:00 [kondemand=
/0]
root      2993  0.0  0.0      0     0 ?        S<   22:26   0:00 [tifm/0]
root      3039  0.0  0.0      0     0 ?        S<   22:26   0:00 [pccardd]
root      3063  0.0  0.0      0     0 ?        S<   22:26   0:00 [ipw2200/0]
root      3127  0.0  0.0      0     0 ?        Ss   22:26   0:00 Comar
root      3278  0.0  0.0      0     0 ?        S    22:26   0:00 ComarRPC
root      3334  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/syslogd -m 15
root      3338  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/klogd -c 3 -2
root      3340  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /sbin/dhcpcd -R -Y -N -t 20 eth1
root      3345  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/acpid -c /etc/acpi/events
dbus      3351  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/bin/dbus-daemon --system
root      3354  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/console-kit-daemon
root      3418  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/polkitd
hal       3420  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/hald --daemon=3Dyes --use-syslog
root      3421  0.0  0.0      0     0 ?        S    22:26   0:00 hald-runner
hal       3432  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-keyboard: listening on /dev/input/event0
hal       3435  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-keyboard: listening on /dev/input/event1
hal       3436  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-keyboard: listening on /dev/input/event2
hal       3437  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-keyboard: listening on /dev/input/event4
root      3444  0.0  0.0      0     0 tty1     Ss+  22:26  =20
0:00 /sbin/mingetty --noclear tty1
root      3445  0.0  0.0      0     0 tty2     Ss+  22:26  =20
0:00 /sbin/mingetty --noclear tty2
root      3446  0.0  0.0      0     0 tty3     Ss+  22:26  =20
0:00 /sbin/mingetty tty3
root      3447  0.0  0.0      0     0 tty4     Ss+  22:26  =20
0:00 /sbin/mingetty tty4
root      3448  0.0  0.0      0     0 tty5     Ss+  22:26  =20
0:00 /sbin/mingetty tty5
root      3449  0.0  0.0      0     0 tty6     Ss+  22:26  =20
0:00 /sbin/mingetty tty6
root      3450  0.0  0.0      0     0 ?        S    22:26  =20
0:00 /usr/libexec/hald-addon-cpufreq
hal       3451  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-acpi: listening on acpid socket /var/run/acpid.socket
root      3576  0.0  0.0      0     0 ?        S    22:26   0:00=20
hald-addon-storage: polling /dev/sr0 (every 2 sec)
root      3582  0.0  0.0      0     0 ?        S<s  22:26   0:00 /sbin/audi=
td
root      3584  0.0  0.0      0     0 ?        S<s  22:26   0:00=20
python /sbin/audispd
nobody    3588  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/mdnsd
root      3589  0.0  0.0      0     0 ?        Ss   22:26  =20
0:01 /opt/sun-jdk/bin/java -DConfigFile=3D/opt/zemberek-server/config/conf.=
ini -Djava.library.path=3D/opt/zemberek-server/li
root      3591  0.0  0.0      0     0 ?        S<   22:26   0:00 [kauditd]
root      3637  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/kde/3.5/bin/kdm
root      3656  0.0  0.0      0     0 ?        Ss   22:26  =20
0:00 /usr/sbin/cupsd
root      3661  8.9  0.0      0     0 tty7     S<s+ 22:26  =20
5:06 /usr/bin/X -br -nolisten tcp :0 vt7 -auth /var/run/xauth/A:0-uzBkHQ
root      3662  0.0  0.0      0     0 ?        S    22:26   0:00 -:0
caglar    3713  0.0  0.0      0     0 ?        Ss   22:27  =20
0:00 /bin/sh /usr/kde/3.5/bin/startkde
caglar    3740  0.0  0.0      0     0 ?        Ss   22:27  =20
0:00 /usr/bin/gpg-agent --daemon
caglar    3744  0.0  0.0      0     0 ?        S    22:27  =20
0:00 /usr/bin/dbus-launch --auto-syntax --exit-with-session
caglar    3745  0.0  0.0      0     0 ?        Ss   22:27  =20
0:00 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
root      3763  0.0  0.0      0     0 ?        S    22:27   0:00=20
start_kdeinit --new-startup +kcminit_startup
caglar    3764  0.0  0.0      0     0 ?        Ss   22:27   0:00 kdeinit=20
Running...
caglar    3767  0.0  0.0      0     0 ?        S    22:27   0:00 dcopserver=
=20
[kdeinit] --nosid
caglar    3769  0.0  0.0      0     0 ?        S    22:27   0:00 klauncher=
=20
[kdeinit] --new-startup
caglar    3771  0.0  0.0      0     0 ?        S    22:27   0:01 kded=20
[kdeinit] --new-startup
caglar    3776  0.0  0.0      0     0 ?        S    22:27   0:00 kwrapper=20
ksmserver
caglar    3778  0.0  0.0      0     0 ?        S    22:27   0:00 ksmserver=
=20
[kdeinit]
caglar    3779  0.0  0.0      0     0 ?        S    22:27   0:02 kwin=20
[kdeinit] -session 10dfd5e1dc000117615244300000037860015_1177150228_731669
caglar    3781  0.0  0.0      0     0 ?        S    22:27   0:01 kdesktop=20
[kdeinit]
caglar    3784  0.1  0.0      0     0 ?        S    22:27   0:06 kicker=20
[kdeinit]
caglar    3790  0.0  0.0      0     0 ?        S    22:27  =20
0:00 /usr/kde/3.5/bin/artsd -F 10 -S 4096 -s 3 -m artsmessage -c drkonqi -l=
=20
3 -f
caglar    3792  0.0  0.0      0     0 ?        S    22:27   0:00 kaccess=20
[kdeinit]
caglar    3795  0.0  0.0      0     0 ?        S    22:27   0:00 kgpg -sess=
ion=20
10dfd5e1dc000116939040300000034540016_1177150228_693587
caglar    3797  0.0  0.0      0     0 ?        S    22:27   0:00 kmix=20
[kdeinit] -session 10dfd5e1dc000117381541300000036690022_1177150228_688422
caglar    3799  0.0  0.0      0     0 ?        S    22:27   0:03=20
yakuake -session 10dfd5e1dc000117550619600000038750011_1177150228_688557
caglar    3801  0.1  0.0      0     0 ?        S    22:27   0:06=20
akregator -session 10dfd5e1dc000116863705100000035770011_1177150228_688758
caglar    3803  1.6  0.0      0     0 ?        S    22:27   0:57=20
amarokapp -session 10dfd5e1dc000117589538100000037590019_1177150228_689118
caglar    3806  0.0  0.0      0     0 ?        S    22:27   0:00 knotify=20
[kdeinit]
caglar    3820  2.2  0.0      0     0 ?        S    22:27   1:15=20
kmail -session 10dfd5e1dc000117702739100000037820008_1177150228_689302
caglar    3825  0.0  0.0      0     0 ?        S    22:27   0:00 kpowersave=
=20
[kdeinit]
caglar    3828  0.0  0.0      0     0 ?        S    22:27   0:00 klipper=20
[kdeinit]
caglar    3840  0.4  0.0      0     0 ?        S    22:27   0:15=20
beagled /usr/lib/beagle/BeagleDaemon.exe --bg
caglar    4027  0.0  0.0      0     0 ?        S    22:28   0:00=20
ruby /usr/kde/3.5/share/apps/amarok/scripts/score_default/score_default.rb
caglar    4423  1.6  0.0      0     0 ?        SN   22:29   0:53=20
beagled-helper /usr/lib/beagle/IndexHelper.exe
caglar    4479  0.0  0.0      0     0 ?        S    22:29   0:00 konqueror=
=20
[kdeinit] -mimetype inode/directory system:/media/camera
caglar    4780  0.9  0.0      0     0 ?        S    22:35   0:27=20
kopete -caption Kopete -icon kopete -miniicon kopete
caglar    6513  0.0  0.0      0     0 pts/0    Ss   23:10   0:00 /bin/bash
caglar    6642  0.2  0.0      0     0 ?        S    23:15  =20
0:01 /usr/share/VirtualBox/VirtualBox
caglar    6655  0.0  0.0      0     0 ?        S    23:15   0:00 kio_file=20
[kdeinit]=20
file /tmp/ksocket-caglar/klauncher7DO9ja.slave-socket /tmp/ksocket-caglar/k=
desktop1c3ZQb.slave-s
caglar    6657  0.0  0.0      0     0 ?        S    23:15  =20
0:00 /usr/share/VirtualBox/VBoxSVC --daemonize
caglar    6663  0.0  0.0      0     0 ?        S    23:15  =20
0:00 /usr/share/VirtualBox/VBoxXPCOMIPCD
caglar    6684 71.7  0.0      0     0 ?        S    23:16  =20
5:40 /usr/share/VirtualBox/VirtualBox -startvm=20
8c00f6d9-e215-4501-a7aa-4ba19eb55acc
caglar    6730  0.0  0.0      0     0 pts/0    R+   23:24   0:00 ps aux

[caglar@zangetsu][~]> top
top - 23:24:27 up 58 min,  3 users,  load average: 13.59, 13.00, 7.75
Tasks: 102 total,   1 running, 101 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.4%us,  0.4%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.2%hi,  0.0%si,  0.0=
%st
Mem:   2067672k total,  1935300k used,   132372k free,      288k buffers
Swap:  2096440k total,        0k used,  2096440k free,   961236k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6684 caglar    20   0  625m 570m  15m S 99.2 28.3   5:56.17 VirtualBox
  844 root       1 -19     0    0    0 S  0.2  0.0   0:00.56 ata/0
 6731 caglar    20   0  2312 1124  856 R  0.2  0.1   0:00.04 top
    1 root      20   0  1608  556  484 S  0.0  0.0   0:00.92 init
    2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0
    3 root      39  19     0    0    0 S  0.0  0.0   0:11.85 ksoftirqd/0
    4 root       1 -19     0    0    0 S  0.0  0.0   0:00.07 events/0
    5 root       1 -19     0    0    0 S  0.0  0.0   0:00.02 khelper
    6 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kthread
   26 root       1 -19     0    0    0 S  0.0  0.0   0:00.04 kblockd/0
   27 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kacpid
  124 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kseriod
  137 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kapmd
  145 root      20   0     0    0    0 S  0.0  0.0   0:00.00 pdflush
  146 root      20   0     0    0    0 S  0.0  0.0   0:00.27 pdflush
  147 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kswapd0
  148 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 aio/0
  802 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 kpsmoused
  845 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 ata_aux
  856 root       1 -19     0    0    0 D  0.0  0.0   0:01.04 scsi_eh_0
  857 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_1
  869 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 ksuspend_usbd
  872 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 khubd
  919 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 khpsbpkt
  927 root       1 -19     0    0    0 S  0.0  0.0   0:00.00 knodemgrd_0
  982 root       1 -19     0    0    0 S  0.0  0.0   0:00.30 xfslogd/0
  983 root       1 -19     0    0    0 S  0.0  0.0   0:00.10 xfsdatad/0


[1] http://www.virtualbox.org/
Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1575499.OQROWH0eL7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGKnWqy7E6i0LKo6YRAlL6AJwKnGy9TEnO6fMoXudpdgq6CAbKDQCgmNlj
Tr8276dUziH0wOtkoZpYRFQ=
=LGDh
-----END PGP SIGNATURE-----

--nextPart1575499.OQROWH0eL7--

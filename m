Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbXJIQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbXJIQtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbXJIQtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:49:06 -0400
Received: from mail.exegy.com ([209.83.156.2]:1625 "EHLO mail.exegy.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbXJIQtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:49:04 -0400
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 12:49:04 EDT
thread-index: AcgKkgYOilsx8EmJTW+VbFPOsnpbwQ==
X-Ninja-AntiSpoofing: spoofed
Message-ID: <470BAD2E.7000305@exegy.com>
Date: Tue, 09 Oct 2007 11:32:46 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
Content-Transfer-Encoding: 7bit
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc9 kswapd infinite loop
Content-Type: multipart/mixed;
	boundary="------------060303050903020908020007"
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4073
Content-Class: urn:content-classes:message
Importance: normal
X-OriginalArrivalTime: 09 Oct 2007 16:32:46.0179 (UTC) FILETIME=[05F95B30:01C80A92]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--------------060303050903020908020007
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I have a reproducible hang with kswapd in the run queue, everything else =
is
in an i/o wait. The load average is climbing.

Using either a highpoint RR2340 or an LSI8888ELP PCIe-8 lane controller,
I max out the write rate at between 900MB/Sec to 1.1GB/Sec into
16 seagate 500GB ES series drives. Eventually the system locks up
with kswapd0 getting 100% of one CPU. kswapd1 is not running.

The system is a SuperMicro H8DM3-2 (or an H8DMi-2) with 2222SE or 2216=20
opterons,
16GB of RAM. 2.6.22-5, 2.6.21 and 2.6.23-rc7 and 2.6.23-rc9 all lock up.
2.6.20 does not, but it also runs 200MB/Sec slower in write rates.
The base O/S is Centos 5.0
I can patch in KDB and look around (did this for 2.6.22-5) but I'm
not sure what to look for in kswapd to see what got lost to keep
the system locked up. With eralier kernels, the system needs a reset
button to recover. With 2.6.23-rc9 I was left with enough to get the=20
following
ps, top, and /proc/meminfo data

Hints anyone (please) as to how to slay this dragon?

Berkley


--=20

// E. F. Berkley Shands, MSc//

** Exegy Inc.**

349 Marshall Road, Suite 100

St. Louis , MO  63119

Direct:  (314) 218-3600 X450

Cell:  (314) 303-2546

Office:  (314) 218-3600

Fax:  (314) 218-3601

=20

The Usual Disclaimer follows...
=20
This e-mail and any documents accompanying it may contain legally =
privileged and/or confidential information belonging to Exegy, Inc. Such =
information may be protected from disclosure by law. The information is =
intended for use by only the addressee. If you are not the intended =
recipient, you are hereby notified that any disclosure or use of the =
information is strictly prohibited. If you have received this e-mail in =
error, please immediately contact the sender by e-mail or phone =
regarding instructions for return or destruction and do not use or =
disclose the content to others.

--------------060303050903020908020007
Content-Type: text/plain;
	name="kswapd.lockup"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="kswapd.lockup"


top - 11:15:00 up 40 min,  2 users,  load average: 25.51, 19.62, 12.66
Tasks: 147 total,  19 running, 128 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 75.0%sy,  0.0%ni,  0.0%id, 25.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:  16471592k total, 16415040k used,    56552k free,      692k buffers
Swap: 33551712k total,      152k used, 33551560k free, 13462880k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                           
  335 root      15  -5     0    0    0 R  100  0.0   9:56.63 kswapd0                                                                                            
 4811 root      20   0 22280 1372 1044 S  100  0.0   5:46.05 ShiftGen                                                                                           
 4816 root      20   0 22280 1376 1044 S  100  0.0   5:47.71 ShiftGen                                                                                           
 4080 root      20   0  110m 1220  760 S    0  0.0   0:00.46 exegyd                                                                                             
 4826 root      20   0 12716 1092  796 R    0  0.0   0:00.20 top                                                                                                
    1 root      20   0 10316  668  556 R    0  0.0   0:00.60 init                                                                                               
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd                                                                                           
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/0                                                                                        
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 ksoftirqd/0                                                                                        
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/0                                                                                         
    6 root      RT  -5     0    0    0 R    0  0.0   0:00.00 migration/1                                                                                        
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 ksoftirqd/1                                                                                        
    8 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/1                                                                                         
    9 root      RT  -5     0    0    0 R    0  0.0   0:00.00 migration/2                                                                                        
   
root@gluebait.eng.exegy.net local/exegy/init> ps -flea
F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 R root         1     0  0  80   0 -  2579 -      10:34 ?        00:00:00 init [3]                   
1 S root         2     0  0  75  -5 -     0 kthrea 10:34 ?        00:00:00 [kthreadd]
1 S root         3     2  0 -40   - -     0 migrat 10:34 ?        00:00:00 [migration/0]
1 S root         4     2  0  75  -5 -     0 ksofti 10:34 ?        00:00:00 [ksoftirqd/0]
5 S root         5     2  0 -40   - -     0 watchd 10:34 ?        00:00:00 [watchdog/0]
1 R root         6     2  0 -40   - -     0 -      10:34 ?        00:00:00 [migration/1]
1 S root         7     2  0  75  -5 -     0 ksofti 10:34 ?        00:00:00 [ksoftirqd/1]
5 S root         8     2  0 -40   - -     0 watchd 10:34 ?        00:00:00 [watchdog/1]
1 R root         9     2  0 -40   - -     0 -      10:34 ?        00:00:00 [migration/2]
1 S root        10     2  0  75  -5 -     0 ksofti 10:34 ?        00:00:00 [ksoftirqd/2]
5 S root        11     2  0 -40   - -     0 watchd 10:34 ?        00:00:00 [watchdog/2]
1 S root        12     2  0 -40   - -     0 migrat 10:34 ?        00:00:00 [migration/3]
1 S root        13     2  0  75  -5 -     0 ksofti 10:34 ?        00:00:00 [ksoftirqd/3]
5 S root        14     2  0 -40   - -     0 watchd 10:34 ?        00:00:00 [watchdog/3]
1 R root        15     2  0  75  -5 -     0 -      10:34 ?        00:00:00 [events/0]
1 R root        16     2  0  75  -5 -     0 -      10:34 ?        00:00:00 [events/1]
1 R root        17     2  0  75  -5 -     0 -      10:34 ?        00:00:00 [events/2]
1 S root        18     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [events/3]
1 S root        19     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [khelper]
1 S root        72     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kblockd/0]
1 R root        73     2  0  75  -5 -     0 -      10:34 ?        00:00:01 [kblockd/1]
1 S root        74     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kblockd/2]
1 S root        75     2  0  75  -5 -     0 worker 10:34 ?        00:00:02 [kblockd/3]
1 S root        78     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kacpid]
1 S root        79     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kacpi_notify]
1 S root       245     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [cqueue/0]
1 S root       246     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [cqueue/1]
1 S root       247     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [cqueue/2]
1 S root       248     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [cqueue/3]
1 S root       250     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ksuspend_usbd]
1 S root       256     2  0  75  -5 -     0 hub_th 10:34 ?        00:00:00 [khubd]
1 S root       259     2  0  75  -5 -     0 serio_ 10:34 ?        00:00:00 [kseriod]
1 R root       335     2 25  75  -5 -     0 -      10:34 ?        00:10:13 [kswapd0]
1 S root       336     2  9  75  -5 -     0 kswapd 10:34 ?        00:03:48 [kswapd1]
1 S root       337     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [aio/0]
1 S root       338     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [aio/1]
1 S root       339     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [aio/2]
1 S root       340     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [aio/3]
1 S root       341     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [xfslogd/0]
1 S root       342     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [xfslogd/1]
1 S root       343     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [xfslogd/2]
1 S root       344     2  0  75  -5 -     0 worker 10:34 ?        00:00:10 [xfslogd/3]
1 S root       345     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [xfsdatad/0]

1 R root       346     2  2  75  -5 -     0 -      10:34 ?        00:00:55 [xfsdatad/1]
1 S root       347     2  0  75  -5 -     0 worker 10:34 ?        00:00:01 [xfsdatad/2]
1 S root       348     2 22  75  -5 -     0 worker 10:34 ?        00:09:05 [xfsdatad/3]
1 S root       349     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [xfs_mru_cache]
1 S root       505     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kpsmoused]
1 S root       554     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ata/0]
1 S root       555     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ata/1]
1 S root       556     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ata/2]
1 S root       557     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ata/3]
1 S root       558     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [ata_aux]
1 S root       564     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_0]
1 S root       565     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_1]
1 S root       566     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_2]
1 S root       567     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_3]
1 S root       568     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_4]
1 S root       569     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_5]
1 S root       575     2  0  75  -5 -     0 scsi_e 10:34 ?        00:00:00 [scsi_eh_6]
1 S root       576     2  0  75  -5 -     0 kjourn 10:34 ?        00:00:00 [kjournald]
1 S root       603     2  0  75  -5 -     0 kaudit 10:34 ?        00:00:00 [kauditd]
5 S root       637     1  0  76  -4 -  3234 -      10:34 ?        00:00:00 /sbin/udevd -d
1 S root      2314     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kmpathd/0]
1 S root      2315     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kmpathd/1]
1 S root      2316     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kmpathd/2]
1 S root      2317     2  0  75  -5 -     0 worker 10:34 ?        00:00:00 [kmpathd/3]
1 S root      2347     2  0  75  -5 -     0 kjourn 10:35 ?        00:00:00 [kjournald]
1 S root      2348     2  0  75  -5 -     0 kjourn 10:35 ?        00:00:00 [kjournald]
1 S root      2349     2  0  75  -5 -     0 kjourn 10:35 ?        00:00:00 [kjournald]
5 R root      2753     1  0  77  -3 -  3548 stext  10:35 ?        00:00:00 auditd
0 S root      2755  2753  0  77  -3 - 29041 -      10:35 ?        00:00:00 python /sbin/audispd
1 R root      2774     1  0  80   0 -  1469 -      10:35 ?        00:00:00 syslogd -m 0
5 S root      2777     1  0  80   0 -   943 syslog 10:35 ?        00:00:00 klogd -x
5 S rpc       2830     1  0  80   0 -  2004 429496 10:35 ?        00:00:00 portmap
5 S root      2869     1  0  80   0 -  2528 -      10:35 ?        00:00:00 rpc.statd
1 R root      2909     2  0  75  -5 -     0 -      10:35 ?        00:00:00 [rpciod/0]
1 S root      2910     2  0  75  -5 -     0 worker 10:35 ?        00:00:00 [rpciod/1]
5 R root      2911     2  0  75  -5 -     0 -      10:35 ?        00:00:00 [rpciod/2]
5 S root      2912     2  0  75  -5 -     0 worker 10:35 ?        00:00:00 [rpciod/3]
1 R root      2919     1  0  80   0 - 10504 -      10:35 ?        00:00:00 rpc.idmapd
5 S dbus      2948     1  0  80   0 -  6365 -      10:35 ?        00:00:00 dbus-daemon --system
1 S root      2991     2  0  80   0 -     0 -      10:35 ?        00:00:00 [lockd]
1 S root      3041     1  0  80   0 -  2121 929750 10:35 ?        00:00:00 /usr/bin/hidd --server
5 S root      3066     1  0  80   0 - 19681 274877 10:35 ?        00:00:00 ypbind
5 S root      3097     1  0  80   0 - 23860 stext  10:35 ?        00:00:00 automount
1 S root      3121     1  0  80   0 -   943 -      10:35 ?        00:00:00 /usr/sbin/acpid
1 S root      3137     1  0  80   0 -  6294 -      10:35 ?        00:00:00 ./hpiod
1 R root      3142     1  0  80   0 - 36857 -      10:35 ?        00:00:00 python ./hpssd.py
5 S root      3159     1  0  80   0 - 31500 -      10:35 ?        00:00:00 cupsd
5 S root      3185     1  0  80   0 - 11074 -      10:35 ?        00:00:00 /usr/sbin/sshd
5 S ntp       3208     1  0  80   0 -  3936 -      10:35 ?        00:00:00 ntpd -u ntp:ntp -p /var/run/ntpd.pid
1 S root      3248     1  0  80   0 - 16621 343793 10:35 ?        00:00:00 rpc.rquotad

1 S root      3271     2  0  75  -5 -     0 worker 10:35 ?        00:00:00 [nfsd4]
1 S root      3272     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3273     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3274     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3275     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3276     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3277     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3278     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3279     2  0  80   0 -     0 -      10:35 ?        00:00:00 [nfsd]
1 S root      3282     1  0  80   0 -  2541 -      10:35 ?        00:00:00 rpc.mountd
5 S root      3324     1  0  80   0 -  1606 -      10:35 ?        00:00:00 gpm -m /dev/input/mice -t exps2
1 S root      3340     1  0  80   0 - 18478 -      10:35 ?        00:00:00 crond
5 S xfs       3376     1  0  80   0 -  6282 -      10:35 ?        00:00:00 xfs -droppriv -daemon
5 R root      3473     1  0  80   0 -  4670 -      10:35 ?        00:00:00 /usr/sbin/atd
5 S root      3489     1  0  80   0 - 56791 -      10:35 ?        00:00:01 /usr/bin/python /usr/sbin/yum-updatesd
5 S 68        3505     1  0  80   0 -  7868 -      10:35 ?        00:00:01 hald
0 S root      3506  3505  0  80   0 -  5408 -      10:35 ?        00:00:00 hald-runner
4 S 68        3512  3506  0  80   0 -  3069 -      10:35 ?        00:00:00 hald-addon-acpi: listening on acpid socket /var/run/acpid.socket
4 S 68        3520  3506  0  80   0 -  3069 evdev_ 10:35 ?        00:00:00 hald-addon-keyboard: listening on /dev/input/event0
0 S root      3529  3506  0  80   0 -  2545 -      10:35 ?        00:00:00 hald-addon-storage: polling /dev/hda
1 S root      3580     1  0  80   0 -  9634 stext  10:35 ?        00:00:00 /usr/bin/hptsvr
5 S root      3615     1  0  80   0 -  1024 -      10:35 ?        00:00:00 /usr/sbin/smartd -q never
4 S root      3619     1  0  80   0 - 17886 wait   10:35 ?        00:00:00 login -- root     
4 S root      3620     1  0  80   0 -   940 -      10:35 tty2     00:00:00 /sbin/mingetty tty2
4 S root      3621     1  0  80   0 -   940 -      10:35 tty3     00:00:00 /sbin/mingetty tty3
4 S root      3622     1  0  80   0 -   940 -      10:35 tty4     00:00:00 /sbin/mingetty tty4
4 S root      3624     1  0  80   0 -   940 -      10:35 tty5     00:00:00 /sbin/mingetty tty5
4 S root      3625     1  0  80   0 -   940 -      10:35 tty6     00:00:00 /sbin/mingetty tty6
4 S root      3678  3619  0  80   0 - 17013 -      10:35 tty1     00:00:00 -tcsh
1 S root      4080     1  0  80   0 - 28285 futex_ 10:38 ?        00:00:00 /usr/local/exegy/bin/exegyd
0 S root      4111  3678  0  80   0 - 20406 wait   10:40 tty1     00:00:00 /usr/bin/perl ./MagicNumbers.pl --nomkfs --devices 4 --satatype rr2340x500s --raiddev
1 S root      4152     2  0  75  -5 -     0 -      10:40 ?        00:00:02 [xfsbufd]
1 R root      4153     2  0  75  -5 -     0 -      10:40 ?        00:00:00 [xfssyncd]
1 S root      4156     2  0  75  -5 -     0 -      10:40 ?        00:00:02 [xfsbufd]
1 S root      4157     2  0  75  -5 -     0 -      10:40 ?        00:00:00 [xfssyncd]
1 S root      4160     2  0  75  -5 -     0 -      10:40 ?        00:00:03 [xfsbufd]
1 R root      4161     2  0  75  -5 -     0 -      10:40 ?        00:00:00 [xfssyncd]
1 S root      4164     2  0  75  -5 -     0 -      10:40 ?        00:00:03 [xfsbufd]
1 S root      4165     2  0  75  -5 -     0 -      10:40 ?        00:00:00 [xfssyncd]
4 S root      4416  3185  0  80   0 - 20071 -      10:52 ?        00:00:00 sshd: root@pts/0 
4 S root      4418  4416  0  80   0 - 18611 rt_sig 10:52 pts/0    00:00:00 -tcsh
1 S root      4803     2  2  80   0 -     0 pdflus 11:08 ?        00:00:09 [pdflush]
1 D root      4805     2  1  80   0 -     0 conges 11:08 ?        00:00:06 [pdflush]
1 S root      4809  4111  0  80   0 - 20406 wait   11:09 tty1     00:00:00 /usr/bin/perl ./MagicNumbers.pl --nomkfs --devices 4 --satatype rr2340x500s --raiddev
1 S root      4810  4111  0  80   0 - 20406 wait   11:09 tty1     00:00:00 /usr/bin/perl ./MagicNumbers.pl --nomkfs --devices 4 --satatype rr2340x500s --raiddev
0 S root      4811  4809 97  80   0 -  5570 futex_ 11:09 tty1     00:06:02 /usr/local/exegy/bin/ShiftGen -blockkb 128 -generate 8 -sync -file /s0/GigaData.38 -l
0 S root      4812  4810  2  80   0 -  5570 futex_ 11:09 tty1     00:00:09 /usr/local/exegy/bin/ShiftGen -blockkb 128 -generate 8 -sync -file /s1/GigaData.38 -l
1 S root      4813  4111  0  80   0 - 20406 wait   11:09 tty1     00:00:00 /usr/bin/perl ./MagicNumbers.pl --nomkfs --devices 4 --satatype rr2340x500s --raiddev

0 S root      4816  4815 97  80   0 -  5570 futex_ 11:09 tty1     00:06:04 /usr/local/exegy/bin/ShiftGen -blockkb 128 -generate 8 -sync -file /s3/GigaData.38 -l
1 D root      4822     2  0  80   0 -     0 conges 11:09 ?        00:00:00 [pdflush]
5 D root      4823  3340  0  80   0 - 29620 synchr 11:10 ?        00:00:00 crond
0 R root      4827  4418  0  80   0 - 16179 -      11:15 pts/0    00:00:00 ps -flea

cat /proc/meminfo
MemTotal:     16471592 kB
MemFree:       2201120 kB
Buffers:           944 kB
Cached:       13463208 kB
SwapCached:          0 kB
Active:          54416 kB
Inactive:     13451452 kB
SwapTotal:    33551712 kB
SwapFree:     33551560 kB
Dirty:          822408 kB
Writeback:      102280 kB
AnonPages:       41324 kB
Mapped:          12228 kB
Slab:           478412 kB
SReclaimable:   413192 kB
SUnreclaim:      65220 kB
PageTables:       4604 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  41787508 kB
Committed_AS:   174504 kB
VmallocTotal: 34359738367 kB
VmallocUsed:    114264 kB
VmallocChunk: 34359598407 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB


--------------060303050903020908020007--

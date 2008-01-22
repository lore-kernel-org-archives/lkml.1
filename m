Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYAVQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYAVQAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYAVQAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:00:23 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:53307 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753059AbYAVQAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:00:22 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Date: Tue, 22 Jan 2008 18:00:12 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200801220119.42312.caglar@pardus.org.tr> <20080122152333.GB19590@elte.hu> <20080122153741.GA25547@elte.hu>
In-Reply-To: <20080122153741.GA25547@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801221800.13099.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

22 Oca 2008 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> 
> also, this might reduce the number of cross-CPU wakeups on near-idle 
> systems:
> 
>   echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> 
> [ or if it doesnt, it should ;) ]
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Seems like nothing changes 


zangetsu ~ # cat /sys/devices/system/cpu/sched_mc_power_savings
1



Powertop still reports ~300 wakeups for "<kernel IPI> : Rescheduling interrupts"

     PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 4,8%)
C1                0,0ms ( 0,0%)
C2                0,2ms ( 2,4%)
C3                2,4ms (92,8%)


Wakeups-from-idle per second : 495,2    interval: 3,0s
no ACPI power usage estimate available

Top causes for wakeups:
  40,0% (330,7)      <kernel IPI> : Rescheduling interrupts
  12,3% (102,0)   USB device  3-2 : HP Integrated Module (Broadcom Corp)
  12,1% (100,0)       <interrupt> : uhci_hcd:usb3
   8,0% ( 66,3)       <interrupt> : extra timer interrupt
   7,0% ( 58,0)         amarokapp : schedule_timeout (process_timeout)
   4,0% ( 33,0)       <interrupt> : uhci_hcd:usb2



and this is what system is doing while powertop reports above;

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.1  0.0   1512   532 ?        Ss   17:41   0:00 init [3]  
root         2  0.0  0.0      0     0 ?        S<   17:41   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   17:41   0:00 [migration/0]
root         4  0.0  0.0      0     0 ?        S<   17:41   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   17:41   0:00 [migration/1]
root         6  0.0  0.0      0     0 ?        S<   17:41   0:00 [ksoftirqd/1]
root         7  0.0  0.0      0     0 ?        S<   17:41   0:00 [events/0]
root         8  0.0  0.0      0     0 ?        S<   17:41   0:00 [events/1]
root         9  0.0  0.0      0     0 ?        S<   17:41   0:00 [khelper]
root        10  0.0  0.0      0     0 ?        S<   17:41   0:00 [kblockd/0]
root        11  0.0  0.0      0     0 ?        S<   17:41   0:00 [kblockd/1]
root        12  0.0  0.0      0     0 ?        S<   17:41   0:00 [kacpid]
root        13  0.0  0.0      0     0 ?        S<   17:41   0:00 [kacpi_notify]
root        14  0.0  0.0      0     0 ?        S<   17:41   0:00 [cqueue/0]
root        15  0.0  0.0      0     0 ?        S<   17:41   0:00 [cqueue/1]
root        16  0.0  0.0      0     0 ?        S<   17:41   0:00 [kseriod]
root        17  0.0  0.0      0     0 ?        S    17:41   0:00 [pdflush]
root        18  0.0  0.0      0     0 ?        S    17:41   0:00 [pdflush]
root        19  0.0  0.0      0     0 ?        S<   17:41   0:00 [kswapd0]
root        20  0.0  0.0      0     0 ?        S<   17:41   0:00 [aio/0]
root        21  0.0  0.0      0     0 ?        S<   17:41   0:00 [aio/1]
root        22  0.0  0.0      0     0 ?        S<   17:41   0:00 [kpsmoused]
root        42  0.0  0.0      0     0 ?        S<   17:41   0:00 [khpsbpkt]
root        46  0.0  0.0      0     0 ?        S<   17:41   0:00 [knodemgrd_0]
root        55  0.0  0.0      0     0 ?        S<   17:41   0:00 [ata/0]
root        56  0.0  0.0      0     0 ?        S<   17:41   0:00 [ata/1]
root        57  0.0  0.0      0     0 ?        S<   17:41   0:00 [ata_aux]
root        61  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_0]
root        62  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_1]
root        63  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_2]
root        64  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_3]
root        70  0.0  0.0      0     0 ?        S<   17:41   0:00 [ksuspend_usbd]
root        71  0.0  0.0      0     0 ?        S<   17:41   0:00 [khubd]
root        80  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_4]
root        81  0.0  0.0      0     0 ?        S<   17:41   0:00 [scsi_eh_5]
root       159  0.0  0.0      0     0 ?        S<   17:41   0:00 [kjournald]
root       194  0.0  0.0   2452  1304 ?        S<s  17:41   0:00 /sbin/udevd --daemon
root      1212  0.0  0.0      0     0 ?        S<   17:41   0:00 [kmmcd]
root      1378  0.0  0.0      0     0 ?        S<   17:41   0:00 [iwl3945/0]
root      1379  0.0  0.0      0     0 ?        S<   17:41   0:00 [iwl3945/1]
root      1408  0.0  0.0      0     0 ?        S<   17:41   0:00 [iwl3945]
root      1522  0.0  0.0   2320   348 ?        Ss   17:41   0:00 /usr/sbin/irqbalance
root      1554  0.0  0.0   3904  1200 ?        Ss   17:41   0:00 Comar         
root      1681  0.0  0.0   3904   720 ?        S    17:41   0:00 ComarRPC      
root      1693  0.0  0.0   1556   608 ?        Ss   17:41   0:00 /usr/sbin/syslogd -m 15
root      1696  0.0  0.0   1512   412 ?        Ss   17:41   0:00 /usr/sbin/klogd -c 3 -2
root      1697  0.0  0.0   2168   948 ?        Ss   17:41   0:00 /usr/sbin/hcid -s -f /etc/bluetooth/hcid.conf
root      1708  0.0  0.0      0     0 ?        S<   17:41   0:00 [krfcommd]
root      1726  0.0  0.0   2008   712 tty3     Ss+  17:41   0:00 /sbin/mingetty tty3
root      1727  0.0  0.0   2008   708 tty4     Ss+  17:41   0:00 /sbin/mingetty tty4
root      1728  0.0  0.0   2008   708 tty5     Ss+  17:41   0:00 /sbin/mingetty tty5
root      1729  0.0  0.0   2008   708 tty6     Ss+  17:41   0:00 /sbin/mingetty tty6
root      1730  0.0  0.0   1508   512 ?        Ss   17:41   0:00 /usr/sbin/acpid -c /etc/acpi/events
dbus      1797  0.0  0.0   2360  1000 ?        Ss   17:41   0:00 /usr/bin/dbus-daemon --system
root      1846  0.0  0.1   8384  2196 ?        Ssl  17:41   0:00 /usr/sbin/console-kit-daemon
hal       1939  0.0  0.1   5572  3948 ?        Ss   17:42   0:00 /usr/sbin/hald --daemon=yes --use-syslog
root      1943  0.0  0.0   2980  1080 ?        S    17:42   0:00 hald-runner
root      1950  0.5  1.7 214512 36420 ?        Ssl  17:42   0:04 /opt/sun-jdk/bin/java -DConfigFile=/opt/zemberek-server/config/conf.ini -Djava.library.path=/opt/zemberek-server/lib -Xverify:none -Xms12m -Xmx14m -jar /opt/zemberek-server/zemberek_server-0.7.jar
root      1951  0.0  0.0   1780   692 ?        Ss   17:42   0:00 /usr/sbin/cron
root      1952  0.0  0.0  10060   648 ?        S<sl 17:42   0:00 /sbin/auditd
root      1954  0.0  0.0   9828   648 ?        S<sl 17:42   0:00 /sbin/audispd
root      1955  0.0  0.0      0     0 ?        S<   17:42   0:00 [kauditd]
root      1962  0.0  0.1   5812  2088 ?        Ss   17:42   0:00 /usr/sbin/cupsd
avahi     1964  0.0  0.0   2656  1492 ?        Ss   17:42   0:00 avahi-daemon: running [zangetsu.local]
avahi     1967  0.0  0.0   2516   456 ?        Ss   17:42   0:00 avahi-daemon: chroot helper
root      2007  0.0  0.0   3072  1108 ?        S    17:42   0:00 hald-addon-input: Listening on /dev/input/event8 /dev/input/event9 /dev/input/event0 /dev/input/event4 /dev/input/event5 /dev/input/event6 /dev/input/event7
hal       2039  0.0  0.0   2032   888 ?        S    17:42   0:00 hald-addon-acpi: listening on acpid socket /var/run/acpid.socket
root      2044  0.0  0.0   3076  1024 ?        S    17:42   0:00 hald-addon-storage: polling /dev/sr0 (every 2 sec)
root      2057  0.0  0.0   1640   468 ?        Ss   17:42   0:00 /usr/sbin/avahi-dnsconfd -D
root      2071  0.0  0.0   3952   776 ?        Ss   17:42   0:00 /usr/kde/3.5/bin/kdm
root      2073  3.5  1.2  30852 26084 tty7     RLs+ 17:42   0:30 /usr/bin/X -br -nolisten tcp :0 vt7 -auth /var/run/xauth/A:0-E3nV3y
root      2077  0.0  0.0   4668  1976 ?        S    17:42   0:00 -:0                 
root      2080  0.0  0.0   3296  1360 ?        Ss   17:42   0:00 /usr/sbin/wpa_supplicant -wuB -P/var/run/wpa_supplicant.pid
root      2109  0.0  0.0   1652   248 ?        Ss   17:42   0:00 /sbin/dhcpcd -R -Y -N eth1 -t 120
root      2694  0.0  0.0   2008   708 tty2     Ss+  17:43   0:00 /sbin/mingetty --noclear tty2
root      2758  0.0  0.0   2008   708 tty1     Ss+  17:43   0:00 /sbin/mingetty --noclear tty1
caglar    2783  0.0  0.0   3016  1348 ?        Ss   17:43   0:00 /bin/sh /usr/kde/3.5/bin/startkde
caglar    2812  0.0  0.0   2664   468 ?        Ss   17:44   0:00 /usr/bin/gpg-agent --daemon
caglar    2815  0.0  0.0   3056   764 ?        Ss   17:44   0:00 /usr/bin/ssh-agent -s
caglar    2832  0.0  0.0   2984   432 ?        S    17:44   0:00 dbus-launch --sh-syntax --exit-with-session
caglar    2833  0.0  0.0   2228   864 ?        Ss   17:44   0:00 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
root      2839  0.0  0.0   1360   148 ?        S    17:44   0:00 start_kdeinit --new-startup +kcminit_startup
caglar    2840  0.0  0.3  25008  7800 ?        Ss   17:44   0:00 kdeinit Running...                                                  
caglar    2843  0.0  0.1  24276  2788 ?        S    17:44   0:00 dcopserver [kdeinit] --nosid                                        
caglar    2845  0.0  0.3  26896  7720 ?        S    17:44   0:00 klauncher [kdeinit] --new-startup                                   
caglar    2847  0.0  0.7  33552 16424 ?        S    17:44   0:00 kded [kdeinit] --new-startup                                        
caglar    2852  0.0  0.0   1496   348 ?        S    17:44   0:00 kwrapper ksmserver
caglar    2854  0.0  0.4  26656  9392 ?        S    17:44   0:00 ksmserver [kdeinit]                                                 
caglar    2855  0.1  0.6  28584 12480 ?        S    17:44   0:01 kwin [kdeinit] -session 10dfd5e1dc000119905582800000074630008_1201  
caglar    2857  0.1  0.8  34436 17352 ?        S    17:44   0:01 kdesktop [kdeinit]                                                  
caglar    2859  0.1  0.8  45892 17384 ?        S    17:44   0:01 kicker [kdeinit]                                                    
caglar    2862  0.0  0.3  25560  6688 ?        S    17:44   0:00 kio_file [kdeinit] file /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    2866  0.0  0.3  13736  7856 ?        S    17:44   0:00 /usr/kde/3.5/bin/artsd -F 10 -S 4096 -s 3 -m artsmessage -c drkonqi -l 3 -f
caglar    2871  0.0  0.6  29552 12728 ?        S    17:44   0:00 kmix [kdeinit] -session 10dfd5e1dc000118109216400000036490013_1201  
caglar    2873  0.3  1.2  57188 26548 ?        S    17:44   0:02 akregator -session 10dfd5e1dc000119737236400000038700014_1201016429_751575
caglar    2876  0.0  0.5  25972 10908 ?        S    17:44   0:00 knazar -session 10dfd5e1dc000119738342100000051660022_1201016429_752054
caglar    2877  0.0  0.5  35540 11524 ?        S    17:44   0:00 knotify [kdeinit]                                                   
caglar    2879  0.0  0.7  41988 14848 ?        S    17:44   0:00 kgpg -session 10dfd5e1dc000119885454500000040010017_1201016429_751902
caglar    2881  0.4  0.7  29792 15976 ?        S    17:44   0:03 yakuake -session 10dfd5e1dc000119949009100000068430023_1201016429_752567
caglar    2882  3.5  2.7 152560 57376 ?        Sl   17:44   0:26 amarokapp -session 10dfd5e1dc000120001145300000022560015_1201016429_751762
caglar    2890  1.2  4.0 148500 83704 ?        Sl   17:44   0:09 kmail -session 10dfd5e1dc000120100924600000022060011_1201016429_752344
caglar    2894  0.0  0.5  27664 11080 ?        S    17:44   0:00 klipper [kdeinit]                                                   
caglar    2898  0.0  0.5  29504 11512 ?        S    17:44   0:00 kpowersave [kdeinit]                                                
caglar    3080  0.0  0.3  54032  7924 ?        S    17:44   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3081  0.0  0.3  53912  7916 ?        S    17:44   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3150  0.0  0.1   4136  2600 pts/2    Ss   17:44   0:00 /bin/bash
caglar    3236  0.0  0.4  16604  8576 ?        S    17:44   0:00 /usr/libexec/notification-daemon
caglar    3273  0.0  0.3  27164  7028 ?        S    17:44   0:00 kio_file [kdeinit] file /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3274  0.0  0.1   3692  2348 ?        S    17:44   0:00 ruby /usr/kde/3.5/share/apps/amarok/scripts/score_default/score_default.rb
caglar    3341  0.0  0.3  62224  8172 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3343  0.0  0.3  61208  8116 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3344  0.0  0.3  54036  8076 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3345  0.0  0.3  53012  8072 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3347  0.0  0.3  54040  8120 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3348  0.0  0.3  62232  8100 ?        S    17:46   0:00 kio_http [kdeinit] http /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
caglar    3897  0.0  0.8  56212 17004 ?        S    17:50   0:00 /usr/bin/python /usr/kde/3.5/bin/network-applet
caglar    4265  0.0  0.0   2752  1308 ?        S    17:53   0:00 /bin/sh /usr/bin/firefox
caglar    4267  1.1  1.6 131892 33644 ?        Sl   17:53   0:01 /usr/lib/MozillaFirefox//firefox-bin
caglar    4271  0.0  0.1   4148  2392 ?        S    17:53   0:00 /usr/libexec/gconfd-2 14
caglar    4300  0.0  0.4  54932  9120 ?        S    17:54   0:00 kio_pop3 [kdeinit] pop3 /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
root      4316  0.0  0.0   2524  1200 pts/2    S    17:55   0:00 su -
root      4318  0.2  0.1   4788  3476 pts/2    S    17:55   0:00 -su
root      4342  0.1  0.1   3200  2116 pts/2    S+   17:55   0:00 powertop
caglar    4345  0.1  0.1   4004  2540 pts/0    Ss   17:55   0:00 /bin/bash
root      4451  0.0  0.0   2524  1200 pts/0    S    17:55   0:00 su -
root      4453  0.3  0.1   4788  3448 pts/0    S    17:55   0:00 -su
caglar    4543  0.2  0.4  54064  9416 ?        S    17:55   0:00 kio_smtp [kdeinit] smtp /tmp/ksocket-caglar/klauncherTCaD9a.slave-  
root      4588  0.0  0.0   2272   964 pts/0    R+   17:56   0:00 ps aux

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!

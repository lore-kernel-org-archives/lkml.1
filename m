Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYANKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYANKVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYANKVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:21:39 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:42809 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYANKVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:21:37 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: native_flush_tlb_others very nasty crash
Date: Mon, 14 Jan 2008 12:21:21 +0200
Message-Id: <20080114092621.M12623@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am having serious issue with one of servers.

It is very difficult to reproduce bug, and also difficult to catch screen, 
cause server installed in rack in another country, and local staff had under 
hands only phone camera, and new messages was appearing non-stop on screen, 
so i had some hell time to decode all this.

This bug appearing after 2-3 days since 2.6.20 (at this kernel version server 
was just installed), and i am not able to reproduce it. Just not i was able 
to catch messages on screen and debug was enabled. Very strange thing, but 
none of watchdogs able to catch this bug.
I was running
/bin/busybox watchdog -t 10 /dev/watchdog with iTCO_wdt module
dmesg shows that it must work
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)

and some custom perl script to ping remote host and issue reboot command in 
case of ping failed.

Probably there is some mistake at numbers, very bad resolution:
c can be e, i mark this places as "?", 
and probably some 0 can be 8 i will mark difficult to read places as "#"


What i am able to read from screen:
EIP: 0060:[<c010edb8>] EFLAGS: 00200202 CPU:2
EIP is at native_flush_tlb_others+0x69/0x95
EAX: ffffb300 EBX: f657cb40 ECX: c040?bc0 EDX: 000###fd
ESI: ffffffff EDI: f73f6898 EBP: f77a3f30
DS: 007b ES: 007b FS:00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: b766?000 CR3: 1d661000 CR4: 000006d0
DR0: 00000000 DR2: 00000000 DR3: 00000000 DR4: 00000000
DR6: ffff0ff0 DR7: 00000400

[<c0105e68>] show_trace_log_lvl+0x1a/0x2f
[<c0106810>] show_trace+0x12/0x14
[<c010341f>] show_regs+0x1c/0x1f
[<c0141883>] softlockup_tick+0x103/0x11c
[<c012448a>] run_local_timers+0x12/0x14
[<c0124833>] update_process_times+0x24/0x49
[<c013563d>] tick_sched_timer+0x7e/0xc2
[<c01305cf>] hrtimer_interrupt+0x10d/0x197
[<c010feff>] smp_apic_timer_interrupt+0x72/0x84
[<c010594b>] apic_timer_interrupt+0x33/0x38
[<c010f389>] flush_tlb_mm+0x55/0x59
[<c0152623>] unmap_region+0xdd/0x101
[<c0152fcd>] do_munmap+0x153/0x1b4
[<c015305?>] sys_munmap+0x30/0x3f

There is looks like another backtrace, but it is even more difficult to 
decode it.
Photos of screen links
http://www.nuclearcat.com/files/panic2/DSC00096.JPG
http://www.nuclearcat.com/files/panic2/DSC00097.JPG
http://www.nuclearcat.com/files/panic2/DSC00098.JPG
http://www.nuclearcat.com/files/panic2/DSC00099.JPG
http://www.nuclearcat.com/files/panic2/DSC00100.JPG
http://www.nuclearcat.com/files/panic2/DSC00102.JPG
http://www.nuclearcat.com/files/panic2/DSC00103.JPG
http://www.nuclearcat.com/files/panic2/DSC00104.JPG


Hardware is Dell PowerEdge 1950


lspci
00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller Hub 
(rev 12)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 
2 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 
3 (rev 12)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 
4 (rev 12)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 
5 (rev 12)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 
6-7 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 
7 (rev 12)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 
12)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 
12)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev 
12)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers 
(rev 12)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers 
(rev 12)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 
12)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 
12)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI 
USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI 
USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI 
USB Controller #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI 
USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 
09)
01:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge A 
(rev 09)
02:08.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X 
Fusion-MPT SAS (rev 01)
03:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2)
04:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 11)
05:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream 
Port (rev 01)
05:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X 
Bridge (rev 01)
06:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream 
Port E1 (rev 01)
06:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream 
Port E2 (rev 01)
07:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev c2)
08:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 
Gigabit Ethernet (rev 11)
0b:00.0 PCI bridge: Intel Corporation 6702PXH PCI Express-to-PCI Bridge A 
(rev 09)
10:0d.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

visp-1 ~ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.259
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6390.26
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.259
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.68
clflush size    : 64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.259
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.75
clflush size    : 64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 4
cpu MHz         : 3192.259
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx cid cx16 xtpr lahf_lm
bogomips        : 6383.77
clflush size    : 64

Two FB-DIMM 512MB
        Manufacturer: 0198808980C1
        Serial Number: 982D0D6A
        Asset Tag: 000621
        Part Number: KD7538-IFA-INTC0S
another
        Manufacturer: 0198808980C1
        Serial Number: 9C2EA25B
        Asset Tag: 000621
        Part Number: KD7538-IFA-INTC0S


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.


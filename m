Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbXHASqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbXHASqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761459AbXHASp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:45:56 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:44853 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933429AbXHASpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:45:53 -0400
Message-ID: <46B0D4B4.2040809@web.de>
Date: Wed, 01 Aug 2007 20:45:08 +0200
From: =?ISO-8859-15?Q?Philipp_T=F6lke?= <philipptoelke@web.de>
User-Agent: Thunderbird 2.0.0.5 (X11/20070724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Oops when using dm-crypt with dpt_i2o
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18AKo6+SNKvTTcnkf19D8Rpx73AXZzh/6/WrW5w
	FciH4oLweY+dimwgbSxthH+MXCmGV2+MZqca5Kph0klv+omSGK
	inBAadM83AJgXkPrAq2g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

if I mount a dm-crypt-encrypted Harddisk/RAID-Array on an Adaptec 3200S,
and produce load (for example with bonnie++) the kernel crashes.

This is always reproducible. To reproduce simply mount an dm-crypt
encrypted device and produce load -- I always used bonnie++.

Unencrypted volumes work fine. Every kind of load I threw at the System
worked fine.

I would be very glad, if some kind of solution for this can be found.

Thanks!

The oopses:

#v+
BUG: unable to handle kernel paging request at virtual address 14001000
printing eip:
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: dm_crypt dm_mod capability commoncap ipv6 pcspkr
ppdev lp parport_pc parport rtc_cmos ppp_generic rtc_core rtc_lib
i2c_viapro i2o_core i2c_core via_ircc irda crc_ccitt sg shpchp
pci_hotplug evdev thermal processor fan button battery ac slhc r8169
usbcore jfs sr_mod cdrom sd_mod sym53c8xx dpt_i2o ata_generic pata_via
libata
CPU:    0
EIP:    0060:[<14001000>]    Not tainted VLI
EFLAGS: 00010082   (2.6.22.1 #2)
EIP is at 0x14001000
eax: 00000000   ebx: 14001000   ecx: 00000000   edx: 0002bc00
esi: 5b51c000   edi: 14001000   ebp: 5b51b000   esp: dfe21f08
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process kblockd/0 (pid: 31, ti=dfe20000 task=c1cfca50 task.ti=dfe20000)

Stack: 5b51a000 14001000 5b519000 14001000 5b518000 d4001000 5b517000
00000086
c1d0b534 c1d0b424 c1d0b490 c1da7834 c1da7834 c1da7834 00000000 07000000
c022aac5 c1da78b8 c022b696 c022c762 00000046 c1d0b534 c1d0b424 c1d0b490

Call Trace:
[<c022aac5>] __generic_unplug_device+0x25/0x30
[<c022b696>] generic_unplug_device+0x6/0x10
[<c022c762>] blk_unplug_work+0x42/0xa0
[<c022c720>] blk_unplug_work+0x0/0xa0
[<c012a307>] run_workqueue+0x97/0x110
[<c012aa00>] worker_thread+0x0/0xe0
[<c012aa7d>] worker_thread+0x7d/0xe0
[<c012d5e0>] autoremove_wake_function+0x0/0x40
[<c012aa00>] worker_thread+0x0/0xe0
[<c012d292>] kthread+0x42/0x70
[<c012d250>] kthread+0x0/0x70
[<c01041df>] kernel_thread_helper+0x7/0x18
=======================
Code:  Bad EIP value.
EIP: [<14001000>] 0x14001000 SS:ESP 0068:dfe21f08


BUG: unable to handle kernel paging request at virtual address 14001000
printing eip:
14001000
*pde = 00000000
Oops: 0000 [#2]
Modules linked in: dm_crypt dm_mod capability commoncap ipv6 pcspkr
ppdev lp parport_pc parport rtc_cmos ppp_generic rtc_core rtc_lib
i2c_viapro i2o_core i2c_core via_ircc irda crc_ccitt sg shpchp
pci_hotplug evdev thermal processor fan button battery ac slhc r8169
usbcore jfs sr_mod cdrom sd_mod sym53c8xx dpt_i2o ata_generic pata_via
libata
CPU:    0
EIP:    0060:[<14001000>]    Not tainted VLI
EFLAGS: 00010086   (2.6.22.1 #2)
EIP is at 0x14001000
eax: 00000000   ebx: 14001000   ecx: 00000000   edx: 0002ba00
esi: 5b4dc000   edi: 14001000   ebp: 5b4db000   esp: dfe21ca4
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process kblockd/0 (pid: 31, ti=dfe20000 task=c1cfca50 task.ti=dfe20000)

Stack: 5b4da000 14001000 5b4d9000 14001000 5b4d8000 d4001000 5b4d7000
dfe21cd8
c1d0b534 c1d0b424 c1d0b490 c1da7834 c1da7834 00000296 c1d0b490 00000286
c022b823 c1da43c0 c1da7834 c0299030 f7e5c070 00000000 00000001 c02991f4

Call Trace:
[<c022b823>] blk_run_queue+0x33/0x70
[<c0299030>] scsi_next_command+0x30/0x50
[<c02991f4>] scsi_end_request+0x94/0xc0
[<c02992fa>] scsi_io_completion+0x8a/0x3e0
[<f884679b>] sd_rw_intr+0x2b/0x220 [sd_mod]
[<c0299b7c>] scsi_softirq_done+0x2c/0x100
[<c0295037>] scsi_finish_command+0x47/0x60
[<c022b73a>] blk_done_softirq+0x5a/0x70
[<c0121002>] __do_softirq+0x42/0x90
[<c0121077>] do_softirq+0x27/0x30
[<c012134a>] irq_exit+0x5a/0x60
[<c0105bf9>] do_IRQ+0x39/0x70
[<c01040ef>] common_interrupt+0x23/0x28
[<c011f553>] do_exit+0x73/0x740
[<c0104af7>] die+0x1e7/0x1f0
[<c0114898>] do_page_fault+0x188/0x5e0
[<c0114710>] do_page_fault+0x0/0x5e0
[<c03403aa>] error_code+0x6a/0x70
[<c022aac5>] __generic_unplug_device+0x25/0x30
[<c022b696>] generic_unplug_device+0x6/0x10
[<c022c762>] blk_unplug_work+0x42/0xa0
[<c022c720>] blk_unplug_work+0x0/0xa0
[<c012a307>] run_workqueue+0x97/0x110
[<c012aa00>] worker_thread+0x0/0xe0
[<c012aa7d>] worker_thread+0x7d/0xe0
[<c012d5e0>] autoremove_wake_function+0x0/0x40
[<c012aa00>] worker_thread+0x0/0xe0
[<c012d292>] kthread+0x42/0x70
[<c012d250>] kthread+0x0/0x70
[<c01041df>] kernel_thread_helper+0x7/0x18
=======================
Code:  Bad EIP value.
EIP: [<14001000>] 0x14001000 SS:ESP 0068:dfe21ca4
Kernel panic - not syncing: Fatal exception in interrupt
#v-


Output from ver_linux:

#v+
Linux beehive 2.6.22.1 #2 Mon Jul 30 11:52:21 CEST 2007 i686 AMD
Athlon(tm) Processor AuthenticAMD GNU/Linux

Gnu C                  4.2.1
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40.2
jfsutils               1.1.11
reiserfsprogs          3.6.20
xfsprogs               2.9.3
pcmciautils            014
Linux C Library        > libc.2.6
Dynamic linker (ldd)   2.6
Linux C++ Library      so.6.0
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   113
wireless-tools         29
Modules Loaded         capability commoncap ipv6 ppdev lp parport_pc
parport i2c_viapro i2c_core via_ircc irda crc_ccitt pcspkr rtc_cmos
ppp_generic rtc_core rtc_lib sg shpchp pci_hotplug i2o_core evdev
thermal processor fan button battery ac slhc r8169 usbcore jfs sr_mod
cdrom sd_mod sym53c8xx dpt_i2o ata_generic pata_via libata
#v-

/proc/cpuinfo:

#v+
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 6
model		: 4
model name	: AMD Athlon(tm) Processor
stepping	: 4
cpu MHz		: 1333.120
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat
pse36 mmx fxsr syscall mmxext 3dnowext 3dnow
bogomips	: 2668.03
clflush size	: 32
#v-

Thank you very much,
-- 
Philipp Tölke

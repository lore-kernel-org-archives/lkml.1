Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYL0FxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYL0FxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYL0FxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:53:14 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33959 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYL0FxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:53:13 -0500
Message-ID: <54964.166.70.238.44.1230354462.squirrel@webmail.wolfmountaingroup.com>
Date: Fri, 26 Dec 2008 22:07:42 -0700 (MST)
Subject: ndiswrapper-1.54-2.6.28 Posted
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Posted at:

ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.28.tar.gz

NOTES:

I have been working on kernel breakage in ntoskernel.c function
KeSynchronizeExecution which involves calls to local_bh_enable()
and the 2.6.28 kernel scehduler has some stability and robustness
issues.

There exists several cases where the kernel can become corrupted in
Linux 2.6.28 and the breakage affects the scheduling queue. After
extensive debugging of the problem, I have determined it is located
in the following area and appears timing dependent:

Dec 26 12:24:55 ffs kernel: ndiswrapper: device wlan0 removed
Dec 26 12:24:55 ffs kernel: ndiswrapper 0000:02:06.0: PCI INT A disabled
Dec 26 12:24:55 ffs kernel: usbcore: deregistering interface driver
ndiswrapper
Dec 26 12:24:55 ffs kernel: BUG: unable to handle kernel paging request at
30203334
Dec 26 12:24:55 ffs kernel: IP: [<c05cc109>] __linkwatch_run_queue+0x65/0x136
Dec 26 12:24:55 ffs kernel: *pde = 00000000
Dec 26 12:24:55 ffs kernel: Oops: 0000 [#1] PREEMPT SMP
Dec 26 12:24:55 ffs kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:02:06.0/irq
Dec 26 12:24:55 ffs kernel: Modules linked in: autofs4 hidp l2cap
bluetooth ndiswrapper(-) nf_conntrack_netbios_ns ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter
ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6
dm_mirror dm_region_hash dm_log dm_multipath dm_mod rfkill input_polldev
sbs sbshc parport_pc lp parport joydev ide_cd_mod cdrom snd_intel8x0
snd_seq_dummy serio_raw snd_intel8x0m snd_ac97_codec ac97_bus snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device battery snd_pcm_oss ac
snd_mixer_oss button snd_pcm 8139cp 8139too rtc_cmos mii rtc_core rtc_lib
snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_core pcspkr ata_piix
libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded:
microcode]
Dec 26 12:24:55 ffs kernel:
Dec 26 12:24:55 ffs kernel: Pid: 6, comm: events/0 Tainted: P          
(2.6.28 #2) Presario 2200 (PM043UA#ABA)
Dec 26 12:24:55 ffs kernel: EIP: 0060:[<c05cc109>] EFLAGS: 00010246 CPU: 0
Dec 26 12:24:55 ffs kernel: EIP is at __linkwatch_run_queue+0x65/0x136
Dec 26 12:24:55 ffs kernel: EAX: dd850000 EBX: 30203020 ECX: 00000282 EDX:
00bb1000
Dec 26 12:24:55 ffs kernel: ESI: 00000003 EDI: 00000000 EBP: 30203020 ESP:
dd850f90
Dec 26 12:24:55 ffs kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Dec 26 12:24:55 ffs kernel: Process events/0 (pid: 6, ti=dd850000
task=dd87c490 task.ti=dd850000)
Dec 26 12:24:55 ffs kernel: Stack:
Dec 26 12:24:55 ffs kernel:  c078bda4 dd851f40 c078bda0 c05cc1da c05cc1f7
c043284c dd851f40 c0432fa0
Dec 26 12:24:55 ffs kernel:  dd851f4c 00000000 c0433053 00000000 dd87c490
c043533c dd850fc8 dd850fc8
Dec 26 12:24:55 ffs kernel:  dd851f40 00000000 c0435279 c0435241 00000000
c04046fb dd82df4c 00000000
Dec 26 12:24:55 ffs kernel: Call Trace:
Dec 26 12:24:55 ffs kernel:  [<c05cc1da>] linkwatch_event+0x0/0x22
Dec 26 12:24:55 ffs kernel:  [<c05cc1f7>] linkwatch_event+0x1d/0x22
Dec 26 12:24:55 ffs kernel:  [<c043284c>] run_workqueue+0x6e/0xf3
Dec 26 12:24:55 ffs kernel:  [<c0432fa0>] worker_thread+0x0/0xbd
Dec 26 12:24:55 ffs kernel:  [<c0433053>] worker_thread+0xb3/0xbd
Dec 26 12:24:55 ffs kernel:  [<c043533c>] autoremove_wake_function+0x0/0x2d
Dec 26 12:24:55 ffs kernel:  [<c0435279>] kthread+0x38/0x5f
Dec 26 12:24:55 ffs kernel:  [<c0435241>] kthread+0x0/0x5f
Dec 26 12:24:55 ffs kernel:  [<c04046fb>] kernel_thread_helper+0x7/0x10
Dec 26 12:24:55 ffs kernel: Code: b8 78 99 8c c0 e8 6f 5d 06 00 b8 78 99
8c c0 8b 1d 84 99 8c c0 c7 05 84 99 8c c0 00 00 00 00 e8 95 5f 06 00 e9 b2
00 00 00 85 ff <8b> ab 14 03 00 00 74 17 89 d8 e8 60 fe ff ff 84 c0 75 0c
89 d8
Dec 26 12:24:55 ffs kernel: EIP: [<c05cc109>]
__linkwatch_run_queue+0x65/0x136 SS:ESP 0068:dd850f90
Dec 26 12:24:55 ffs kernel: ---[ end trace 322e4a35e9b8ee1c ]---

Due to the fact folks seem to be constantly altering the scheduler and
posting/pulling git changes, I have spent little time attempting to
determine the "flavor of the month" kernel breakage introduced in recent
kernels.  I have reviewed the ndiswrapper code and the defect is not
in the ndiswrapper code itself and appears to be related to recent (and it
seems constant) introduction of breakage with all the scheduler changes.

This problem only shows up when the ndiswrapper module is loaded/unloaded
several times in succession.  Normal operations (i.e. install, boot,
orderly shutdown) seem to work fine for most of the systems I have tested
it on.

This version is tested on 2.6.28 and seems to work fine under normal use
cases.

Jeffrey Vernon Merkey




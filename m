Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYJWJuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYJWJuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYJWJtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:49:55 -0400
Received: from mail.agmk.net ([91.192.224.71]:25205 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYJWJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:49:54 -0400
To: linux-kernel@vger.kernel.org
Subject: [2.6.26.6] OOPS in :jbd:journal_grab_journal_head
Date: Thu, 23 Oct 2008 11:49:47 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <GsbBXwHg.1224755387.6750170.pluto@agmk.net>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
MIME-Version: 1.0 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i have a dual-core box with 4GB of ram and ~12GB of swap.
this machine is used for gcc farm and xilinx tools and usually
eats lot of cpu/mem/swap. today i saw in dmesg an oops and
a warning. i can provide more information if you want to
debug this problem.

please CC me on reply and thanks in advance,
Pawel.

[1051788.284859] general protection fault: 0000 [1] SMP
[1051788.284859] CPU 0
[1051788.284859] Modules linked in: dummy binfmt_misc nfs lockd nfs_acl
sunrpc sch_sfq xt_TCPMSS xt_tcpudp iptable_mangle iptable_filter
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables
ip6table_filter ip6_tables x_tables raid0 uvesafb cn autofs4
pata_jmicron ata_generic pata_acpi ide_pci_generic rtc_cmos rtc_core
rtc_lib serio_raw cfi_cmdset_0002 pcspkr isp1760 cfi_util k8temp psmouse
jmicron hwmon ohci_hcd ahci jedec_probe cfi_probe forcedeth ehci_hcd
i2c_nforce2 usbcore gen_probe i2c_core ssb sg pcmcia pcmcia_core
firmware_class ck804xrom mtd chipreg map_funcs thermal button processor
evdev scsi_wait_scan sd_mod raid1 md_mod ext3 jbd mbcache sata_nv libata
scsi_mod dock amd74xx ide_core
[1051788.284859] Pid: 212, comm: kswapd0 Not tainted 2.6.26.6-0.1 #1
[1051788.284859] RIP: 0010:[<ffffffffa0072ed0>]  [<ffffffffa0072ed0>]
:jbd:journal_grab_journal_head+0x0/0x90
[1051788.284859] RSP: 0000:ffff81011e421ae8  EFLAGS: 00010282
[1051788.284859] RAX: 0000000000000000 RBX: 0307ac00ffff8100 RCX:
0100000000000809
[1051788.284859] RDX: 00000000000000d0 RSI: ffffe2000307ac00 RDI:
0307ac00ffff8100
[1051788.284859] RBP: ffffe2000307ac28 R08: 6000000000000000 R09:
0000000000000000
[1051788.284859] R10: 0000000000000000 R11: ffffffffa00806c0 R12:
0000000000000000
[1051788.284859] R13: ffff8100ba4dd610 R14: ffffe2000307ac00 R15:
ffff8101194f2c00
[1051788.284859] FS:  00007ff082558710(0000) GS:ffffffff80649000(0000)
knlGS:00000000f5e61b90
[1051788.284859] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[1051788.284859] CR2: 00000000e79f00cc CR3: 000000006d556000 CR4:
00000000000006e0
[1051788.284859] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[1051788.284859] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7:
0000000000000400
[1051788.284859] Process kswapd0 (pid: 212, threadinfo ffff81011e420000,
task ffff81011f0ae3c0)
[1051788.284859] Stack:  ffffffffa006ea38 ffffe20002b12780
000000d0014d0980 ffff8101194f2d84
[1051788.284859]  ffffe2000307ac00 ffffe2000307ac28 ffff81011e421d60
ffff81011e421e60
[1051788.284859]  0000000000000001 ffff810051d9e618 ffffffff802a19ac
ffff81011e421c30
[1051788.284859] Call Trace:
[1051788.284859]  [<ffffffffa006ea38>] ?
:jbd:journal_try_to_free_buffers+0x48/0x1d0
[1051788.284859]  [<ffffffff802a19ac>] ? shrink_page_list+0x44c/0x680
[1051788.284859]  [<ffffffff802a0794>] ? isolate_lru_pages+0x84/0x220
[1051788.284859]  [<ffffffff802a1d42>] ? shrink_inactive_list+0x162/0x380
[1051788.284859]  [<ffffffff802a1fd4>] ? shrink_zone+0x74/0x150
[1051788.284859]  [<ffffffff802a2ce0>] ? kswapd+0x580/0x5d0
[1051788.284859]  [<ffffffff802a0930>] ? isolate_pages_global+0x0/0x40
[1051788.284859]  [<ffffffff80250470>] ? autoremove_wake_function+0x0/0x30
[1051788.284859]  [<ffffffff802a2760>] ? kswapd+0x0/0x5d0
[1051788.284859]  [<ffffffff8024ff27>] ? kthread+0x47/0x90
[1051788.284859]  [<ffffffff80235be7>] ? schedule_tail+0x27/0xa0
[1051788.284859]  [<ffffffff8020d168>] ? child_rip+0xa/0x12
[1051788.284859]  [<ffffffff8024fee0>] ? kthread+0x0/0x90
[1051788.284859]  [<ffffffff8020d15e>] ? child_rip+0x0/0x12
[1051788.284859]
[1051788.284859]
[1051788.284859] Code: c0 0f b6 c0 5b c3 0f 1f 44 00 00 48 8b 87 18 01 00
00 b9 0c 00 00 00 0f b6 40 20 29 c1 b8 01 00 00 00 d3 e0 c3 66 0f 1f 44
00 00 <f0> 0f ba 2f 16 19 c0 85 c0 74 15 48 8b 07 a9 00 00 40 00 74 eb
[1051788.284859] RIP  [<ffffffffa0072ed0>]
:jbd:journal_grab_journal_head+0x0/0x90
[1051788.284859]  RSP <ffff81011e421ae8>
[1051788.284859] ------------[ cut here ]------------


[1051788.284859] WARNING: at kernel/softirq.c:142
local_bh_enable+0x65/0x90()
[1051788.284859] Modules linked in: dummy binfmt_misc nfs lockd nfs_acl
sunrpc sch_sfq xt_TCPMSS xt_tcpudp iptable_mangle iptable_filter
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables
ip6table_filter ip6_tables x_tables raid0 uvesafb cn autofs4
pata_jmicron ata_generic pata_acpi ide_pci_generic rtc_cmos rtc_core
rtc_lib serio_raw cfi_cmdset_0002 pcspkr isp1760 cfi_util k8temp psmouse
jmicron hwmon ohci_hcd ahci jedec_probe cfi_probe forcedeth ehci_hcd
i2c_nforce2 usbcore gen_probe i2c_core ssb sg pcmcia pcmcia_core
firmware_class ck804xrom mtd chipreg map_funcs thermal button processor
evdev scsi_wait_scan sd_mod raid1 md_mod ext3 jbd mbcache sata_nv libata
scsi_mod dock amd74xx ide_core
[1051788.284859] Pid: 212, comm: kswapd0 Tainted: G      D   2.6.26.6-0.1
#1
[1051788.284859]
[1051788.284859] Call Trace:
[1051788.284859]  [<ffffffff80238c64>] warn_on_slowpath+0x64/0xc0
[1051788.284859]  [<ffffffff803a33e1>] bit_clear+0xb1/0xe0
[1051788.284859]  [<ffffffff803a0850>] fbcon_scroll+0x260/0xde0
[1051788.284859]  [<ffffffff8023f065>] local_bh_enable+0x65/0x90
[1051788.284859]  [<ffffffff8042f005>] sk_filter+0x95/0xd0
[1051788.284859]  [<ffffffff8043f3f9>] netlink_broadcast+0x189/0x430
[1051788.284859]  [<ffffffffa01cbb60>]
[1051788.284859]  [<ffffffff802c438c>] kmem_cache_alloc+0xac/0x220
[1051788.284859]  [<ffffffffa01cc049>]
[1051788.284859]  [<ffffffff803940a6>] fb_blank+0x36/0x70
[1051788.284859]  [<ffffffff8039f9ff>] fbcon_blank+0x1cf/0x280
[1051788.284859]  [<ffffffff804e8b17>] printk+0x4e/0x57
[1051788.284859]  [<ffffffff80244254>] lock_timer_base+0x34/0x70
[1051788.284859]  [<ffffffff80244537>] __mod_timer+0xb7/0xd0
[1051788.284859]  [<ffffffff803e51d4>] do_unblank_screen+0xa4/0x170
[1051788.284859]  [<ffffffff803822cd>] bust_spinlocks+0x1d/0x40
[1051788.284859]  [<ffffffff804ec07c>] oops_end+0x2c/0x90
[1051788.284859]  [<ffffffff804ebad9>] error_exit+0x0/0x51
[1051788.284859]  [<ffffffffa00806c0>] :ext3:ext3_sync_flags+0xea0/0x1250
[1051788.284859]  [<ffffffffa0072ed0>]
:jbd:journal_grab_journal_head+0x0/0x90
[1051788.284860]  [<ffffffffa006ea38>]
:jbd:journal_try_to_free_buffers+0x48/0x1d0
[1051788.284860]  [<ffffffff802a19ac>] shrink_page_list+0x44c/0x680
[1051788.284860]  [<ffffffff802a0794>] isolate_lru_pages+0x84/0x220
[1051788.284860]  [<ffffffff802a1d42>] shrink_inactive_list+0x162/0x380
[1051788.284860]  [<ffffffff802a1fd4>] shrink_zone+0x74/0x150
[1051788.284860]  [<ffffffff802a2ce0>] kswapd+0x580/0x5d0
[1051788.284860]  [<ffffffff802a0930>] isolate_pages_global+0x0/0x40
[1051788.284860]  [<ffffffff80250470>] autoremove_wake_function+0x0/0x30
[1051788.284860]  [<ffffffff802a2760>] kswapd+0x0/0x5d0
[1051788.284860]  [<ffffffff8024ff27>] kthread+0x47/0x90
[1051788.284860]  [<ffffffff80235be7>] schedule_tail+0x27/0xa0
[1051788.284860]  [<ffffffff8020d168>] child_rip+0xa/0x12
[1051788.284860]  [<ffffffff8024fee0>] kthread+0x0/0x90
[1051788.284860]  [<ffffffff8020d15e>] child_rip+0x0/0x12
[1051788.284860]
[1051788.284860] ---[ end trace 83b19352657ddd8a ]---

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZBIPvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZBIPvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZBIPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:51:04 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:53698 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZBIPvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:51:01 -0500
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Date: Mon, 9 Feb 2009 16:50:57 +0100
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com>
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmJjq+13WQP0k8DSW6CGiQncZ/gLABPnv1A
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Feb 2009 15:50:58.0402 (UTC) FILETIME=[3338B420:01C98ACE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Update:

the same issue with a linux 2.6.28.4 kernel.

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xdf/0x119()
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28.4-ibm #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8023cdae>] warn_slowpath+0xb4/0xda
[    0.000000]  [<ffffffff80341c1f>] sprintf+0x51/0x59
[    0.000000]  [<ffffffff80222cb8>] default_spin_lock_flags+0x14/0x18
[    0.000000]  [<ffffffff8045e589>] _spin_unlock_irqrestore+0x22/0x25
[    0.000000]  [<ffffffff80219b3d>] get_fixed_ranges+0x94/0xbb
[    0.000000]  [<ffffffff80219e0a>] mtrr_wrmsr+0x29/0x56
[    0.000000]  [<ffffffff80219e0a>] mtrr_wrmsr+0x29/0x56
[    0.000000]  [<ffffffff80602534>] get_mtrr_state+0x32d/0x339
[    0.000000]  [<ffffffff80219cf1>] generic_get_mtrr+0xdf/0x119
[    0.000000]  [<ffffffff80601347>] mtrr_bp_init+0x21f/0xc71
[    0.000000]  [<ffffffff80601e3a>] mtrr_trim_uncached_memory+0xa1/0x390
[    0.000000]  [<ffffffff803d796c>] dmi_table+0x6c/0x7a
[    0.000000]  [<ffffffff8060cd06>] __early_set_fixmap+0xd1/0xd4
[    0.000000]  [<ffffffff805f6140>] early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff805fcf6a>] setup_arch+0x407/0x78c
[    0.000000]  [<ffffffff806116d5>] cgroup_init_subsys+0x2a/0xd9
[    0.000000]  [<ffffffff806119b2>] cgroup_init_early+0x1a4/0x1b6
[    0.000000]  [<ffffffff8045e536>] _spin_lock+0x14/0x15
[    0.000000]  [<ffffffff805f6977>] start_kernel+0x7b/0x38b
[    0.000000]  [<ffffffff805f6140>] early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff805f63e7>] x86_64_start_kernel+0x12d/0x13a
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

-----Ursprüngliche Nachricht-----
Von: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] Im Auftrag von Morten P.D. Stevens
Gesendet: Sonntag, 8. Februar 2009 02:44
An: linux-kernel@vger.kernel.org
Betreff: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400

Hi,

just for fun i installed linux 2.6.29-rc3 on a IBM x3400 server for
testing purposes and get a warning in
arch/x86/kernel/cpu/mtrr/generic.c:

Kernel failure message 1:
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:400
generic_get_mtrr+0xc6/0x104() (Not tainted)
Hardware name: IBM eServer x3400-[7976KCG]-
mtrr: your BIOS has set up an incorrect mask, fixing it up.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-0.66.rc3.fc11.x86_64 #1
Call Trace:
[<ffffffff8104a5c1>] warn_slowpath+0xb9/0xfe
[<ffffffff8106ef5b>] ? lock_acquired+0x29e/0x2ae
[<ffffffff81016ea4>] ? sched_clock+0xa/0xc
[<ffffffff8106bc68>] ? lock_release_holdtime+0x2c/0x123
[<ffffffff8106f633>] ? lock_release+0x17c/0x189
[<ffffffff8119a570>] ? _raw_spin_unlock+0x8f/0x93
[<ffffffff8106c741>] ? trace_hardirqs_off+0xd/0xf
[<ffffffff8101f915>] generic_get_mtrr+0xc6/0x104
[<ffffffff8160efa0>] mtrr_trim_uncached_memory+0x8e/0x2f5
[<ffffffff813806d9>] ? printk+0x3c/0x43
[<ffffffff816190f6>] ? early_gart_iommu_check+0x98/0x26a
[<ffffffff81602140>] ? early_idt_handler+0x0/0x71
[<ffffffff8160a825>] setup_arch+0x41c/0x7d1
[<ffffffff8138338e>] ? _spin_unlock_irqrestore+0x40/0x57
[<ffffffff81602a8e>] start_kernel+0xa2/0x3e2
[<ffffffff816022bf>] x86_64_start_reservations+0xaa/0xae
[<ffffffff816023ca>] x86_64_start_kernel+0xe4/0xf3
---[ end trace 4eaa2a86a8e2da22 ]---

lspci:

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8
Port 2-3 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 3 (rev b1)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8
Port 4-5 (rev b1)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 5 (rev b1)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8
Port 6-7 (rev b1)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 7 (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers
(rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers
(rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers
(rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 (rev 09)
00:1c.1 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 2 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller
(rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01)
02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E2 (rev 01)
03:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
1a:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721
Gigabit Ethernet PCI Express (rev 21)
1c:04.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

Bios is the newest IBM BIOS.
There are no problems with previous kernel versions like 2.6.18-92 or
2.6.27.

Any ideas about the CPU/BIOS warning?

-

Morten


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZBHBoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZBHBoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 20:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZBHBnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 20:43:52 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:57464 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZBHBnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:43:51 -0500
Subject: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Date: Sun, 8 Feb 2009 02:43:48 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com>
X-MS-Has-Attach: 
Content-class: urn:content-classes:message
X-MS-TNEF-Correlator: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmJjq+13WQP0k8DSW6CGiQncZ/gLA==
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Feb 2009 01:43:48.0843 (UTC) FILETIME=[B007C3B0:01C9898E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



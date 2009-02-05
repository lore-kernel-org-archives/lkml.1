Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZBEW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZBEW3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZBEW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:29:15 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:37313 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZBEW3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:29:14 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-class: urn:content-classes:message
Subject: linux 2.6.29-rc3 kernel failure with mptsas
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 5 Feb 2009 23:29:10 +0100
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: linux 2.6.29-rc3 kernel failure with mptsas
Thread-Index: AcmH4SpQOTNjfPBDR+SOSExL4JZjWg==
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2009 22:29:11.0215 (UTC) FILETIME=[2ACBA3F0:01C987E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get a kernel failure with linux 2.6.29-rc3 on my Dell T7400
Workstation.

failure message:

WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400  
Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
scsi_transport_sas
Pid: 35, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.66.rc3.fc11.x86_64 #1
Call Trace:
[<ffffffff8104a5c1>] warn_slowpath+0xb9/0xfe
[<ffffffff813806d9>] ? printk+0x3c/0x43
[<ffffffff8119b5fb>] __debug_object_init+0x2a8/0x353
[<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff8119b6d3>] debug_object_init+0x14/0x19
[<ffffffff8105461f>] init_timer+0x18/0x5b
[<ffffffffa001122d>] mpt_config+0x1e4/0x305 [mptbase]
[<ffffffffa001017a>] ? pci_free_consistent+0x75/0x81 [mptbase]
[<ffffffffa0012f25>] mpt_do_ioc_recovery+0x142a/0x15e8 [mptbase]
[<ffffffff81046c95>] ? finish_task_switch+0x5f/0xf6
[<ffffffff81046c36>] ? finish_task_switch+0x0/0xf6
[<ffffffffa00132a5>] ? mpt_timer_expired+0x0/0x60 [mptbase]
[<ffffffff8101414a>] ? dump_trace+0x269/0x27b
[<ffffffff8101c12b>] ? save_stack_trace+0x2a/0x48
[<ffffffff8106c546>] ? save_trace+0x3f/0x95
[<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
[<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
[<ffffffff8106d529>] ? mark_held_locks+0x67/0x83
[<ffffffff81383395>] ? _spin_unlock_irqrestore+0x47/0x57
[<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
[<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff81194602>] ? __up_read+0x7c/0x85
[<ffffffff810624ad>] ? up_read+0x26/0x2a
[<ffffffffa001480f>] mpt_attach+0xa1b/0xb80 [mptbase]
[<ffffffffa002f70a>] mptsas_probe+0x1a/0x487 [mptsas]
[<ffffffff811a491f>] local_pci_probe+0x12/0x16
[<ffffffff8105b0d7>] do_work_for_cpu+0x13/0x1b
[<ffffffff8105b268>] run_workqueue+0x103/0x20a
[<ffffffff8105b216>] ? run_workqueue+0xb1/0x20a
[<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
[<ffffffff8105b0c4>] ? do_work_for_cpu+0x0/0x1b
[<ffffffff8105b44f>] worker_thread+0xe0/0xf1
[<ffffffff8105f090>] ? autoremove_wake_function+0x0/0x38
[<ffffffff8105b36f>] ? worker_thread+0x0/0xf1
[<ffffffff8105ed18>] kthread+0x49/0x76
[<ffffffff8101262a>] child_rip+0xa/0x20
[<ffffffff81011f3e>] ? restore_args+0x0/0x30
[<ffffffff8105ecaa>] ? kthreadd+0x176/0x19b
[<ffffffff8105eccf>] ? kthread+0x0/0x76
[<ffffffff81012620>] ? child_rip+0x0/0x20
---[ end trace af29b8e50456f967 ]---


Kernel failure message 2:
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400  
Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
scsi_transport_sas
Pid: 35, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.66.rc3.fc11.x86_64 #1
Call Trace:
[<ffffffff8104a5c1>] warn_slowpath+0xb9/0xfe
[<ffffffff813806d9>] ? printk+0x3c/0x43
[<ffffffff8119b5fb>] __debug_object_init+0x2a8/0x353
[<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff8119b6d3>] debug_object_init+0x14/0x19
[<ffffffff8105461f>] init_timer+0x18/0x5b
[<ffffffffa001122d>] mpt_config+0x1e4/0x305 [mptbase]
[<ffffffffa0012e57>] mpt_do_ioc_recovery+0x135c/0x15e8 [mptbase]
[<ffffffff81046c95>] ? finish_task_switch+0x5f/0xf6
[<ffffffff81046c36>] ? finish_task_switch+0x0/0xf6
[<ffffffff81195b1d>] ? string+0x3d/0xa1
[<ffffffff81195f66>] ? vsnprintf+0x3e5/0x930
[<ffffffff8101414a>] ? dump_trace+0x269/0x27b
[<ffffffff8101c12b>] ? save_stack_trace+0x2a/0x48
[<ffffffff8106c546>] ? save_trace+0x3f/0x95
[<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
[<ffffffff8106d137>] ? mark_lock+0x22/0x3ad
[<ffffffff8106d529>] ? mark_held_locks+0x67/0x83
[<ffffffff81383395>] ? _spin_unlock_irqrestore+0x47/0x57
[<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
[<ffffffff8106d74a>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff81194602>] ? __up_read+0x7c/0x85
[<ffffffff810624ad>] ? up_read+0x26/0x2a
[<ffffffffa001480f>] mpt_attach+0xa1b/0xb80 [mptbase]
[<ffffffffa002f70a>] mptsas_probe+0x1a/0x487 [mptsas]
[<ffffffff811a491f>] local_pci_probe+0x12/0x16
[<ffffffff8105b0d7>] do_work_for_cpu+0x13/0x1b
[<ffffffff8105b268>] run_workqueue+0x103/0x20a
[<ffffffff8105b216>] ? run_workqueue+0xb1/0x20a
[<ffffffff8106d719>] ? trace_hardirqs_on_caller+0x12f/0x153
[<ffffffff8105b0c4>] ? do_work_for_cpu+0x0/0x1b
[<ffffffff8105b44f>] worker_thread+0xe0/0xf1
[<ffffffff8105f090>] ? autoremove_wake_function+0x0/0x38
[<ffffffff8105b36f>] ? worker_thread+0x0/0xf1
[<ffffffff8105ed18>] kthread+0x49/0x76
[<ffffffff8101262a>] child_rip+0xa/0x20
[<ffffffff81011f3e>] ? restore_args+0x0/0x30
[<ffffffff8105ecaa>] ? kthreadd+0x176/0x19b
[<ffffffff8105eccf>] ? kthread+0x0/0x76
[<ffffffff81012620>] ? child_rip+0x0/0x20
---[ end trace af29b8e50456f966 ]---


Kernel failure message 3:
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400  
Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
scsi_transport_sas
Pid: 35, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.66.rc3.fc11.x86_64 #1
Call Trace:


Kernel failure message 4:
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
(Not tainted)
Hardware name: Precision WorkStation T7400  
Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
scsi_transport_sas
Pid: 35, comm: work_on_cpu/0 Not tainted 2.6.29-0.66.rc3.fc11.x86_64 #1
Call Trace:

hardware info:

[root@localhost Desktop]# lspci
00:00.0 Host bridge: Intel Corporation 5400 Chipset Memory Controller
Hub (rev 20)
00:01.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 1
(rev 20)
00:05.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 5
(rev 20)
00:09.0 PCI bridge: Intel Corporation 5400 Chipset PCI Express Port 9
(rev 20)
00:10.0 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.1 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.2 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.3 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:10.4 Host bridge: Intel Corporation 5400 Chipset FSB Registers (rev
20)
00:11.0 Host bridge: Intel Corporation 5400 Chipset CE/SF Registers (rev
20)
00:15.0 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:15.1 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:16.0 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:16.1 Host bridge: Intel Corporation 5400 Chipset FBD Registers (rev
20)
00:1b.0 Audio device: Intel Corporation 631xESB/632xESB High Definition
Audio Controller (rev 09)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
Express Root Port 1 (rev 09)
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
00:1f.2 IDE interface: Intel Corporation 631xESB/632xESB/3100 Chipset
SATA IDE Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
02:00.0 VGA compatible controller: nVidia Corporation Quadro FX 570 (rev
a1)
03:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01)
03:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01)
04:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01)
04:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E2 (rev 01)
05:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)
08:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express (rev 02)

Any ideas about the problem?


-

Morten





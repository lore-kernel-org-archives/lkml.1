Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZLCVuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZLCVuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZLCVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:50:51 -0500
Received: from lucidpixels.com ([75.144.35.66]:45834 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZLCVuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:50:50 -0500
Date: Thu, 3 Dec 2009 16:50:57 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32 OOPS: hpet issue w/frame pointers enabled (was: Intel
 DP55KG)
Message-ID: <alpine.DEB.2.00.0912031649350.3565@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a BIOS errata that Intel has mentioned but FYI, with 2.6.32:

[    3.287702] ------------[ cut here ]------------
[    3.298987] WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x7d/0x90()
[    3.298988] Hardware name:
[    3.298988] Modules linked in:
[    3.298990] Pid: 1, comm: swapper Not tainted 2.6.32 #2
[    3.298991] Call Trace:
[    3.298992]  <IRQ>  [<ffffffff81046e5d>] ? hpet_next_event+0x7d/0x90
[    3.298996]  [<ffffffff8105baf8>] warn_slowpath_common+0x78/0xd0
[    3.298997]  [<ffffffff8105bb5f>] warn_slowpath_null+0xf/0x20
[    3.298999]  [<ffffffff81046e5d>] hpet_next_event+0x7d/0x90
[    3.299001]  [<ffffffff81046e9b>] hpet_legacy_next_event+0xb/0x10
[    3.299003]  [<ffffffff8107c8df>] clockevents_program_event+0x4f/0x90
[    3.299005]  [<ffffffff8107dcae>] tick_dev_program_event+0x3e/0xc0
[    3.299008]  [<ffffffff8107677d>] ? sched_clock_cpu+0xad/0x110
[    3.299010]  [<ffffffff8107d502>] tick_handle_oneshot_broadcast+0xe2/0x100
[    3.299012]  [<ffffffff81050b9d>] ? task_tick_fair+0x10d/0x170
[    3.299015]  [<ffffffff810333aa>] timer_interrupt+0x1a/0x30
[    3.299017]  [<ffffffff81089d6a>] handle_IRQ_event+0x3a/0xe0
[    3.299019]  [<ffffffff8108bb28>] handle_edge_irq+0xb8/0x150
[    3.299021]  [<ffffffff81032cbf>] handle_irq+0x1f/0x30
[    3.299022]  [<ffffffff8107c8df>] ? clockevents_program_event+0x4f/0x90
[    3.299024]  [<ffffffff810321da>] do_IRQ+0x6a/0xf0
[    3.299026]  [<ffffffff81030613>] ret_from_intr+0x0/0xa
[    3.299029]  [<ffffffff810613af>] ? __do_softirq+0x5f/0x130
[    3.299030]  [<ffffffff81046dc2>] ? hpet_interrupt_handler+0x12/0x30
[    3.299032]  [<ffffffff81030d7c>] ? call_softirq+0x1c/0x30
[    3.299034]  [<ffffffff81032c65>] ? do_softirq+0x55/0x90
[    3.299035]  [<ffffffff810610d5>] ? irq_exit+0x75/0x90
[    3.299037]  [<ffffffff810321e3>] ? do_IRQ+0x73/0xf0
[    3.299038]  [<ffffffff81030613>] ? ret_from_intr+0x0/0xa
[    3.299039]  <EOI>  [<ffffffff8105c775>] ? vprintk+0x1a5/0x440
[    3.299043]  [<ffffffff8110de9d>] ? sysfs_find_dirent+0x2d/0x40
[    3.299044]  [<ffffffff8110e521>] ? sysfs_addrm_finish+0x21/0x250
[    3.299047]  [<ffffffff815ab8b0>] ? hid_init+0x0/0xc8
[    3.299049]  [<ffffffff813ebdc8>] ? printk+0x67/0x69
[    3.299051]  [<ffffffff8110d9dc>] ? sysfs_add_file+0xc/0x10
[    3.299052]  [<ffffffff8110daa1>] ? sysfs_create_file+0x21/0x30
[    3.299056]  [<ffffffff81283857>] ? driver_create_file+0x17/0x20
[    3.299059]  [<ffffffff812c35a4>] ? usb_register_driver+0xf4/0x120
[    3.299060]  [<ffffffff815ab8b0>] ? hid_init+0x0/0xc8
[    3.299062]  [<ffffffff815ab976>] ? hid_init+0xc6/0xc8
[    3.299064]  [<ffffffff81009048>] ? do_one_initcall+0x38/0x190
[    3.299067]  [<ffffffff81589655>] ? kernel_init+0x162/0x1ba
[    3.299068]  [<ffffffff81030c7a>] ? child_rip+0xa/0x20
[    3.299070]  [<ffffffff815894f3>] ? kernel_init+0x0/0x1ba
[    3.299072]  [<ffffffff81030c70>] ? child_rip+0x0/0x20
[    3.299075] ---[ end trace bd1963d9af6a1f28 ]---


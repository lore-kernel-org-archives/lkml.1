Return-Path: <linux-kernel-owner+w=401wt.eu-S932679AbZFLDQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbZFLDQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbZFLDQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:16:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35207 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbZFLDQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HGkg2eULK54eWTtHPrV8acKNDFk41lAU73sg5XgBLOYFzWJYNc9qEtxzJe9R9dQp5b
         jHInPb9QEcWhzPSheoz0gEJx4rHyszUbI69Eye6auk3lQ20Hys5tOIaQSDHIyUA4dgb5
         /GSYUaN/BMooSPhYRxondpC8JeXwq1otNx8+g=
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 19:45:21 -0700
Message-ID: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
Subject: mthca double free irqs
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Roland Dreier <rdreier@cisco.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  604.800358] ib_mthca: Initializing 0000:c4:00.0
[  604.803593] ib_mthca 0000:c4:00.0: PCI INT A -> GSI 98 (level, low) -> IRQ 98
[  604.820587] ib_mthca 0000:c4:00.0: setting latency timer to 64
[  604.824369] ib_mthca 0000:c4:00.0: using 64bit DMA mask
[  604.840003] ib_mthca 0000:c4:00.0: using 64bit consistent DMA mask
[  604.845961] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  604.863794] free_memtype request 0xfbef0000-0xfbef1000
[  605.882922] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.179925] reserve_memtype added 0xfa800000-0xfa801000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.222053] ib_mthca 0000:c4:00.0: HCA FW version 4.6.002 is old
(4.8.200 is current).
[  606.229839] ib_mthca 0000:c4:00.0: If you have problems, try
updating your HCA FW.
[  606.239838] reserve_memtype added 0xfbe82000-0xfbe83000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.259063]   alloc irq_desc for 232 on node 0
[  606.263133]   alloc kstat_irqs on node 0
[  606.277766] ib_mthca 0000:c4:00.0: irq 232 for MSI/MSI-X
[  606.282177]   alloc irq_desc for 233 on node 0
[  606.286160]   alloc kstat_irqs on node 0
[  606.299309] ib_mthca 0000:c4:00.0: irq 233 for MSI/MSI-X
[  606.303756]   alloc irq_desc for 234 on node 0
[  606.319225]   alloc kstat_irqs on node 0
[  606.322687] ib_mthca 0000:c4:00.0: irq 234 for MSI/MSI-X
[  606.337147] reserve_memtype added 0xfa802000-0xfa803000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.357274] reserve_memtype added 0xe5800000-0xe6000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.366082] reserve_memtype added 0xe0000000-0xe4000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.389823] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.401964] Overlap at 0xfbe80000-0xfbe81000
[  606.418913] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.538429] ib_mthca 0000:c4:00.0: NOP command failed to generate
interrupt (IRQ 234).
[  606.543348] ib_mthca 0000:c4:00.0: Trying again with MSI-X disabled.
[  606.560852] free_memtype request 0xfbe80000-0xfbe81000
[  606.564779] free_memtype request 0xfbef0000-0xfbef1000
[  606.578039] free_memtype request 0xe0000000-0xe4000000
[  606.581770] free_memtype request 0xe5800000-0xe6000000
[  606.597795] free_memtype request 0xfa802000-0xfa803000
[  606.600688] free_memtype request 0xfbe82000-0xfbe83000
[  606.616891] reserve_memtype added 0xfa802000-0xfa803000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.639208] reserve_memtype added 0xe5800000-0xe6000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.647364] reserve_memtype added 0xe0000000-0xe4000000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.671960] reserve_memtype added 0xfbef0000-0xfbef1000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.686785] Overlap at 0xfbe80000-0xfbe81000
[  606.696978] reserve_memtype added 0xfbe80000-0xfbe81000, track
uncached-minus, req uncached-minus, ret uncached-minus
[  606.818317] ib_mthca 0000:c4:00.0: NOP command failed to generate
interrupt (IRQ 98), aborting.
[  606.826709] ib_mthca 0000:c4:00.0: BIOS or ACPI interrupt routing problem?
[  606.839353] ------------[ cut here ]------------
[  606.841560] WARNING: at kernel/irq/manage.c:740 __free_irq+0xad/0x17f()
[  606.859197] Hardware name: System Name
[  606.861049] Trying to free already-free IRQ 234
[  606.877055] Modules linked in:
[  606.881444] Pid: 10719, comm: work_for_cpu Not tainted
2.6.30-tip-03093-gff58544-dirty #380
[  606.897083] Call Trace:
[  606.900366]  [<ffffffff810cb58a>] ? __free_irq+0xad/0x17f
[  606.904024]  [<ffffffff8107d612>] warn_slowpath_common+0x8d/0xd0
[  606.918689]  [<ffffffff8107d6e2>] warn_slowpath_fmt+0x50/0x66
[  606.924606]  [<ffffffff810cb55d>] ? __free_irq+0x80/0x17f
[  606.939724]  [<ffffffff810cb58a>] __free_irq+0xad/0x17f
[  606.943368]  [<ffffffff810ac63d>] ? trace_hardirqs_on+0x20/0x36
[  606.960565]  [<ffffffff810cb67d>] free_irq+0x21/0x3f
[  606.962793]  [<ffffffff8190acbe>] mthca_free_irqs+0x5a/0xad
[  606.979683]  [<ffffffff8190af71>] mthca_cleanup_eq_table+0x2b/0xda
[  606.983649]  [<ffffffff81904308>] mthca_setup_hca+0x4f7/0x558
[  606.998302]  [<ffffffff81905909>] __mthca_init_one+0x5f6/0x708
[  607.003948]  [<ffffffff81b4dd66>] mthca_init_one+0x94/0xbf
[  607.019447]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.023666]  [<ffffffff814621ab>] local_pci_probe+0x2a/0x42
[  607.039153]  [<ffffffff81094252>] do_work_for_cpu+0x27/0x50
[  607.041672]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.059565]  [<ffffffff8109958d>] kthread+0x6e/0xb1
[  607.063474]  [<ffffffff81035fda>] child_rip+0xa/0x20
[  607.079096]  [<ffffffff8103597c>] ? restore_args+0x0/0x30
[  607.083027]  [<ffffffff8109951f>] ? kthread+0x0/0xb1
[  607.098768]  [<ffffffff81035fd0>] ? child_rip+0x0/0x20
[  607.101323] ---[ end trace e6652b295472e0d7 ]---
[  607.117066] ------------[ cut here ]------------
[  607.119830] WARNING: at kernel/irq/manage.c:740 __free_irq+0xad/0x17f()
[  607.137557] Hardware name: Libra
[  607.140825] Trying to free already-free IRQ 233
[  607.145850] Modules linked in:
[  607.157651] Pid: 10719, comm: work_for_cpu Tainted: G        W
2.6.30-tip-03093-gff58544-dirty #380
[  607.176018] Call Trace:
[  607.178982]  [<ffffffff810cb58a>] ? __free_irq+0xad/0x17f
[  607.182636]  [<ffffffff8107d612>] warn_slowpath_common+0x8d/0xd0
[  607.198688]  [<ffffffff8107d6e2>] warn_slowpath_fmt+0x50/0x66
[  607.203487]  [<ffffffff810cb55d>] ? __free_irq+0x80/0x17f
[  607.219523]  [<ffffffff810cb58a>] __free_irq+0xad/0x17f
[  607.222882]  [<ffffffff810ac63d>] ? trace_hardirqs_on+0x20/0x36
[  607.238103]  [<ffffffff810cb67d>] free_irq+0x21/0x3f
[  607.241173]  [<ffffffff8190acda>] mthca_free_irqs+0x76/0xad
[  607.257516]  [<ffffffff8190af71>] mthca_cleanup_eq_table+0x2b/0xda
[  607.264306]  [<ffffffff81904308>] mthca_setup_hca+0x4f7/0x558
[  607.277819]  [<ffffffff81905909>] __mthca_init_one+0x5f6/0x708
[  607.283174]  [<ffffffff81b4dd66>] mthca_init_one+0x94/0xbf
[  607.297829]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.301208]  [<ffffffff814621ab>] local_pci_probe+0x2a/0x42
[  607.318688]  [<ffffffff81094252>] do_work_for_cpu+0x27/0x50
[  607.322902]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.339817]  [<ffffffff8109958d>] kthread+0x6e/0xb1
[  607.344286]  [<ffffffff81035fda>] child_rip+0xa/0x20
[  607.357248]  [<ffffffff8103597c>] ? restore_args+0x0/0x30
[  607.360923]  [<ffffffff8109951f>] ? kthread+0x0/0xb1
[  607.376587]  [<ffffffff81035fd0>] ? child_rip+0x0/0x20
[  607.383884] ---[ end trace e6652b295472e0d8 ]---
[  607.396025] ------------[ cut here ]------------
[  607.400016] WARNING: at kernel/irq/manage.c:740 __free_irq+0xad/0x17f()
[  607.416804] Hardware name: Libra
[  607.419503] Trying to free already-free IRQ 232
[  607.424234] Modules linked in:
[  607.436788] Pid: 10719, comm: work_for_cpu Tainted: G        W
2.6.30-tip-03093-gff58544-dirty #380
[  607.442583] Call Trace:
[  607.456233]  [<ffffffff810cb58a>] ? __free_irq+0xad/0x17f
[  607.459883]  [<ffffffff8107d612>] warn_slowpath_common+0x8d/0xd0
[  607.477933]  [<ffffffff8107d6e2>] warn_slowpath_fmt+0x50/0x66
[  607.481881]  [<ffffffff810cb55d>] ? __free_irq+0x80/0x17f
[  607.497082]  [<ffffffff810cb58a>] __free_irq+0xad/0x17f
[  607.500157]  [<ffffffff810ac63d>] ? trace_hardirqs_on+0x20/0x36
[  607.516507]  [<ffffffff810cb67d>] free_irq+0x21/0x3f
[  607.520978]  [<ffffffff8190acf6>] mthca_free_irqs+0x92/0xad
[  607.536204]  [<ffffffff8190af71>] mthca_cleanup_eq_table+0x2b/0xda
[  607.542430]  [<ffffffff81904308>] mthca_setup_hca+0x4f7/0x558
[  607.557645]  [<ffffffff81905909>] __mthca_init_one+0x5f6/0x708
[  607.561602]  [<ffffffff81b4dd66>] mthca_init_one+0x94/0xbf
[  607.578214]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.581882]  [<ffffffff814621ab>] local_pci_probe+0x2a/0x42
[  607.597365]  [<ffffffff81094252>] do_work_for_cpu+0x27/0x50
[  607.604409]  [<ffffffff8109422b>] ? do_work_for_cpu+0x0/0x50
[  607.617720]  [<ffffffff8109958d>] kthread+0x6e/0xb1
[  607.620780]  [<ffffffff81035fda>] child_rip+0xa/0x20
[  607.637011]  [<ffffffff8103597c>] ? restore_args+0x0/0x30
[  607.642633]  [<ffffffff8109951f>] ? kthread+0x0/0xb1
[  607.656116]  [<ffffffff81035fd0>] ? child_rip+0x0/0x20
[  607.659478] ---[ end trace e6652b295472e0d9 ]---
[  607.662779] free_memtype request 0xfbe80000-0xfbe81000
[  607.678284] free_memtype request 0xfbef0000-0xfbef1000
[  607.682522] free_memtype request 0xe0000000-0xe4000000
[  607.697438] free_memtype request 0xe5800000-0xe6000000
[  607.701085] free_memtype request 0xfa802000-0xfa803000
[  607.718191] free_memtype request 0xfbe80000-0xfbe81000
[  607.721542] free_memtype request 0xfa800000-0xfa801000
[  607.737028] ib_mthca 0000:c4:00.0: PCI INT A disabled
[  607.741860] ib_mthca: probe of 0000:c4:00.0 failed with error -16

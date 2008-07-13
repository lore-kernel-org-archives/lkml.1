Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYGMSz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYGMSz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYGMSzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:55:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYGMSzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:55:20 -0400
Date: Sun, 13 Jul 2008 20:55:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: per-cpu related?
Message-ID: <20080713185502.GA17644@elte.hu>
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com> <19f34abd0807130455w516d73cfi80161c345564464@mail.gmail.com> <86802c440807131134i351f967dh3a2b94d687c767ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807131134i351f967dh3a2b94d687c767ee@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> thanks
> 
> could be caused by max_low_pfn_mapped patch...because hpet still use 
> fixmap address that is cleared by others.
> 
> will check that.

got another weird crash:

[   12.431572] device: 'sda1': device_add
[   12.435498] PM: Adding info for No Bus:sda1
[   12.439795] device: 'sda2': device_add
[   12.443606] PM: Adding info for No Bus:sda2
[   12.447945] ------------[ cut here ]------------
[   12.452585] WARNING: at kernel/mutex.c:134 mutex_lock_nested+0x327/0x350()
[   12.459481] Modules linked in:
[   12.462597] Pid: 1, comm: swapper Not tainted 2.6.26-rc9-tip #14453
[   12.468884] 
[   12.468885] Call Trace:
[   12.472882]  [<ffffffff802522b3>] warn_on_slowpath+0x73/0xc0
[   12.478565]  [<ffffffff80280520>] ? trace_hardirqs_on+0x20/0x40
[   12.484509]  [<ffffffff804505d8>] ? debug_locks_off+0x8/0x70
[   12.490190]  [<ffffffff802acb03>] ? ftrace_record_ip+0x193/0x2b0
[   12.496220]  [<ffffffff80280520>] ? trace_hardirqs_on+0x20/0x40
[   12.502159]  [<ffffffff8020c9f4>] ? mcount_call+0x5/0x31
[   12.507494]  [<ffffffff8069b7fd>] ? scsi_disk_put+0x3d/0x80
[   12.513089]  [<ffffffff808a55f7>] mutex_lock_nested+0x327/0x350
[   12.519030]  [<ffffffff8069b7fd>] ? scsi_disk_put+0x3d/0x80
[   12.524624]  [<ffffffff8069b7fd>] scsi_disk_put+0x3d/0x80
[   12.530044]  [<ffffffff8069c5db>] sd_release+0x5b/0xa0
[   12.535207]  [<ffffffff8032e708>] __blkdev_put+0x1d8/0x200
[   12.540713]  [<ffffffff8020c9f4>] ? mcount_call+0x5/0x31
[   12.546047]  [<ffffffff8032e753>] blkdev_put+0x23/0x40
[   12.551209]  [<ffffffff803576c5>] register_disk+0x1a5/0x1c0
[   12.556806]  [<ffffffff80441c2a>] add_disk+0x5a/0xc0
[   12.561794]  [<ffffffff8069c004>] sd_probe+0x2e4/0x440
[   12.566955]  [<ffffffff8050a644>] driver_probe_device+0x104/0x260
[   12.573068]  [<ffffffff8050a860>] ? __device_attach+0x0/0x40
[   12.578750]  [<ffffffff8050a881>] __device_attach+0x21/0x40
[   12.584347]  [<ffffffff805095bb>] bus_for_each_drv+0x7b/0xc0
[   12.590027]  [<ffffffff8050a9a9>] device_attach+0xa9/0xc0
[   12.595450]  [<ffffffff805092f5>] bus_attach_device+0x75/0xa0
[   12.601216]  [<ffffffff80507619>] device_add+0x599/0x670
[   12.606550]  [<ffffffff8020c9f4>] ? mcount_call+0x5/0x31
[   12.611884]  [<ffffffff806277e5>] scsi_sysfs_add_sdev+0x75/0x2a0
[   12.617914]  [<ffffffff8062461b>] scsi_probe_and_add_lun+0xbbb/0xc70
[   12.624289]  [<ffffffff8062586a>] __scsi_add_device+0x13a/0x150
[   12.630229]  [<ffffffff806ada2b>] ata_scsi_scan_host+0xeb/0x330
[   12.636171]  [<ffffffff806aa376>] ata_host_register+0x286/0x310
[   12.642111]  [<ffffffff8050e150>] ? devres_open_group+0xc0/0xf0
[   12.648053]  [<ffffffff806b7380>] ? ata_sff_interrupt+0x0/0x2c0
[   12.653995]  [<ffffffff806b478f>] ata_pci_sff_activate_host+0x12f/0x240
[   12.660628]  [<ffffffff80892af4>] piix_init_one+0x334/0x7f0
[   12.666225]  [<ffffffff804660c3>] pci_call_probe+0xa3/0x100
[   12.671817]  [<ffffffff804662d9>] pci_device_probe+0x99/0xd0
[   12.677499]  [<ffffffff8050a644>] driver_probe_device+0x104/0x260
[   12.683615]  [<ffffffff8050a84b>] __driver_attach+0xab/0xc0
[   12.689208]  [<ffffffff8050a7a0>] ? __driver_attach+0x0/0xc0
[   12.694891]  [<ffffffff80509a4b>] bus_for_each_dev+0x7b/0xc0
[   12.700570]  [<ffffffff8050a324>] driver_attach+0x34/0x50
[   12.705991]  [<ffffffff80508f96>] bus_add_driver+0x116/0x2a0
[   12.711670]  [<ffffffff8050ab67>] driver_register+0x87/0x1a0
[   12.717353]  [<ffffffff80454ff7>] ? __spin_lock_init+0x47/0x90
[   12.723206]  [<ffffffff80deda70>] ? piix_init+0x0/0x60
[   12.728368]  [<ffffffff804665ee>] __pci_register_driver+0x7e/0xe0
[   12.734483]  [<ffffffff80dedaa1>] piix_init+0x31/0x60
[   12.739558]  [<ffffffff80dbbaac>] kernel_init+0x26f/0x39c
[   12.744981]  [<ffffffff808a79af>] ? _spin_unlock_irq+0x3f/0x70
[   12.750834]  [<ffffffff808a7313>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   12.757297]  [<ffffffff80280499>] ? trace_hardirqs_on_caller+0x169/0x1d0
[   12.764019]  [<ffffffff8020e0c9>] child_rip+0xa/0x11
[   12.769006]  [<ffffffff8020d3de>] ? restore_args+0x0/0x30
[   12.774429]  [<ffffffff80dbb83d>] ? kernel_init+0x0/0x39c
[   12.779850]  [<ffffffff8020e0bf>] ? child_rip+0x0/0x11
[   12.785012] 
[   12.786538] ---[ end trace 0361c3a3643346eb ]---
[   12.791214] BUG: scheduling while atomic: swapper/1/0x92899fb1
[   12.797072] INFO: lockdep is turned off.
[   12.801020] Modules linked in:

task structure got corrupted here too - the preempt count is 0x92899fb1.

	Ingo

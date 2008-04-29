Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYD2T5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYD2T5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYD2T5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:57:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYD2T5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:57:19 -0400
Date: Tue, 29 Apr 2008 21:55:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jgarzik@pobox.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [bug - scsi/blk] -git, WARNING: at include/linux/blkdev.h:427
	__blk_run_queue+0x74/0xa0()
Message-ID: <20080429195508.GA30109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


x86.git auto-testing found two new warnings below with latest -git:

 WARNING: at include/linux/blkdev.h:439 blk_remove_plug+0x69/0x80()
 WARNING: at include/linux/blkdev.h:427 __blk_run_queue+0x74/0xa0()

one seems a relatively harmless init locking bug (unlocked access in a 
probe function), the other seems scarier as it happens in an irq handler 
and it likely would trigger multiple times if it wasnt a WARN_ON_ONCE().

Config and full log at:

 http://redhat.com/~mingo/misc/log-Tue_Apr_29_21_40_46_CEST_2008.bad
 http://redhat.com/~mingo/misc/config-Tue_Apr_29_21_40_46_CEST_2008.bad

system booted up fine otherwise and the warnings did not trigger again.

	Ingo

EXT3-fs: write access will be enabled during recovery.
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:427 __blk_run_queue+0x74/0xa0()
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W 2.6.25-sched-devel.git-x86-latest.git #2
 [<c0126e09>] warn_on_slowpath+0x59/0x80
 [<c0175445>] ? cache_flusharray+0xb5/0x100
 [<c015a243>] ? mempool_free_slab+0x13/0x20
 [<c0174a4b>] ? poison_obj+0x2b/0x50
 [<c0174cfe>] ? cache_free_debugcheck+0xce/0x240
 [<c015a243>] ? mempool_free_slab+0x13/0x20
 [<c015a4d8>] ? mempool_free+0x68/0xe0
 [<c015a243>] ? mempool_free_slab+0x13/0x20
 [<c0174a4b>] ? poison_obj+0x2b/0x50
 [<c0174cfe>] ? cache_free_debugcheck+0xce/0x240
 [<c02d9feb>] ? __freed_request+0xab/0xf0
 [<c0404b1d>] ? scsi_pool_free_command+0x2d/0x40
 [<c02daeb4>] __blk_run_queue+0x74/0xa0
 [<c02db356>] blk_run_queue+0x36/0x80
 [<c04097cf>] scsi_run_queue+0x15f/0x300
 [<c04051ec>] ? scsi_put_command+0x6c/0x90
 [<c0409e58>] scsi_next_command+0x38/0x50
 [<c040a0ef>] scsi_end_request+0x6f/0xb0
 [<c040ab37>] scsi_io_completion+0x97/0x410
 [<c0404a46>] scsi_finish_command+0x76/0x90
 [<c040a6e7>] scsi_softirq_done+0x77/0xf0
 [<c02d960a>] blk_done_softirq+0x7a/0x90
 [<c012c485>] __do_softirq+0x85/0x140
 [<c0105ee2>] do_softirq+0xc2/0x100
 [<c014db50>] ? handle_edge_irq+0x0/0xf0
 [<c012c3eb>] irq_exit+0x3b/0x50
 [<c0105fa1>] do_IRQ+0x81/0xc0
 [<c01028e0>] ? default_idle+0x0/0x80
 [<c01028e0>] ? default_idle+0x0/0x80
 [<c01047e0>] common_interrupt+0x28/0x30
 [<c01028e0>] ? default_idle+0x0/0x80
 [<c011799a>] ? native_safe_halt+0xa/0x10
 [<c0102933>] default_idle+0x53/0x80
 [<c0102800>] cpu_idle+0x40/0x90
 [<c05decb8>] rest_init+0x48/0x50
 [<c0872b9f>] start_kernel+0x26f/0x300
 [<c0872410>] ? unknown_bootoption+0x0/0x210
 [<c0104998>] ? mcount_call+0x5/0x9
 [<c08722ad>] i386_start_kernel+0xd/0x10
 =======================
---[ end trace e97bb6de0cc9400b ]---
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.

ata2.01: configured for UDMA/33
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:439 blk_remove_plug+0x69/0x80()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-sched-devel.git-x86-latest.git #2
 [<c0126e09>] warn_on_slowpath+0x59/0x80
 [<c0104998>] ? mcount_call+0x5/0x9
 [<c02dd83e>] ? blk_recalc_rq_segments+0xe/0x210
 [<c0150427>] ? marker_probe_cb+0x37/0x80
 [<c02d8bbe>] ? elv_insert+0xe/0x160
 [<c0151eab>] ? ftrace_record_ip+0xeb/0x210
 [<c02dabd9>] ? blk_remove_plug+0x9/0x80
 [<c0151eab>] ? ftrace_record_ip+0xeb/0x210
 [<c02dac39>] blk_remove_plug+0x69/0x80
 [<c02daca9>] __generic_unplug_device+0x19/0x30
 [<c02dd72a>] blk_execute_rq_nowait+0x6a/0xa0
 [<c02dd7bb>] blk_execute_rq+0x5b/0xa0
 [<c02dd800>] ? blk_end_sync_rq+0x0/0x30
 [<c0104998>] ? mcount_call+0x5/0x9
 [<c016cefe>] ? blk_queue_bounce+0xe/0x280
 [<c019d639>] ? bio_hw_segments+0x9/0x30
 [<c02d96a0>] ? blk_rq_bio_prep+0x30/0xc0
 [<c040a89f>] scsi_execute+0xcf/0xf0
 [<c040a931>] scsi_execute_req+0x71/0xe0
 [<c040c4ed>] scsi_probe_and_add_lun+0x19d/0x8d0
 [<c05fe98d>] ? mutex_unlock+0xd/0x10
 [<c0373ff6>] ? get_device+0x16/0x20
 [<c040c01c>] ? scsi_alloc_target+0x20c/0x2c0
 [<c040c29c>] ? scsi_complete_async_scans+0xc/0xc0
 [<c0104998>] ? mcount_call+0x5/0x9
 [<c040d7b1>] __scsi_add_device+0xe1/0xf0
 [<c044a36f>] ata_scsi_scan_host+0xdf/0x2a0
 [<c0446fc1>] ata_host_register+0x271/0x290
 [<c0450a3b>] ata_pci_sff_activate_host+0x9b/0x210
 [<c0453350>] ? ata_sff_interrupt+0x0/0x230
 [<c045105e>] ata_pci_sff_init_one+0xde/0x100
 [<c045c2f3>] amd_init_one+0xd3/0x1c0
 [<c045c220>] ? amd_init_one+0x0/0x1c0
 [<c02ff04e>] pci_device_probe+0x5e/0x90
 [<c0376912>] driver_probe_device+0x82/0x180
 [<c0376a82>] __driver_attach+0x72/0x80
 [<c0375fe9>] bus_for_each_dev+0x49/0x70
 [<c037678e>] driver_attach+0x1e/0x20
 [<c0376a10>] ? __driver_attach+0x0/0x80
 [<c037645b>] bus_add_driver+0xab/0x210
 [<c02fef90>] ? pci_device_remove+0x0/0x40
 [<c0376c12>] driver_register+0x42/0xf0
 [<c02ff23e>] __pci_register_driver+0x3e/0x90
 [<c0898289>] amd_init+0x19/0x20
 [<c08727a6>] kernel_init+0x86/0x210
 [<c0872720>] ? kernel_init+0x0/0x210
 [<c0104983>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace e97bb6de0cc9400b ]---
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)

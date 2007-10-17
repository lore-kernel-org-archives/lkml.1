Return-Path: <linux-kernel-owner+w=401wt.eu-S935507AbXJQR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935507AbXJQR3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbXJQR3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:29:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052AbXJQR3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:29:08 -0400
Date: Wed, 17 Oct 2007 19:28:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017172857.GA32066@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017170804.GG15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> [...] It's always safe to zero sg, since it's a valid entry - nothing 
> to save in ->page. Ingo, does this work for you?

with that patch it not crashes on NULL dereference - see crashlog below. 
Compiler bug perhaps?

	Ingo

---------------->
[   34.605614] EXT3-fs: INFO: recovery required on readonly filesystem.
[   34.611842] EXT3-fs: write access will be enabled during recovery.
[   34.635861] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
[   34.644227] printing eip: 7840840e *pde = 00000000 
[   34.649081] Oops: 0002 [#1] DEBUG_PAGEALLOC
[   34.653239] 
[   34.654713] Pid: 1, comm: swapper Not tainted (2.6.23 #3)
[   34.660086] EIP: 0060:[<7840840e>] EFLAGS: 00010046 CPU: 0
[   34.665548] EIP is at blk_rq_map_sg+0x8e/0x190
[   34.669965] EAX: 00000000 EBX: 7c885180 ECX: 00000004 EDX: 033b6000
[   34.676205] ESI: 00001000 EDI: 00000008 EBP: 00000000 ESP: 7b4219b8
[   34.682444]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   34.687818] Process swapper (pid: 1, ti=7b420000 task=7b416000 task.ti=7b420000)
[   34.695010] Stack: 7b521d38 00000008 7c884000 7b520000 00002000 033b6000 7c885080 00000001 
[   34.703329]        00000001 7c885880 01000002 7c886e00 7b521d1c 7c8857c4 7b520000 784c7ae5 
[   34.711649]        7b520000 784c75ea 7c8857c4 7b524ce4 7b521d1c 7c8857c4 784e4590 7b416000 
[   34.719968] Call Trace:
[   34.722568]  [<784c7ae5>] scsi_init_io+0x55/0xe0
[   34.727161]  [<784c75ea>] scsi_get_cmd_from_req+0x2a/0x40
[   34.732534]  [<784e4590>] sd_prep_fn+0x80/0x940
[   34.737041]  [<7813661b>] __lock_acquire+0x4ab/0xe20
[   34.741981]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[   34.747007]  [<78770e30>] _spin_unlock_irq+0x20/0x30
[   34.751946]  [<78404633>] elv_dispatch_sort+0x23/0xe0
[   34.756973]  [<784041a0>] elv_next_request+0xa0/0x130
[   34.761999]  [<784c8c24>] scsi_request_fn+0x1e4/0x370
[   34.767025]  [<78120f02>] del_timer+0x62/0x70
[   34.771358]  [<784072d5>] __generic_unplug_device+0x25/0x30
[   34.776905]  [<784075a5>] generic_unplug_device+0x15/0x30
[   34.782278]  [<78404e0c>] blk_backing_dev_unplug+0xc/0x10
[   34.787650]  [<78181e76>] sync_buffer+0x26/0x40
[   34.792157]  [<7876f6c2>] __wait_on_bit+0x42/0x70
[   34.796836]  [<78181e50>] sync_buffer+0x0/0x40
[   34.801256]  [<78181e50>] sync_buffer+0x0/0x40
[   34.805676]  [<7876f74a>] out_of_line_wait_on_bit+0x5a/0x70
[   34.811223]  [<7812adb0>] wake_bit_function+0x0/0x60
[   34.816163]  [<78181db4>] __wait_on_buffer+0x24/0x30
[   34.821102]  [<78207a27>] jread+0x1b7/0x250
[   34.825262]  [<78207bcd>] do_one_pass+0x10d/0x600
[   34.829942]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[   34.834968]  [<7820823b>] journal_recover+0x9b/0x1a0
[   34.839908]  [<7820b811>] journal_load+0x51/0xf0
[   34.844501]  [<781e6914>] ext3_fill_super+0xdd4/0x1850
[   34.849613]  [<78411cef>] snprintf+0x1f/0x30
[   34.853860]  [<7819ce70>] disk_name+0xb0/0xc0
[   34.858193]  [<78163809>] get_sb_bdev+0x109/0x130
[   34.862873]  [<7815f300>] __kmalloc_node+0x80/0x90
[   34.867639]  [<781e3a80>] ext3_get_sb+0x20/0x30
[   34.872146]  [<781e5b40>] ext3_fill_super+0x0/0x1850
[   34.877085]  [<78163315>] vfs_kern_mount+0xb5/0x130
[   34.881938]  [<781633ed>] do_kern_mount+0x3d/0xe0
[   34.886618]  [<78177c57>] do_mount+0x5e7/0x710
[   34.891038]  [<78770fe5>] _spin_unlock_irqrestore+0x55/0x70
[   34.896584]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[   34.901610]  [<78110935>] change_page_attr+0x3d5/0x400
[   34.906724]  [<7811099a>] kernel_map_pages+0x3a/0x90
[   34.911663]  [<7814972f>] get_page_from_freelist+0x1ff/0x3e0
[   34.917296]  [<7814a2cf>] __alloc_pages+0x5f/0x380
[   34.922063]  [<7814a61e>] __get_free_pages+0x2e/0x50
[   34.927002]  [<78176660>] copy_mount_options+0x40/0x140
[   34.932202]  [<78177df2>] sys_mount+0x72/0xb0
[   34.936535]  [<78a14d39>] mount_block_root+0x89/0x260
[   34.941561]  [<7816b4c7>] sys_mknod+0x27/0x30
[   34.945894]  [<78a14f56>] mount_root+0x46/0x60
[   34.950314]  [<78a1501c>] prepare_namespace+0xac/0x170
[   34.955427]  [<7816000f>] sys_access+0x1f/0x30
[   34.959846]  [<78a147ae>] kernel_init+0x15e/0x280
[   34.964526]  [<78a14650>] kernel_init+0x0/0x280
[   34.969033]  [<78103a97>] kernel_thread_helper+0x7/0x10
[   34.974233]  =======================
[   34.977785] Code: 44 24 20 88 44 24 2b eb 54 8d 74 26 00 83 44 24 04 10 8b 7c 24 04 8b 07 a8 01 0f 85 fb 00 00 00 31 c0 b9 04 00 00 00 8b 7c 24 04 <f3> ab 8b 03 8b 54 24 04 89 02 89 72 0c 8b 43 08 89 42 04 83 44 
[   34.996590] EIP: [<7840840e>] blk_rq_map_sg+0x8e/0x190 SS:ESP 0068:7b4219b8
[   35.003525] Kernel panic - not syncing: Attempted to kill init!

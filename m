Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYIERYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYIERYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYIERYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:24:24 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:58112 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYIERYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vg7YkgCxI+QNWR3F0b3l9lUrOFufWS9u14q/UG39A7RC9Vc0WEuJdzvyVjy2j5nsfq
         NLv4A3B2mLeekdjcG4i74tbPFPsS+7smF0AUY6uIlbBKsAGnOb9Eh+3pcsJkhA6ty4cQ
         N73zahx6strtADacu45yrb2hEm1uZ0wvOBoi8=
Date: Fri, 5 Sep 2008 21:26:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: 2.6.27-rc5-mm1: list corruption during blk_add_timer()
Message-ID: <20080905172602.GC11569@x200.localdomain>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904224004.d3dd3076.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, send to Andrew whatever you fixed in git://git.kernel.dk/linux-2.6-block.git for-2.6.28

[   24.567512] ------------[ cut here ]------------
[   24.567619] WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
[   24.567722] list_add corruption. prev->next should be next (ffff88017f9b8420), but was ffff88017f9b8588. (prev=ffff88017f9b8858).
[   24.567882] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   24.568925] Pid: 3366, comm: runscript.sh Tainted: G        W 2.6.27-rc5-mm1 #1
[   24.569071] Call Trace:
[   24.569168]  [<ffffffff802328b7>] warn_slowpath+0xb7/0xe0
[   24.569268]  [<ffffffff8026b321>] ? mempool_alloc_slab+0x11/0x20
[   24.569369]  [<ffffffff8026b47a>] ? mempool_alloc+0x4a/0x130
[   24.569470]  [<ffffffff80291fb7>] ? kmem_cache_alloc+0x67/0xd0
[   24.569571]  [<ffffffff80316390>] ? sg_init_table+0x20/0x80
[   24.569670]  [<ffffffff8031646c>] ? __sg_alloc_table+0x7c/0x140
[   24.569772]  [<ffffffff80388151>] ? scsi_init_sgtable+0x51/0xb0
[   24.569872]  [<ffffffff8038841f>] ? scsi_init_io+0x1f/0xd0
[   24.569971]  [<ffffffff80390d4c>] ? sd_prep_fn+0x5c/0x580
[   24.570069]  [<ffffffff80317f05>] __list_add+0x95/0xa0
[   24.570167]  [<ffffffff80304f10>] blk_add_timer+0x50/0xd0
[   24.570266]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   24.570374]  [<ffffffff80300a67>] __generic_unplug_device+0x27/0x30
[   24.570484]  [<ffffffff80301201>] ? generic_unplug_device+0x21/0x40
[   24.570586]  [<ffffffff80301209>] generic_unplug_device+0x29/0x40
[   24.570688]  [<ffffffff802ff012>] blk_unplug+0x12/0x20
[   24.570785]  [<ffffffff802ff02d>] blk_backing_dev_unplug+0xd/0x10
[   24.570887]  [<ffffffff802b6f2e>] block_sync_page+0x3e/0x50
[   24.570987]  [<ffffffff802686b9>] sync_page+0x39/0x60
[   24.571083]  [<ffffffff8026a319>] sync_page_killable+0x9/0x40
[   24.571184]  [<ffffffff80430efe>] __wait_on_bit_lock+0x4e/0x80
[   24.571284]  [<ffffffff8026a310>] ? sync_page_killable+0x0/0x40
[   24.571386]  [<ffffffff802685f5>] __lock_page_killable+0x65/0x70
[   24.571487]  [<ffffffff80248180>] ? wake_bit_function+0x0/0x30
[   24.571595]  [<ffffffff8026a6c8>] generic_file_aio_read+0x378/0x660
[   24.571699]  [<ffffffff80296bf1>] do_sync_read+0xf1/0x130
[   24.571797]  [<ffffffff80248140>] ? autoremove_wake_function+0x0/0x40
[   24.571909]  [<ffffffff802568dd>] ? trace_hardirqs_on+0xd/0x10
[   24.572011]  [<ffffffff80433852>] ? _spin_unlock_irqrestore+0x42/0x80
[   24.572114]  [<ffffffff80297357>] vfs_read+0xa7/0xe0
[   24.572211]  [<ffffffff8029b53a>] kernel_read+0x3a/0x60
[   24.572309]  [<ffffffff8029b64c>] prepare_binprm+0xec/0x120
[   24.572408]  [<ffffffff8029c727>] do_execve+0x197/0x280
[   24.572506]  [<ffffffff80209b49>] sys_execve+0x49/0x80
[   24.572604]  [<ffffffff8020bb0a>] stub_execve+0x6a/0xc0
[   24.572701] ---[ end trace 4eaa2a86a8e2da22 ]---
[   27.409101] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[   30.709439] ------------[ cut here ]------------
[   30.709545] WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
[   30.709648] list_add corruption. prev->next should be next (ffff88017f9b8420), but was ffff88017f9b8588. (prev=ffff88017f9b8858).
[   30.709806] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   30.710824] Pid: 3821, comm: bash Tainted: G        W 2.6.27-rc5-mm1 #1
[   30.712432] Call Trace:
[   30.712527]  [<ffffffff802328b7>] warn_slowpath+0xb7/0xe0
[   30.712626]  [<ffffffff8026b321>] ? mempool_alloc_slab+0x11/0x20
[   30.712728]  [<ffffffff8026b47a>] ? mempool_alloc+0x4a/0x130
[   30.712757]  [<ffffffff80291fb7>] ? kmem_cache_alloc+0x67/0xd0
[   30.712757]  [<ffffffff80316390>] ? sg_init_table+0x20/0x80
[   30.712757]  [<ffffffff8031646c>] ? __sg_alloc_table+0x7c/0x140
[   30.712757]  [<ffffffff80388151>] ? scsi_init_sgtable+0x51/0xb0
[   30.712757]  [<ffffffff8038841f>] ? scsi_init_io+0x1f/0xd0
[   30.712757]  [<ffffffff80390d4c>] ? sd_prep_fn+0x5c/0x580
[   30.712757]  [<ffffffff80317f05>] __list_add+0x95/0xa0
[   30.712757]  [<ffffffff80304f10>] blk_add_timer+0x50/0xd0
[   30.712757]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   30.712757]  [<ffffffff80300a67>] __generic_unplug_device+0x27/0x30
[   30.712757]  [<ffffffff80301201>] ? generic_unplug_device+0x21/0x40
[   30.712757]  [<ffffffff80301209>] generic_unplug_device+0x29/0x40
[   30.712757]  [<ffffffff802ff012>] blk_unplug+0x12/0x20
[   30.712757]  [<ffffffff802ff02d>] blk_backing_dev_unplug+0xd/0x10
[   30.712757]  [<ffffffff802b6f2e>] block_sync_page+0x3e/0x50
[   30.712757]  [<ffffffff802686b9>] sync_page+0x39/0x60
[   30.712757]  [<ffffffff8026a319>] sync_page_killable+0x9/0x40
[   30.712757]  [<ffffffff80430efe>] __wait_on_bit_lock+0x4e/0x80
[   30.712757]  [<ffffffff8026a310>] ? sync_page_killable+0x0/0x40
[   30.712757]  [<ffffffff802685f5>] __lock_page_killable+0x65/0x70
[   30.712757]  [<ffffffff80248180>] ? wake_bit_function+0x0/0x30
[   30.712757]  [<ffffffff8026a6c8>] generic_file_aio_read+0x378/0x660
[   30.712757]  [<ffffffff80296bf1>] do_sync_read+0xf1/0x130
[   30.712757]  [<ffffffff80248140>] ? autoremove_wake_function+0x0/0x40
[   30.712757]  [<ffffffff802568dd>] ? trace_hardirqs_on+0xd/0x10
[   30.712757]  [<ffffffff80433852>] ? _spin_unlock_irqrestore+0x42/0x80
[   30.712757]  [<ffffffff80297357>] vfs_read+0xa7/0xe0
[   30.712757]  [<ffffffff8029b53a>] kernel_read+0x3a/0x60
[   30.712757]  [<ffffffff8029b64c>] prepare_binprm+0xec/0x120
[   30.712757]  [<ffffffff8029c727>] do_execve+0x197/0x280
[   30.712757]  [<ffffffff80209b49>] sys_execve+0x49/0x80
[   30.712757]  [<ffffffff8020bb0a>] stub_execve+0x6a/0xc0
[   30.712757] ---[ end trace 4eaa2a86a8e2da22 ]---
[   31.690008] eth0: no IPv6 routers present
[   45.000111] ------------[ cut here ]------------
[   45.000214] WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
[   45.000317] list_add corruption. prev->next should be next (ffff88017f9b8420), but was ffff88017f9b8588. (prev=ffff88017f9b8858).
[   45.000475] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   45.001489] Pid: 193, comm: pdflush Tainted: G        W 2.6.27-rc5-mm1 #1
[   45.001594] Call Trace:
[   45.001683]  [<ffffffff802328b7>] warn_slowpath+0xb7/0xe0
[   45.001783]  [<ffffffff8026b321>] ? mempool_alloc_slab+0x11/0x20
[   45.001885]  [<ffffffff8026b47a>] ? mempool_alloc+0x4a/0x130
[   45.001986]  [<ffffffff80291fb7>] ? kmem_cache_alloc+0x67/0xd0
[   45.002088]  [<ffffffff80316390>] ? sg_init_table+0x20/0x80
[   45.002187]  [<ffffffff8031646c>] ? __sg_alloc_table+0x7c/0x140
[   45.002289]  [<ffffffff80388151>] ? scsi_init_sgtable+0x51/0xb0
[   45.002390]  [<ffffffff8038841f>] ? scsi_init_io+0x1f/0xd0
[   45.002490]  [<ffffffff80390d4c>] ? sd_prep_fn+0x5c/0x580
[   45.002589]  [<ffffffff80317f05>] __list_add+0x95/0xa0
[   45.002688]  [<ffffffff80304f10>] blk_add_timer+0x50/0xd0
[   45.002787]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   45.002888]  [<ffffffff80300a67>] __generic_unplug_device+0x27/0x30
[   45.002990]  [<ffffffff802feb48>] elv_insert+0xe8/0x1a0
[   45.003089]  [<ffffffff802feca2>] __elv_add_request+0xa2/0xc0
[   45.003189]  [<ffffffff80301313>] __make_request+0xf3/0x420
[   45.003288]  [<ffffffff802ffb26>] generic_make_request+0x126/0x2a0
[   45.003392]  [<ffffffff802bc360>] ? bvec_alloc_bs+0x60/0xc0
[   45.003491]  [<ffffffff803016dd>] submit_bio+0x9d/0x140
[   45.003590]  [<ffffffff802b779c>] submit_bh+0xdc/0x130
[   45.003688]  [<ffffffff802b9ab8>] __block_write_full_page+0x198/0x310
[   45.003792]  [<ffffffff802be7d0>] ? blkdev_get_block+0x0/0x70
[   45.003891]  [<ffffffff802be7d0>] ? blkdev_get_block+0x0/0x70
[   45.003992]  [<ffffffff802b9cce>] block_write_full_page+0x9e/0x120
[   45.004094]  [<ffffffff802be253>] blkdev_writepage+0x13/0x20
[   45.004194]  [<ffffffff8026f6f5>] __writepage+0x15/0x40
[   45.004292]  [<ffffffff8026fd8b>] write_cache_pages+0x26b/0x3e0
[   45.004393]  [<ffffffff8026f6e0>] ? __writepage+0x0/0x40
[   45.004492]  [<ffffffff8026ff22>] generic_writepages+0x22/0x30
[   45.004593]  [<ffffffff8026ff5b>] do_writepages+0x2b/0x40
[   45.004692]  [<ffffffff802b2eb4>] __writeback_single_inode+0xa4/0x330
[   45.004796]  [<ffffffff802b360f>] generic_sync_sb_inodes+0x1ff/0x2f0
[   45.004899]  [<ffffffff802b3725>] sync_sb_inodes+0x25/0x30
[   45.004998]  [<ffffffff802b3986>] writeback_inodes+0x96/0xe0
[   45.005098]  [<ffffffff80270b04>] wb_kupdate+0xa4/0x120
[   45.005196]  [<ffffffff80270ff0>] ? pdflush+0x0/0x1e0
[   45.005293]  [<ffffffff802710fe>] pdflush+0x10e/0x1e0
[   45.005390]  [<ffffffff80270a60>] ? wb_kupdate+0x0/0x120
[   45.005488]  [<ffffffff80270ff0>] ? pdflush+0x0/0x1e0
[   45.005585]  [<ffffffff80247d1d>] kthread+0x4d/0x80
[   45.005682]  [<ffffffff8020c769>] child_rip+0xa/0x11
[   45.005779]  [<ffffffff8020bd13>] ? restore_args+0x0/0x30
[   45.005877]  [<ffffffff80247cd0>] ? kthread+0x0/0x80
[   45.005973]  [<ffffffff8020c75f>] ? child_rip+0x0/0x11
[   45.006070] ---[ end trace 4eaa2a86a8e2da22 ]---
[   50.070449] ------------[ cut here ]------------
[   50.070554] kernel BUG at block/blk-timeout.c:132!
[   50.070649] invalid opcode: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
[   50.070915] last sysfs file: /sys/kernel/uevent_seqnum
[   50.071012] CPU 0 
[   50.071135] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   50.072160] Pid: 0, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
[   50.072263] RIP: 0010:[<ffffffff80304f70>]  [<ffffffff80304f70>] blk_add_timer+0xb0/0xd0
[   50.072450] RSP: 0018:ffffffff805abc70  EFLAGS: 00010002
[   50.072548] RAX: ffff88017f9b8300 RBX: ffff88017f9b8720 RCX: 0000000000000000
[   50.072661] RDX: 0000000000000000 RSI: ffff88017f9b8720 RDI: ffff88017f9b8858
[   50.072766] RBP: ffffffff805abc80 R08: 0000000000000000 R09: 0000000000000001
[   50.072876] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88017f9b8000
[   50.072981] R13: ffff88017fbab0d8 R14: ffff88017f9b8000 R15: ffff88017f9b8000
[   50.073086] FS:  0000000000000000(0000) GS:ffffffff80553580(0000) knlGS:0000000000000000
[   50.073228] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   50.073327] CR2: 00000000018599f8 CR3: 000000017b9a5000 CR4: 00000000000006e0
[   50.073432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   50.073537] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   50.073641] Process swapper (pid: 0, threadinfo ffffffff80558000, task ffffffff80526420)
[   50.073783] Stack:  ffff88017f9b8720 ffff88017fba9048 ffffffff805abcd0 ffffffff80389631
[   50.074141]  0000000000000286 ffff88017f9b8300 ffff88017fbab240 ffff88017f9b8000
[   50.074443]  0000000000000286 ffff88017fbab0d8 ffff88017f9b8000 ffff88017fba90b0
[   50.074750] Call Trace:
[   50.074834]  <IRQ>  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   50.074989]  [<ffffffff803003a2>] blk_invoke_request_fn+0x82/0x130
[   50.075090]  [<ffffffff80300985>] __blk_run_queue+0x25/0x30
[   50.075190]  [<ffffffff803009bb>] blk_run_queue+0x2b/0x50
[   50.075289]  [<ffffffff80387795>] scsi_run_queue+0x195/0x2e0
[   50.075388]  [<ffffffff80387fbd>] scsi_next_command+0x3d/0x60
[   50.075488]  [<ffffffff8038828d>] scsi_end_request+0x8d/0xb0
[   50.075588]  [<ffffffff803890da>] scsi_io_completion+0x8a/0x410
[   50.075690]  [<ffffffff80382baf>] scsi_finish_command+0x8f/0xc0
[   50.075790]  [<ffffffff8038950e>] scsi_softirq_done+0xae/0x130
[   50.075897]  [<ffffffff80304cf3>] blk_done_softirq+0x83/0xa0
[   50.075998]  [<ffffffff80237ef7>] __do_softirq+0x67/0xe0
[   50.076096]  [<ffffffff8020cacc>] call_softirq+0x1c/0x30
[   50.076194]  [<ffffffff8020f1c5>] do_softirq+0x65/0xa0
[   50.076299]  [<ffffffff80237e09>] irq_exit+0x99/0xb0
[   50.076396]  [<ffffffff8020f2e1>] do_IRQ+0xa1/0x130
[   50.076492]  [<ffffffff8020bc66>] ret_from_intr+0x0/0xf
[   50.076588]  <EOI>  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.076734]  [<ffffffff802136fc>] ? mwait_idle+0x4c/0x60
[   50.076832]  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.076930]  [<ffffffff8020a426>] ? cpu_idle+0x46/0x90
[   50.077034]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.077131] Code: 5c c9 c3 48 89 c6 e8 20 82 f3 ff 5b 41 5c c9 c3 41 8b 84 24 e8 03 00 00 48 8b 15 1c 19 25 00 48 01 d0 48 89 83 30 01 00 00 eb 8f <0f> 0b eb fe 48 c7 83 30 01 00 00 01 00 00 00 eb a5 66 66 66 66 
[   50.080078] RIP  [<ffffffff80304f70>] blk_add_timer+0xb0/0xd0
[   50.080220]  RSP <ffffffff805abc70>
[   50.080310] Kernel panic - not syncing: Fatal exception in interrupt
[   50.080412] Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc5-mm1 #1
[   50.080416] Call Trace:
[   50.080416]  <IRQ>  [<ffffffff80232a0a>] panic+0xaa/0x180
[   50.080416]  [<ffffffff8020d3e5>] ? show_registers+0x95/0x2b0
[   50.080416]  [<ffffffff803695af>] ? do_unblank_screen+0x1f/0x140
[   50.080416]  [<ffffffff803696db>] ? unblank_screen+0xb/0x10
[   50.080416]  [<ffffffff8020cc92>] oops_end+0xb2/0xc0
[   50.080416]  [<ffffffff8020d96e>] die+0x5e/0x90
[   50.080416]  [<ffffffff8020db50>] do_trap+0x130/0x150
[   50.080416]  [<ffffffff8020e81c>] do_invalid_op+0x9c/0xc0
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff8025437d>] ? trace_hardirqs_off+0xd/0x10
[   50.080416]  [<ffffffff80433852>] ? _spin_unlock_irqrestore+0x42/0x80
[   50.080416]  [<ffffffff80383423>] ? scsi_get_command+0x83/0xc0
[   50.080416]  [<ffffffff80433c5d>] error_exit+0x0/0xa9
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   50.080416]  [<ffffffff803003a2>] blk_invoke_request_fn+0x82/0x130
[   50.080416]  [<ffffffff80300985>] __blk_run_queue+0x25/0x30
[   50.080416]  [<ffffffff803009bb>] blk_run_queue+0x2b/0x50
[   50.080416]  [<ffffffff80387795>] scsi_run_queue+0x195/0x2e0
[   50.080416]  [<ffffffff80387fbd>] scsi_next_command+0x3d/0x60
[   50.080416]  [<ffffffff8038828d>] scsi_end_request+0x8d/0xb0
[   50.080416]  [<ffffffff803890da>] scsi_io_completion+0x8a/0x410
[   50.080416]  [<ffffffff80382baf>] scsi_finish_command+0x8f/0xc0
[   50.080416]  [<ffffffff8038950e>] scsi_softirq_done+0xae/0x130
[   50.080416]  [<ffffffff80304cf3>] blk_done_softirq+0x83/0xa0
[   50.080416]  [<ffffffff80237ef7>] __do_softirq+0x67/0xe0
[   50.080416]  [<ffffffff8020cacc>] call_softirq+0x1c/0x30
[   50.080416]  [<ffffffff8020f1c5>] do_softirq+0x65/0xa0
[   50.080416]  [<ffffffff80237e09>] irq_exit+0x99/0xb0
[   50.080416]  [<ffffffff8020f2e1>] do_IRQ+0xa1/0x130
[   50.080416]  [<ffffffff8020bc66>] ret_from_intr+0x0/0xf
[   50.080416]  <EOI>  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff802136fc>] ? mwait_idle+0x4c/0x60
[   50.080416]  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff8020a426>] ? cpu_idle+0x46/0x90
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416] ------------[ cut here ]------------
[   50.080416] WARNING: at kernel/smp.c:332 smp_call_function_mask+0x20e/0x220()
[   50.080416] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   50.080416] Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc5-mm1 #1
[   50.080416] Call Trace:
[   50.080416]  <IRQ>  [<ffffffff8023293f>] warn_on_slowpath+0x5f/0x80
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff80233a17>] ? printk+0x67/0x70
[   50.080416]  [<ffffffff80233a17>] ? printk+0x67/0x70
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff8025de2e>] smp_call_function_mask+0x20e/0x220
[   50.080416]  [<ffffffff8021cfe8>] ? touch_nmi_watchdog+0x58/0x70
[   50.080416]  [<ffffffff8020cb9c>] ? printk_address+0x2c/0x30
[   50.080416]  [<ffffffff80245c42>] ? __kernel_text_address+0x22/0x40
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff8020d0d8>] ? dump_trace+0x328/0x3f0
[   50.080416]  [<ffffffff8020d1f4>] ? show_trace_log_lvl+0x54/0x70
[   50.080416]  [<ffffffff8021b770>] ? stop_this_cpu+0x0/0x30
[   50.080416]  [<ffffffff8025de7a>] smp_call_function+0x3a/0x70
[   50.080416]  [<ffffffff8021b800>] native_smp_send_stop+0x30/0x60
[   50.080416]  [<ffffffff80232a17>] panic+0xb7/0x180
[   50.080416]  [<ffffffff8020d3e5>] ? show_registers+0x95/0x2b0
[   50.080416]  [<ffffffff803695af>] ? do_unblank_screen+0x1f/0x140
[   50.080416]  [<ffffffff803696db>] ? unblank_screen+0xb/0x10
[   50.080416]  [<ffffffff8020cc92>] oops_end+0xb2/0xc0
[   50.080416]  [<ffffffff8020d96e>] die+0x5e/0x90
[   50.080416]  [<ffffffff8020db50>] do_trap+0x130/0x150
[   50.080416]  [<ffffffff8020e81c>] do_invalid_op+0x9c/0xc0
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff8025437d>] ? trace_hardirqs_off+0xd/0x10
[   50.080416]  [<ffffffff80433852>] ? _spin_unlock_irqrestore+0x42/0x80
[   50.080416]  [<ffffffff80383423>] ? scsi_get_command+0x83/0xc0
[   50.080416]  [<ffffffff80433c5d>] error_exit+0x0/0xa9
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   50.080416]  [<ffffffff803003a2>] blk_invoke_request_fn+0x82/0x130
[   50.080416]  [<ffffffff80300985>] __blk_run_queue+0x25/0x30
[   50.080416]  [<ffffffff803009bb>] blk_run_queue+0x2b/0x50
[   50.080416]  [<ffffffff80387795>] scsi_run_queue+0x195/0x2e0
[   50.080416]  [<ffffffff80387fbd>] scsi_next_command+0x3d/0x60
[   50.080416]  [<ffffffff8038828d>] scsi_end_request+0x8d/0xb0
[   50.080416]  [<ffffffff803890da>] scsi_io_completion+0x8a/0x410
[   50.080416]  [<ffffffff80382baf>] scsi_finish_command+0x8f/0xc0
[   50.080416]  [<ffffffff8038950e>] scsi_softirq_done+0xae/0x130
[   50.080416]  [<ffffffff80304cf3>] blk_done_softirq+0x83/0xa0
[   50.080416]  [<ffffffff80237ef7>] __do_softirq+0x67/0xe0
[   50.080416]  [<ffffffff8020cacc>] call_softirq+0x1c/0x30
[   50.080416]  [<ffffffff8020f1c5>] do_softirq+0x65/0xa0
[   50.080416]  [<ffffffff80237e09>] irq_exit+0x99/0xb0
[   50.080416]  [<ffffffff8020f2e1>] do_IRQ+0xa1/0x130
[   50.080416]  [<ffffffff8020bc66>] ret_from_intr+0x0/0xf
[   50.080416]  <EOI>  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff802136fc>] ? mwait_idle+0x4c/0x60
[   50.080416]  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff8020a426>] ? cpu_idle+0x46/0x90
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416] ---[ end trace 4eaa2a86a8e2da22 ]---
[   50.080416] ------------[ cut here ]------------
[   50.080416] WARNING: at kernel/smp.c:219 smp_call_function_single+0x118/0x140()
[   50.080416] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
[   50.080416] Pid: 0, comm: swapper Tainted: G      D W 2.6.27-rc5-mm1 #1
[   50.080416] Call Trace:
[   50.080416]  <IRQ>  [<ffffffff8023293f>] warn_on_slowpath+0x5f/0x80
[   50.080416]  [<ffffffff8020e132>] ? dump_stack+0x72/0x80
[   50.080416]  [<ffffffff8025e857>] ? print_modules+0xb7/0xd0
[   50.080416]  [<ffffffff8023268e>] ? print_oops_end_marker+0x1e/0x20
[   50.080416]  [<ffffffff8023294f>] ? warn_on_slowpath+0x6f/0x80
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff80233a17>] ? printk+0x67/0x70
[   50.080416]  [<ffffffff8025dbf8>] smp_call_function_single+0x118/0x140
[   50.080416]  [<ffffffff8021b770>] ? stop_this_cpu+0x0/0x30
[   50.080416]  [<ffffffff8025ddca>] smp_call_function_mask+0x1aa/0x220
[   50.080416]  [<ffffffff8021cfe8>] ? touch_nmi_watchdog+0x58/0x70
[   50.080416]  [<ffffffff8020cb9c>] ? printk_address+0x2c/0x30
[   50.080416]  [<ffffffff80245c42>] ? __kernel_text_address+0x22/0x40
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416]  [<ffffffff8020d0d8>] ? dump_trace+0x328/0x3f0
[   50.080416]  [<ffffffff8020d1f4>] ? show_trace_log_lvl+0x54/0x70
[   50.080416]  [<ffffffff8021b770>] ? stop_this_cpu+0x0/0x30
[   50.080416]  [<ffffffff8025de7a>] smp_call_function+0x3a/0x70
[   50.080416]  [<ffffffff8021b800>] native_smp_send_stop+0x30/0x60
[   50.080416]  [<ffffffff80232a17>] panic+0xb7/0x180
[   50.080416]  [<ffffffff8020d3e5>] ? show_registers+0x95/0x2b0
[   50.080416]  [<ffffffff803695af>] ? do_unblank_screen+0x1f/0x140
[   50.080416]  [<ffffffff803696db>] ? unblank_screen+0xb/0x10
[   50.080416]  [<ffffffff8020cc92>] oops_end+0xb2/0xc0
[   50.080416]  [<ffffffff8020d96e>] die+0x5e/0x90
[   50.080416]  [<ffffffff8020db50>] do_trap+0x130/0x150
[   50.080416]  [<ffffffff8020e81c>] do_invalid_op+0x9c/0xc0
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff8025437d>] ? trace_hardirqs_off+0xd/0x10
[   50.080416]  [<ffffffff80433852>] ? _spin_unlock_irqrestore+0x42/0x80
[   50.080416]  [<ffffffff80383423>] ? scsi_get_command+0x83/0xc0
[   50.080416]  [<ffffffff80433c5d>] error_exit+0x0/0xa9
[   50.080416]  [<ffffffff80304f70>] ? blk_add_timer+0xb0/0xd0
[   50.080416]  [<ffffffff80389631>] scsi_request_fn+0xa1/0x380
[   50.080416]  [<ffffffff803003a2>] blk_invoke_request_fn+0x82/0x130
[   50.080416]  [<ffffffff80300985>] __blk_run_queue+0x25/0x30
[   50.080416]  [<ffffffff803009bb>] blk_run_queue+0x2b/0x50
[   50.080416]  [<ffffffff80387795>] scsi_run_queue+0x195/0x2e0
[   50.080416]  [<ffffffff80387fbd>] scsi_next_command+0x3d/0x60
[   50.080416]  [<ffffffff8038828d>] scsi_end_request+0x8d/0xb0
[   50.080416]  [<ffffffff803890da>] scsi_io_completion+0x8a/0x410
[   50.080416]  [<ffffffff80382baf>] scsi_finish_command+0x8f/0xc0
[   50.080416]  [<ffffffff8038950e>] scsi_softirq_done+0xae/0x130
[   50.080416]  [<ffffffff80304cf3>] blk_done_softirq+0x83/0xa0
[   50.080416]  [<ffffffff80237ef7>] __do_softirq+0x67/0xe0
[   50.080416]  [<ffffffff8020cacc>] call_softirq+0x1c/0x30
[   50.080416]  [<ffffffff8020f1c5>] do_softirq+0x65/0xa0
[   50.080416]  [<ffffffff80237e09>] irq_exit+0x99/0xb0
[   50.080416]  [<ffffffff8020f2e1>] do_IRQ+0xa1/0x130
[   50.080416]  [<ffffffff8020bc66>] ret_from_intr+0x0/0xf
[   50.080416]  <EOI>  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff802136fc>] ? mwait_idle+0x4c/0x60
[   50.080416]  [<ffffffff802136f3>] ? mwait_idle+0x43/0x60
[   50.080416]  [<ffffffff8020a426>] ? cpu_idle+0x46/0x90
[   50.080416]  [<ffffffff804279d0>] ? rest_init+0x70/0x80
[   50.080416] ---[ end trace 4eaa2a86a8e2da22 ]---


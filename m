Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYICPhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYICPhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYICPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:37:41 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:58179 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYICPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nfeQZ91gpbFs7gGYGeQDNc7YEadkzuE4fc4YHHGMUs+z7EyzhhNGM3fdejqfUlu6xu
         lGudvQaaA2BHiHnWu4Lm8400CIWZWs17nX1yAwQeQ9alehavlgBCwhKVx/GXk3u4uQRQ
         i3NIxOwLkamyIawULJM/MY6A1a69V54XqqwfE=
Date: Wed, 3 Sep 2008 19:39:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: axboe@kernel.dk
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: list corruption in next-20080903
Message-ID: <20080903153915.GB5604@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reproducible, happens during init scripts.

------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 4006, comm: bash Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
 [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
 [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
 [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
 [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
 [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
 [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
 [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
 [<ffffffff802fda31>] ? generic_unplug_device+0x21/0x40
 [<ffffffff802fda39>] generic_unplug_device+0x29/0x40
 [<ffffffff802fb842>] blk_unplug+0x12/0x20
 [<ffffffff802fb85d>] blk_backing_dev_unplug+0xd/0x10
 [<ffffffff802b630e>] block_sync_page+0x3e/0x50
 [<ffffffff80267ff9>] sync_page+0x39/0x60
 [<ffffffff80269c29>] sync_page_killable+0x9/0x40
 [<ffffffff8042e61e>] __wait_on_bit_lock+0x4e/0x80
 [<ffffffff80269c20>] ? sync_page_killable+0x0/0x40
 [<ffffffff80267f35>] __lock_page_killable+0x65/0x70
 [<ffffffff802483a0>] ? wake_bit_function+0x0/0x30
 [<ffffffff8026a018>] generic_file_aio_read+0x3b8/0x660
 [<ffffffff802938b1>] do_sync_read+0xf1/0x130
 [<ffffffff80248360>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80256add>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80430ef2>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff80294017>] vfs_read+0xa7/0xe0
 [<ffffffff8029820a>] kernel_read+0x3a/0x60
 [<ffffffff8029831c>] prepare_binprm+0xec/0x120
 [<ffffffff80299467>] do_execve+0x197/0x280
 [<ffffffff80209b69>] sys_execve+0x49/0x80
 [<ffffffff8020bb2a>] stub_execve+0x6a/0xc0
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 4225, comm: start-stop-daem Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
 [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
 [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
 [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
 [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
 [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
 [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
 [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
 [<ffffffff802fda31>] ? generic_unplug_device+0x21/0x40
 [<ffffffff802fda39>] generic_unplug_device+0x29/0x40
 [<ffffffff802fb842>] blk_unplug+0x12/0x20
 [<ffffffff802fb85d>] blk_backing_dev_unplug+0xd/0x10
 [<ffffffff802b7cf9>] sync_buffer+0x39/0x50
 [<ffffffff8042e735>] __wait_on_bit+0x55/0x80
 [<ffffffff802b7cc0>] ? sync_buffer+0x0/0x50
 [<ffffffff802b7cc0>] ? sync_buffer+0x0/0x50
 [<ffffffff8042e7d8>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff802483a0>] ? wake_bit_function+0x0/0x30
 [<ffffffff802b7c36>] __wait_on_buffer+0x26/0x30
 [<ffffffff802dd1e6>] __ext3_get_inode_loc+0x296/0x330
 [<ffffffff802e0701>] ext3_iget+0x51/0x3c0
 [<ffffffff802e3fd8>] ext3_lookup+0xd8/0x100
 [<ffffffff8029c8ca>] do_lookup+0x1da/0x220
 [<ffffffff8029df37>] __link_path_walk+0x7c7/0xd40
 [<ffffffff8028ddc1>] ? init_object+0x51/0x90
 [<ffffffff8029e507>] path_walk+0x57/0xb0
 [<ffffffff8029e639>] do_path_lookup+0x89/0x170
 [<ffffffff8029d536>] ? getname+0xe6/0x210
 [<ffffffff8029f21e>] user_path_at+0x4e/0xa0
 [<ffffffff80256add>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80297288>] vfs_stat_fd+0x28/0x60
 [<ffffffff802974e7>] sys_newstat+0x27/0x50
 [<ffffffff8043048d>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff80430417>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b6fb>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
eth0: no IPv6 routers present
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 193, comm: pdflush Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
 [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
 [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
 [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
 [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
 [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
 [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
 [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
 [<ffffffff802fb378>] elv_insert+0xe8/0x1a0
 [<ffffffff802fb4d2>] __elv_add_request+0xa2/0xc0
 [<ffffffff802fdb43>] __make_request+0xf3/0x420
 [<ffffffff802fc356>] generic_make_request+0x126/0x2a0
 [<ffffffff802bb6e0>] ? bvec_alloc_bs+0x60/0xc0
 [<ffffffff802fdf0d>] submit_bio+0x9d/0x140
 [<ffffffff802b6b3c>] submit_bh+0xdc/0x130
 [<ffffffff802b8e36>] __block_write_full_page+0x196/0x310
 [<ffffffff802bdb20>] ? blkdev_get_block+0x0/0x70
 [<ffffffff802bdb20>] ? blkdev_get_block+0x0/0x70
 [<ffffffff802b904e>] block_write_full_page+0x9e/0x120
 [<ffffffff802bd643>] blkdev_writepage+0x13/0x20
 [<ffffffff8026eef5>] __writepage+0x15/0x40
 [<ffffffff8026f5cb>] write_cache_pages+0x26b/0x3d0
 [<ffffffff8026eee0>] ? __writepage+0x0/0x40
 [<ffffffff8026f752>] generic_writepages+0x22/0x30
 [<ffffffff8026f78b>] do_writepages+0x2b/0x40
 [<ffffffff802b22a4>] __writeback_single_inode+0xa4/0x330
 [<ffffffff802b29ff>] generic_sync_sb_inodes+0x1ff/0x2f0
 [<ffffffff802b2af9>] sync_sb_inodes+0x9/0x10
 [<ffffffff802b2d56>] writeback_inodes+0x96/0xe0
 [<ffffffff802702b4>] wb_kupdate+0xa4/0x120
 [<ffffffff802707a0>] ? pdflush+0x0/0x1e0
 [<ffffffff802708ae>] pdflush+0x10e/0x1e0
 [<ffffffff80270210>] ? wb_kupdate+0x0/0x120
 [<ffffffff802707a0>] ? pdflush+0x0/0x1e0
 [<ffffffff80247f2d>] kthread+0x4d/0x80
 [<ffffffff8020c789>] child_rip+0xa/0x11
 [<ffffffff8020bd33>] ? restore_args+0x0/0x30
 [<ffffffff80247ee0>] ? kthread+0x0/0x80
 [<ffffffff8020c77f>] ? child_rip+0x0/0x11
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 52, comm: kblockd/0 Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
 [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
 [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
 [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
 [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
 [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
 [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
 [<ffffffff802fb810>] ? blk_unplug_work+0x0/0x20
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff802fb810>] ? blk_unplug_work+0x0/0x20
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
 [<ffffffff802fb810>] ? blk_unplug_work+0x0/0x20
 [<ffffffff802fb810>] ? blk_unplug_work+0x0/0x20
 [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
 [<ffffffff802fda31>] ? generic_unplug_device+0x21/0x40
 [<ffffffff802fda39>] generic_unplug_device+0x29/0x40
 [<ffffffff802fb824>] blk_unplug_work+0x14/0x20
 [<ffffffff8024409a>] run_workqueue+0x19a/0x250
 [<ffffffff80244048>] ? run_workqueue+0x148/0x250
 [<ffffffff80244e73>] worker_thread+0x93/0xd0
 [<ffffffff80248360>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80244de0>] ? worker_thread+0x0/0xd0
 [<ffffffff80247f2d>] kthread+0x4d/0x80
 [<ffffffff8020c789>] child_rip+0xa/0x11
 [<ffffffff8020bd33>] ? restore_args+0x0/0x30
 [<ffffffff80247ee0>] ? kthread+0x0/0x80
 [<ffffffff8020c77f>] ? child_rip+0x0/0x11
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 441, comm: kjournald Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8028d773>] ? check_object+0x223/0x250
 [<ffffffff8028ddc1>] ? init_object+0x51/0x90
 [<ffffffff802b7155>] ? __getblk+0x35/0x280
 [<ffffffff8038075f>] ? scsi_pool_alloc_command+0x4f/0x80
 [<ffffffff8028d4b8>] ? check_bytes_and_report+0x38/0xd0
 [<ffffffff8028d773>] ? check_object+0x223/0x250
 [<ffffffff80300ad3>] ? blk_recount_segments+0x43/0x60
 [<ffffffff80256add>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff802ff482>] blk_do_ordered+0xa2/0x300
 [<ffffffff8023ce06>] ? lock_timer_base+0x36/0x70
 [<ffffffff802fb0ea>] elv_next_request+0x4a/0x1f0
 [<ffffffff80386e49>] scsi_request_fn+0x209/0x380
 [<ffffffff802fb32c>] elv_insert+0x9c/0x1a0
 [<ffffffff802fb4d2>] __elv_add_request+0xa2/0xc0
 [<ffffffff802fdb43>] __make_request+0xf3/0x420
 [<ffffffff802fc356>] generic_make_request+0x126/0x2a0
 [<ffffffff802bb6e0>] ? bvec_alloc_bs+0x60/0xc0
 [<ffffffff802fdf0d>] submit_bio+0x9d/0x140
 [<ffffffff802b6b3c>] submit_bh+0xdc/0x130
 [<ffffffff802baa2b>] sync_dirty_buffer+0x5b/0xf0
 [<ffffffff802ede57>] journal_commit_transaction+0xdc7/0x1260
 [<ffffffff8023ce06>] ? lock_timer_base+0x36/0x70
 [<ffffffff8023ce84>] ? try_to_del_timer_sync+0x44/0x90
 [<ffffffff802f1c2f>] kjournald+0xdf/0x230
 [<ffffffff80248360>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802f1b50>] ? kjournald+0x0/0x230
 [<ffffffff80247f2d>] kthread+0x4d/0x80
 [<ffffffff8020c789>] child_rip+0xa/0x11
 [<ffffffff8020bd33>] ? restore_args+0x0/0x30
 [<ffffffff80247ee0>] ? kthread+0x0/0x80
 [<ffffffff8020c77f>] ? child_rip+0x0/0x11
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
list_add corruption. prev->next should be next (ffff88017fb70420), but was ffff88017fb70588. (prev=ffff88017fb70858).
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 nls_utf8 ntfs fuse sr_mod cdrom
Pid: 441, comm: kjournald Tainted: G        W 2.6.27-rc5-next-20080903 #2
Call Trace:
 [<ffffffff80232837>] warn_slowpath+0xb7/0xe0
 [<ffffffff8026ac31>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff8026ad8a>] ? mempool_alloc+0x4a/0x130
 [<ffffffff8028ec87>] ? kmem_cache_alloc+0x67/0xd0
 [<ffffffff80312bb0>] ? sg_init_table+0x20/0x80
 [<ffffffff80312c8c>] ? __sg_alloc_table+0x7c/0x140
 [<ffffffff80385801>] ? scsi_init_sgtable+0x51/0xb0
 [<ffffffff80385acf>] ? scsi_init_io+0x1f/0xd0
 [<ffffffff8038e3fc>] ? sd_prep_fn+0x5c/0x580
 [<ffffffff803145d5>] __list_add+0x95/0xa0
 [<ffffffff80301740>] blk_add_timer+0x50/0xd0
 [<ffffffff80386ce1>] scsi_request_fn+0xa1/0x380
 [<ffffffff802fd297>] __generic_unplug_device+0x27/0x30
 [<ffffffff802fda31>] ? generic_unplug_device+0x21/0x40
 [<ffffffff802fda39>] generic_unplug_device+0x29/0x40
 [<ffffffff802fb842>] blk_unplug+0x12/0x20
 [<ffffffff802fb85d>] blk_backing_dev_unplug+0xd/0x10
 [<ffffffff802b7cf9>] sync_buffer+0x39/0x50
 [<ffffffff8042e735>] __wait_on_bit+0x55/0x80
 [<ffffffff802b7cc0>] ? sync_buffer+0x0/0x50
 [<ffffffff802b7cc0>] ? sync_buffer+0x0/0x50
 [<ffffffff8042e7d8>] out_of_line_wait_on_bit+0x78/0x90
 [<ffffffff802483a0>] ? wake_bit_function+0x0/0x30
 [<ffffffff802b7c36>] __wait_on_buffer+0x26/0x30
 [<ffffffff802edb0c>] journal_commit_transaction+0xa7c/0x1260
 [<ffffffff8023ce06>] ? lock_timer_base+0x36/0x70
 [<ffffffff80256add>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8023ce84>] ? try_to_del_timer_sync+0x44/0x90
 [<ffffffff802f1c2f>] kjournald+0xdf/0x230
 [<ffffffff80248360>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802f1b50>] ? kjournald+0x0/0x230
 [<ffffffff80247f2d>] kthread+0x4d/0x80
 [<ffffffff8020c789>] child_rip+0xa/0x11
 [<ffffffff8020bd33>] ? restore_args+0x0/0x30
 [<ffffffff80247ee0>] ? kthread+0x0/0x80
 [<ffffffff8020c77f>] ? child_rip+0x0/0x11
---[ end trace 4eaa2a86a8e2da22 ]---


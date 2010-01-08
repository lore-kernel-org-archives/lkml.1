Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250Ab0AHNnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0AHNnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 08:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969Ab0AHNnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 08:43:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49564 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0AHNnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 08:43:01 -0500
MIME-Version: 1.0
Date: Fri, 8 Jan 2010 05:43:00 -0800
Message-ID: <f488382f1001080543gb8a1e1dvabff0e4879cbf87b@mail.gmail.com>
Subject: 2.6.31.9: JFS - inconsistent lock state
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed this popped up in dmesg at one point. Based on the changelog
between v2.6.31.9 and v2.6.31.10, I don't think this has been fixed
yet (I see no JFS changes in v2.6.31.10).

[ 2282.813001]
[ 2282.813004] =================================
[ 2282.813006] [ INFO: inconsistent lock state ]
[ 2282.813006] 2.6.31.9 #3
[ 2282.813006] ---------------------------------
[ 2282.813006] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 2282.813006] sh/5534 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2282.813006]  (&jfs_ip->rdwrlock#2){++++?.}, at:
[<ffffffff8121b489>] jfs_get_block+0x4c/0x21e
[ 2282.813006] {RECLAIM_FS-ON-W} state was registered at:
[ 2282.813006]   [<ffffffff81070aae>] mark_held_locks+0x52/0x70
[ 2282.813006]   [<ffffffff81070b67>] lockdep_trace_alloc+0x9b/0xb4
[ 2282.813006]   [<ffffffff810e31b8>] kmem_cache_alloc+0x36/0x12e
[ 2282.813006]   [<ffffffff8132718f>] radix_tree_preload+0x34/0x85
[ 2282.813006]   [<ffffffff810b87b5>] add_to_page_cache_locked+0x27/0xb2
[ 2282.813006]   [<ffffffff810b886d>] add_to_page_cache_lru+0x2d/0x5e
[ 2282.813006]   [<ffffffff810b89b9>] read_cache_page_async+0x75/0x129
[ 2282.813006]   [<ffffffff810b8a7f>] read_cache_page+0x12/0x49
[ 2282.813006]   [<ffffffff8122f5b0>] __get_metapage+0xdc/0x273
[ 2282.868700]   [<ffffffff812277f8>] dbAllocAG+0x13a/0x32a
[ 2282.868700]   [<ffffffff81227ef2>] dbAlloc+0x3c1/0x453
[ 2282.868700]   [<ffffffff8122e5e0>] extAlloc+0x1d5/0x46d
[ 2282.868700]   [<ffffffff8121b5da>] jfs_get_block+0x19d/0x21e
[ 2282.868700]   [<ffffffff811099d9>] nobh_write_begin+0x181/0x2f2
[ 2282.868700]   [<ffffffff8121b16b>] jfs_write_begin+0x23/0x25
[ 2282.868700]   [<ffffffff810b9253>] generic_file_buffered_write+0x12b/0x309
[ 2282.868700]   [<ffffffff810b984a>]
__generic_file_aio_write_nolock+0x254/0x289
[ 2282.868700]   [<ffffffff810b9b29>] generic_file_aio_write+0x6c/0xcc
[ 2282.868700]   [<ffffffff810e7571>] do_sync_write+0xe8/0x125
[ 2282.868700]   [<ffffffff810e7b2c>] vfs_write+0xae/0x10b
[ 2282.868700]   [<ffffffff810e7c49>] sys_write+0x4a/0x6e
[ 2282.868700]   [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[ 2282.868700]   [<ffffffffffffffff>] 0xffffffffffffffff
[ 2282.868700] irq event stamp: 4371
[ 2282.868700] hardirqs last  enabled at (4371): [<ffffffff810e3238>]
kmem_cache_alloc+0xb6/0x12e
[ 2282.868700] hardirqs last disabled at (4370): [<ffffffff810e31dd>]
kmem_cache_alloc+0x5b/0x12e
[ 2282.868700] softirqs last  enabled at (2082): [<ffffffff81051cf2>]
__do_softirq+0x1a9/0x1bf
[ 2282.868700] softirqs last disabled at (2073): [<ffffffff8100ce5c>]
call_softirq+0x1c/0x3e
[ 2282.868700]
[ 2282.868700] other info that might help us debug this:
[ 2282.868700] no locks held by sh/5534.
[ 2282.868700]
[ 2282.868700] stack backtrace:
[ 2282.868700] Pid: 5534, comm: sh Not tainted 2.6.31.9 #3
[ 2282.868700] Call Trace:
[ 2282.868700]  [<ffffffff81070822>] valid_state+0x178/0x18b
[ 2282.868700]  [<ffffffff81015ae3>] ? save_stack_trace+0x2f/0x4c
[ 2282.868700]  [<ffffffff8107108c>] ? check_usage_forwards+0x0/0x56
[ 2282.868700]  [<ffffffff81070948>] mark_lock+0x113/0x227
[ 2282.868700]  [<ffffffff810719d0>] __lock_acquire+0x2dd/0xb97
[ 2282.868700]  [<ffffffff81070862>] ? mark_lock+0x2d/0x227
[ 2282.868700]  [<ffffffff81072354>] lock_acquire+0xca/0xee
[ 2282.868700]  [<ffffffff8121b489>] ? jfs_get_block+0x4c/0x21e
[ 2282.868700]  [<ffffffff8106590c>] down_write_nested+0x4c/0x5b
[ 2282.868700]  [<ffffffff8121b489>] ? jfs_get_block+0x4c/0x21e
[ 2282.868700]  [<ffffffff81106d58>] ? alloc_buffer_head+0x48/0x4e
[ 2282.868700]  [<ffffffff8121b489>] jfs_get_block+0x4c/0x21e
[ 2282.868700]  [<ffffffff81109d54>] ? end_buffer_async_write+0x0/0x129
[ 2282.868700]  [<ffffffff8162308e>] ? _spin_unlock+0x2b/0x30
[ 2282.868700]  [<ffffffff81109d54>] ? end_buffer_async_write+0x0/0x129
[ 2282.868700]  [<ffffffff8110955c>] __block_write_full_page+0x100/0x2b9
[ 2282.868700]  [<ffffffff8121b43d>] ? jfs_get_block+0x0/0x21e
[ 2282.868700]  [<ffffffff81109d54>] ? end_buffer_async_write+0x0/0x129
[ 2282.868700]  [<ffffffff81109d54>] ? end_buffer_async_write+0x0/0x129
[ 2282.868700]  [<ffffffff8121b43d>] ? jfs_get_block+0x0/0x21e
[ 2282.868700]  [<ffffffff8110979e>] block_write_full_page_endio+0x89/0x96
[ 2282.868700]  [<ffffffff811097c0>] block_write_full_page+0x15/0x17
[ 2282.868700]  [<ffffffff8121b1d5>] jfs_writepage+0x18/0x1a
[ 2282.868700]  [<ffffffff810c25d1>] shrink_page_list+0x376/0x644
[ 2282.868700]  [<ffffffff810c0662>] ? pagevec_move_tail+0x66/0x12a
[ 2282.868700]  [<ffffffff810c2b7e>] shrink_list+0x2df/0x63a
[ 2282.868700]  [<ffffffff8106fa19>] ? register_lock_class+0x1e/0x321
[ 2282.868700]  [<ffffffff8162305c>] ? _spin_unlock_irqrestore+0x3f/0x46
[ 2282.868700]  [<ffffffff810c3151>] shrink_zone+0x278/0x326
[ 2282.868700]  [<ffffffff810698fb>] ? getnstimeofday+0x5b/0xaf
[ 2282.868700]  [<ffffffff810c3f81>] try_to_free_pages+0x1ec/0x327
[ 2282.868700]  [<ffffffff810c1380>] ? isolate_pages_global+0x0/0x202
[ 2282.868700]  [<ffffffff810bd897>] __alloc_pages_nodemask+0x3da/0x5bc
[ 2282.868700]  [<ffffffff810e29c6>] alloc_pages_node+0x1b/0x1d
[ 2282.868700]  [<ffffffff810e29e9>] alloc_slab_page+0x21/0x23
[ 2282.868700]  [<ffffffff810e2bca>] __slab_alloc+0x189/0x4c5
[ 2282.868700]  [<ffffffff8104a076>] ? copy_process+0x8a/0x12cf
[ 2282.868700]  [<ffffffff810e3210>] kmem_cache_alloc+0x8e/0x12e
[ 2282.868700]  [<ffffffff8104a076>] ? copy_process+0x8a/0x12cf
[ 2282.868700]  [<ffffffff8104a076>] copy_process+0x8a/0x12cf
[ 2282.868700]  [<ffffffff8104b41e>] do_fork+0x163/0x308
[ 2282.868700]  [<ffffffff81070d32>] ? trace_hardirqs_on_caller+0x121/0x145
[ 2282.868700]  [<ffffffff81070d63>] ? trace_hardirqs_on+0xd/0xf
[ 2282.868700]  [<ffffffff81623017>] ? _spin_unlock_irq+0x30/0x36
[ 2282.868700]  [<ffffffff8100bc4c>] ? sysret_check+0x27/0x62
[ 2282.868700]  [<ffffffff8100a49d>] sys_clone+0x28/0x2a
[ 2282.868700]  [<ffffffff8100c003>] stub_clone+0x13/0x20
[ 2282.868700]  [<ffffffff8100bc1b>] ? system_call_fastpath+0x16/0x1b


- Steven

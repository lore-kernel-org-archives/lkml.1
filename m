Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZIUHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZIUHlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZIUHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:41:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:38120 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752083AbZIUHlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:41:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HG9NnS+jHk2AEYJ/0qITusSCqvozCkn1kipINtr
	5oRfaHHU63uLeL
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090921093328.75ae5519@infradead.org>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
	 <20090920220405.GA395@duck.suse.cz>
	 <1253517908.25640.37.camel@marge.simson.net>
	 <20090921093328.75ae5519@infradead.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 09:41:46 +0200
Message-Id: <1253518906.25640.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:33 +0200, Arjan van de Ven wrote:
> On Mon, 21 Sep 2009 09:25:08 +0200
> Mike Galbraith <efault@gmx.de> wrote:
> > I still occasionally see some largish numbers though, and suspect that
> > depends on how much cache was evicted.
> 
> if you run latencytop it'll at least tell you what kind of operating
> was going on that hit the delay...

One of the really bad ones for evolution is below.  It was so bad that I
had _plenty_ of time to get to a GUI free shell, and poke SysRq-W before
killing the darn dd.

[ 5112.427012] SysRq : Show Blocked State
[ 5112.430995]   task                        PC stack   pid father
[ 5112.430995] kjournald     D 0000000000000002     0  1230      2 0x00000000
[ 5112.430995]  ffff8800378d7c50 0000000000000046 0000000000000000 ffff8800a5ed53b0
[ 5112.430995]  ffff8800bd2c0000 ffff8800378d7fd8 000000000000dd38 0000000000013480
[ 5112.430995]  0000000000004000 0000000000013480 ffff8800378d7bf0 00001000810e0c0a
[ 5112.430995] Call Trace:
[ 5112.430995]  [<ffffffff812cacb4>] io_schedule+0x80/0xc6
[ 5112.430995]  [<ffffffff8110df99>] sync_buffer+0x40/0x44
[ 5112.430995]  [<ffffffff812cb373>] __wait_on_bit+0x4c/0x7e
[ 5112.430995]  [<ffffffff8110df59>] ? sync_buffer+0x0/0x44
[ 5112.430995]  [<ffffffff8110df59>] ? sync_buffer+0x0/0x44
[ 5112.430995]  [<ffffffff812cb414>] out_of_line_wait_on_bit+0x6f/0x7c
[ 5112.430995]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.430995]  [<ffffffff8110deff>] __wait_on_buffer+0x24/0x26
[ 5112.430995]  [<ffffffffa0077e91>] journal_commit_transaction+0xca4/0x138b [jbd]
[ 5112.430995]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.430995]  [<ffffffffa007ba02>] kjournald+0x168/0x397 [jbd]
[ 5112.430995]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.430995]  [<ffffffffa007b89a>] ? kjournald+0x0/0x397 [jbd]
[ 5112.430995]  [<ffffffff81065acb>] kthread+0x82/0x8a
[ 5112.625071]  [<ffffffff8100ccca>] child_rip+0xa/0x20
[ 5112.625071]  [<ffffffff8100c669>] ? restore_args+0x0/0x30
[ 5112.625071]  [<ffffffff81065a49>] ? kthread+0x0/0x8a
[ 5112.625071]  [<ffffffff8100ccc0>] ? child_rip+0x0/0x20
[ 5112.625071] flush-8:16    D ffff8800bd2097f0     0  1236      2 0x00000000
[ 5112.625071]  ffff8800bd209790 0000000000000046 0000000000000000 ffffffff810beb58
[ 5112.625071]  ffff8800bd209740 ffff8800bd209fd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 0000000001080001 0000000000000080
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffff810beb58>] ? get_page_from_freelist+0x33d/0x4a6
[ 5112.625071]  [<ffffffff81174cb6>] ? cfq_may_queue+0x60/0xe1
[ 5112.625071]  [<ffffffff812cacb4>] io_schedule+0x80/0xc6
[ 5112.625071]  [<ffffffff81169184>] get_request_wait+0xf3/0x18f
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff8115f142>] ? elv_merge+0x37/0x19d
[ 5112.625071]  [<ffffffff8116954d>] __make_request+0x32d/0x45b
[ 5112.625071]  [<ffffffff811678ae>] generic_make_request+0x339/0x38b
[ 5112.625071]  [<ffffffff811679d4>] submit_bio+0xd4/0xdd
[ 5112.625071]  [<ffffffff8110ccfc>] submit_bh+0x106/0x129
[ 5112.625071]  [<ffffffff8110f7a4>] __block_write_full_page+0x1eb/0x2d1
[ 5112.625071]  [<ffffffff8110e197>] ? end_buffer_async_write+0x0/0x13f
[ 5112.625071]  [<ffffffff8110f94f>] block_write_full_page_endio+0xc5/0xca
[ 5112.625071]  [<ffffffff8110f969>] block_write_full_page+0x15/0x17
[ 5112.625071]  [<ffffffffa0095e1f>] ext3_writeback_writepage+0x71/0x142 [ext3]
[ 5112.625071]  [<ffffffff810bf647>] __writepage+0x17/0x34
[ 5112.625071]  [<ffffffff810bfd9f>] write_cache_pages+0x250/0x393
[ 5112.625071]  [<ffffffff810bf630>] ? __writepage+0x0/0x34
[ 5112.625071]  [<ffffffff810bff06>] generic_writepages+0x24/0x2a
[ 5112.625071]  [<ffffffff810bff34>] do_writepages+0x28/0x2a
[ 5112.625071]  [<ffffffff81106b94>] writeback_single_inode+0x181/0x395
[ 5112.625071]  [<ffffffff811077fc>] writeback_inodes_wb+0x341/0x42f
[ 5112.625071]  [<ffffffff81107a2b>] wb_writeback+0x141/0x194
[ 5112.625071]  [<ffffffff81095031>] ? call_rcu_sched+0x15/0x17
[ 5112.625071]  [<ffffffff81095041>] ? call_rcu+0xe/0x10
[ 5112.625071]  [<ffffffff81107bb9>] wb_do_writeback+0x7a/0x16b
[ 5112.625071]  [<ffffffff81107ce9>] bdi_writeback_task+0x3f/0xad
[ 5112.625071]  [<ffffffff810cca5d>] ? bdi_start_fn+0x0/0xd7
[ 5112.625071]  [<ffffffff810ccad3>] bdi_start_fn+0x76/0xd7
[ 5112.625071]  [<ffffffff810cca5d>] ? bdi_start_fn+0x0/0xd7
[ 5112.625071]  [<ffffffff81065acb>] kthread+0x82/0x8a
[ 5112.625071]  [<ffffffff8100ccca>] child_rip+0xa/0x20
[ 5112.625071]  [<ffffffff8100c669>] ? restore_args+0x0/0x30
[ 5112.625071]  [<ffffffff81065a49>] ? kthread+0x0/0x8a
[ 5112.625071]  [<ffffffff8100ccc0>] ? child_rip+0x0/0x20
[ 5112.625071] console-kit-d D ffff8800b788c480     0  2963      1 0x00000000
[ 5112.625071]  ffff8800bc59f6b8 0000000000000082 0000000000000000 ffffffffa0076655
[ 5112.625071]  ffff8800bc59f628 ffff8800bc59ffd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 ffff8800bd2f3c00 0000000000000000
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffffa0076655>] ? do_get_write_access+0x443/0x48b [jbd]
[ 5112.625071]  [<ffffffffa0076490>] do_get_write_access+0x27e/0x48b [jbd]
[ 5112.625071]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.625071]  [<ffffffffa00766c4>] journal_get_write_access+0x27/0x38 [jbd]
[ 5112.625071]  [<ffffffffa00a15fb>] __ext3_journal_get_write_access+0x24/0x4d [ext3]
[ 5112.625071]  [<ffffffffa0092901>] ext3_new_blocks+0x333/0x669 [ext3]
[ 5112.625071]  [<ffffffffa0096654>] ext3_get_blocks_handle+0x3ec/0x92d [ext3]
[ 5112.625071]  [<ffffffff8110c866>] ? alloc_buffer_head+0x1e/0x51
[ 5112.625071]  [<ffffffffa0096c3a>] ext3_get_block+0xa5/0xe3 [ext3]
[ 5112.625071]  [<ffffffff8110ec0a>] __block_prepare_write+0x1f0/0x3d2
[ 5112.625071]  [<ffffffffa0076e49>] ? start_this_handle+0x37d/0x474 [jbd]
[ 5112.625071]  [<ffffffffa0096b95>] ? ext3_get_block+0x0/0xe3 [ext3]
[ 5112.625071]  [<ffffffffa007709a>] ? journal_start+0x60/0xca [jbd]
[ 5112.625071]  [<ffffffff8110ef7c>] block_write_begin+0x85/0xd5
[ 5112.625071]  [<ffffffffa0098130>] ext3_write_begin+0xf0/0x1e7 [ext3]
[ 5112.625071]  [<ffffffffa0096b95>] ? ext3_get_block+0x0/0xe3 [ext3]
[ 5112.625071]  [<ffffffff810ba9e8>] generic_file_buffered_write+0x11f/0x277
[ 5112.625071]  [<ffffffff810bafe1>] __generic_file_aio_write+0x351/0x385
[ 5112.625071]  [<ffffffff810bb07b>] generic_file_aio_write+0x66/0xad
[ 5112.625071]  [<ffffffff810e75b4>] do_sync_write+0xec/0x132
[ 5112.625071]  [<ffffffff810c176a>] ? lru_cache_add_lru+0x2b/0x2d
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff8117c94f>] ? __up_read+0x9e/0xa7
[ 5112.625071]  [<ffffffff81151f8c>] ? security_file_permission+0x16/0x18
[ 5112.625071]  [<ffffffff810e8053>] vfs_write+0xb3/0x16f
[ 5112.625071]  [<ffffffff810e81dd>] sys_write+0x4c/0x74
[ 5112.625071]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[ 5112.625071] dd            D ffff8800b788c480     0  8587   6686 0x00000000
[ 5112.625071]  ffff8800a5e2faa8 0000000000000086 0000000000000000 ffffffff812cab8c
[ 5112.625071]  ffff8800a5e2fbe0 ffff8800a5e2ffd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 ffff8800a5e2fa28 ffffffff810b9b1c
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffff812cab8c>] ? thread_return+0x60/0x108
[ 5112.625071]  [<ffffffff810b9b1c>] ? find_get_page+0x28/0x89
[ 5112.625071]  [<ffffffffa0076490>] do_get_write_access+0x27e/0x48b [jbd]
[ 5112.625071]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.625071]  [<ffffffffa00766c4>] journal_get_write_access+0x27/0x38 [jbd]
[ 5112.625071]  [<ffffffffa00a15fb>] __ext3_journal_get_write_access+0x24/0x4d [ext3]
[ 5112.625071]  [<ffffffffa00953f5>] ext3_reserve_inode_write+0x44/0x80 [ext3]
[ 5112.625071]  [<ffffffffa0095460>] ext3_mark_inode_dirty+0x2f/0x4c [ext3]
[ 5112.625071]  [<ffffffffa0095605>] ext3_dirty_inode+0xab/0xc2 [ext3]
[ 5112.625071]  [<ffffffff81107392>] __mark_inode_dirty+0x34/0x15d
[ 5112.625071]  [<ffffffff810fc6af>] file_update_time+0xbe/0x102
[ 5112.625071]  [<ffffffff810baef7>] __generic_file_aio_write+0x267/0x385
[ 5112.625071]  [<ffffffff810b8427>] ? perf_swcounter_ctx_event+0x16c/0x1c6
[ 5112.625071]  [<ffffffff810bb07b>] generic_file_aio_write+0x66/0xad
[ 5112.625071]  [<ffffffff810e75b4>] do_sync_write+0xec/0x132
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff8117ffa0>] ? __clear_user+0x17/0x55
[ 5112.625071]  [<ffffffff81151f8c>] ? security_file_permission+0x16/0x18
[ 5112.625071]  [<ffffffff810e8053>] vfs_write+0xb3/0x16f
[ 5112.625071]  [<ffffffff810e81dd>] sys_write+0x4c/0x74
[ 5112.625071]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[ 5112.625071] perf          D ffff8800b788c480     0  8588   6686 0x00000000
[ 5112.625071]  ffff8800a5f115d8 0000000000000082 0000000000000000 000004a57bce3b78
[ 5112.625071]  ffff8800be035f40 ffff8800a5f11fd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 ffff8800a5f11558 ffffffff810b9b1c
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffff810b9b1c>] ? find_get_page+0x28/0x89
[ 5112.625071]  [<ffffffffa0076490>] do_get_write_access+0x27e/0x48b [jbd]
[ 5112.625071]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.625071]  [<ffffffffa00766c4>] journal_get_write_access+0x27/0x38 [jbd]
[ 5112.625071]  [<ffffffffa00a15fb>] __ext3_journal_get_write_access+0x24/0x4d [ext3]
[ 5112.625071]  [<ffffffffa00953f5>] ext3_reserve_inode_write+0x44/0x80 [ext3]
[ 5112.625071]  [<ffffffffa0095460>] ext3_mark_inode_dirty+0x2f/0x4c [ext3]
[ 5112.625071]  [<ffffffffa0095605>] ext3_dirty_inode+0xab/0xc2 [ext3]
[ 5112.625071]  [<ffffffff81107392>] __mark_inode_dirty+0x34/0x15d
[ 5112.625071]  [<ffffffffa0092672>] ext3_new_blocks+0xa4/0x669 [ext3]
[ 5112.625071]  [<ffffffff81110195>] ? __bread+0x13/0x92
[ 5112.625071]  [<ffffffffa00959c4>] ? ext3_get_branch+0x7b/0xee [ext3]
[ 5112.625071]  [<ffffffffa0096654>] ext3_get_blocks_handle+0x3ec/0x92d [ext3]
[ 5112.625071]  [<ffffffffa0096c3a>] ext3_get_block+0xa5/0xe3 [ext3]
[ 5112.625071]  [<ffffffff8110ec0a>] __block_prepare_write+0x1f0/0x3d2
[ 5112.625071]  [<ffffffffa0076e49>] ? start_this_handle+0x37d/0x474 [jbd]
[ 5112.625071]  [<ffffffffa0096b95>] ? ext3_get_block+0x0/0xe3 [ext3]
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff8110ef7c>] block_write_begin+0x85/0xd5
[ 5112.625071]  [<ffffffffa0098130>] ext3_write_begin+0xf0/0x1e7 [ext3]
[ 5112.625071]  [<ffffffffa0096b95>] ? ext3_get_block+0x0/0xe3 [ext3]
[ 5112.625071]  [<ffffffff810ba9e8>] generic_file_buffered_write+0x11f/0x277
[ 5112.625071]  [<ffffffff810bafe1>] __generic_file_aio_write+0x351/0x385
[ 5112.625071]  [<ffffffff8100c669>] ? restore_args+0x0/0x30
[ 5112.625071]  [<ffffffff812cb922>] ? mutex_lock+0x1c/0x3b
[ 5112.625071]  [<ffffffff810bb07b>] generic_file_aio_write+0x66/0xad
[ 5112.625071]  [<ffffffff810e75b4>] do_sync_write+0xec/0x132
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff812cab6a>] ? thread_return+0x3e/0x108
[ 5112.625071]  [<ffffffff81151f8c>] ? security_file_permission+0x16/0x18
[ 5112.625071]  [<ffffffff810e8053>] vfs_write+0xb3/0x16f
[ 5112.625071]  [<ffffffff810e81dd>] sys_write+0x4c/0x74
[ 5112.625071]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[ 5112.625071] evolution.bin D 0000000000000082     0  8638   6627 0x00000000
[ 5112.625071]  ffff880099339c08 0000000000000086 0000000000000000 ffffffff811157a6
[ 5112.625071]  ffffffffa0096b95 ffff880099339fd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 ffffea0001c5ae08 00000000009ff29b
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffff811157a6>] ? mpage_readpages+0x10a/0x120
[ 5112.625071]  [<ffffffffa0096b95>] ? ext3_get_block+0x0/0xe3 [ext3]
[ 5112.625071]  [<ffffffff812cacb4>] io_schedule+0x80/0xc6
[ 5112.625071]  [<ffffffff810b9d22>] sync_page+0x46/0x4a
[ 5112.625071]  [<ffffffff810b9d34>] sync_page_killable+0xe/0x35
[ 5112.625071]  [<ffffffff812cb263>] __wait_on_bit_lock+0x4a/0x92
[ 5112.625071]  [<ffffffff810b9d26>] ? sync_page_killable+0x0/0x35
[ 5112.625071]  [<ffffffff810b9c54>] __lock_page_killable+0x68/0x6f
[ 5112.625071]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.625071]  [<ffffffff810bb480>] generic_file_aio_read+0x3be/0x5bb
[ 5112.625071]  [<ffffffff810e76e6>] do_sync_read+0xec/0x132
[ 5112.625071]  [<ffffffff810c176a>] ? lru_cache_add_lru+0x2b/0x2d
[ 5112.625071]  [<ffffffff81065e32>] ? autoremove_wake_function+0x0/0x3d
[ 5112.625071]  [<ffffffff81151f8c>] ? security_file_permission+0x16/0x18
[ 5112.625071]  [<ffffffff810e82b5>] vfs_read+0xb0/0x16c
[ 5112.625071]  [<ffffffff810e843f>] sys_read+0x4c/0x75
[ 5112.625071]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[ 5112.625071] hal-acl-tool  D ffff8800b788c480     0  8675   2964 0x00000000
[ 5112.625071]  ffff880037b3db78 0000000000000082 ffff88007af907e0 ffff880062b7f7e0
[ 5112.625071]  ffff880037b3dac8 ffff880037b3dfd8 000000000000dd38 0000000000013480
[ 5112.625071]  0000000000004000 0000000000013480 ffff880037b3db18 ffffffff8110d414
[ 5112.625071] Call Trace:
[ 5112.625071]  [<ffffffff8110d414>] ? __getblk+0x2d/0x2ae
[ 5112.625071]  [<ffffffffa0076490>] do_get_write_access+0x27e/0x48b [jbd]
[ 5112.625071]  [<ffffffff81065e6f>] ? wake_bit_function+0x0/0x2f
[ 5112.625071]  [<ffffffffa00766c4>] journal_get_write_access+0x27/0x38 [jbd]
[ 5112.625071]  [<ffffffffa00a15fb>] __ext3_journal_get_write_access+0x24/0x4d [ext3]
[ 5112.625071]  [<ffffffffa0093ef8>] ext3_new_inode+0x4d4/0x96d [ext3]
[ 5112.625071]  [<ffffffffa009afca>] ext3_create+0x76/0xf3 [ext3]
[ 5112.625071]  [<ffffffff810f2be9>] vfs_create+0xa2/0x117
[ 5112.625071]  [<ffffffff810f50fb>] do_filp_open+0x327/0xa39
[ 5112.625071]  [<ffffffff810f2e69>] ? getname+0x31/0x1b3
[ 5112.625071]  [<ffffffff810e513e>] do_sys_open+0x62/0x109
[ 5112.625071]  [<ffffffff810e5218>] sys_open+0x20/0x22
[ 5112.625071]  [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b



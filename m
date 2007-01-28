Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXA1Q43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXA1Q43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 11:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXA1Q43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 11:56:29 -0500
Received: from dvhart.com ([64.146.134.43]:42056 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbXA1Q42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 11:56:28 -0500
Message-ID: <45BCD5A8.4090400@mbligh.org>
Date: Sun, 28 Jan 2007 08:56:08 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm1
References: <20070127234928.64d8e437.akpm@osdl.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> - It seems that people have been busy creating the need for this.  I had to
>   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
>   errors.  And a number of patches were dropped due to no-compile or to
>   runtime errors.  Heaven knows how many runtime bugs were added.

dbench seems to panic on xfs / cfq ?

http://test.kernel.org/abat/68498/debug/console.log

Pid: 30381, comm: dbench Not tainted 2.6.20-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff8039b19a>]  [<ffffffff8039b19a>] 
cfq_dispatch_requests+0xa9/0x4a2
RSP: 0000:ffff8100e3231418  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffff81007db97600 RCX: 0000000000010410
RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff81007db976a8
RBP: ffff8100e3231458 R08: 0000000000000000 R09: 00000000ffffa23e
R10: ffff8101ebf5c9c0 R11: ffff8101ed8d0298 R12: ffff81007db97688
R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8101fe003740(0063) knlGS:00000000f7de9460
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f7eb6050 CR3: 00000000e251d000 CR4: 00000000000006e0
Process dbench (pid: 30381, threadinfo ffff8100e3230000, task 
ffff8100e3855800)
Stack:  ffff8100e3231478 000000008039296a 00000000e32314b8 ffff81007dba4c48
  ffff81007dba4c48 ffff81007dba4c48 ffff8100e36e0c38 0000000000000000
  ffff8100e3231478 ffffffff803910c2 000000000218abe9 ffff8101ed8d0298
Call Trace:
  [<ffffffff803910c2>] elv_drain_elevator+0x1b/0x63
  [<ffffffff80391155>] elv_insert+0x4b/0x144
  [<ffffffff8039130f>] __elv_add_request+0x6e/0x70
  [<ffffffff80395b84>] __make_request+0x255/0x32e
  [<ffffffff80394c14>] generic_make_request+0x1c5/0x1fc
  [<ffffffff80394d09>] submit_bio+0xbe/0xc7
  [<ffffffff80383a80>] xfs_buf_iorequest+0x37e/0x3db
  [<ffffffff802243c5>] default_wake_function+0x0/0xf
  [<ffffffff802243c5>] default_wake_function+0x0/0xf
  [<ffffffff80382a67>] xfs_buf_associate_memory+0x100/0x220
  [<ffffffff8036b0a0>] xlog_bdstrat_cb+0x1c/0x45
  [<ffffffff8036bcd9>] xlog_state_release_iclog+0x2f2/0x4b1
  [<ffffffff8036cb37>] xlog_state_sync_all+0xce/0x21c
  [<ffffffff803500b3>] xfs_btree_del_cursor+0x59/0x61
  [<ffffffff8036d467>] _xfs_log_force+0x93/0x2fe
  [<ffffffff8038917e>] xfs_fs_alloc_inode+0x15/0x27
  [<ffffffff80282921>] iget_locked+0x6a/0x147
  [<ffffffff80361eb3>] xfs_iget+0x360/0x783
  [<ffffffff8037765f>] xfs_trans_iget+0xa3/0x10f
  [<ffffffff80363125>] xfs_ialloc+0x8e/0x44a
  [<ffffffff80377f16>] xfs_dir_ialloc+0x74/0x283
  [<ffffffff8037cc87>] xfs_create+0x347/0x626
  [<ffffffff804dcae9>] __up+0x19/0x1b
  [<ffffffff80386be0>] xfs_vn_mknod+0x14b/0x2b7
  [<ffffffff8036bead>] xfs_log_release_iclog+0x15/0x44
  [<ffffffff80280f7e>] __d_lookup+0xd7/0x114
  [<ffffffff80280f7e>] __d_lookup+0xd7/0x114
  [<ffffffff80277666>] do_lookup+0x63/0x1ba
  [<ffffffff8027fe46>] dput+0x22/0x151
  [<ffffffff80277fbb>] __link_path_walk+0x6b2/0xd16
  [<ffffffff80284991>] mntput_no_expire+0x1e/0x81
  [<ffffffff802786f5>] link_path_walk+0xd6/0xe7
  [<ffffffff80386d57>] xfs_vn_create+0xb/0xd
  [<ffffffff80278f63>] vfs_create+0x7e/0xc2
  [<ffffffff80279300>] open_namei+0x18d/0x600
  [<ffffffff8026fe9f>] do_filp_open+0x28/0x4b
  [<ffffffff80270038>] get_unused_fd+0x78/0x106
  [<ffffffff802701ec>] do_sys_open+0x4d/0xd4
  [<ffffffff8029ae0c>] compat_sys_open+0x15/0x17
  [<ffffffff8021b0e2>] ia32_sysret+0x0/0xa

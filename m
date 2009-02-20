Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbZBTRxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbZBTRxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZBTRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:53:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:37127 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbZBTRxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=XFXhqTw0oGNH1tZnXunae5peNErvyfN5MKfYmvr2kKzWyNgtrBDRBzpZg7uaDqt2h5
         9pfQ8LCQlZSXe2o9wMXZ5IAGoXa9LfganAs2RaEadqgPwjYYoqvhKubSZWJo/I2A9GP/
         3Jp1X/3Zl4qJdIffrEbjjS9BAjlVeH4usAGOE=
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 20:52:59 +0300
Message-ID: <a4423d670902200952v5dc2fd91w3b54ab1db51a7fe2@mail.gmail.com>
Subject: next-20090220: XFS: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[ INFO: inconsistent lock state ]
2.6.29-rc5-next-20090220 #2
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
kswapd0/324 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_lock)->mr_lock){+++++?}, at: [<ffffffff803ca60a>]
xfs_ilock+0xaa/0x120
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8026c469>] mark_held_locks+0x69/0x90
  [<ffffffff8026c4d1>] lockdep_trace_alloc+0x41/0xb0
  [<ffffffff802c609d>] kmem_cache_alloc+0x2d/0x100
  [<ffffffff8047f0ea>] radix_tree_preload+0x6a/0xf0
  [<ffffffff803cb01b>] xfs_iget+0x3db/0x650
  [<ffffffff803eb7a8>] xfs_trans_iget+0x208/0x250
  [<ffffffff803ce431>] xfs_ialloc+0xc1/0x700
  [<ffffffff803ec5b9>] xfs_dir_ialloc+0xa9/0x340
  [<ffffffff803eef81>] xfs_create+0x3e1/0x690
  [<ffffffff803fb6d3>] xfs_vn_mknod+0x63/0xf0
  [<ffffffff803fb76e>] xfs_vn_mkdir+0xe/0x10
  [<ffffffff802d47fc>] vfs_mkdir+0x8c/0xd0
  [<ffffffff802d6966>] sys_mkdirat+0x106/0x120
  [<ffffffff802d6993>] sys_mkdir+0x13/0x20
  [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 240653
hardirqs last  enabled at (240653): [<ffffffff80282ae4>]
__rcu_read_unlock+0xa4/0xc0
hardirqs last disabled at (240652): [<ffffffff80282a99>]
__rcu_read_unlock+0x59/0xc0
softirqs last  enabled at (233948): [<ffffffff80248199>]
__do_softirq+0x139/0x150
softirqs last disabled at (233943): [<ffffffff8020cd5c>] call_softirq+0x1c/0x30

other info that might help us debug this:
2 locks held by kswapd0/324:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff802a3e92>] shrink_slab+0x32/0x1c0
 #1:  (iprune_mutex){+.+.-.}, at: [<ffffffff802df2c4>]
shrink_icache_memory+0x84/0x2a0

stack backtrace:
Pid: 324, comm: kswapd0 Not tainted 2.6.29-rc5-next-20090220 #2
Call Trace:
 [<ffffffff8026b37d>] print_usage_bug+0x17d/0x190
 [<ffffffff8026c2cd>] mark_lock+0x31d/0x450
 [<ffffffff8026b4f0>] ? check_usage_forwards+0x0/0xc0
 [<ffffffff8026d4ed>] __lock_acquire+0x40d/0x12a0
 [<ffffffff8026e411>] lock_acquire+0x91/0xc0
 [<ffffffff803ca60a>] ? xfs_ilock+0xaa/0x120
 [<ffffffff8025e0a0>] down_read_nested+0x50/0x90
 [<ffffffff803ca60a>] ? xfs_ilock+0xaa/0x120
 [<ffffffff803ca60a>] xfs_ilock+0xaa/0x120
 [<ffffffff803ef394>] xfs_free_eofblocks+0x84/0x280
 [<ffffffff8026d3ac>] ? __lock_acquire+0x2cc/0x12a0
 [<ffffffff803efe1e>] xfs_inactive+0xee/0x540
 [<ffffffff803fd417>] xfs_fs_clear_inode+0x67/0x70
 [<ffffffff802deefa>] clear_inode+0x9a/0x120
 [<ffffffff802df160>] dispose_list+0x30/0x110
 [<ffffffff802df488>] shrink_icache_memory+0x248/0x2a0
 [<ffffffff802a3fbc>] shrink_slab+0x15c/0x1c0
 [<ffffffff802a5f3a>] kswapd+0x56a/0x6b0
 [<ffffffff80235f36>] ? finish_task_switch+0x46/0x110
 [<ffffffff802a33a0>] ? isolate_pages_global+0x0/0x270
 [<ffffffff80259d20>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802a59d0>] ? kswapd+0x0/0x6b0
 [<ffffffff80259836>] kthread+0x56/0x90
 [<ffffffff8020cc5a>] child_rip+0xa/0x20
 [<ffffffff80235f79>] ? finish_task_switch+0x89/0x110
 [<ffffffff80654516>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c640>] ? restore_args+0x0/0x30
 [<ffffffff802597e0>] ? kthread+0x0/0x90
 [<ffffffff8020cc50>] ? child_rip+0x0/0x20

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZDGBfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZDGBfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZDGBfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:35:07 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:62228 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZDGBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ehzsIW7f4mvJZLtlfZof58uWVxSxKfWvL2Ctr4GLnKBi6AiBrR/9bXriIrl7kQ2Qkw
         /ac9okUtDP/zpvI7oRkr2K4/giKD2HOewIAl+BIoOGTUTOoEAoFOdBnVYYGCIwzKtIvA
         VZ78pG3rdgoCqdEvHcGnD16UvkCxc78YLhMw0=
MIME-Version: 1.0
Date: Tue, 7 Apr 2009 09:35:03 +0800
Message-ID: <a0adeea50904061835o69034257je5881bb7b7a5850a@mail.gmail.com>
Subject: [ INFO: inconsistent lock state ] in least git
From: Grissiom <chaos.proton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

>From 2.6.29-git1, I constantly got this:

[  329.464922]
[  329.464929] =================================
[  329.464940] [ INFO: inconsistent lock state ]
[  329.464949] 2.6.29-g14-rfkill-nophy-ledon-09854-gd508afb #93
[  329.464956] ---------------------------------
[  329.464963] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
usage.
[  329.464972] kswapd0/32 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  329.464979]  (&inode->inotify_mutex){+.+.?.}, at: [<c01de4eb>]
inotify_inode_is_dead+0x1b/0x80
[  329.465012] {RECLAIM_FS-ON-W} state was registered at:
[  329.465019]   [<c01546e4>] mark_held_locks+0x64/0x90
[  329.465035]   [<c01547e5>] lockdep_trace_alloc+0xd5/0xe0
[  329.465048]   [<c01adc60>] __kmalloc+0x40/0x220
[  329.465059]   [<c01df465>] kernel_event+0x85/0x130
[  329.465071]   [<c01df58f>] inotify_dev_queue_event+0x7f/0x180
[  329.465082]   [<c01de403>] inotify_inode_queue_event+0xa3/0xe0
[  329.465093]   [<c01bb282>] vfs_create+0xb2/0x100
[  329.465106]   [<c01be365>] do_filp_open+0x6e5/0x820
[  329.465117]   [<c01b04d9>] do_sys_open+0x59/0xf0
[  329.465127]   [<c01b05d9>] sys_open+0x29/0x40
[  329.465136]   [<c0102fa5>] syscall_call+0x7/0xb
[  329.465148]   [<ffffffff>] 0xffffffff
[  329.465160] irq event stamp: 134535
[  329.465166] hardirqs last  enabled at (134535): [<c017558a>]
call_rcu+0x4a/0x80
[  329.465184] hardirqs last disabled at (134534): [<c0175563>]
call_rcu+0x23/0x80
[  329.465196] softirqs last  enabled at (133954): [<c0133476>]
__do_softirq+0x156/0x1d0
[  329.465211] softirqs last disabled at (133947): [<c013354d>]
do_softirq+0x5d/0x70
[  329.465223]
[  329.465226] other info that might help us debug this:
[  329.465233] 2 locks held by kswapd0/32:
[  329.465239]  #0:  (shrinker_rwsem){++++..}, at: [<c018f1f4>]
shrink_slab+0x24/0x1b0
[  329.465260]  #1:  (&type->s_umount_key#17){++++..}, at:
[<c01c276c>] shrink_dcache_memory+0xfc/0x1b0
[  329.465283]
[  329.465284] stack backtrace:
[  329.465293] Pid: 32, comm: kswapd0 Not tainted
2.6.29-g14-rfkill-nophy-ledon-09854-gd508afb #93
[  329.465303] Call Trace:
[  329.465316]  [<c0559680>] ? printk+0x18/0x1a
[  329.465327]  [<c0153fd1>] print_usage_bug+0x161/0x1c0
[  329.465339]  [<c0154488>] mark_lock+0x458/0x650
[  329.465350]  [<c0154e20>] ? check_usage_forwards+0x0/0xb0
[  329.465362]  [<c0155b8f>] __lock_acquire+0x3ef/0x18e0
[  329.465374]  [<c01546e4>] ? mark_held_locks+0x64/0x90
[  329.465386]  [<c01de4eb>] ? inotify_inode_is_dead+0x1b/0x80
[  329.465398]  [<c0157148>] lock_acquire+0xc8/0x100
[  329.465409]  [<c01de4eb>] ? inotify_inode_is_dead+0x1b/0x80
[  329.465421]  [<c01de4eb>] ? inotify_inode_is_dead+0x1b/0x80
[  329.465432]  [<c055b1c9>] mutex_lock_nested+0x59/0x370
[  329.465445]  [<c01de4eb>] ? inotify_inode_is_dead+0x1b/0x80
[  329.465456]  [<c01de4eb>] inotify_inode_is_dead+0x1b/0x80
[  329.465470]  [<c01c225c>] dentry_iput+0x9c/0xc0
[  329.465480]  [<c01c2365>] d_kill+0x35/0x60
[  329.465490]  [<c01c259d>] __shrink_dcache_sb+0x20d/0x2e0
[  329.465502]  [<c01c279e>] shrink_dcache_memory+0x12e/0x1b0
[  329.465514]  [<c018f2d5>] shrink_slab+0x105/0x1b0
[  329.465526]  [<c018f88b>] kswapd+0x50b/0x670
[  329.465540]  [<c018d1f0>] ? isolate_pages_global+0x0/0x200
[  329.465552]  [<c0143910>] ? autoremove_wake_function+0x0/0x40
[  329.465564]  [<c018f380>] ? kswapd+0x0/0x670
[  329.465573]  [<c014354c>] kthread+0x3c/0x70
[  329.465582]  [<c0143510>] ? kthread+0x0/0x70
[  329.465593]  [<c01039a7>] kernel_thread_helper+0x7/0x10

What's the root cause of this? Thanks.

--
Cheers,
Grissiom

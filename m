Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXDVXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXDVXo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161143AbXDVXo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:44:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXDVXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:44:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: jeffm@suse.com
Subject: More reiserfs trouble in 2.6.21-rc5
Date: Mon, 23 Apr 2007 01:44:04 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704230144.05011.ak@suse.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FYI,

This was a debugging kernel (preempt, slab debugging, lockdep etc. enabled)
running autotest and some other load on a 4 core Opteron system

There was also another lockdep warning before that which I'm sending
separately.

Looks like some memory corruption. Could be something else, but at least
reiserfs is the messenger.

BTW these kind of backtraces are a good example on why I want the dwarf2
unwinder back.

-Andi

------------[ cut here ]------------
kernel BUG at /mnt/dm-2/newautoboot/autoboot/lsrc/mainline/linux/mm/slab.c:2380!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in:
Pid: 12205, comm: find Not tainted 2.6.21-rc5-git6 #44
RIP: 0010:[<ffffffff8027b89d>]  [<ffffffff8027b89d>] cache_alloc_refill+0xe6/0x22a
RSP: 0018:ffff810078be7a28  EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffffffff8027b826
RDX: 0000000000000003 RSI: ffff81017d077000 RDI: ffff8100f7f7c540
RBP: ffff81017d077000 R08: ffff8100f7f7ec78 R09: ffff8101fa6cf178
R10: ffff810100116070 R11: 0000000000000000 R12: ffff810100116070
R13: ffff8100f7f7ec78 R14: ffff8100f7f7c540 R15: 000000000000000c
FS:  00002acc1ce646d0(0000) GS:ffffffff8074a000(0000) knlGS:000000005b3f2b90
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000043d45000 CR3: 0000000088a9b000 CR4: 00000000000006e0
Process find (pid: 12205, threadinfo ffff810078be6000, task ffff81002a76d0c0)
Stack:  00000001000000d0 ffff8101002b6248 ffff8100f7f7c540 0000000000000246
 00000000000000d0 ffffffff802ce4cb ffffffff802c7590 ffffffff8027bda3
 ffff8101002b6248 0000000000000000 ffff8100070a9988 ffff8101002b6248
Call Trace:
 [<ffffffff802ce4cb>] reiserfs_alloc_inode+0x15/0x2a
 [<ffffffff802c7590>] reiserfs_find_actor+0x0/0x1b
 [<ffffffff8027bda3>] kmem_cache_alloc+0x8c/0xe2
 [<ffffffff802ce4cb>] reiserfs_alloc_inode+0x15/0x2a
 [<ffffffff802925c9>] alloc_inode+0x12/0x13f
 [<ffffffff8029289d>] iget5_locked+0x5a/0x18a
 [<ffffffff802c757e>] reiserfs_init_locked_inode+0x0/0x12
 [<ffffffff802c54a0>] reiserfs_iget+0x30/0x92
 [<ffffffff802d5079>] pathrelse+0x24/0x3c
 [<ffffffff802c2a11>] reiserfs_lookup+0xcf/0x138
 [<ffffffff80557303>] _read_trylock+0x47/0x6b
 [<ffffffff80290b6e>] d_alloc+0x1c4/0x1d0
 [<ffffffff80287a2c>] do_lookup+0xc4/0x1ae
 [<ffffffff80289551>] __link_path_walk+0x885/0xd2b
 [<ffffffff80289a4f>] link_path_walk+0x58/0xe0
 [<ffffffff80289deb>] do_path_lookup+0x1be/0x1e2
 [<ffffffff80288b1e>] getname+0x152/0x196
 [<ffffffff8028a626>] __user_walk_fd+0x37/0x53
 [<ffffffff80283c85>] vfs_lstat_fd+0x18/0x47
 [<ffffffff80283e79>] sys_newlstat+0x19/0x31
 [<ffffffff80556a9f>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8034a59d>] _atomic_dec_and_lock+0x39/0x58
 [<ffffffff8020945e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 49 8b 86 70 03 00 00 49 ff 86 78 03 00 00 48 ff
RIP  [<ffffffff8027b89d>] cache_alloc_refill+0xe6/0x22a
 RSP <ffff810078be7a28>
note: find[12205] exited with preempt_count 1
BUG: scheduling while atomic: find/0x10000001/12205
INFO: lockdep is turned off.
UG: scheduling while atomic: find/0x10000001/12205
INFO: lockdep is turned off.

Call Trace:
 [<ffffffff80553e61>] __sched_text_start+0x81/0x80b
 [<ffffffff8039b16c>] vt_console_print+0x21f/0x235
 [<ffffffff805574a4>] _spin_unlock_irqrestore+0x49/0x69
 [<ffffffff8022bbda>] __cond_resched+0x13/0x32
 [<ffffffff80554e85>] cond_resched+0x2e/0x39
 [<ffffffff80266b8b>] unmap_vmas+0x5e5/0x778
 [<ffffffff8026a6ec>] exit_mmap+0x80/0x117
 [<ffffffff8022e91e>] mmput+0x2c/0x9e
 [<ffffffff80233fb4>] do_exit+0x21a/0x82e
 [<ffffffff805574a4>] _spin_unlock_irqrestore+0x49/0x69
 [<ffffffff8020acab>] kernel_math_error+0x0/0x90
 [<ffffffff8020b287>] do_invalid_op+0xb2/0xbc
 [<ffffffff8027b89d>] cache_alloc_refill+0xe6/0x22a
 [<ffffffff80556a9f>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80209a00>] restore_args+0x0/0x30
 [<ffffffff805579ed>] error_exit+0x0/0x96
 [<ffffffff8027b826>] cache_alloc_refill+0x6f/0x22a
 [<ffffffff8027b89d>] cache_alloc_refill+0xe6/0x22a
 [<ffffffff8027b884>] cache_alloc_refill+0xcd/0x22a
 [<ffffffff802ce4cb>] reiserfs_alloc_inode+0x15/0x2a
 [<ffffffff802c7590>] reiserfs_find_actor+0x0/0x1b
 [<ffffffff8027bda3>] kmem_cache_alloc+0x8c/0xe2
 [<ffffffff802ce4cb>] reiserfs_alloc_inode+0x15/0x2a
 [<ffffffff802925c9>] alloc_inode+0x12/0x13f
 [<ffffffff8029289d>] iget5_locked+0x5a/0x18a
 [<ffffffff802c757e>] reiserfs_init_locked_inode+0x0/0x12
 [<ffffffff802c54a0>] reiserfs_iget+0x30/0x92
 [<ffffffff802d5079>] pathrelse+0x24/0x3c
 [<ffffffff802c2a11>] reiserfs_lookup+0xcf/0x138
 [<ffffffff80557303>] _read_trylock+0x47/0x6b
 [<ffffffff80290b6e>] d_alloc+0x1c4/0x1d0
 [<ffffffff80287a2c>] do_lookup+0xc4/0x1ae
 [<ffffffff80289551>] __link_path_walk+0x885/0xd2b
 [<ffffffff80289a4f>] link_path_walk+0x58/0xe0
 [<ffffffff80289deb>] do_path_lookup+0x1be/0x1e2
 [<ffffffff80288b1e>] getname+0x152/0x196
 [<ffffffff8028a626>] __user_walk_fd+0x37/0x53
 [<ffffffff80283c85>] vfs_lstat_fd+0x18/0x47
 [<ffffffff80283e79>] sys_newlstat+0x19/0x31
 [<ffffffff80556a9f>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8034a59d>] _atomic_dec_and_lock+0x39/0x58
 [<ffffffff8020945e>] system_call+0x7e/0x83

BUG: scheduling while atomic: find/0x10000001/12205
INFO: lockdep is turned off.

[... more similar messages ...]

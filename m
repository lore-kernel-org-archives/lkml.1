Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYLOI5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYLOI5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLOI5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:57:43 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58607 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYLOI5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:57:42 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: locking checker reported on reiserfs in 2.6.28-rc8
Date: Mon, 15 Dec 2008 09:59:33 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812150959.33392.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this in the log. No noticeable ill effect. 2.6.28-rc8 on x86_64.

	Regards
		Oliver

Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: =======================================================
Dec 15 09:50:53 vanamonde kernel: [ INFO: possible circular locking dependency detected ]
Dec 15 09:50:53 vanamonde kernel: 2.6.28-rc8-default #3
Dec 15 09:50:53 vanamonde kernel: -------------------------------------------------------
Dec 15 09:50:53 vanamonde kernel: kmail/3204 is trying to acquire lock:
Dec 15 09:50:53 vanamonde kernel:  (&sb->s_type->i_mutex_key#12){--..}, at: [<ffffffff802beb25>] vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: but task is already holding lock:
Dec 15 09:50:53 vanamonde kernel:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffffa04b25f5>] reiserfs_delete_xattrs+0xff/0x16b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: which lock already depends on the new lock.
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: the existing dependency chain (in reverse order) is:
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: -> #1 (&REISERFS_SB(s)->xattr_dir_sem){----}:
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff8026231b>] __lock_acquire+0x1291/0x15be
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802626d5>] lock_acquire+0x8d/0xba
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff804716f9>] down_read+0x45/0x52
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffa04b3b94>] reiserfs_acl_chmod+0x69/0x1c0 [reiserfs]
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffa0496c30>] reiserfs_setattr+0x243/0x26b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c92ba>] notify_change+0x194/0x2da
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802b518c>] sys_fchmodat+0x91/0xbd
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802b51cb>] sys_chmod+0x13/0x15
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff8020c05a>] system_call_fastpath+0x16/0x1b
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: -> #0 (&sb->s_type->i_mutex_key#12){--..}:
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff8026202c>] __lock_acquire+0xfa2/0x15be
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802626d5>] lock_acquire+0x8d/0xba
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff80470e24>] mutex_lock_nested+0xf9/0x2a0
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802beb25>] vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffa04b2601>] reiserfs_delete_xattrs+0x10b/0x16b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffa049a65e>] reiserfs_delete_inode+0x75/0x11b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c89bc>] generic_delete_inode+0xb8/0x145
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c8a60>] generic_drop_inode+0x17/0x17c
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c7aa1>] iput+0x61/0x65
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c0b40>] do_unlinkat+0x103/0x159
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff802c0ba7>] sys_unlink+0x11/0x13
Dec 15 09:50:53 vanamonde kernel:        [<ffffffff8020c05a>] system_call_fastpath+0x16/0x1b
Dec 15 09:50:53 vanamonde kernel:        [<ffffffffffffffff>] 0xffffffffffffffff
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: other info that might help us debug this:
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: 1 lock held by kmail/3204:
Dec 15 09:50:53 vanamonde kernel:  #0:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffffa04b25f5>] reiserfs_delete_xattrs+0xff/0x16b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:
Dec 15 09:50:53 vanamonde kernel: stack backtrace:
Dec 15 09:50:53 vanamonde kernel: Pid: 3204, comm: kmail Not tainted 2.6.28-rc8-default #3
Dec 15 09:50:53 vanamonde kernel: Call Trace:
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff80260ccc>] print_circular_bug_tail+0xb8/0xc3
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff8026202c>] __lock_acquire+0xfa2/0x15be
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802626d5>] lock_acquire+0x8d/0xba
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802beb25>] ? vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff80470e24>] mutex_lock_nested+0xf9/0x2a0
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802beb25>] ? vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802beb25>] ? vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff804729fa>] ? _spin_unlock_irq+0x2b/0x37
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802be128>] ? may_delete+0x65/0x147
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802beb25>] vfs_rmdir+0x8b/0x104
Dec 15 09:50:53 vanamonde kernel:  [<ffffffffa04b2601>] reiserfs_delete_xattrs+0x10b/0x16b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:  [<ffffffffa049a65e>] reiserfs_delete_inode+0x75/0x11b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff80345a17>] ? _raw_spin_unlock+0x8e/0x94
Dec 15 09:50:53 vanamonde kernel:  [<ffffffffa049a5e9>] ? reiserfs_delete_inode+0x0/0x11b [reiserfs]
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c89bc>] generic_delete_inode+0xb8/0x145
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c8a60>] generic_drop_inode+0x17/0x17c
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c7aa1>] iput+0x61/0x65
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c0b40>] do_unlinkat+0x103/0x159
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff8020c0aa>] ? sysret_check+0x46/0x81
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff8026073b>] ? trace_hardirqs_on_caller+0xf6/0x11a
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff804725f3>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c0543>] ? do_path_lookup+0x47/0x1c8
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff802c0ba7>] sys_unlink+0x11/0x13
Dec 15 09:50:53 vanamonde kernel:  [<ffffffff8020c05a>] system_call_fastpath+0x16/0x1b

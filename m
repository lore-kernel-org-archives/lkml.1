Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZLWEuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZLWEuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZLWEuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:50:22 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49059 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZLWEuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=dhoqR6wskIp7Sl7XBdIXUYWxVSq8ItUh4g3IB+NgfYs82lyk2FsmENhmc57PVVlQDj
         BbXqh2fgPME24sCvunuHaZrB2WKbKxVHxEOVu2u3uzihA+PFzi+DiTx4xc/x+Qpo6UR+
         OHRtH0Ma2XiUn6KdFv+M1og9VtqKo1JEVqGP0=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 20:50:21 -0800
X-Google-Sender-Auth: b5bb78acba92c47a
Message-ID: <86802c440912222050o2d634667p4702a87171d045ed@mail.gmail.com>
Subject: lockdep with reiserfs
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x:~ # mount /dev/sda2 /xx

[  277.586941] =======================================================
[  277.594680] [ INFO: possible circular locking dependency detected ]
[  277.601299] 2.6.33-rc1-tip-yh-00304-g97a015d-dirty #1007
[  277.605492] -------------------------------------------------------
[  277.622611] mount/19427 is trying to acquire lock:
[  277.627353]  (&journal->j_mutex){+.+...}, at: [<ffffffff811c6d40>]
do_journal_begin_r+0x9f/0x308
[  277.645049]
[  277.645050] but task is already holding lock:
[  277.659112]  (&REISERFS_SB(s)->lock){+.+.+.}, at:
[<ffffffff811cc0b0>] reiserfs_write_lock+0x30/0x42
[  277.677168]
[  277.677169] which lock already depends on the new lock.
[  277.677170]
[  277.685840]
[  277.685841] the existing dependency chain (in reverse order) is:
[  277.700845]
[  277.700845] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[  277.707089]        [<ffffffff810a8735>] check_prev_add+0x3ca/0x583
[  277.723457]        [<ffffffff810a8d4b>] validate_chain+0x45d/0x567
[  277.738331]        [<ffffffff810a9605>] __lock_acquire+0x7b0/0x838
[  277.745738]        [<ffffffff810a9751>] lock_acquire+0xc4/0xe1
[  277.758903]        [<ffffffff81d305bf>] mutex_lock_nested+0x68/0x2d2
[  277.765408]        [<ffffffff811cc0b0>] reiserfs_write_lock+0x30/0x42
[  277.780623]        [<ffffffff811c6d48>] do_journal_begin_r+0xa7/0x308
[  277.788070]        [<ffffffff811c717c>] journal_begin+0xcb/0x10f
[  277.801530]        [<ffffffff811b924f>] reiserfs_fill_super+0x6f6/0xa04
[  277.818144]        [<ffffffff81134094>] get_sb_bdev+0x134/0x17f
[  277.824414]        [<ffffffff811b67b7>] get_super_block+0x18/0x1a
[  277.838452]        [<ffffffff81132d81>] vfs_kern_mount+0x5b/0xce
[  277.843123]        [<ffffffff81132e5b>] do_kern_mount+0x4c/0xec
[  277.858708]        [<ffffffff8114aa43>] do_mount+0x1c7/0x228
[  277.865063]        [<ffffffff8114ab28>] sys_mount+0x84/0xc4
[  277.879329]        [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[  277.885762]
[  277.885763] -> #0 (&journal->j_mutex){+.+...}:
[  277.900836]        [<ffffffff810a8464>] check_prev_add+0xf9/0x583
[  277.905844]        [<ffffffff810a8d4b>] validate_chain+0x45d/0x567
[  277.921016]        [<ffffffff810a9605>] __lock_acquire+0x7b0/0x838
[  277.937549]        [<ffffffff810a9751>] lock_acquire+0xc4/0xe1
[  277.941772]        [<ffffffff81d305bf>] mutex_lock_nested+0x68/0x2d2
[  277.958127]        [<ffffffff811c6d40>] do_journal_begin_r+0x9f/0x308
[  277.964631]        [<ffffffff811c717c>] journal_begin+0xcb/0x10f
[  277.978818]        [<ffffffff811b24cd>] reiserfs_delete_inode+0x96/0x141
[  277.984215]        [<ffffffff81145b40>] generic_delete_inode+0xe1/0x174
[  278.002166]        [<ffffffff81145bef>] generic_drop_inode+0x1c/0x67
[  278.016829]        [<ffffffff81144a31>] iput+0x66/0x6a
[  278.022807]        [<ffffffff811b8294>] finish_unfinished+0x47a/0x529
[  278.037406]        [<ffffffff811b93ef>] reiserfs_fill_super+0x896/0xa04
[  278.042843]        [<ffffffff81134094>] get_sb_bdev+0x134/0x17f
[  278.058832]        [<ffffffff811b67b7>] get_super_block+0x18/0x1a
[  278.064476]        [<ffffffff81132d81>] vfs_kern_mount+0x5b/0xce
[  278.079763]        [<ffffffff81132e5b>] do_kern_mount+0x4c/0xec
[  278.085409]        [<ffffffff8114aa43>] do_mount+0x1c7/0x228
[  278.099487]        [<ffffffff8114ab28>] sys_mount+0x84/0xc4
[  278.104554]        [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[  278.120594]
[  278.120594] other info that might help us debug this:
[  278.120595]
[  278.137861] 2 locks held by mount/19427:
[  278.142048]  #0:  (&type->s_umount_key#17/1){+.+.+.}, at:
[<ffffffff8113398d>] alloc_super+0x153/0x227
[  278.161051]  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at:
[<ffffffff811cc0b0>] reiserfs_write_lock+0x30/0x42
[  278.178694]
[  278.178694] stack backtrace:
[  278.183421] Pid: 19427, comm: mount Not tainted
2.6.33-rc1-tip-yh-00304-g97a015d-dirty #1007
[  278.200418] Call Trace:
[  278.203357]  [<ffffffff810a7dcc>] print_circular_bug+0xb3/0xc2
[  278.218174]  [<ffffffff810a8464>] check_prev_add+0xf9/0x583
[  278.223784]  [<ffffffff810a8d4b>] validate_chain+0x45d/0x567
[  278.238230]  [<ffffffff810a9605>] __lock_acquire+0x7b0/0x838
[  278.244997]  [<ffffffff81d303de>] ? __mutex_unlock_slowpath+0x112/0x11e
[  278.259664]  [<ffffffff810a9751>] lock_acquire+0xc4/0xe1
[  278.264989]  [<ffffffff811c6d40>] ? do_journal_begin_r+0x9f/0x308
[  278.278800]  [<ffffffff81d305bf>] mutex_lock_nested+0x68/0x2d2
[  278.284152]  [<ffffffff811c6d40>] ? do_journal_begin_r+0x9f/0x308
[  278.299640]  [<ffffffff811c6d40>] ? do_journal_begin_r+0x9f/0x308
[  278.305289]  [<ffffffff811cb418>] ? reiserfs_for_each_xattr+0x72/0x2ad
[  278.322801]  [<ffffffff8109b2c8>] ? cpu_clock+0x2d/0x3f
[  278.336165]  [<ffffffff811c6d40>] do_journal_begin_r+0x9f/0x308
[  278.341890]  [<ffffffff810a5c2e>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  278.357094]  [<ffffffff811c717c>] journal_begin+0xcb/0x10f
[  278.362825]  [<ffffffff811b24cd>] reiserfs_delete_inode+0x96/0x141
[  278.377094]  [<ffffffff811b2437>] ? reiserfs_delete_inode+0x0/0x141
[  278.383601]  [<ffffffff81145b40>] generic_delete_inode+0xe1/0x174
[  278.398309]  [<ffffffff81145bef>] generic_drop_inode+0x1c/0x67
[  278.403863]  [<ffffffff81144a31>] iput+0x66/0x6a
[  278.418387]  [<ffffffff811b8294>] finish_unfinished+0x47a/0x529
[  278.422333]  [<ffffffff811cc0b0>] ? reiserfs_write_lock+0x30/0x42
[  278.438673]  [<ffffffff810a6f29>] ? trace_hardirqs_on+0xd/0xf
[  278.444584]  [<ffffffff811b93ef>] reiserfs_fill_super+0x896/0xa04
[  278.459330]  [<ffffffff81134094>] get_sb_bdev+0x134/0x17f
[  278.464098]  [<ffffffff811b8b59>] ? reiserfs_fill_super+0x0/0xa04
[  278.479768]  [<ffffffff811b67b7>] get_super_block+0x18/0x1a
[  278.484545]  [<ffffffff81132d81>] vfs_kern_mount+0x5b/0xce
[  278.500296]  [<ffffffff81132e5b>] do_kern_mount+0x4c/0xec
[  278.506534]  [<ffffffff8114aa43>] do_mount+0x1c7/0x228
[  278.518910]  [<ffffffff8114ab28>] sys_mount+0x84/0xc4
[  278.522530]  [<ffffffff81d31bfe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  278.541059]  [<ffffffff81033bdb>] system_call_fastpath+0x16/0x1b
[  278.555566] done
[  278.557459] REISERFS (device sda2): There were 1 uncompleted
unlinks/truncates. Completed

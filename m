Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXDZXlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXDZXlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbXDZXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:41:08 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:20027 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755243AbXDZXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:41:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rez6uDrGdm7fNzMulnwpaUdsHCqnquO5glg/FqV1Y6O7/Vge4pachBqhDrq5j9T2xfNNyfR+6iH3RlpEAgQ4INNwUJ6tEH/8uN4MjsomlQeZ/IHK+DO5mKzhfj0CicH5+BqiTW+T3Uw7psVel1Xa5Sy4gzDVlxIrDta/av3JGwM=  ;
X-YMail-OSG: d9chp6gVM1lciZA01sZ4iQzy7qGUx1RcZbyIcEdALaQFiZSrTd7JBe_p.mI5YGS04aFBuwUKIA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.21 reiserfs -- cicular locking?
Date: Thu, 26 Apr 2007 16:40:14 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261640.15068.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This might be a Heisenberg, but I figure it's worth posting
in case anyone else sees similar oddness.  Never seen it
before or since.  It's as if a gremlin got annoyed with me
for switching a filesystem from reiser to ext3.  :)

- Dave


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-git #6
-------------------------------------------------------
vi/4556 is trying to acquire lock:
 (&REISERFS_SB(s)->xattr_dir_sem){..--}, at: [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<ffffffff8026c4fa>] chown_common+0x93/0xb3

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<ffffffff802405f4>] __lock_acquire+0x9f7/0xbaa
       [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
       [<ffffffff80240822>] lock_acquire+0x7b/0x9f
       [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
       [<ffffffff8023dee0>] save_trace+0x40/0x9e
       [<ffffffff8041e1db>] __mutex_lock_slowpath+0xd8/0x281
       [<ffffffff8041ff18>] _spin_unlock_irq+0x24/0x4a
       [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
       [<ffffffff802ca2a8>] open_xa_dir+0x1c/0xf8
       [<ffffffff8041f34b>] __down_read+0x34/0x9d
       [<ffffffff802cb50a>] reiserfs_delete_xattrs+0x64/0x185
       [<ffffffff802fd620>] _atomic_dec_and_lock+0x14/0x34
       [<ffffffff802b252e>] reiserfs_delete_inode+0x38/0xae
       [<ffffffff8027f6bc>] generic_delete_inode+0x64/0xf5
       [<ffffffff802b24f6>] reiserfs_delete_inode+0x0/0xae
       [<ffffffff8027f6d2>] generic_delete_inode+0x7a/0xf5
       [<ffffffff80276b95>] do_unlinkat+0xd9/0x14f
       [<ffffffff8023f75f>] trace_hardirqs_on+0x123/0x14d
       [<ffffffff8041f4d1>] trace_hardirqs_on_thunk+0x35/0x37
       [<ffffffff8020954e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&REISERFS_SB(s)->xattr_dir_sem){..--}:
       [<ffffffff8023ee6f>] print_circular_bug_header+0xcc/0xd3
       [<ffffffff802404f0>] __lock_acquire+0x8f3/0xbaa
       [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
       [<ffffffff80240822>] lock_acquire+0x7b/0x9f
       [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
       [<ffffffff8023bb03>] down_read+0x32/0x3b
       [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
       [<ffffffff8022e285>] __capable+0x9/0x1d
       [<ffffffff802b2828>] reiserfs_setattr+0x11e/0x1ec
       [<ffffffff8022bd6b>] current_fs_time+0x35/0x3a
       [<ffffffff802803a1>] notify_change+0x122/0x231
       [<ffffffff8026c505>] chown_common+0x9e/0xb3
       [<ffffffff8026e7a6>] fget+0x88/0xa7
       [<ffffffff8026c54a>] sys_fchown+0x30/0x47
       [<ffffffff8020954e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by vi/4556:
 #0:  (&inode->i_mutex){--..}, at: [<ffffffff8026c4fa>] chown_common+0x93/0xb3

stack backtrace:

Call Trace:
 [<ffffffff8023eacc>] print_circular_bug_tail+0x69/0x72
 [<ffffffff8023ee6f>] print_circular_bug_header+0xcc/0xd3
 [<ffffffff802404f0>] __lock_acquire+0x8f3/0xbaa
 [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
 [<ffffffff80240822>] lock_acquire+0x7b/0x9f
 [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
 [<ffffffff8023bb03>] down_read+0x32/0x3b
 [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
 [<ffffffff8022e285>] __capable+0x9/0x1d
 [<ffffffff802b2828>] reiserfs_setattr+0x11e/0x1ec
 [<ffffffff8022bd6b>] current_fs_time+0x35/0x3a
 [<ffffffff802803a1>] notify_change+0x122/0x231
 [<ffffffff8026c505>] chown_common+0x9e/0xb3
 [<ffffffff8026e7a6>] fget+0x88/0xa7
 [<ffffffff8026c54a>] sys_fchown+0x30/0x47
 [<ffffffff8020954e>] system_call+0x7e/0x83


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbZLKWGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbZLKWGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZLKWGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:06:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35918 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690AbZLKWGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:06:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=eewBojEmbUhwpQJ67D+ieGQzgvHtbk00mPwlOxvhuRX2rl+2D7D//WGm1Dxb6Mg0mu
         pvBtNO5mV9dcBpdDUfL7lYw/ii5ZvZWZ46ANJXvboPnwmUMvTsphXr5uy2JecL4J5Ep1
         XLSi/WeZQW5mzmSJCn9g8h1E4UvjD0opUSXYg=
MIME-Version: 1.0
Date: Sat, 12 Dec 2009 01:06:29 +0300
Message-ID: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
Subject: 2.6.33-rc0: reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic

It is x86_32 UP


[ INFO: inconsistent lock state ]
2.6.32-05594-g3ef884b #2
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/312 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c11108a8>] reiserfs_write_lock+0x28/0x40
{RECLAIM_FS-ON-W} state was registered at:
  [<c104e1c2>] mark_held_locks+0x62/0x90
  [<c104e28a>] lockdep_trace_alloc+0x9a/0xc0
  [<c108e396>] kmem_cache_alloc+0x26/0xf0
  [<c10850ec>] __get_vm_area_node+0x6c/0xf0
  [<c10857de>] __vmalloc_node+0x7e/0xa0
  [<c108597b>] vmalloc+0x2b/0x30
  [<c10e00b9>] reiserfs_init_bitmap_cache+0x39/0x70
  [<c10f8178>] reiserfs_fill_super+0x2e8/0xb90
  [<c1094345>] get_sb_bdev+0x145/0x180
  [<c10f5a11>] get_super_block+0x21/0x30
  [<c10931f0>] vfs_kern_mount+0x40/0xd0
  [<c10932d9>] do_kern_mount+0x39/0xd0
  [<c10a9857>] do_mount+0x2c7/0x6b0
  [<c10a9ca6>] sys_mount+0x66/0xa0
  [<c161589b>] mount_block_root+0xc4/0x245
  [<c1615a75>] mount_root+0x59/0x5f
  [<c1615b8c>] prepare_namespace+0x111/0x14b
  [<c1615269>] kernel_init+0xcf/0xdb
  [<c10031fb>] kernel_thread_helper+0x7/0x1c
irq event stamp: 48075
hardirqs last  enabled at (48075): [<c134ad8a>]
__mutex_unlock_slowpath+0x9a/0x120
hardirqs last disabled at (48074): [<c134ad29>]
__mutex_unlock_slowpath+0x39/0x120
softirqs last  enabled at (46832): [<c102f4e1>] __do_softirq+0xc1/0x110
softirqs last disabled at (46825): [<c102f57d>] do_softirq+0x4d/0x60

other info that might help us debug this:
2 locks held by kswapd0/312:
 #0:  (shrinker_rwsem){++++..}, at: [<c1073de4>] shrink_slab+0x24/0x170
 #1:  (&type->s_umount_key#19){++++..}, at: [<c10a1e0d>]
shrink_dcache_memory+0xfd/0x1a0

stack backtrace:
Pid: 312, comm: kswapd0 Not tainted 2.6.32-05594-g3ef884b #2
Call Trace:
 [<c134a046>] ? printk+0x18/0x1a
 [<c104db7f>] print_usage_bug+0x15f/0x1a0
 [<c104df5f>] mark_lock+0x39f/0x5a0
 [<c104c9fb>] ? trace_hardirqs_off+0xb/0x10
 [<c1051fe0>] ? check_usage_forwards+0x0/0xf0
 [<c104ffb4>] __lock_acquire+0x214/0xa70
 [<c105088a>] lock_acquire+0x7a/0xa0
 [<c11108a8>] ? reiserfs_write_lock+0x28/0x40
 [<c134b5cf>] mutex_lock_nested+0x5f/0x2b0
 [<c11108a8>] ? reiserfs_write_lock+0x28/0x40
 [<c11108a8>] ? reiserfs_write_lock+0x28/0x40
 [<c11108a8>] reiserfs_write_lock+0x28/0x40
 [<c10ef6e0>] reiserfs_delete_inode+0x50/0x140
 [<c10a52df>] ? generic_delete_inode+0x5f/0x150
 [<c10ef690>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a531c>] generic_delete_inode+0x9c/0x150
 [<c10a540d>] generic_drop_inode+0x3d/0x60
 [<c10a4327>] iput+0x47/0x50
 [<c10a190f>] dentry_iput+0x6f/0xf0
 [<c10a1a34>] d_kill+0x24/0x50
 [<c10a1a34>] d_kill+0x24/0x50
 [<c10a1c7d>] __shrink_dcache_sb+0x21d/0x2b0
 [<c10a1e3f>] shrink_dcache_memory+0x12f/0x1a0
 [<c1073ec9>] shrink_slab+0x109/0x170
 [<c10743a9>] kswapd+0x479/0x5c0
 [<c10720d0>] ? isolate_pages_global+0x0/0x1b0
 [<c103e080>] ? autoremove_wake_function+0x0/0x40
 [<c1073f30>] ? kswapd+0x0/0x5c0
 [<c103de6c>] kthread+0x6c/0x80
 [<c103de00>] ? kthread+0x0/0x80
 [<c10031fb>] kernel_thread_helper+0x7/0x1c

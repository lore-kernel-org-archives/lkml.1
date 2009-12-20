Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZLTMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZLTMJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZLTMJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:09:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37718 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZLTMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ehw8SCqNEHC+qHgnznJgXqlibvFlDm1yGglswkbpluga1PieY9DltueElGLVUQGLpS
         iKv7UknUdv7jIdfRg67G8A3nBCAbABEDCzv50ZVyWX5dTldxmguo8hPgsmDEbhvCV/tr
         5LwyBWvl1aNaFAdOEyrZp0S3y+/SSZ/NgpraI=
MIME-Version: 1.0
In-Reply-To: <20091216224117.GA5014@nowhere>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
	 <20091214110921.GA5168@nowhere>
	 <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
	 <20091216224117.GA5014@nowhere>
Date: Sun, 20 Dec 2009 15:09:33 +0300
Message-ID: <a4423d670912200409w51690618i229b31c8c00f8dc4@mail.gmail.com>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic

This is Linus's v2.6.33-rc1-96-gdd59f6c
plus your 47376ceba5 "reiserfs: Fix reiserfs lock <-> inode mutex
dependency inversion"

[ INFO: inconsistent lock state ]
2.6.33-rc1-00101-g476ef56 #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/313 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c1111048>]
reiserfs_write_lock_once+0x28/0x50
{RECLAIM_FS-ON-W} state was registered at:
  [<c104e522>] mark_held_locks+0x62/0x90
  [<c104e5ea>] lockdep_trace_alloc+0x9a/0xc0
  [<c108efa6>] kmem_cache_alloc+0x26/0xf0
  [<c1085a0c>] __get_vm_area_node+0x6c/0xf0
  [<c10860fe>] __vmalloc_node+0x7e/0xa0
  [<c108629b>] vmalloc+0x2b/0x30
  [<c110d4ba>] journal_init+0x2a/0x9f0
  [<c10f8a32>] reiserfs_fill_super+0x342/0xb80
  [<c1094e85>] get_sb_bdev+0x145/0x180
  [<c10f6271>] get_super_block+0x21/0x30
  [<c1093d30>] vfs_kern_mount+0x40/0xd0
  [<c1093e19>] do_kern_mount+0x39/0xd0
  [<c10aa4f7>] do_mount+0x2c7/0x6b0
  [<c10aa946>] sys_mount+0x66/0xa0
  [<c16178a7>] mount_block_root+0xc4/0x245
  [<c1617a81>] mount_root+0x59/0x5f
  [<c1617b98>] prepare_namespace+0x111/0x14b
  [<c1617269>] kernel_init+0xcf/0xdb
  [<c100303a>] kernel_thread_helper+0x6/0x1c
irq event stamp: 2148275
hardirqs last  enabled at (2148275): [<c134d4aa>]
__mutex_unlock_slowpath+0x9a/0x120
hardirqs last disabled at (2148274): [<c134d449>]
__mutex_unlock_slowpath+0x39/0x120
softirqs last  enabled at (2147974): [<c102f591>] __do_softirq+0xc1/0x110
softirqs last disabled at (2147957): [<c102f62d>] do_softirq+0x4d/0x60

other info that might help us debug this:
2 locks held by kswapd0/313:
 #0:  (shrinker_rwsem){++++..}, at: [<c10742f4>] shrink_slab+0x24/0x170
 #1:  (&type->s_umount_key#19){++++..}, at: [<c10a291d>]
shrink_dcache_memory+0xfd/0x1a0

stack backtrace:
Pid: 313, comm: kswapd0 Not tainted 2.6.33-rc1-00101-g476ef56 #1
Call Trace:
 [<c134c7dc>] ? printk+0x18/0x1c
 [<c104dedf>] print_usage_bug+0x15f/0x1a0
 [<c104e2bf>] mark_lock+0x39f/0x5a0
 [<c104cd5b>] ? trace_hardirqs_off+0xb/0x10
 [<c1052340>] ? check_usage_forwards+0x0/0xf0
 [<c1050314>] __lock_acquire+0x214/0xa70
 [<c1042e75>] ? T.321+0x15/0x1a0
 [<c1050bea>] lock_acquire+0x7a/0xa0
 [<c1111048>] ? reiserfs_write_lock_once+0x28/0x50
 [<c134dcef>] mutex_lock_nested+0x5f/0x2b0
 [<c1111048>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1111048>] ? reiserfs_write_lock_once+0x28/0x50
 [<c1111048>] reiserfs_write_lock_once+0x28/0x50
 [<c10eff40>] reiserfs_delete_inode+0x50/0x140
 [<c10a5f7f>] ? generic_delete_inode+0x5f/0x150
 [<c10efef0>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a5fbc>] generic_delete_inode+0x9c/0x150
 [<c10a60ad>] generic_drop_inode+0x3d/0x60
 [<c10a4fd7>] iput+0x47/0x50
 [<c10a248f>] dentry_iput+0x6f/0xf0
 [<c10a2534>] d_kill+0x24/0x50
 [<c10a277d>] __shrink_dcache_sb+0x21d/0x2b0
 [<c10a294f>] shrink_dcache_memory+0x12f/0x1a0
 [<c10743de>] shrink_slab+0x10e/0x170
 [<c10748c7>] kswapd+0x487/0x740
 [<c10724f0>] ? isolate_pages_global+0x0/0x1b0
 [<c103e1c0>] ? autoremove_wake_function+0x0/0x40
 [<c1074440>] ? kswapd+0x0/0x740
 [<c103decc>] kthread+0x6c/0x80
 [<c103de60>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c

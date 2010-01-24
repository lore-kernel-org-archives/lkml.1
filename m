Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986Ab0AXSo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0AXSo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 13:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517Ab0AXSo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 13:44:27 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:43711 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0AXSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 13:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ueCwwN1RbzpFjGBHHC/KDIKAmuHEouV1UCRO3vnWtL1NonVZRvydsF1uXbu9mvMQlN
         mqUGSbAjbRfgCC9fsHmiDpZccNOB3fGojPlcRYcERnlnmbfW8IinIaxftIqXrKwX/+jb
         xClwrVDSuoDXPYg1ttzNG1P3ciW0xUooeMecA=
MIME-Version: 1.0
Date: Sun, 24 Jan 2010 21:44:25 +0300
Message-ID: <a4423d671001241044k4435417dt11aa2e0e9259fe93@mail.gmail.com>
Subject: reiserfs: lockdep warning
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic

Here is another warning:

[ INFO: inconsistent lock state ]
2.6.33-rc5 #1
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/313 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&REISERFS_SB(s)->lock){+.+.?.}, at: [<c11118c8>]
reiserfs_write_lock_once+0x28/0x50
{RECLAIM_FS-ON-W} state was registered at:
  [<c104ee32>] mark_held_locks+0x62/0x90
  [<c104eefa>] lockdep_trace_alloc+0x9a/0xc0
  [<c108f7b6>] kmem_cache_alloc+0x26/0xf0
  [<c108621c>] __get_vm_area_node+0x6c/0xf0
  [<c108690e>] __vmalloc_node+0x7e/0xa0
  [<c1086aab>] vmalloc+0x2b/0x30
  [<c110e1fb>] journal_init+0x6cb/0xa10
  [<c10f90a2>] reiserfs_fill_super+0x342/0xb80
  [<c1095665>] get_sb_bdev+0x145/0x180
  [<c10f68e1>] get_super_block+0x21/0x30
  [<c1094520>] vfs_kern_mount+0x40/0xd0
  [<c1094609>] do_kern_mount+0x39/0xd0
  [<c10aaa97>] do_mount+0x2c7/0x6d0
  [<c10aaf06>] sys_mount+0x66/0xa0
  [<c16198a7>] mount_block_root+0xc4/0x245
  [<c1619a81>] mount_root+0x59/0x5f
  [<c1619b98>] prepare_namespace+0x111/0x14b
  [<c1619269>] kernel_init+0xcf/0xdb
  [<c100303a>] kernel_thread_helper+0x6/0x1c
irq event stamp: 63236801
hardirqs last  enabled at (63236801): [<c134e7fa>]
__mutex_unlock_slowpath+0x9a/0x120
hardirqs last disabled at (63236800): [<c134e799>]
__mutex_unlock_slowpath+0x39/0x120
softirqs last  enabled at (63218800): [<c102f451>] __do_softirq+0xc1/0x110
softirqs last disabled at (63218789): [<c102f4ed>] do_softirq+0x4d/0x60

other info that might help us debug this:
2 locks held by kswapd0/313:
 #0:  (shrinker_rwsem){++++..}, at: [<c1074bb4>] shrink_slab+0x24/0x170
 #1:  (&type->s_umount_key#19){++++..}, at: [<c10a2edd>]
shrink_dcache_memory+0xfd/0x1a0

stack backtrace:
Pid: 313, comm: kswapd0 Not tainted 2.6.33-rc5 #1
Call Trace:
 [<c134db2c>] ? printk+0x18/0x1c
 [<c104e7ef>] print_usage_bug+0x15f/0x1a0
 [<c104ebcf>] mark_lock+0x39f/0x5a0
 [<c104d66b>] ? trace_hardirqs_off+0xb/0x10
 [<c1052c50>] ? check_usage_forwards+0x0/0xf0
 [<c1050c24>] __lock_acquire+0x214/0xa70
 [<c10438c5>] ? sched_clock_cpu+0x95/0x110
 [<c10514fa>] lock_acquire+0x7a/0xa0
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c134f03f>] mutex_lock_nested+0x5f/0x2b0
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c11118c8>] ? reiserfs_write_lock_once+0x28/0x50
 [<c11118c8>] reiserfs_write_lock_once+0x28/0x50
 [<c10f05b0>] reiserfs_delete_inode+0x50/0x140
 [<c10a653f>] ? generic_delete_inode+0x5f/0x150
 [<c10f0560>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a657c>] generic_delete_inode+0x9c/0x150
 [<c10a666d>] generic_drop_inode+0x3d/0x60
 [<c10a5597>] iput+0x47/0x50
 [<c10a2a4f>] dentry_iput+0x6f/0xf0
 [<c10a2af4>] d_kill+0x24/0x50
 [<c10a2d3d>] __shrink_dcache_sb+0x21d/0x2b0
 [<c10a2f0f>] shrink_dcache_memory+0x12f/0x1a0
 [<c1074c9e>] shrink_slab+0x10e/0x170
 [<c1075177>] kswapd+0x477/0x6a0
 [<c1072d10>] ? isolate_pages_global+0x0/0x1b0
 [<c103e160>] ? autoremove_wake_function+0x0/0x40
 [<c1074d00>] ? kswapd+0x0/0x6a0
 [<c103de6c>] kthread+0x6c/0x80
 [<c103de00>] ? kthread+0x0/0x80
 [<c100303a>] kernel_thread_helper+0x6/0x1c

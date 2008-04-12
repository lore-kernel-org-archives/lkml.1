Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYDLQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYDLQeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYDLQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:34:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYDLQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:34:02 -0400
Date: Sat, 12 Apr 2008 12:33:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ext3 jbd_handle/xattr_sem lockdep trace.
Message-ID: <20080412163359.GA23674@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-0.195.rc8.git1.fc9.i686 #1
-------------------------------------------------------
yum/12720 is trying to acquire lock:
 (jbd_handle){--..}, at: [<e085d8ff>] journal_start+0xcf/0xf0 [jbd]

but task is already holding lock:
 (&ei->xattr_sem){----}, at: [<e0899c1f>] ext3_xattr_get+0x2a/0x23b [ext3]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ei->xattr_sem){----}:
       [__lock_acquire+2713/3089] __lock_acquire+0xa99/0xc11
       [lock_acquire+106/144] lock_acquire+0x6a/0x90
       [down_read+48/106] down_read+0x30/0x6a
       [<e0899c1f>] ext3_xattr_get+0x2a/0x23b [ext3]
       [<e089a577>] ext3_get_acl+0xd2/0x2f2 [ext3]
       [<e089a9f0>] ext3_init_acl+0x40/0x140 [ext3]
       [<e088cbb8>] ext3_new_inode+0x8d2/0x8eb [ext3]
       [<e08927b1>] ext3_create+0x85/0xeb [ext3]
       [vfs_create+189/300] vfs_create+0xbd/0x12c
       [open_namei+351/1455] open_namei+0x15f/0x5af
       [do_filp_open+31/53] do_filp_open+0x1f/0x35
       [do_sys_open+64/181] do_sys_open+0x40/0xb5
       [sys_open+22/24] sys_open+0x16/0x18
       [syscall_call+7/11] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (jbd_handle){--..}:
       [__lock_acquire+2488/3089] __lock_acquire+0x9b8/0xc11
       [lock_acquire+106/144] lock_acquire+0x6a/0x90
       [<e085d913>] journal_start+0xe3/0xf0 [jbd]
       [<e0896774>] ext3_journal_start_sb+0x40/0x42 [ext3]
       [<e088e2af>] ext3_ordered_writepage+0x45/0x116 [ext3]
       [shrink_page_list+840/1415] shrink_page_list+0x348/0x587
       [shrink_inactive_list+292/779] shrink_inactive_list+0x124/0x30b
       [shrink_zone+187/218] shrink_zone+0xbb/0xda
       [try_to_free_pages+337/563] try_to_free_pages+0x151/0x233
       [__alloc_pages+494/815] __alloc_pages+0x1ee/0x32f
       [__slab_alloc+430/1355] __slab_alloc+0x1ae/0x54b
       [kmem_cache_alloc+98/196] kmem_cache_alloc+0x62/0xc4
       [<e082464c>] mb_cache_entry_alloc+0x13/0x3f [mbcache]
       [<e0898e07>] ext3_xattr_cache_insert+0x1d/0x55 [ext3]
       [<e0899df7>] ext3_xattr_get+0x202/0x23b [ext3]
       [<e089abcc>] ext3_xattr_security_get+0x33/0x41 [ext3]
       [generic_getxattr+101/104] generic_getxattr+0x65/0x68
       [inode_doinit_with_dentry+344/1277] inode_doinit_with_dentry+0x158/0x4fd
       [selinux_d_instantiate+18/20] selinux_d_instantiate+0x12/0x14
       [security_d_instantiate+28/30] security_d_instantiate+0x1c/0x1e
       [d_splice_alias+169/203] d_splice_alias+0xa9/0xcb
       [<e0892a36>] ext3_lookup+0x7b/0xa2 [ext3]
       [do_lookup+167/326] do_lookup+0xa7/0x146
       [__link_path_walk+2250/3378] __link_path_walk+0x8ca/0xd32
       [path_walk+76/155] path_walk+0x4c/0x9b
       [do_path_lookup+408/481] do_path_lookup+0x198/0x1e1
       [__user_walk_fd+47/67] __user_walk_fd+0x2f/0x43
       [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
       [vfs_stat+17/19] vfs_stat+0x11/0x13
       [sys_stat64+20/43] sys_stat64+0x14/0x2b
       [syscall_call+7/11] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by yum/12720:
 #0:  (&type->i_mutex_dir_key#4){--..}, at: [do_lookup+114/326] do_lookup+0x72/0x146
 #1:  (&isec->lock){--..}, at: [inode_doinit_with_dentry+56/1277] inode_doinit_with_dentry+0x38/0x4fd
 #2:  (&ei->xattr_sem){----}, at: [<e0899c1f>] ext3_xattr_get+0x2a/0x23b [ext3]

stack backtrace:
Pid: 12720, comm: yum Not tainted 2.6.25-0.195.rc8.git1.fc9.i686 #1
 [print_circular_bug_tail+91/102] print_circular_bug_tail+0x5b/0x66
 [print_circular_bug_header+166/177] ? print_circular_bug_header+0xa6/0xb1
 [__lock_acquire+2488/3089] __lock_acquire+0x9b8/0xc11
 [<e085d75a>] ? start_this_handle+0x2d1/0x2f0 [jbd]
 [lock_acquire+106/144] lock_acquire+0x6a/0x90
 [<e085d8ff>] ? journal_start+0xcf/0xf0 [jbd]
 [<e085d913>] journal_start+0xe3/0xf0 [jbd]
 [<e085d8ff>] ? journal_start+0xcf/0xf0 [jbd]
 [<e0896774>] ext3_journal_start_sb+0x40/0x42 [ext3]
 [<e088e2af>] ext3_ordered_writepage+0x45/0x116 [ext3]
 [shrink_page_list+840/1415] shrink_page_list+0x348/0x587
 [list_add+10/15] ? list_add+0xa/0xf
 [isolate_lru_pages+132/370] ? isolate_lru_pages+0x84/0x172
 [native_sched_clock+181/209] ? native_sched_clock+0xb5/0xd1
 [shrink_inactive_list+292/779] shrink_inactive_list+0x124/0x30b
 [shrink_zone+187/218] shrink_zone+0xbb/0xda
 [try_to_free_pages+337/563] try_to_free_pages+0x151/0x233
 [get_page_from_freelist+151/1010] ? get_page_from_freelist+0x97/0x3f2
 [isolate_pages_global+0/62] ? isolate_pages_global+0x0/0x3e
 [__alloc_pages+494/815] __alloc_pages+0x1ee/0x32f
 [__slab_alloc+430/1355] __slab_alloc+0x1ae/0x54b
 [kmem_cache_alloc+98/196] kmem_cache_alloc+0x62/0xc4
 [<e082464c>] ? mb_cache_entry_alloc+0x13/0x3f [mbcache]
 [<e082464c>] ? mb_cache_entry_alloc+0x13/0x3f [mbcache]
 [<e082464c>] mb_cache_entry_alloc+0x13/0x3f [mbcache]
 [<e0898e07>] ext3_xattr_cache_insert+0x1d/0x55 [ext3]
 [<e0899df7>] ext3_xattr_get+0x202/0x23b [ext3]
 [__slab_alloc+1222/1355] ? __slab_alloc+0x4c6/0x54b
 [<e089abcc>] ext3_xattr_security_get+0x33/0x41 [ext3]
 [generic_getxattr+101/104] generic_getxattr+0x65/0x68
 [inode_doinit_with_dentry+344/1277] inode_doinit_with_dentry+0x158/0x4fd
 [d_splice_alias+160/203] ? d_splice_alias+0xa0/0xcb
 [selinux_d_instantiate+18/20] selinux_d_instantiate+0x12/0x14
 [security_d_instantiate+28/30] security_d_instantiate+0x1c/0x1e
 [d_splice_alias+169/203] d_splice_alias+0xa9/0xcb
 [<e0892a36>] ext3_lookup+0x7b/0xa2 [ext3]
 [do_lookup+167/326] do_lookup+0xa7/0x146
 [__link_path_walk+2250/3378] __link_path_walk+0x8ca/0xd32
 [native_sched_clock+181/209] ? native_sched_clock+0xb5/0xd1
 [lock_release_holdtime+26/277] ? lock_release_holdtime+0x1a/0x115
 [path_walk+76/155] path_walk+0x4c/0x9b
 [do_path_lookup+408/481] do_path_lookup+0x198/0x1e1
 [__user_walk_fd+47/67] __user_walk_fd+0x2f/0x43
 [vfs_stat_fd+25/64] vfs_stat_fd+0x19/0x40
 [vfs_stat+17/19] vfs_stat+0x11/0x13
 [sys_stat64+20/43] sys_stat64+0x14/0x2b
 [restore_nocheck+18/21] ? restore_nocheck+0x12/0x15
 [trace_hardirqs_on+233/266] ? trace_hardirqs_on+0xe9/0x10a
 [restore_nocheck+18/21] ? restore_nocheck+0x12/0x15
 [syscall_call+7/11] syscall_call+0x7/0xb
 =======================


-- 
http://www.codemonkey.org.uk

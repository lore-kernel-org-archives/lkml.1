Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYDLQer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYDLQer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYDLQej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:34:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYDLQeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:34:37 -0400
Date: Sat, 12 Apr 2008 12:34:36 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ext3 truncate/quota lockdep trace.
Message-ID: <20080412163436.GB23674@redhat.com>
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
2.6.25-0.195.rc8.git1.fc9.x86_64 #1
-------------------------------------------------------
tar/4243 is trying to acquire lock:
 (&ei->truncate_mutex){--..}, at: [_end+107219435/2109740072] ext3_get_blocks_handle+0x143/0x8b1 [ext3]

but task is already holding lock:
 (&sb->s_type->i_mutex_key#9/4){--..}, at: [_end+107246718/2109740072] ext3_quota_write+0xb4/0x239 [ext3]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&sb->s_type->i_mutex_key#9/4){--..}:
       [__lock_acquire+3027/3427] __lock_acquire+0xbd3/0xd63
       [lock_acquire+94/120] lock_acquire+0x5e/0x78
       [mutex_lock_nested+247/661] mutex_lock_nested+0xf7/0x295
       [_end+107246718/2109740072] ext3_quota_write+0xb4/0x239 [ext3]
       [v2_write_dquot+280/359] v2_write_dquot+0x118/0x167
       [dquot_commit+160/243] dquot_commit+0xa0/0xf3
       [_end+107256471/2109740072] ext3_write_dquot+0x64/0x89 [ext3]
       [dqput+304/458] dqput+0x130/0x1ca
       [dquot_drop+48/112] dquot_drop+0x30/0x70
       [_end+107256657/2109740072] ext3_dquot_drop+0x4c/0x6c [ext3]
       [_end+107210573/2109740072] ext3_free_inode+0xf9/0x2dc [ext3]
       [_end+107226100/2109740072] ext3_delete_inode+0xba/0xda [ext3]
       [generic_delete_inode+184/325] generic_delete_inode+0xb8/0x145
       [generic_drop_inode+21/362] generic_drop_inode+0x15/0x16a
       [iput+124/128] iput+0x7c/0x80
       [do_unlinkat+254/340] do_unlinkat+0xfe/0x154
       [sys_unlinkat+36/38] sys_unlinkat+0x24/0x26
       [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #3 (&s->s_dquot.dqio_mutex){--..}:
       [__lock_acquire+3027/3427] __lock_acquire+0xbd3/0xd63
       [lock_acquire+94/120] lock_acquire+0x5e/0x78
       [mutex_lock_nested+247/661] mutex_lock_nested+0xf7/0x295
       [dquot_acquire+65/276] dquot_acquire+0x41/0x114
       [_end+107256334/2109740072] ext3_acquire_dquot+0x64/0x89 [ext3]
       [dqget+665/712] dqget+0x299/0x2c8
       [dquot_initialize+136/188] dquot_initialize+0x88/0xbc
       [_end+107256769/2109740072] ext3_dquot_initialize+0x50/0x73 [ext3]
       [vfs_quota_on_inode+876/1118] vfs_quota_on_inode+0x36c/0x45e
       [vfs_quota_on+111/143] vfs_quota_on+0x6f/0x8f
       [_end+107242277/2109740072] ext3_quota_on+0xd9/0xeb [ext3]
       [sys_quotactl+918/1582] sys_quotactl+0x396/0x62e
       [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&dquot->dq_lock){--..}:
       [__lock_acquire+3027/3427] __lock_acquire+0xbd3/0xd63
       [lock_acquire+94/120] lock_acquire+0x5e/0x78
       [mutex_lock_nested+247/661] mutex_lock_nested+0xf7/0x295
       [dqget+636/712] dqget+0x27c/0x2c8
       [dquot_initialize+136/188] dquot_initialize+0x88/0xbc
       [_end+107256769/2109740072] ext3_dquot_initialize+0x50/0x73 [ext3]
       [vfs_quota_on_inode+876/1118] vfs_quota_on_inode+0x36c/0x45e
       [vfs_quota_on+111/143] vfs_quota_on+0x6f/0x8f
       [_end+107242277/2109740072] ext3_quota_on+0xd9/0xeb [ext3]
       [sys_quotactl+918/1582] sys_quotactl+0x396/0x62e
       [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&s->s_dquot.dqptr_sem){----}:
       [__lock_acquire+3027/3427] __lock_acquire+0xbd3/0xd63
       [lock_acquire+94/120] lock_acquire+0x5e/0x78
       [down_read+64/109] down_read+0x40/0x6d
       [dquot_free_space+57/412] dquot_free_space+0x39/0x19c
       [_end+107200960/2109740072] ext3_free_blocks+0x5e/0x7c [ext3]
       [_end+107222729/2109740072] ext3_clear_blocks+0x180/0x19a [ext3]
       [_end+107222931/2109740072] ext3_free_data+0xb0/0xd6 [ext3]
       [_end+107225000/2109740072] ext3_truncate+0x589/0x91b [ext3]
       [vmtruncate+194/228] vmtruncate+0xc2/0xe4
       [inode_setattr+43/293] inode_setattr+0x2b/0x125
       [_end+107215384/2109740072] ext3_setattr+0x1bc/0x223 [ext3]
       [notify_change+383/782] notify_change+0x17f/0x30e
       [do_truncate+101/131] do_truncate+0x65/0x83
       [may_open+443/529] may_open+0x1bb/0x211
       [open_namei+719/1726] open_namei+0x2cf/0x6be
       [do_filp_open+40/75] do_filp_open+0x28/0x4b
       [do_sys_open+81/210] do_sys_open+0x51/0xd2
       [sys_open+27/29] sys_open+0x1b/0x1d
       [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&ei->truncate_mutex){--..}:
       [__lock_acquire+2774/3427] __lock_acquire+0xad6/0xd63
       [lock_acquire+94/120] lock_acquire+0x5e/0x78
       [mutex_lock_nested+247/661] mutex_lock_nested+0xf7/0x295
       [_end+107219435/2109740072] ext3_get_blocks_handle+0x143/0x8b1 [ext3]
       [_end+107221689/2109740072] ext3_getblk+0x64/0x194 [ext3]
       [_end+107222015/2109740072] ext3_bread+0x16/0x82 [ext3]
       [_end+107246762/2109740072] ext3_quota_write+0xe0/0x239 [ext3]
       [get_free_dqblk+181/231] get_free_dqblk+0xb5/0xe7
       [do_insert_tree+505/1069] do_insert_tree+0x1f9/0x42d
       [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
       [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
       [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
       [v2_write_dquot+54/359] v2_write_dquot+0x36/0x167
       [dquot_acquire+164/276] dquot_acquire+0xa4/0x114
       [_end+107256334/2109740072] ext3_acquire_dquot+0x64/0x89 [ext3]
       [dqget+665/712] dqget+0x299/0x2c8
       [dquot_transfer+227/949] dquot_transfer+0xe3/0x3b5
       [_end+107215161/2109740072] ext3_setattr+0xdd/0x223 [ext3]
       [notify_change+383/782] notify_change+0x17f/0x30e
       [chown_common+171/196] chown_common+0xab/0xc4
       [sys_chown+76/105] sys_chown+0x4c/0x69
       [tracesys+213/218] tracesys+0xd5/0xda
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

6 locks held by tar/4243:
 #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [chown_common+159/196] chown_common+0x9f/0xc4
 #1:  (jbd_handle){--..}, at: [_end+107143484/2109740072] journal_start+0xef/0x115 [jbd]
 #2:  (&s->s_dquot.dqptr_sem){----}, at: [dquot_transfer+154/949] dquot_transfer+0x9a/0x3b5
 #3:  (&dquot->dq_lock){--..}, at: [dquot_acquire+48/276] dquot_acquire+0x30/0x114
 #4:  (&s->s_dquot.dqio_mutex){--..}, at: [dquot_acquire+65/276] dquot_acquire+0x41/0x114
 #5:  (&sb->s_type->i_mutex_key#9/4){--..}, at: [_end+107246718/2109740072] ext3_quota_write+0xb4/0x239 [ext3]

stack backtrace:
Pid: 4243, comm: tar Not tainted 2.6.25-0.195.rc8.git1.fc9.x86_64 #1

Call Trace:
 [print_circular_bug_tail+112/123] print_circular_bug_tail+0x70/0x7b
 [print_circular_bug_entry+72/79] ? print_circular_bug_entry+0x48/0x4f
 [__lock_acquire+2774/3427] __lock_acquire+0xad6/0xd63
 [_spin_unlock_irqrestore+56/71] ? _spin_unlock_irqrestore+0x38/0x47
 [sched_clock+80/109] ? native_sched_clock+0x50/0x6d
 [lock_acquire+94/120] lock_acquire+0x5e/0x78
 [_end+107219435/2109740072] ? :ext3:ext3_get_blocks_handle+0x143/0x8b1
 [mutex_lock_nested+247/661] mutex_lock_nested+0xf7/0x295
 [_end+107219435/2109740072] ? :ext3:ext3_get_blocks_handle+0x143/0x8b1
 [sched_clock+80/109] ? native_sched_clock+0x50/0x6d
 [sched_clock+80/109] ? native_sched_clock+0x50/0x6d
 [_end+107219435/2109740072] :ext3:ext3_get_blocks_handle+0x143/0x8b1
 [sched_clock+80/109] ? native_sched_clock+0x50/0x6d
 [sched_clock+80/109] ? native_sched_clock+0x50/0x6d
 [_end+107221689/2109740072] :ext3:ext3_getblk+0x64/0x194
 [mark_held_locks+92/119] ? mark_held_locks+0x5c/0x77
 [mutex_lock_nested+634/661] ? mutex_lock_nested+0x27a/0x295
 [trace_hardirqs_on+241/277] ? trace_hardirqs_on+0xf1/0x115
 [mutex_lock_nested+646/661] ? mutex_lock_nested+0x286/0x295
 [_end+107246718/2109740072] ? :ext3:ext3_quota_write+0xb4/0x239
 [_end+107222015/2109740072] :ext3:ext3_bread+0x16/0x82
 [_end+107246762/2109740072] :ext3:ext3_quota_write+0xe0/0x239
 [get_free_dqblk+181/231] get_free_dqblk+0xb5/0xe7
 [do_insert_tree+505/1069] do_insert_tree+0x1f9/0x42d
 [_end+107247324/2109740072] ? :ext3:ext3_quota_read+0xd9/0xfe
 [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
 [_end+107247324/2109740072] ? :ext3:ext3_quota_read+0xd9/0xfe
 [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
 [_end+107247324/2109740072] ? :ext3:ext3_quota_read+0xd9/0xfe
 [do_insert_tree+876/1069] do_insert_tree+0x36c/0x42d
 [find_tree_dqentry+487/505] ? find_tree_dqentry+0x1e7/0x1f9
 [v2_write_dquot+54/359] v2_write_dquot+0x36/0x167
 [v2_read_dquot+91/459] ? v2_read_dquot+0x5b/0x1cb
 [mutex_lock_nested+646/661] ? mutex_lock_nested+0x286/0x295
 [dquot_acquire+65/276] ? dquot_acquire+0x41/0x114
 [dquot_acquire+164/276] dquot_acquire+0xa4/0x114
 [_end+107256334/2109740072] :ext3:ext3_acquire_dquot+0x64/0x89
 [dqget+665/712] dqget+0x299/0x2c8
 [dquot_transfer+227/949] dquot_transfer+0xe3/0x3b5
 [_end+107215161/2109740072] :ext3:ext3_setattr+0xdd/0x223
 [notify_change+383/782] notify_change+0x17f/0x30e
 [chown_common+171/196] chown_common+0xab/0xc4
 [sys_chown+76/105] sys_chown+0x4c/0x69
 [audit_syscall_exit+817/851] ? audit_syscall_exit+0x331/0x353
 [syscall_trace_enter+181/185] ? syscall_trace_enter+0xb5/0xb9
 [tracesys+113/218] ? tracesys+0x71/0xda
 [tracesys+213/218] tracesys+0xd5/0xda



-- 
http://www.codemonkey.org.uk

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbXFGLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbXFGLNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXFGLNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:13:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43668 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbXFGLNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:13:09 -0400
Date: Thu, 7 Jun 2007 13:13:06 +0200
From: Jan Kara <jack@suse.cz>
To: "alpha @ steudten Engineering" <NWQ3MzhlY2QwZDAzODVhN@steudten.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.20: possible circular locking dependency detected
Message-ID: <20070607111306.GF31483@atrey.karlin.mff.cuni.cz>
References: <465D6F57.5040709@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465D6F57.5040709@steudten.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Thanks for report. It's actually a false warning and should be fixed
in 2.6.22 or so...

									Honza

> Linux version 2.6.20-1.2948.self (rpmbuild@merlin.linux.alpha) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP
> Mon May 7 11:07:53 CEST 2007
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.20-1.2948.self #1
> -------------------------------------------------------
> squid/4111 is trying to acquire lock:
>  (tty_mutex){--..}, at: [<c019fb54>] print_warning+0x8b/0x12e
> 
> but task is already holding lock:
>  (&s->s_dquot.dqptr_sem){----}, at: [<c01a0802>] dquot_alloc_inode+0x34/0x10a
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #4 (&s->s_dquot.dqptr_sem){----}:
>        [<c013a89d>] __lock_acquire+0x950/0xa70
>        [<c01a06bb>] dquot_alloc_space+0x42/0x155
>        [<c013acf8>] lock_acquire+0x67/0x89
>        [<c01a06bb>] dquot_alloc_space+0x42/0x155
>        [<c013683a>] down_read+0x38/0x49
>        [<c01a06bb>] dquot_alloc_space+0x42/0x155
>        [<c01a06bb>] dquot_alloc_space+0x42/0x155
>        [<c01ae738>] ext3_new_blocks+0x83/0x5c4
>        [<c019dd86>] mb_cache_entry_find_first+0x29/0x5b
>        [<c01aec99>] ext3_new_block+0x20/0x25
>        [<c01bcec2>] ext3_xattr_block_set+0x57b/0x7ce
>        [<c01b0e41>] __ext3_get_inode_loc+0x10f/0x2fb
>        [<c01bf52b>] journal_get_write_access+0x21/0x26
>        [<c01bd494>] ext3_xattr_set_handle+0x37f/0x47f
>        [<c01be8ac>] ext3_init_security+0x70/0x91
>        [<c01b0423>] ext3_new_inode+0x877/0x98b
>        [<c01bf8c5>] start_this_handle+0x256/0x341
>        [<c034a84b>] _spin_unlock+0x14/0x1c
>        [<c01bf994>] start_this_handle+0x325/0x341
>        [<c016ff4c>] cache_alloc_debugcheck_after+0xc4/0x136
>        [<c0139b22>] trace_hardirqs_on+0x141/0x164
>        [<c01bf042>] journal_stop+0x1ce/0x1da
>        [<c01bfa5f>] journal_start+0xaf/0xdd
>        [<c019ef57>] dquot_initialize+0x21/0x87
>        [<c01b62cd>] ext3_create+0x7b/0xe2
>        [<c017b5f3>] vfs_create+0xca/0x134
>        [<c017de64>] open_namei+0x177/0x5a2
>        [<c01734f6>] get_unused_fd+0x22/0xbd
>        [<c016303c>] __handle_mm_fault+0x8c0/0x8e2
>        [<c01737b9>] do_filp_open+0x25/0x39
>        [<c034a84b>] _spin_unlock+0x14/0x1c
>        [<c0173587>] get_unused_fd+0xb3/0xbd
>        [<c017380f>] do_sys_open+0x42/0xbe
>        [<c01738c4>] sys_open+0x1c/0x1e
>        [<c0102ff4>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> -> #3 (&ei->xattr_sem){----}:
>        [<c013a89d>] __lock_acquire+0x950/0xa70
>        [<c01bd804>] ext3_xattr_get+0x2e/0x239
>        [<c013acf8>] lock_acquire+0x67/0x89
>        [<c01bd804>] ext3_xattr_get+0x2e/0x239
>        [<c013683a>] down_read+0x38/0x49
>        [<c01bd804>] ext3_xattr_get+0x2e/0x239
>        [<c01bd804>] ext3_xattr_get+0x2e/0x239
>        [<c0139909>] mark_held_locks+0x46/0x62
>        [<c0349533>] __mutex_lock_slowpath+0x292/0x2af
>        [<c016ff4c>] cache_alloc_debugcheck_after+0xc4/0x136
>        [<c01be90e>] ext3_xattr_security_get+0x41/0x4b
>        [<c018b185>] generic_getxattr+0x41/0x47
>        [<c01df2c5>] inode_doinit_with_dentry+0x16e/0x4ba
>        [<c01be90e>] ext3_xattr_security_get+0x41/0x4b
>        [<c018b144>] generic_getxattr+0x0/0x47
>        [<c01dfe9a>] superblock_doinit+0x6c3/0x751
>        [<c01e02f3>] selinux_complete_init+0x64/0xb6
>        [<c013683a>] down_read+0x38/0x49
>        [<c01e0302>] selinux_complete_init+0x73/0xb6
>        [<c01eaea1>] security_load_policy+0xed/0x275
>        [<c034ad4a>] _spin_unlock_irqrestore+0x3e/0x4d
>        [<c0139909>] mark_held_locks+0x46/0x62
>        [<c034ad4a>] _spin_unlock_irqrestore+0x3e/0x4d
>        [<c034ad4a>] _spin_unlock_irqrestore+0x3e/0x4d
>        [<c0139b22>] trace_hardirqs_on+0x141/0x164
>        [<c0152452>] delayacct_end+0x55/0x77
>        [<c015246d>] delayacct_end+0x70/0x77
>        [<c0157372>] sync_page+0x0/0x3b
>        [<c0152565>] __delayacct_blkio_end+0x5b/0x5e
>        [<c01629df>] __handle_mm_fault+0x263/0x8e2
>        [<c0157364>] __lock_page+0x58/0x5e
>        [<c01629df>] __handle_mm_fault+0x263/0x8e2
>        [<c011b784>] kunmap_atomic+0x54/0x61
>        [<c016303c>] __handle_mm_fault+0x8c0/0x8e2
>        [<c034c403>] do_page_fault+0x16b/0x4f2
>        [<c01368ac>] up_read+0x14/0x28
>        [<c034c529>] do_page_fault+0x291/0x4f2
>        [<c0103045>] restore_nocheck+0x12/0x15
>        [<c0103045>] restore_nocheck+0x12/0x15
>        [<c0204b16>] __copy_from_user_ll+0xcb/0xd6
>        [<c01e3c9d>] sel_write_load+0xa6/0x2dd
>        [<c01e3bf7>] sel_write_load+0x0/0x2dd
>        [<c017510e>] vfs_write+0xa8/0x154
>        [<c0175729>] sys_write+0x41/0x67
>        [<c0102ff4>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> -> #2 (&isec->lock){--..}:
>        [<c013a89d>] __lock_acquire+0x950/0xa70
>        [<c01df18c>] inode_doinit_with_dentry+0x35/0x4ba
>        [<c0139ca8>] check_usage+0x24/0x245
>        [<c013acf8>] lock_acquire+0x67/0x89
>        [<c01df18c>] inode_doinit_with_dentry+0x35/0x4ba
>        [<c03493a7>] __mutex_lock_slowpath+0x106/0x2af
>        [<c01df18c>] inode_doinit_with_dentry+0x35/0x4ba
>        [<c011c219>] __might_sleep+0x21/0xf0
>        [<c01df18c>] inode_doinit_with_dentry+0x35/0x4ba
>        [<c013ac87>] lock_release+0x16b/0x175
>        [<c01838ac>] d_instantiate+0x7e/0x82
>        [<c01ab0a1>] sysfs_create+0x85/0xb6
>        [<c01aba74>] init_dir+0x0/0x1a
>        [<c01abe50>] create_dir+0x9e/0x19a
>        [<c01ac614>] sysfs_create_dir+0x45/0x5f
>        [<c020120c>] kobject_add+0xdd/0x194
>        [<c02013b8>] subsystem_register+0xf/0x1c
>        [<c049204d>] mnt_init+0xe8/0x1c6
>        [<c0491d3e>] vfs_caches_init+0x135/0x144
>        [<c0493c43>] security_init+0x2d/0x3d
>        [<c0480695>] start_kernel+0x2cb/0x427
>        [<c04801c8>] unknown_bootoption+0x0/0x202
>        [<ffffffff>] 0xffffffff
> 
> -> #1 (&sysfs_inode_imutex_key){--..}:
>        [<c013a89d>] __lock_acquire+0x950/0xa70
>        [<c01aae4a>] sysfs_hash_and_remove+0x34/0x116
>        [<c017cdcf>] __link_path_walk+0xad6/0xc13
>        [<c0139b22>] trace_hardirqs_on+0x141/0x164
>        [<c013acf8>] lock_acquire+0x67/0x89
>        [<c01aae4a>] sysfs_hash_and_remove+0x34/0x116
>        [<c03493a7>] __mutex_lock_slowpath+0x106/0x2af
>        [<c01aae4a>] sysfs_hash_and_remove+0x34/0x116
>        [<c01aae4a>] sysfs_hash_and_remove+0x34/0x116
>        [<c0279d13>] device_remove_file+0x1c/0x28
>        [<c0279d7f>] device_del+0x29/0x1b8
>        [<c0279f16>] device_unregister+0x8/0x10
>        [<c02606b9>] vcs_remove_sysfs+0x17/0x31
>        [<c0265257>] con_close+0x49/0x5b
>        [<c0259ecf>] release_dev+0x210/0x61e
>        [<c025bed2>] tty_open+0x233/0x2ba
>        [<c0176fec>] chrdev_open+0x10b/0x138
>        [<c0176ee1>] chrdev_open+0x0/0x138
>        [<c0173454>] fd_install+0x21/0x49
>        [<c0173785>] nameidata_to_filp+0x24/0x33
>        [<c01743c0>] sys_close+0x21/0xa7
>        [<c025a2ec>] tty_release+0xf/0x18
>        [<c0175a78>] __fput+0xb5/0x16b
>        [<c01734cd>] filp_close+0x51/0x58
>        [<c017440f>] sys_close+0x70/0xa7
>        [<c0102ff4>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (tty_mutex){--..}:
>        [<c013a7a7>] __lock_acquire+0x85a/0xa70
>        [<c019fb54>] print_warning+0x8b/0x12e
>        [<c0349288>] __mutex_unlock_slowpath+0x13c/0x150
>        [<c0139909>] mark_held_locks+0x46/0x62
>        [<c0349288>] __mutex_unlock_slowpath+0x13c/0x150
>        [<c013acf8>] lock_acquire+0x67/0x89
>        [<c019fb54>] print_warning+0x8b/0x12e
>        [<c03493a7>] __mutex_lock_slowpath+0x106/0x2af
>        [<c019fb54>] print_warning+0x8b/0x12e
>        [<c019fb54>] print_warning+0x8b/0x12e
>        [<c01a08ba>] dquot_alloc_inode+0xec/0x10a
>        [<c01b0403>] ext3_new_inode+0x857/0x98b
>        [<c01bf8c5>] start_this_handle+0x256/0x341
>        [<c034a84b>] _spin_unlock+0x14/0x1c
>        [<c01bf994>] start_this_handle+0x325/0x341
>        [<c016ff4c>] cache_alloc_debugcheck_after+0xc4/0x136
>        [<c0139b22>] trace_hardirqs_on+0x141/0x164
>        [<c01bf042>] journal_stop+0x1ce/0x1da
>        [<c01bfa5f>] journal_start+0xaf/0xdd
>        [<c01b62cd>] ext3_create+0x7b/0xe2
>        [<c017b5f3>] vfs_create+0xca/0x134
>        [<c017de64>] open_namei+0x177/0x5a2
>        [<c01734f6>] get_unused_fd+0x22/0xbd
>        [<c014ef76>] __audit_getname+0x84/0xdd
>        [<c01737b9>] do_filp_open+0x25/0x39
>        [<c034a84b>] _spin_unlock+0x14/0x1c
>        [<c0173587>] get_unused_fd+0xb3/0xbd
>        [<c034a80a>] _read_unlock+0x14/0x1c
>        [<c017380f>] do_sys_open+0x42/0xbe
>        [<c01738c4>] sys_open+0x1c/0x1e
>        [<c0102ff4>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by squid/4111:
>  #0:  (&inode->i_mutex){--..}, at: [<c017ddcf>] open_namei+0xe2/0x5a2
>  #1:  (&s->s_dquot.dqptr_sem){----}, at: [<c01a0802>] dquot_alloc_inode+0x34/0x10a
> 
> stack backtrace:
>  [<c0139027>] print_circular_bug_tail+0x5f/0x67
>  [<c013a7a7>] __lock_acquire+0x85a/0xa70
>  [<c019fb54>] print_warning+0x8b/0x12e
>  [<c0349288>] __mutex_unlock_slowpath+0x13c/0x150
>  [<c0139909>] mark_held_locks+0x46/0x62
>  [<c0349288>] __mutex_unlock_slowpath+0x13c/0x150
>  [<c013acf8>] lock_acquire+0x67/0x89
>  [<c019fb54>] print_warning+0x8b/0x12e
>  [<c03493a7>] __mutex_lock_slowpath+0x106/0x2af
>  [<c019fb54>] print_warning+0x8b/0x12e
>  [<c019fb54>] print_warning+0x8b/0x12e
>  [<c01a08ba>] dquot_alloc_inode+0xec/0x10a
>  [<c01b0403>] ext3_new_inode+0x857/0x98b
>  [<c01bf8c5>] start_this_handle+0x256/0x341
>  [<c034a84b>] _spin_unlock+0x14/0x1c
>  [<c01bf994>] start_this_handle+0x325/0x341
>  [<c016ff4c>] cache_alloc_debugcheck_after+0xc4/0x136
>  [<c0139b22>] trace_hardirqs_on+0x141/0x164
>  [<c01bf042>] journal_stop+0x1ce/0x1da
>  [<c01bfa5f>] journal_start+0xaf/0xdd
>  [<c01b62cd>] ext3_create+0x7b/0xe2
>  [<c017b5f3>] vfs_create+0xca/0x134
>  [<c017de64>] open_namei+0x177/0x5a2
>  [<c01734f6>] get_unused_fd+0x22/0xbd
>  [<c014ef76>] __audit_getname+0x84/0xdd
>  [<c01737b9>] do_filp_open+0x25/0x39
>  [<c034a84b>] _spin_unlock+0x14/0x1c
>  [<c0173587>] get_unused_fd+0xb3/0xbd
>  [<c034a80a>] _read_unlock+0x14/0x1c
>  [<c017380f>] do_sys_open+0x42/0xbe
>  [<c01738c4>] sys_open+0x1c/0x1e
>  [<c0102ff4>] syscall_call+0x7/0xb
>  =======================
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

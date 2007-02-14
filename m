Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXBNWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXBNWBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXBNWBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:01:17 -0500
Received: from keetweej.vanheusden.com ([213.84.46.114]:45836 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbXBNWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:01:15 -0500
Date: Wed, 14 Feb 2007 22:59:23 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.20] possible circular locking dependency detected
Message-ID: <20070214215922.GW26684@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Feb 15 16:23:53 CET 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is this of any interest?

[  141.713801] =======================================================
[  141.713891] [ INFO: possible circular locking dependency detected ]
[  141.713937] 2.6.20 #2
[  141.713980] -------------------------------------------------------
[  141.714025] tor/5534 is trying to acquire lock:
[  141.714070]  (tty_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  141.714272] 
[  141.714273] but task is already holding lock:
[  141.714277]  (&s->s_dquot.dqptr_sem){----}, at: [<c1099403>] dquot_alloc_space+0x50/0x189
[  141.714484] 
[  141.714486] which lock already depends on the new lock.
[  141.714488] 
[  141.714490] 
[  141.714491] the existing dependency chain (in reverse order) is:
[  141.714690] 
[  141.714691] -> #4 (&s->s_dquot.dqptr_sem){----}:
[  141.714696]        [<c10354b8>] check_prev_add+0x154/0x206
[  141.714706]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.714716]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.714723]        [<c1037624>] lock_acquire+0x62/0x81
[  141.714730]        [<c1032b5f>] down_read+0x2b/0x3d
[  141.714739]        [<c1099403>] dquot_alloc_space+0x50/0x189
[  141.714746]        [<c10a98e6>] ext3_new_blocks+0x44b/0x5a2
[  141.714754]        [<c10abe78>] ext3_alloc_blocks+0x40/0xdf
[  141.714762]        [<c10abf67>] ext3_alloc_branch+0x50/0x21b
[  141.714770]        [<c10ac445>] ext3_get_blocks_handle+0x1b8/0x367
[  141.714778]        [<c10ac76e>] ext3_getblk+0x97/0x228
[  141.714786]        [<c10ac919>] ext3_bread+0x1a/0x78
[  141.714796]        [<c10b1bc2>] ext3_mkdir+0xf4/0x270
[  141.714803]        [<c1072a6a>] vfs_mkdir+0xb3/0x161
[  141.714811]        [<c1072ba4>] sys_mkdirat+0x8c/0xc4
[  141.714818]        [<c1072bfc>] sys_mkdir+0x20/0x22
[  141.714826]        [<c1002f78>] syscall_call+0x7/0xb
[  141.714836]        [<ffffffff>] 0xffffffff
[  141.714857] 
[  141.714858] -> #3 (&ei->truncate_mutex){--..}:
[  141.714861]        [<c10354b8>] check_prev_add+0x154/0x206
[  141.714870]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.714880]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.714887]        [<c1037624>] lock_acquire+0x62/0x81
[  141.714894]        [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  141.714902]        [<c1205b88>] mutex_lock+0x8/0xa
[  141.714908]        [<c10ae14f>] ext3_truncate+0x170/0x468
[  141.714919]        [<c1058e72>] vmtruncate+0xa6/0x116
[  141.714927]        [<c107d587>] inode_setattr+0x145/0x16c
[  141.714935]        [<c10af071>] ext3_setattr+0x150/0x22f
[  141.714944]        [<c107d909>] notify_change+0x35b/0x392
[  141.714952]        [<c10679d2>] do_truncate+0x52/0x75
[  141.714963]        [<c1071f5e>] may_open+0x1ec/0x231
[  141.714971]        [<c107211c>] open_namei+0xda/0x59b
[  141.714978]        [<c106863a>] do_filp_open+0x2c/0x53
[  141.714986]        [<c106896f>] do_sys_open+0x52/0xd8
[  141.714994]        [<c1068a11>] sys_open+0x1c/0x1e
[  141.715004]        [<c1002f78>] syscall_call+0x7/0xb
[  141.715010]        [<ffffffff>] 0xffffffff
[  141.715020] 
[  141.715020] -> #2 (&inode->i_alloc_sem){--..}:
[  141.715024]        [<c10354b8>] check_prev_add+0x154/0x206
[  141.715034]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.715045]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.715052]        [<c1037624>] lock_acquire+0x62/0x81
[  141.715058]        [<c1032bf5>] down_write+0x2b/0x45
[  141.715066]        [<c107d890>] notify_change+0x2e2/0x392
[  141.715073]        [<c10679d2>] do_truncate+0x52/0x75
[  141.715084]        [<c1071f5e>] may_open+0x1ec/0x231
[  141.715091]        [<c107211c>] open_namei+0xda/0x59b
[  141.715098]        [<c106863a>] do_filp_open+0x2c/0x53
[  141.715106]        [<c106896f>] do_sys_open+0x52/0xd8
[  141.715113]        [<c1068a11>] sys_open+0x1c/0x1e
[  141.715120]        [<c1002f78>] syscall_call+0x7/0xb
[  141.715129]        [<ffffffff>] 0xffffffff
[  141.715137] 
[  141.715138] -> #1 (&sysfs_inode_imutex_key){--..}:
[  141.715143]        [<c10354b8>] check_prev_add+0x154/0x206
[  141.715151]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.715159]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.715166]        [<c1037624>] lock_acquire+0x62/0x81
[  141.715173]        [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  141.715181]        [<c1205b88>] mutex_lock+0x8/0xa
[  141.715188]        [<c10a5447>] sysfs_hash_and_remove+0x43/0x11c
[  141.715196]        [<c10a5ef7>] sysfs_remove_file+0xd/0x12
[  141.715206]        [<c114b00c>] device_remove_file+0x32/0x44
[  141.715213]        [<c114b6d9>] device_del+0x174/0x1d2
[  141.715220]        [<c114b742>] device_unregister+0xb/0x15
[  141.715228]        [<c114b93d>] device_destroy+0x8d/0x9a
[  141.715234]        [<c1137a38>] vcs_remove_sysfs+0x1c/0x38
[  141.715244]        [<c113e0d8>] con_close+0x5e/0x6b
[  141.715251]        [<c1130103>] release_dev+0x4c4/0x6ce
[  141.715260]        [<c113077b>] tty_release+0x12/0x1c
[  141.715268]        [<c106a471>] __fput+0x145/0x16e
[  141.715276]        [<c106a32a>] fput+0x19/0x1b
[  141.715285]        [<c1068a92>] filp_close+0x3c/0x75
[  141.715292]        [<c1068b34>] sys_close+0x69/0xb4
[  141.715299]        [<c1002f78>] syscall_call+0x7/0xb
[  141.715307]        [<ffffffff>] 0xffffffff
[  141.715316] 
[  141.715317] -> #0 (tty_mutex){--..}:
[  141.715321]        [<c1035398>] check_prev_add+0x34/0x206
[  141.715332]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.715340]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.715347]        [<c1037624>] lock_acquire+0x62/0x81
[  141.715354]        [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  141.715362]        [<c1205b88>] mutex_lock+0x8/0xa
[  141.715371]        [<c1098d79>] print_warning+0x8c/0x15d
[  141.715378]        [<c1099537>] dquot_alloc_space+0x184/0x189
[  141.715387]        [<c10a98e6>] ext3_new_blocks+0x44b/0x5a2
[  141.715394]        [<c10abe78>] ext3_alloc_blocks+0x40/0xdf
[  141.715402]        [<c10abf67>] ext3_alloc_branch+0x50/0x21b
[  141.715412]        [<c10ac445>] ext3_get_blocks_handle+0x1b8/0x367
[  141.715420]        [<c10ac66c>] ext3_get_block+0x78/0xe3
[  141.715428]        [<c108a239>] __block_prepare_write+0x168/0x3fd
[  141.715437]        [<c108ad10>] block_prepare_write+0x28/0x3b
[  141.715445]        [<c10acbcd>] ext3_prepare_write+0x3f/0x18d
[  141.715455]        [<c104dbe5>] generic_file_buffered_write+0x197/0x5e6
[  141.715463]        [<c104e2e2>] __generic_file_aio_write_nolock+0x2ae/0x5ad
[  141.715472]        [<c104e6ea>] generic_file_aio_write+0x58/0xc4
[  141.715479]        [<c10aa723>] ext3_file_write+0x2d/0xba
[  141.715487]        [<c1069441>] do_sync_write+0xc7/0x116
[  141.715497]        [<c1069612>] vfs_write+0x182/0x187
[  141.715504]        [<c10696b8>] sys_write+0x3d/0x64
[  141.715512]        [<c1002f78>] syscall_call+0x7/0xb
[  141.715519]        [<ffffffff>] 0xffffffff
[  141.715527] 
[  141.715529] other info that might help us debug this:
[  141.715531] 
[  141.715533] 3 locks held by tor/5534:
[  141.715535]  #0:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  141.715542]  #1:  (&ei->truncate_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  141.715548]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c1099403>] dquot_alloc_space+0x50/0x189
[  141.715555] 
[  141.715556] stack backtrace:
[  141.715558]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
[  141.715563]  [<c1003d7f>] show_trace+0x12/0x14
[  141.715567]  [<c1003e79>] dump_stack+0x16/0x18
[  141.715573]  [<c1034d6d>] print_circular_bug_tail+0x6f/0x71
[  141.715578]  [<c1035398>] check_prev_add+0x34/0x206
[  141.715582]  [<c10355d4>] check_prevs_add+0x6a/0xd5
[  141.715586]  [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  141.715591]  [<c1037624>] lock_acquire+0x62/0x81
[  141.715595]  [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  141.715599]  [<c1205b88>] mutex_lock+0x8/0xa
[  141.715602]  [<c1098d79>] print_warning+0x8c/0x15d
[  141.715606]  [<c1099537>] dquot_alloc_space+0x184/0x189
[  141.715612]  [<c10a98e6>] ext3_new_blocks+0x44b/0x5a2
[  141.715616]  [<c10abe78>] ext3_alloc_blocks+0x40/0xdf
[  141.715620]  [<c10abf67>] ext3_alloc_branch+0x50/0x21b
[  141.715624]  [<c10ac445>] ext3_get_blocks_handle+0x1b8/0x367
[  141.715629]  [<c10ac66c>] ext3_get_block+0x78/0xe3
[  141.715633]  [<c108a239>] __block_prepare_write+0x168/0x3fd
[  141.715638]  [<c108ad10>] block_prepare_write+0x28/0x3b
[  141.715641]  [<c10acbcd>] ext3_prepare_write+0x3f/0x18d
[  141.715647]  [<c104dbe5>] generic_file_buffered_write+0x197/0x5e6
[  141.715654]  [<c104e2e2>] __generic_file_aio_write_nolock+0x2ae/0x5ad
[  141.715658]  [<c104e6ea>] generic_file_aio_write+0x58/0xc4
[  141.715662]  [<c10aa723>] ext3_file_write+0x2d/0xba
[  141.715666]  [<c1069441>] do_sync_write+0xc7/0x116
[  141.715671]  [<c1069612>] vfs_write+0x182/0x187
[  141.715675]  [<c10696b8>] sys_write+0x3d/0x64
[  141.715679]  [<c1002f78>] syscall_call+0x7/0xb
[  141.715682]  =======================

System is a P4 with HT, 3.2GHz, 2GB ram. Filesystem is ext3.


Folkert van Heusden

www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

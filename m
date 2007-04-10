Return-Path: <linux-kernel-owner+w=401wt.eu-S966104AbXDJIXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966104AbXDJIXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966110AbXDJIXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:23:37 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:33967 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966104AbXDJIXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:23:36 -0400
Date: Tue, 10 Apr 2007 10:19:22 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [XFS] INFO: possible circular locking dependency detected
Message-ID: <20070410101922.728625bb@localhost>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_9gJim6iyL6AncNMmr._mu0k
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_9gJim6iyL6AncNMmr._mu0k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I've not seen this reported...

[ 9564.772749] 
[ 9564.772752] =======================================================
[ 9564.772757] [ INFO: possible circular locking dependency detected ]
[ 9564.772760] 2.6.21-rc6-gc2481cc4 #9
[ 9564.772762] -------------------------------------------------------
[ 9564.772765] xfssyncd/6157 is trying to acquire lock:
[ 9564.772767]  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.772775] 
[ 9564.772776] but task is already holding lock:
[ 9564.772778]  (&mp->m_ilock){--..}, at: [<ffffffff803348f6>] xfs_finish_reclaim_all+0x1d/0xc1
[ 9564.772785] 
[ 9564.772786] which lock already depends on the new lock.
[ 9564.772787] 
[ 9564.772789] 
[ 9564.772790] the existing dependency chain (in reverse order) is:
[ 9564.772792] 
[ 9564.772793] -> #1 (&mp->m_ilock){--..}:
[ 9564.772796]        [<ffffffff802478f1>] __lock_acquire+0xa3d/0xbe4
[ 9564.772804]        [<ffffffff8031b217>] xfs_iget_core+0x60e/0x6c4
[ 9564.772811]        [<ffffffff80247b13>] lock_acquire+0x7b/0x9f
[ 9564.772817]        [<ffffffff8031b217>] xfs_iget_core+0x60e/0x6c4
[ 9564.772824]        [<ffffffff804f6f19>] __mutex_lock_slowpath+0xe1/0x263
[ 9564.772832]        [<ffffffff8031b217>] xfs_iget_core+0x60e/0x6c4
[ 9564.772839]        [<ffffffff8031b371>] xfs_iget+0xa4/0x14b
[ 9564.772845]        [<ffffffff8032c9b8>] xfs_mountfs+0x708/0x954
[ 9564.772852]        [<ffffffff8033b37f>] xfs_setsize_buftarg_flags+0x30/0x9e
[ 9564.772859]        [<ffffffff80332a67>] xfs_mount+0x317/0x39d
[ 9564.772866]        [<ffffffff803427ff>] xfs_fs_fill_super+0x0/0x1a1
[ 9564.772873]        [<ffffffff8034287d>] xfs_fs_fill_super+0x7e/0x1a1
[ 9564.772880]        [<ffffffff804f8586>] _spin_unlock+0x17/0x20
[ 9564.772887]        [<ffffffff80277b65>] sget+0x377/0x389
[ 9564.772894]        [<ffffffff802774e0>] set_bdev_super+0x0/0xf
[ 9564.772900]        [<ffffffff802774ef>] test_bdev_super+0x0/0xd
[ 9564.772907]        [<ffffffff802784b2>] get_sb_bdev+0x121/0x17b
[ 9564.772913]        [<ffffffff80277ff5>] vfs_kern_mount+0x4f/0x8a
[ 9564.772920]        [<ffffffff80278072>] do_kern_mount+0x36/0x4d
[ 9564.772926]        [<ffffffff8028b3d6>] do_mount+0x625/0x699
[ 9564.772934]        [<ffffffff80289e83>] mntput_no_expire+0x1c/0x85
[ 9564.772941]        [<ffffffff8027ef8e>] link_path_walk+0xce/0xe0
[ 9564.772948]        [<ffffffff80236f20>] sigprocmask+0x28/0xc1
[ 9564.772956]        [<ffffffff80272a18>] kmem_cache_free+0xcf/0xd9
[ 9564.772963]        [<ffffffff80246a13>] trace_hardirqs_on+0x124/0x14f
[ 9564.772970]        [<ffffffff8025c17d>] get_page_from_freelist+0x1ef/0x35d
[ 9564.772977]        [<ffffffff80246a13>] trace_hardirqs_on+0x124/0x14f
[ 9564.772984]        [<ffffffff8025c358>] __alloc_pages+0x6d/0x2b4
[ 9564.772990]        [<ffffffff8028b4d4>] sys_mount+0x8a/0xd7
[ 9564.772997]        [<ffffffff8020962e>] system_call+0x7e/0x83
[ 9564.773004]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 9564.773014] 
[ 9564.773015] -> #0 (&(&ip->i_lock)->mr_lock){----}:
[ 9564.773018]        [<ffffffff8024611f>] print_circular_bug_header+0xcc/0xd3
[ 9564.773025]        [<ffffffff802477ed>] __lock_acquire+0x939/0xbe4
[ 9564.773032]        [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773039]        [<ffffffff80247b13>] lock_acquire+0x7b/0x9f
[ 9564.773045]        [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773052]        [<ffffffff80242d08>] down_write_trylock+0x2f/0x35
[ 9564.773059]        [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773066]        [<ffffffff80334919>] xfs_finish_reclaim_all+0x40/0xc1
[ 9564.773073]        [<ffffffff80332567>] xfs_syncsub+0x4e/0x237
[ 9564.773080]        [<ffffffff8023ff12>] keventd_create_kthread+0x0/0x6d
[ 9564.773087]        [<ffffffff80341e68>] vfs_sync_worker+0x19/0x38
[ 9564.773094]        [<ffffffff80342157>] xfssyncd+0x10c/0x15d
[ 9564.773101]        [<ffffffff8034204b>] xfssyncd+0x0/0x15d
[ 9564.773107]        [<ffffffff80240182>] kthread+0xd1/0x103
[ 9564.773114]        [<ffffffff8020a4b8>] child_rip+0xa/0x12
[ 9564.773121]        [<ffffffff804f884c>] _spin_unlock_irq+0x24/0x27
[ 9564.773127]        [<ffffffff80209bcc>] restore_args+0x0/0x30
[ 9564.773134]        [<ffffffff802400b1>] kthread+0x0/0x103
[ 9564.773140]        [<ffffffff8020a4ae>] child_rip+0x0/0x12
[ 9564.773147]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 9564.773153] 
[ 9564.773154] other info that might help us debug this:
[ 9564.773155] 
[ 9564.773158] 1 lock held by xfssyncd/6157:
[ 9564.773159]  #0:  (&mp->m_ilock){--..}, at: [<ffffffff803348f6>] xfs_finish_reclaim_all+0x1d/0xc1
[ 9564.773166] 
[ 9564.773167] stack backtrace:
[ 9564.773169] 
[ 9564.773169] Call Trace:
[ 9564.773173]  [<ffffffff80245d6a>] print_circular_bug_tail+0x69/0x72
[ 9564.773177]  [<ffffffff8024611f>] print_circular_bug_header+0xcc/0xd3
[ 9564.773180]  [<ffffffff802477ed>] __lock_acquire+0x939/0xbe4
[ 9564.773183]  [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773187]  [<ffffffff80247b13>] lock_acquire+0x7b/0x9f
[ 9564.773190]  [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773194]  [<ffffffff80242d08>] down_write_trylock+0x2f/0x35
[ 9564.773197]  [<ffffffff8031abae>] xfs_ilock_nowait+0x6d/0xc8
[ 9564.773200]  [<ffffffff80334919>] xfs_finish_reclaim_all+0x40/0xc1
[ 9564.773204]  [<ffffffff80332567>] xfs_syncsub+0x4e/0x237
[ 9564.773207]  [<ffffffff8023ff12>] keventd_create_kthread+0x0/0x6d
[ 9564.773211]  [<ffffffff80341e68>] vfs_sync_worker+0x19/0x38
[ 9564.773214]  [<ffffffff80342157>] xfssyncd+0x10c/0x15d
[ 9564.773217]  [<ffffffff8034204b>] xfssyncd+0x0/0x15d
[ 9564.773220]  [<ffffffff80240182>] kthread+0xd1/0x103
[ 9564.773224]  [<ffffffff8020a4b8>] child_rip+0xa/0x12
[ 9564.773227]  [<ffffffff804f884c>] _spin_unlock_irq+0x24/0x27
[ 9564.773230]  [<ffffffff80209bcc>] restore_args+0x0/0x30
[ 9564.773233]  [<ffffffff802400b1>] kthread+0x0/0x103
[ 9564.773236]  [<ffffffff8020a4ae>] child_rip+0x0/0x12
[ 9564.773238] 


-- 
	Paolo Ornati
	Linux 2.6.21-rc6-gc2481cc4 on x86_64

--MP_9gJim6iyL6AncNMmr._mu0k
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config.gz

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
koqPAAA=

--MP_9gJim6iyL6AncNMmr._mu0k--

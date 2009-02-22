Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZBVFPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZBVFPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 00:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZBVFPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 00:15:03 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59845 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZBVFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 00:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=liuyOyS6yUstRONZJYF9hHzvUAh1rKfO6JIadLo96VDsxCVxfaqcZyQESon8FM5cOW
         94cpEd916WTburwu0TWvRD+2zfxsRX3+SemmMZAe9HBnyckkT6g+8O43yCPf1Qg33VLA
         eCg3Ee5PH4mO6aotNazgnz0CUvj8KNV4sVcR4=
MIME-Version: 1.0
Date: Sun, 22 Feb 2009 06:14:57 +0100
Message-ID: <12bfabe40902212114h271b3728tac48b8283d33c20b@mail.gmail.com>
Subject: [BUG] 2.6.28.7 - ext4 : possible circular locking dependency detected
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Through dmesg I got this error message :

[10484.092586]
[10484.092587] =======================================================
[10484.092593] [ INFO: possible circular locking dependency detected ]
[10484.092597] 2.6.28.7-my001 #1
[10484.092600] -------------------------------------------------------
[10484.092604] kjournald2/3695 is trying to acquire lock:
[10484.092608]  (&meta_group_info[i]->alloc_sem){----}, at:
[<ffffffffa039b6d9>] ext4_mb_load_buddy+0xd9/0x34a [ext4]
[10484.092633]
[10484.092634] but task is already holding lock:
[10484.092638]  (&journal->j_list_lock#2){--..}, at:
[<ffffffffa0370033>] jbd2_journal_commit_transaction+0xf06/0x117b
[jbd2]
[10484.092656]
[10484.092657] which lock already depends on the new lock.
[10484.092659]
[10484.092662]
[10484.092663] the existing dependency chain (in reverse order) is:
[10484.092667]
[10484.092668] -> #1 (&journal->j_list_lock#2){--..}:
[10484.092677]        [<ffffffff8026e399>] __lock_acquire+0x134c/0x16ab
[10484.092685]        [<ffffffff8026e785>] lock_acquire+0x8d/0xba
[10484.092691]        [<ffffffff804e8b86>] _spin_lock+0x36/0x67
[10484.092697]        [<ffffffffa036e440>]
do_get_write_access+0x34e/0x489 [jbd2]
[10484.092710]        [<ffffffffa036e5a2>]
jbd2_journal_get_write_access+0x27/0x38 [jbd2]
[10484.092722]        [<ffffffffa0398cb3>]
__ext4_journal_get_write_access+0x24/0x4d [ext4]
[10484.092741]        [<ffffffffa039c0b3>]
ext4_mb_mark_diskspace_used+0x77/0x3a6 [ext4]
[10484.092759]        [<ffffffffa03a06ec>] ext4_mb_new_blocks+0x1d7/0x35f [ext4]
[10484.092777]        [<ffffffffa0398958>]
ext4_ext_get_blocks+0xc18/0xe18 [ext4]
[10484.092794]        [<ffffffffa03887ab>]
ext4_get_blocks_wrap+0xfc/0x224 [ext4]
[10484.092811]        [<ffffffffa0388b3c>]
ext4_da_get_block_write+0x6c/0x151 [ext4]
[10484.092828]        [<ffffffffa0387063>] mpage_da_map_blocks+0x84/0x4ea [ext4]
[10484.092844]        [<ffffffffa0387886>] ext4_da_writepages+0x248/0x380 [ext4]
[10484.092860]        [<ffffffff802a826e>] do_writepages+0x30/0x40
[10484.092868]        [<ffffffff802f26d9>] __writeback_single_inode+0x195/0x3a5
[10484.092876]        [<ffffffff802f2db0>] generic_sync_sb_inodes+0x296/0x43a
[10484.092882]        [<ffffffff802f315e>] writeback_inodes+0xa7/0xff
[10484.092889]        [<ffffffff802a83dd>] wb_kupdate+0xa8/0x11e
[10484.092894]        [<ffffffff802a8eb9>] pdflush+0x15b/0x20e
[10484.092900]        [<ffffffff8025d856>] kthread+0x4e/0x7b
[10484.092907]        [<ffffffff802129d9>] child_rip+0xa/0x11
[10484.092914]        [<ffffffffffffffff>] 0xffffffffffffffff
[10484.092933]
[10484.092934] -> #0 (&meta_group_info[i]->alloc_sem){----}:
[10484.092942]        [<ffffffff8026e0aa>] __lock_acquire+0x105d/0x16ab
[10484.092948]        [<ffffffff8026e785>] lock_acquire+0x8d/0xba
[10484.092953]        [<ffffffff804e7587>] down_read+0x50/0x80
[10484.092959]        [<ffffffffa039b6d9>] ext4_mb_load_buddy+0xd9/0x34a [ext4]
[10484.092977]        [<ffffffffa039ece2>]
release_blocks_on_commit+0x60/0x1db [ext4]
[10484.092995]        [<ffffffffa03701da>]
jbd2_journal_commit_transaction+0x10ad/0x117b [jbd2]
[10484.093008]        [<ffffffffa037384c>] kjournald2+0xee/0x23f [jbd2]
[10484.093020]        [<ffffffff8025d856>] kthread+0x4e/0x7b
[10484.093026]        [<ffffffff802129d9>] child_rip+0xa/0x11
[10484.093032]        [<ffffffffffffffff>] 0xffffffffffffffff
[10484.093038]
[10484.093039] other info that might help us debug this:
[10484.093041]
[10484.093044] 1 lock held by kjournald2/3695:
[10484.093048]  #0:  (&journal->j_list_lock#2){--..}, at:
[<ffffffffa0370033>] jbd2_journal_commit_transaction+0xf06/0x117b
[jbd2]
[10484.093066]
[10484.093067] stack backtrace:
[10484.093071] Pid: 3695, comm: kjournald2 Not tainted 2.6.28.7-my001 #1
[10484.093075] Call Trace:
[10484.093080]  [<ffffffff8026cc81>] print_circular_bug_tail+0xb8/0xc3
[10484.093087]  [<ffffffff8026e0aa>] __lock_acquire+0x105d/0x16ab
[10484.093095]  [<ffffffff8026c6e3>] ? trace_hardirqs_on+0xd/0xf
[10484.093101]  [<ffffffff8026e785>] lock_acquire+0x8d/0xba
[10484.093119]  [<ffffffffa039b6d9>] ? ext4_mb_load_buddy+0xd9/0x34a [ext4]
[10484.093125]  [<ffffffff804e7587>] down_read+0x50/0x80
[10484.093142]  [<ffffffffa039b6d9>] ? ext4_mb_load_buddy+0xd9/0x34a [ext4]
[10484.093159]  [<ffffffffa039b6d9>] ext4_mb_load_buddy+0xd9/0x34a [ext4]
[10484.093177]  [<ffffffffa039ece2>] release_blocks_on_commit+0x60/0x1db [ext4]
[10484.093190]  [<ffffffffa03701c6>] ?
jbd2_journal_commit_transaction+0x1099/0x117b [jbd2]
[10484.093197]  [<ffffffff803a04f9>] ? _raw_spin_unlock+0xaa/0xb0
[10484.093209]  [<ffffffffa03701da>]
jbd2_journal_commit_transaction+0x10ad/0x117b [jbd2]
[10484.093223]  [<ffffffffa037384c>] kjournald2+0xee/0x23f [jbd2]
[10484.093229]  [<ffffffff8025dc0b>] ? autoremove_wake_function+0x0/0x3d
[10484.093241]  [<ffffffffa037375e>] ? kjournald2+0x0/0x23f [jbd2]
[10484.093246]  [<ffffffff8025d856>] kthread+0x4e/0x7b
[10484.093252]  [<ffffffff802129d9>] child_rip+0xa/0x11
[10484.093258]  [<ffffffff8026c6e3>] ? trace_hardirqs_on+0xd/0xf
[10484.093264]  [<ffffffff804e8966>] ? _spin_unlock_irq+0x30/0x3c
[10484.093269]  [<ffffffff80211be3>] ? restore_args+0x0/0x30
[10484.093275]  [<ffffffff8025d7e3>] ? kthreadd+0x18a/0x1af
[10484.093280]  [<ffffffff8025d808>] ? kthread+0x0/0x7b
[10484.093285]  [<ffffffff802129cf>] ? child_rip+0x0/0x11

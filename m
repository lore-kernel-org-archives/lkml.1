Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZDHAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZDHAnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZDHAnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:43:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45371 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbZDHAm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B4Lw3O+UCZu6SLKt8VhYcy8mWjXwJP/9zzuU74VVImfsfunuDAY2aOJbvBvH9jEN+7
         bgwlWZkqf0n05XT0jaEbyPdkF/K5kvngSzeZvwbuwxVkoumDJskxeRHy1U+WxrIwZUoa
         L4h8O6EeGUMyLgvLNf/Xo45230toxU2y5KGC0=
Date: Wed, 8 Apr 2009 02:42:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090408004251.GA5977@nowhere>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com> <a4423d670904071434w6a687568hc6f2a380a8b32661@mail.gmail.com> <20090407215721.GA6252@nowhere> <20090407221950.GA29238@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407221950.GA29238@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:19:50AM +0400, Alexander Beregalov wrote:
> On Tue, Apr 07, 2009 at 11:57:22PM +0200, Frederic Weisbecker wrote:
> > On Wed, Apr 08, 2009 at 01:34:07AM +0400, Alexander Beregalov wrote:
> > > Hi Frederic
> > > 
> > > I've applied your patch.
> > > This is UP system.
> > > This warning seems related to your patch.
> > > 
> > > 
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.29-10247-g8e2c4f2-dirty #2
> > > -------------------------------------------------------
> > > udevadm/1239 is trying to acquire lock:
> > >  (&mm->mmap_sem){++++++}, at: [<c0173f52>] might_fault+0x52/0xa0
> > > 
> > > but task is already holding lock:
> > >  (sysfs_mutex){+.+.+.}, at: [<c01ccd36>] sysfs_readdir+0x56/0x200
> > 
> > 
> > Ah, I've never hit it. I'm not sure this is related to my patch
> > but it could be.
> > Could you send me your config?
> [Sent in private mail]
> 
> This should be related.
> System is hung after dbench testing for some time.
> 



Ok, I can reproduce these hangs with dbench.
I will investigate on that and try to fix it soon.

Thanks a lot for this report,
Frederic.


 
> SysRq : Emergency Sync
> SysRq : Show Blocked State
>   task                PC stack   pid father
> events/0      D 00000000  5672     6      2
>  f7067ee8 00000046 00000046 00000000 00000000 f7056720 f70569ac b6acece3
>  00000b44 00000000 f70569ac c018c1df 00000202 00000202 f6982a60 f7056720
>  f7067f30 c0448e3a 00000000 00000002 00000000 c018c1df 00000000 0018c3b2
> Call Trace:
>  [<c018c1df>] ? lock_super+0x1f/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c018c1df>] ? lock_super+0x1f/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c018c1df>] ? lock_super+0x1f/0x30
>  [<c018c1df>] lock_super+0x1f/0x30
>  [<c018c3b9>] sync_supers+0x69/0xc0
>  [<c01a922c>] do_sync+0x1c/0x60
>  [<c013a0e6>] ? worker_thread+0xe6/0x250
>  [<c01a927d>] do_sync_work+0xd/0x20
>  [<c013a148>] worker_thread+0x148/0x250
>  [<c013a0e6>] ? worker_thread+0xe6/0x250
>  [<c01a9270>] ? do_sync_work+0x0/0x20
>  [<c013dab0>] ? autoremove_wake_function+0x0/0x40
>  [<c013a000>] ? worker_thread+0x0/0x250
>  [<c013d86a>] kthread+0x3a/0x70
>  [<c013d830>] ? kthread+0x0/0x70
>  [<c0103677>] kernel_thread_helper+0x7/0x10
> metalog       D 00000000  4936  2183      1
>  f7161cec 00000046 00000046 00000000 00000000 f6b8d280 f6b8d50c 1eba9be4
>  00000b44 00000000 f6b8d50c c020375e 00000202 00000202 f670a014 f6b8d280
>  f7161d34 c0448e3a 00000000 00000002 00000000 c020375e 00000000 0018440c
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01e9674>] reiserfs_dirty_inode+0x24/0xb0
>  [<c01a0f7a>] ? mnt_want_write+0x1a/0xc0
>  [<c01a613c>] __mark_inode_dirty+0x2c/0x180
>  [<c019c6f5>] file_update_time+0xc5/0xe0
>  [<c01634eb>] __generic_file_aio_write_nolock+0x18b/0x520
>  [<c0163980>] ? generic_file_aio_write+0x50/0xd0
>  [<c0163993>] generic_file_aio_write+0x63/0xd0
>  [<c018a331>] do_sync_write+0xd1/0x110
>  [<c013dab0>] ? autoremove_wake_function+0x0/0x40
>  [<c01e23ba>] reiserfs_file_write+0x8a/0xa0
>  [<c018a94c>] vfs_write+0x9c/0x140
>  [<c01e2330>] ? reiserfs_file_write+0x0/0xa0
>  [<c018aaad>] sys_write+0x3d/0x70
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> svscan        D 00000000  5384  2223      1
>  f731dd8c 00000046 00000046 00000000 00000000 f6740000 f674028c eaa8d98d
>  00000af9 00000000 f674028c c020375e 00000202 00000202 f670a014 f6740000
>  f731ddd4 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00740000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01e266a>] reiserfs_readdir_dentry+0x5a/0x740
>  [<c018b46f>] ? file_move+0x1f/0x50
>  [<c0197b70>] ? filldir+0x0/0xd0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c044ae07>] ? _spin_unlock+0x27/0x50
>  [<c018b48e>] ? file_move+0x3e/0x50
>  [<c0173f9d>] ? might_fault+0x9d/0xa0
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c0449013>] ? __mutex_lock_common+0x2f3/0x430
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c01e2d67>] reiserfs_readdir+0x17/0x20
>  [<c0197d9e>] vfs_readdir+0x7e/0xa0
>  [<c0197b70>] ? filldir+0x0/0xd0
>  [<c0197ed8>] sys_getdents+0x68/0xb0
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> multilog      D 00000000  4800  2236   2228
>  f731bcec 00000046 00000046 00000000 00000000 f6ba8000 f6ba828c 50105c29
>  00000b26 00000000 f6ba828c c020375e 00000202 00000202 f670a014 f6ba8000
>  f731bd34 c0448e3a 00000000 00000002 00000000 c020375e 00000000 0014ce9d
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01e9674>] reiserfs_dirty_inode+0x24/0xb0
>  [<c01a0f7a>] ? mnt_want_write+0x1a/0xc0
>  [<c01a613c>] __mark_inode_dirty+0x2c/0x180
>  [<c019c6f5>] file_update_time+0xc5/0xe0
>  [<c01634eb>] __generic_file_aio_write_nolock+0x18b/0x520
>  [<c0163980>] ? generic_file_aio_write+0x50/0xd0
>  [<c0163993>] generic_file_aio_write+0x63/0xd0
>  [<c018a331>] do_sync_write+0xd1/0x110
>  [<c013dab0>] ? autoremove_wake_function+0x0/0x40
>  [<c01b42ba>] ? dnotify_parent+0x2a/0x80
>  [<c01e23ba>] reiserfs_file_write+0x8a/0xa0
>  [<c018a94c>] vfs_write+0x9c/0x140
>  [<c0173f52>] ? might_fault+0x52/0xa0
>  [<c01e2330>] ? reiserfs_file_write+0x0/0xa0
>  [<c018aaad>] sys_write+0x3d/0x70
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> agetty        D 00000000  5432  2441      1
>  f73cbba8 00000046 00000046 00000000 00000000 f73dd280 f73dd50c 6a069cd5
>  00000b33 00000000 f73dd50c c020375e 00000202 00000202 f670a014 f73dd280
>  f73cbbf0 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00000246
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01df2e6>] reiserfs_get_block+0x66/0x14f0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014e52b>] ? trace_hardirqs_on+0xb/0x10
>  [<c044b07d>] ? _spin_unlock_irq+0x2d/0x50
>  [<c0124b02>] ? finish_task_switch+0x62/0xb0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c0124aa0>] ? finish_task_switch+0x0/0xb0
>  [<c044b2df>] ? __reacquire_kernel_lock+0x2f/0x40
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c0332d78>] ? serial8250_tx_empty+0x18/0x50
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c016108e>] ? add_to_page_cache_locked+0x5e/0xe0
>  [<c01b32f0>] do_mpage_readpage+0x340/0x490
>  [<c01610e9>] ? add_to_page_cache_locked+0xb9/0xe0
>  [<c016a415>] ? __lru_cache_add+0x65/0xa0
>  [<c0161184>] ? add_to_page_cache_lru+0x74/0x80
>  [<c01b352e>] mpage_readpages+0x9e/0xe0
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c04480b8>] ? __schedule+0x2f8/0x4f0
>  [<c01dc710>] ? reiserfs_readpages+0x0/0x20
>  [<c01dc729>] reiserfs_readpages+0x19/0x20
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c01696ff>] __do_page_cache_readahead+0x13f/0x200
>  [<c016980e>] do_page_cache_readahead+0x4e/0x70
>  [<c0162caf>] filemap_fault+0x30f/0x430
>  [<c0175f6d>] __do_fault+0x3d/0x360
>  [<c01b42ba>] ? dnotify_parent+0x2a/0x80
>  [<c0176aa0>] handle_mm_fault+0x100/0x590
>  [<c014159d>] ? down_read_trylock+0x5d/0x70
>  [<c011aff1>] do_page_fault+0x121/0x280
>  [<c011aed0>] ? do_page_fault+0x0/0x280
>  [<c044b40a>] error_code+0x6a/0x70
>  [<c011aed0>] ? do_page_fault+0x0/0x280
> screen        D 00000000  5244  2529   2528
>  f612fd90 00000046 00000046 00000000 00000000 f6babde0 f6bac06c 33c73fab
>  00000b1c 00000000 f6bac06c c0193bf3 00000202 00000202 f6f9615c f6babde0
>  f612fdd8 c0448e3a 00000000 00000002 00000000 c0193bf3 00000000 0012fed0
> Call Trace:
>  [<c0193bf3>] ? do_lookup+0xd3/0x1c0
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c0193bf3>] ? do_lookup+0xd3/0x1c0
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c0193bf3>] ? do_lookup+0xd3/0x1c0
>  [<c0193bf3>] do_lookup+0xd3/0x1c0
>  [<c0193e49>] __link_path_walk+0x169/0xcc0
>  [<c0194b53>] path_walk+0x53/0xb0
>  [<c0194c8b>] do_path_lookup+0x8b/0x170
>  [<c01958ea>] user_path_at+0x4a/0x80
>  [<c01b42ba>] ? dnotify_parent+0x2a/0x80
>  [<c018e471>] vfs_stat_fd+0x21/0x50
>  [<c018e571>] vfs_stat+0x11/0x20
>  [<c018e594>] sys_stat64+0x14/0x30
>  [<c018abdf>] ? vfs_read+0xff/0x140
>  [<c0317d70>] ? tty_read+0x0/0xb0
>  [<c018acdd>] ? sys_read+0x3d/0x70
>  [<c02c9d84>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> rtorrent      D 00000000  4084  2543   2542
>  f6325d88 00000046 00000046 00000000 00000000 f6b894a0 f6b8972c d79a38dd
>  00000af9 00000000 f6b8972c c020375e 00000202 00000202 f670a014 f6b894a0
>  f6325dd0 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00000000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01e266a>] reiserfs_readdir_dentry+0x5a/0x740
>  [<c018b46f>] ? file_move+0x1f/0x50
>  [<c0197a80>] ? filldir64+0x0/0xf0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c044ae07>] ? _spin_unlock+0x27/0x50
>  [<c018b48e>] ? file_move+0x3e/0x50
>  [<c0173f9d>] ? might_fault+0x9d/0xa0
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c0449013>] ? __mutex_lock_common+0x2f3/0x430
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c01e2d67>] reiserfs_readdir+0x17/0x20
>  [<c0197d9e>] vfs_readdir+0x7e/0xa0
>  [<c0197a80>] ? filldir64+0x0/0xf0
>  [<c0197e29>] sys_getdents64+0x69/0xb0
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> bash          D 00000000  5788  2546   2529
>  f585dcd8 00000046 00000046 00000000 00000000 f6b8bde0 f6b8c06c 188b381a
>  00000b1b 00000000 f6b8c06c c020375e 00000202 00000202 f670a014 f6b8bde0
>  f585dd20 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00000000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01db389>] reiserfs_lookup+0x59/0x170
>  [<c019b923>] ? d_alloc+0x123/0x1b0
>  [<c0193cb1>] do_lookup+0x191/0x1c0
>  [<c0194305>] __link_path_walk+0x625/0xcc0
>  [<c0194b53>] path_walk+0x53/0xb0
>  [<c0194c8b>] do_path_lookup+0x8b/0x170
>  [<c01958ea>] user_path_at+0x4a/0x80
>  [<c018dda4>] ? cp_new_stat64+0xe4/0x100
>  [<c018e471>] vfs_stat_fd+0x21/0x50
>  [<c018e571>] vfs_stat+0x11/0x20
>  [<c018e594>] sys_stat64+0x14/0x30
>  [<c02c9d84>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4816 20778      1
>  f44bbd1c 00000046 00000046 00000000 00000000 ce105280 ce10550c d12c8ac7
>  00000af8 00000000 ce10550c c020375e 00000202 00000202 f670a014 ce105280
>  f44bbd64 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766a00
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c018570d>] ? check_object+0x13d/0x200
>  [<c01fba72>] flush_commit_list+0x2d2/0x7c0
>  [<c0121ab0>] ? __wake_up+0x40/0x50
>  [<c01fde19>] do_journal_end+0xdc9/0xf50
>  [<c0133420>] ? process_timeout+0x0/0x10
>  [<c01fdffd>] journal_end_sync+0x5d/0x80
>  [<c01feadd>] reiserfs_commit_for_inode+0x1bd/0x1e0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4660 20779      1
>  f44b3de4 00000046 00000046 00000000 00000000 ce106720 ce1069ac d12c836c
>  00000af8 00000000 ce1069ac c020375e 00000202 00000202 f670a014 ce106720
>  f44b3e2c c0448e3a 00000000 00000002 00000000 c020375e 00000000 00767400
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c04480b8>] ? __schedule+0x2f8/0x4f0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01fba72>] flush_commit_list+0x2d2/0x7c0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0133420>] ? process_timeout+0x0/0x10
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c01fe9c1>] reiserfs_commit_for_inode+0xa1/0x1e0
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4724 20780      1
>  f6389de4 00000046 00000046 00000000 00000000 ce102940 ce102bcc d12c7533
>  00000af8 00000000 ce102bcc c020375e 00000202 00000202 f670a014 ce102940
>  f6389e2c c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766280
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c0169c29>] ? pagevec_lookup_tag+0x29/0x40
>  [<c0168241>] ? write_cache_pages+0xd1/0x350
>  [<c01fba72>] flush_commit_list+0x2d2/0x7c0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449013>] ? __mutex_lock_common+0x2f3/0x430
>  [<c01fe9c1>] reiserfs_commit_for_inode+0xa1/0x1e0
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4944 20781      1
>  f589dc84 00000046 00000046 00000000 00000000 ce1014a0 ce10172c d0f2ddbd
>  00000af8 00000000 ce10172c c020375e 00000202 00000202 f670a014 ce1014a0
>  f589dccc c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766280
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fe08b>] do_journal_begin_r+0x6b/0x320
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01fe400>] journal_begin+0x80/0x110
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e9686>] reiserfs_dirty_inode+0x36/0xb0
>  [<c01a0f7a>] ? mnt_want_write+0x1a/0xc0
>  [<c01a613c>] __mark_inode_dirty+0x2c/0x180
>  [<c019c6f5>] file_update_time+0xc5/0xe0
>  [<c01634eb>] __generic_file_aio_write_nolock+0x18b/0x520
>  [<c0163980>] ? generic_file_aio_write+0x50/0xd0
>  [<c0163993>] generic_file_aio_write+0x63/0xd0
>  [<c014e52b>] ? trace_hardirqs_on+0xb/0x10
>  [<c018a331>] do_sync_write+0xd1/0x110
>  [<c013dab0>] ? autoremove_wake_function+0x0/0x40
>  [<c01e23ba>] reiserfs_file_write+0x8a/0xa0
>  [<c018a94c>] vfs_write+0x9c/0x140
>  [<c02ca436>] ? copy_to_user+0x36/0x130
>  [<c01e2330>] ? reiserfs_file_write+0x0/0xa0
>  [<c018aa6b>] sys_pwrite64+0x7b/0x80
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4832 20782      1
>  f4617a64 00000046 00000046 00000000 00000000 ce103de0 ce10406c d12ca393
>  00000af8 00000000 ce10406c c020375e 00000202 00000202 f670a014 ce103de0
>  f4617aac c0448e3a 00000000 00000002 00000000 c020375e 00000000 00767900
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fe08b>] do_journal_begin_r+0x6b/0x320
>  [<c01fe400>] journal_begin+0x80/0x110
>  [<c01fe4c2>] ? reiserfs_persistent_transaction+0x32/0x90
>  [<c01fe4d1>] reiserfs_persistent_transaction+0x41/0x90
>  [<c01df460>] reiserfs_get_block+0x1e0/0x14f0
>  [<c018dbbe>] ? inode_get_bytes+0x1e/0x50
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c018570d>] ? check_object+0x13d/0x200
>  [<c01ab2c3>] ? create_empty_buffers+0x33/0xa0
>  [<c01ad424>] __block_prepare_write+0x1a4/0x380
>  [<c0161184>] ? add_to_page_cache_lru+0x74/0x80
>  [<c01ad7a8>] block_write_begin+0x48/0xe0
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c01ddfbc>] reiserfs_write_begin+0xec/0x200
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c01618f5>] generic_file_buffered_write+0x155/0x2c0
>  [<c0163520>] __generic_file_aio_write_nolock+0x1c0/0x520
>  [<c0163993>] generic_file_aio_write+0x63/0xd0
>  [<c018a331>] do_sync_write+0xd1/0x110
>  [<c0173f52>] ? might_fault+0x52/0xa0
>  [<c013dab0>] ? autoremove_wake_function+0x0/0x40
>  [<c01e23ba>] reiserfs_file_write+0x8a/0xa0
>  [<c018a94c>] vfs_write+0x9c/0x140
>  [<c02ca436>] ? copy_to_user+0x36/0x130
>  [<c01e2330>] ? reiserfs_file_write+0x0/0xa0
>  [<c018aa6b>] sys_pwrite64+0x7b/0x80
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4764 20783      1
>  f5833e48 00000046 00000046 00000000 00000000 f73de720 f73de9ac d12c96e7
>  00000af8 00000000 f73de9ac c020375e 00000202 00000202 f670a014 f73de720
>  f5833e90 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766280
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449013>] ? __mutex_lock_common+0x2f3/0x430
>  [<c01fe9c1>] reiserfs_commit_for_inode+0xa1/0x1e0
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4600 20785      1
>  f460bd1c 00000046 00000046 00000000 00000000 f6b88000 f6b8828c d12c9d18
>  00000af8 00000000 f6b8828c c020375e 00000202 00000202 f670a014 f6b88000
>  f460bd64 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c01fba72>] flush_commit_list+0x2d2/0x7c0
>  [<c0121ab0>] ? __wake_up+0x40/0x50
>  [<c01fde19>] do_journal_end+0xdc9/0xf50
>  [<c0133420>] ? process_timeout+0x0/0x10
>  [<c01fdffd>] journal_end_sync+0x5d/0x80
>  [<c01feadd>] reiserfs_commit_for_inode+0x1bd/0x1e0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4548 20786      1
>  f5903d1c 00000046 00000046 00000000 00000000 f6960000 f696028c d12fcd2a
>  00000af8 00000000 f696028c c020375e 00000202 00000202 f670a014 f6960000
>  f5903d64 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766280
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c018570d>] ? check_object+0x13d/0x200
>  [<c01fba72>] flush_commit_list+0x2d2/0x7c0
>  [<c0121ab0>] ? __wake_up+0x40/0x50
>  [<c01fde19>] do_journal_end+0xdc9/0xf50
>  [<c0133420>] ? process_timeout+0x0/0x10
>  [<c01fdffd>] journal_end_sync+0x5d/0x80
>  [<c01feadd>] reiserfs_commit_for_inode+0x1bd/0x1e0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> dbench        D 00000000  4704 20787      1
>  f4557d60 00000046 00000046 00000000 00000000 f69614a0 f696172c d12c7cad
>  00000af8 00000000 f696172c c020375e 00000202 00000202 f670a014 f69614a0
>  f4557da8 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00767b80
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fb8c5>] flush_commit_list+0x125/0x7c0
>  [<c01862b1>] ? __slab_alloc+0xc1/0x5f0
>  [<c02c4f65>] ? __prop_inc_single+0x65/0x80
>  [<c01fbfc3>] get_list_bitmap+0x63/0xb0
>  [<c01fdd5f>] do_journal_end+0xd0f/0xf50
>  [<c0133420>] ? process_timeout+0x0/0x10
>  [<c01fdffd>] journal_end_sync+0x5d/0x80
>  [<c01feadd>] reiserfs_commit_for_inode+0x1bd/0x1e0
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e1e68>] reiserfs_sync_file+0x38/0x90
>  [<c01a905d>] vfs_fsync+0x6d/0xe0
>  [<c01a90fd>] do_fsync+0x2d/0x50
>  [<c01a914d>] sys_fsync+0xd/0x10
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> pdflush       D 00000000  6080 20790      2
>  f09bfe3c 00000046 00000046 00000000 00000000 f7088000 f708828c d12caa96
>  00000af8 00000000 f708828c c020375e 00000202 00000202 f670a014 f7088000
>  f09bfe84 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00766c80
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01fe08b>] do_journal_begin_r+0x6b/0x320
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01fe400>] journal_begin+0x80/0x110
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c01e95fe>] reiserfs_sync_fs+0x3e/0x80
>  [<c0449203>] ? mutex_lock_nested+0x33/0x40
>  [<c018c1df>] ? lock_super+0x1f/0x30
>  [<c01e964d>] reiserfs_write_super+0xd/0x10
>  [<c018c3d4>] sync_supers+0x84/0xc0
>  [<c0169330>] ? pdflush+0x0/0x1c0
>  [<c016860b>] wb_kupdate+0x2b/0x100
>  [<c014e52b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0169330>] ? pdflush+0x0/0x1c0
>  [<c01693f8>] pdflush+0xc8/0x1c0
>  [<c01685e0>] ? wb_kupdate+0x0/0x100
>  [<c013d86a>] kthread+0x3a/0x70
>  [<c013d830>] ? kthread+0x0/0x70
>  [<c0103677>] kernel_thread_helper+0x7/0x10
> git-daemon    D 00000000  6696 20791   2273
>  f3705ba8 00000046 00000046 00000000 00000000 f66fe720 f66fe9ac 4a31216d
>  00000afb 00000000 f66fe9ac c020375e 00000202 00000202 f670a014 f66fe720
>  f3705bf0 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00000000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01df2e6>] reiserfs_get_block+0x66/0x14f0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c018440c>] ? slab_pad_check+0x3c/0x120
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c01666ee>] ? get_page_from_freelist+0x41e/0x530
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c016108e>] ? add_to_page_cache_locked+0x5e/0xe0
>  [<c01b32f0>] do_mpage_readpage+0x340/0x490
>  [<c01610e9>] ? add_to_page_cache_locked+0xb9/0xe0
>  [<c016a415>] ? __lru_cache_add+0x65/0xa0
>  [<c0161184>] ? add_to_page_cache_lru+0x74/0x80
>  [<c01b352e>] mpage_readpages+0x9e/0xe0
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c01dc710>] ? reiserfs_readpages+0x0/0x20
>  [<c01dc729>] reiserfs_readpages+0x19/0x20
>  [<c01df280>] ? reiserfs_get_block+0x0/0x14f0
>  [<c01696ff>] __do_page_cache_readahead+0x13f/0x200
>  [<c016980e>] do_page_cache_readahead+0x4e/0x70
>  [<c0162caf>] filemap_fault+0x30f/0x430
>  [<c0175f6d>] __do_fault+0x3d/0x360
>  [<c0176aa0>] handle_mm_fault+0x100/0x590
>  [<c014159d>] ? down_read_trylock+0x5d/0x70
>  [<c011aff1>] do_page_fault+0x121/0x280
>  [<c011aed0>] ? do_page_fault+0x0/0x280
>  [<c044b40a>] error_code+0x6a/0x70
>  [<c011aed0>] ? do_page_fault+0x0/0x280
> git-daemon    D f63ede14  6888 20792   2273
>  f63ede20 00000046 00000000 f63ede14 00000046 f66fa940 f66fabcc 977b8ab0
>  00000afe 00000000 f66fabcc f63ede14 c014e52b c057e5a0 000003ae f63ede70
>  f63ede28 c04482c2 f63ede34 c04482f4 f63ede68 f63ede3c c0160d95 f63ede5c
> Call Trace:
>  [<c014e52b>] ? trace_hardirqs_on+0xb/0x10
>  [<c04482c2>] schedule+0x12/0x30
>  [<c04482f4>] io_schedule+0x14/0x20
>  [<c0160d95>] sync_page+0x55/0x60
>  [<c0448881>] __wait_on_bit_lock+0x41/0x80
>  [<c0160d40>] ? sync_page+0x0/0x60
>  [<c0160d18>] __lock_page+0x88/0xa0
>  [<c013daf0>] ? wake_bit_function+0x0/0x60
>  [<c0160eb9>] find_lock_page+0x39/0x70
>  [<c0162ad7>] filemap_fault+0x137/0x430
>  [<c0175f6d>] __do_fault+0x3d/0x360
>  [<c0176aa0>] handle_mm_fault+0x100/0x590
>  [<c014159d>] ? down_read_trylock+0x5d/0x70
>  [<c011aff1>] do_page_fault+0x121/0x280
>  [<c011aed0>] ? do_page_fault+0x0/0x280
>  [<c044b40a>] error_code+0x6a/0x70
>  [<c011aed0>] ? do_page_fault+0x0/0x280
> fcron         D 00000000  7168 20797   2257
>  f5a0fd80 00000046 00000046 00000000 00000000 f6952940 f6952bcc df71112a
>  00000b25 00000000 f6952bcc c020375e 00000202 00000202 f670a014 f6952940
>  f5a0fdc8 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00000000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01db389>] reiserfs_lookup+0x59/0x170
>  [<c019b923>] ? d_alloc+0x123/0x1b0
>  [<c019275f>] __lookup_hash+0xcf/0x130
>  [<c01927e7>] lookup_hash+0x27/0x30
>  [<c0195cb5>] do_filp_open+0x245/0x7a0
>  [<c019ed68>] ? alloc_fd+0x28/0xf0
>  [<c044ae07>] ? _spin_unlock+0x27/0x50
>  [<c019ee18>] ? alloc_fd+0xd8/0xf0
>  [<c0188879>] do_sys_open+0x59/0xf0
>  [<c0188979>] sys_open+0x29/0x40
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> Sched Debug Version: v0.09, 2.6.29-10247-g8e2c4f2-dirty #2
> now at 12468457.474391 msecs
>   .jiffies                                 : 1216523
>   .sysctl_sched_latency                    : 20.000000
>   .sysctl_sched_min_granularity            : 4.000000
>   .sysctl_sched_wakeup_granularity         : 5.000000
>   .sysctl_sched_child_runs_first           : 0.000001
>   .sysctl_sched_features                   : 113917
> 
> cpu#0, 1830.032 MHz
>   .nr_running                    : 1
>   .load                          : 1024
>   .nr_switches                   : 6163991
>   .nr_load_updates               : 582498
>   .nr_uninterruptible            : 21
>   .next_balance                  : 0.000000
>   .curr->pid                     : 20784
>   .clock                         : 12465239.317891
>   .cpu_load[0]                   : 1024
>   .cpu_load[1]                   : 1024
>   .cpu_load[2]                   : 1024
>   .cpu_load[3]                   : 1024
>   .cpu_load[4]                   : 1024
>   .yld_count                     : 0
>   .sched_switch                  : 0
>   .sched_count                   : 778698744
>   .sched_goidle                  : 307156
>   .ttwu_count                    : 0
>   .ttwu_local                    : 0
>   .bkl_count                     : 275
> 
> cfs_rq[0]:
>   .exec_clock                    : 1507714.391289
>   .MIN_vruntime                  : 0.000001
>   .min_vruntime                  : 1444293.051451
>   .max_vruntime                  : 0.000001
>   .spread                        : 0.000000
>   .spread0                       : 0.000000
>   .nr_running                    : 1
>   .load                          : 1024
>   .nr_spread_over                : 35
> 
> rt_rq[0]:
>   .rt_nr_running                 : 0
>   .rt_throttled                  : 0
>   .rt_time                       : 0.000000
>   .rt_runtime                    : 950.000000
> 
> runnable tasks:
>             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
> R         dbench 20784   1444293.051451      4569   120   1444293.051451    401016.637062     16471.092414
> 
> INFO: task svscan:2223 blocked for more than 480 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> svscan        D 00000000  5384  2223      1
>  f731dd8c 00000046 00000046 00000000 00000000 f6740000 f674028c eaa8d98d
>  00000af9 00000000 f674028c c020375e 00000202 00000202 f670a014 f6740000
>  f731ddd4 c0448e3a 00000000 00000002 00000000 c020375e 00000000 00740000
> Call Trace:
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0448e3a>] __mutex_lock_common+0x11a/0x430
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c0449203>] mutex_lock_nested+0x33/0x40
>  [<c020375e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c020375e>] reiserfs_write_lock+0x1e/0x30
>  [<c01e266a>] reiserfs_readdir_dentry+0x5a/0x740
>  [<c018b46f>] ? file_move+0x1f/0x50
>  [<c0197b70>] ? filldir+0x0/0xd0
>  [<c014ce9d>] ? print_lock_contention_bug+0x1d/0x110
>  [<c044ae07>] ? _spin_unlock+0x27/0x50
>  [<c018b48e>] ? file_move+0x3e/0x50
>  [<c0173f9d>] ? might_fault+0x9d/0xa0
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c0449013>] ? __mutex_lock_common+0x2f3/0x430
>  [<c0197d6f>] ? vfs_readdir+0x4f/0xa0
>  [<c01e2d67>] reiserfs_readdir+0x17/0x20
>  [<c0197d9e>] vfs_readdir+0x7e/0xa0
>  [<c0197b70>] ? filldir+0x0/0xd0
>  [<c0197ed8>] sys_getdents+0x68/0xb0
>  [<c0102e48>] sysenter_do_call+0x12/0x36
> INFO: lockdep is turned off.


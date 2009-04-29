Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZD2VlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZD2VlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZD2VlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:41:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbZD2VlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:41:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
Date: Wed, 29 Apr 2009 23:40:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Sachin Sant <sachinp@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <200904292151.46107.rjw@sisk.pl> <49F8C255.2040301@gmail.com>
In-Reply-To: <49F8C255.2040301@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904292340.17071.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Marcin Slusarz wrote:
> Rafael J. Wysocki pisze:
> > On Wednesday 29 April 2009, Sachin Sant wrote:
> >> Rafael J. Wysocki wrote:
> >>> This message has been generated automatically as a part of a report
> >>> of recent regressions.
> >>>
> >>> The following bug entry is on the current list of known regressions
> >>> from 2.6.29.  Please verify if it still should be listed and let me know
> >>> (either way).
> >>>
> >>>
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
> >>> Subject		: Lockdep warining in inotify_dev_queue_event
> >>> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> >>> Date		: 2009-04-05 12:37 (21 days old)
> >>> References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4
> >>>
> >>>
> >>>   
> >> I have not been able to recreate this problem with recent 
> >> kernels(rc3-git's).
> > 
> > Thanks, I've closed the bug.
> 
> Was it really fixed? I'm on 56a50adda49b2020156616c4eb15353e0f9ad7de and still seeing this warning.
> 
> [ 2771.164306]
> [ 2771.164309] =================================
> [ 2771.164323] [ INFO: inconsistent lock state ]
> [ 2771.164329] 2.6.30-rc3-mod-56a50adda #121
> [ 2771.164333] ---------------------------------
> [ 2771.164338] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
> [ 2771.164344] emerge/14418 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 2771.164349]  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802c2d25>] inotify_inode_queue_event+0x4f/0xe0
> [ 2771.164367] {IN-RECLAIM_FS-W} state was registered at:
> [ 2771.164371]   [<ffffffff80254f5f>] __lock_acquire+0x618/0x7b1
> [ 2771.164382]   [<ffffffff802551e7>] lock_acquire+0xef/0x111
> [ 2771.164390]   [<ffffffff805beef7>] mutex_lock_nested+0x5a/0x2da
> [ 2771.164399]   [<ffffffff802c2e19>] inotify_inode_is_dead+0x29/0x8f
> [ 2771.164407]   [<ffffffff802a9bdd>] dentry_iput+0x7c/0xbb
> [ 2771.164416]   [<ffffffff802a9d01>] d_kill+0x41/0x62
> [ 2771.164423]   [<ffffffff802a9f2e>] __shrink_dcache_sb+0x20c/0x2af
> [ 2771.164433]   [<ffffffff802aa0de>] shrink_dcache_memory+0xfe/0x18e
> [ 2771.164440]   [<ffffffff8027db03>] shrink_slab+0xe2/0x176
> [ 2771.164448]   [<ffffffff8027e2e5>] kswapd+0x35c/0x542
> [ 2771.164455]   [<ffffffff80245550>] kthread+0x50/0x7c
> [ 2771.164465]   [<ffffffff8020bd6a>] child_rip+0xa/0x20
> [ 2771.164473]   [<ffffffffffffffff>] 0xffffffffffffffff
> [ 2771.164481] irq event stamp: 5964095
> [ 2771.164484] hardirqs last  enabled at (5964095): [<ffffffff80296ef7>] kmem_cache_alloc+0x9a/0x138
> [ 2771.164495] hardirqs last disabled at (5964094): [<ffffffff80296a30>] __slab_alloc+0x349/0x5c6
> [ 2771.164504] softirqs last  enabled at (5962724): [<ffffffff80236ac6>] __do_softirq+0x1be/0x1ca
> [ 2771.164514] softirqs last disabled at (5962715): [<ffffffff8020be6a>] call_softirq+0x1a/0x24
> [ 2771.164522]
> [ 2771.164523] other info that might help us debug this:
> [ 2771.164529] 4 locks held by emerge/14418:
> [ 2771.164533]  #0:  (&type->i_mutex_dir_key#2){+.+.+.}, at: [<ffffffff802a60ce>] do_filp_open+0x183/0x7d0
> [ 2771.164550]  #1:  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802c2d25>] inotify_inode_queue_event+0x4f/0xe0
> [ 2771.164567]  #2:  (&ih->mutex){+.+...}, at: [<ffffffff802c2d53>] inotify_inode_queue_event+0x7d/0xe0
> [ 2771.164582]  #3:  (&dev->ev_mutex){+.+...}, at: [<ffffffff802c3d7c>] inotify_dev_queue_event+0x36/0x15b
> [ 2771.164598]
> [ 2771.164599] stack backtrace:
> [ 2771.164606] Pid: 14418, comm: emerge Not tainted 2.6.30-rc3-mod-56a50adda #121
> [ 2771.164611] Call Trace:
> [ 2771.164617]  [<ffffffff8025233e>] print_usage_bug+0x1b8/0x1c9
> [ 2771.164623]  [<ffffffff80253574>] ? check_usage_backwards+0x0/0x9f
> [ 2771.164629]  [<ffffffff80252632>] mark_lock+0x2e3/0x546
> [ 2771.164635]  [<ffffffff802528e2>] mark_held_locks+0x4d/0x6a
> [ 2771.164641]  [<ffffffff80252df6>] lockdep_trace_alloc+0xa6/0xbf
> [ 2771.164647]  [<ffffffff802c3cdc>] ? kernel_event+0xa9/0x113
> [ 2771.164653]  [<ffffffff8029826a>] __kmalloc+0xc2/0x1db
> [ 2771.164660]  [<ffffffff802c3cdc>] kernel_event+0xa9/0x113
> [ 2771.164666]  [<ffffffff802c3e26>] inotify_dev_queue_event+0xe0/0x15b
> [ 2771.164673]  [<ffffffff802c2d81>] inotify_inode_queue_event+0xab/0xe0
> [ 2771.164679]  [<ffffffff802a3655>] vfs_create+0xf6/0x119
> [ 2771.164685]  [<ffffffff802b1fca>] ? mnt_want_write+0x26/0xa4
> [ 2771.164691]  [<ffffffff802a618c>] do_filp_open+0x241/0x7d0
> [ 2771.164697]  [<ffffffff802aeaa6>] ? alloc_fd+0xfe/0x10d
> [ 2771.164704]  [<ffffffff8022c2bf>] ? sub_preempt_count+0xa0/0xbd
> [ 2771.164710]  [<ffffffff805c0f03>] ? _spin_unlock+0x30/0x49
> [ 2771.164716]  [<ffffffff80299282>] do_sys_open+0x53/0xda
> [ 2771.164722]  [<ffffffff80299332>] sys_open+0x1b/0x1d
> [ 2771.164728]  [<ffffffff8020ae68>] system_call_fastpath+0x16/0x1b

OK, reopened.

Since Sachin is no longer able to reproduce it, now you're the reporter. :-)

Thanks,
Rafael

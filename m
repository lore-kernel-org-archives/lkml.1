Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZGHDwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZGHDwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZGHDv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:51:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28955 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZGHDv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:51:56 -0400
X-IronPort-AV: E=Sophos;i="4.42,366,1243814400"; 
   d="scan'208";a="339570476"
From: Roland Dreier <rdreier@cisco.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Paris <eparis@redhat.com>
Subject: Re: 2.6.31-rc2 -- INFO: inconsistent lock state -- inconsistent  {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
References: <a44ae5cd0907052122w1733780eh84c37a0b288cbd1d@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 07 Jul 2009 20:51:54 -0700
In-Reply-To: <a44ae5cd0907052122w1733780eh84c37a0b288cbd1d@mail.gmail.com>
	(Miles Lane's message of "Mon, 6 Jul 2009 00:22:11 -0400")
Message-ID: <adafxd7x25h.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jul 2009 03:51:55.0363 (UTC) FILETIME=[6F842330:01C9FF7F]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Eric Paris cc as this looks to be an inotify issue ]

 > [ 6627.976224] =================================
 > [ 6627.976237] [ INFO: inconsistent lock state ]
 > [ 6627.976247] 2.6.31-rc2 #16
 > [ 6627.976254] ---------------------------------
 > [ 6627.976263] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
 > [ 6627.976276] khubd/217 [HC0[0]:SC0[0]:HE1:SE1] takes:
 > [ 6627.976285]  (iprune_mutex){+.+.?.}, at: [<c10ba899>]
 > invalidate_inodes+0x20/0xe3
 > [ 6627.976315] {IN-RECLAIM_FS-W} state was registered at:
 > [ 6627.976324]   [<c10536ab>] __lock_acquire+0x2c9/0xac4
 > [ 6627.976343]   [<c1053f45>] lock_acquire+0x9f/0xc2
 > [ 6627.976358]   [<c1308872>] __mutex_lock_common+0x2d/0x323
 > [ 6627.976376]   [<c1308c00>] mutex_lock_nested+0x2e/0x36
 > [ 6627.976392]   [<c10ba6ff>] shrink_icache_memory+0x38/0x1b2
 > [ 6627.976407]   [<c108bfb6>] shrink_slab+0xe2/0x13c
 > [ 6627.976424]   [<c108c3e1>] kswapd+0x3d1/0x55d
 > [ 6627.976439]   [<c10449b5>] kthread+0x66/0x6b
 > [ 6627.976454]   [<c1003fdf>] kernel_thread_helper+0x7/0x10
 > [ 6627.976472]   [<ffffffff>] 0xffffffff
 > [ 6627.976494] irq event stamp: 41543
 > [ 6627.976501] hardirqs last  enabled at (41543): [<c13086f7>]
 > __mutex_unlock_slowpath+0x10a/0x118
 > [ 6627.976520] hardirqs last disabled at (41542): [<c1308645>]
 > __mutex_unlock_slowpath+0x58/0x118
 > [ 6627.976539] softirqs last  enabled at (41158): [<c129d01f>]
 > __rcu_read_unlock_bh+0x1c/0x1e
 > [ 6627.976559] softirqs last disabled at (41156): [<c129cfcb>]
 > __rcu_read_lock_bh+0x8/0x26
 > [ 6627.976576]
 > [ 6627.976579] other info that might help us debug this:
 > [ 6627.976590] 2 locks held by khubd/217:
 > [ 6627.976598]  #0:  (&type->s_umount_key#39){.+.+.+}, at:
 > [<c10acd4b>] get_super+0x42/0x87
 > [ 6627.976631]  #1:  (iprune_mutex){+.+.?.}, at: [<c10ba899>]
 > invalidate_inodes+0x20/0xe3
 > [ 6627.976657]
 > [ 6627.976660] stack backtrace:
 > [ 6627.976672] Pid: 217, comm: khubd Not tainted 2.6.31-rc2 #16
 > [ 6627.976681] Call Trace:
 > [ 6627.976696]  [<c1307907>] ? printk+0xf/0x18
 > [ 6627.976711]  [<c10526d7>] valid_state+0x12a/0x13d
 > [ 6627.976726]  [<c10527ad>] mark_lock+0xc3/0x1b4
 > [ 6627.976740]  [<c1052eea>] ? check_usage_backwards+0x0/0x3f
 > [ 6627.976755]  [<c10528e1>] mark_held_locks+0x43/0x5b
 > [ 6627.976772]  [<c10cf46d>] ? inotify_ignored_and_remove_idr+0x19/0x74
 > [ 6627.976787]  [<c105299e>] lockdep_trace_alloc+0xa5/0xc1
 > [ 6627.976802]  [<c10a6685>] kmem_cache_alloc+0x21/0x13a
 > [ 6627.976818]  [<c10cf46d>] inotify_ignored_and_remove_idr+0x19/0x74
 > [ 6627.976834]  [<c10ceb77>] inotify_freeing_mark+0x8/0xa
 > [ 6627.976849]  [<c10cd989>] fsnotify_destroy_mark_by_entry+0xf1/0x115
 > [ 6627.976858]  [<c10cda32>] fsnotify_clear_marks_by_inode+0x85/0xa2
 > [ 6627.976858]  [<c10ccdbf>] __fsnotify_inode_delete+0x8/0xd
 > [ 6627.976858]  [<c10cd670>] fsnotify_unmount_inodes+0xb0/0xdf
 > [ 6627.976858]  [<c10ba8b9>] invalidate_inodes+0x40/0xe3
 > [ 6627.976858]  [<c10c977f>] __invalidate_device+0x21/0x38
 > [ 6627.976858]  [<c116c981>] invalidate_partition+0x1e/0x2d
 > [ 6627.976858]  [<c10e7710>] del_gendisk+0x2d/0xf0
 > [ 6627.976858]  [<c122e473>] sd_remove+0x35/0x67
 > [ 6627.976858]  [<c121b637>] __device_release_driver+0x47/0x7f
 > [ 6627.976858]  [<c121b70c>] device_release_driver+0x18/0x23
 > [ 6627.976858]  [<c121ad1b>] bus_remove_device+0x71/0x7e
 > [ 6627.976858]  [<c1219a0a>] device_del+0xf0/0x131
 > [ 6627.976858]  [<c122a4a6>] __scsi_remove_device+0x34/0x65
 > [ 6627.976858]  [<c12285a5>] scsi_forget_host+0x35/0x51
 > [ 6627.976858]  [<c1223615>] scsi_remove_host+0x69/0xd4
 > [ 6627.976858]  [<f805f67c>] quiesce_and_remove_host+0x4c/0x7e [usb_storage]
 > [ 6627.976858]  [<f805f760>] usb_stor_disconnect+0x11/0x1b [usb_storage]
 > [ 6627.976858]  [<c124adca>] usb_unbind_interface+0x4e/0xc4
 > [ 6627.976858]  [<c121b637>] __device_release_driver+0x47/0x7f
 > [ 6627.976858]  [<c121b70c>] device_release_driver+0x18/0x23
 > [ 6627.976858]  [<c121ad1b>] bus_remove_device+0x71/0x7e
 > [ 6627.976858]  [<c1219a0a>] device_del+0xf0/0x131
 > [ 6627.976858]  [<c1248795>] usb_disable_device+0xc1/0x125
 > [ 6627.976858]  [<c1243f37>] usb_disconnect+0xb2/0x117
 > [ 6627.976858]  [<c12450da>] hub_thread+0x533/0xe45
 > [ 6627.976858]  [<c13080fd>] ? schedule+0x70c/0x769
 > [ 6627.976858]  [<c1044bfc>] ? autoremove_wake_function+0x0/0x2f
 > [ 6627.976858]  [<c1244ba7>] ? hub_thread+0x0/0xe45
 > [ 6627.976858]  [<c10449b5>] kthread+0x66/0x6b
 > [ 6627.976858]  [<c104494f>] ? kthread+0x0/0x6b
 > [ 6627.976858]  [<c1003fdf>] kernel_thread_helper+0x7/0x10
 > [ 6628.142547] usb 1-3:1.0: uevent

I don't believe that this is actually related to usb; it looks to be an
inotify issue (and I believe lockdep is warning about a real bug).

What lockdep is saying is that iprune_mutex is held during reclaim, when
it is taken in prune_icache(); however invalidate_inodes() also takes
iprune_mutex and then calls into fsnotify_unmount_inodes(), which ends
up in fsnotify_destroy_mark_by_entry().  And if inotify is in use, then
it calls into inotify_freeing_mark() via group->ops->freeing_mark, which
just does inotify_ignored_and_remove_idr().

And then if we look at this:

void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
				    struct fsnotify_group *group)
{
	//..

	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);

	//...

	fsnotify_add_notify_event(group, inotify_ignored_event, fsn_event_priv);
}

so it does a GFP_KERNEL allocation with iprune_mutex held; which could
deadlock if it triggers reclaim and ends up in prune_icache().  The
trivial fix for this immediate issue is:

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index ff27a29..b1727e8 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -379,7 +379,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
-	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
+	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_NOFS);
 	if (unlikely(!event_priv))
 		goto skip_send_ignore;
 
but I don't think this fully fixes things -- notice that there is also
fsnotify_add_notify_event() there, which it seems might do
fsnotify_alloc_event_holder(), which is just

	return kmem_cache_alloc(fsnotify_event_holder_cachep, GFP_KERNEL);

ie another GFP_KERNEL allocation that might happen with iprune_mutex
held.  Again the simple fix is to change this to GFP_NOFS but I'm not
sure if it might not be better to pass a gfp mask in to know when we
might be in reclaim and when we might not be, to avoid failing
allocations and lost events.

Anyway, hope this helps...

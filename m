Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZEFF5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZEFF5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZEFF4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:56:55 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:64868 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZEFF4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:56:54 -0400
Message-ID: <4A012665.9030300@freemail.hu>
Date: Wed, 06 May 2009 07:55:49 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc4: inconsistent lock state
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32710; Body=1 Fuz1=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this error recently while I was compiling kernel on ext3 fs. The kernel
was running on a Clevo D410J laptop.

I don't know whether this is reproducible or not, but maybe this info is enough
for somebody. I can send the full dmesg/.config or anything which is needed.

[ 1771.878353]
[ 1771.878358] =================================
[ 1771.878364] [ INFO: inconsistent lock state ]
[ 1771.878369] 2.6.30-rc4 #1
[ 1771.878372] ---------------------------------
[ 1771.878376] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 1771.878381] kswapd0/183 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1771.878385]  (&inode->inotify_mutex){+.+.?.}, at: [<c01cc03b>] inotify_inode_is_dead+0x1b/0x80
[ 1771.878399] {RECLAIM_FS-ON-W} state was registered at:
[ 1771.878402]   [<c014b7d2>] mark_held_locks+0x62/0x80
[ 1771.878410]   [<c014b8b5>] lockdep_trace_alloc+0xc5/0xd0
[ 1771.878415]   [<c019caf0>] __kmalloc+0x70/0x230
[ 1771.878422]   [<c01ccfa7>] kernel_event+0x87/0x130
[ 1771.878427]   [<c01cd0cf>] inotify_dev_queue_event+0x7f/0x180
[ 1771.878432]   [<c01cbf53>] inotify_inode_queue_event+0xa3/0xe0
[ 1771.878437]   [<c01a900a>] vfs_create+0xba/0x100
[ 1771.878443]   [<c01ac14d>] do_filp_open+0x6dd/0x810
[ 1771.878449]   [<c019e339>] do_sys_open+0x59/0xf0
[ 1771.878454]   [<c019e439>] sys_open+0x29/0x40
[ 1771.878459]   [<c0102e84>] sysenter_do_call+0x12/0x32
[ 1771.878465]   [<ffffffff>] 0xffffffff
[ 1771.878490] irq event stamp: 315803
[ 1771.878493] hardirqs last  enabled at (315803): [<c016ae34>] call_rcu+0xb4/0xe0
[ 1771.878501] hardirqs last disabled at (315802): [<c016ad9e>] call_rcu+0x1e/0xe0
[ 1771.878508] softirqs last  enabled at (315442): [<c012b80f>] __do_softirq+0x15f/0x1e0
[ 1771.878516] softirqs last disabled at (315435): [<c012b8ed>] do_softirq+0x5d/0x70
[ 1771.878522]
[ 1771.878523] other info that might help us debug this:
[ 1771.878527] 2 locks held by kswapd0/183:
[ 1771.878530]  #0:  (shrinker_rwsem){++++..}, at: [<c0182bf4>] shrink_slab+0x24/0x1a0
[ 1771.878540]  #1:  (&type->s_umount_key#16){++++..}, at: [<c01b0553>] shrink_dcache_memory+0x103/0x1b0
[ 1771.878551]
[ 1771.878552] stack backtrace:
[ 1771.878556] Pid: 183, comm: kswapd0 Not tainted 2.6.30-rc4 #1
[ 1771.878559] Call Trace:
[ 1771.878566]  [<c0364305>] ? printk+0x18/0x1b
[ 1771.878570]  [<c014b0c7>] print_usage_bug+0x167/0x1c0
[ 1771.878576]  [<c014b570>] mark_lock+0x450/0x650
[ 1771.878580]  [<c014bef0>] ? check_usage_forwards+0x0/0xb0
[ 1771.878586]  [<c014cc5a>] __lock_acquire+0x3ca/0x18a0
[ 1771.878591]  [<c014c9dc>] ? __lock_acquire+0x14c/0x18a0
[ 1771.878596]  [<c01cc03b>] ? inotify_inode_is_dead+0x1b/0x80
[ 1771.878601]  [<c014e1ff>] lock_acquire+0xcf/0xf0
[ 1771.878606]  [<c01cc03b>] ? inotify_inode_is_dead+0x1b/0x80
[ 1771.878611]  [<c01cc03b>] ? inotify_inode_is_dead+0x1b/0x80
[ 1771.878616]  [<c0365968>] mutex_lock_nested+0x58/0x350
[ 1771.878621]  [<c01cc03b>] ? inotify_inode_is_dead+0x1b/0x80
[ 1771.878626]  [<c01cc03b>] inotify_inode_is_dead+0x1b/0x80
[ 1771.878632]  [<c01b003c>] dentry_iput+0x9c/0xc0
[ 1771.878637]  [<c01b0146>] d_kill+0x36/0x60
[ 1771.878643]  [<c01b0385>] __shrink_dcache_sb+0x215/0x2e0
[ 1771.878649]  [<c01b0585>] shrink_dcache_memory+0x135/0x1b0
[ 1771.878654]  [<c0182cd5>] shrink_slab+0x105/0x1a0
[ 1771.878660]  [<c0183213>] kswapd+0x4a3/0x5d0
[ 1771.878666]  [<c0180c20>] ? isolate_pages_global+0x0/0x200
[ 1771.878672]  [<c013b6c0>] ? autoremove_wake_function+0x0/0x50
[ 1771.878678]  [<c0182d70>] ? kswapd+0x0/0x5d0
[ 1771.878683]  [<c013b373>] kthread+0x43/0x80
[ 1771.878687]  [<c013b330>] ? kthread+0x0/0x80
[ 1771.878692]  [<c010372b>] kernel_thread_helper+0x7/0x1c

Maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=13068 ?

Regards,

	Márton Németh

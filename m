Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZDEM0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZDEM0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZDEMZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:25:57 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:42231 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZDEMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:25:56 -0400
Message-ID: <49D8A34C.2020200@in.ibm.com>
Date: Sun, 05 Apr 2009 17:55:48 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, peterz@infradead.org, mingo@redhat.com
Subject: 2.6.29-git12 : lockdep warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.29-git12 on a powerpc box i observed the following
warning

=================================
2.6.29-git12 #1
inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
yum-updatesd-he/6947 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&inode->inotify_mutex){+.+.?.}, at: [<c000000000154a04>] .inotify_inode_queue_event+0x6c/0x160
  [<c000000000098198>] .lock_acquire+0x54/0x80
  [<c000000000154bb0>] .inotify_inode_is_dead+0x38/0xcc
  [<c0000000001319f0>] .d_kill+0x68/0xac
  [<c0000000001320b4>] .shrink_dcache_memory+0x134/0x214
  [<c0000000000e82fc>] .shrink_slab+0x144/0x20c
  [<c0000000000e936c>] .kswapd+0x43c/0x628
  [<c0000000000850e0>] .kthread+0x78/0xc4
  [<c00000000002bd6c>] .kernel_thread+0x54/0x70
irq event stamp: 223781
hardirqs last  enabled at (223781): [<c0000000001101c8>] .kmem_cache_alloc+0x184/0x200
hardirqs last disabled at (223780): [<c00000000010f204>] .cache_grow+0x3b0/0x48c
softirqs last  enabled at (222934): [<c00000000002ba64>] .call_do_softirq+0x14/0x24
softirqs last disabled at (222923): [<c00000000002ba64>] .call_do_softirq+0x14/0x24

other info that might help us debug this:
4 locks held by yum-updatesd-he/6947:
 #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c00000000012c53c>] .do_filp_open+0x188/0x874
 #1:  (&inode->inotify_mutex){+.+.?.}, at: [<c000000000154a04>] .inotify_inode_queue_event+0x6c/0x160
 #2:  (&ih->mutex){+.+...}, at: [<c000000000154a34>] .inotify_inode_queue_event+0x9c/0x160
 #3:  (&dev->ev_mutex){+.+...}, at: [<c000000000156330>] .inotify_dev_queue_event+0x50/0x1d8

stack backtrace:
Call Trace:
[c0000000541ff4f0] [c0000000000115cc] .show_stack+0x70/0x184 (unreliable)
[c0000000541ff5a0] [c000000000093a00] .print_usage_bug+0x1bc/0x1ec
[c0000000541ff650] [c000000000093dac] .mark_lock+0x37c/0x6c0
[c0000000541ff700] [c000000000094148] .mark_held_locks+0x58/0xac
[c0000000541ff790] [c000000000097f54] .lockdep_trace_alloc+0xc4/0xf4
[c0000000541ff810] [c00000000010fc24] .__kmalloc+0x98/0x25c
[c0000000541ff8b0] [c000000000156244] .kernel_event+0xbc/0x158
[c0000000541ff950] [c000000000156400] .inotify_dev_queue_event+0x120/0x1d8
[c0000000541ffa00] [c000000000154a84] .inotify_inode_queue_event+0xec/0x160
[c0000000541ffad0] [c0000000001292cc] .vfs_create+0x168/0x1e4
[c0000000541ffb70] [c00000000012c5f0] .do_filp_open+0x23c/0x874
[c0000000541ffd10] [c00000000011aecc] .do_sys_open+0x80/0x140
[c0000000541ffdc0] [c000000000161748] .compat_sys_open+0x24/0x38
[c0000000541ffe30] [c000000000008554] syscall_exit+0x0/0x40

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


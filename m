Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYFDD2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYFDD2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFDD2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:28:42 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:32876 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbYFDD2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:28:41 -0400
Message-ID: <48460B94.8050000@linux.vnet.ibm.com>
Date: Wed, 04 Jun 2008 08:57:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: per_cpu_counter_sum lockdep warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saw this warning on an x86_64 box, while booting up 2.6.26-rc4. Has anybody else
seen it? Working on it?

=================================
[ INFO: inconsistent lock state ]
2.6.26-rc4 #2
---------------------------------
inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
init/1 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&fbc->lock){+...}, at: [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a
{in-hardirq-W} state was registered at:
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 694563
hardirqs last  enabled at (694563): [<ffffffff80297533>] kmem_cache_free+0x1a9/0x1bb
hardirqs last disabled at (694562): [<ffffffff802973aa>] kmem_cache_free+0x20/0x1bb
softirqs last  enabled at (692960): [<ffffffff8023a27b>] __do_softirq+0xda/0xe3
softirqs last disabled at (692945): [<ffffffff8020c4ac>] call_softirq+0x1c/0x28

other info that might help us debug this:
no locks held by init/1.

stack backtrace:
Pid: 1, comm: init Not tainted 2.6.26-rc4 #2

Call Trace:
 [<ffffffff802518e6>] print_usage_bug+0x15e/0x16f
 [<ffffffff8025281f>] mark_lock+0x22f/0x416
 [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
 [<ffffffff80253576>] __lock_acquire+0x4e7/0xc8a
 [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
 [<ffffffff80253da7>] lock_acquire+0x8e/0xb2
 [<ffffffff80386382>] ? __percpu_counter_sum+0xf/0x5a
 [<ffffffff805990d7>] _spin_lock+0x26/0x53
 [<ffffffff80386382>] __percpu_counter_sum+0xf/0x5a
 [<ffffffff803139e2>] ext3_statfs+0xd6/0x160
 [<ffffffff8029c6be>] vfs_statfs+0x4e/0x6d
 [<ffffffff8029c85f>] vfs_statfs_native+0x22/0x48
 [<ffffffff8029c945>] sys_statfs+0x4d/0x89
 [<ffffffff80252bfe>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff8037da3d>] ? __up_read+0x8f/0x97
 [<ffffffff8024ad5a>] ? up_read+0x26/0x2a
 [<ffffffff80598cf0>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80252bfe>] ? trace_hardirqs_on+0xf9/0x124
 [<ffffffff80598cf0>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b1fb>] system_call_after_swapgs+0x7b/0x80

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

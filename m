Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbXIXQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbXIXQs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763600AbXIXQpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:45:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763703AbXIXQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:45:11 -0400
Date: Mon, 24 Sep 2007 09:44:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.23-rc7-mm1
Message-Id: <20070924094448.d08cf3a6.akpm@linux-foundation.org>
In-Reply-To: <46F7B7FD.1000905@linux.vnet.ibm.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	<46F7B7FD.1000905@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 18:43:33 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Kernel BUG over x86_64 (AMD Opteron(tm) Processor 844).
> 
> Similar kernel Bug was reported for 2.6.23-rc2-mm1
> at http://lkml.org/lkml/2007/8/10/20 and the 
> mm-dirty-balancing-for-tasks.patch was dropped from 2.6.23-rc2-mm2.
> And the same patch is in this -mm version, suspect whether is it the
> same patch triggering this Bug.
> 
> BUG: soft lockup - CPU#0 stuck for 11s! [events/0:15]
> CPU 0:
> Modules linked in:
> Pid: 15, comm: events/0 Tainted: G      D 2.6.23-rc7-mm1-autokern1 #1
> RIP: 0010:[<ffffffff8021be46>]  [<ffffffff8021be46>] __smp_call_function_mask+0x9a/0xc4
> RSP: 0000:ffff8100017add80  EFLAGS: 00000297
> RAX: 00000000000000fc RBX: ffff8100017adde0 RCX: 0000000000000001
> RDX: 00000000000008fc RSI: 00000000000000fc RDI: 000000000000000e
> RBP: ffffc20002d11000 R08: ffff8100017ac000 R09: ffffffff80675e38
> R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000f
> R13: ffffffff8021bcfe R14: 0000000000000000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffffffff8065a000(0000) knlGS:00000000556aa2a0
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: ffffc20002d11008 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Call Trace:
> Inexact backtrace:
>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
>  [<ffffffff8021becf>] smp_call_function_mask+0x5f/0x72
>  [<ffffffff802157a4>] mcheck_check_cpu+0x0/0x31
>  [<ffffffff8021bf82>] smp_call_function+0x19/0x1b
>  [<ffffffff8023a773>] on_each_cpu+0x16/0x2b
>  [<ffffffff802158a2>] mcheck_timer+0x0/0x7c
>  [<ffffffff802158c0>] mcheck_timer+0x1e/0x7c
>  [<ffffffff802444b9>] run_workqueue+0x88/0x109
>  [<ffffffff8024453a>] worker_thread+0x0/0xf4
>  [<ffffffff80244623>] worker_thread+0xe9/0xf4
>  [<ffffffff8024841d>] autoremove_wake_function+0x0/0x37
>  [<ffffffff8024841d>] autoremove_wake_function+0x0/0x37
>  [<ffffffff80247e5c>] kthread+0x44/0x6d
>  [<ffffffff8020c5a8>] child_rip+0xa/0x12
>  [<ffffffff80247e18>] kthread+0x0/0x6d
>  [<ffffffff8020c59e>] child_rip+0x0/0x12

hm, I thought we'd fixed the problems in that patchset.  Peter, were
you aware of this one?

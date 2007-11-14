Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbXKNPvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbXKNPvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXKNPvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:51:13 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56069 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXKNPvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:51:12 -0500
Date: Wed, 14 Nov 2007 18:50:31 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114155031.GA12398@tv-sign.ru>
References: <20071114151708.GA12355@tv-sign.ru> <20071114152930.GA1690@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114152930.GA1690@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > > [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP:
> > > [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > > [18073.371144] PGD 81f9067 PUD 81c8067 PMD 0
> > > [18073.371151] Oops: 0000 [1] PREEMPT SMP
> > > [18073.371157] CPU 2
> > > [18073.371161] Modules linked in: vfat fat
> > > [18073.371168] Pid: 4639, comm: kwin Not tainted 2.6.24-rc1 #1
> > > [18073.371171] RIP: 0010:[<ffffffff8023572e>]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > > [18073.371177] RSP: 0018:ffff810008531a78  EFLAGS: 00010006
> > > [18073.371179] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > [18073.371183] RDX: ffff810004441bf0 RSI: ffff81000801e860 RDI: ffff81000444ab80
> > > [18073.371186] RBP: ffff810008531aa8 R08: 000000d0d47a4a90 R09: 0000000000000000
> > > [18073.371188] R10: ffff810004441bf0 R11: 0000000000000001 R12: ffff810006520400
> > > [18073.371190] R13: ffff81000801e860 R14: ffff81000a63a000 R15: ffff81000443d8e0
> > > [18073.371193] FS:  00002b7d646a86f0(0000) GS:ffff810004c11780(0000) knlGS:0000000000000000
> > > [18073.371196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [18073.371199] CR2: 0000000000000120 CR3: 0000000008495000 CR4: 00000000000006e0
> > > [18073.371202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [18073.371211] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > [18073.371214] Process kwin (pid: 4639, threadinfo ffff810008530000, task ffff81000840a860)
> > > [18073.371216] Stack:  ffff81000444ab80 0000000000000001 ffff81000801e860 ffff81000444ab80
> > > [18073.371231]  0000000000000002 ffff81000443d8e0 ffff810008531b38 ffffffff8023061e
> > > [18073.371238]  0000000000000000 ffff810004441b80 0000000000000002 0000000100000000
> > > [18073.371245] Call Trace:
> > > [18073.371250]  [<ffffffff8023061e>] try_to_wake_up+0x2fe/0x3a0
> > 
> > I suspect I see the bug in that area, but I am not sure it can explain 
> > this trace completely.
> 
> there's a fix pending from Dmitry - please see below. It took days for 
> Grant to trigger the crash so it needs some time to be confirmed but it 
> could explain the crash in theory.

Yes I agree, it can explain the crash.

However, this patch can't fix the bug I was talking about (of course, unless
I missed something). It is still possible that the "fair_sched_class" task
can have ->se.cfs_rq/parent pointing to the freed memory, no?

Oleg.


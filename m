Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXDVHc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXDVHc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXDVHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:32:59 -0400
Received: from mail30.syd.optusnet.com.au ([211.29.133.193]:45425 "EHLO
	mail30.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbXDVHc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:32:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 17:31:58 +1000
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704221441.48897.kernel@kolivas.org> <20070422070037.GA15092@1wt.eu> <200704221727.44430.kernel@kolivas.org>
In-Reply-To: <200704221727.44430.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221731.58724.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 17:27, Con Kolivas wrote:
> On Sunday 22 April 2007 17:00, Willy Tarreau wrote:
> > On Sun, Apr 22, 2007 at 02:41:48PM +1000, Con Kolivas wrote:
> > > A significant bugfix for SMP balancing was just posted for the
> > > staircase deadline cpu scheduler which improves behaviour dramatically
> > > on any SMP machine.
> > >
> > > Thanks to Willy Tarreau for noticing likely fault point.
> > >
> > > Also requested was a version in the Makefile so this version of the
> > > patch adds -sd045 to the kernel version.
> >
> > Con, I'm sorry, but it is worse with this one :-(
>
> Well that was quick testing, thanks.
>
> > The lag when typing in xterms is even more noticeable and vmstat output
> > oscillates between 8 and 65, with idle rates around 50%, as you can see
> > below :
> >
> > Renicing X or not does not change anything here.
> >
> > I suspect that the bug you fixed was hiding another one :-/
> > If you want me to test another patch, feel free to ask.

Just as a debug point could you please try this patch? Thanks.

> Thanks. Clearly still a bug in there. I have to keep looking. The other
> changes are still valid so I have to run with them.
>
> > Willy
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-22 17:30:25.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-22 17:30:49.000000000 +1000
@@ -3276,6 +3276,7 @@ retry:
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
+#if 0
 	if (unlikely(next->time_slice <= 0)) {
 		/*
 		 * Unlucky enough that this task ran out of time_slice
@@ -3287,6 +3288,7 @@ retry:
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
 		goto retry;
 	}
+#endif
 	next->rotation = rq->prio_rotation;
 	nstatic = next->static_prio;
 	if (nstatic < array->best_static_prio)

-- 
-ck

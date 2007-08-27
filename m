Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbXH0Or4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbXH0Or4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbXH0Orr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:47:47 -0400
Received: from [212.12.190.28] ([212.12.190.28]:32870 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756666AbXH0Orq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:47:46 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Mon, 27 Aug 2007 17:46:47 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708270706.41565.a1426z@gawab.com> <20070827105317.GA15003@elte.hu>
In-Reply-To: <20070827105317.GA15003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271746.47685.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > could you send the exact patch that shows what you did?
> >
> > On 2.6.22.5-v20.3 (not v20.4):
> >
> > 340-    curr->delta_exec += delta_exec;
> > 341-
> > 342-    if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity))
> > { 343://          __update_curr(cfs_rq, curr);
> > 344-            curr->delta_exec = 0;
> > 345-    }
> > 346-    curr->exec_start = rq_of(cfs_rq)->clock;
>
> ouch - this produces a really broken scheduler - with this we dont do
> any run-time accounting (!).

Of course it's broken, and it's not meant as a fix, but this change allows 
you to see the amount of overhead as well as any miscalculations 
__update_curr incurs.

In terms of overhead, __update_curr incurs ~3x slowdown, and in terms of 
run-time accounting it exhibits a ~10sec task-startup miscalculation.

> Could you try the patch below instead, does this make 3x glxgears smooth
> again? (if yes, could you send me your Signed-off-by line as well.)

The task-startup stalling is still there for ~10sec.

Can you see the problem on your machine?


Thanks!

--
Al


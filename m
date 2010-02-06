Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0BFPUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 10:20:21 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:59005 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252Ab0BFPUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 10:20:20 -0500
Date: Sat, 6 Feb 2010 18:20:40 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler oddity
In-Reply-To: <1265458315.8803.79.camel@marge.simson.net>
Message-ID: <alpine.LNX.2.00.1002061819330.18643@linmac>
References: <alpine.LNX.2.00.1002051928230.4744@linmac> <1265458315.8803.79.camel@marge.simson.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010, Mike Galbraith wrote:

> On Fri, 2010-02-05 at 19:33 +0300, malc wrote:
> > Following test exhibits somewhat odd behaviour on, at least, 2.6.32.3 
> > (ppc) and 2.6.29.1 (x86_64), perhaps someone could explain why.
> 
> Expected behavior.
> 
> SCHED_BATCH tasks do not wakeup preempt, preemption is tick driven.  The
> writer therefore has time to fill the pipe/block, so reader can then
> drain the pipe, leading to efficient data transfer.
> 
> SCHED_NORMAL tasks do preempt.  Every write wakes a reader who's
> vruntime (CPU utilization fairness yardstick) lags the writer enough to
> warrant preemption, so one write translates to one preemption followed
> by a read.  The reader can't possibly catch up to the writer (being
> synchronous) in either case, but the scheduler doesn't know that or
> care, it simply tries to equalize the two.  Since the writer's CPU
> utilization stems entirely from tiny writes, that time is what goes
> toward equalizing the reader.  Result is the tiny I/Os the programmer
> asked for, extreme low latency, and utterly horrid throughput.
> 

Thank you.

-- 
mailto:av1474@comtv.ru

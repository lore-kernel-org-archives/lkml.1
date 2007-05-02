Return-Path: <linux-kernel-owner+w=401wt.eu-S1766802AbXEBR2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766802AbXEBR2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766848AbXEBR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:28:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43383 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766802AbXEBR2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:28:32 -0400
Date: Wed, 2 May 2007 23:06:34 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ting Yang <tingy@cs.umass.edu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502173634.GA11308@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
>  "A Proportional Share REsource Allocation Algorithm for Real-Time, 
> Time-Shared Systems", by Ion Stoica. You can find the paper here: 
> http://citeseer.ist.psu.edu/37752.html

Good paper ..thanks for the pointer.

I briefly went thr' the paper and my impression is it expect each task
to specify the length of each new request it initiates. Is that correct?

If we have to apply EEVDF to SCHED_NORMAL task scheduling under CFS, how
would we calculate that "length of each new request" (which is reqd
before we calculate its virtual deadline)?

>  EXAMPLE: assume the system runs at 1000 tick/second, i.e. 1ms a tick, 
> and the granularity of pre-exemption for CFS is 5 virtual ticks (the 
> current setting). If, at time t=0, we start 2 tasks: p1 and p2, both 
> have nice value 0 (weight 1024), and rq->fair_clock is initialized to 0. 
> Now we have: 
>        p1->fair_key = p2->fair_key = rq->fair_clock = 0.
> CFS breaks the tie arbitrarily, say it executes p1. After 1 system tick 
> (1ms later) t=1, we have:
>        rq->fair_clock = 1/2, p1->fair_key = 1,  p2->fair_key = 0.
> Suppose, a new task p3 starts with nice value -10 at this moment, that 
> is p3->fair_key=1/2. In this case, CFS will not schedule p3 for 
> execution until the fair_keys of p1 and p2 go beyond 5+1/2 (which 
> translates to about 10ms later in this setting), _regardless_ the 
> priority (weight) of p3.

There is also p->wait_runtime which is taken into account when
calculating p->fair_key. So if p3 had waiting in runqueue for long
before, it can get to run quicker than 10ms later.

-- 
Regards,
vatsa

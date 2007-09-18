Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbXIRJtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbXIRJtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXIRJs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:48:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbXIRJsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:48:55 -0400
Date: Tue, 18 Sep 2007 11:48:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070918094829.GA3809@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu> <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com> <20070918084825.GA25803@elte.hu> <6b8cef970709180245r86d370q2b1a92a29128f2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b8cef970709180245r86d370q2b1a92a29128f2e@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rob Hussey <robjhussey@gmail.com> wrote:

> On 9/18/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Rob Hussey <robjhussey@gmail.com> wrote:
> >
> > > The obligatory graphs:
> > > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_lat_ctx_benchmark.png
> > > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_hackbench_benchmark.png
> > > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_pipe-test_benchmark.png
> >
> > btw., it's likely that if you turn off CONFIG_PREEMPT for .21 and for
> > .22-ck1 they'll improve a bit too - so it's not fair to put the .23
> > !PREEMPT numbers on the graph as the PREEMPT numbers of the other
> > kernels. (it shows the .23 scheduler being faster than it really is)
> >
> 
> The graphs are really just to show where the new numbers fit in. Plus, 
> I was too lazy to run all the numbers again.

yeah - the graphs are completely OK (and they are really nice and 
useful), i just wanted to point this out for completeness.

> > the pipe-test behavior looks like an outlier. !PREEMPT only removes 
> > code (which makes the code faster), so this could be a cache layout 
> > artifact. (or perhaps we preempt at a different point which is 
> > disadvantageous to caching?) Pipe-test is equivalent to "lat_ctx -s 
> > 0 2" so if there was a genuine slowdown it would show up in the 
> > lat_ctx graph - but the graph shows a speedup.
> 
> Interestingly, every set of lat_ctx -s 0 2 numbers I run on the 
> !PREEMPT kernel are on average higher than with PREEMPT (around 2.84 
> for !PREEMPT and 2.4 for PREEMPT). Anything higher than around 2 or 3 
> (such as lat_ctx -s 0 8) gives lower average numbers for !PREEMPT.

perhaps this 2 task ping-pong is somehow special in that it manages to 
fit into L1 cache much better under PREEMPT than under !PREEMPT. 
(usually the opposite is true) At 3 tasks or more things dont fit 
anymore (or the special alignment is gone) so the faster !PREEMPT code 
wins.

	Ingo

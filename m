Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXJCJsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXJCJsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbXJCJsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:48:25 -0400
Received: from mx12.go2.pl ([193.17.41.142]:36196 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752026AbXJCJsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:48:24 -0400
Date: Wed, 3 Oct 2007 11:50:57 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003095057.GD1726@ff.dom.local>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003091058.GB7802@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 11:10:58AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > On Wed, Oct 03, 2007 at 10:16:13AM +0200, Ingo Molnar wrote:
> > > 
> > > * Jarek Poplawski <jarkao2@o2.pl> wrote:
> > > 
> > > > > firstly, there's no notion of "timeslices" in CFS. (in CFS tasks 
> > > > > "earn" a right to the CPU, and that "right" is not sliced in the 
> > > > > traditional sense) But we tried a conceptually similar thing [...]
> > > > 
> > > > >From kernel/sched_fair.c:
> > > > 
> > > > "/*
> > > >  * Targeted preemption latency for CPU-bound tasks:
> > > >  * (default: 20ms, units: nanoseconds)
> > > >  *
> > > >  * NOTE: this latency value is not the same as the concept of
> > > >  * 'timeslice length' - timeslices in CFS are of variable length.
> > > >  * (to see the precise effective timeslice length of your workload,
> > > >  *  run vmstat and monitor the context-switches field)
> > > > ..."
> > > > 
> > > > So, no notion of something, which are(!) of variable length, and which 
> > > > precise effective timeslice lenght can be seen in nanoseconds? (But 
> > > > not timeslice!)
> > > 
> > > You should really read and understand the code you are arguing about :-/
> > 
> > Maybe you could help me with better comments? IMHO, it would be enough 
> > to warn new timeslices have different meaning, or stop to use this 
> > term at all. [...]
> 
> i'm curious, what better do you need than the very detailed comment 
> quoted above? Which bit of "this latency value is not the same as the 
> concept of timeslice length" is difficult to understand? The timeslices 
> of tasks (i.e. the time they spend on a CPU without scheduling away) is 
> _not_ maintained directly in CFS as a per-task variable that can be 
> "cleared", it's not the metric that drives scheduling. Yes, of course 
> CFS too "slices up CPU time", but those slices are not the per-task 
> variables of traditional schedulers and cannot be 'cleared'.

It's not about this comment alone, but this comment plus "no notion"
comment, which appears in sched-design-CFS.txt too.

> 
> > [...] (Btw, in -rc8-mm2 I see new sched_slice() function which seems 
> > to return... time.)
> 
> wrong again. That is a function, not a variable to be cleared. (Anyway, 
> the noise/signal ratio is getting increasingly high in this thread with 
> no progress in sight, so i cannot guarantee any further replies - 
> possibly others will pick up the tab and explain/discuss any other 
> questions that might come up. Patches are welcome of course.)

I can't see anything about clearing. I think, this was about charging,
which should change the key enough, to move a task to, maybe, a better
place in a que (tree) than with current ways.

Jarek P.

PS: Don't you think that a nice argue with some celebrity, like Ingo
Molnar himself, is by far more interesting than those dull patches?

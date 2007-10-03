Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXJCIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXJCIyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXJCIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:54:06 -0400
Received: from mx2.go2.pl ([193.17.41.42]:37972 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbXJCIyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:54:05 -0400
Date: Wed, 3 Oct 2007 10:56:36 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003085636.GC1726@ff.dom.local>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003081613.GA29904@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 10:16:13AM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > > firstly, there's no notion of "timeslices" in CFS. (in CFS tasks 
> > > "earn" a right to the CPU, and that "right" is not sliced in the 
> > > traditional sense) But we tried a conceptually similar thing [...]
> > 
> > >From kernel/sched_fair.c:
> > 
> > "/*
> >  * Targeted preemption latency for CPU-bound tasks:
> >  * (default: 20ms, units: nanoseconds)
> >  *
> >  * NOTE: this latency value is not the same as the concept of
> >  * 'timeslice length' - timeslices in CFS are of variable length.
> >  * (to see the precise effective timeslice length of your workload,
> >  *  run vmstat and monitor the context-switches field)
> > ..."
> > 
> > So, no notion of something, which are(!) of variable length, and which 
> > precise effective timeslice lenght can be seen in nanoseconds? (But 
> > not timeslice!)
> 
> You should really read and understand the code you are arguing about :-/

Maybe you could help me with better comments? IMHO, it would be enough
to warn new timeslices have different meaning, or stop to use this
term at all. (Btw, in -rc8-mm2 I see new sched_slice() function which
seems to return... time.)

> 
> In the 2.6.22 scheduler, there was a p->time_slice per task variable 
> that could be manipulated. (Note, in 2.6.22's sched_yield() did not 
> manipulate p->time_slice.)
> 
> sysctl_sched_latency on the other hand is not something that is per task 
> (it is global) so there is no pending timeslice to be "cleared" as it 
> has been suggested naively.

But, there is this "something", very similar and very misleading, you
count eg. in check_preempt_curr_fair to find if time is over, and I
think this could be similar enough to what David Schwartz wanted to
use in his idea, and you didn't care to explain why it's so different?

Jarek P.

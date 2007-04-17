Return-Path: <linux-kernel-owner+w=401wt.eu-S1031085AbXDQEfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031085AbXDQEfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031086AbXDQEfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:35:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:35011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031085AbXDQEfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:35:21 -0400
Date: Tue, 17 Apr 2007 06:34:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417043456.GH25513@wotan.suse.de>
References: <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com> <20070417035528.GE25513@wotan.suse.de> <46244C43.8000607@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46244C43.8000607@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 02:25:39PM +1000, Peter Williams wrote:
> Nick Piggin wrote:
> >On Mon, Apr 16, 2007 at 04:10:59PM -0700, Michael K. Edwards wrote:
> >>On 4/16/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
> >>>Note that I talk of run queues
> >>>not CPUs as I think a shift to multiple CPUs per run queue may be a good
> >>>idea.
> >>This observation of Peter's is the best thing to come out of this
> >>whole foofaraw.  Looking at what's happening in CPU-land, I think it's
> >>going to be necessary, within a couple of years, to replace the whole
> >>idea of "CPU scheduling" with "run queue scheduling" across a complex,
> >>possibly dynamic mix of CPU-ish resources.  Ergo, there's not much
> >>point in churning the mainline scheduler through a design that isn't
> >>significantly more flexible than any of those now under discussion.
> >
> >Why? If you do that, then your load balancer just becomes less flexible
> >because it is harder to have tasks run on one or the other.
> >
> >You can have single-runqueue-per-domain behaviour (or close to) just by
> >relaxing all restrictions on idle load balancing within that domain. It
> >is harder to go the other way and place any per-cpu affinity or
> >restirctions with multiple cpus on a single runqueue.
> 
> Allowing N (where N can be one or greater) CPUs per run queue actually 
> increases flexibility as you can still set N to 1 to get the current 
> behaviour.

But you add extra code for that on top of what we have, and are also
prevented from making per-cpu assumptions.

And you can get N CPUs per runqueue behaviour by having them in a domain
with no restrictions on idle balancing. So where does your increased
flexibilty come from?

> One advantage of allowing multiple CPUs per run queue would be at the 
> smaller end of the system scale i.e. a PC with a single hyper threading 
> chip (i.e. 2 CPUs) would not need to worry about load balancing at all 
> if both CPUs used the one runqueue and all the nasty side effects that 
> come with hyper threading would be minimized at the same time.

I don't know about that -- the current load balancer already minimises
the nasty multi threading effects. SMT is very important for IBM's chips
for example, and they've never had any problem with that side of it
since it was introduced and bugs ironed out (at least, none that I've
heard).



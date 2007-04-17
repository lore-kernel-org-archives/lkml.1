Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXDQGXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXDQGXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXDQGXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:23:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:49591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbXDQGXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:23:16 -0400
Date: Tue, 17 Apr 2007 08:23:06 +0200
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
Message-ID: <20070417062306.GD1057@wotan.suse.de>
References: <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com> <20070417035528.GE25513@wotan.suse.de> <46244C43.8000607@bigpond.net.au> <20070417043456.GH25513@wotan.suse.de> <4624633D.4080005@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624633D.4080005@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 04:03:41PM +1000, Peter Williams wrote:
> Nick Piggin wrote:
> >
> >But you add extra code for that on top of what we have, and are also
> >prevented from making per-cpu assumptions.
> >
> >And you can get N CPUs per runqueue behaviour by having them in a domain
> >with no restrictions on idle balancing. So where does your increased
> >flexibilty come from?
> >
> >>One advantage of allowing multiple CPUs per run queue would be at the 
> >>smaller end of the system scale i.e. a PC with a single hyper threading 
> >>chip (i.e. 2 CPUs) would not need to worry about load balancing at all 
> >>if both CPUs used the one runqueue and all the nasty side effects that 
> >>come with hyper threading would be minimized at the same time.
> >
> >I don't know about that -- the current load balancer already minimises
> >the nasty multi threading effects. SMT is very important for IBM's chips
> >for example, and they've never had any problem with that side of it
> >since it was introduced and bugs ironed out (at least, none that I've
> >heard).
> >
> 
> There's a lot of ugly code in the load balancer that is only there to 
> overcome the side effects of SMT and dual core.  A lot of it was put 
> there by Intel employees trying to make load balancing more friendly to 

I agree that some of that has exploded complexity. I have some
thoughts about better approaches for some of those things, but
basically been stuck working on VM problems for a while.


> their systems.  What I'm suggesting is that an N CPUs per runqueue is a 
> better way of achieving that end.  I may (of course) be wrong but I 
> think that the idea deserves more consideration than you're willing to 
> give it.

Put it this way: it is trivial to group the load balancing stats
of N CPUs with their own runqueues. Just put them under a domain
and take the sum. The domain essentially takes on the same function
as a single queue with N CPUs under it. Anything _further_ you can
do with individual runqueues (like naturally adding an affinity
pressure ranging from nothing to absolute) are things that you
don't trivially get with 1:N approach. AFAIKS.

So I will definitely give any idea consideration, but I just need to
be shown where the benefit comes from.


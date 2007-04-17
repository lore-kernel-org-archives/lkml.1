Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXDQIZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXDQIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXDQIZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:25:57 -0400
Received: from holomorphy.com ([66.93.40.71]:43040 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXDQIZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:25:56 -0400
Date: Tue, 17 Apr 2007 01:24:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417082417.GT8915@holomorphy.com>
References: <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415233909.GE2986@holomorphy.com> <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com> <20070417035528.GE25513@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417035528.GE25513@wotan.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 04:10:59PM -0700, Michael K. Edwards wrote:
>> This observation of Peter's is the best thing to come out of this
>> whole foofaraw.  Looking at what's happening in CPU-land, I think it's
>> going to be necessary, within a couple of years, to replace the whole
>> idea of "CPU scheduling" with "run queue scheduling" across a complex,
>> possibly dynamic mix of CPU-ish resources.  Ergo, there's not much
>> point in churning the mainline scheduler through a design that isn't
>> significantly more flexible than any of those now under discussion.

On Tue, Apr 17, 2007 at 05:55:28AM +0200, Nick Piggin wrote:
> Why? If you do that, then your load balancer just becomes less flexible
> because it is harder to have tasks run on one or the other.

On Tue, Apr 17, 2007 at 05:55:28AM +0200, Nick Piggin wrote:
> You can have single-runqueue-per-domain behaviour (or close to) just by
> relaxing all restrictions on idle load balancing within that domain. It
> is harder to go the other way and place any per-cpu affinity or
> restirctions with multiple cpus on a single runqueue.

The big sticking point here is order-sensitivity. One can point to
stringent sched_yield() ordering but that's not so important in and of
itself. The more significant case is RT applications which are order-
sensitive. Per-cpu runqueues rather significantly disturb the ordering
requirements of applications that care about it.

In terms of a plugging framework, the per-cpu arrangement precludes or
makes extremely awkward scheduling policies that don't have per-cpu
runqueues, for instance, the 2.4.x policy. There is also the alternate
SMP scalability strategy of a lockless scheduler with a single global
queue, which is more performance-oriented.


-- wli

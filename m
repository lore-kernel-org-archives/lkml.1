Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYDTUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYDTUns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYDTUnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:43:40 -0400
Received: from smtp.enter.net ([216.193.128.24]:2393 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYDTUnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:43:39 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86: 4kstacks default
Date: Sun, 20 Apr 2008 16:43:34 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080420114845.77bf3fed@laptopd505.fenrus.org> <480BA12A.4000307@firstfloor.org>
In-Reply-To: <480BA12A.4000307@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201643.35830.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 16:01:46 Andi Kleen wrote:
> > These are real customer workloads; java based "many things going on" at a
> > time showed several thousands of threads fin the system (a dozen or two
> > per request, multiplied by the number of outstanding connections) for
> > *real customers*.
>
> Several thousands or 50k? Several thousands sounds large, but not entirely
> unreasonable, but it is far from 50k.
>

At 12 threads per request it'd only take about 4200 outstanding requests. That 
is high, but I can see it happening. At 24 threads per request the number of 
outstanding requests it takes to reach that is cut in half, to about 2100. 
That number is more realistic. Since all outstanding requests aren't going to 
be at the extremes, let us assume that it's a mid-point between the two for 
the number of outstanding requests - say somewhere around 3150 outstanding 
requests.

While that is a rather high number, if a company - a decently sized one - is 
using a piece of Java code internally for some reason they could easily have 
that level of requests coming in from the users. For a website with a decent 
load that routes a common request to the machine running the code it'd be 
even easier to hit that limit. So yes, 50K threads *IS* actually pretty easy 
to reach and could be a common workload.

> > That you don't take that serious, fair, you can take serious whatever you
> > want.
>
> No I don't take 50k threads on 32bit serious. And I hope you do not
> either.

Just makes you sound foolish. Run the numbers yourself and you'll see that it 
is easy for a machine running highly threaded code to easily hit 50K threads.

<snip>
> > Yes 2.4 sucked a lot more than 2.6 does. But even 2.6 will (and does)
> > have fragmentation issues. We don't have effective physical address based
> > reclaim yet for higher order allocs.
>
> I don't see any evidence that there are serious order 1 fragmentation
> issues on 2.6. If you have any please post it.

Due to me screwing up the configuration of Apache (2) and MySQL I have seen a 
machine I own hit problems with memory fragmentation - and it's running a 2.6 
series kernel (a distro 2.6.17)

Because I was able to see that it was a problem I caused I didn't even *THINK* 
about posting information about it to LKML. I didn't keep the logs of that 
around - it happened more than three months ago and I clean the logs out 
every three months or so.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

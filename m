Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbXGTPEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbXGTPEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765392AbXGTPEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:04:32 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1886 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764961AbXGTPEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:04:31 -0400
Date: Fri, 20 Jul 2007 17:03:37 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070718160251.GA29043@elte.hu>
Message-ID: <Pine.LNX.4.64.0707201551410.1817@scrub.home>
References: <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
 <1184754430.20032.130.camel@twins> <Pine.LNX.4.64.0707181442340.1817@scrub.home>
 <1184763148.20032.135.camel@twins> <Pine.LNX.4.64.0707181506460.1817@scrub.home>
 <20070718134811.GA9227@elte.hu> <Pine.LNX.4.64.0707181558590.1817@scrub.home>
 <20070718160251.GA29043@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 18 Jul 2007, Ingo Molnar wrote:

> > Why do you constantly stress level 19? Yes, that one is special, all 
> > other positive levels were already relatively consistent.
> 
> i constantly stress it for the reason i mentioned a good number of 
> times: because it's by far the most commonly used (and complained about) 
> nice level. =B-)

How do you know that? Most complained about makes most commonly used?

> but because you are asking, i'm glad to give you some first-hand 
> historic background about Linux nice levels (in case you are interested) 
> and the motivations behind their old and new implementations:

I guess I should be thankful now?
I'm curious why you post this now, after I "asked" about this. Most of the 
information is either rather generic or not specific enough for the 
problem at hand. If you had posted this information earlier, it had been 
far more valueable as it could have been a nice base for a discussion.
But posting it this late I can't lose the feeling you're more interested 
in "teaching" me.

> nice levels were always so weak under Linux (just read Peter's report) 

-ENOLINK

> Hope this helps,

Not completely.

For negative nice levels you mentioned audio apps, but these aren't really 
interested in a fair share, they would use the higher percentage only to 
guarantee they get the amount of time they need independent of the 
current load. I think they would be better served with e.g. a deadline 
scheduler, which guarantees them an absolute time share not a relative 
one.
On the other end with positive levels I more remember requests for 
something closer to idle scheduling, where a process only runs when 
nothing else is running.

So assuming we had scheduling classes for the above use cases, what other 
reasons are left for such extreme nice levels?

My proposed nice levels have otherwise the same properties as yours (e.g. 
being consistent). There is one propery you haven't commented on at all 
yet. My proposed levels give the average use a far better idea what they 
actually mean, i.e. that every 5 levels the process gets double/halve the 
cpu time. This is IMO a considerable advantage.

bye, Roman

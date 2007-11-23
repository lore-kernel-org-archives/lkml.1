Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbXKWNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbXKWNKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 08:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXKWNKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 08:10:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbXKWNKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 08:10:19 -0500
Date: Fri, 23 Nov 2007 14:09:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071123130952.GA6320@elte.hu>
References: <47425EA5.7000607@rtr.ca> <200711210243.46944.nickpiggin@yahoo.com.au> <20071120110726.4cc2995e@laptopd505.fenrus.org> <200711221854.15516.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711221854.15516.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Ahh, hate to get off topic, but let's not perpetuate this myth. It 
> wasn't Con, or CFS, or anything that showed fairness is some great new 
> idea. Actually I was arguing for fairness first, against both Con and 
> Ingo, way back when the old scheduler was having so much problems.
> 
> Not that I am trying to claim the idea for myself. Fairness is like 
> the most fundamental and obvious behaviour for any sort of resource 
> scheduler that I have to laugh when people get "credited" with this 
> idea.

just out of curiosity (and to get my own sense of history corrected), do 
you remember in which thread you said that? (and even better, could you 
dig out any URLs for that thread?)

btw., the question was never really whether fairness was a good idea for 
a resource scheduler - the question was whether _strict fairness_ was a 
good idea for a general purpose OS (and the desktop in particular). My 
point back then was that strict fairness is not good enough and that we 
thus need the interactivity estimator - and i still maintain the first 
half of that position while conceding that i was wrong about the second 
part :-)

I dont think anyone was arguing for a scheduler with no fairness at all 
- but "fairness" indeed was more of an after-thought, not the driving 
principle.

Current CFS uses a modified "sleeper fairness" model (not a strict 
fairness model) via which we in essence replace the effect of the 
interactivity estimator with "sleeper fairness". So in essence we've 
replaced the O(1) scheduler's sleep average code with a deterministic 
sleep average code. This in turn also made the allocation of CPU time 
deterministic throughout. (which in other words can also be called "fair 
allocation of CPU time")

_That_ scheme seems to behave rather well in practice and i think i can 
take credit for _that_ bit ;-) [many people have hacked upon that 
concept and code since then so it's nowhere near "my code" anymore, of 
course.]

	Ingo

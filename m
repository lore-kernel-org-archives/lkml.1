Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXFVWQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXFVWQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXFVWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:16:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbXFVWQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:16:38 -0400
Date: Sat, 23 Jun 2007 00:15:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622221529.GA27445@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <1182549202.3228.78.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182549202.3228.78.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> >  - tasklets have certain fairness limitations. (they are executed in
> >    softirq context and thus preempt everything, even if there is 
> >    some potentially more important, high-priority task waiting to be 
> >    executed.)
> 
> Since -rt has been executing tasklets in process context for a long 
> time, I'm not sure this change would cause to many regressions. 
> However, it seems like implicit dependencies on "tasklets preempt 
> everything" might crop up. The other issue is if they don't "preempt 
> everything" (most of the time), what default priority do we give them 
> (all of the time)? [...]

there is no such guarantee at all (of 'instant preemption'), even with 
current, softirq-based tasklets. A tasklet might be 'stolen' by another 
CPU. It might be delayed to the next timer tick (or other softirq 
execution). Or it might be delayed into a ksoftirqd context, which 
currently runs at nice +19. So your worry of implicit execution 
dependencies is unfounded, because, if they existed, they would be bad 
(and triggerable) bugs today too.

	Ingo

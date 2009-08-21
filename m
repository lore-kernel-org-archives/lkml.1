Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZHUOpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZHUOpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZHUOpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:45:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbZHUOpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:45:01 -0400
Date: Fri, 21 Aug 2009 16:44:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, hugh.dickins@tiscali.co.uk,
       benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090821144416.GA16810@elte.hu>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com> <20090817192036.GJ6760@linux.vnet.ibm.com> <20090818152643.GA5549@elte.hu> <20090820140335.GA31773@Krystal> <20090821141721.GA11098@elte.hu> <alpine.DEB.2.00.0908211022090.16405@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908211022090.16405@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 21 Aug 2009, Ingo Molnar wrote:
> 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > I would not trust this architecture for synchronization tests. 
> > > There has been reports of a hardware bug affecting the cmpxchg 
> > > instruction in the field. The load fence normally implied by 
> > > the semantic seems to be missing. AFAIK, AMD never 
> > > acknowledged the problem.
> > 
> > If cmpxchg was broken i'd be having far worse problems and very 
> > widely so.
> 
> I believe Mathieu is suggesting that the hardware bug is not that 
> the compare and exchange does not work in cmpxchg, but that it 
> does not provide an explicit memory barrier. Such a bug is very 
> hard to trigger, since it requires a race that allows a memory 
> write/read to cross the cmpxchg, and then have this be in such a 
> place that it will cause harm.

We can argue all sorts of exotic hardware bugs really, proof is 
still needed.

[...]
> > That's not a proof of course (it's near impossible to prove the 
> > lack of a bug), but it's sure a strong indicator and you'll need 
> > to provide far more proof of misbehavior before i discount a 
> > bona fide regression on this box.
> 
> But with the above said, I totally agree with your point. More 
> proof must be given before we can discount that another bug 
> exists.

Yeah. Especially given that this code was changed recently ;-)

	Ingo

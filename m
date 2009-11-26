Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZKZTUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZKZTUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZKZTUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:20:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45156 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZKZTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:20:22 -0500
Date: Thu, 26 Nov 2009 20:20:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
Message-ID: <20091126192019.GA11245@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
 <1259224390.21397.87.camel@gandalf.stny.rr.com>
 <20091126084039.GA15919@elte.hu>
 <1259246730.21397.97.camel@gandalf.stny.rr.com>
 <20091126175548.GC4997@nowhere>
 <20091126181205.GA18670@elte.hu>
 <1259262740.21397.121.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259262740.21397.121.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> (added Christoph since he was the one to recommend the template 
> creation)
>
> On Thu, 2009-11-26 at 19:12 +0100, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > DECLARE_EVENT_CLASS() doesnt really define an event visible to the user 
> > yet though. It defines functions internally (to be used by the real 
> > definition of the event) - but not visible externally really.
> > 
> > So the real 'definition' of an event happens with DEFINE_EVENT() - in 
> > the logical model of this.
> > 
> > So the logical model is clear:
> > 
> >    DECLARE_EVENT_CLASS(class);
> > 
> >     DEFINE_EVENT(class, event1);
> >     DEFINE_EVENT(class, event2);
> >     DEFINE_EVENT(class, event3);
> >     ...
> > 
> >   # later:
> >   # DEFINE_STANDALONE_EVENT(event)
> 
> I think that name sounds even uglier than DEFINE_SINGLE_EVENT :-/
>
> I'm fine with the DECLARE_EVENT_CLASS and DEFINE_EVENT, but I'm unsure 
> what to rename TRACE_EVENT as. I know its still pretty new, but it's 
> being used quite a bit. So it should take some extra thought.
> 
> I guess DEFINE_EVENT_CLASS is probably not good, although this would 
> be the combination of DECLARE_EVENT_CLASS and DEFINE_EVENT which it 
> actually is.
> 
> DECLARE_DEFINE_EVENT?  *naw*
> 
> DEFINE_DECLARED_EVENT?
> 
> Or we could go with DECLARE_EVENT(), DECLARE_EVENT_CLASS() and 
> DEFINE_EVENT_CLASS_INSTANCE()?

I think the most common one should be the shortest, and the most common 
one will be DEFINE_EVENT() - that's short enough already IMO.

I think we generally want to encourage the creation of classes of 
events, not myriads of standalone events, each with their own call 
signature, record format and printouts.

In that sense making the TRACE_EVENT() one longer would achieve that 
goal of discouraging its over-use: DEFINE_SINGLE_EVENT() tells the 
developer that it's an event of it's kind.

	Ingo

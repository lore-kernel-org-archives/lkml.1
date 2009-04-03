Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbZDCQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbZDCQdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764152AbZDCQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:32:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764155AbZDCQc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:32:57 -0400
Date: Fri, 3 Apr 2009 18:32:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf_counter: request for three more sample data options
Message-ID: <20090403163248.GA21669@elte.hu>
References: <49D56A7E.80908@linux.vnet.ibm.com> <1238742064.798.8.camel@twins> <49D5B9E7.1020400@linux.vnet.ibm.com> <1238745077.798.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238745077.798.17.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-04-03 at 00:25 -0700, Corey Ashford wrote:
> 
> > >> I am guessing the only difficult thing here would be obtaining the 
> > >> current time from an IRQ, especially NMI handler.  Is this difficult?
> > > 
> > > Yes, quite :-) I'll have to see what we can do there -- we could do a
> > > best effort thing with little to no guarantees I think.
> > > 
> > 
> > Best effort would be fine, I think.  I would assume that means 
> > that 99.9% of the time, you'll get a correct timestamp, and the 
> > rest are rubbish?  Or would there be a way to detect when you're 
> > not able to give a correct timestamp and in that case replace 
> > the timestamp field with a special sentinel, like all hex f's?
> 
> What I was thinking of was re-using some of the cpu_clock() 
> infrastructure. That provides us with a jiffy based GTOD sample, 
> cpu_clock() then uses TSC and a few filters to compute a current 
> timestamp.
> 
> I was thinking about cutting back those filters and thus trusting 
> the TSC more -- which on x86 can do any random odd thing. So 
> provided the TSC is not doing funny the results will be ok-ish.
> 
> This does mean however, that its not possible to know when its 
> gone bad.

Note that on latest mainline and on Nehalem CPUs that filter is 
being cut back already. So there's an opt-in mechanism to trust 
sched_clock() some more.

> Also, cpu_clock() can only provide monotonicity per-cpu, if a 
> value read on one cpu is compared to a value read on another cpu, 
> there can be a drift of at most 1-2 jiffies.

That should be a good start i think. If it causes any measurable 
jitter then the performance monitoring community is probably going 
to be the first one to notice! ;-) So there's good synergy IMO.

	Ingo

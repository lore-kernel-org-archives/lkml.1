Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZFWOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZFWOGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZFWOGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:06:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZFWOGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:06:04 -0400
Date: Tue, 23 Jun 2009 16:05:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rob Fowler <rjf@renci.org>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] IV.3 - AMD IBS
Message-ID: <20090623140538.GA10451@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622120018.GR24366@elte.hu> <4A3F9062.6000303@renci.org> <1245737987.19816.1477.camel@twins> <7c86c4470906230119g6df76304xbec11dc682176b09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906230119g6df76304xbec11dc682176b09@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> > The most natural way to support IBS would be to have a special 
> > sampling cycle counter and use that as group lead and add non 
> > sampling siblings to that group to get individual elements.
> >
> As discussed in my message, I think the way to support IBS is to 
> create two pseudo-events (like your perf_hw_event_ids), one for 
> fetch and one for op (because they could be measured 
> simultaneously). The sample_period field would be used to express 
> the IBS*CTL maxcnt, subject to the verification that the bottom 4 
> bits must be 0. And then, you add two new sampling formats 
> PERF_SAMPLE_IBSFETCH, PERF_SAMPLE_IBSOP. Those would only work 
> with IBS pseudo events. Once you have the randomize option in 
> perf_counter_attr, you could even enable IBSFETCH randomization.

I'd suggest to start smaller, and first express the 'precise' nature 
of IBS transparently, by simply mapping it to one of the generic 
events. (cycles and instructions both appears to be possible)

No extra sampling, no extra events - just a transparent side channel 
implementation for the specific case of PERF_COUNT_HW_CPU_CYCLES. (A 
bit like the fixed-purpose counters are done on the Intel side - a 
special-case - but none of the generic code knows about it.)

This gives us immediate results with less code, and also gives us 
the platform to see how IBS is structured, what kind of general 
problems/quirks it has, and how popular its precision is, etc. We 
can always add extra sampling formats on top of that (i'm not 
opposed to that), to expose more and more of IBS.

The same can be done on the PEBS side as well.

Would you be interested in pursuing this?

	Ingo

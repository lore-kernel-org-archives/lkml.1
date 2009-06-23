Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZFWOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZFWOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZFWOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:55:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZFWOz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:55:28 -0400
Date: Tue, 23 Jun 2009 16:55:08 +0200
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
Message-ID: <20090623145508.GC13415@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622120018.GR24366@elte.hu> <4A3F9062.6000303@renci.org> <1245737987.19816.1477.camel@twins> <7c86c4470906230119g6df76304xbec11dc682176b09@mail.gmail.com> <20090623140538.GA10451@elte.hu> <7c86c4470906230725t2d86cd2eybabeba454f3aff81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906230725t2d86cd2eybabeba454f3aff81@mail.gmail.com>
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

> On Tue, Jun 23, 2009 at 4:05 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >
> > * stephane eranian <eranian@googlemail.com> wrote:
> >
> >> > The most natural way to support IBS would be to have a special
> >> > sampling cycle counter and use that as group lead and add non
> >> > sampling siblings to that group to get individual elements.
> >> >
> >> As discussed in my message, I think the way to support IBS is to
> >> create two pseudo-events (like your perf_hw_event_ids), one for
> >> fetch and one for op (because they could be measured
> >> simultaneously). The sample_period field would be used to express
> >> the IBS*CTL maxcnt, subject to the verification that the bottom 4
> >> bits must be 0. And then, you add two new sampling formats
> >> PERF_SAMPLE_IBSFETCH, PERF_SAMPLE_IBSOP. Those would only work
> >> with IBS pseudo events. Once you have the randomize option in
> >> perf_counter_attr, you could even enable IBSFETCH randomization.
> >
> > I'd suggest to start smaller, and first express the 'precise' 
> > nature of IBS transparently, by simply mapping it to one of the 
> > generic events. (cycles and instructions both appears to be 
> > possible)
>
> IBS is precise by nature.

(yes. Did you understand my comments above as saying the opposite?)

> [...] It does not work like PEBS. It tags an instruction and then 
> collects info about it. When it retires, IBS freezes and triggers 
> an interrupt like a regular counter interrupt. Except this time, 
> you don't care about the interrupted IP, you use the instruction 
> address in the IBS data register, it is guaranteed to correspond 
> to the tagged instruction.
> 
> The sampling period expresses the delay before picking the 
> instruction to tag. And as I said before, it is only 20 bits and 
> the bottom 4 bits must be zero (as they cannot be encoded).

The 20 bits delay is in cycles, right? So this in itself still lends 
itself to be transparently provided as a PERF_COUNT_HW_CPU_CYCLES 
counter.

	Ingo

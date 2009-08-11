Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZHKNMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZHKNMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZHKNMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:12:45 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55084 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZHKNMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:12:44 -0400
Date: Tue, 11 Aug 2009 13:06:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] cache-miss and cache-refs events on P6-mobile CPUs
Message-ID: <20090811110627.GA31136@elte.hu>
References: <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu> <20090810203706.GA17338@sig21.net> <20090810213133.GB16944@elte.hu> <20090810221307.GA19236@sig21.net> <20090811093405.GA13004@elte.hu> <1249983579.17467.156.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249983579.17467.156.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-08-11 at 11:34 +0200, Ingo Molnar wrote:
> 
> > @@ -116,8 +116,8 @@ static const u64 p6_perfmon_event_map[] 
> >  {
> >    [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
> >    [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
> > -  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
> > -  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
> > +  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
> > +  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
> 
> 2e is total numer of L2 events,
> 
> 0f is all mesi states
> 01 is invalid states

here's Intel's own description:

 I_STATE 0x01 Counts how many times requests miss the cache.
 MESI    0x0F Counts how many times cache lines in any state are accessed.

so it's pretty close in practice. The only counts that are a bit 
inapplicable are fetches/prefetches it initiates on its own (they 
are included here) - but those too are related to the workload in 
general, so it's good as an approximation.

It's definitely better than 0x00 IMO. What do you think?

	Ingo

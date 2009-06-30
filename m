Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZF3J6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZF3J6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZF3J55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:57:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZF3J54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:57:56 -0400
Date: Tue, 30 Jun 2009 11:57:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
	multiple events in one shot
Message-ID: <20090630095738.GD6942@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam> <1246051927.2988.10.camel@hpdv5.satnam> <1246051996.2988.12.camel@hpdv5.satnam> <20090627163821.GA17638@elte.hu> <1246129498.32198.27.camel@hpdv5.satnam> <20090628132926.GD31988@elte.hu> <1246202166.2982.8.camel@hpdv5.satnam> <20090629035708.GD8059@elte.hu> <1246351114.2476.38.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246351114.2476.38.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Mon, 2009-06-29 at 05:57 +0200, Ingo Molnar wrote:
> 
> > The above patterns i suggested _already cover_ 'multiple events'.
> > 
> > We might define further aliases like:
> > 
> > 	all := "*"
> >         all-sw := "sw-*"
> > 
> > but it should all be in terms of patterns and regular 
> > expressions, not via some hardcoded special-case thing as your 
> > posted patches did.
> > 
> 
> It seems to me very confusing and needs lot of book-keeping and 
> need to rewrite whole tools/perf/util/parse-events.c because :
> 
> * means all perf_event_types :
> 	PERF_TYPE_HARDWARE,
>         PERF_TYPE_SOFTWARE,
>         PERF_TYPE_TRACEPOINT,
>         PERF_TYPE_HW_CACHE,
>         PERF_TYPE_RAW
> 
> hw-* means all hardware events :
> 	PERF_TYPE_HARDWARE,
>         PERF_TYPE_HW_CACHE,
>         PERF_TYPE_RAW
> 
> sw-* means all software events :
>         PERF_TYPE_SOFTWARE,
>         PERF_TYPE_TRACEPOINT
> 
> *cache* means all cache based events :
> 	PERF_COUNT_CACHE_REFERENCES, 	/* Generalized H/W */
> 	PERF_COUNT_CACHE_MISSES,	/* Generalized H/W */
>         PERF_TYPE_HW_CACHE,		/* Generalized Cache */
> 
> *write* means all write based events :
> 	(L1D,       WRITE,          ACCESS),
> 	(L1D,       WRITE,          MISS),
> 	(LL,        WRITE,          ACCESS),
> 	(LL,        WRITE,          MISS),
> 	(DTLB,      WRITE,          ACCESS),
> 	(DTLB,      WRITE,          MISS)
> 
> Please let me know why it looks complex to me, is it really 
> complex or I am going in wrong direction.

It would certainly need some reorganization of the code but the end 
result would be more flexible and other places could use it too, for 
example:

	perf test -e hw-*

would test all (known) hardware counters.

	Ingo

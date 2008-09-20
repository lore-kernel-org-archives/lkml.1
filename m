Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYITGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYITGRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYITGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 02:17:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYITGRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 02:17:11 -0400
Date: Sat, 20 Sep 2008 08:16:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-ID: <20080920061659.GF25713@elte.hu>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net> <20080919142326.29834d11.akpm@linux-foundation.org> <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> On Fri, Sep 19, 2008 at 2:23 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 19 Sep 2008 03:06:43 -0700
> > Steven Noonan <steven@uplinklabs.net> wrote:
> >
> >> --- a/kernel/trace/trace.h
> >> +++ b/kernel/trace/trace.h
> >> @@ -339,6 +339,10 @@ extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
> >>  extern int trace_selftest_startup_wakeup(struct tracer *trace,
> >>                                        struct trace_array *tr);
> >>  #endif
> >> +#ifdef CONFIG_NOP_TRACER
> >> +extern int trace_selftest_startup_nop(struct tracer *trace,
> >> +                                      struct trace_array *tr);
> >> +#endif
> >>  #ifdef CONFIG_CONTEXT_SWITCH_TRACER
> >>  extern int trace_selftest_startup_sched_switch(struct tracer *trace,
> >>                                              struct trace_array *tr);
> >
> > Consider omitting the ifdefs around the declarations.
> >
> > pro: the code looks nicer and is less likely to suffer build errors
> > with weird config combinations.
> >
> > con: build errors are reported at link-time rather than at compile-time.
> >
> > Personally, I think pro>con here.
> >
> 
> I merely based this on one of the other tracers, so the ifdefs are
> basically copied and renamed.

yeah. Feel free to send a separate patch that implements Andrew's 
clean-up suggestion. I agree that pro>con.

	Ingo

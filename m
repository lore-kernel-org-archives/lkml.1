Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYISIvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYISIvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYISIv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:51:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYISIv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:51:26 -0400
Date: Fri, 19 Sep 2008 10:51:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080919085105.GG17592@elte.hu>
References: <20080918220102.GE7408@tesla> <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919081733.GC19491@elte.hu> <f488382f0809190122k1b30cd9q22fd076c1e3eaa18@mail.gmail.com> <f488382f0809190145s1b5407d4s9d97ae594bcc3379@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0809190145s1b5407d4s9d97ae594bcc3379@mail.gmail.com>
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

> On Fri, Sep 19, 2008 at 1:22 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> > On Fri, Sep 19, 2008 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> in tip/master there's an ftrace_printk() facility. You can just replace
> >> the verbose printk()s with ftrace_printk() and see the result in
> >> /debug/tracing/trace.
> >>
> >> This sort of tracing has very low overhead and can be used in an easy
> >> ad-hoc manner with no extra infrastructure. Here's a few quick-start
> >> links about how to enable the scheduler tracer:
> >>
> >>  http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt
> >>  http://redhat.com/~mingo/sched-devel.git/howto-trace-latencies.txt
> >>
> >> any ftrace_printk() you add in the kernel will show up in that trace.
> >>
> >> (If the scheduling events are uninteresting and clutter the output then
> >> you might want to remove the scheduler tracing entries from kernel/*.c
> >> by removing the trace_sched_*() calls or use a less noisy tracer.)
> >>
> >> to get enough of a trace history you might want to increase the number
> >> of trace entries in /debug/tracing/trace_entries from 16K to 128K or so.
> >>
> >
> > Thanks for the suggestion, I'll do that. :)
> >
> 
> It'd be extremely convenient to have a tracer that did absolutely 
> nothing but display ftrace_printk()s.

yeah, had the same thought.

Could you please contribute one? :) I'd suggest you take the smallest 
tracer as a template: trace_sched_switch.c and turn that into 
trace_nop.c - and change all the function names and ASCII and kconfig 
glue to 'nop'/'NOP'?

That can then be used as a basis for additional ftrace plugins, or for 
ad-hoc temporary tracing.

	Ingo

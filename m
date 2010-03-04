Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0CDPB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:01:28 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:58702 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab0CDPB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:01:26 -0500
X-Greylist: delayed 2984 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 10:01:26 EST
Date: Thu, 4 Mar 2010 12:25:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace events
Message-ID: <20100304112531.GF21977@elte.hu>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
 <1267632387.10871.59.camel@gandalf.stny.rr.com>
 <1267634258.25158.88.camel@laptop>
 <1267636046.10871.74.camel@gandalf.stny.rr.com>
 <1267636595.25158.93.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267636595.25158.93.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-03-03 at 12:07 -0500, Steven Rostedt wrote:
> > oops, my bad :-), I thought this was in the x86 arch directory. For the
> > University, I was helping them with adding trace points for page faults
> > when I came across this in arch/x86/mm/fault.c:
> > 
> >         perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
> > 
> > 
> > This is what I actually was wondering about. Why is it a "perf only" trace 
> > point instead of a TRACE_EVENT()?
> 
> Because I wanted to make perf usable without having to rely on funny 
> tracepoints. That is, I am less worried about committing software counters 
> to ABI than I am about TRACE_EVENT(), which still gives me a terribly 
> uncomfortable feeling.

I'd still like a much less error-prone and work-intense way of doing it.

I'd suggest we simply add a TRACE_EVENT_ABI() for such cases, where we really 
want to expose a tracepoint to tooling, programmatically. Maybe even change 
the usage sites to trace_foo_ABI(), to make it really clear and to make people 
aware of the consequences.

> Also, building with all CONFIG_TRACE_*=n will still yield a usable perf, 
> which is something the embedded people might fancy, all that TRACE stuff 
> adds lots of code.

Not a real issue i suspect when you do lock profiling ...

Or if it is, some debloating might be in order - and the detaching of event 
enumeration and ftrace TRACE_EVENT infrastructure from other ftrace bits. (i 
suggested an '/eventfs' special filesystem before, for nicely layed out 
hierarchy of ftrace/perf events.)

Thanks,

	Ingo

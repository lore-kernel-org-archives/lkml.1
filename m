Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbZLJOLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbZLJOLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZLJOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:11:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbZLJOLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:11:34 -0500
Date: Thu, 10 Dec 2009 15:11:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210141121.GB1436@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210120332.GA5042@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Dec 10, 2009 at 08:08:00AM +0100, Ingo Molnar wrote:
> > 
> > * Tim Bird <tim.bird@am.sony.com> wrote:
> > 
> > > Add function duration tracer.
> > > 
> > > Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> > > ---
> > >  kernel/trace/Kconfig          |    8
> > >  kernel/trace/Makefile         |    1
> > >  kernel/trace/trace.c          |   32 ++
> > >  kernel/trace/trace_duration.c |  527 ++++++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 568 insertions(+)
> > 
> > Please do it in a cleaner an more generic fashion: add a "function 
> > event" that perf can see and process, so all the output embellishment 
> > can be done outside of the kernel, in tools/perf/.
> > 
> > We want to wind down the current maze of ftrace plugins, not extend 
> > them. We already obsoleted the following ftrace plugins: scheduler, 
> > sysprof, blktrace, kmem, scheduler, etc. There's more work ongoing and 
> > broad agreement between folks developing it that this is the way 
> > forward.
> > 
> > The function tracer / function graph tracer is a holdout due to its 
> > complexity - but that by no means weakens the argument and the necessity 
> > to migrate it.
> > 
> > ftrace plugins were a nice idea originally and a clear improvement over 
> > existing alternatives, but now that we've got a technicaly superior, 
> > unified event framework that can do what the old plugins did and much 
> > more, we want to improve that and not look back ...
> 
> 
> I agree. If we can abstract it out in a struct trace_event rather than 
> a struct tracer, then please try. I doubt we can't.
> 
> The trace events are more unified.
> 
> This makes me feel I'm going to try converting the function graph 
> tracer into an event during the next cycle. [...]

Great!

> [...] It does not mean I could make it usable as a perf event right 
> away in the same shot that said, as you can guess this is not a 
> trivial plug. The current perf fast path is not yet adapted for that.

Yeah, definitely so. I'd guess it would be slower out of box - it hasnt 
gone through nearly as many refinements yet.

> But at least this will be a good step forward.

Yeah.

Also, i'd suggest we call unified events 'ftrace events', as that is 
what they really are: the whole TRACE_EVENT() infrastructure is the 
crown jewel of ftrace and IMO it worked out pretty well.

I hope there wont be any significant culture clash between ftrace and 
perf - we want a single, unified piece of instrumentation 
infrastructure, we want to keep the best of both worlds, and want to 
eliminate any weaknesses and duplications. As long as we keep all that 
in mind it will be all fine.

	Ingo

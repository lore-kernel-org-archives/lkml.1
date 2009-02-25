Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbZBYP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbZBYP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZBYP6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:58:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZBYP6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:58:00 -0500
Date: Wed, 25 Feb 2009 16:57:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225155709.GA12732@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <alpine.DEB.2.00.0902250923360.12697@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902250923360.12697@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > #                _------=> CPU#
> > #               / _-----=> irqs-off
> > #              | / _----=> need-resched
> > #              || / _---=> hardirq/softirq
> > #              ||| / _--=> preempt-depth
> > #              |||| /
> > #              |||||     delay
> > #  cmd     pid ||||| time  |   caller
> > #     \   /    |||||   \   |   /
> >   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> >   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> >   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
[...]
> > 
> > your time starts now.
> 
> Note, that is a legacy format, that works great for the 
> latency tracers. Those include (the example you used) irqsoff, 
> the preempt off, wake up latencies. This gives us a nice 
> listing of why we are hitting a latency. All other plugins 
> generally use the trace file, although they could also use 
> that file too.
> 
> As for your English comment. I showed the header to my wife, 
> and she had no idea what irqs-off means, nor need-resched, nor 
> preempt-depth ;-) They are not quite English as they are 
> technical terms. Most of the names are hard coded into the 
> kernel too.
> 
> Yeah, maybe that file (latency_trace) is a bit too much. I for 
> one love it. It is great to load a kernel on some remote box, 
> and run the irqs off latency tracer to see where the 
> interrupts are disabled for the longest time. This format is 
> really nice because it shows me when we are in an interrupt, 
> or interrupts are disabled, and when the task should have been 
> rescheduled.
> 
> This has help find places that we miss a preemption check too.

Could we get that, as PeterZ has suggested, as a trace_option 
column in the 'trace' file? It would be default off for 
non-latency tracers, with latency tracing plugins turning it on 
by default. Would that work?

	Ingo

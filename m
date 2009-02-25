Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbZBYKfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbZBYKfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZBYKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:35:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZBYKfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:35:08 -0500
Date: Wed, 25 Feb 2009 11:31:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20090225103109.GF12352@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <1235553982.4645.3111.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235553982.4645.3111.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-02-25 at 01:22 -0800, Andrew Morton wrote:
> 
> > Parse this:
> > 
> > irqsoff latency trace v1.1.5 on 2.6.26-rc8
> > --------------------------------------------------------------------
> >  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> >     -----------------
> >     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> >     -----------------
> >  => started at: apic_timer_interrupt
> >  => ended at:   do_softirq
> > 
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
> > 
> > your time starts now.
> 
> awk '/^#/ { start=1; next } { if (!start) next; .... }'

yeah.

For /debug/tracing/trace the convention is that a simple:

  grep -v '^#'

pattern will filter out the header as "comments".

	Ingo

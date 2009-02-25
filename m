Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbZBYJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbZBYJdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZBYJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:33:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37884 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZBYJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:33:11 -0500
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20090225012250.db68e480.akpm@linux-foundation.org>
References: <20090225025608.956691460@goodmis.org>
	 <20090225025753.798204550@goodmis.org>
	 <20090224194548.3effb746.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	 <20090224203308.8d623e0b.akpm@linux-foundation.org>
	 <20090225081118.GC15303@elte.hu>
	 <20090225002852.5ef5b869.akpm@linux-foundation.org>
	 <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
	 <20090225012250.db68e480.akpm@linux-foundation.org>
Date: Wed, 25 Feb 2009 11:33:07 +0200
Message-Id: <1235554387.3849.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 2009-02-25 at 01:22 -0800, Andrew Morton wrote:
> irqsoff latency trace v1.1.5 on 2.6.26-rc8
> --------------------------------------------------------------------
>  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
>     -----------------
>     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
>     -----------------
>  => started at: apic_timer_interrupt
>  => ended at:   do_softirq

<the header seems broken here, should have # at the beginning of the line>

> 
> #                _------=> CPU#
> #               / _-----=> irqs-off
> #              | / _----=> need-resched
> #              || / _---=> hardirq/softirq
> #              ||| / _--=> preempt-depth
> #              |||| /
> #              |||||     delay
> #  cmd     pid ||||| time  |   caller
> #     \   /    |||||   \   |   /
>   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
>   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
>   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> 
> your time starts now.

Well, what do you want to know? The first thing to do here is to:

$ grep -v "#" trace 
  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)

after which you have access to the raw data. This particular trace seems
to be somewhat hard to parse (because not all fields are whitespace
delimited) but I can assure you that any format I rely on is not.

So if you're arguing against specific ftrace plugins, go ahead (you
probably have a fair point there). But please don't dismiss the while
_concept_ of ftrace because of them.

			Pekka


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbZBYJbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbZBYJbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZBYJaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:30:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:34996 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZBYJay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:30:54 -0500
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
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
Content-Type: text/plain
Date: Wed, 25 Feb 2009 10:26:22 +0100
Message-Id: <1235553982.4645.3111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 01:22 -0800, Andrew Morton wrote:

> Parse this:
> 
> irqsoff latency trace v1.1.5 on 2.6.26-rc8
> --------------------------------------------------------------------
>  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
>     -----------------
>     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
>     -----------------
>  => started at: apic_timer_interrupt
>  => ended at:   do_softirq
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

awk '/^#/ { start=1; next } { if (!start) next; .... }'


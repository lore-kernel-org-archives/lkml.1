Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbZBYJZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbZBYJZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZBYJZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:25:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbZBYJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:25:18 -0500
Date: Wed, 25 Feb 2009 01:22:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
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
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-Id: <20090225012250.db68e480.akpm@linux-foundation.org>
In-Reply-To: <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
References: <20090225025608.956691460@goodmis.org>
	<20090225025753.798204550@goodmis.org>
	<20090224194548.3effb746.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	<20090224203308.8d623e0b.akpm@linux-foundation.org>
	<20090225081118.GC15303@elte.hu>
	<20090225002852.5ef5b869.akpm@linux-foundation.org>
	<84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 11:00:53 +0200 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Wed, Feb 25, 2009 at 10:28 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > A better approach would be to design simple, robust kernel interfaces
> > which make sense and which aren't made all complex by putting the user
> > interface in kernel space. __And to maintain corresponding userspace
> > tools which manipulate and present the IO from those kernel interfaces.
> 
> We did this for kmemtrace and quite frankly, I usually end up spending
> more time figuring out how to export the data from a virtual machine
> than actually analyzing the results.

Simple text files would suit.  I'm not saying use massive binary blobs.
Here.

> What makes ftrace so cool is the
> fact that it has almost zero-overhead for setup and that the
> text-based data format plays well with simple scripting tools
> available everywhere.

Parse this:

irqsoff latency trace v1.1.5 on 2.6.26-rc8
--------------------------------------------------------------------
 latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------
 => started at: apic_timer_interrupt
 => ended at:   do_softirq

#                _------=> CPU#
#               / _-----=> irqs-off
#              | / _----=> need-resched
#              || / _---=> hardirq/softirq
#              ||| / _--=> preempt-depth
#              |||| /
#              |||||     delay
#  cmd     pid ||||| time  |   caller
#     \   /    |||||   \   |   /
  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)

your time starts now.

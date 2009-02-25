Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZBYKI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZBYKI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758978AbZBYKIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:08:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbZBYKIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:08:46 -0500
Date: Wed, 25 Feb 2009 11:07:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
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
Subject: [PATCH] tracing: remove /debug/tracing/latency_trace
Message-ID: <20090225100726.GD12352@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <1235554387.3849.30.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235554387.3849.30.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Wed, 2009-02-25 at 01:22 -0800, Andrew Morton wrote:
> > irqsoff latency trace v1.1.5 on 2.6.26-rc8
> > --------------------------------------------------------------------
> >  latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> >     -----------------
> >     | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> >     -----------------
> >  => started at: apic_timer_interrupt
> >  => ended at:   do_softirq
> 
> <the header seems broken here, should have # at the beginning 
> of the line>

yep.

Furthermore note that latency_trace is a legacy format which i 
think we'll deprecate - in fact see the patch below. The primary 
format that people use is /debug/tracing/trace.

All the pretty-printing patches that Andrew has seen and 
complained about affect /debug/tracing/trace, not 
/debug/tracing/latency_trace.

	Ingo

----------------->
>From 886b5b73d71e4027d7dc6c14f5f7ab102201ea6b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 25 Feb 2009 11:03:44 +0100
Subject: [PATCH] tracing: remove /debug/tracing/latency_trace

Impact: remove old debug/tracing API

/debug/tracing/latency_trace is an old legacy format we kept from
the old latency tracer. Remove the file for now. If there's any
useful bit missing then we'll propagate any useful output bits into
the /debug/tracing/trace output.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e1f3b99..11ba100 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2938,11 +2938,6 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
 
-	entry = debugfs_create_file("latency_trace", 0444, d_tracer,
-				    &global_trace, &tracing_lt_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'latency_trace' entry\n");
-
 	entry = debugfs_create_file("trace", 0444, d_tracer,
 				    &global_trace, &tracing_fops);
 	if (!entry)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYAZEa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYAZEa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYAZE2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:28:30 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:55605 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYAZE2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:28:21 -0500
Message-Id: <20080126042803.840143806@goodmis.org>
References: <20080126042152.526086719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jan 2008 23:22:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 17/23 -v6] Add marker in try_to_wake_up
Content-Disposition: inline; filename=add-markers-to-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add markers into the wakeup code, to allow the tracer to
record wakeup timings.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-25 21:47:21.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-25 21:47:30.000000000 -0500
@@ -1885,6 +1885,10 @@ static int try_to_wake_up(struct task_st
 
 out_activate:
 #endif /* CONFIG_SMP */
+	trace_mark(kernel_sched_wakeup,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
+
 	schedstat_inc(p, se.nr_wakeups);
 	if (sync)
 		schedstat_inc(p, se.nr_wakeups_sync);
@@ -2026,6 +2030,10 @@ void fastcall wake_up_new_task(struct ta
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(p, rq);
 	}
+	trace_mark(kernel_sched_wakeup_new,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
+
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)

-- 

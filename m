Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYAWQFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYAWQFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYAWQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:04:53 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:63057 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYAWQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:04:50 -0500
Message-Id: <20080123160443.853153432@goodmis.org>
References: <20080123160236.969334052@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 23 Jan 2008 11:02:53 -0500
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
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 17/20 -v5] Add marker in try_to_wake_up
Content-Disposition: inline; filename=add-markers-to-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add markers into the wakeup code, to allow the tracer to
record wakeup timings.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-23 10:27:28.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-23 10:27:45.000000000 -0500
@@ -1633,6 +1633,10 @@ out_set_cpu:
 
 out_activate:
 #endif /* CONFIG_SMP */
+	trace_mark(kernel_sched_wakeup,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
+
 	schedstat_inc(p, se.nr_wakeups);
 	if (sync)
 		schedstat_inc(p, se.nr_wakeups_sync);

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYA3VHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYA3VHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYA3VFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:41 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:51363 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYA3VFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:35 -0500
Message-Id: <20080130210526.687987807@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:09 -0500
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
Subject: [PATCH 12/23 -v8] Add context switch marker to sched.c
Content-Disposition: inline; filename=add-trace-hooks-to-sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add marker into context_switch to record the prev and next tasks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-mcount.git/kernel/sched.c
===================================================================
--- linux-mcount.git.orig/kernel/sched.c	2008-01-30 14:36:00.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-30 15:25:31.000000000 -0500
@@ -2198,6 +2198,8 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		   "prev %p next %p", prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*

-- 

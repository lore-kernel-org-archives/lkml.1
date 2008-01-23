Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbYAWQFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbYAWQFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYAWQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:04:52 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:64286 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYAWQEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:04:48 -0500
Message-Id: <20080123160443.042918845@goodmis.org>
References: <20080123160236.969334052@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 23 Jan 2008 11:02:48 -0500
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
Subject: [PATCH 12/20 -v5] Add context switch marker to sched.c
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
--- linux-mcount.git.orig/kernel/sched.c	2008-01-23 10:26:11.000000000 -0500
+++ linux-mcount.git/kernel/sched.c	2008-01-23 10:27:25.000000000 -0500
@@ -1933,6 +1933,8 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		   "prev %p next %p", prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*

-- 

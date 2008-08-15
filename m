Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYHODBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYHODBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYHODAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:00:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYHODAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:00:49 -0400
Message-Id: <20080815030047.164606620@goodmis.org>
References: <20080815024716.480118113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 22:47:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: [PATCH 1/3] ftrace: do not show freed records in available_filter_functions
Content-Disposition: inline; filename=ftrace-dont-print-freed-recs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that freed records can appear in the available_filter_functions list.
This patch fixes that.

CC: Abhishek Sagar <sagar.abhishek@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-14 22:43:01.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-14 22:43:03.000000000 -0400
@@ -879,15 +879,13 @@ t_next(struct seq_file *m, void *v, loff
 		}
 	} else {
 		rec = &iter->pg->records[iter->idx++];
-		if ((!(iter->flags & FTRACE_ITER_FAILURES) &&
+		if ((rec->flags & FTRACE_FL_FREE) ||
+
+		    (!(iter->flags & FTRACE_ITER_FAILURES) &&
 		     (rec->flags & FTRACE_FL_FAILED)) ||
 
 		    ((iter->flags & FTRACE_ITER_FAILURES) &&
-		     (!(rec->flags & FTRACE_FL_FAILED) ||
-		      (rec->flags & FTRACE_FL_FREE))) ||
-
-		    ((iter->flags & FTRACE_ITER_FILTER) &&
-		     !(rec->flags & FTRACE_FL_FILTER)) ||
+		     !(rec->flags & FTRACE_FL_FAILED)) ||
 
 		    ((iter->flags & FTRACE_ITER_NOTRACE) &&
 		     !(rec->flags & FTRACE_FL_NOTRACE))) {

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYKDVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYKDVsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYKDVsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:48:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYKDVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:48:13 -0500
Date: Tue, 4 Nov 2008 16:48:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace: ftrace_preempt_disable comment fix
In-Reply-To: <20081104091042.GD23790@elte.hu>
Message-ID: <alpine.DEB.1.10.0811041645330.15875@gandalf.stny.rr.com>
References: <20081104041554.605521183@goodmis.org> <20081104042203.123673140@goodmis.org> <20081104091042.GD23790@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: comment fixes

Updates to ftrace_preempt_disable comments as recommended to me
by Andrew Morton.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-trace.git/kernel/trace/trace.h
===================================================================
--- linux-trace.git.orig/kernel/trace/trace.h	2008-11-04 16:32:57.000000000 -0500
+++ linux-trace.git/kernel/trace/trace.h	2008-11-04 16:36:11.000000000 -0500
@@ -425,17 +425,17 @@ extern struct tracer nop_trace;
  * ftrace_preempt_disable - disable preemption scheduler safe
  *
  * When tracing can happen inside the scheduler, there exists
- * cases that the tracing might happen before the need_resched
+ * cases where tracing might happen before the need_resched
  * flag is checked. If this happens and the tracer calls
  * preempt_enable (after a disable), a schedule might take place
  * causing an infinite recursion.
  *
  * To prevent this, we read the need_recshed flag before
- * disabling preemption. When we want to enable preemption we
- * check the flag, if it is set, then we call preempt_enable_no_resched.
- * Otherwise, we call preempt_enable.
+ * disabling preemption and store it. When we want to enable preemption
+ * we check the stored flag, if it is set, then we call
+ * preempt_enable_no_resched. Otherwise, we call preempt_enable.
  *
- * The rational for doing the above is that if need resched is set
+ * The rationale for doing the above is that if need resched is set
  * and we have yet to reschedule, we are either in an atomic location
  * (where we do not need to check for scheduling) or we are inside
  * the scheduler and do not want to resched.



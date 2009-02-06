Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZBFP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZBFP3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZBFP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59070 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZBFP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:23 -0500
Message-Id: <20090206152721.833871946@goodmis.org>
References: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 7/7] trace: trivial fixes in comment typos.
Content-Disposition: inline; filename=0007-trace-trivial-fixes-in-comment-typos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Impact: clean up

Fixed several typos in the comments.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    2 +-
 kernel/trace/ftrace.c  |    6 +++---
 kernel/trace/trace.h   |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7840e71..5e302d6 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -140,7 +140,7 @@ static inline int ftrace_disable_ftrace_graph_caller(void) { return 0; }
 #endif
 
 /**
- * ftrace_make_nop - convert code into top
+ * ftrace_make_nop - convert code into nop
  * @mod: module structure if called by module load initialization
  * @rec: the mcount call site record
  * @addr: the address that the call site should be calling
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6861003..1796e01 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -465,7 +465,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	 * it is not enabled then do nothing.
 	 *
 	 * If this record is not to be traced and
-	 * it is enabled then disabled it.
+	 * it is enabled then disable it.
 	 *
 	 */
 	if (rec->flags & FTRACE_FL_NOTRACE) {
@@ -485,7 +485,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 		if (fl == (FTRACE_FL_FILTER | FTRACE_FL_ENABLED))
 			return 0;
 
-		/* Record is not filtered and is not enabled do nothing */
+		/* Record is not filtered or enabled, do nothing */
 		if (!fl)
 			return 0;
 
@@ -507,7 +507,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
 		} else {
 
-			/* if record is not enabled do nothing */
+			/* if record is not enabled, do nothing */
 			if (!(rec->flags & FTRACE_FL_ENABLED))
 				return 0;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index df627a9..5f2f170 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -613,12 +613,12 @@ extern struct tracer nop_trace;
  * preempt_enable (after a disable), a schedule might take place
  * causing an infinite recursion.
  *
- * To prevent this, we read the need_recshed flag before
+ * To prevent this, we read the need_resched flag before
  * disabling preemption. When we want to enable preemption we
  * check the flag, if it is set, then we call preempt_enable_no_resched.
  * Otherwise, we call preempt_enable.
  *
- * The rational for doing the above is that if need resched is set
+ * The rational for doing the above is that if need_resched is set
  * and we have yet to reschedule, we are either in an atomic location
  * (where we do not need to check for scheduling) or we are inside
  * the scheduler and do not want to resched.
@@ -639,7 +639,7 @@ static inline int ftrace_preempt_disable(void)
  *
  * This is a scheduler safe way to enable preemption and not miss
  * any preemption checks. The disabled saved the state of preemption.
- * If resched is set, then we were either inside an atomic or
+ * If resched is set, then we are either inside an atomic or
  * are inside the scheduler (we would have already scheduled
  * otherwise). In this case, we do not want to call normal
  * preempt_enable, but preempt_enable_no_resched instead.
-- 
1.5.6.5

-- 

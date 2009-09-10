Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZIJEOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZIJEOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZIJEOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:14:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZIJEM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:59 -0400
Message-Id: <20090910041301.972329901@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 6/6] tracing: move PRED macros to trace_events_filter.c
Content-Disposition: inline; filename=0006-tracing-move-PRED-macros-to-trace_events_filter.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
  to kernel/trace/trace_events_filter.c

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |   41 ------------------------------------
 kernel/trace/trace_events_filter.c |   41 ++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2163d18..acaa680 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -800,47 +800,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-#define DEFINE_COMPARISON_PRED(type)					\
-static int filter_pred_##type(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	type *addr = (type *)(event + pred->offset);			\
-	type val = (type)pred->val;					\
-	int match = 0;							\
-									\
-	switch (pred->op) {						\
-	case OP_LT:							\
-		match = (*addr < val);					\
-		break;							\
-	case OP_LE:							\
-		match = (*addr <= val);					\
-		break;							\
-	case OP_GT:							\
-		match = (*addr > val);					\
-		break;							\
-	case OP_GE:							\
-		match = (*addr >= val);					\
-		break;							\
-	default:							\
-		break;							\
-	}								\
-									\
-	return match;							\
-}
-
-#define DEFINE_EQUALITY_PRED(size)					\
-static int filter_pred_##size(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	u##size *addr = (u##size *)(event + pred->offset);		\
-	u##size val = (u##size)pred->val;				\
-	int match;							\
-									\
-	match = (val == *addr) ^ pred->not;				\
-									\
-	return match;							\
-}
-
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 93660fb..2324578 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -121,6 +121,47 @@ struct filter_parse_state {
 	} operand;
 };
 
+#define DEFINE_COMPARISON_PRED(type)					\
+static int filter_pred_##type(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	type *addr = (type *)(event + pred->offset);			\
+	type val = (type)pred->val;					\
+	int match = 0;							\
+									\
+	switch (pred->op) {						\
+	case OP_LT:							\
+		match = (*addr < val);					\
+		break;							\
+	case OP_LE:							\
+		match = (*addr <= val);					\
+		break;							\
+	case OP_GT:							\
+		match = (*addr > val);					\
+		break;							\
+	case OP_GE:							\
+		match = (*addr >= val);					\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+									\
+	return match;							\
+}
+
+#define DEFINE_EQUALITY_PRED(size)					\
+static int filter_pred_##size(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	u##size *addr = (u##size *)(event + pred->offset);		\
+	u##size val = (u##size)pred->val;				\
+	int match;							\
+									\
+	match = (val == *addr) ^ pred->not;				\
+									\
+	return match;							\
+}
+
 DEFINE_COMPARISON_PRED(s64);
 DEFINE_COMPARISON_PRED(u64);
 DEFINE_COMPARISON_PRED(s32);
-- 
1.6.3.3

-- 

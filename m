Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZILHxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZILHxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZILHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:53:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZILHxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:53:36 -0400
Date: Sat, 12 Sep 2009 07:53:20 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AA8579B.4020706@cn.fujitsu.com>
References: <4AA8579B.4020706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: move PRED macros to trace_events_filter.c
Message-ID: <tip-197e2eabc90c203d1086916b7f66694ba5fbb937@git.kernel.org>
Git-Commit-ID: 197e2eabc90c203d1086916b7f66694ba5fbb937
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:53:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  197e2eabc90c203d1086916b7f66694ba5fbb937
Gitweb:     http://git.kernel.org/tip/197e2eabc90c203d1086916b7f66694ba5fbb937
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Sep 2009 09:34:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Sep 2009 23:54:11 -0400

tracing: move PRED macros to trace_events_filter.c

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

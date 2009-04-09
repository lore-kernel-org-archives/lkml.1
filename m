Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbZDIGL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbZDIGL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZDIGLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:11:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65093 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZDIGLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:11:47 -0400
Message-ID: <49DD90D2.5020604@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 14:08:18 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Tracepoint: Make skb tracepoint use TRACE_EVENT macro
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TRACE_EVENT is more unify and generic for define a tracepoint.
It also add ftrace support for this tracepoint.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/skb.h               |    4 +--
 include/trace/skb_event_types.h   |   38 +++++++++++++++++++++++++++++++++++++
 include/trace/trace_event_types.h |    1 +
 include/trace/trace_events.h      |    1 +
 4 files changed, 41 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/skb_event_types.h

diff --git a/include/trace/skb.h b/include/trace/skb.h
index b66206d..d2de717 100644
--- a/include/trace/skb.h
+++ b/include/trace/skb.h
@@ -4,8 +4,6 @@
 #include <linux/skbuff.h>
 #include <linux/tracepoint.h>
 
-DECLARE_TRACE(kfree_skb,
-	TP_PROTO(struct sk_buff *skb, void *location),
-	TP_ARGS(skb, location));
+#include <trace/skb_event_types.h>
 
 #endif
diff --git a/include/trace/skb_event_types.h b/include/trace/skb_event_types.h
new file mode 100644
index 0000000..4a1c504
--- /dev/null
+++ b/include/trace/skb_event_types.h
@@ -0,0 +1,38 @@
+
+/* use <trace/skb.h> instead */
+#ifndef TRACE_EVENT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM skb
+
+/*
+ * Tracepoint for free an sk_buff:
+ */
+TRACE_EVENT(kfree_skb,
+
+	TP_PROTO(struct sk_buff *skb, void *location),
+
+	TP_ARGS(skb, location),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned short,	protocol	)
+		__field(	void *,		location	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		if (skb) {
+			__entry->protocol = ntohs(skb->protocol);
+		}
+		__entry->location = location;
+	),
+
+	TP_printk("skbaddr=%p protocol=%u location=%p",
+		__entry->skbaddr, __entry->protocol, __entry->location)
+);
+
+#undef TRACE_SYSTEM
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index df56f56..33b6bfc 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -3,3 +3,4 @@
 #include <trace/sched_event_types.h>
 #include <trace/irq_event_types.h>
 #include <trace/lockdep_event_types.h>
+#include <trace/skb_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index fd13750..0e2aa80 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -3,3 +3,4 @@
 #include <trace/sched.h>
 #include <trace/irq.h>
 #include <trace/lockdep.h>
+#include <trace/skb.h>
-- 
1.5.5.3



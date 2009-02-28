Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZB1JNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZB1JNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZB1JJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZB1JJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:41 -0500
Message-Id: <20090228090938.855733601@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/10] tracing: create the C style tracing for the irq subsystem
Content-Disposition: inline; filename=0010-tracing-create-the-C-style-tracing-for-the-irq-subs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch utilizes the TRACE_EVENT_FORMAT macro to enable the C style
faster tracing for the irq subsystem trace points.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/irq_event_types.h |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 47a2be1..65850bc 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -8,15 +8,26 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-TRACE_FORMAT(irq_handler_entry,
+TRACE_EVENT_FORMAT(irq_handler_entry,
 	TPPROTO(int irq, struct irqaction *action),
 	TPARGS(irq, action),
-	TPFMT("irq=%d handler=%s", irq, action->name));
+	TPFMT("irq=%d handler=%s", irq, action->name),
+	TRACE_STRUCT(
+		TRACE_FIELD(int, irq, irq)
+	),
+	TPRAWFMT("irq %d")
+	);
 
-TRACE_FORMAT(irq_handler_exit,
+TRACE_EVENT_FORMAT(irq_handler_exit,
 	TPPROTO(int irq, struct irqaction *action, int ret),
 	TPARGS(irq, action, ret),
 	TPFMT("irq=%d handler=%s return=%s",
-		irq, action->name, ret ? "handled" : "unhandled"));
+		irq, action->name, ret ? "handled" : "unhandled"),
+	TRACE_STRUCT(
+		TRACE_FIELD(int, irq, irq)
+		TRACE_FIELD(int, ret, ret)
+	),
+	TPRAWFMT("irq %d ret %d")
+	);
 
 #undef TRACE_SYSTEM
-- 
1.5.6.5

-- 

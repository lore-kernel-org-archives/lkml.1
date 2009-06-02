Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZFBEpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZFBEpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZFBEnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41681 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZFBEnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:39 -0400
Message-Id: <20090602044340.946664871@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/10] tracing: remove redundant SOFTIRQ from softirq event traces
Content-Disposition: inline; filename=0008-tracing-remove-redundant-SOFTIRQ-from-softirq-event-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After converting the softirq tracer to use te flags options, this
caused a regression with the name. Since the flag was used directly
it was printed out (i.e. HRTIMER_SOFTIRQ).

This patch only shows the softirq name without the SOFTIRQ part.

[ Impact: fix regression of output from softirq events ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 683fb36..b0c7ede 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -7,18 +7,18 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM irq
 
-#define softirq_name(sirq) { sirq, #sirq }
-#define show_softirq_name(val)						\
-	__print_symbolic(val,						\
-			 softirq_name(HI_SOFTIRQ),			\
-			 softirq_name(TIMER_SOFTIRQ),			\
-			 softirq_name(NET_TX_SOFTIRQ),			\
-			 softirq_name(NET_RX_SOFTIRQ),			\
-			 softirq_name(BLOCK_SOFTIRQ),			\
-			 softirq_name(TASKLET_SOFTIRQ),			\
-			 softirq_name(SCHED_SOFTIRQ),			\
-			 softirq_name(HRTIMER_SOFTIRQ),			\
-			 softirq_name(RCU_SOFTIRQ))
+#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
+#define show_softirq_name(val)			\
+	__print_symbolic(val,			\
+			 softirq_name(HI),	\
+			 softirq_name(TIMER),	\
+			 softirq_name(NET_TX),	\
+			 softirq_name(NET_RX),	\
+			 softirq_name(BLOCK),	\
+			 softirq_name(TASKLET),	\
+			 softirq_name(SCHED),	\
+			 softirq_name(HRTIMER),	\
+			 softirq_name(RCU))
 
 /**
  * irq_handler_entry - called immediately before the irq action handler
-- 
1.6.3.1

-- 

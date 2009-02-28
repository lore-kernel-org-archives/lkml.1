Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZB1JKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZB1JKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZB1JJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090937.575418744@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:50 -0500
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
Subject: [PATCH 04/10] tracing: add subsystem irq for irq events
Content-Disposition: inline; filename=0004-tracing-add-subsystem-irq-for-irq-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the TRACE_SYSTEM irq for the irq events.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/irq_event_types.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 5d0919f..47a2be1 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -5,6 +5,9 @@
 # error Unless you know what you are doing.
 #endif
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq
+
 TRACE_FORMAT(irq_handler_entry,
 	TPPROTO(int irq, struct irqaction *action),
 	TPARGS(irq, action),
@@ -15,3 +18,5 @@ TRACE_FORMAT(irq_handler_exit,
 	TPARGS(irq, action, ret),
 	TPFMT("irq=%d handler=%s return=%s",
 		irq, action->name, ret ? "handled" : "unhandled"));
+
+#undef TRACE_SYSTEM
-- 
1.5.6.5

-- 

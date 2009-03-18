Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZCRDe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZCRDe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 23:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZCRDcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 23:32:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZCRDcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 23:32:52 -0400
Message-Id: <20090318033249.888398770@goodmis.org>
References: <20090318031423.981603258@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 23:14:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] tracing: make power tracer start/stop methods lighter weight
Content-Disposition: inline; filename=0005-tracing-make-power-tracer-start-stop-methods-lighte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The start/stop methods of a tracer should be able to be executed
in all contexts. This patch converts the power tracer to do so.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_power.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 91ce672..bae791e 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -122,12 +122,16 @@ fail_start:
 static void start_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 1;
-	tracing_power_register();
 }
 
 static void stop_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 0;
+}
+
+static void power_trace_reset(struct trace_array *tr)
+{
+	trace_power_enabled = 0;
 	unregister_trace_power_start(probe_power_start);
 	unregister_trace_power_end(probe_power_end);
 	unregister_trace_power_mark(probe_power_mark);
@@ -188,7 +192,7 @@ static struct tracer power_tracer __read_mostly =
 	.init		= power_trace_init,
 	.start		= start_power_trace,
 	.stop		= stop_power_trace,
-	.reset		= stop_power_trace,
+	.reset		= power_trace_reset,
 	.print_line	= power_print_line,
 };
 
-- 
1.6.2

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYLHA4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYLHA4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 19:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYLHA4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 19:56:12 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:23131 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYLHA4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 19:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JaL+sptFOyO+SgB1V0gQrydn5/fZdPBEXggXL92SrTwFc13AdfVeaxHR1JlELcpDVy
         yKcOQtygKtEAohUO//QegDRkbovSLGVlnBpXxsl2uDQeYchN4zj9X26Oe0sKQJAXko+s
         XNcAfmro+qC0bLapBEsyLpx5AXNyk+nU/S/d0=
Message-ID: <493C70A6.70905@gmail.com>
Date: Mon, 08 Dec 2008 01:56:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/function-graph-tracer: implement a print_headers
 function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: provide headers to explain a bit the output

This patch implements the print_headers callback for the function graph
tracer. These headers are output according to the current trace options.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 7ea446d..4434e4e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -606,11 +606,36 @@ print_graph_function(struct trace_iterator *iter)
 	}
 }
 
+static void print_graph_headers(struct seq_file *s)
+{
+	/* 1st line */
+	seq_printf(s, "# ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+		seq_printf(s, "CPU ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+		seq_printf(s, "TASK/PID     ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD)
+		seq_printf(s, "OVERHEAD/");
+	seq_printf(s, "DURATION            FUNCTION CALLS\n");
+
+	/* 2nd line */
+	seq_printf(s, "# ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+		seq_printf(s, "|   ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+		seq_printf(s, "|      |     ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+		seq_printf(s, "|        ");
+		seq_printf(s, "|                   |   |   |   |\n");
+	} else
+		seq_printf(s, "    |               |   |   |   |\n");
+}
 static struct tracer graph_trace __read_mostly = {
-	.name	     = "function_graph",
-	.init	     = graph_trace_init,
-	.reset	     = graph_trace_reset,
-	.print_line = print_graph_function,
+	.name	     	= "function_graph",
+	.init	     	= graph_trace_init,
+	.reset	     	= graph_trace_reset,
+	.print_line	= print_graph_function,
+	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
 };
 
-- 
1.6.0.4


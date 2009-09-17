Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZIQT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZIQT6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIQT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:57:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZIQT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:57:43 -0400
Message-Id: <20090917195745.739830595@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 17 Sep 2009 15:55:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] [PATCH 2/5] tracing: switch function prints from %pf to %ps
References: <20090917195508.189551309@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-switch-function-prints-from-pf-to-ps.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

For direct function pointers (like what mcount provides) PowerPC64
requires the use of %ps, otherwise nothing is printed.

This patch converts all prints of functions retrieved through mcount
to use the %ps format from the %pf.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                |    6 +++---
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f7ab7fc..cc615f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1405,7 +1405,7 @@ static int t_hash_show(struct seq_file *m, void *v)
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
 
-	seq_printf(m, "%pf:%pf", (void *)rec->ip, (void *)rec->ops->func);
+	seq_printf(m, "%ps:%ps", (void *)rec->ip, (void *)rec->ops->func);
 
 	if (rec->data)
 		seq_printf(m, ":%p", rec->data);
@@ -1515,7 +1515,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%pf\n", (void *)rec->ip);
+	seq_printf(m, "%ps\n", (void *)rec->ip);
 
 	return 0;
 }
@@ -2456,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	seq_printf(m, "%pf\n", (void *)*ptr);
+	seq_printf(m, "%ps\n", (void *)*ptr);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 5b01b94..b3f3776 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -290,7 +290,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 {
 	long count = (long)data;
 
-	seq_printf(m, "%pf:", (void *)ip);
+	seq_printf(m, "%ps:", (void *)ip);
 
 	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 61f1667..45e6c01 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -124,7 +124,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
 		ftrace_graph_stop();
 		WARN(1, "Bad frame pointer: expected %lx, received %lx\n"
-		     "  from func %pF return to %lx\n",
+		     "  from func %ps return to %lx\n",
 		     current->ret_stack[index].fp,
 		     frame_pointer,
 		     (void *)current->ret_stack[index].func,
@@ -669,7 +669,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "%pf();\n", (void *)call->func);
+	ret = trace_seq_printf(s, "%ps();\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -712,7 +712,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "%pf() {\n", (void *)call->func);
+	ret = trace_seq_printf(s, "%ps() {\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-- 
1.6.3.3



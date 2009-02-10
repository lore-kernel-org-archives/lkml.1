Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZBJRiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZBJRiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZBJRgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZBJRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:20 -0500
Message-Id: <20090210173619.073263328@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/7] tracing: provide correct return value after outputting the event
Content-Disposition: inline; filename=0006-tracing-provide-correct-return-value-after-outputti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

This patch is to make the function return early on failure, and give
correct return value on success.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 782ec0f..519a0ca 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -186,30 +186,30 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
 	ret = trace_seq_printf(s,
 		" ------------------------------------------\n");
 	if (!ret)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = print_graph_cpu(s, cpu);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = print_graph_proc(s, prev_pid);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = trace_seq_printf(s, " => ");
 	if (!ret)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = print_graph_proc(s, pid);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = trace_seq_printf(s,
 		"\n ------------------------------------------\n\n");
 	if (!ret)
-		TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
 
-	return ret;
+	return TRACE_TYPE_HANDLED;
 }
 
 static struct ftrace_graph_ret_entry *
-- 
1.5.6.5

-- 

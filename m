Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZBJIyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZBJIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZBJIyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:54:36 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:27878 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZBJIyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:54:35 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 2/3] trace: provide correct return value after outputting the event.
Date: Tue, 10 Feb 2009 01:03:05 -0500
Message-Id: <1234245785-14526-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.499140C4.000E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to make the function early return once failure and give
correct return value in case of success.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
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
1.5.6


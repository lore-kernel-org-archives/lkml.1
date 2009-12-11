Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZLKJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZLKJls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZLKJlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:41:42 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28753 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZLKJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:41:41 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] tracing: add checks for printing graph irq
Date: Fri, 11 Dec 2009 17:38:35 +0800
Message-Id: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B2213D1.0061:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return value of trace_seq_printf.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_functions_graph.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..3fa4055 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -555,8 +555,11 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Don't close the duration column if haven't one */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
-		trace_seq_printf(s, " |");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+		ret = trace_seq_printf(s, " |");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 	ret = trace_seq_printf(s, "\n");
 
 	if (!ret)
-- 
1.5.6


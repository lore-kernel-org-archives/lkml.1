Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYLVSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYLVSQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLVSQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:16:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:12163 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYLVSQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=D/W9Ar7ZVeUwjv0jWZY8He0WwekQ4k65b/dNDvOdUde6Wc/mh/E3Pr5Xjhtll6c42D
         sFUQ7CUXjIo9ExzF2pOPDtBMS+XQcDmKcyaoAKiLwcGM5ioth0uhmMfsUyAKwgBb82KF
         oy1MtJwcDpHkRJEdh8Jd8d3RR3ivNY9uSw7ZE=
Message-ID: <494FD967.2000002@gmail.com>
Date: Mon, 22 Dec 2008 19:16:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-graph-tracer: strip ending newlines on comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: trivial output improvement

Ending newlines are appended automatically on comments by the function graph tracer
because the newlines needs to be placed after the "*/" characters.
So if the user puts an ending whitespace, we want to strip it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4bf39fc..20c0b0d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -540,6 +540,7 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 		   struct trace_entry *ent, struct trace_iterator *iter)
 {
 	int i;
+	int len;
 	int ret;
 
 	/* Pid */
@@ -584,6 +585,11 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 				return TRACE_TYPE_PARTIAL_LINE;
 		}
 
+	/* Strip ending newline on the comment */
+	len = strlen(trace->buf);
+	if (trace->buf[len - 1] == '\n')
+		trace->buf[len - 1] = '\0';
+
 	/* The comment */
 	ret = trace_seq_printf(s, "/* %s", trace->buf);
 	if (!ret)
-- 
1.6.0.4


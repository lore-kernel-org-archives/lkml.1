Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbZGICq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbZGICq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbZGICqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:46:38 -0400
Received: from ey-out-1920.google.com ([74.125.78.148]:33801 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbZGICqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ELi5qyuOD28aEB79/L2yJgl60HLYe7ZgFtl2JZMtmyo16hRb17/BPOQIimYFiQ/typ
         BxwLx+BA/rFLcdWLu8mZ4SUHHdhWdxD1zX8zfC5HItyjviT+3tmr4sUpXOnj7FT3uXmx
         V2fMC6f+aaKAo2Wpgb8V1+fHimu0NcX3lSupk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing/function-graph-tracer: Use the %pf format
Date: Thu,  9 Jul 2009 04:46:29 +0200
Message-Id: <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247107590-6428-1-git-send-email-fweisbec@gmail.com>
References: <1247107590-6428-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the obsolete seq_print_ip_sym() usage and replace it
by the %pf format in order to print function symbols.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/trace/trace_functions_graph.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d2249ab..abf7c4a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -565,11 +565,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = seq_print_ip_sym(s, call->func, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_printf(s, "();\n");
+	ret = trace_seq_printf(s, "%pf();\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -612,11 +608,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = seq_print_ip_sym(s, call->func, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_printf(s, "() {\n");
+	ret = trace_seq_printf(s, "%pf() {\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-- 
1.6.2.3


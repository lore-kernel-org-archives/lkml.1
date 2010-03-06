Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0CFCWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:22:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0CFCWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:22:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=Syq3WAq7A58A:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=2xOch9Zi1-IkwRud8PYA:9 a=d-fT41exfg2Ge7qDqZ6RgnWKYQAA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100306022215.678161487@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Mar 2010 21:21:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/4] function-graph: Use comment notation for func names of dangling }
References: <20100306022140.320536991@goodmis.org>
Content-Disposition: inline; filename=0002-function-graph-Use-comment-notation-for-func-names-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a '}' does not have a matching function start, the name is printed
within parenthesis. But this makes it confusing between ending '}'
and function starts. This patch makes the function name appear in C comment
notation.

Old view:
 3)   1.281 us    |            } (might_fault)
 3)   3.620 us    |          } (filldir)
 3)   5.251 us    |        } (call_filldir)
 3)               |        call_filldir() {
 3)               |          filldir() {

New view:
 3)   1.281 us    |            } /* might_fault */
 3)   3.620 us    |          } /* filldir */
 3)   5.251 us    |        } /* call_filldir */
 3)               |        call_filldir() {
 3)               |          filldir() {

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e998a82..7b1f246 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -920,7 +920,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	} else {
-		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
+		ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
-- 
1.7.0



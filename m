Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0CFCWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:22:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0CFCWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:22:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=SzXHoAgzrVwA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=5dNHhCxE6qfLTrCz5P4A:9 a=VTfFkNwHRbKEI_TScjZc2cRgWasA:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100306022215.237442622@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Mar 2010 21:21:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] function-graph: Fix unused reference to ftrace_set_func()
References: <20100306022140.320536991@goodmis.org>
Content-Disposition: inline; filename=0001-function-graph-Fix-unused-reference-to-ftrace_set_fu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The declaration of ftrace_set_func() is at the start of the ftrace.c file
and wrapped with a #ifdef CONFIG_FUNCTION_GRAPH condition. If function
graph tracing is enabled but CONFIG_DYNAMIC_FTRACE is not, a warning
about that function being declared static and unused is given.

This really should have been placed within the CONFIG_FUNCTION_GRAPH
condition that uses ftrace_set_func().

Moving the declaration down fixes the warning and makes the code cleaner.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d996353..d0407c9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -85,10 +85,6 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
-#endif
-
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op = ftrace_list;
@@ -2300,6 +2296,8 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
+
 static int __init set_graph_function(char *str)
 {
 	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
-- 
1.7.0



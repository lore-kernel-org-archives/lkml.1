Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZA1PCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZA1PCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZA1PCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:02:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZA1PCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:02:30 -0500
Date: Wed, 28 Jan 2009 13:02:12 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace: Use tracing_reset_online_cpus in more places
Message-ID: <20090128150212.GB627@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>    
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index ca017e0..1284145 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -133,11 +133,7 @@ static void stop_branch_trace(struct trace_array *tr)
 
 static int branch_trace_init(struct trace_array *tr)
 {
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-
+	tracing_reset_online_cpus(tr);
 	start_branch_trace(tr);
 	return 0;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 66fc7b8..c97594d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -52,15 +52,11 @@ static struct tracer_flags tracer_flags = {
 
 static int graph_trace_init(struct trace_array *tr)
 {
-	int cpu, ret;
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-
-	ret = register_ftrace_graph(&trace_graph_return,
+	int ret = register_ftrace_graph(&trace_graph_return,
 					&trace_graph_entry);
 	if (ret)
 		return ret;
+	tracing_reset_online_cpus(tr);
 	tracing_start_cmdline_record();
 
 	return 0;
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index b9767ac..087b6cb 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -47,12 +47,8 @@ static void stop_nop_trace(struct trace_array *tr)
 
 static int nop_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	ctx_trace = tr;
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-
+	tracing_reset_online_cpus(tr);
 	start_nop_trace(tr);
 	return 0;
 }

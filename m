Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZGJKnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZGJKnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZGJKmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:42:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:53485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbZGJKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:42:40 -0400
Date: Fri, 10 Jul 2009 10:42:04 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
References: <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/core] tracing/function-graph-tracer: Use the %pf format
Message-ID: <tip-68baafcfc46074c4bb4e4c3115c2c76a8a85f37d@git.kernel.org>
Git-Commit-ID: 68baafcfc46074c4bb4e4c3115c2c76a8a85f37d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:42:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68baafcfc46074c4bb4e4c3115c2c76a8a85f37d
Gitweb:     http://git.kernel.org/tip/68baafcfc46074c4bb4e4c3115c2c76a8a85f37d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 9 Jul 2009 04:46:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:07:19 +0200

tracing/function-graph-tracer: Use the %pf format

Remove the obsolete seq_print_ip_sym() usage and replace it
by the %pf format in order to print function symbols.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1247107590-6428-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 

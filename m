Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZGJKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZGJKoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZGJKnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:43:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:53585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbZGJKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:43:44 -0400
Date: Fri, 10 Jul 2009 10:42:18 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
References: <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/core] tracing/kmemtrace: Use the %pf format
Message-ID: <tip-6a167c655858cbec4175532fd00417661c87f149@git.kernel.org>
Git-Commit-ID: 6a167c655858cbec4175532fd00417661c87f149
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:42:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a167c655858cbec4175532fd00417661c87f149
Gitweb:     http://git.kernel.org/tip/6a167c655858cbec4175532fd00417661c87f149
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 9 Jul 2009 04:46:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:07:20 +0200

tracing/kmemtrace: Use the %pf format

Remove the obsolete seq_print_ip_sym() usage and replace it
by the %pf format in order to print function symbols.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 74903b6..2f6fa47 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -389,19 +389,12 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Node */
-	ret = trace_seq_printf(s, "%4d   ", entry->node);
+	/* Node and call site*/
+	ret = trace_seq_printf(s, "%4d   %pf\n", entry->node,
+						 (void *)entry->call_site);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Call site */
-	ret = seq_print_ip_sym(s, entry->call_site, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	if (!trace_seq_printf(s, "\n"))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -447,19 +440,11 @@ kmemtrace_print_free_compress(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Skip node */
-	ret = trace_seq_printf(s, "       ");
+	/* Skip node and print call site*/
+	ret = trace_seq_printf(s, "       %pf\n", (void *)entry->call_site);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Call site */
-	ret = seq_print_ip_sym(s, entry->call_site, 0);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	if (!trace_seq_printf(s, "\n"))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return TRACE_TYPE_HANDLED;
 }
 

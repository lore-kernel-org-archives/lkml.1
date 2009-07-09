Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZGICrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZGICrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759179AbZGICqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:46:39 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53356 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789AbZGICqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HviESPyc/IcqrZQwr9xQNklMlA2RYUo5I8l7ouW0s0Nf+vbEZBUsNNqKfmvJ7370S6
         l8AhUMQC6PrqLRUVxWs444k16gcJOXY0nPQEv7vGSHHz6EGy7wMGx1IDvYh78Eks9gbN
         cBbKlY7PlcHy906EE5/lE3K4iVTyLVxmjaxz0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 2/2] tracing/kmemtrace: Use the %pf format
Date: Thu,  9 Jul 2009 04:46:30 +0200
Message-Id: <1247107590-6428-3-git-send-email-fweisbec@gmail.com>
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
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
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
 
-- 
1.6.2.3


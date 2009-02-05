Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZBEGOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZBEGOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZBEGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:14:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbZBEGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:14:11 -0500
Message-Id: <20090205061408.191066576@goodmis.org>
References: <20090205061335.917484162@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 01:13:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] trace: code style clean up
Content-Disposition: inline; filename=0003-trace-code-style-clean-up.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Ingo Molar suggested using goto logic to keep the indentation
down and to be able to remove the nasty line breaks. This actually
makes the code a bit more readable.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cfc0c3d..6f3cc5c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -522,23 +522,24 @@ int register_tracer(struct tracer *type)
 	tracing_selftest_running = false;
 	mutex_unlock(&trace_types_lock);
 
-	if (!ret && default_bootup_tracer) {
-		if (!strncmp(default_bootup_tracer, type->name,
-			     BOOTUP_TRACER_SIZE)) {
-			printk(KERN_INFO "Starting tracer '%s'\n",
-			       type->name);
-			/* Do we want this tracer to start on bootup? */
-			tracing_set_tracer(type->name);
-			default_bootup_tracer = NULL;
-			/* disable other selftests, since this will break it. */
-			tracing_selftest_disabled = 1;
+	if (ret || !default_bootup_tracer)
+		goto out_unlock;
+
+	if (strncmp(default_bootup_tracer, type->name, BOOTUP_TRACER_SIZE))
+		goto out_unlock;
+
+	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
+	/* Do we want this tracer to start on bootup? */
+	tracing_set_tracer(type->name);
+	default_bootup_tracer = NULL;
+	/* disable other selftests, since this will break it. */
+	tracing_selftest_disabled = 1;
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-			printk(KERN_INFO "Disabling FTRACE selftests due"
-			       " to running tracer '%s'\n", type->name);
+	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
+	       type->name);
 #endif
-		}
-	}
 
+ out_unlock:
 	lock_kernel();
 	return ret;
 }
-- 
1.5.6.5

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbYGKBBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbYGKBBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYGKA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005950.848362449@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/8] ftrace: start wakeup tracing after setting function tracer
Content-Disposition: inline; filename=ftrace-wakeup-enable-tracing-last-on-startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling the wakeup tracer before enabling the function tracing causes
some strange results due to the dynamic enabling of the functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-07-10 12:19:54.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-07-10 12:54:09.000000000 -0400
@@ -352,9 +352,10 @@ static void start_wakeup_tracer(struct t
 	 */
 	smp_wmb();
 
-	tracer_enabled = 1;
 	register_ftrace_function(&trace_ops);
 
+	tracer_enabled = 1;
+
 	return;
 fail_deprobe_wake_new:
 	marker_probe_unregister("kernel_sched_wakeup_new",

-- 

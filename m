Return-Path: <linux-kernel-owner+w=401wt.eu-S1764860AbZATAYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764860AbZATAYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764079AbZATARp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763381AbZATARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:34 -0500
Message-Id: <20090120001732.732175373@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/8] x86, ftrace, hw-branch-tracer: reset trace buffer on close
Content-Disposition: inline; filename=0003-x86-ftrace-hw-branch-tracer-reset-trace-buffer-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

Reset the ftrace buffer on close. Since we use cyclic buffers, the
trace is not contiguous, anyway.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_hw_branches.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index e56df2c..372b47a 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -274,6 +274,11 @@ static void trace_bts_prepare(struct trace_iterator *iter)
 	mutex_unlock(&bts_tracer_mutex);
 }
 
+static void trace_bts_close(struct trace_iterator *iter)
+{
+	tracing_reset_online_cpus(iter->tr);
+}
+
 void trace_hw_branch_oops(void)
 {
 	mutex_lock(&bts_tracer_mutex);
@@ -292,7 +297,8 @@ struct tracer bts_tracer __read_mostly =
 	.print_line	= bts_trace_print_line,
 	.start		= bts_trace_start,
 	.stop		= bts_trace_stop,
-	.open		= trace_bts_prepare
+	.open		= trace_bts_prepare,
+	.close		= trace_bts_close
 };
 
 __init static int init_bts_trace(void)
-- 
1.5.6.5

-- 

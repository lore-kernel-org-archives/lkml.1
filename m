Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZBQSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZBQSWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZBQSVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182125.734313782@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/6] tracing: fix the return value of trace selftest
Content-Disposition: inline; filename=0004-tracing-fix-the-return-value-of-trace-selftest.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

This patch is to fix the return value of trace_selftest_startup_sysprof
and trace_selftest_startup_branch on failure.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_selftest.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 0c9aa14..c72e749 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -622,7 +622,7 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
-		return 0;
+		return ret;
 	}
 
 	/* Sleep for a 1/10 of a second */
@@ -634,6 +634,11 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	trace->reset(tr);
 	tracing_start();
 
+	if (!ret && !count) {
+		printk(KERN_CONT ".. no entries found ..");
+		ret = -1;
+	}
+
 	return ret;
 }
 #endif /* CONFIG_SYSPROF_TRACER */
@@ -661,6 +666,11 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	trace->reset(tr);
 	tracing_start();
 
+	if (!ret && !count) {
+		printk(KERN_CONT ".. no entries found ..");
+		ret = -1;
+	}
+
 	return ret;
 }
 #endif /* CONFIG_BRANCH_TRACER */
-- 
1.5.6.5

-- 

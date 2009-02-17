Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZBQJe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZBQJe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZBQJeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:34:46 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:62426 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZBQJep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:34:45 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 2/3] tracing: fix the return value of trace selftest.
Date: Tue, 17 Feb 2009 01:09:47 -0500
Message-Id: <1234850987-3548-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1234850848-3525-1-git-send-email-wenji.huang@oracle.com>
References: <1234850848-3525-1-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.499A84AF.00FC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix the return value of trace_selftest_startup_sysprof
and trace_selftest_startup_branch on failure.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
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
1.5.6


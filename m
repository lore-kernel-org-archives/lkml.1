Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbZFRLKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbZFRLKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZFRLJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:09:57 -0400
Received: from 82-38-64-26.cable.ubr06.brad.blueyonder.co.uk ([82.38.64.26]:53923
	"EHLO phlog.console-pimps.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757184AbZFRLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:09:57 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 07:09:57 EDT
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, rostedt@goodmis.org,
       Matt Fleming <matt@console-pimps.org>
Subject: [PATCH] tracing: Use DECLARE_COMPLETION_ONSTACK() for stack completion variable
Date: Thu, 18 Jun 2009 12:01:34 +0100
Message-Id: <1245322894-12951-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_completion() is for use with dynamically allocated
completions. The 'isrt' completion is not dynamically allocated but is
allocated on the stack, so use the appropriate macro for lockdep's
benefit.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 kernel/trace/trace_selftest.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 00dd648..45e64e1 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -586,12 +586,10 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
 	unsigned long save_max = tracing_max_latency;
 	struct task_struct *p;
-	struct completion isrt;
+	DECLARE_COMPLETION_ONSTACK(isrt);
 	unsigned long count;
 	int ret;
 
-	init_completion(&isrt);
-
 	/* create a high prio thread */
 	p = kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
 	if (IS_ERR(p)) {
-- 
1.6.3.2.306.g4f4fa


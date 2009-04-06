Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZDFQkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZDFQkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:40:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbZDFQi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:38:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbZDFQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:38:56 -0400
Message-Id: <20090406163831.423179976@goodmis.org>
References: <20090406163706.097842409@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 12:37:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 08/10] ftrace: Add check of sched_stopped for probe_sched_wakeup
Content-Disposition: inline; filename=0008-ftrace-Add-check-of-sched_stopped-for-probe_sched_w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

The wakeup tracing in sched_switch does not stop when a user
disables tracing. This is because the probe_sched_wakeup() is missing
the check to prevent the wakeup from being traced.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <49D1C543.3010307@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_switch.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index de35f20..9117cea 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -62,6 +62,9 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	pc = preempt_count();
 	tracing_record_cmdline(current);
 
+	if (sched_stopped)
+		return;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
-- 
1.6.2.1

-- 

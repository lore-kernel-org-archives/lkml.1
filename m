Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZDGNOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZDGNOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZDGNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:13:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:59392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbZDGNNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:13:46 -0400
Date: Tue, 7 Apr 2009 13:13:09 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49D1C543.3010307@cn.fujitsu.com>
References: <49D1C543.3010307@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Add check of sched_stopped for probe_sched_wakeup
Message-ID: <tip-8bcae09b93e7f96f700b6bb372c2b3f2b36636dc@git.kernel.org>
Git-Commit-ID: 8bcae09b93e7f96f700b6bb372c2b3f2b36636dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bcae09b93e7f96f700b6bb372c2b3f2b36636dc
Gitweb:     http://git.kernel.org/tip/8bcae09b93e7f96f700b6bb372c2b3f2b36636dc
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Tue, 31 Mar 2009 15:24:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:01:11 +0200

ftrace: Add check of sched_stopped for probe_sched_wakeup

The wakeup tracing in sched_switch does not stop when a user
disables tracing. This is because the probe_sched_wakeup() is missing
the check to prevent the wakeup from being traced.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <49D1C543.3010307@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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

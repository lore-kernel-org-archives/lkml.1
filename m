Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYL2SLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYL2SLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 13:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYL2SLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 13:11:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYL2SLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 13:11:10 -0500
Subject: [PATCH] sched: sched.c declare variables before they get used
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 23:39:17 +0530
Message-Id: <1230574157.26564.37.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warnings

In linux/sched.h moved out sysctl_sched_latency, sysctl_sched_min_granularity, sysctl_sched_wakeup_granularity, sysctl_sched_shares_ratelimit and sysctl_sched_shares_thresh from #ifdef CONFIG_SCHED_DEBUG as these variables are common for both.

Fixes these sparse warnings:
kernel/sched.c:825:14: warning: symbol 'sysctl_sched_shares_ratelimit' was not declared. Should it be static?
kernel/sched.c:832:14: warning: symbol 'sysctl_sched_shares_thresh' was not declared. Should it be static?
kernel/sched_fair.c:37:14: warning: symbol 'sysctl_sched_latency' was not declared. Should it be static?
kernel/sched_fair.c:43:14: warning: symbol 'sysctl_sched_min_granularity' was not declared. Should it be static?
kernel/sched_fair.c:72:14: warning: symbol 'sysctl_sched_wakeup_granularity' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/sched.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7eec8ca..272d6b1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1707,16 +1707,16 @@ extern void wake_up_idle_cpu(int cpu);
 static inline void wake_up_idle_cpu(int cpu) { }
 #endif
 
-#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
+extern unsigned int sysctl_sched_shares_ratelimit;
+extern unsigned int sysctl_sched_shares_thresh;
+#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_shares_ratelimit;
-extern unsigned int sysctl_sched_shares_thresh;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
-- 
1.5.5.1




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZLIJwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZLIJwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbZLIJwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:52:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:44953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZLIJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:52:29 -0500
Date: Wed, 9 Dec 2009 09:52:11 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B1F194D.7080306@cn.fujitsu.com>
References: <4B1F194D.7080306@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Clean up __perf_event_init_context()
Message-ID: <tip-aa5452d70c0d559310598b243b8b1033c10056e7@git.kernel.org>
Git-Commit-ID: aa5452d70c0d559310598b243b8b1033c10056e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa5452d70c0d559310598b243b8b1033c10056e7
Gitweb:     http://git.kernel.org/tip/aa5452d70c0d559310598b243b8b1033c10056e7
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 9 Dec 2009 11:28:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 09:56:27 +0100

perf_event: Clean up __perf_event_init_context()

Clean up the code a bit:

 - define 'perf_cpu_context' variable with 'static'
 - use kzalloc() instead of kmalloc() and memset()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B1F194D.7080306@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3b0cf86..2b06c45 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -36,7 +36,7 @@
 /*
  * Each CPU has a list of per CPU events:
  */
-DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 
 int perf_max_events __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
@@ -1579,7 +1579,6 @@ static void
 __perf_event_init_context(struct perf_event_context *ctx,
 			    struct task_struct *task)
 {
-	memset(ctx, 0, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->group_list);
@@ -1654,7 +1653,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	}
 
 	if (!ctx) {
-		ctx = kmalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
@@ -5105,7 +5104,7 @@ int perf_event_init_task(struct task_struct *child)
 	 * First allocate and initialize a context for the child.
 	 */
 
-	child_ctx = kmalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+	child_ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
 	if (!child_ctx)
 		return -ENOMEM;
 

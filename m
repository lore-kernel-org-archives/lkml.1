Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZLID3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZLID3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 22:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZLID3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 22:29:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZLID3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 22:29:50 -0500
Message-ID: <4B1F194D.7080306@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 11:28:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf_event: cleanup for __perf_event_init_context()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch and does:
- define 'perf_cpu_context' variable with 'static'
- using kzalloc() instead of kmalloc() and memset()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_event.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 08f5718..fbebe7b 100644
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
 	raw_spin_lock_init(&ctx->lock);
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
 
-- 
1.6.1.2


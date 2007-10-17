Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXJQTI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXJQTI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932485AbXJQTFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:05:05 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53182
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757657AbXJQTFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:05:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 8/9] RT: Fixes for push-rt patch
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 17 Oct 2007 14:51:08 -0400
Message-ID: <20071017185108.11272.42107.stgit@novell1.haskins.net>
In-Reply-To: <20071017184745.11272.10024.stgit@novell1.haskins.net>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Steve found these errors in the original patch

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    2 +-
 kernel/sched_rt.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0ee1e21..8c916de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1536,7 +1536,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 		for_each_cpu_mask(cpu, cpu_mask) {
 			struct rq *rq = &per_cpu(runqueues, cpu);
 
-			if (cpu == smp_processor_id())
+			if (cpu == this_rq->cpu)
 				continue;
 
 			/* We look for lowest RT prio or non-rt CPU */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8d59e62..04959fe 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -115,7 +115,7 @@ static struct task_struct *rt_next_highest_task(struct rq *rq)
 
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
-	if (unlikely(next != current))
+	if (unlikely(next != rq->curr))
 		return next;
 
 	if (queue->next->next != queue) {


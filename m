Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXKFAw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXKFAw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbXKFAuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:40 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25188 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755541AbXKFAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:34 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/8] RT: Allow current_cpu to be included in search
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:48:53 -0700
Message-ID: <20071105234853.25451.34622.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't hurt if we allow the current CPU to be included in the
search.  We will just simply skip it later if the current CPU turns out
to be the lowest.

We will use this later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fbe7b8a..7dd67db 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -326,9 +326,6 @@ static int find_lowest_rq(struct task_struct *task)
 	for_each_cpu_mask(cpu, cpu_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
-		if (cpu == rq->cpu)
-			continue;
-
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
 			lowest_rq = rq;
@@ -356,7 +353,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
 		cpu = find_lowest_rq(task);
 
-		if (cpu == -1)
+		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
 
 		lowest_rq = cpu_rq(cpu);


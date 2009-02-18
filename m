Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZBRMRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZBRMRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZBRMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:17:13 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:46088 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZBRMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=wJAhEuNzVn6cZC+we53muj3oSH2Zj/Kh6HK6QnNRJzBRODmd+MESCD1dAT4c6WeX7C
         hhl5vfKQ1TyGZadSzHzdu2ZOKZK2i26oZ9wGcjM1/n8eh8cX7EX1fm5QKwWXON57Pdx/
         YTDw9iPv+nGeztfCjoX8Giu4LpsfwjLcHyvGQ=
Date: Wed, 18 Feb 2009 21:16:57 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perfcounters: clean up rotate_percpu
Message-Id: <20090218211657.38bf3f38.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo implemented rotate function at 235c7fc7c500e4fd1700c4ad01b5612bcdc1b449.
I think he want to implement rotate_percpu but he don't implement it yet.

If we need not it immediately, 
It would be better to remove it until we will need it again.

 Signed-off-by: MinChan Kim <minchan.kim@gmail.com>

---
 kernel/perf_counter.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ad62965..007b219 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -972,18 +972,9 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
-	const int rotate_percpu = 0;
 
-	if (rotate_percpu)
-		perf_counter_cpu_sched_out(cpuctx);
 	perf_counter_task_sched_out(curr, cpu);
-
-	if (rotate_percpu)
-		rotate_ctx(&cpuctx->ctx);
 	rotate_ctx(ctx);
-
-	if (rotate_percpu)
-		perf_counter_cpu_sched_in(cpuctx, cpu);
 	perf_counter_task_sched_in(curr, cpu);
 }
 
-- 
1.5.4.3


-- 
Kinds Regards
MinChan Kim

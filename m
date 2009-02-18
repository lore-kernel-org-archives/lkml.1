Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZBRM2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZBRM2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZBRM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:27:53 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:46552 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZBRM1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:27:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=LxDBWwe0rcxItxugAkl0Fe7/j3NylRyOGWufzvnoHLYotdvB9Z8LcMJr7HlcoEI7uC
         1pUSroRuXptU7duT5+n+/64fuAJWE2icbSvCtZ10TeETTsVo08QhHmss5ZTn1JgRYdt1
         BxqcFhZLU/tfI79AKybMXByW0I7c96MveGBFI=
Date: Wed, 18 Feb 2009 21:27:30 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] perfcounters: clean up rotate_percpu
Message-Id: <20090218212730.dde6942b.minchan.kim@barrios-desktop>
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
 kernel/perf_counter.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ad62965..211b13b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -970,20 +970,10 @@ static void rotate_ctx(struct perf_counter_context *ctx)
 
 void perf_counter_task_tick(struct task_struct *curr, int cpu)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
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

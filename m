Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0CELDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 06:03:17 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:45143 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab0CELDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 06:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sAvq3mNgbpcDD4vxgeJv6HirSsyT6XTTlDrMman5TlwrpFz6pSjuX8LILrRZ8+8tVg
         E7owoWL6MfE+0JS9WDiBzL8Ihitv4KXfZebiYVLm9I6qyBu7K4tRdqt+kiZOT4/sn8lA
         ZYr1IvUxBnieHmdxPg2J3qyGn/SKmFv4mb8hA=
Subject: [PATCH] sched_fair: add schedule equal check condition
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 19:03:10 +0800
Message-ID: <1267786990.2576.6.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
in check_preempt_tick() function, the check schedule condition,the reality increasing runtime 
"delta_exec", vruntion increasing runtime "delta" and reality ideal time "ideal_runtime":
	if (delta_exec > ideal_runtime)
and
	if (delta > ideal_runtime)
if equal, it had better be schedule.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8fe7ee8..65fd43e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -859,7 +859,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime) {
+	if (delta_exec >= ideal_runtime) {
 		resched_task(rq_of(cfs_rq)->curr);
 		/*
 		 * The current task ran long enough, ensure it doesn't get
@@ -884,7 +884,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
-		if (delta > ideal_runtime)
+		if (delta >= ideal_runtime)
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }



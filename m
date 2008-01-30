Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbYA3QAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbYA3QAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYA3P7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:59:52 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:13095 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYA3P7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=j3dtUoVJRtsLaRrdhQetXnw0iCSIJ8N5UQPFkCY9zCbcVGKpEEVEauX0rB/t6agqdRLYsc81sSihfxfN5YwvsiWd64uqBtbWNMequpNehBsCi0t2W5ZahaH/hrJeDyJccf4/1gf6gJCDcAReeOokD2gnaK7JVjP2c6ZFCYefcNg=
Date: Wed, 30 Jan 2008 10:54:30 -0500 (EST)
X-X-Sender: gstralko@buckthorn.lexi.com
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: remove unused params
Message-ID: <alpine.LRH.1.00.0801301048570.23744@buckthorn.lexi.com>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Gerald Stralko <gerb.stralko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the extra struct task_struct *p parameter in inc_nr_running 
and dec_nr_running functions.

Signed-off by: Jerry Stralko <gerb.stralko@gmail.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index ba4c880..8355e00 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1255,12 +1255,12 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
 #define sched_class_highest (&rt_sched_class)
 
-static void inc_nr_running(struct task_struct *p, struct rq *rq)
+static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
 }
 
-static void dec_nr_running(struct task_struct *p, struct rq *rq)
+static void dec_nr_running(struct rq *rq)
 {
 	rq->nr_running--;
 }
@@ -1354,7 +1354,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(p, rq);
+	inc_nr_running(rq);
 }
 
 /*
@@ -1366,7 +1366,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(p, rq);
+	dec_nr_running(rq);
 }
 
 /**
@@ -2006,7 +2006,7 @@ void fastcall wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(p, rq);
+		inc_nr_running(rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP

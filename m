Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbYDYRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbYDYRxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYDYRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:53:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:40621 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbYDYRxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k510m4/rg97+2tLyHwLXblzFZamNe3wG7/nuRAQ8N6hIdTkI6WeRL/BP29erT0McVJHthC8IlhghZsSzDTACJjaQIXFpSxKAh6tu6DMKpc9igjexxYuudKr0bz/dPHjOIKwep8zRXguLMqlNG8pRqj/tG4V42dTmJx4KG1zV30Q=
Subject: [PATCH] sched: make rt_sched_class, idle_sched_class static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 10:53:13 -0700
Message-Id: <1209145993.20088.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C files are included directly in sched.c, so they are
effectively static.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/sched_idletask.c                          |    2 +-
 kernel/sched_rt.c                                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 2bcafa3..3a4f92d 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -99,7 +99,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
-const struct sched_class idle_sched_class = {
+static const struct sched_class idle_sched_class = {
 	/* .next is NULL */
 	/* no enqueue/yield_task for idle tasks */
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c2730a5..dcd6495 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1309,7 +1309,7 @@ static void set_curr_task_rt(struct rq *rq)
 	p->se.exec_start = rq->clock;
 }
 
-const struct sched_class rt_sched_class = {
+static const struct sched_class rt_sched_class = {
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
-- 
1.5.5.1.270.g89765




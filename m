Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471Ab0AQSbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0AQSbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0AQSbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:31:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:34339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab0AQSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:31:48 -0500
Date: Sun, 17 Jan 2010 18:31:04 GMT
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, hartleys@visionengravers.com, tglx@linutronix.de,
       hsweeten@visionengravers.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, hartleys@visionengravers.com,
       hsweeten@visionengravers.com, mingo@elte.hu
In-Reply-To: <201001132021.53253.hartleys@visionengravers.com>
References: <201001132021.53253.hartleys@visionengravers.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don't expose local functions
Message-ID: <tip-6d686f4564f3fc7c6e678852919e48ad331d276b@git.kernel.org>
Git-Commit-ID: 6d686f4564f3fc7c6e678852919e48ad331d276b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 18:31:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d686f4564f3fc7c6e678852919e48ad331d276b
Gitweb:     http://git.kernel.org/tip/6d686f4564f3fc7c6e678852919e48ad331d276b
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Wed, 13 Jan 2010 20:21:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 08:09:45 +0100

sched: Don't expose local functions

kernel/sched: don't expose local functions

The get_rr_interval_* functions are all class methods of
struct sched_class. They are not exported so make them
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <201001132021.53253.hartleys@visionengravers.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |    2 +-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..7177860 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2076,7 +2076,7 @@ static void moved_group_fair(struct task_struct *p, int on_rq)
 }
 #endif
 
-unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
 	unsigned int rr_interval = 0;
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 5f93b57..01332bf 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..072b3fc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1721,7 +1721,7 @@ static void set_curr_task_rt(struct rq *rq)
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
+static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks

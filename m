Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZC2CEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZC2CEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZC2CEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:08 -0400
Received: from ozlabs.org ([203.10.76.45]:46555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZC2CEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:05 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 9/10] cpumask: remove cpumask_t from core
Message-Id: <20090329020401.382AADDE9E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

struct cpumask is nicer, and we use it to make where we've made code
safe for CONFIG_CPUMASK_OFFSTACK=y.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched_cpupri.h |    2 +-
 kernel/stop_machine.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -25,7 +25,7 @@ struct cpupri {
 
 #ifdef CONFIG_SMP
 int  cpupri_find(struct cpupri *cp,
-		 struct task_struct *p, cpumask_t *lowest_mask);
+		 struct task_struct *p, struct cpumask *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp, bool bootmem);
 void cpupri_cleanup(struct cpupri *cp);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -44,7 +44,7 @@ static int refcount;
 static int refcount;
 static struct workqueue_struct *stop_machine_wq;
 static struct stop_machine_data active, idle;
-static const cpumask_t *active_cpus;
+static const struct cpumask *active_cpus;
 static void *stop_machine_work;
 
 static void set_state(enum stopmachine_state newstate)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZGJKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZGJKmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZGJKlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:41:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:53260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZGJKlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:41:50 -0400
Date: Fri, 10 Jul 2009 10:41:14 GMT
From: tip-bot for Lucas De Marchi <lucas.de.marchi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, lucas.de.marchi@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lucas.de.marchi@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
References: <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
Subject: [tip:sched/urgent] sched: Reset sched stats on fork()
Message-ID: <tip-7793527b90d9418211f4fe8464cc1dcb1631ea1b@git.kernel.org>
Git-Commit-ID: 7793527b90d9418211f4fe8464cc1dcb1631ea1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:41:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7793527b90d9418211f4fe8464cc1dcb1631ea1b
Gitweb:     http://git.kernel.org/tip/7793527b90d9418211f4fe8464cc1dcb1631ea1b
Author:     Lucas De Marchi <lucas.de.marchi@gmail.com>
AuthorDate: Thu, 9 Jul 2009 13:57:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:43:29 +0200

sched: Reset sched stats on fork()

The sched_stat fields are currently not reset upon fork.
Ingo's recent commit 6c594c21fcb02c662f11c97be4d7d2b73060a205
did reset nr_migrations, but it didn't reset any of the
others.

This patch resets all sched_stat fields on fork.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   40 +++++++++++++++++++++++++++++++---------
 1 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a17f3d9..c4549bd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2572,15 +2572,37 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start		= 0;
-	p->se.sum_sleep_runtime		= 0;
-	p->se.sleep_start		= 0;
-	p->se.block_start		= 0;
-	p->se.sleep_max			= 0;
-	p->se.block_max			= 0;
-	p->se.exec_max			= 0;
-	p->se.slice_max			= 0;
-	p->se.wait_max			= 0;
+	p->se.wait_start			= 0;
+	p->se.wait_max				= 0;
+	p->se.wait_count			= 0;
+	p->se.wait_sum				= 0;
+
+	p->se.sleep_start			= 0;
+	p->se.sleep_max				= 0;
+	p->se.sum_sleep_runtime			= 0;
+
+	p->se.block_start			= 0;
+	p->se.block_max				= 0;
+	p->se.exec_max				= 0;
+	p->se.slice_max				= 0;
+
+	p->se.nr_migrations_cold		= 0;
+	p->se.nr_failed_migrations_affine	= 0;
+	p->se.nr_failed_migrations_running	= 0;
+	p->se.nr_failed_migrations_hot		= 0;
+	p->se.nr_forced_migrations		= 0;
+	p->se.nr_forced2_migrations		= 0;
+
+	p->se.nr_wakeups			= 0;
+	p->se.nr_wakeups_sync			= 0;
+	p->se.nr_wakeups_migrate		= 0;
+	p->se.nr_wakeups_local			= 0;
+	p->se.nr_wakeups_remote			= 0;
+	p->se.nr_wakeups_affine			= 0;
+	p->se.nr_wakeups_affine_attempts	= 0;
+	p->se.nr_wakeups_passive		= 0;
+	p->se.nr_wakeups_idle			= 0;
+
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);

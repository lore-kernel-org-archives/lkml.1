Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZLTWer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZLTWer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 17:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZLTWeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 17:34:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:45266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZLTWep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 17:34:45 -0500
Date: Sun, 20 Dec 2009 22:33:36 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, sachinp@in.ibm.com,
       jens.axboe@oracle.com, benh@kernel.crashing.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, sachinp@in.ibm.com,
       jens.axboe@oracle.com, benh@kernel.crashing.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1261326987.4314.24.camel@laptop>
References: <1261326987.4314.24.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix hotplug hang
Message-ID: <tip-70f1120527797adb31c68bdc6f1b45e182c342c7@git.kernel.org>
Git-Commit-ID: 70f1120527797adb31c68bdc6f1b45e182c342c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70f1120527797adb31c68bdc6f1b45e182c342c7
Gitweb:     http://git.kernel.org/tip/70f1120527797adb31c68bdc6f1b45e182c342c7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 20 Dec 2009 17:36:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Dec 2009 23:31:23 +0100

sched: Fix hotplug hang

The hot-unplug kstopmachine usage does a wakeup after
deactivating the cpu, hence we cannot use cpu_active()
here but must rely on the good olde online.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <1261326987.4314.24.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7ffde2a..87f1f47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2346,7 +2346,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu)))
+		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;

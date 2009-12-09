Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZLIKPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZLIKPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZLIKPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:15:31 -0500
Received: from www.tglx.de ([62.245.132.106]:40007 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZLIKPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:15:22 -0500
Message-Id: <20091209100706.827251164@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 10:15:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 3/4] sched: Rename bogus label in sched_setaffinity()
References: <20091209100540.511353305@linutronix.de>
Content-Disposition: inline; filename=sched-fix-bogus-label.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

out_unlock: is bogus as there is nothing to unlock. Rename it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6558,11 +6558,11 @@ long sched_setaffinity(pid_t pid, const 
 	}
 	retval = -EPERM;
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
-		goto out_unlock;
+		goto out_free;
 
 	retval = security_task_setscheduler(p, 0, NULL);
 	if (retval)
-		goto out_unlock;
+		goto out_free;
 
 	cpuset_cpus_allowed(p, cpus_allowed);
 	cpumask_and(new_mask, in_mask, cpus_allowed);
@@ -6581,7 +6581,7 @@ long sched_setaffinity(pid_t pid, const 
 			goto again;
 		}
 	}
-out_unlock:
+out_free:
 	free_cpumask_var(new_mask);
 out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);



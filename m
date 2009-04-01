Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbZDAQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbZDAQEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762172AbZDAQE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:04:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:34984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304AbZDAQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:04:25 -0400
Date: Wed, 1 Apr 2009 16:03:26 GMT
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
Subject: [tip:sched/urgent] sched: Print sched_group::__cpu_power in sched_domain_debug
Message-ID: <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org>
Git-Commit-ID: 46e0bb9c12f4bab539736f1714cbf16600f681ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 16:03:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46e0bb9c12f4bab539736f1714cbf16600f681ec
Gitweb:     http://git.kernel.org/tip/46e0bb9c12f4bab539736f1714cbf16600f681ec
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Mon, 30 Mar 2009 10:25:20 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 17:58:03 +0200

sched: Print sched_group::__cpu_power in sched_domain_debug

Impact: extend debug info /proc/sched_debug

If the user changes the value of the sched_mc/smt_power_savings sysfs
tunable, it'll trigger a rebuilding of the whole sched_domain tree,
with the SD_POWERSAVINGS_BALANCE flag set at certain levels.

As a result, there would be a change in the __cpu_power of sched_groups
in the sched_domain hierarchy.

Print the __cpu_power values for each sched_group in sched_domain_debug
to help verify this change and correlate it with the change in the
load-balancing behavior.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8d1bdbe..6234d10 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6963,7 +6963,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %s (__cpu_power = %d)", str,
+						group->__cpu_power);
 
 		group = group->next;
 	} while (group != sd->groups);

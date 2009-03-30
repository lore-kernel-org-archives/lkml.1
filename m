Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZC3Ezl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZC3Ezl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZC3Ez1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:55:27 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41633 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZC3Ez0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:55:26 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] sched: Print sched_group::__cpu_power in sched_domain_debug.
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Mon, 30 Mar 2009 10:25:20 +0530
Message-ID: <20090330045520.2869.24777.stgit@sofia.in.ibm.com>
In-Reply-To: <20090330045321.2869.9284.stgit@sofia.in.ibm.com>
References: <20090330045321.2869.9284.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user changes the value of the sched_mc/smt_power_savings sysfs tunable,
it'll trigger a rebuilding of the whole sched_domain tree, with the
SD_POWERSAVINGS_BALANCE flag set at certain levels.

As a result, there would be a change in the __cpu_power of sched_groups
in the sched_domain hierarchy.

Print the __cpu_power values for each sched_group in sched_domain_debug
to help verify this change and correlate it with the change in the
load-balancing behavior.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 706517c..fbac83b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7363,7 +7363,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %s (__cpu_power = %d)", str,
+						group->__cpu_power);
 
 		group = group->next;
 	} while (group != sd->groups);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZDNSnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZDNSnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbZDNSnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:43:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:54105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbZDNSnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:43:09 -0400
Date: Tue, 14 Apr 2009 18:42:33 GMT
From: tip-bot for Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tony.luck@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
       mingo@elte.hu
In-Reply-To: <20090414033936.GA534@in.ibm.com>
References: <20090414033936.GA534@in.ibm.com>
Subject: [tip:sched/urgent] sched: Avoid printing sched_group::__cpu_power for default case
Message-ID: <tip-728fc565bdfc98dc7086fdcccb3f1e1edf195b20@git.kernel.org>
Git-Commit-ID: 728fc565bdfc98dc7086fdcccb3f1e1edf195b20
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 18:42:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  728fc565bdfc98dc7086fdcccb3f1e1edf195b20
Gitweb:     http://git.kernel.org/tip/728fc565bdfc98dc7086fdcccb3f1e1edf195b20
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Tue, 14 Apr 2009 09:09:36 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 20:39:40 +0200

sched: Avoid printing sched_group::__cpu_power for default case

Impact: reduce syslog clutter

Commit 46e0bb9c12f4 ("sched: Print sched_group::__cpu_power
in sched_domain_debug") produces a messy dmesg output while
attempting to print the sched_group::__cpu_power for each
group in the sched_domain hierarchy.

Fix this by avoid printing the __cpu_power for default cases.
(i.e, __cpu_power == SCHED_LOAD_SCALE).

Reported-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Fixed-by: Tony Luck <tony.luck@intel.com>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <20090414033936.GA534@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e90e70e..b902e58 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7367,8 +7367,12 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s (__cpu_power = %d)", str,
-						group->__cpu_power);
+
+		printk(KERN_CONT " %s", str);
+		if (group->__cpu_power != SCHED_LOAD_SCALE) {
+			printk(KERN_CONT " (__cpu_power = %d)",
+				group->__cpu_power);
+		}
 
 		group = group->next;
 	} while (group != sd->groups);

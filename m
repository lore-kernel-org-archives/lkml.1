Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYE2PYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYE2PYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYE2PYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:24:41 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:36241 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYE2PYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:24:40 -0400
Date: Thu, 29 May 2008 20:56:32 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: Print the sd->level in sched_domain_debug code
Message-ID: <20080529152632.GB28006@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Print the sd->level in sched_domain_debug code

From: Gautham R Shenoy <ego@in.ibm.com>

While printing out the visual representation of the sched-domains, print
the level (MC, SMT, CPU, NODE, ... ) of each of the sched_domains.

Credit: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)


diff --git a/kernel/sched.c b/kernel/sched.c
index 1846451..7b81114 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6638,6 +6638,28 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SCHED_DEBUG
 
+static inline const char *sd_level_to_string(enum sched_domain_level lvl)
+{
+	switch (lvl) {
+	case SD_LV_NONE:
+			return "NONE";
+	case SD_LV_SIBLING:
+			return "SIBLING";
+	case SD_LV_MC:
+			return "MC";
+	case SD_LV_CPU:
+			return "CPU";
+	case SD_LV_NODE:
+			return "NODE";
+	case SD_LV_ALLNODES:
+			return "ALLNODES";
+	case SD_LV_MAX:
+			return "MAX";
+
+	}
+	return "MAX";
+}
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  cpumask_t *groupmask)
 {
@@ -6657,7 +6679,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s\n", str);
+	printk(KERN_CONT "span %s level %s\n",
+		str, sd_level_to_string(sd->level));
 
 	if (!cpu_isset(cpu, sd->span)) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
-- 
Thanks and Regards
gautham

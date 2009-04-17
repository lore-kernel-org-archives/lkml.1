Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZDQA7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZDQA7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZDQA7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:59:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZDQA7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:59:22 -0400
Date: Fri, 17 Apr 2009 02:59:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090417005911.GA6815@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Gautham R Shenoy (1):
      sched: Avoid printing sched_group::__cpu_power for default case

Lai Jiangshan (1):
      tracing, sched: mark get_parent_ip() notrace


 kernel/sched.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5724508..b902e58 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4846,7 +4846,7 @@ void scheduler_tick(void)
 #endif
 }
 
-unsigned long get_parent_ip(unsigned long addr)
+notrace unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
 		addr = CALLER_ADDR2;
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

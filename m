Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZAELKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZAELKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZAELJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:09:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZAELIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:08:50 -0500
Message-ID: <4961EA06.7070002@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 19:07:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: cleanup for arch_reinit_sched_domains()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

- Make arch_reinit_sched_domains() static. It was exported to be used in
  s390, but now rebuild_sched_domains() is used instead.

- Make it return void.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |    9 +++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 38a3f4b..91207df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -912,7 +912,6 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 
 extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 				    struct sched_domain_attr *dattr_new);
-extern int arch_reinit_sched_domains(void);
 
 /* Test a flag in parent sched domain */
 static inline int test_sd_parent(struct sched_domain *sd, int flag)
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a8e296..c5019a5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7987,7 +7987,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-int arch_reinit_sched_domains(void)
+static void arch_reinit_sched_domains(void)
 {
 	get_online_cpus();
 
@@ -7996,13 +7996,10 @@ int arch_reinit_sched_domains(void)
 
 	rebuild_sched_domains();
 	put_online_cpus();
-
-	return 0;
 }
 
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 {
-	int ret;
 	unsigned int level = 0;
 
 	if (sscanf(buf, "%u", &level) != 1)
@@ -8023,9 +8020,9 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	else
 		sched_mc_power_savings = level;
 
-	ret = arch_reinit_sched_domains();
+	arch_reinit_sched_domains();
 
-	return ret ? ret : count;
+	return count;
 }
 
 #ifdef CONFIG_SCHED_MC
-- 
1.5.4.rc3


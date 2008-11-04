Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYKDISi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYKDISi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKDIS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:18:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYKDIS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:18:29 -0500
Message-ID: <491004A9.70803@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:15:37 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched debug: remove sd_level_to_string()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use sd->name.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index bf75a5e..baa7e4b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6622,28 +6622,6 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SCHED_DEBUG
 
-static inline const char *sd_level_to_string(enum sched_domain_level lvl)
-{
-	switch (lvl) {
-	case SD_LV_NONE:
-			return "NONE";
-	case SD_LV_SIBLING:
-			return "SIBLING";
-	case SD_LV_MC:
-			return "MC";
-	case SD_LV_CPU:
-			return "CPU";
-	case SD_LV_NODE:
-			return "NODE";
-	case SD_LV_ALLNODES:
-			return "ALLNODES";
-	case SD_LV_MAX:
-			return "MAX";
-
-	}
-	return "MAX";
-}
-
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  cpumask_t *groupmask)
 {
@@ -6663,8 +6641,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n",
-		str, sd_level_to_string(sd->level));
+	printk(KERN_CONT "span %s level %s\n", str, sd->name);
 
 	if (!cpu_isset(cpu, sd->span)) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
-- 
1.5.4.rc3

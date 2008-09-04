Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYIDNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYIDNx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYIDNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:59 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:59168
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756628AbYIDNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/4] sched: make task_hot() once again use sd->cache_hot_time
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, mingo@elte.hu
Date: Thu, 04 Sep 2008 09:50:34 -0400
Message-ID: <20080904135034.26109.79306.stgit@dev.haskins.net>
In-Reply-To: <20080904134959.26109.90529.stgit@dev.haskins.net>
References: <20080904134959.26109.90529.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fd28b64..b5f8640 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1778,6 +1778,7 @@ static int
 task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
+	s64 migration_cost = (s64)(sd ? sd->cache_hot_time : sysctl_sched_migration_cost);
 
 	/*
 	 * Buddy candidates are cache hot:
@@ -1788,14 +1789,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	if (p->sched_class != &fair_sched_class)
 		return 0;
 
-	if (sysctl_sched_migration_cost == -1)
-		return 1;
-	if (sysctl_sched_migration_cost == 0)
-		return 0;
-
 	delta = now - p->se.exec_start;
 
-	return delta < (s64)sysctl_sched_migration_cost;
+	return delta < migration_cost;
 }
 
 


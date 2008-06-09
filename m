Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYFIIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYFIIOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYFIIO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:14:28 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19901 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755476AbYFIIO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:14:27 -0400
Date: Mon, 9 Jun 2008 17:12:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Kill off dead cfs_rq_set_shares().
Message-ID: <20080609081224.GA11751@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building with CONFIG_FAIR_GROUP_SCHED=y on UP results in an unused
cfs_rq_set_shares() reference. As nothing is using this dummy function
in the first place, just kill it off.

Against current git, but still seems to be relevant to 'sched-devel' in
-tip.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/sched.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index bfb8ad8..25de9ef 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1471,16 +1471,8 @@ static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
 static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-#else /* CONFIG_SMP */
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
-{
-}
 #endif
 
-#endif /* CONFIG_SMP */
-
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"

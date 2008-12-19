Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYLSAfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYLSAfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYLSAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:34:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:52730 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYLSAe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:34:56 -0500
Message-ID: <494AEC2F.4050103@ct.jp.nec.com>
Date: Thu, 18 Dec 2008 16:34:55 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] sched: use cpumask_first() to fix compiler warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Use cpumask_first() and sched_group_cpus().

  CC      kernel/sched.o
kernel/sched.c: In function 'find_busiest_group':
kernel/sched.c:3429: warning: passing argument 1 of '__first_cpu' from incompatible pointer type

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b4dc4d..e75d6ed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3426,7 +3426,7 @@ out_balanced:
 		*imbalance = min_load_per_task;
 		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
 			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-					first_cpu(group_leader->cpumask);
+				cpumask_first(sched_group_cpus(group_leader));
 		}
 		return group_min;
 	}
-- 
1.6.0.4


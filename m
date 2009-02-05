Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZBEXgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZBEXgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBEXgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:36:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:29218 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZBEXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:36:23 -0500
Message-ID: <498B77F6.4020702@ct.jp.nec.com>
Date: Thu, 05 Feb 2009 15:36:22 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] sched_rt: don't start timer when rt bandwidth disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: fix incorrect condition check

No need to start rt bandwidth timer when rt bandwidth is disabled.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1e965b7..4c03c88 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -223,7 +223,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	ktime_t now;
 
-	if (rt_bandwidth_enabled() && rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
 	if (hrtimer_active(&rt_b->rt_period_timer))
-- 
1.6.1.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYIVRGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYIVRGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYIVRGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:06:23 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41163 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYIVRGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:06:23 -0400
Message-ID: <48D7D081.8060807@nortel.com>
Date: Mon, 22 Sep 2008 11:06:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, mingo@elte.hu
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] sched: fix list traversal to use _rcu variant
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2008 17:06:13.0080 (UTC) FILETIME=[8458E580:01C91CD5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Friesen    <cfriesen@nortel.com>

load_balance_fair() calls rcu_read_lock() but then traverses the list
 using the regular list traversal routine.  This patch converts the
list traversal to use the _rcu version.

Signed-off-by: Chris Friesen <cfriesen@nortel.com>
Approval token "Nortel-02-July-2008-01"
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>

---

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..3c8f631 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1507,7 +1507,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	rcu_read_lock();
 	update_h_load(busiest_cpu);
 
-	list_for_each_entry(tg, &task_groups, list) {
+	list_for_each_entry_rcu(tg, &task_groups, list) {
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
 		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;

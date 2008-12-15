Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYLOG1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYLOG1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 01:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYLOG1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 01:27:07 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57347 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYLOG1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 01:27:04 -0500
Date: Mon, 15 Dec 2008 11:56:48 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: Use RCU variant of list traversal in
	for_each_leaf_rt_rq()
Message-ID: <20081215062648.GB4337@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Use RCU variant of list traversal in for_each_leaf_rt_rq()

for_each_leaf_rt_rq() walks an RCU protected list (rq->leaf_rt_rq_list),
but doesn't use list_for_each_entry_rcu(). Fix this.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched_rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -77,7 +77,7 @@ static inline u64 sched_rt_period(struct
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
-	list_for_each_entry(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
+	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {

Regards,
Bharata.

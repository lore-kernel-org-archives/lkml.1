Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbXDISKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbXDISKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXDISKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:10:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:13326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXDISKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:10:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="70846712:sNHT22234320"
Date: Mon, 9 Apr 2007 11:08:53 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: [patch] sched: align rq to cacheline boundary
Message-ID: <20070409180853.GC3948@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Align the per cpu runqueue to the cacheline boundary. This will minimize the
number of cachelines touched during remote wakeup.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index b9a6837..eca33c5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,7 +278,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues);
+static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
 
 static inline int cpu_of(struct rq *rq)
 {

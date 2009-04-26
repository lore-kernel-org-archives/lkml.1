Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZDZUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZDZUqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZDZUqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:46:38 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41371 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbZDZUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:46:37 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 1/3] sched: add more levels of sched_mc
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 27 Apr 2009 02:16:44 +0530
Message-ID: <20090426204644.17495.8214.stgit@drishya.in.ibm.com>
In-Reply-To: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add few more levels to sched_mc for cpu evacuation.
These levels will try to keep CPU cores free in order
to reduce power consumption.

sched_mc=3 to 5 enables cpu evacuation

** This is a RFC patch for discussion ***

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/sched.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..8b27295 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -788,6 +788,10 @@ enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_WAKEUP,	/* Also bias task wakeups to semi-idle
 					 * cpu package for power savings
 					 */
+	POWERSAVINGS_INCREASE_GROUP_CAPACITY_1, /* 1*imbalalance_pct = 125% */
+	POWERSAVINGS_INCREASE_GROUP_CAPACITY_2, /* 2*imbalalance_pct = 150% */
+	POWERSAVINGS_INCREASE_GROUP_CAPACITY_3, /* 4*imbalalance_pct = 200% */
+
 	MAX_POWERSAVINGS_BALANCE_LEVELS
 };
 


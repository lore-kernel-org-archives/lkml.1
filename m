Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYKUI2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYKUI2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYKUI2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:28:06 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58306 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYKUI2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:28:04 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 7/7] sched: fine-tune SD_MC_INIT -- revert
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2008 14:01:54 +0530
Message-ID: <20081121083154.27075.71015.stgit@drishya.in.ibm.com>
In-Reply-To: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
References: <20081121082533.27075.12056.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 14800984706bf6936bbec5187f736e928be5c218
    Author: Mike Galbraith <efault@gmx.de>
    Date:   Fri Nov 7 15:26:50 2008 +0100

    Reverting this patch for now since this affects
    consolidation and power savings.  Will rework
    this tuning in the next iteration.

    Tune SD_MC_INIT the same way as SD_CPU_INIT:
    unset SD_BALANCE_NEWIDLE, and set SD_WAKE_BALANCE.

    This improves vmark by 5%:

    vmark         132102 125968 125497 messages/sec    avg 127855.66    .984
    vmark         139404 131719 131272 messages/sec    avg 134131.66   1.033

    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 2565f4a..b1551d4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -120,10 +120,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\


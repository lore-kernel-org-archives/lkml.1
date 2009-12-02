Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZLBUKX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 2 Dec 2009 15:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZLBUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:10:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41504 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZLBUKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:10:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: make RCU's CPU-stall detector be default
Date: Wed,  2 Dec 2009 12:10:16 -0800
Message-Id: <12597846162906-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091202200955.GA12950@linux.vnet.ibm.com>
References: <20091202200955.GA12950@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The RCU_CPU_STALL_DETECTOR costs almost nothing and has located some bugs
that might otherwise have been difficult to track down.  Make it be default
for the TREE RCU implementations.  (TINY_RCU does not support CPU-stall
detection, but then again it is a uniprocessor...)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8911558..50e0e78 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -749,7 +749,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default n
+	default y
 	help
 	  This option causes RCU to printk information on which
 	  CPUs are delaying the current grace period, but only when
-- 
1.5.2.5


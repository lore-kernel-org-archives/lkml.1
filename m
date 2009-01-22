Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZAVBrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZAVBrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 20:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZAVBrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 20:47:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56983 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbZAVBrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 20:47:11 -0500
Message-ID: <4977CFFE.2020405@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 09:46:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: remove the old CONFIG_RCU_CPU_STALL_DETECTOR

tree_rcu introduce CONFIG_RCU_CPU_STALL_DETECTOR again.

These two are the same exactly except:
the old one "depends on CLASSIC_RCU"
the new one "depends on CLASSIC_RCU || TREE_RCU"

This patch remove the old one.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c9ae60..e770e85 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU
-	default n
-	help
-	  This option causes RCU to printk information on which
-	  CPUs are delaying the current grace period, but only when
-	  the grace period extends for excessive time periods.
-
-	  Say Y if you want RCU to perform such checks.
-
-	  Say N if you are unsure.
-
-config RCU_CPU_STALL_DETECTOR
-	bool "Check for stalled CPUs delaying RCU grace periods"
 	depends on CLASSIC_RCU || TREE_RCU
 	default n
 	help



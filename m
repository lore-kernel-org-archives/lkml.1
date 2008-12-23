Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLWWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLWWDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 17:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYLWWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 17:03:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40799 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYLWWDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 17:03:37 -0500
Date: Tue, 23 Dec 2008 14:03:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       ralf@linux-mips.org, kernel@wantstofly.org, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: [PATCH, -tip] Remove redundant RCU_CPU_STALL_DETECTOR declaration
Message-ID: <20081223220345.GA16472@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081223215948.GA16137@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223215948.GA16137@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the redundant RCU_CPU_STALL_DETECTOR Kconfig
parameter.  We got one from the classic RCU detector and the other
from the hierarchical RCU detector, this patch merges them.

This patch is suitable for inclusion.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 lib/Kconfig.debug |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 465d822..8bae51a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -608,19 +608,6 @@ config RCU_TORTURE_TEST_RUNNABLE
 
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
-- 
1.5.2.5


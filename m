Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZIVFiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZIVFiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZIVFiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:38:09 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:58734 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZIVFiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:38:09 -0400
Date: Tue, 22 Sep 2009 11:08:09 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v5 RFC PATCH 4/7]: POWER: enable cpuidle for POWER.
Message-ID: <20090922053809.GE6417@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922053314.GA6417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922053314.GA6417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 11:03:14]:

This patch enables the cpuidle option in Kconfig for pSeries.

Currently cpuidle infrastructure is enabled only for x86 and ARM.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -243,6 +243,20 @@ source "kernel/Kconfig.freezer"
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
 
+menu "Power management options"
+
+source "drivers/cpuidle/Kconfig"
+
+config PSERIES_PROCESSOR_IDLE
+	bool "Idle Power Management Support for pSeries"
+	depends on PPC_PSERIES && CPU_IDLE
+	default y
+	help
+	  Idle Power Management Support for pSeries. This hooks onto cpuidle
+	  infrastructure to help in idle cpu power management.
+
+endmenu
+
 menu "Kernel options"
 
 config HIGHMEM

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYIDAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYIDAJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYIDAJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:09:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:48995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYIDAJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:09:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="376477005"
Message-Id: <20080904000238.336231000@linux-os.sc.intel.com>
References: <20080904000237.746216000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 16:58:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [patch 5/5] dmar: fix dmar_parse_dev() devices_cnt error condition check
Content-Disposition: inline; filename=fix_dmar_parse_dev_error_condition_check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: dmar: fix dmar_parse_dev() devices_cnt error condition check

It is possible that,
instead of PCI endpoint/sub-hierarchy structures, only IO-APIC/HPET
devices may be reported under device scope structures. Fix the devices_cnt
error check, which cares about only PCI structures and removes the
dma-remapping unit structure (dmaru) when the devices_cnt is zero
and include_all flag is not set.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-09-03 13:57:28.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-09-03 13:59:12.000000000 -0700
@@ -212,7 +212,7 @@
 		include_all = 1;
 	}
 
-	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all)) {
+	if (ret) {
 		list_del(&dmaru->list);
 		kfree(dmaru);
 	}

-- 


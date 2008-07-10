Return-Path: <linux-kernel-owner+w=401wt.eu-S1762234AbYGJSrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234AbYGJSrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbYGJSmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:47639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758890AbYGJSmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="589105637"
Message-Id: <20080710182236.624134000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yong Y Wang <yong.y.wang@intel.com>
Subject: [patch 05/26] x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
Content-Disposition: inline; filename=fix_dmar_table_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presence of RMRR structures is not compulsory for enabling DMA-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Yong Y Wang <yong.y.wang@intel.com>
---

Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:51:53.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:51:55.000000000 -0700
@@ -419,10 +419,8 @@
 	}
 
 #ifdef CONFIG_DMAR
-	if (list_empty(&dmar_rmrr_units)) {
+	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO PREFIX "No RMRR found\n");
-		return -ENODEV;
-	}
 #endif
 
 	return 0;

-- 


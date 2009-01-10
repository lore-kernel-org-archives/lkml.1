Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbZAJAZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbZAJAZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZAJAYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:30104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbZAJAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="655938477"
Message-Id: <20090110001405.030083000@intel.com>
References: <20090110001308.403550000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 Jan 2009 16:13:13 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       kjwinchester@gmail.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 5/6] x86 PAT: ioremap_wc should take resource_size_t parameter
Content-Disposition: inline; filename=ioremap_wc_resource_size_change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap_wc was taking in unsigned long parameter, where as it should take 64
bit resource_size_t parameter like other ioremap variants.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/io.h |    2 +-
 arch/x86/mm/ioremap.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/io.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io.h	2009-01-09 11:23:10.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/io.h	2009-01-09 13:21:58.000000000 -0800
@@ -91,7 +91,7 @@ extern void unxlate_dev_mem_ptr(unsigned
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
-extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
+extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
 
 /*
  * early_ioremap() and early_iounmap() are for temporary early boot-time
Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c	2009-01-09 11:23:10.000000000 -0800
+++ linux-2.6/arch/x86/mm/ioremap.c	2009-01-09 13:21:58.000000000 -0800
@@ -367,7 +367,7 @@ EXPORT_SYMBOL(ioremap_nocache);
  *
  * Must be freed with iounmap.
  */
-void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
 	if (pat_enabled)
 		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,

-- 


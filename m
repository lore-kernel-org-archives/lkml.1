Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYIWVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYIWVV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYIWVVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:21:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:38240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYIWVVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:21:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="442796889"
Message-Id: <20080923211444.224058000@linux-os.sc.intel.com>
References: <20080923210035.413932000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 14:00:37 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/7] x86, cpa: remove USER permission from the very early identity mapping attribute
Content-Disposition: inline; filename=change_init_pte_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove USER from the PTE/PDE attributes for the very early identity
mapping. We overwrite these mappings with KERNEL attribute later
in the boot. Just being paranoid here as there is no need for USER bit
to be set.

If this breaks something(don't know the history), then we can simply drop
this change.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/include/asm-x86/pgtable.h
===================================================================
--- tip.orig/include/asm-x86/pgtable.h	2008-09-22 15:59:32.000000000 -0700
+++ tip/include/asm-x86/pgtable.h	2008-09-22 15:59:34.000000000 -0700
@@ -148,8 +148,8 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
-#define PTE_IDENT_ATTR	 0x007		/* PRESENT+RW+USER */
-#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 

-- 


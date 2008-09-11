Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYIKVTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYIKVTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYIKVTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:19:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:14161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbYIKVTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:19:18 -0400
X-ExtLoopCount2: 2 from 10.22.226.40
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="615328626"
TrustInternalSourcedMail: True
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="45166176"
Message-Id: <20080911204150.578029000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:50 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/7] x86, cpa: remove USER permission from the very early identity mapping attribute
Content-Disposition: inline; filename=change_init_pte_mapping.patch
X-OriginalArrivalTime: 11 Sep 2008 21:19:17.0631 (UTC) FILETIME=[0C8040F0:01C91454]
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
--- tip.orig/include/asm-x86/pgtable.h	2008-09-11 11:15:53.000000000 -0700
+++ tip/include/asm-x86/pgtable.h	2008-09-11 11:16:04.000000000 -0700
@@ -138,8 +138,8 @@
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


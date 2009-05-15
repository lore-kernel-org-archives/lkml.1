Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbZEOSBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbZEOSBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZEOR7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:59:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2043 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbZEOR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 03/11] arch/m68knommu: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:37 -0700
Message-Id: <4bba2ced6c7b9294db7d415009520fe72d7e6f1e.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/m68knommu/kernel/setup.c |   16 +++++++---------
 arch/m68knommu/mm/init.c      |    4 +---
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
index 5985f19..5c2bb3e 100644
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -166,15 +166,13 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Motorola M5235EVB support (C)2005 Syn-tech Systems, Inc. (Jate Sujjavanich)\n");
 #endif
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
-		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
-		(int) &_sdata, (int) &_edata,
-		(int) &_sbss, (int) &_ebss);
-	printk(KERN_DEBUG "MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
-		(int) &_ebss, (int) memory_start,
-		(int) memory_start, (int) memory_end);
-#endif
+	pr_debug("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
+		 "BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
+		 (int) &_sdata, (int) &_edata,
+		 (int) &_sbss, (int) &_ebss);
+	pr_debug("MEMORY -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x\n ",
+		 (int) &_ebss, (int) memory_start,
+		 (int) memory_start, (int) memory_end);
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
index 7befc0c..b1703c6 100644
--- a/arch/m68knommu/mm/init.c
+++ b/arch/m68knommu/mm/init.c
@@ -126,9 +126,7 @@ void __init mem_init(void)
 	unsigned long start_mem = memory_start; /* DAVIDM - these must start at end of kernel */
 	unsigned long end_mem   = memory_end; /* DAVIDM - this must not include kernel stack at top */
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
-#endif
+	pr_debug("Mem_init: start=%lx, end=%lx\n", start_mem, end_mem);
 
 	end_mem &= PAGE_MASK;
 	high_memory = (void *) end_mem;
-- 
1.6.3.1.9.g95405b.dirty


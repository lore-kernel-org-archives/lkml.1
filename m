Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbZEOSAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbZEOSAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZEOR7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:59:49 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2041 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZEOR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:48 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/11] arch/h8300: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:36 -0700
Message-Id: <ba728843ea27d48a54d7dcaa43264e3ed9a7bb34.1242407227.git.joe@perches.com>
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
 arch/h8300/kernel/setup.c |   24 ++++++++++--------------
 arch/h8300/mm/init.c      |    4 +---
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index 7fda657..9d17c40 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -133,17 +133,15 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne\n");
 	printk(KERN_INFO "H8/300 series support by Yoshinori Sato <ysato@users.sourceforge.jp>\n");
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
-		"BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
-		(int) &_sdata, (int) &_edata,
-		(int) &_sbss, (int) &_ebss);
-	printk(KERN_DEBUG "KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
-		"STACK=0x%06x-0x%06x\n",
-	       (int) &_ebss, (int) memory_start,
-		(int) memory_start, (int) memory_end,
-		(int) memory_end, (int) &_ramend);
-#endif
+	pr_debug("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x "
+		 "BSS=0x%06x-0x%06x\n", (int) &_stext, (int) &_etext,
+		 (int) &_sdata, (int) &_edata,
+		 (int) &_sbss, (int) &_ebss);
+	pr_debug("KERNEL -> ROMFS=0x%06x-0x%06x MEM=0x%06x-0x%06x "
+		 "STACK=0x%06x-0x%06x\n",
+		 (int) &_ebss, (int) memory_start,
+		 (int) memory_start, (int) memory_end,
+		 (int) memory_end, (int) &_ramend);
 
 #ifdef CONFIG_DEFAULT_CMDLINE
 	/* set from default command line */
@@ -190,9 +188,7 @@ void __init setup_arch(char **cmdline_p)
 		*cscr  |= (AREABIT(CONFIG_H8300_IDE_BASE) | AREABIT(CONFIG_H8300_IDE_ALT)) | 0x0f;
 	}
 #endif
-#ifdef DEBUG
-	printk(KERN_DEBUG "Done setup_arch\n");
-#endif
+	pr_debug("Done setup_arch\n");
 }
 
 /*
diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 9942f24..61a3977 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -130,9 +130,7 @@ void __init mem_init(void)
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


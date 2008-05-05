Return-Path: <linux-kernel-owner+w=401wt.eu-S1764204AbYEESlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764204AbYEESlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbYEESaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33146 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760110AbYEESaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:23 -0400
Date: Mon, 5 May 2008 21:29:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] xtensa: remove the nonexisting highmem support
Message-ID: <20080505182915.GV17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile an xtensa kernel with CONFIG_HIGHMEM=y fails early and 
hard:

<--  snip  -->

...
  CC      init/main.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pagemap.h:10,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/buffer_head.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:53:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h: In function 'clear_user_highpage':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: implicit declaration of function 'kmap_atomic'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: 'KM_USER0' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/highmem.h:68: error: for each function it appears in.)
...
make[2]: *** [init/main.o] Error 1

<--  snip  -->

This patch removes all traces of highmem support from the
xtensa port - highmem support was simply nonexisting.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 23 Apr 2008
- 14 Apr 2008

 arch/xtensa/Kconfig          |    3 ---
 arch/xtensa/mm/init.c        |    8 --------
 include/asm-xtensa/highmem.h |   17 -----------------
 3 files changed, 28 deletions(-)

4593b43e8e6c763d90a4f45c9f2db8750e0fa9c7 diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 9fc8551..09dafbc 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -97,9 +97,6 @@ config MATH_EMULATION
 	help
 	Can we use information of configuration file?
 
-config HIGHMEM
-	bool "High memory support"
-
 endmenu
 
 menu "Platform options"
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 81d0560..89531ff 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -169,10 +169,6 @@ void __init paging_init(void)
 	for (i = 1; i < MAX_NR_ZONES; i++)
 		zones_size[i] = 0;
 
-#ifdef CONFIG_HIGHMEM
-	zones_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
-#endif
-
 	/* Initialize the kernel's page tables. */
 
 	memset(swapper_pg_dir, 0, PAGE_SIZE);
@@ -222,10 +218,6 @@ void __init mem_init(void)
 	high_memory = (void *) __va(max_mapnr << PAGE_SHIFT);
 	highmemsize = 0;
 
-#ifdef CONFIG_HIGHMEM
-#error HIGHGMEM not implemented in init.c
-#endif
-
 	totalram_pages += free_all_bootmem();
 
 	reservedpages = ram = 0;
diff --git a/include/asm-xtensa/highmem.h b/include/asm-xtensa/highmem.h
deleted file mode 100644
index 0a046ca..0000000
--- a/include/asm-xtensa/highmem.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * include/asm-xtensa/highmem.h
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2003 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_HIGHMEM_H
-#define _XTENSA_HIGHMEM_H
-
-extern void flush_cache_kmaps(void);
-
-#endif
-


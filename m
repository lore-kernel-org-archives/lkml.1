Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbXJXQpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbXJXQpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXJXQ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:06 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60987 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759578AbXJXQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:04 -0400
Date: Wed, 24 Oct 2007 18:26:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: bryan.wu@analog.com, ysato@users.sourceforge.jp, gerg@uclinux.org,
       Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove mm_{ptov,vtop}()
Message-ID: <20071024162629.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused mm_{ptov,vtop}().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-blackfin/io.h       |    2 --
 include/asm-h8300/io.h          |    2 --
 include/asm-h8300/virtconvert.h |    2 --
 include/asm-m68knommu/io.h      |    2 --
 include/asm-v850/io.h           |    2 --
 5 files changed, 10 deletions(-)

c2472eb3a1eaaa4211863e6091817b4078b6a53e 
diff --git a/include/asm-blackfin/io.h b/include/asm-blackfin/io.h
index d1d2e6b..f3d8126 100644
--- a/include/asm-blackfin/io.h
+++ b/include/asm-blackfin/io.h
@@ -187,8 +187,6 @@ extern void blkfin_inv_cache_all(void);
 #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
 
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff --git a/include/asm-h8300/io.h b/include/asm-h8300/io.h
index 7543a57..26dc6cc 100644
--- a/include/asm-h8300/io.h
+++ b/include/asm-h8300/io.h
@@ -302,8 +302,6 @@ static __inline__ void ctrl_outl(unsigned long b, unsigned long addr)
 /*
  * Macros used for converting between virtual and physical mappings.
  */
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff --git a/include/asm-h8300/virtconvert.h b/include/asm-h8300/virtconvert.h
index ee7d5ea..19cfd62 100644
--- a/include/asm-h8300/virtconvert.h
+++ b/include/asm-h8300/virtconvert.h
@@ -10,8 +10,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff --git a/include/asm-m68knommu/io.h b/include/asm-m68knommu/io.h
index 653d9b2..6adef1e 100644
--- a/include/asm-m68knommu/io.h
+++ b/include/asm-m68knommu/io.h
@@ -172,8 +172,6 @@ extern void iounmap(void *addr);
 /*
  * Macros used for converting between virtual and physical mappings.
  */
-#define mm_ptov(vaddr)		((void *) (vaddr))
-#define mm_vtop(vaddr)		((unsigned long) (vaddr))
 #define phys_to_virt(vaddr)	((void *) (vaddr))
 #define virt_to_phys(vaddr)	((unsigned long) (vaddr))
 
diff --git a/include/asm-v850/io.h b/include/asm-v850/io.h
index cc364fc..cdad251 100644
--- a/include/asm-v850/io.h
+++ b/include/asm-v850/io.h
@@ -122,8 +122,6 @@ outsl (unsigned long port, const void *src, unsigned long count)
 #endif
 
 /* Conversion between virtual and physical mappings.  */
-#define mm_ptov(addr)		((void *)__phys_to_virt (addr))
-#define mm_vtop(addr)		((unsigned long)__virt_to_phys (addr))
 #define phys_to_virt(addr)	((void *)__phys_to_virt (addr))
 #define virt_to_phys(addr)	((unsigned long)__virt_to_phys (addr))
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXJVSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXJVSOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXJVSMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22192 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXJVSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:26 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/10] Add CONFIG_DEBUG_SG sg validation
Date: Mon, 22 Oct 2007 20:11:04 +0200
Message-Id: <1193076664-13652-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig entry which will toggle some sanity checks on the sg
entry and tables.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-alpha/scatterlist.h     |    3 +++
 include/asm-arm/scatterlist.h       |    3 +++
 include/asm-avr32/scatterlist.h     |    3 +++
 include/asm-blackfin/scatterlist.h  |    3 +++
 include/asm-cris/scatterlist.h      |    3 +++
 include/asm-frv/scatterlist.h       |    3 +++
 include/asm-h8300/scatterlist.h     |    3 +++
 include/asm-ia64/scatterlist.h      |    3 +++
 include/asm-m32r/scatterlist.h      |    3 +++
 include/asm-m68k/scatterlist.h      |    3 +++
 include/asm-m68knommu/scatterlist.h |    3 +++
 include/asm-mips/scatterlist.h      |    3 +++
 include/asm-parisc/scatterlist.h    |    3 +++
 include/asm-powerpc/scatterlist.h   |    3 +++
 include/asm-s390/scatterlist.h      |    3 +++
 include/asm-sh/scatterlist.h        |    3 +++
 include/asm-sh64/scatterlist.h      |    3 +++
 include/asm-sparc/scatterlist.h     |    3 +++
 include/asm-sparc64/scatterlist.h   |    3 +++
 include/asm-v850/scatterlist.h      |    3 +++
 include/asm-x86/scatterlist_32.h    |    3 +++
 include/asm-x86/scatterlist_64.h    |    3 +++
 include/asm-xtensa/scatterlist.h    |    3 +++
 include/linux/scatterlist.h         |   22 ++++++++++++++++++++++
 lib/Kconfig.debug                   |   10 ++++++++++
 25 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/include/asm-alpha/scatterlist.h b/include/asm-alpha/scatterlist.h
index b764706..440747c 100644
--- a/include/asm-alpha/scatterlist.h
+++ b/include/asm-alpha/scatterlist.h
@@ -5,6 +5,9 @@
 #include <asm/types.h>
   
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 
diff --git a/include/asm-arm/scatterlist.h b/include/asm-arm/scatterlist.h
index ab1d85d..ca0a37d 100644
--- a/include/asm-arm/scatterlist.h
+++ b/include/asm-arm/scatterlist.h
@@ -5,6 +5,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;		/* buffer offset		 */
 	dma_addr_t	dma_address;	/* dma address			 */
diff --git a/include/asm-avr32/scatterlist.h b/include/asm-avr32/scatterlist.h
index 1356f29..377320e 100644
--- a/include/asm-avr32/scatterlist.h
+++ b/include/asm-avr32/scatterlist.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+   unsigned long	sg_magic;
+#endif
     unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
diff --git a/include/asm-blackfin/scatterlist.h b/include/asm-blackfin/scatterlist.h
index 384af54..32128d5 100644
--- a/include/asm-blackfin/scatterlist.h
+++ b/include/asm-blackfin/scatterlist.h
@@ -4,6 +4,9 @@
 #include <linux/mm.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 	dma_addr_t dma_address;
diff --git a/include/asm-cris/scatterlist.h b/include/asm-cris/scatterlist.h
index 5a8a834..faff53a 100644
--- a/include/asm-cris/scatterlist.h
+++ b/include/asm-cris/scatterlist.h
@@ -2,6 +2,9 @@
 #define __ASM_CRIS_SCATTERLIST_H
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	char *  address;    /* Location data is to be transferred to */
 	unsigned int length;
 
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
index 53dade7..f7da007 100644
--- a/include/asm-frv/scatterlist.h
+++ b/include/asm-frv/scatterlist.h
@@ -22,6 +22,9 @@
  * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
  */
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;		/* for highmem, page offset */
 
diff --git a/include/asm-h8300/scatterlist.h b/include/asm-h8300/scatterlist.h
index 7e41983..d3ecdd8 100644
--- a/include/asm-h8300/scatterlist.h
+++ b/include/asm-h8300/scatterlist.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
diff --git a/include/asm-ia64/scatterlist.h b/include/asm-ia64/scatterlist.h
index 2f76ce3..d6f5787 100644
--- a/include/asm-ia64/scatterlist.h
+++ b/include/asm-ia64/scatterlist.h
@@ -9,6 +9,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;	/* buffer length */
diff --git a/include/asm-m32r/scatterlist.h b/include/asm-m32r/scatterlist.h
index 33b4b4d..1ed372c 100644
--- a/include/asm-m32r/scatterlist.h
+++ b/include/asm-m32r/scatterlist.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long sg_magic;
+#endif
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
     unsigned long page_link;
diff --git a/include/asm-m68k/scatterlist.h b/include/asm-m68k/scatterlist.h
index e06bb89..d3a7a0e 100644
--- a/include/asm-m68k/scatterlist.h
+++ b/include/asm-m68k/scatterlist.h
@@ -4,6 +4,9 @@
 #include <linux/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
diff --git a/include/asm-m68knommu/scatterlist.h b/include/asm-m68knommu/scatterlist.h
index 28bed41..1094284 100644
--- a/include/asm-m68knommu/scatterlist.h
+++ b/include/asm-m68knommu/scatterlist.h
@@ -5,6 +5,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
diff --git a/include/asm-mips/scatterlist.h b/include/asm-mips/scatterlist.h
index 787797c..83d69fe 100644
--- a/include/asm-mips/scatterlist.h
+++ b/include/asm-mips/scatterlist.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
index 26da914..cd3cfdf 100644
--- a/include/asm-parisc/scatterlist.h
+++ b/include/asm-parisc/scatterlist.h
@@ -5,6 +5,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 
diff --git a/include/asm-powerpc/scatterlist.h b/include/asm-powerpc/scatterlist.h
index b9f1dbc..fcf7d55 100644
--- a/include/asm-powerpc/scatterlist.h
+++ b/include/asm-powerpc/scatterlist.h
@@ -14,6 +14,9 @@
 #include <asm/dma.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
diff --git a/include/asm-s390/scatterlist.h b/include/asm-s390/scatterlist.h
index eb39486..29ec8e2 100644
--- a/include/asm-s390/scatterlist.h
+++ b/include/asm-s390/scatterlist.h
@@ -2,6 +2,9 @@
 #define _ASMS390_SCATTERLIST_H
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long sg_magic;
+#endif
     unsigned long page_link;
     unsigned int offset;
     unsigned int length;
diff --git a/include/asm-sh/scatterlist.h b/include/asm-sh/scatterlist.h
index bc7c809..a7d0d18 100644
--- a/include/asm-sh/scatterlist.h
+++ b/include/asm-sh/scatterlist.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long sg_magic;
+#endif
     unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
diff --git a/include/asm-sh64/scatterlist.h b/include/asm-sh64/scatterlist.h
index 0afd856..5109251 100644
--- a/include/asm-sh64/scatterlist.h
+++ b/include/asm-sh64/scatterlist.h
@@ -14,6 +14,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long sg_magic;
+#endif
     unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
diff --git a/include/asm-sparc/scatterlist.h b/include/asm-sparc/scatterlist.h
index 45b16f1..e08d3d7 100644
--- a/include/asm-sparc/scatterlist.h
+++ b/include/asm-sparc/scatterlist.h
@@ -5,6 +5,9 @@
 #include <linux/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long sg_magic;
+#endif
 	unsigned long page_link;
 	unsigned int offset;
 
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 4cbaf7c..6df23f0 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -6,6 +6,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;
 
diff --git a/include/asm-v850/scatterlist.h b/include/asm-v850/scatterlist.h
index db91feb..02d27b3 100644
--- a/include/asm-v850/scatterlist.h
+++ b/include/asm-v850/scatterlist.h
@@ -17,6 +17,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned	offset;
 	dma_addr_t	dma_address;
diff --git a/include/asm-x86/scatterlist_32.h b/include/asm-x86/scatterlist_32.h
index 140a5b3..0e7d997 100644
--- a/include/asm-x86/scatterlist_32.h
+++ b/include/asm-x86/scatterlist_32.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long	sg_magic;
+#endif
     unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
diff --git a/include/asm-x86/scatterlist_64.h b/include/asm-x86/scatterlist_64.h
index e344784..1847c72 100644
--- a/include/asm-x86/scatterlist_64.h
+++ b/include/asm-x86/scatterlist_64.h
@@ -4,6 +4,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+    unsigned long	sg_magic;
+#endif
     unsigned long	page_link;
     unsigned int	offset;
     unsigned int	length;
diff --git a/include/asm-xtensa/scatterlist.h b/include/asm-xtensa/scatterlist.h
index 3b8aba5..810080b 100644
--- a/include/asm-xtensa/scatterlist.h
+++ b/include/asm-xtensa/scatterlist.h
@@ -14,6 +14,9 @@
 #include <asm/types.h>
 
 struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
 	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index c6136e8..42daf5e 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -23,6 +23,8 @@
  *
  */
 
+#define SG_MAGIC	0x87654321
+
 /**
  * sg_set_page - Set sg entry to point at given page
  * @sg:		 SG entry
@@ -39,6 +41,9 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page)
 {
 	unsigned long page_link = sg->page_link & 0x3;
 
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
 	sg->page_link = page_link | (unsigned long) page;
 }
 
@@ -81,6 +86,9 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
  **/
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
 	if (sg_is_last(sg))
 		return NULL;
 
@@ -124,6 +132,10 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
 		ret = sg;
 
 #endif
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
+	BUG_ON(!sg_is_last(ret));
+#endif
 	return ret;
 }
 
@@ -180,6 +192,9 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 			       unsigned int buflen)
 {
 	memset(sg, 0, sizeof(*sg));
+#ifdef CONFIG_DEBUG_SG
+	sg->sg_magic = SG_MAGIC;
+#endif
 	sg_mark_end(sg, 1);
 	sg_set_buf(sg, buf, buflen);
 }
@@ -198,6 +213,13 @@ static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
 {
 	memset(sgl, 0, sizeof(*sgl) * nents);
 	sg_mark_end(sgl, nents);
+#ifdef CONFIG_DEBUG_SG
+	{
+		int i;
+		for (i = 0; i < nents; i++)
+			sgl[i].sg_magic = SG_MAGIC;
+	}
+#endif
 }
 
 /**
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c567f21..1faa508 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -389,6 +389,16 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_SG
+	bool "Debug SG table operations"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on checks on scatter-gather tables. This can
+	  help find problems with drivers that do not properly initialize
+	  their sg tables.
+
+	  If unsure, say N.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
-- 
1.5.3.GIT


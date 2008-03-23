Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYCWIj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYCWIj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759824AbYCWIK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2304 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759314AbYCWIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:26 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 025/148] include/asm-x86/dma.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:00 -0700
Message-Id: <1206259443-13210-26-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/dma.h |   45 ++++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/asm-x86/dma.h b/include/asm-x86/dma.h
index e9733ce..ca1098a 100644
--- a/include/asm-x86/dma.h
+++ b/include/asm-x86/dma.h
@@ -12,7 +12,6 @@
 #include <asm/io.h>		/* need byte IO */
 #include <linux/delay.h>
 
-
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
 #else
@@ -74,15 +73,15 @@
 #ifdef CONFIG_X86_32
 
 /* The maximum address that we can perform a DMA transfer to on this platform */
-#define MAX_DMA_ADDRESS      (PAGE_OFFSET+0x1000000)
+#define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)
 
 #else
 
 /* 16MB ISA DMA zone */
-#define MAX_DMA_PFN   ((16*1024*1024) >> PAGE_SHIFT)
+#define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
-#define MAX_DMA32_PFN ((4UL*1024*1024*1024) >> PAGE_SHIFT)
+#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
 
 /* Compat define for old dma zone */
 #define MAX_DMA_ADDRESS ((unsigned long)__va(MAX_DMA_PFN << PAGE_SHIFT))
@@ -154,20 +153,20 @@
 
 extern spinlock_t  dma_spin_lock;
 
-static __inline__ unsigned long claim_dma_lock(void)
+static inline unsigned long claim_dma_lock(void)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&dma_spin_lock, flags);
 	return flags;
 }
 
-static __inline__ void release_dma_lock(unsigned long flags)
+static inline void release_dma_lock(unsigned long flags)
 {
 	spin_unlock_irqrestore(&dma_spin_lock, flags);
 }
 
 /* enable/disable a specific DMA channel */
-static __inline__ void enable_dma(unsigned int dmanr)
+static inline void enable_dma(unsigned int dmanr)
 {
 	if (dmanr <= 3)
 		dma_outb(dmanr, DMA1_MASK_REG);
@@ -175,7 +174,7 @@ static __inline__ void enable_dma(unsigned int dmanr)
 		dma_outb(dmanr & 3, DMA2_MASK_REG);
 }
 
-static __inline__ void disable_dma(unsigned int dmanr)
+static inline void disable_dma(unsigned int dmanr)
 {
 	if (dmanr <= 3)
 		dma_outb(dmanr | 4, DMA1_MASK_REG);
@@ -190,7 +189,7 @@ static __inline__ void disable_dma(unsigned int dmanr)
  * --- In order to do that, the DMA routines below should ---
  * --- only be used while holding the DMA lock ! ---
  */
-static __inline__ void clear_dma_ff(unsigned int dmanr)
+static inline void clear_dma_ff(unsigned int dmanr)
 {
 	if (dmanr <= 3)
 		dma_outb(0, DMA1_CLEAR_FF_REG);
@@ -199,7 +198,7 @@ static __inline__ void clear_dma_ff(unsigned int dmanr)
 }
 
 /* set mode (above) for a specific DMA channel */
-static __inline__ void set_dma_mode(unsigned int dmanr, char mode)
+static inline void set_dma_mode(unsigned int dmanr, char mode)
 {
 	if (dmanr <= 3)
 		dma_outb(mode | dmanr, DMA1_MODE_REG);
@@ -212,7 +211,7 @@ static __inline__ void set_dma_mode(unsigned int dmanr, char mode)
  * the lower 16 bits of the DMA current address register, but a 64k boundary
  * may have been crossed.
  */
-static __inline__ void set_dma_page(unsigned int dmanr, char pagenr)
+static inline void set_dma_page(unsigned int dmanr, char pagenr)
 {
 	switch (dmanr) {
 	case 0:
@@ -243,15 +242,15 @@ static __inline__ void set_dma_page(unsigned int dmanr, char pagenr)
 /* Set transfer address & page bits for specific DMA channel.
  * Assumes dma flipflop is clear.
  */
-static __inline__ void set_dma_addr(unsigned int dmanr, unsigned int a)
+static inline void set_dma_addr(unsigned int dmanr, unsigned int a)
 {
 	set_dma_page(dmanr, a>>16);
 	if (dmanr <= 3)  {
 		dma_outb(a & 0xff, ((dmanr & 3) << 1) + IO_DMA1_BASE);
 		dma_outb((a >> 8) & 0xff, ((dmanr & 3) << 1) + IO_DMA1_BASE);
 	}  else  {
-	    dma_outb((a >> 1) & 0xff, ((dmanr & 3) << 2) + IO_DMA2_BASE);
-	    dma_outb((a >> 9) & 0xff, ((dmanr & 3) << 2) + IO_DMA2_BASE);
+		dma_outb((a >> 1) & 0xff, ((dmanr & 3) << 2) + IO_DMA2_BASE);
+		dma_outb((a >> 9) & 0xff, ((dmanr & 3) << 2) + IO_DMA2_BASE);
 	}
 }
 
@@ -264,18 +263,18 @@ static __inline__ void set_dma_addr(unsigned int dmanr, unsigned int a)
  * Assumes dma flip-flop is clear.
  * NOTE 2: "count" represents _bytes_ and must be even for channels 5-7.
  */
-static __inline__ void set_dma_count(unsigned int dmanr, unsigned int count)
+static inline void set_dma_count(unsigned int dmanr, unsigned int count)
 {
 	count--;
 	if (dmanr <= 3)  {
-	    dma_outb(count & 0xff, ((dmanr & 3) << 1) + 1 + IO_DMA1_BASE);
-	    dma_outb((count >> 8) & 0xff,
-		     ((dmanr & 3) << 1) + 1 + IO_DMA1_BASE);
+		dma_outb(count & 0xff, ((dmanr & 3) << 1) + 1 + IO_DMA1_BASE);
+		dma_outb((count >> 8) & 0xff,
+			 ((dmanr & 3) << 1) + 1 + IO_DMA1_BASE);
 	} else {
-	    dma_outb((count >> 1) & 0xff,
-		     ((dmanr & 3) << 2) + 2 + IO_DMA2_BASE);
-	    dma_outb((count >> 9) & 0xff,
-		     ((dmanr & 3) << 2) + 2 + IO_DMA2_BASE);
+		dma_outb((count >> 1) & 0xff,
+			 ((dmanr & 3) << 2) + 2 + IO_DMA2_BASE);
+		dma_outb((count >> 9) & 0xff,
+			 ((dmanr & 3) << 2) + 2 + IO_DMA2_BASE);
 	}
 }
 
@@ -288,7 +287,7 @@ static __inline__ void set_dma_count(unsigned int dmanr, unsigned int count)
  *
  * Assumes DMA flip-flop is clear.
  */
-static __inline__ int get_dma_residue(unsigned int dmanr)
+static inline int get_dma_residue(unsigned int dmanr)
 {
 	unsigned int io_port;
 	/* using short to get 16-bit wrap around */
-- 
1.5.4.rc2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbYCWIXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbYCWIXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYCWIJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:11 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2271 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758952AbYCWIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:09 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 066/148] include/asm-x86/mca_dma.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:41 -0700
Message-Id: <1206259443-13210-67-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mca_dma.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/asm-x86/mca_dma.h b/include/asm-x86/mca_dma.h
index fbb1f3b..c3dca6e 100644
--- a/include/asm-x86/mca_dma.h
+++ b/include/asm-x86/mca_dma.h
@@ -12,18 +12,18 @@
  *   count by 2 when using 16-bit dma; that is not handled by these functions.
  *
  * Ramen Noodles are yummy.
- * 
- *  1998 Tymm Twillman <tymm@computer.org>  
+ *
+ *  1998 Tymm Twillman <tymm@computer.org>
  */
 
 /*
- * Registers that are used by the DMA controller; FN is the function register 
+ * Registers that are used by the DMA controller; FN is the function register
  *   (tell the controller what to do) and EXE is the execution register (how
  *   to do it)
  */
 
 #define MCA_DMA_REG_FN  0x18
-#define MCA_DMA_REG_EXE 0x1A 
+#define MCA_DMA_REG_EXE 0x1A
 
 /*
  * Functions that the DMA controller can do
@@ -43,9 +43,9 @@
 
 /*
  * Modes (used by setting MCA_DMA_FN_MODE in the function register)
- * 
+ *
  * Note that the MODE_READ is read from memory (write to device), and
- *   MODE_WRITE is vice-versa.  
+ *   MODE_WRITE is vice-versa.
  */
 
 #define MCA_DMA_MODE_XFER  0x04  /* read by default */
@@ -63,7 +63,7 @@
  *	IRQ context.
  */
 
-static __inline__ void mca_enable_dma(unsigned int dmanr)
+static inline void mca_enable_dma(unsigned int dmanr)
 {
 	outb(MCA_DMA_FN_RESET_MASK | dmanr, MCA_DMA_REG_FN);
 }
@@ -76,7 +76,7 @@ static __inline__ void mca_enable_dma(unsigned int dmanr)
  *	IRQ context.
  */
 
-static __inline__ void mca_disable_dma(unsigned int dmanr)
+static inline void mca_disable_dma(unsigned int dmanr)
 {
 	outb(MCA_DMA_FN_MASK | dmanr, MCA_DMA_REG_FN);
 }
@@ -87,10 +87,10 @@ static __inline__ void mca_disable_dma(unsigned int dmanr)
  *	@a: 24bit bus address
  *
  *	Load the address register in the DMA controller. This has a 24bit
- *	limitation (16Mb). 
+ *	limitation (16Mb).
  */
 
-static __inline__ void mca_set_dma_addr(unsigned int dmanr, unsigned int a)
+static inline void mca_set_dma_addr(unsigned int dmanr, unsigned int a)
 {
 	outb(MCA_DMA_FN_SET_ADDR | dmanr, MCA_DMA_REG_FN);
 	outb(a & 0xff, MCA_DMA_REG_EXE);
@@ -106,14 +106,14 @@ static __inline__ void mca_set_dma_addr(unsigned int dmanr, unsigned int a)
  *	limitation (16Mb). The return is a bus address.
  */
 
-static __inline__ unsigned int mca_get_dma_addr(unsigned int dmanr)
+static inline unsigned int mca_get_dma_addr(unsigned int dmanr)
 {
 	unsigned int addr;
 
 	outb(MCA_DMA_FN_GET_ADDR | dmanr, MCA_DMA_REG_FN);
 	addr = inb(MCA_DMA_REG_EXE);
 	addr |= inb(MCA_DMA_REG_EXE) << 8;
-	addr |= inb(MCA_DMA_REG_EXE) << 16;  
+	addr |= inb(MCA_DMA_REG_EXE) << 16;
 
 	return addr;
 }
@@ -127,7 +127,7 @@ static __inline__ unsigned int mca_get_dma_addr(unsigned int dmanr)
  *	Setting a count of zero will not do what you expect.
  */
 
-static __inline__ void mca_set_dma_count(unsigned int dmanr, unsigned int count)
+static inline void mca_set_dma_count(unsigned int dmanr, unsigned int count)
 {
 	count--;  /* transfers one more than count -- correct for this */
 
@@ -144,7 +144,7 @@ static __inline__ void mca_set_dma_count(unsigned int dmanr, unsigned int count)
  *	on this DMA channel.
  */
 
-static __inline__ unsigned int mca_get_dma_residue(unsigned int dmanr)
+static inline unsigned int mca_get_dma_residue(unsigned int dmanr)
 {
 	unsigned short count;
 
@@ -164,12 +164,12 @@ static __inline__ unsigned int mca_get_dma_residue(unsigned int dmanr)
  *	with an I/O port target.
  */
 
-static __inline__ void mca_set_dma_io(unsigned int dmanr, unsigned int io_addr)
+static inline void mca_set_dma_io(unsigned int dmanr, unsigned int io_addr)
 {
 	/*
 	 * DMA from a port address -- set the io address
 	 */
-	
+
 	outb(MCA_DMA_FN_SET_IO | dmanr, MCA_DMA_REG_FN);
 	outb(io_addr & 0xff, MCA_DMA_REG_EXE);
 	outb((io_addr >>  8) & 0xff, MCA_DMA_REG_EXE);
@@ -192,7 +192,7 @@ static __inline__ void mca_set_dma_io(unsigned int dmanr, unsigned int io_addr)
  *	%MCA_DMA_MODE_16 to do 16bit transfers.
  */
 
-static __inline__ void mca_set_dma_mode(unsigned int dmanr, unsigned int mode)
+static inline void mca_set_dma_mode(unsigned int dmanr, unsigned int mode)
 {
 	outb(MCA_DMA_FN_SET_MODE | dmanr, MCA_DMA_REG_FN);
 	outb(mode, MCA_DMA_REG_EXE);
-- 
1.5.4.rc2


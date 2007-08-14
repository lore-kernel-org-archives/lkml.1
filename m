Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbXHNVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbXHNVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXHNVZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:25:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38467 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757086AbXHNVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:25:33 -0400
Date: Tue, 14 Aug 2007 23:25:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] arm: "extern inline" -> "static inline"
Message-ID: <20070814212519.GR18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/nwfpe/ARM-gcc.h                |    2 +-
 arch/arm/nwfpe/fpa11.inl                |    8 ++++----
 include/asm-arm/arch-ixp23xx/platform.h |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

348e0e79b7ce03132287290b9598a16d3b6350cd 
diff --git a/arch/arm/nwfpe/ARM-gcc.h b/arch/arm/nwfpe/ARM-gcc.h
index e659847..436e54a 100644
--- a/arch/arm/nwfpe/ARM-gcc.h
+++ b/arch/arm/nwfpe/ARM-gcc.h
@@ -68,7 +68,7 @@ a compiler does not support explicit inlining, this macro should be defined
 to be `static'.
 -------------------------------------------------------------------------------
 */
-#define INLINE extern __inline__
+#define INLINE static inline
 
 
 /* For use as a GCC soft-float library we need some special function names. */
diff --git a/arch/arm/nwfpe/fpa11.inl b/arch/arm/nwfpe/fpa11.inl
index 10c3caf..ab8d682 100644
--- a/arch/arm/nwfpe/fpa11.inl
+++ b/arch/arm/nwfpe/fpa11.inl
@@ -22,13 +22,13 @@
 #include "fpa11.h"
 
 /* Read and write floating point status register */
-extern __inline__ unsigned int readFPSR(void)
+static inline unsigned int readFPSR(void)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	return (fpa11->fpsr);
 }
 
-extern __inline__ void writeFPSR(FPSR reg)
+static inline void writeFPSR(FPSR reg)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	/* the sysid byte in the status register is readonly */
@@ -36,14 +36,14 @@ extern __inline__ void writeFPSR(FPSR reg)
 }
 
 /* Read and write floating point control register */
-extern __inline__ FPCR readFPCR(void)
+static inline FPCR readFPCR(void)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	/* clear SB, AB and DA bits before returning FPCR */
 	return (fpa11->fpcr & ~MASK_RFC);
 }
 
-extern __inline__ void writeFPCR(FPCR reg)
+static inline void writeFPCR(FPCR reg)
 {
 	FPA11 *fpa11 = GET_FPA11();
 	fpa11->fpcr &= ~MASK_WFC;		/* clear SB, AB and DA bits */
diff --git a/include/asm-arm/arch-ixp23xx/platform.h b/include/asm-arm/arch-ixp23xx/platform.h
index 56e16d6..db8aa30 100644
--- a/include/asm-arm/arch-ixp23xx/platform.h
+++ b/include/asm-arm/arch-ixp23xx/platform.h
@@ -14,17 +14,17 @@
 
 #ifndef __ASSEMBLY__
 
-extern inline unsigned long ixp2000_reg_read(volatile void *reg)
+static inline unsigned long ixp2000_reg_read(volatile void *reg)
 {
 	return *((volatile unsigned long *)reg);
 }
 
-extern inline void ixp2000_reg_write(volatile void *reg, unsigned long val)
+static inline void ixp2000_reg_write(volatile void *reg, unsigned long val)
 {
 	*((volatile unsigned long *)reg) = val;
 }
 
-extern inline void ixp2000_reg_wrb(volatile void *reg, unsigned long val)
+static inline void ixp2000_reg_wrb(volatile void *reg, unsigned long val)
 {
 	*((volatile unsigned long *)reg) = val;
 }


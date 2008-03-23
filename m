Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbYCWImx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbYCWImx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbYCWIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2311 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbYCWIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:43 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 147/148] include/asm-x86/xor_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:04:02 -0700
Message-Id: <1206259443-13210-148-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/xor_32.h |  494 +++++++++++++++++++++++-----------------------
 1 files changed, 248 insertions(+), 246 deletions(-)

diff --git a/include/asm-x86/xor_32.h b/include/asm-x86/xor_32.h
index a41ef1b..067b5c1 100644
--- a/include/asm-x86/xor_32.h
+++ b/include/asm-x86/xor_32.h
@@ -16,12 +16,12 @@
  * Copyright (C) 1998 Ingo Molnar.
  */
 
-#define LD(x,y)		"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
-#define ST(x,y)		"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
-#define XO1(x,y)	"       pxor   8*("#x")(%2), %%mm"#y"   ;\n"
-#define XO2(x,y)	"       pxor   8*("#x")(%3), %%mm"#y"   ;\n"
-#define XO3(x,y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
-#define XO4(x,y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
+#define LD(x, y)	"       movq   8*("#x")(%1), %%mm"#y"   ;\n"
+#define ST(x, y)	"       movq %%mm"#y",   8*("#x")(%1)   ;\n"
+#define XO1(x, y)	"       pxor   8*("#x")(%2), %%mm"#y"   ;\n"
+#define XO2(x, y)	"       pxor   8*("#x")(%3), %%mm"#y"   ;\n"
+#define XO3(x, y)	"       pxor   8*("#x")(%4), %%mm"#y"   ;\n"
+#define XO4(x, y)	"       pxor   8*("#x")(%5), %%mm"#y"   ;\n"
 
 #include <asm/i387.h>
 
@@ -32,24 +32,24 @@ xor_pII_mmx_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
-#define BLOCK(i) \
-	LD(i,0)					\
-		LD(i+1,1)			\
-			LD(i+2,2)		\
-				LD(i+3,3)	\
-	XO1(i,0)				\
-	ST(i,0)					\
-		XO1(i+1,1)			\
-		ST(i+1,1)			\
-			XO1(i+2,2)		\
-			ST(i+2,2)		\
-				XO1(i+3,3)	\
-				ST(i+3,3)
+#define BLOCK(i)				\
+	LD(i, 0)				\
+		LD(i + 1, 1)			\
+			LD(i + 2, 2)		\
+				LD(i + 3, 3)	\
+	XO1(i, 0)				\
+	ST(i, 0)				\
+		XO1(i+1, 1)			\
+		ST(i+1, 1)			\
+			XO1(i + 2, 2)		\
+			ST(i + 2, 2)		\
+				XO1(i + 3, 3)	\
+				ST(i + 3, 3)
 
 	" .align 32			;\n"
-  	" 1:                            ;\n"
+	" 1:                            ;\n"
 
 	BLOCK(0)
 	BLOCK(4)
@@ -76,25 +76,25 @@ xor_pII_mmx_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
-#define BLOCK(i) \
-	LD(i,0)					\
-		LD(i+1,1)			\
-			LD(i+2,2)		\
-				LD(i+3,3)	\
-	XO1(i,0)				\
-		XO1(i+1,1)			\
-			XO1(i+2,2)		\
-				XO1(i+3,3)	\
-	XO2(i,0)				\
-	ST(i,0)					\
-		XO2(i+1,1)			\
-		ST(i+1,1)			\
-			XO2(i+2,2)		\
-			ST(i+2,2)		\
-				XO2(i+3,3)	\
-				ST(i+3,3)
+#define BLOCK(i)				\
+	LD(i, 0)				\
+		LD(i + 1, 1)			\
+			LD(i + 2, 2)		\
+				LD(i + 3, 3)	\
+	XO1(i, 0)				\
+		XO1(i + 1, 1)			\
+			XO1(i + 2, 2)		\
+				XO1(i + 3, 3)	\
+	XO2(i, 0)				\
+	ST(i, 0)				\
+		XO2(i + 1, 1)			\
+		ST(i + 1, 1)			\
+			XO2(i + 2, 2)		\
+			ST(i + 2, 2)		\
+				XO2(i + 3, 3)	\
+				ST(i + 3, 3)
 
 	" .align 32			;\n"
 	" 1:                            ;\n"
@@ -125,29 +125,29 @@ xor_pII_mmx_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
-#define BLOCK(i) \
-	LD(i,0)					\
-		LD(i+1,1)			\
-			LD(i+2,2)		\
-				LD(i+3,3)	\
-	XO1(i,0)				\
-		XO1(i+1,1)			\
-			XO1(i+2,2)		\
-				XO1(i+3,3)	\
-	XO2(i,0)				\
-		XO2(i+1,1)			\
-			XO2(i+2,2)		\
-				XO2(i+3,3)	\
-	XO3(i,0)				\
-	ST(i,0)					\
-		XO3(i+1,1)			\
-		ST(i+1,1)			\
-			XO3(i+2,2)		\
-			ST(i+2,2)		\
-				XO3(i+3,3)	\
-				ST(i+3,3)
+#define BLOCK(i)				\
+	LD(i, 0)				\
+		LD(i + 1, 1)			\
+			LD(i + 2, 2)		\
+				LD(i + 3, 3)	\
+	XO1(i, 0)				\
+		XO1(i + 1, 1)			\
+			XO1(i + 2, 2)		\
+				XO1(i + 3, 3)	\
+	XO2(i, 0)				\
+		XO2(i + 1, 1)			\
+			XO2(i + 2, 2)		\
+				XO2(i + 3, 3)	\
+	XO3(i, 0)				\
+	ST(i, 0)				\
+		XO3(i + 1, 1)			\
+		ST(i + 1, 1)			\
+			XO3(i + 2, 2)		\
+			ST(i + 2, 2)		\
+				XO3(i + 3, 3)	\
+				ST(i + 3, 3)
 
 	" .align 32			;\n"
 	" 1:                            ;\n"
@@ -186,35 +186,35 @@ xor_pII_mmx_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	   because we modify p4 and p5 there, but we can't mark them
 	   as read/write, otherwise we'd overflow the 10-asm-operands
 	   limit of GCC < 3.1.  */
-	__asm__ ("" : "+r" (p4), "+r" (p5));
+	asm("" : "+r" (p4), "+r" (p5));
 
-	__asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
-#define BLOCK(i) \
-	LD(i,0)					\
-		LD(i+1,1)			\
-			LD(i+2,2)		\
-				LD(i+3,3)	\
-	XO1(i,0)				\
-		XO1(i+1,1)			\
-			XO1(i+2,2)		\
-				XO1(i+3,3)	\
-	XO2(i,0)				\
-		XO2(i+1,1)			\
-			XO2(i+2,2)		\
-				XO2(i+3,3)	\
-	XO3(i,0)				\
-		XO3(i+1,1)			\
-			XO3(i+2,2)		\
-				XO3(i+3,3)	\
-	XO4(i,0)				\
-	ST(i,0)					\
-		XO4(i+1,1)			\
-		ST(i+1,1)			\
-			XO4(i+2,2)		\
-			ST(i+2,2)		\
-				XO4(i+3,3)	\
-				ST(i+3,3)
+#define BLOCK(i)				\
+	LD(i, 0)				\
+		LD(i + 1, 1)			\
+			LD(i + 2, 2)		\
+				LD(i + 3, 3)	\
+	XO1(i, 0)				\
+		XO1(i + 1, 1)			\
+			XO1(i + 2, 2)		\
+				XO1(i + 3, 3)	\
+	XO2(i, 0)				\
+		XO2(i + 1, 1)			\
+			XO2(i + 2, 2)		\
+				XO2(i + 3, 3)	\
+	XO3(i, 0)				\
+		XO3(i + 1, 1)			\
+			XO3(i + 2, 2)		\
+				XO3(i + 3, 3)	\
+	XO4(i, 0)				\
+	ST(i, 0)				\
+		XO4(i + 1, 1)			\
+		ST(i + 1, 1)			\
+			XO4(i + 2, 2)		\
+			ST(i + 2, 2)		\
+				XO4(i + 3, 3)	\
+				ST(i + 3, 3)
 
 	" .align 32			;\n"
 	" 1:                            ;\n"
@@ -233,13 +233,13 @@ xor_pII_mmx_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	"       jnz 1b                ;\n"
 	: "+r" (lines),
 	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5) 
+	: "r" (p4), "r" (p5)
 	: "memory");
 
 	/* p4 and p5 were modified, and now the variables are dead.
 	   Clobber them just to be sure nobody does something stupid
 	   like assuming they have some legal value.  */
-	__asm__ ("" : "=r" (p4), "=r" (p5));
+	asm("" : "=r" (p4), "=r" (p5));
 
 	kernel_fpu_end();
 }
@@ -259,7 +259,7 @@ xor_p5_mmx_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 	" .align 32	             ;\n"
 	" 1:                         ;\n"
 	"       movq   (%1), %%mm0   ;\n"
@@ -286,7 +286,7 @@ xor_p5_mmx_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 	"       pxor 56(%2), %%mm7   ;\n"
 	"       movq %%mm6, 48(%1)   ;\n"
 	"       movq %%mm7, 56(%1)   ;\n"
-	
+
 	"       addl $64, %1         ;\n"
 	"       addl $64, %2         ;\n"
 	"       decl %0              ;\n"
@@ -307,7 +307,7 @@ xor_p5_mmx_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 	" .align 32,0x90             ;\n"
 	" 1:                         ;\n"
 	"       movq   (%1), %%mm0   ;\n"
@@ -342,7 +342,7 @@ xor_p5_mmx_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	"       pxor 56(%3), %%mm7   ;\n"
 	"       movq %%mm6, 48(%1)   ;\n"
 	"       movq %%mm7, 56(%1)   ;\n"
-      
+
 	"       addl $64, %1         ;\n"
 	"       addl $64, %2         ;\n"
 	"       addl $64, %3         ;\n"
@@ -364,7 +364,7 @@ xor_p5_mmx_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 
 	kernel_fpu_begin();
 
-	__asm__ __volatile__ (
+	asm volatile(
 	" .align 32,0x90             ;\n"
 	" 1:                         ;\n"
 	"       movq   (%1), %%mm0   ;\n"
@@ -407,7 +407,7 @@ xor_p5_mmx_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	"       pxor 56(%4), %%mm7   ;\n"
 	"       movq %%mm6, 48(%1)   ;\n"
 	"       movq %%mm7, 56(%1)   ;\n"
-      
+
 	"       addl $64, %1         ;\n"
 	"       addl $64, %2         ;\n"
 	"       addl $64, %3         ;\n"
@@ -436,9 +436,9 @@ xor_p5_mmx_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	   because we modify p4 and p5 there, but we can't mark them
 	   as read/write, otherwise we'd overflow the 10-asm-operands
 	   limit of GCC < 3.1.  */
-	__asm__ ("" : "+r" (p4), "+r" (p5));
+	asm("" : "+r" (p4), "+r" (p5));
 
-	__asm__ __volatile__ (
+	asm volatile(
 	" .align 32,0x90             ;\n"
 	" 1:                         ;\n"
 	"       movq   (%1), %%mm0   ;\n"
@@ -489,7 +489,7 @@ xor_p5_mmx_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	"       pxor 56(%5), %%mm7   ;\n"
 	"       movq %%mm6, 48(%1)   ;\n"
 	"       movq %%mm7, 56(%1)   ;\n"
-      
+
 	"       addl $64, %1         ;\n"
 	"       addl $64, %2         ;\n"
 	"       addl $64, %3         ;\n"
@@ -505,7 +505,7 @@ xor_p5_mmx_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	/* p4 and p5 were modified, and now the variables are dead.
 	   Clobber them just to be sure nobody does something stupid
 	   like assuming they have some legal value.  */
-	__asm__ ("" : "=r" (p4), "=r" (p5));
+	asm("" : "=r" (p4), "=r" (p5));
 
 	kernel_fpu_end();
 }
@@ -531,11 +531,12 @@ static struct xor_block_template xor_block_p5_mmx = {
  * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
  */
 
-#define XMMS_SAVE do {				\
+#define XMMS_SAVE				\
+do {						\
 	preempt_disable();			\
 	cr0 = read_cr0();			\
 	clts();					\
-	__asm__ __volatile__ ( 			\
+	asm volatile(				\
 		"movups %%xmm0,(%0)	;\n\t"	\
 		"movups %%xmm1,0x10(%0)	;\n\t"	\
 		"movups %%xmm2,0x20(%0)	;\n\t"	\
@@ -543,10 +544,11 @@ static struct xor_block_template xor_block_p5_mmx = {
 		:				\
 		: "r" (xmm_save) 		\
 		: "memory");			\
-} while(0)
+} while (0)
 
-#define XMMS_RESTORE do {			\
-	__asm__ __volatile__ ( 			\
+#define XMMS_RESTORE				\
+do {						\
+	asm volatile(				\
 		"sfence			;\n\t"	\
 		"movups (%0),%%xmm0	;\n\t"	\
 		"movups 0x10(%0),%%xmm1	;\n\t"	\
@@ -557,76 +559,76 @@ static struct xor_block_template xor_block_p5_mmx = {
 		: "memory");			\
 	write_cr0(cr0);				\
 	preempt_enable();			\
-} while(0)
+} while (0)
 
 #define ALIGN16 __attribute__((aligned(16)))
 
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
 #define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
-#define LD(x,y)		"       movaps   "OFFS(x)"(%1), %%xmm"#y"	;\n"
-#define ST(x,y)		"       movaps %%xmm"#y",   "OFFS(x)"(%1)	;\n"
+#define LD(x, y)	"       movaps   "OFFS(x)"(%1), %%xmm"#y"	;\n"
+#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%1)	;\n"
 #define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%2)		;\n"
 #define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%3)		;\n"
 #define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%4)		;\n"
 #define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%5)		;\n"
 #define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%6)		;\n"
-#define XO1(x,y)	"       xorps   "OFFS(x)"(%2), %%xmm"#y"	;\n"
-#define XO2(x,y)	"       xorps   "OFFS(x)"(%3), %%xmm"#y"	;\n"
-#define XO3(x,y)	"       xorps   "OFFS(x)"(%4), %%xmm"#y"	;\n"
-#define XO4(x,y)	"       xorps   "OFFS(x)"(%5), %%xmm"#y"	;\n"
-#define XO5(x,y)	"       xorps   "OFFS(x)"(%6), %%xmm"#y"	;\n"
+#define XO1(x, y)	"       xorps   "OFFS(x)"(%2), %%xmm"#y"	;\n"
+#define XO2(x, y)	"       xorps   "OFFS(x)"(%3), %%xmm"#y"	;\n"
+#define XO3(x, y)	"       xorps   "OFFS(x)"(%4), %%xmm"#y"	;\n"
+#define XO4(x, y)	"       xorps   "OFFS(x)"(%5), %%xmm"#y"	;\n"
+#define XO5(x, y)	"       xorps   "OFFS(x)"(%6), %%xmm"#y"	;\n"
 
 
 static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
-        unsigned long lines = bytes >> 8;
+	unsigned long lines = bytes >> 8;
 	char xmm_save[16*4] ALIGN16;
 	int cr0;
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
-#define BLOCK(i) \
-		LD(i,0)					\
-			LD(i+1,1)			\
+#define BLOCK(i)					\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
 		PF1(i)					\
-				PF1(i+2)		\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
-		PF0(i+4)				\
-				PF0(i+6)		\
-		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
-		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+				PF1(i + 2)		\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
 
 
 		PF0(0)
 				PF0(2)
 
 	" .align 32			;\n"
-        " 1:                            ;\n"
+	" 1:                            ;\n"
 
 		BLOCK(0)
 		BLOCK(4)
 		BLOCK(8)
 		BLOCK(12)
 
-        "       addl $256, %1           ;\n"
-        "       addl $256, %2           ;\n"
-        "       decl %0                 ;\n"
-        "       jnz 1b                  ;\n"
+	"       addl $256, %1           ;\n"
+	"       addl $256, %2           ;\n"
+	"       decl %0                 ;\n"
+	"       jnz 1b                  ;\n"
 	: "+r" (lines),
 	  "+r" (p1), "+r" (p2)
 	:
-        : "memory");
+	: "memory");
 
 	XMMS_RESTORE;
 }
@@ -635,59 +637,59 @@ static void
 xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
-        unsigned long lines = bytes >> 8;
+	unsigned long lines = bytes >> 8;
 	char xmm_save[16*4] ALIGN16;
 	int cr0;
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
+				PF1(i + 2)		\
 		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
 		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
 		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
 		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
 
 
 		PF0(0)
 				PF0(2)
 
 	" .align 32			;\n"
-        " 1:                            ;\n"
+	" 1:                            ;\n"
 
 		BLOCK(0)
 		BLOCK(4)
 		BLOCK(8)
 		BLOCK(12)
 
-        "       addl $256, %1           ;\n"
-        "       addl $256, %2           ;\n"
-        "       addl $256, %3           ;\n"
-        "       decl %0                 ;\n"
-        "       jnz 1b                  ;\n"
+	"       addl $256, %1           ;\n"
+	"       addl $256, %2           ;\n"
+	"       addl $256, %3           ;\n"
+	"       decl %0                 ;\n"
+	"       jnz 1b                  ;\n"
 	: "+r" (lines),
 	  "+r" (p1), "+r"(p2), "+r"(p3)
 	:
-        : "memory" );
+	: "memory" );
 
 	XMMS_RESTORE;
 }
@@ -696,66 +698,66 @@ static void
 xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
-        unsigned long lines = bytes >> 8;
+	unsigned long lines = bytes >> 8;
 	char xmm_save[16*4] ALIGN16;
 	int cr0;
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
+				PF1(i + 2)		\
 		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
+				PF2(i + 2)		\
 		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
 		PF3(i)					\
-				PF3(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
 		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
 		XO3(i,0)				\
-			XO3(i+1,1)			\
-				XO3(i+2,2)		\
-					XO3(i+3,3)	\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
 		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
 
 
 		PF0(0)
 				PF0(2)
 
 	" .align 32			;\n"
-        " 1:                            ;\n"
+	" 1:                            ;\n"
 
 		BLOCK(0)
 		BLOCK(4)
 		BLOCK(8)
 		BLOCK(12)
 
-        "       addl $256, %1           ;\n"
-        "       addl $256, %2           ;\n"
-        "       addl $256, %3           ;\n"
-        "       addl $256, %4           ;\n"
-        "       decl %0                 ;\n"
-        "       jnz 1b                  ;\n"
+	"       addl $256, %1           ;\n"
+	"       addl $256, %2           ;\n"
+	"       addl $256, %3           ;\n"
+	"       addl $256, %4           ;\n"
+	"       decl %0                 ;\n"
+	"       jnz 1b                  ;\n"
 	: "+r" (lines),
 	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
 	:
-        : "memory" );
+	: "memory" );
 
 	XMMS_RESTORE;
 }
@@ -764,7 +766,7 @@ static void
 xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
-        unsigned long lines = bytes >> 8;
+	unsigned long lines = bytes >> 8;
 	char xmm_save[16*4] ALIGN16;
 	int cr0;
 
@@ -776,65 +778,65 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	   because we modify p4 and p5 there, but we can't mark them
 	   as read/write, otherwise we'd overflow the 10-asm-operands
 	   limit of GCC < 3.1.  */
-	__asm__ ("" : "+r" (p4), "+r" (p5));
+	asm("" : "+r" (p4), "+r" (p5));
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
+				PF1(i + 2)		\
 		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
+				PF2(i + 2)		\
 		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
 		PF3(i)					\
-				PF3(i+2)		\
+				PF3(i + 2)		\
 		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
 		PF4(i)					\
-				PF4(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
 		XO3(i,0)				\
-			XO3(i+1,1)			\
-				XO3(i+2,2)		\
-					XO3(i+3,3)	\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
 		XO4(i,0)				\
-			XO4(i+1,1)			\
-				XO4(i+2,2)		\
-					XO4(i+3,3)	\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
 		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
 
 
 		PF0(0)
 				PF0(2)
 
 	" .align 32			;\n"
-        " 1:                            ;\n"
+	" 1:                            ;\n"
 
 		BLOCK(0)
 		BLOCK(4)
 		BLOCK(8)
 		BLOCK(12)
 
-        "       addl $256, %1           ;\n"
-        "       addl $256, %2           ;\n"
-        "       addl $256, %3           ;\n"
-        "       addl $256, %4           ;\n"
-        "       addl $256, %5           ;\n"
-        "       decl %0                 ;\n"
-        "       jnz 1b                  ;\n"
+	"       addl $256, %1           ;\n"
+	"       addl $256, %2           ;\n"
+	"       addl $256, %3           ;\n"
+	"       addl $256, %4           ;\n"
+	"       addl $256, %5           ;\n"
+	"       decl %0                 ;\n"
+	"       jnz 1b                  ;\n"
 	: "+r" (lines),
 	  "+r" (p1), "+r" (p2), "+r" (p3)
 	: "r" (p4), "r" (p5)
@@ -843,17 +845,17 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	/* p4 and p5 were modified, and now the variables are dead.
 	   Clobber them just to be sure nobody does something stupid
 	   like assuming they have some legal value.  */
-	__asm__ ("" : "=r" (p4), "=r" (p5));
+	asm("" : "=r" (p4), "=r" (p5));
 
 	XMMS_RESTORE;
 }
 
 static struct xor_block_template xor_block_pIII_sse = {
-        .name = "pIII_sse",
-        .do_2 =  xor_sse_2,
-        .do_3 =  xor_sse_3,
-        .do_4 =  xor_sse_4,
-        .do_5 = xor_sse_5,
+	.name = "pIII_sse",
+	.do_2 = xor_sse_2,
+	.do_3 = xor_sse_3,
+	.do_4 = xor_sse_4,
+	.do_5 = xor_sse_5,
 };
 
 /* Also try the generic routines.  */
@@ -861,21 +863,21 @@ static struct xor_block_template xor_block_pIII_sse = {
 
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES				\
-	do {						\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_8regs_p);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_32regs_p);		\
-	        if (cpu_has_xmm)			\
-			xor_speed(&xor_block_pIII_sse);	\
-	        if (cpu_has_mmx) {			\
-	                xor_speed(&xor_block_pII_mmx);	\
-	                xor_speed(&xor_block_p5_mmx);	\
-	        }					\
-	} while (0)
+do {							\
+	xor_speed(&xor_block_8regs);			\
+	xor_speed(&xor_block_8regs_p);			\
+	xor_speed(&xor_block_32regs);			\
+	xor_speed(&xor_block_32regs_p);			\
+	if (cpu_has_xmm)				\
+		xor_speed(&xor_block_pIII_sse);		\
+	if (cpu_has_mmx) {				\
+		xor_speed(&xor_block_pII_mmx);		\
+		xor_speed(&xor_block_p5_mmx);		\
+	}						\
+} while (0)
 
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
+#define XOR_SELECT_TEMPLATE(FASTEST)			\
 	(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
-- 
1.5.4.rc2


Return-Path: <linux-kernel-owner+w=401wt.eu-S935094AbYCWJKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094AbYCWJKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbYCWIMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:37 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2379 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbYCWIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:04 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 148/148] include/asm-x86/xor_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:04:03 -0700
Message-Id: <1206259443-13210-149-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/xor_64.h |  294 +++++++++++++++++++++++-----------------------
 1 files changed, 149 insertions(+), 145 deletions(-)

diff --git a/include/asm-x86/xor_64.h b/include/asm-x86/xor_64.h
index 1eee7fc..24957e3 100644
--- a/include/asm-x86/xor_64.h
+++ b/include/asm-x86/xor_64.h
@@ -24,20 +24,23 @@
  */
 
 /*
- * x86-64 changes / gcc fixes from Andi Kleen. 
+ * x86-64 changes / gcc fixes from Andi Kleen.
  * Copyright 2002 Andi Kleen, SuSE Labs.
  *
  * This hasn't been optimized for the hammer yet, but there are likely
  * no advantages to be gotten from x86-64 here anyways.
  */
 
-typedef struct { unsigned long a,b; } __attribute__((aligned(16))) xmm_store_t;
+typedef struct {
+	unsigned long a, b;
+} __attribute__((aligned(16))) xmm_store_t;
 
-/* Doesn't use gcc to save the XMM registers, because there is no easy way to 
+/* Doesn't use gcc to save the XMM registers, because there is no easy way to
    tell it to do a clts before the register saving. */
-#define XMMS_SAVE do {				\
+#define XMMS_SAVE				\
+do {						\
 	preempt_disable();			\
-	asm volatile (				\
+	asm volatile(				\
 		"movq %%cr0,%0		;\n\t"	\
 		"clts			;\n\t"	\
 		"movups %%xmm0,(%1)	;\n\t"	\
@@ -47,10 +50,11 @@ typedef struct { unsigned long a,b; } __attribute__((aligned(16))) xmm_store_t;
 		: "=&r" (cr0)			\
 		: "r" (xmm_save) 		\
 		: "memory");			\
-} while(0)
+} while (0)
 
-#define XMMS_RESTORE do {			\
-	asm volatile (				\
+#define XMMS_RESTORE				\
+do {						\
+	asm volatile(				\
 		"sfence			;\n\t"	\
 		"movups (%1),%%xmm0	;\n\t"	\
 		"movups 0x10(%1),%%xmm1	;\n\t"	\
@@ -61,72 +65,72 @@ typedef struct { unsigned long a,b; } __attribute__((aligned(16))) xmm_store_t;
 		: "r" (cr0), "r" (xmm_save)	\
 		: "memory");			\
 	preempt_enable();			\
-} while(0)
+} while (0)
 
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
 #define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
-#define LD(x,y)		"       movaps   "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
-#define ST(x,y)		"       movaps %%xmm"#y",   "OFFS(x)"(%[p1])	;\n"
+#define LD(x, y)	"       movaps   "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
+#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%[p1])	;\n"
 #define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
 #define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
 #define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
 #define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
 #define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%[p6])		;\n"
-#define XO1(x,y)	"       xorps   "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
-#define XO2(x,y)	"       xorps   "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
-#define XO3(x,y)	"       xorps   "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
-#define XO4(x,y)	"       xorps   "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
-#define XO5(x,y)	"       xorps   "OFFS(x)"(%[p6]), %%xmm"#y"	;\n"
+#define XO1(x, y)	"       xorps   "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
+#define XO2(x, y)	"       xorps   "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
+#define XO3(x, y)	"       xorps   "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
+#define XO4(x, y)	"       xorps   "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+#define XO5(x, y)	"       xorps   "OFFS(x)"(%[p6]), %%xmm"#y"	;\n"
 
 
 static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
-        unsigned int lines = bytes >> 8;
+	unsigned int lines = bytes >> 8;
 	unsigned long cr0;
 	xmm_store_t xmm_save[4];
 
 	XMMS_SAVE;
 
-        asm volatile (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
-		LD(i,0)					\
-			LD(i+1,1)			\
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
 
-        "       addq %[inc], %[p1]           ;\n"
-        "       addq %[inc], %[p2]           ;\n"
+	"       addq %[inc], %[p1]           ;\n"
+	"       addq %[inc], %[p2]           ;\n"
 		"		decl %[cnt] ; jnz 1b"
 	: [p1] "+r" (p1), [p2] "+r" (p2), [cnt] "+r" (lines)
-	: [inc] "r" (256UL) 
-        : "memory");
+	: [inc] "r" (256UL)
+	: "memory");
 
 	XMMS_RESTORE;
 }
@@ -141,52 +145,52 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
-		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+				PF1(i + 2)		\
+		LD(i, 0)					\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
-		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
-		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
-		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
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
 
-        "       addq %[inc], %[p1]           ;\n"
-        "       addq %[inc], %[p2]          ;\n"
-        "       addq %[inc], %[p3]           ;\n"
+	"       addq %[inc], %[p1]           ;\n"
+	"       addq %[inc], %[p2]          ;\n"
+	"       addq %[inc], %[p3]           ;\n"
 		"		decl %[cnt] ; jnz 1b"
 	: [cnt] "+r" (lines),
 	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
 	: [inc] "r" (256UL)
-	: "memory"); 
+	: "memory");
 	XMMS_RESTORE;
 }
 
@@ -195,64 +199,64 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4]; 
+	xmm_store_t xmm_save[4];
 	unsigned long cr0;
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
-		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
-		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
 		PF3(i)					\
-				PF3(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
-		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
-		XO3(i,0)				\
-			XO3(i+1,1)			\
-				XO3(i+2,2)		\
-					XO3(i+3,3)	\
-		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
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
 
-        "       addq %[inc], %[p1]           ;\n"
-        "       addq %[inc], %[p2]           ;\n"
-        "       addq %[inc], %[p3]           ;\n"
-        "       addq %[inc], %[p4]           ;\n"
+	"       addq %[inc], %[p1]           ;\n"
+	"       addq %[inc], %[p2]           ;\n"
+	"       addq %[inc], %[p3]           ;\n"
+	"       addq %[inc], %[p4]           ;\n"
 	"	decl %[cnt] ; jnz 1b"
 	: [cnt] "+c" (lines),
 	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
 	: [inc] "r" (256UL)
-        : "memory" );
+	: "memory" );
 
 	XMMS_RESTORE;
 }
@@ -261,70 +265,70 @@ static void
 xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
-        unsigned int lines = bytes >> 8;
+	unsigned int lines = bytes >> 8;
 	xmm_store_t xmm_save[4];
 	unsigned long cr0;
 
 	XMMS_SAVE;
 
-        __asm__ __volatile__ (
+	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
 		PF1(i)					\
-				PF1(i+2)		\
-		LD(i,0)					\
-			LD(i+1,1)			\
-				LD(i+2,2)		\
-					LD(i+3,3)	\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
 		PF2(i)					\
-				PF2(i+2)		\
-		XO1(i,0)				\
-			XO1(i+1,1)			\
-				XO1(i+2,2)		\
-					XO1(i+3,3)	\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
 		PF3(i)					\
-				PF3(i+2)		\
-		XO2(i,0)				\
-			XO2(i+1,1)			\
-				XO2(i+2,2)		\
-					XO2(i+3,3)	\
+				PF3(i + 2)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
 		PF4(i)					\
-				PF4(i+2)		\
-		PF0(i+4)				\
-				PF0(i+6)		\
-		XO3(i,0)				\
-			XO3(i+1,1)			\
-				XO3(i+2,2)		\
-					XO3(i+3,3)	\
-		XO4(i,0)				\
-			XO4(i+1,1)			\
-				XO4(i+2,2)		\
-					XO4(i+3,3)	\
-		ST(i,0)					\
-			ST(i+1,1)			\
-				ST(i+2,2)		\
-					ST(i+3,3)	\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		XO4(i, 0)				\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
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
 
-        "       addq %[inc], %[p1]           ;\n"
-        "       addq %[inc], %[p2]           ;\n"
-        "       addq %[inc], %[p3]           ;\n"
-        "       addq %[inc], %[p4]           ;\n"
-        "       addq %[inc], %[p5]           ;\n"
+	"       addq %[inc], %[p1]           ;\n"
+	"       addq %[inc], %[p2]           ;\n"
+	"       addq %[inc], %[p3]           ;\n"
+	"       addq %[inc], %[p4]           ;\n"
+	"       addq %[inc], %[p5]           ;\n"
 	"	decl %[cnt] ; jnz 1b"
 	: [cnt] "+c" (lines),
-  	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4), 
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4),
 	  [p5] "+r" (p5)
 	: [inc] "r" (256UL)
 	: "memory");
@@ -333,18 +337,18 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 }
 
 static struct xor_block_template xor_block_sse = {
-        .name = "generic_sse",
-        .do_2 = xor_sse_2,
-        .do_3 = xor_sse_3,
-        .do_4 = xor_sse_4,
-        .do_5 = xor_sse_5,
+	.name = "generic_sse",
+	.do_2 = xor_sse_2,
+	.do_3 = xor_sse_3,
+	.do_4 = xor_sse_4,
+	.do_5 = xor_sse_5,
 };
 
 #undef XOR_TRY_TEMPLATES
-#define XOR_TRY_TEMPLATES				\
-	do {						\
-		xor_speed(&xor_block_sse);	\
-	} while (0)
+#define XOR_TRY_TEMPLATES			\
+do {						\
+	xor_speed(&xor_block_sse);		\
+} while (0)
 
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
-- 
1.5.4.rc2


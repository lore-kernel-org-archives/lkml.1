Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbYCWIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbYCWIdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbYCWIKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2295 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbYCWIKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:02 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 118/148] include/asm-x86/string_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:33 -0700
Message-Id: <1206259443-13210-119-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/string_32.h |  141 +++++++++++++++++++++----------------------
 1 files changed, 70 insertions(+), 71 deletions(-)

diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 32afb63..c18e533 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -3,7 +3,7 @@
 
 #ifdef __KERNEL__
 
-/* Let gcc decide wether to inline or use the out of line functions */
+/* Let gcc decide whether to inline or use the out of line functions */
 
 #define __HAVE_ARCH_STRCPY
 extern char *strcpy(char *dest, const char *src);
@@ -32,16 +32,15 @@ extern size_t strlen(const char *s);
 static __always_inline void *__memcpy(void *to, const void *from, size_t n)
 {
 	int d0, d1, d2;
-	__asm__ __volatile__(
-		"rep ; movsl\n\t"
-		"movl %4,%%ecx\n\t"
-		"andl $3,%%ecx\n\t"
-		"jz 1f\n\t"
-		"rep ; movsb\n\t"
-		"1:"
-		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		: "0" (n/4), "g" (n), "1" ((long)to), "2" ((long)from)
-		: "memory");
+	asm volatile("rep ; movsl\n\t"
+		     "movl %4,%%ecx\n\t"
+		     "andl $3,%%ecx\n\t"
+		     "jz 1f\n\t"
+		     "rep ; movsb\n\t"
+		     "1:"
+		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		     : "0" (n / 4), "g" (n), "1" ((long)to), "2" ((long)from)
+		     : "memory");
 	return to;
 }
 
@@ -74,10 +73,12 @@ static __always_inline void *__constant_memcpy(void *to, const void *from, size_
 		*(int *)to = *(int *)from;
 		*((char *)to + 4) = *((char *)from + 4);
 		return to;
-	case 6: *(int *)to = *(int *)from;
+	case 6:
+		*(int *)to = *(int *)from;
 		*((short *)to + 2) = *((short *)from + 2);
 		return to;
-	case 8: *(int *)to = *(int *)from;
+	case 8:
+		*(int *)to = *(int *)from;
 		*((int *)to + 1) = *((int *)from + 1);
 		return to;
 #endif
@@ -88,54 +89,55 @@ static __always_inline void *__constant_memcpy(void *to, const void *from, size_
 	if (n >= 5 * 4) {
 		/* large block: use rep prefix */
 		int ecx;
-		__asm__ __volatile__(
-			"rep ; movsl"
-			: "=&c" (ecx), "=&D" (edi), "=&S" (esi)
-			: "0" (n/4), "1" (edi), "2" (esi)
-			: "memory"
+		asm volatile("rep ; movsl"
+			     : "=&c" (ecx), "=&D" (edi), "=&S" (esi)
+			     : "0" (n / 4), "1" (edi), "2" (esi)
+			     : "memory"
 		);
 	} else {
 		/* small block: don't clobber ecx + smaller code */
 		if (n >= 4 * 4)
-			__asm__ __volatile__("movsl"
-					     : "=&D"(edi), "=&S"(esi)
-					     : "0"(edi), "1"(esi)
-					     : "memory");
+			asm volatile("movsl"
+				     : "=&D"(edi), "=&S"(esi)
+				     : "0"(edi), "1"(esi)
+				     : "memory");
 		if (n >= 3 * 4)
-			__asm__ __volatile__("movsl"
-					     : "=&D"(edi), "=&S"(esi)
-					     : "0"(edi), "1"(esi)
-					     : "memory");
+			asm volatile("movsl"
+				     : "=&D"(edi), "=&S"(esi)
+				     : "0"(edi), "1"(esi)
+				     : "memory");
 		if (n >= 2 * 4)
-			__asm__ __volatile__("movsl"
-					     : "=&D"(edi), "=&S"(esi)
-					     : "0"(edi), "1"(esi)
-					     : "memory");
+			asm volatile("movsl"
+				     : "=&D"(edi), "=&S"(esi)
+				     : "0"(edi), "1"(esi)
+				     : "memory");
 		if (n >= 1 * 4)
-			__asm__ __volatile__("movsl"
-					     : "=&D"(edi), "=&S"(esi)
-					     : "0"(edi), "1"(esi)
-					     : "memory");
+			asm volatile("movsl"
+				     : "=&D"(edi), "=&S"(esi)
+				     : "0"(edi), "1"(esi)
+				     : "memory");
 	}
 	switch (n % 4) {
 		/* tail */
 	case 0:
 		return to;
 	case 1:
-		__asm__ __volatile__("movsb"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
+		asm volatile("movsb"
+			     : "=&D"(edi), "=&S"(esi)
+			     : "0"(edi), "1"(esi)
+			     : "memory");
 		return to;
-	case 2: __asm__ __volatile__("movsw"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
+	case 2:
+		asm volatile("movsw"
+			     : "=&D"(edi), "=&S"(esi)
+			     : "0"(edi), "1"(esi)
+			     : "memory");
 		return to;
-	default: __asm__ __volatile__("movsw\n\tmovsb"
-				      : "=&D"(edi), "=&S"(esi)
-				      : "0"(edi), "1"(esi)
-				      : "memory");
+	default:
+		asm volatile("movsw\n\tmovsb"
+			     : "=&D"(edi), "=&S"(esi)
+			     : "0"(edi), "1"(esi)
+			     : "memory");
 		return to;
 	}
 }
@@ -193,12 +195,11 @@ extern void *memchr(const void *cs, int c, size_t count);
 static inline void *__memset_generic(void *s, char c, size_t count)
 {
 	int d0, d1;
-	__asm__ __volatile__(
-		"rep\n\t"
-		"stosb"
-		: "=&c" (d0), "=&D" (d1)
-		: "a" (c), "1" (s), "0" (count)
-		: "memory");
+	asm volatile("rep\n\t"
+		     "stosb"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (c), "1" (s), "0" (count)
+		     : "memory");
 	return s;
 }
 
@@ -213,18 +214,17 @@ static inline void *__memset_generic(void *s, char c, size_t count)
 static __always_inline void *__constant_c_memset(void *s, unsigned long c, size_t count)
 {
 	int d0, d1;
-	__asm__ __volatile__(
-		"rep ; stosl\n\t"
-		"testb $2,%b3\n\t"
-		"je 1f\n\t"
-		"stosw\n"
-		"1:\ttestb $1,%b3\n\t"
-		"je 2f\n\t"
-		"stosb\n"
-		"2:"
-		: "=&c" (d0), "=&D" (d1)
-		: "a" (c), "q" (count), "0" (count/4), "1" ((long)s)
-		: "memory");
+	asm volatile("rep ; stosl\n\t"
+		     "testb $2,%b3\n\t"
+		     "je 1f\n\t"
+		     "stosw\n"
+		     "1:\ttestb $1,%b3\n\t"
+		     "je 2f\n\t"
+		     "stosb\n"
+		     "2:"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (c), "q" (count), "0" (count/4), "1" ((long)s)
+		     : "memory");
 	return s;
 }
 
@@ -260,13 +260,12 @@ static __always_inline void *__constant_c_and_count_memset(void *s, unsigned lon
 		return s;
 	}
 
-#define COMMON(x)						\
-	__asm__  __volatile__(					\
-		"rep ; stosl"					\
-		x						\
-		: "=&c" (d0), "=&D" (d1)			\
-		: "a" (pattern), "0" (count/4), "1" ((long)s)	\
-		: "memory")
+#define COMMON(x)							\
+	asm volatile("rep ; stosl"					\
+		     x							\
+		     : "=&c" (d0), "=&D" (d1)				\
+		     : "a" (pattern), "0" (count/4), "1" ((long)s)	\
+		     : "memory")
 
 	{
 		int d0, d1;
-- 
1.5.4.rc2


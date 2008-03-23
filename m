Return-Path: <linux-kernel-owner+w=401wt.eu-S1764668AbYCWIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764668AbYCWIg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbYCWIKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:16 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2298 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759735AbYCWIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:12 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 119/148] include/asm-x86/string_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:34 -0700
Message-Id: <1206259443-13210-120-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/string_64.h |   66 +++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/asm-x86/string_64.h b/include/asm-x86/string_64.h
index e583da7..52b5ab3 100644
--- a/include/asm-x86/string_64.h
+++ b/include/asm-x86/string_64.h
@@ -3,26 +3,24 @@
 
 #ifdef __KERNEL__
 
-/* Written 2002 by Andi Kleen */ 
+/* Written 2002 by Andi Kleen */
 
-/* Only used for special circumstances. Stolen from i386/string.h */ 
-static __always_inline void *
-__inline_memcpy(void * to, const void * from, size_t n)
+/* Only used for special circumstances. Stolen from i386/string.h */
+static __always_inline void *__inline_memcpy(void *to, const void *from, size_t n)
 {
-unsigned long d0, d1, d2;
-__asm__ __volatile__(
-	"rep ; movsl\n\t"
-	"testb $2,%b4\n\t"
-	"je 1f\n\t"
-	"movsw\n"
-	"1:\ttestb $1,%b4\n\t"
-	"je 2f\n\t"
-	"movsb\n"
-	"2:"
-	: "=&c" (d0), "=&D" (d1), "=&S" (d2)
-	:"0" (n/4), "q" (n),"1" ((long) to),"2" ((long) from)
-	: "memory");
-return (to);
+	unsigned long d0, d1, d2;
+	asm volatile("rep ; movsl\n\t"
+		     "testb $2,%b4\n\t"
+		     "je 1f\n\t"
+		     "movsw\n"
+		     "1:\ttestb $1,%b4\n\t"
+		     "je 2f\n\t"
+		     "movsb\n"
+		     "2:"
+		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		     : "0" (n / 4), "q" (n), "1" ((long)to), "2" ((long)from)
+		     : "memory");
+	return to;
 }
 
 /* Even with __builtin_ the compiler may decide to use the out of line
@@ -32,28 +30,30 @@ return (to);
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
 extern void *memcpy(void *to, const void *from, size_t len);
 #else
-extern void *__memcpy(void *to, const void *from, size_t len); 
-#define memcpy(dst,src,len) \
-	({ size_t __len = (len);				\
-	   void *__ret;						\
-	   if (__builtin_constant_p(len) && __len >= 64)	\
-		 __ret = __memcpy((dst),(src),__len);		\
-	   else							\
-		 __ret = __builtin_memcpy((dst),(src),__len);	\
-	   __ret; }) 
+extern void *__memcpy(void *to, const void *from, size_t len);
+#define memcpy(dst, src, len)					\
+({								\
+	size_t __len = (len);					\
+	void *__ret;						\
+	if (__builtin_constant_p(len) && __len >= 64)		\
+		__ret = __memcpy((dst), (src), __len);		\
+	else							\
+		__ret = __builtin_memcpy((dst), (src), __len);	\
+	__ret;							\
+})
 #endif
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
-void * memmove(void * dest,const void *src,size_t count);
+void *memmove(void *dest, const void *src, size_t count);
 
-int memcmp(const void * cs,const void * ct,size_t count);
-size_t strlen(const char * s);
-char *strcpy(char * dest,const char *src);
-char *strcat(char * dest, const char * src);
-int strcmp(const char * cs,const char * ct);
+int memcmp(const void *cs, const void *ct, size_t count);
+size_t strlen(const char *s);
+char *strcpy(char *dest, const char *src);
+char *strcat(char *dest, const char *src);
+int strcmp(const char *cs, const char *ct);
 
 #endif /* __KERNEL__ */
 
-- 
1.5.4.rc2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYCWIUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYCWIUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbYCWIIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:50 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2262 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbYCWIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:45 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 048/148] include/asm-x86/io_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:23 -0700
Message-Id: <1206259443-13210-49-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/io_64.h |  110 +++++++++++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index 084d60c..c3346bf 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -58,60 +58,75 @@ static inline void slow_down_io(void)
 /*
  * Talk about misusing macros..
  */
-#define __OUT1(s,x) \
+#define __OUT1(s, x)							\
 static inline void out##s(unsigned x value, unsigned short port) {
 
-#define __OUT2(s,s1,s2) \
-__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1"
+#define __OUT2(s, s1, s2)				\
+asm volatile ("out" #s " %" s1 "0,%" s2 "1"
 
 #ifndef REALLY_SLOW_IO
 #define REALLY_SLOW_IO
 #define UNSET_REALLY_SLOW_IO
 #endif
 
-#define __OUT(s,s1,x) \
-__OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port)); \
-		slow_down_io(); }
+#define __OUT(s, s1, x)							\
+	__OUT1(s, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port));	\
+	}								\
+	__OUT1(s##_p, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port)); \
+	slow_down_io();							\
+}
 
-#define __IN1(s) \
-static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
+#define __IN1(s)							\
+static inline RETURN_TYPE in##s(unsigned short port)			\
+{									\
+	RETURN_TYPE _v;
 
-#define __IN2(s,s1,s2) \
-__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0"
+#define __IN2(s, s1, s2)						\
+	asm volatile ("in" #s " %" s2 "1,%" s1 "0"
 
-#define __IN(s,s1,i...) \
-__IN1(s) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i); return _v; } \
-__IN1(s##_p) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	  \
-				slow_down_io(); return _v; }
+#define __IN(s, s1, i...)						\
+	__IN1(s) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
+	return _v;							\
+	}								\
+	__IN1(s##_p) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
+	slow_down_io(); \
+	return _v; }
 
 #ifdef UNSET_REALLY_SLOW_IO
 #undef REALLY_SLOW_IO
 #endif
 
-#define __INS(s) \
-static inline void ins##s(unsigned short port, void * addr, unsigned long count) \
-{ __asm__ __volatile__ ("rep ; ins" #s \
-: "=D" (addr), "=c" (count) : "d" (port),"0" (addr),"1" (count)); }
+#define __INS(s)							\
+static inline void ins##s(unsigned short port, void *addr,		\
+			  unsigned long count)				\
+{									\
+	asm volatile ("rep ; ins" #s					\
+		      : "=D" (addr), "=c" (count)			\
+		      : "d" (port), "0" (addr), "1" (count));		\
+}
 
-#define __OUTS(s) \
-static inline void outs##s(unsigned short port, const void * addr, unsigned long count) \
-{ __asm__ __volatile__ ("rep ; outs" #s \
-: "=S" (addr), "=c" (count) : "d" (port),"0" (addr),"1" (count)); }
+#define __OUTS(s)							\
+static inline void outs##s(unsigned short port, const void *addr,	\
+			   unsigned long count)				\
+{									\
+	asm volatile ("rep ; outs" #s					\
+		      : "=S" (addr), "=c" (count)			\
+		      : "d" (port), "0" (addr), "1" (count));		\
+}
 
 #define RETURN_TYPE unsigned char
-__IN(b,"")
+__IN(b, "")
 #undef RETURN_TYPE
 #define RETURN_TYPE unsigned short
-__IN(w,"")
+__IN(w, "")
 #undef RETURN_TYPE
 #define RETURN_TYPE unsigned int
-__IN(l,"")
+__IN(l, "")
 #undef RETURN_TYPE
 
-__OUT(b,"b",char)
-__OUT(w,"w",short)
-__OUT(l,,int)
+__OUT(b, "b", char)
+__OUT(w, "w", short)
+__OUT(l, , int)
 
 __INS(b)
 __INS(w)
@@ -132,12 +147,12 @@ __OUTS(l)
  * Change virtual addresses to physical addresses and vv.
  * These are pretty trivial
  */
-static inline unsigned long virt_to_phys(volatile void * address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return __pa(address);
 }
 
-static inline void * phys_to_virt(unsigned long address)
+static inline void *phys_to_virt(unsigned long address)
 {
 	return __va(address);
 }
@@ -200,18 +215,22 @@ static inline __u8 __readb(const volatile void __iomem *addr)
 {
 	return *(__force volatile __u8 *)addr;
 }
+
 static inline __u16 __readw(const volatile void __iomem *addr)
 {
 	return *(__force volatile __u16 *)addr;
 }
+
 static __always_inline __u32 __readl(const volatile void __iomem *addr)
 {
 	return *(__force volatile __u32 *)addr;
 }
+
 static inline __u64 __readq(const volatile void __iomem *addr)
 {
 	return *(__force volatile __u64 *)addr;
 }
+
 #define readb(x) __readb(x)
 #define readw(x) __readw(x)
 #define readl(x) __readl(x)
@@ -231,37 +250,44 @@ static inline void __writel(__u32 b, volatile void __iomem *addr)
 {
 	*(__force volatile __u32 *)addr = b;
 }
+
 static inline void __writeq(__u64 b, volatile void __iomem *addr)
 {
 	*(__force volatile __u64 *)addr = b;
 }
+
 static inline void __writeb(__u8 b, volatile void __iomem *addr)
 {
 	*(__force volatile __u8 *)addr = b;
 }
+
 static inline void __writew(__u16 b, volatile void __iomem *addr)
 {
 	*(__force volatile __u16 *)addr = b;
 }
-#define writeq(val,addr) __writeq((val),(addr))
-#define writel(val,addr) __writel((val),(addr))
-#define writew(val,addr) __writew((val),(addr))
-#define writeb(val,addr) __writeb((val),(addr))
+
+#define writeq(val, addr) __writeq((val), (addr))
+#define writel(val, addr) __writel((val), (addr))
+#define writew(val, addr) __writew((val), (addr))
+#define writeb(val, addr) __writeb((val), (addr))
 #define __raw_writeb writeb
 #define __raw_writew writew
 #define __raw_writel writel
 #define __raw_writeq writeq
 
-void __memcpy_fromio(void*,unsigned long,unsigned);
-void __memcpy_toio(unsigned long,const void*,unsigned);
+void __memcpy_fromio(void *, unsigned long, unsigned);
+void __memcpy_toio(unsigned long, const void *, unsigned);
 
-static inline void memcpy_fromio(void *to, const volatile void __iomem *from, unsigned len)
+static inline void memcpy_fromio(void *to, const volatile void __iomem *from,
+				 unsigned len)
 {
-	__memcpy_fromio(to,(unsigned long)from,len);
+	__memcpy_fromio(to, (unsigned long)from, len);
 }
-static inline void memcpy_toio(volatile void __iomem *to, const void *from, unsigned len)
+
+static inline void memcpy_toio(volatile void __iomem *to, const void *from,
+			       unsigned len)
 {
-	__memcpy_toio((unsigned long)to,from,len);
+	__memcpy_toio((unsigned long)to, from, len);
 }
 
 void memset_io(volatile void __iomem *a, int b, size_t c);
@@ -276,7 +302,7 @@ void memset_io(volatile void __iomem *a, int b, size_t c);
  */
 #define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
 
-#define flush_write_buffers() 
+#define flush_write_buffers()
 
 extern int iommu_bio_merge;
 #define BIO_VMERGE_BOUNDARY iommu_bio_merge
-- 
1.5.4.rc2


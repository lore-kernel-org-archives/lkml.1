Return-Path: <linux-kernel-owner+w=401wt.eu-S1765751AbYCWIpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765751AbYCWIpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759012AbYCWILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:00 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2317 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbYCWIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:55 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 047/148] include/asm-x86/io_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:22 -0700
Message-Id: <1206259443-13210-48-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/io_32.h |  137 ++++++++++++++++++++++++++++------------------
 1 files changed, 83 insertions(+), 54 deletions(-)

diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index 10d10df..c908196 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -59,14 +59,14 @@
  *
  *	The returned physical address is the physical (CPU) mapping for
  *	the memory address given. It is only valid to use this function on
- *	addresses directly mapped or allocated via kmalloc. 
+ *	addresses directly mapped or allocated via kmalloc.
  *
  *	This function does not give bus mappings for DMA transfers. In
  *	almost all conceivable cases a device driver should not be using
  *	this function
  */
- 
-static inline unsigned long virt_to_phys(volatile void * address)
+
+static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return __pa(address);
 }
@@ -84,7 +84,7 @@ static inline unsigned long virt_to_phys(volatile void * address)
  *	this function
  */
 
-static inline void * phys_to_virt(unsigned long address)
+static inline void *phys_to_virt(unsigned long address)
 {
 	return __va(address);
 }
@@ -163,16 +163,19 @@ extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 static inline unsigned char readb(const volatile void __iomem *addr)
 {
-	return *(volatile unsigned char __force *) addr;
+	return *(volatile unsigned char __force *)addr;
 }
+
 static inline unsigned short readw(const volatile void __iomem *addr)
 {
-	return *(volatile unsigned short __force *) addr;
+	return *(volatile unsigned short __force *)addr;
 }
+
 static inline unsigned int readl(const volatile void __iomem *addr)
 {
 	return *(volatile unsigned int __force *) addr;
 }
+
 #define readb_relaxed(addr) readb(addr)
 #define readw_relaxed(addr) readw(addr)
 #define readl_relaxed(addr) readl(addr)
@@ -182,15 +185,17 @@ static inline unsigned int readl(const volatile void __iomem *addr)
 
 static inline void writeb(unsigned char b, volatile void __iomem *addr)
 {
-	*(volatile unsigned char __force *) addr = b;
+	*(volatile unsigned char __force *)addr = b;
 }
+
 static inline void writew(unsigned short b, volatile void __iomem *addr)
 {
-	*(volatile unsigned short __force *) addr = b;
+	*(volatile unsigned short __force *)addr = b;
 }
+
 static inline void writel(unsigned int b, volatile void __iomem *addr)
 {
-	*(volatile unsigned int __force *) addr = b;
+	*(volatile unsigned int __force *)addr = b;
 }
 #define __raw_writeb writeb
 #define __raw_writew writew
@@ -233,12 +238,12 @@ memcpy_toio(volatile void __iomem *dst, const void *src, int count)
  *	1. Out of order aware processors
  *	2. Accidentally out of order processors (PPro errata #51)
  */
- 
+
 #if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
 
 static inline void flush_write_buffers(void)
 {
-	__asm__ __volatile__ ("lock; addl $0,0(%%esp)": : :"memory");
+	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
 }
 
 #else
@@ -258,7 +263,8 @@ extern void io_delay_init(void);
 #include <asm/paravirt.h>
 #else
 
-static inline void slow_down_io(void) {
+static inline void slow_down_io(void)
+{
 	native_io_delay();
 #ifdef REALLY_SLOW_IO
 	native_io_delay();
@@ -269,51 +275,74 @@ static inline void slow_down_io(void) {
 
 #endif
 
-#define __BUILDIO(bwl,bw,type) \
-static inline void out##bwl(unsigned type value, int port) { \
-	out##bwl##_local(value, port); \
-} \
-static inline unsigned type in##bwl(int port) { \
-	return in##bwl##_local(port); \
+#define __BUILDIO(bwl, bw, type)				\
+static inline void out##bwl(unsigned type value, int port)	\
+{								\
+	out##bwl##_local(value, port);				\
+}								\
+								\
+static inline unsigned type in##bwl(int port)			\
+{								\
+	return in##bwl##_local(port);				\
 }
 
-#define BUILDIO(bwl,bw,type) \
-static inline void out##bwl##_local(unsigned type value, int port) { \
-	__asm__ __volatile__("out" #bwl " %" #bw "0, %w1" : : "a"(value), "Nd"(port)); \
-} \
-static inline unsigned type in##bwl##_local(int port) { \
-	unsigned type value; \
-	__asm__ __volatile__("in" #bwl " %w1, %" #bw "0" : "=a"(value) : "Nd"(port)); \
-	return value; \
-} \
-static inline void out##bwl##_local_p(unsigned type value, int port) { \
-	out##bwl##_local(value, port); \
-	slow_down_io(); \
-} \
-static inline unsigned type in##bwl##_local_p(int port) { \
-	unsigned type value = in##bwl##_local(port); \
-	slow_down_io(); \
-	return value; \
-} \
-__BUILDIO(bwl,bw,type) \
-static inline void out##bwl##_p(unsigned type value, int port) { \
-	out##bwl(value, port); \
-	slow_down_io(); \
-} \
-static inline unsigned type in##bwl##_p(int port) { \
-	unsigned type value = in##bwl(port); \
-	slow_down_io(); \
-	return value; \
-} \
-static inline void outs##bwl(int port, const void *addr, unsigned long count) { \
-	__asm__ __volatile__("rep; outs" #bwl : "+S"(addr), "+c"(count) : "d"(port)); \
-} \
-static inline void ins##bwl(int port, void *addr, unsigned long count) { \
-	__asm__ __volatile__("rep; ins" #bwl : "+D"(addr), "+c"(count) : "d"(port)); \
+#define BUILDIO(bwl, bw, type)						\
+static inline void out##bwl##_local(unsigned type value, int port)	\
+{									\
+	asm volatile("out" #bwl " %" #bw "0, %w1"		\
+		     : : "a"(value), "Nd"(port));			\
+}									\
+									\
+static inline unsigned type in##bwl##_local(int port)			\
+{									\
+	unsigned type value;						\
+	asm volatile("in" #bwl " %w1, %" #bw "0"		\
+		     : "=a"(value) : "Nd"(port));			\
+	return value;							\
+}									\
+									\
+static inline void out##bwl##_local_p(unsigned type value, int port)	\
+{									\
+	out##bwl##_local(value, port);					\
+	slow_down_io();							\
+}									\
+									\
+static inline unsigned type in##bwl##_local_p(int port)			\
+{									\
+	unsigned type value = in##bwl##_local(port);			\
+	slow_down_io();							\
+	return value;							\
+}									\
+									\
+__BUILDIO(bwl, bw, type)						\
+									\
+static inline void out##bwl##_p(unsigned type value, int port)		\
+{									\
+	out##bwl(value, port);						\
+	slow_down_io();							\
+}									\
+									\
+static inline unsigned type in##bwl##_p(int port)			\
+{									\
+	unsigned type value = in##bwl(port);				\
+	slow_down_io();							\
+	return value;							\
+}									\
+									\
+static inline void outs##bwl(int port, const void *addr, unsigned long count) \
+{									\
+	asm volatile("rep; outs" #bwl					\
+		     : "+S"(addr), "+c"(count) : "d"(port));		\
+}									\
+									\
+static inline void ins##bwl(int port, void *addr, unsigned long count)	\
+{									\
+	asm volatile("rep; ins" #bwl					\
+		     : "+D"(addr), "+c"(count) : "d"(port));		\
 }
 
-BUILDIO(b,b,char)
-BUILDIO(w,w,short)
-BUILDIO(l,,int)
+BUILDIO(b, b, char)
+BUILDIO(w, w, short)
+BUILDIO(l, , int)
 
 #endif
-- 
1.5.4.rc2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762899AbXJENNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762899AbXJENNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbXJENNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:13:19 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:38147 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762177AbXJENNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:13:17 -0400
Date: Fri, 5 Oct 2007 14:13:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, aubrey.li@analog.com,
       bernd.schmidt@analog.com, bryan.wu@analog.com, grace.pan@analog.com,
       marc.hoffman@analog.com, michael.hennerich@analog.com,
       michael.frysinger@analog.com, jerry.zeng@analog.com,
       jie.zhang@analog.com, robin.getz@analog.com, roy.huang@analog.com,
       sonic.zhang@analog.com, vivi.li@analog.com, yi.li@analog.com,
       paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Replace __attribute_pure__ with __pure
Message-ID: <20071005131309.GA445@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent with the use of attributes in the rest of the kernel
replace all use of __attribute_pure__ with __pure and delete the
definition of __attribute_pure__.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

---
Patch against v2.6.23-rc8-mm2.

And btw why does Analog list half their employees in the MAINTAINERS entry?
Seems a little over the top ...

  Ralf

diff --git a/arch/arm/nwfpe/fpopcode.h b/arch/arm/nwfpe/fpopcode.h
index ec78e35..0090b19 100644
--- a/arch/arm/nwfpe/fpopcode.h
+++ b/arch/arm/nwfpe/fpopcode.h
@@ -369,20 +369,20 @@ TABLE 5
 #define getRoundingMode(opcode)		((opcode & MASK_ROUNDING_MODE) >> 5)
 
 #ifdef CONFIG_FPE_NWFPE_XP
-static inline __attribute_pure__ floatx80 getExtendedConstant(const unsigned int nIndex)
+static inline floatx80 __pure getExtendedConstant(const unsigned int nIndex)
 {
 	extern const floatx80 floatx80Constant[];
 	return floatx80Constant[nIndex];
 }
 #endif
 
-static inline __attribute_pure__ float64 getDoubleConstant(const unsigned int nIndex)
+static inline float64 __pure getDoubleConstant(const unsigned int nIndex)
 {
 	extern const float64 float64Constant[];
 	return float64Constant[nIndex];
 }
 
-static inline __attribute_pure__ float32 getSingleConstant(const unsigned int nIndex)
+static inline float32 __pure getSingleConstant(const unsigned int nIndex)
 {
 	extern const float32 float32Constant[];
 	return float32Constant[nIndex];
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index 9eac65f..dcf22a3 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -144,7 +144,7 @@ const static unsigned int palette2pixelformat[] = {
 	[VIDEO_PALETTE_YUV422P] = V4L2_PIX_FMT_YUV422P,
 };
 
-static unsigned int __attribute_pure__
+static unsigned int __pure
 palette_to_pixelformat(unsigned int palette)
 {
 	if (palette < ARRAY_SIZE(palette2pixelformat))
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index 6bb3e0d..c571e95 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -104,13 +104,13 @@ unsigned long get_wchan(struct task_struct *p);
 #define cpu_relax()    	barrier()
 
 /* Get the Silicon Revision of the chip */
-static inline __attribute_pure__ uint32_t bfin_revid(void)
+static inline uint32_t __pure bfin_revid(void)
 {
 	/* stored in the upper 4 bits */
 	return bfin_read_CHIPID() >> 28;
 }
 
-static inline __attribute_pure__ uint32_t bfin_compiled_revid(void)
+static inline uint32_t __pure bfin_compiled_revid(void)
 {
 #if defined(CONFIG_BF_REV_0_0)
 	return 0;
diff --git a/include/asm-ppc/time.h b/include/asm-ppc/time.h
index f7eadf6..81dbcd4 100644
--- a/include/asm-ppc/time.h
+++ b/include/asm-ppc/time.h
@@ -57,7 +57,7 @@ static __inline__ void set_dec(unsigned int val)
 /* Accessor functions for the timebase (RTC on 601) registers. */
 /* If one day CONFIG_POWER is added just define __USE_RTC as 1 */
 #ifdef CONFIG_6xx
-extern __inline__ int __attribute_pure__ __USE_RTC(void) {
+extern __inline__ int __pure __USE_RTC(void) {
 	return (mfspr(SPRN_PVR)>>16) == 1;
 }
 #else
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index acd5833..fe23792 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -36,10 +36,20 @@
 #define __weak				__attribute__((weak))
 #define __naked				__attribute__((naked))
 #define __noreturn			__attribute__((noreturn))
+
+/*
+ * From the GCC manual:
+ *
+ * Many functions have no effects except the return value and their
+ * return value depends only on the parameters and/or global
+ * variables.  Such a function can be subject to common subexpression
+ * elimination and loop optimization just as an arithmetic operator
+ * would be.
+ * [...]
+ */
 #define __pure				__attribute__((pure))
 #define __aligned(x)			__attribute__((aligned(x)))
 #define __printf(a,b)			__attribute__((format(printf,a,b)))
 #define  noinline			__attribute__((noinline))
-#define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 2165cc9..53354e1 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -167,20 +167,6 @@ extern int do_check_likely(struct likeliness *likeliness, int exp);
 # define __maybe_unused		/* unimplemented */
 #endif
 
-/*
- * From the GCC manual:
- *
- * Many functions have no effects except the return value and their
- * return value depends only on the parameters and/or global
- * variables.  Such a function can be subject to common subexpression
- * elimination and loop optimization just as an arithmetic operator
- * would be.
- * [...]
- */
-#ifndef __attribute_pure__
-# define __attribute_pure__	/* unimplemented */
-#endif
-
 #ifndef noinline
 #define noinline
 #endif
diff --git a/lib/crc32.c b/lib/crc32.c
index bfc3331..d2c2f25 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -49,7 +49,7 @@ MODULE_LICENSE("GPL");
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len);
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_LE_BITS == 1
 /*
@@ -57,7 +57,7 @@ u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len);
  * simplified by inlining the table in ?: form.
  */
 
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -69,7 +69,7 @@ u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
 }
 #else				/* Table-based approach */
 
-u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
 	const u32      *b =(u32 *)p;
@@ -145,7 +145,7 @@ u32 __attribute_pure__ crc32_le(u32 crc, unsigned char const *p, size_t len)
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len);
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_BE_BITS == 1
 /*
@@ -153,7 +153,7 @@ u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len);
  * simplified by inlining the table in ?: form.
  */
 
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -167,7 +167,7 @@ u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len)
 }
 
 #else				/* Table-based approach */
-u32 __attribute_pure__ crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
 	const u32      *b =(u32 *)p;
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 60f4680..802f11f 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL(crc32c_le);
  * loop below with crc32 and vary the POLY if we don't find value in terms
  * of space and maintainability in keeping the two modules separate.
  */
-u32 __attribute_pure__
+u32 __pure
 crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
@@ -160,7 +160,7 @@ static const u32 crc32c_table[256] = {
  * crc using table.
  */
 
-u32 __attribute_pure__
+u32 __pure
 crc32c_le(u32 seed, unsigned char const *data, size_t length)
 {
 	u32 crc = __cpu_to_le32(seed);
@@ -177,7 +177,7 @@ crc32c_le(u32 seed, unsigned char const *data, size_t length)
 EXPORT_SYMBOL(crc32c_be);
 
 #if CRC_BE_BITS == 1
-u32 __attribute_pure__
+u32 __pure
 crc32c_be(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;

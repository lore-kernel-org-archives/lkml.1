Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXEOLSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXEOLSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXEOLS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:18:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57721 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbXEOLS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:18:29 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 15 May 2007 07:17:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Russell King <rmk@arm.linux.org.uk>, mchebab@infradead.org,
       Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Replace "__attribute_pure__" with the shorter "__pure".
Message-ID: <Pine.LNX.4.64.0705150705570.24052@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace the few occurrences of, and the macro definition of,
"__attribute_pure__" with the shorter "__pure", to be more consistent
with the other abbreviations in include/linux/compiler-gcc.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that the short form of "__pure" is already defined, there's no
point in supporting a longer (redundant) macro definition for exactly
the same thing.

  compile tested on x86 with "make allyesconfig".


 arch/arm/nwfpe/fpopcode.h         |    6 +++---
 drivers/media/video/v4l1-compat.c |    2 +-
 include/asm-ppc/time.h            |    2 +-
 include/linux/compiler-gcc.h      |    1 -
 include/linux/compiler.h          |    3 ---
 lib/crc32.c                       |   12 ++++++------
 lib/libcrc32c.c                   |    6 +++---
 7 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/arm/nwfpe/fpopcode.h b/arch/arm/nwfpe/fpopcode.h
index ec78e35..8ae6f42 100644
--- a/arch/arm/nwfpe/fpopcode.h
+++ b/arch/arm/nwfpe/fpopcode.h
@@ -369,20 +369,20 @@ TABLE 5
 #define getRoundingMode(opcode)		((opcode & MASK_ROUNDING_MODE) >> 5)

 #ifdef CONFIG_FPE_NWFPE_XP
-static inline __attribute_pure__ floatx80 getExtendedConstant(const unsigned int nIndex)
+static inline __pure floatx80 getExtendedConstant(const unsigned int nIndex)
 {
 	extern const floatx80 floatx80Constant[];
 	return floatx80Constant[nIndex];
 }
 #endif

-static inline __attribute_pure__ float64 getDoubleConstant(const unsigned int nIndex)
+static inline __pure float64 getDoubleConstant(const unsigned int nIndex)
 {
 	extern const float64 float64Constant[];
 	return float64Constant[nIndex];
 }

-static inline __attribute_pure__ float32 getSingleConstant(const unsigned int nIndex)
+static inline __pure float32 getSingleConstant(const unsigned int nIndex)
 {
 	extern const float32 float32Constant[];
 	return float32Constant[nIndex];
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index ede8543..6dbbfa2 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -145,7 +145,7 @@ const static unsigned int palette2pixelformat[] = {
 	[VIDEO_PALETTE_YUV422P] = V4L2_PIX_FMT_YUV422P,
 };

-static unsigned int __attribute_pure__
+static unsigned int __pure
 palette_to_pixelformat(unsigned int palette)
 {
 	if (palette < ARRAY_SIZE(palette2pixelformat))
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
index 03ec231..7820fef 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -38,6 +38,5 @@
 #define __aligned(x)			__attribute__((aligned(x)))
 #define __printf(a,b)			__attribute__((format(printf,a,b)))
 #define  noinline			__attribute__((noinline))
-#define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 498c359..cc0abaa 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -144,9 +144,6 @@ extern void __chk_io_ptr(const void __iomem *);
  * would be.
  * [...]
  */
-#ifndef __attribute_pure__
-# define __attribute_pure__	/* unimplemented */
-#endif

 #ifndef noinline
 #define noinline
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

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYEaWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYEaWht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYEaWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:37:42 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37732 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754768AbYEaWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:37:41 -0400
Date: Sat, 31 May 2008 23:37:31 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Remove 'generic_' prefix from generic little-endian bitops
Message-ID: <20080531223730.GB30769@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531223419.GA30769@solarflare.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 include/asm-generic/bitops/ext2-non-atomic.h |   12 ++++----
 include/asm-generic/bitops/le.h              |   40 ++++++++++++++-----------
 include/asm-generic/bitops/minix-le.h        |   10 +++---
 include/asm-m68k/bitops.h                    |    2 +-
 include/asm-m68knommu/bitops.h               |    2 +-
 include/asm-powerpc/bitops.h                 |    7 ++++-
 6 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/include/asm-generic/bitops/ext2-non-atomic.h b/include/asm-generic/bitops/ext2-non-atomic.h
index 63cf822..b9281c2 100644
--- a/include/asm-generic/bitops/ext2-non-atomic.h
+++ b/include/asm-generic/bitops/ext2-non-atomic.h
@@ -4,17 +4,17 @@
 #include <asm-generic/bitops/le.h>
 
 #define ext2_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_le_bit((nr),(unsigned long *)(addr))
 #define ext2_clear_bit(nr,addr)	\
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_le_bit((nr),(unsigned long *)(addr))
 
 #define ext2_test_bit(nr,addr)	\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_le_bit((nr),(unsigned long *)(addr))
 #define ext2_find_first_zero_bit(addr, size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr), (size))
+	find_first_zero_le_bit((unsigned long *)(addr), (size))
 #define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_ */
diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 80e3bf1..a51c4ca 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -9,41 +9,45 @@
 
 #if defined(__LITTLE_ENDIAN)
 
-#define generic_test_le_bit(nr, addr) test_bit(nr, addr)
-#define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
-#define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
+#define test_le_bit(nr, addr) test_bit(nr, addr)
+#define __set_le_bit(nr, addr) __set_bit(nr, addr)
+#define __clear_le_bit(nr, addr) __clear_bit(nr, addr)
 
-#define generic_test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
-#define generic_test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
+#define test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
+#define test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
 
-#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
-#define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
+#define __test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
+#define __test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
 
-#define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
-#define generic_find_next_le_bit(addr, size, offset) \
+#define find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
+#define find_next_le_bit(addr, size, offset) \
 			find_next_bit(addr, size, offset)
 
 #elif defined(__BIG_ENDIAN)
 
-#define generic_test_le_bit(nr, addr) \
+#define test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___set_le_bit(nr, addr) \
+#define __set_le_bit(nr, addr) \
 	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___clear_le_bit(nr, addr) \
+#define __clear_le_bit(nr, addr) \
 	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic_test_and_set_le_bit(nr, addr) \
+#define test_and_set_le_bit(nr, addr) \
 	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic_test_and_clear_le_bit(nr, addr) \
+#define test_and_clear_le_bit(nr, addr) \
 	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define generic___test_and_set_le_bit(nr, addr) \
+#define __test_and_set_le_bit(nr, addr) \
 	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___test_and_clear_le_bit(nr, addr) \
+#define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
+#define find_next_zero_le_bit(addr, size, offset) \
+	generic_find_next_zero_le_bit(addr, size, offset)
 extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
+#define find_next_le_bit(addr, size, offset) \
+	generic_find_next_le_bit(addr, size, offset)
 extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
@@ -51,7 +55,7 @@ extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
 #error "Please fix <asm/byteorder.h>"
 #endif
 
-#define generic_find_first_zero_le_bit(addr, size) \
-        generic_find_next_zero_le_bit((addr), (size), 0)
+#define find_first_zero_le_bit(addr, size) \
+        find_next_zero_le_bit((addr), (size), 0)
 
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
diff --git a/include/asm-generic/bitops/minix-le.h b/include/asm-generic/bitops/minix-le.h
index 4a981c1..da3613d 100644
--- a/include/asm-generic/bitops/minix-le.h
+++ b/include/asm-generic/bitops/minix-le.h
@@ -4,14 +4,14 @@
 #include <asm-generic/bitops/le.h>
 
 #define minix_test_and_set_bit(nr,addr)	\
-	generic___test_and_set_le_bit((nr),(unsigned long *)(addr))
+	__test_and_set_le_bit((nr),(unsigned long *)(addr))
 #define minix_set_bit(nr,addr)		\
-	generic___set_le_bit((nr),(unsigned long *)(addr))
+	__set_le_bit((nr),(unsigned long *)(addr))
 #define minix_test_and_clear_bit(nr,addr) \
-	generic___test_and_clear_le_bit((nr),(unsigned long *)(addr))
+	__test_and_clear_le_bit((nr),(unsigned long *)(addr))
 #define minix_test_bit(nr,addr)		\
-	generic_test_le_bit((nr),(unsigned long *)(addr))
+	test_le_bit((nr),(unsigned long *)(addr))
 #define minix_find_first_zero_bit(addr,size) \
-	generic_find_first_zero_le_bit((unsigned long *)(addr),(size))
+	find_first_zero_le_bit((unsigned long *)(addr),(size))
 
 #endif /* _ASM_GENERIC_BITOPS_MINIX_LE_H_ */
diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 83d1f28..27d7ae9 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -411,7 +411,7 @@ static inline int ext2_find_next_zero_bit(const void *vaddr, unsigned size,
 	return (p - addr) * 32 + res;
 }
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-m68knommu/bitops.h b/include/asm-m68knommu/bitops.h
index c142fbf..6213a08 100644
--- a/include/asm-m68knommu/bitops.h
+++ b/include/asm-m68knommu/bitops.h
@@ -295,7 +295,7 @@ found_middle:
 }
 
 #define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+	find_next_le_bit((unsigned long *)(addr), (size), (off))
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 897eade..dcbf9a8 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -362,10 +362,15 @@ static __inline__ int test_le_bit(unsigned long nr,
 #define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) generic_find_next_zero_le_bit((addr), (size), 0)
+#define find_first_zero_le_bit(addr, size) \
+	generic_find_next_zero_le_bit(addr, size, 0)
+#define find_next_zero_le_bit(addr, size, offset) \
+	generic_find_next_zero_le_bit(addr, size, offset)
 unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 
+#define find_next_le_bit(addr, size, offset) \
+	generic_find_next_le_bit(addr, size, offset)
 unsigned long generic_find_next_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbYEaWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbYEaWiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYEaWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:38:43 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37736 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751795AbYEaWim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:38:42 -0400
Date: Sat, 31 May 2008 23:38:33 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Use <asm-generic/bitops/le.h> in <asm-powerpc/bitops.h>
Message-ID: <20080531223832.GC30769@solarflare.com>
References: <f12db478511ce4ff462d1b236724e4fc46470a4d.1212272760.git.bhutchings@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531223419.GA30769@solarflare.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc little-endian bitops have no arch-specific optimisations.

Remove clashing macros from these headers.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 include/asm-generic/bitops/le.h |    1 -
 include/asm-powerpc/bitops.h    |   34 +---------------------------------
 2 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index a51c4ca..08c5df3 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -4,7 +4,6 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
 #if defined(__LITTLE_ENDIAN)
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index dcbf9a8..afe2fa3 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -54,7 +54,6 @@
 
 #define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
 static __inline__ void set_bit(int nr, volatile unsigned long *addr)
 {
@@ -340,39 +339,8 @@ static __inline__ int fls64(__u64 x)
 
 /* Little-endian versions */
 
-static __inline__ int test_le_bit(unsigned long nr,
-				  __const__ unsigned long *addr)
-{
-	__const__ unsigned char	*tmp = (__const__ unsigned char *) addr;
-	return (tmp[nr >> 3] >> (nr & 7)) & 1;
-}
+#include <asm-generic/bitops/le.h>
 
-#define __set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define __test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define find_first_zero_le_bit(addr, size) \
-	generic_find_next_zero_le_bit(addr, size, 0)
-#define find_next_zero_le_bit(addr, size, offset) \
-	generic_find_next_zero_le_bit(addr, size, offset)
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-				    unsigned long size, unsigned long offset);
-
-#define find_next_le_bit(addr, size, offset) \
-	generic_find_next_le_bit(addr, size, offset)
-unsigned long generic_find_next_le_bit(const unsigned long *addr,
-				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
 #define ext2_set_bit(nr,addr) \
-- 
1.5.4

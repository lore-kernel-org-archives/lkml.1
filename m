Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbYCWI6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbYCWI6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbYCWIL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:57 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2355 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760165AbYCWILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:46 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 008/148] include/asm-x86/bitops_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:43 -0700
Message-Id: <1206259443-13210-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/bitops_32.h |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
index c19fbe9..3ed64b2 100644
--- a/include/asm-x86/bitops_32.h
+++ b/include/asm-x86/bitops_32.h
@@ -20,20 +20,22 @@ static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
 
 	if (!size)
 		return 0;
-	/* This looks at memory. Mark it volatile to tell gcc not to move it around */
-	__asm__ __volatile__(
-		"movl $-1,%%eax\n\t"
-		"xorl %%edx,%%edx\n\t"
-		"repe; scasl\n\t"
-		"je 1f\n\t"
-		"xorl -4(%%edi),%%eax\n\t"
-		"subl $4,%%edi\n\t"
-		"bsfl %%eax,%%edx\n"
-		"1:\tsubl %%ebx,%%edi\n\t"
-		"shll $3,%%edi\n\t"
-		"addl %%edi,%%edx"
-		:"=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
-		:"1" ((size + 31) >> 5), "2" (addr), "b" (addr) : "memory");
+	/* This looks at memory.
+	 * Mark it volatile to tell gcc not to move it around
+	 */
+	asm volatile("movl $-1,%%eax\n\t"
+		     "xorl %%edx,%%edx\n\t"
+		     "repe; scasl\n\t"
+		     "je 1f\n\t"
+		     "xorl -4(%%edi),%%eax\n\t"
+		     "subl $4,%%edi\n\t"
+		     "bsfl %%eax,%%edx\n"
+		     "1:\tsubl %%ebx,%%edi\n\t"
+		     "shll $3,%%edi\n\t"
+		     "addl %%edi,%%edx"
+		     : "=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
+		     : "1" ((size + 31) >> 5), "2" (addr),
+		       "b" (addr) : "memory");
 	return res;
 }
 
@@ -53,7 +55,7 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 		unsigned long val = *addr++;
 		if (val)
 			return __ffs(val) + x;
-		x += (sizeof(*addr)<<3);
+		x += sizeof(*addr) << 3;
 	}
 	return x;
 }
@@ -72,10 +74,10 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-		test_and_set_bit((nr), (unsigned long *)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-		test_and_clear_bit((nr), (unsigned long *)addr)
+#define ext2_set_bit_atomic(lock, nr, addr)			\
+	test_and_set_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)			\
+	test_and_clear_bit((nr), (unsigned long *)(addr))
 
 #include <asm-generic/bitops/minix.h>
 
-- 
1.5.4.rc2


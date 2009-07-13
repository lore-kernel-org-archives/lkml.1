Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZGMHPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZGMHPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZGMHPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:15:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZGMHPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:15:52 -0400
Subject: [FIX REQUEST] x86: Remove avoidable multiple ifdef blocks
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 12:45:12 +0530
Message-Id: <1247469312.2525.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In -tip there are many instances where multiple ifdefs are used which
can be easily avoidable to make core more readable and consistent.

Like multiple 'ifdef __KERNEL__' in asm/bitops.h :

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..477f556 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -434,11 +434,6 @@ static inline int fls(int x)
 #endif
 	return r + 1;
 }
-#endif /* __KERNEL__ */
-
-#undef ADDR
-
-#ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
 
@@ -446,12 +441,6 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/hweight.h>
 
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\
@@ -462,4 +451,9 @@ static inline int fls(int x)
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
+
+#undef ADDR
+
+#include <asm-generic/bitops/fls64.h>
+
 #endif /* _ASM_X86_BITOPS_H */

Similarly in ifdef __KERNEL__ in asm/e820.h and asm/signal.h

And similarly others ifdef block.

Thanks,
--
JSR


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765300AbXHOJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765300AbXHOJxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXHOJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:09 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:58681 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXHOJt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:57 -0400
Message-Id: <20070815094850.362629389@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:46 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/10] m68k: Use _AC() instead of #ifdef __ASSEMBLY__
Content-Disposition: inline; filename=m68k-use-_AC.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: Use _AC() instead of #ifdef __ASSEMBLY__ hackery when needed, remove
hackery when unused.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/page.h      |    8 +++-----
 include/asm-m68k/processor.h |    4 ----
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/include/asm-m68k/page.h
+++ b/include/asm-m68k/page.h
@@ -4,17 +4,15 @@
 
 #ifdef __KERNEL__
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #ifndef CONFIG_SUN3
 #define PAGE_SHIFT	(12)
 #else
 #define PAGE_SHIFT	(13)
 #endif
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #include <asm/setup.h>
--- a/include/asm-m68k/processor.h
+++ b/include/asm-m68k/processor.h
@@ -38,12 +38,8 @@ static inline void wrusp(unsigned long u
 #ifndef CONFIG_SUN3
 #define TASK_SIZE	(0xF0000000UL)
 #else
-#ifdef __ASSEMBLY__
-#define TASK_SIZE	(0x0E000000)
-#else
 #define TASK_SIZE	(0x0E000000UL)
 #endif
-#endif
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


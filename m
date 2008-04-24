Return-Path: <linux-kernel-owner+w=401wt.eu-S1763791AbYDXSjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763791AbYDXSjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbYDXSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:39 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:48040 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbYDXSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:19 -0400
Message-Id: <20080424183241.990859107@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:46 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 06/15] m68k: Make gcc aware that BUG() does not return
Content-Disposition: inline; filename=m68k-silence-BUG-can-return-warnings.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Use `__builtin_trap()' instead of `asm volatile("illegal")' in the m68k BUG()
macros (as suggested by Andrew Pinski), to kill warnings in code that assumes
BUG() does not return.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-m68k/bug.h
+++ b/include/asm-m68k/bug.h
@@ -7,7 +7,7 @@
 #ifndef CONFIG_SUN3
 #define BUG() do { \
 	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
-	asm volatile("illegal"); \
+	__builtin_trap(); \
 } while (0)
 #else
 #define BUG() do { \
@@ -17,7 +17,7 @@
 #endif
 #else
 #define BUG() do { \
-	asm volatile("illegal"); \
+	__builtin_trap(); \
 } while (0)
 #endif
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


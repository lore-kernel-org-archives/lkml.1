Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbYERTE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbYERTE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbYERSyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:25 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:52101 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761941AbYERSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:05 -0400
Message-Id: <20080518185153.392485636@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:21 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 15/18] m68k: Prefix ISA type with ISA_TYPE_
Content-Disposition: inline; filename=m68k-isa-type-name-conflicts.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The *_ISA type defines are quite generic and cause namespace conflicts
(e.g. with `AMIGAHW_DECLARE(GG2_ISA)' in <asm/amigahw.h>) for some kernel
configurations. Use ISA_TYPE_* to avoid such conflicts.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup.c |    6 +++---
 include/asm-m68k/io.h    |   44 ++++++++++++++++++++++----------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -348,17 +348,17 @@ void __init setup_arch(char **cmdline_p)
 #if defined(CONFIG_ISA) && defined(MULTI_ISA)
 #if defined(CONFIG_Q40)
 	if (MACH_IS_Q40) {
-		isa_type = Q40_ISA;
+		isa_type = ISA_TYPE_Q40;
 		isa_sex = 0;
 	}
 #elif defined(CONFIG_GG2)
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(GG2_ISA)) {
-		isa_type = GG2_ISA;
+		isa_type = ISA_TYPE_GG2;
 		isa_sex = 0;
 	}
 #elif defined(CONFIG_AMIGA_PCMCIA)
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(PCMCIA)) {
-		isa_type = AG_ISA;
+		isa_type = ISA_TYPE_AG;
 		isa_sex = 1;
 	}
 #endif
--- a/include/asm-m68k/io.h
+++ b/include/asm-m68k/io.h
@@ -91,20 +91,20 @@ extern unsigned long gg2_isa_base;
 #undef MULTI_ISA
 #endif
 
-#define Q40_ISA (1)
-#define GG2_ISA (2)
-#define AG_ISA  (3)
+#define ISA_TYPE_Q40 (1)
+#define ISA_TYPE_GG2 (2)
+#define ISA_TYPE_AG  (3)
 
 #if defined(CONFIG_Q40) && !defined(MULTI_ISA)
-#define ISA_TYPE Q40_ISA
+#define ISA_TYPE ISA_TYPE_Q40
 #define ISA_SEX  0
 #endif
 #if defined(CONFIG_AMIGA_PCMCIA) && !defined(MULTI_ISA)
-#define ISA_TYPE AG_ISA
+#define ISA_TYPE ISA_TYPE_AG
 #define ISA_SEX  1
 #endif
 #if defined(CONFIG_GG2) && !defined(MULTI_ISA)
-#define ISA_TYPE GG2_ISA
+#define ISA_TYPE ISA_TYPE_GG2
 #define ISA_SEX  0
 #endif
 
@@ -126,13 +126,13 @@ static inline u8 __iomem *isa_itb(unsign
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_Q40
-    case Q40_ISA: return (u8 __iomem *)Q40_ISA_IO_B(addr);
+    case ISA_TYPE_Q40: return (u8 __iomem *)Q40_ISA_IO_B(addr);
 #endif
 #ifdef CONFIG_GG2
-    case GG2_ISA: return (u8 __iomem *)GG2_ISA_IO_B(addr);
+    case ISA_TYPE_GG2: return (u8 __iomem *)GG2_ISA_IO_B(addr);
 #endif
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: return (u8 __iomem *)AG_ISA_IO_B(addr);
+    case ISA_TYPE_AG: return (u8 __iomem *)AG_ISA_IO_B(addr);
 #endif
     default: return NULL; /* avoid warnings, just in case */
     }
@@ -142,13 +142,13 @@ static inline u16 __iomem *isa_itw(unsig
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_Q40
-    case Q40_ISA: return (u16 __iomem *)Q40_ISA_IO_W(addr);
+    case ISA_TYPE_Q40: return (u16 __iomem *)Q40_ISA_IO_W(addr);
 #endif
 #ifdef CONFIG_GG2
-    case GG2_ISA: return (u16 __iomem *)GG2_ISA_IO_W(addr);
+    case ISA_TYPE_GG2: return (u16 __iomem *)GG2_ISA_IO_W(addr);
 #endif
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: return (u16 __iomem *)AG_ISA_IO_W(addr);
+    case ISA_TYPE_AG: return (u16 __iomem *)AG_ISA_IO_W(addr);
 #endif
     default: return NULL; /* avoid warnings, just in case */
     }
@@ -158,7 +158,7 @@ static inline u32 __iomem *isa_itl(unsig
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: return (u32 __iomem *)AG_ISA_IO_W(addr);
+    case ISA_TYPE_AG: return (u32 __iomem *)AG_ISA_IO_W(addr);
 #endif
     default: return 0; /* avoid warnings, just in case */
     }
@@ -168,13 +168,13 @@ static inline u8 __iomem *isa_mtb(unsign
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_Q40
-    case Q40_ISA: return (u8 __iomem *)Q40_ISA_MEM_B(addr);
+    case ISA_TYPE_Q40: return (u8 __iomem *)Q40_ISA_MEM_B(addr);
 #endif
 #ifdef CONFIG_GG2
-    case GG2_ISA: return (u8 __iomem *)GG2_ISA_MEM_B(addr);
+    case ISA_TYPE_GG2: return (u8 __iomem *)GG2_ISA_MEM_B(addr);
 #endif
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: return (u8 __iomem *)addr;
+    case ISA_TYPE_AG: return (u8 __iomem *)addr;
 #endif
     default: return NULL; /* avoid warnings, just in case */
     }
@@ -184,13 +184,13 @@ static inline u16 __iomem *isa_mtw(unsig
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_Q40
-    case Q40_ISA: return (u16 __iomem *)Q40_ISA_MEM_W(addr);
+    case ISA_TYPE_Q40: return (u16 __iomem *)Q40_ISA_MEM_W(addr);
 #endif
 #ifdef CONFIG_GG2
-    case GG2_ISA: return (u16 __iomem *)GG2_ISA_MEM_W(addr);
+    case ISA_TYPE_GG2: return (u16 __iomem *)GG2_ISA_MEM_W(addr);
 #endif
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: return (u16 __iomem *)addr;
+    case ISA_TYPE_AG: return (u16 __iomem *)addr;
 #endif
     default: return NULL; /* avoid warnings, just in case */
     }
@@ -218,13 +218,13 @@ static inline void isa_delay(void)
   switch(ISA_TYPE)
     {
 #ifdef CONFIG_Q40
-    case Q40_ISA: isa_outb(0,0x80); break;
+    case ISA_TYPE_Q40: isa_outb(0,0x80); break;
 #endif
 #ifdef CONFIG_GG2
-    case GG2_ISA: break;
+    case ISA_TYPE_GG2: break;
 #endif
 #ifdef CONFIG_AMIGA_PCMCIA
-    case AG_ISA: break;
+    case ISA_TYPE_AG: break;
 #endif
     default: break; /* avoid warnings */
     }

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYJMUIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYJMUIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYJMUFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:47 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:43062 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYJMUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:40 -0400
Message-Id: <20081013195915.064949446@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:51 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/18] m68k: Reverse platform MMU logic so Sun 3 is last
Content-Disposition: inline; filename=m68k-reverse-platform-mmu-logic-so-sun3-is-last.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
incompatible with standard Motorola MMUs. However, this means that
`allmodconfig' enables support for Sun 3, and thus disables support for all
other platforms.

Reverse the logic and move Sun 3 last, so `allmodconfig' enables all
platforms except for Sun 3, increasing compile-coverage.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -105,21 +105,9 @@ config PCMCIA
 	  To compile this driver as modules, choose M here: the
 	  modules will be called pcmcia_core and ds.
 
-config SUN3
-	bool "Sun3 support"
-	select M68020
-	select MMU_SUN3 if MMU
-	help
-	  This option enables support for the Sun 3 series of workstations
-	  (3/50, 3/60, 3/1xx, 3/2xx systems). Enabling this option requires
-	  that all other hardware types must be disabled, as Sun 3 kernels
-	  are incompatible with all other m68k targets (including Sun 3x!).
-
-	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
-
 config AMIGA
 	bool "Amiga support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  This option enables support for the Amiga series of computers. If
 	  you plan to use this kernel on an Amiga, say Y here and browse the
@@ -127,7 +115,7 @@ config AMIGA
 
 config ATARI
 	bool "Atari support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  This option enables support for the 68000-based Atari series of
 	  computers (including the TT, Falcon and Medusa). If you plan to use
@@ -153,7 +141,7 @@ config PCI
 
 config MAC
 	bool "Macintosh support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  This option enables support for the Apple Macintosh series of
 	  computers (yes, there is experimental support now, at least for part
@@ -174,14 +162,14 @@ config M68K_L2_CACHE
 
 config APOLLO
 	bool "Apollo support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  Say Y here if you want to run Linux on an MC680x0-based Apollo
 	  Domain workstation such as the DN3500.
 
 config VME
 	bool "VME (Motorola and BVM) support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  Say Y here if you want to build a kernel for a 680x0 based VME
 	  board.  Boards currently supported include Motorola boards MVME147,
@@ -218,7 +206,7 @@ config BVME6000
 
 config HP300
 	bool "HP9000/300 and HP9000/400 support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  This option enables support for the HP9000/300 and HP9000/400 series
 	  of workstations. Support for these machines is still somewhat
@@ -237,7 +225,7 @@ config DIO
 
 config SUN3X
 	bool "Sun3x support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	select M68030
 	help
 	  This option enables support for the Sun 3x series of workstations.
@@ -250,7 +238,7 @@ config SUN3X
 
 config Q40
 	bool "Q40/Q60 support"
-	depends on !MMU_SUN3
+	select MMU_MOTOROLA if MMU
 	help
 	  The Q40 is a Motorola 68040-based successor to the Sinclair QL
 	  manufactured in Germany.  There is an official Q40 home page at
@@ -258,6 +246,19 @@ config Q40
 	  Q60. Select your CPU below.  For 68LC060 don't forget to enable FPU
 	  emulation.
 
+config SUN3
+	bool "Sun3 support"
+	depends on !MMU_MOTOROLA
+	select MMU_SUN3 if MMU
+	select M68020
+	help
+	  This option enables support for the Sun 3 series of workstations
+	  (3/50, 3/60, 3/1xx, 3/2xx systems). Enabling this option requires
+	  that all other hardware types must be disabled, as Sun 3 kernels
+	  are incompatible with all other m68k targets (including Sun 3x!).
+
+	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
+
 comment "Processor type"
 
 config M68020
@@ -295,10 +296,10 @@ config M68060
 config MMU_MOTOROLA
 	bool
 	depends on MMU && !MMU_SUN3
-	default y
 
 config MMU_SUN3
 	bool
+	depends on MMU && !MMU_MOTOROLA
 
 config M68KFPU_EMU
 	bool "Math emulation support (EXPERIMENTAL)"

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYA0MkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYA0MkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYA0Mfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:43 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:53344 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbYA0Mfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:35:40 -0500
Message-Id: <20080127123357.377006166@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:22 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 06/14] m68k: kill arch/m68k/mac/mac_ksyms.c
Content-Disposition: inline; filename=m68k-kill-arch-m68k-mac-mac_ksyms-c.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

m68k: kill arch/m68k/mac/mac_ksyms.c

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/Makefile    |    2 +-
 arch/m68k/mac/mac_ksyms.c |    8 --------
 arch/m68k/mac/via.c       |    5 ++++-
 3 files changed, 5 insertions(+), 10 deletions(-)

--- a/arch/m68k/mac/Makefile
+++ b/arch/m68k/mac/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y		:= config.o bootparse.o macints.o iop.o via.o oss.o psc.o \
-			baboon.o macboing.o debug.o misc.o mac_ksyms.o
+			baboon.o macboing.o debug.o misc.o
--- a/arch/m68k/mac/mac_ksyms.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-
-/* Says whether we're using A/UX interrupts or not */
-extern int via_alt_mapping;
-
-EXPORT_SYMBOL(via_alt_mapping);
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
@@ -41,7 +42,9 @@ volatile __u8 *via1, *via2;
 /* See note in mac_via.h about how this is possibly not useful */
 volatile long *via_memory_bogon=(long *)&via_memory_bogon;
 #endif
-int rbv_present, via_alt_mapping;
+int rbv_present;
+int via_alt_mapping;
+EXPORT_SYMBOL(via_alt_mapping);
 __u8 rbv_clear;
 
 /*

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


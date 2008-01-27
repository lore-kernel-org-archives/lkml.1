Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYA0Mfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYA0Mfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYA0Me7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:34:59 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:54752 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYA0Me5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:34:57 -0500
Message-Id: <20080127123355.557539057@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:17 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 01/14] m68k: Use cc-cross-prefix
Content-Disposition: inline; filename=m68k-cc-cross-prefix.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: Use cc-cross-prefix

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m68k/Makefile |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -13,16 +13,15 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
-ifneq ($(COMPILE_ARCH),$(ARCH))
-	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
+ifneq ($(SUBARCH),$(ARCH))
+	ifeq ($(CROSS_COMPILE),)
+		CROSS_COMPILE := $(call cc-cross-prefix, \
+			m68k-linux-gnu- m68k-linux- m68k-unknown-linux-gnu-)
+	endif
 endif
 
 ifdef CONFIG_SUN3

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


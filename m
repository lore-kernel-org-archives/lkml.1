Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXJUR5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXJUR5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXJUR5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:57:43 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:38127 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXJUR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:57:41 -0400
Date: Sun, 21 Oct 2007 19:57:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <20071019204415.GA623@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710211956280.6155@anakin>
References: <20071019204415.GA623@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Sam Ravnborg wrote:
> The cc-cross-prefix is new and developed on request from Geert Uytterhoeven.
> With cc-cross-prefix it is now much easier to have a few default
> cross compile prefixes and defaulting to none - if none of them were present.
> ARCH maintainers are expected to pick up this feature soon.

Thanks, seems to work fine!

m68k: Use cc-cross-prefix

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Makefile |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -13,16 +13,14 @@
 # Copyright (C) 1994 by Hamish Macdonald
 #
 
-# test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-
 # override top level makefile
 AS += -m68020
 LDFLAGS := -m m68kelf
 LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
 ifneq ($(COMPILE_ARCH),$(ARCH))
-	# prefix for cross-compiling binaries
-	CROSS_COMPILE = m68k-linux-gnu-
+	ifeq ($(CROSS_COMPILE),)
+	       CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
+	endif
 endif
 
 ifdef CONFIG_SUN3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

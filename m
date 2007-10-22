Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXJVShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXJVShT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJVShD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:37:03 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:50239 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXJVSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:36:59 -0400
X-Greylist: delayed 86848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 14:36:59 EDT
Date: Mon, 22 Oct 2007 20:36:49 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild
 updates - second round)
In-Reply-To: <jetzoj1phj.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0710221315400.30734@anakin>
References: <20071019204415.GA623@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710211956280.6155@anakin> <20071021182245.GA5840@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710212028560.6155@anakin> <jetzoj1phj.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-59085110-1193078191=:7105"
Content-ID: <Pine.LNX.4.64.0710222036380.7105@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-59085110-1193078191=:7105
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0710222036381.7105@anakin>

On Mon, 22 Oct 2007, Andreas Schwab wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> >> Did you mean to use $(SUBARCH) here?
>                          ^^^^^^^
> 
> > Oops, indeed. Sorry, here's a new one...

> > +ifneq ($(SUB_ARCH),$(ARCH))
>             ^^^^^^^^
> You did test it, didn't you?

Bummer, I only tested a cross-compile build, as I don't have access to a
native m68k machine at this moment. Third time, good time? I also added
m68k-unknown-linux-gnu- to please Kolbjørn Barmen and the other Gentoo
people.
---

m68k: Use cc-cross-prefix

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-59085110-1193078191=:7105--

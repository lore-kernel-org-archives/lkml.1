Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbYDXSgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbYDXSgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYDXSeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:34:25 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:54947 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYDXSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:34:16 -0400
Message-Id: <20080424183243.647120715@mail.of.borg>
References: <20080424182940.424312704@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 20:29:53 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 13/15] m68k: Q40/Q60 floppy support is broken
Content-Disposition: inline; filename=m68k-q40-floppy-is-broken.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Mark Q40/Q60 floppy support broken:

    arch/m68k/q40/q40ints.c: In function 'q40_irq_handler':
    arch/m68k/q40/q40ints.c:214: error: implicit declaration of function 'floppy_hardint'

Including <asm/floppy.h> doesn't help, as it causes a lot of additional error
messages (cfr. Sun 3x).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -44,7 +44,7 @@ config GENERIC_IOMAP
 
 config ARCH_MAY_HAVE_PC_FDC
 	bool
-	depends on Q40 || (BROKEN && SUN3X)
+	depends on BROKEN && (Q40 || SUN3X)
 	default y
 
 config NO_IOPORT

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


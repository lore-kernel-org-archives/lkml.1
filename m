Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbXJOTvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbXJOTvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbXJOTvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:51:16 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:36060 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbXJOTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:51:14 -0400
Date: Mon, 15 Oct 2007 21:51:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@atrey.karlin.mff.cz, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Atari keyboard: incorporate additional review comments
Message-ID: <Pine.LNX.4.64.0710152150260.22973@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Atari keyboard: incorporate additional review comments:
  o Kill reference to source file name
  o Return error value from input_register_device() instead of -ENOMEM

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
---
 arch/m68k/atari/atakeyb.c       |    2 --
 drivers/input/keyboard/atakbd.c |    7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/m68k/atari/atakeyb.c
- *
  * Atari Keyboard driver for 680x0 Linux
  *
  * This file is subject to the terms and conditions of the GNU General Public
--- a/drivers/input/keyboard/atakbd.c
+++ b/drivers/input/keyboard/atakbd.c
@@ -217,7 +217,7 @@ static void atakbd_interrupt(unsigned ch
 
 static int __init atakbd_init(void)
 {
-	int i;
+	int i, error;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(ST_MFP))
 		return -EIO;
@@ -247,9 +247,10 @@ static int __init atakbd_init(void)
 	}
 
 	/* error check */
-	if (input_register_device(atakbd_dev)) {
+	error = input_register_device(atakbd_dev);
+	if (error) {
 		input_free_device(atakbd_dev);
-		return -ENOMEM;
+		return error;
 	}
 
 	atari_input_keyboard_interrupt_hook = atakbd_interrupt;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

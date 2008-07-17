Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYGQTdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYGQTdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348AbYGQTXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:35 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:35518 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790AbYGQTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:47 -0400
Message-Id: <20080717191750.266475167@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:10 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 03/29] m68k: Return -ENODEV if no device is found
Content-Disposition: inline; filename=m68k-initcalls-should-return-ENODEV-if-device-not-found2.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

According to the tests in do_initcalls(), the proper error code in case no
device is found is -ENODEV, not -ENXIO or -EIO.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/ataflop.c         |    4 ++--
 drivers/char/nvram.c            |    2 +-
 drivers/input/keyboard/atakbd.c |    2 +-
 drivers/video/atafb.c           |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1880,11 +1880,11 @@ static int __init atari_floppy_init (voi
 
 	if (!MACH_IS_ATARI)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
-		return -ENXIO;
+		return -ENODEV;
 
 	if (MACH_IS_HADES)
 		/* Hades doesn't have Atari-compatible floppy */
-		return -ENXIO;
+		return -ENODEV;
 
 	if (register_blkdev(FLOPPY_MAJOR,"fd"))
 		return -EBUSY;
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -444,7 +444,7 @@ nvram_init(void)
 
 	/* First test whether the driver should init at all */
 	if (!CHECK_DRIVER_INIT())
-		return -ENXIO;
+		return -ENODEV;
 
 	ret = misc_register(&nvram_dev);
 	if (ret) {
--- a/drivers/input/keyboard/atakbd.c
+++ b/drivers/input/keyboard/atakbd.c
@@ -220,7 +220,7 @@ static int __init atakbd_init(void)
 	int i, error;
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(ST_MFP))
-		return -EIO;
+		return -ENODEV;
 
 	// need to init core driver if not already done so
 	if (atari_keyb_init())
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3110,7 +3110,7 @@ int __init atafb_init(void)
 	printk("atafb_init: start\n");
 
 	if (!MACH_IS_ATARI)
-		return -ENXIO;
+		return -ENODEV;
 
 	do {
 #ifdef ATAFB_EXT

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


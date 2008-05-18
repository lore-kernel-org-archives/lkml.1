Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbYERTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbYERTFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761490AbYERSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:54:28 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:58041 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbYERSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:54:01 -0400
Message-Id: <20080518185152.674241300@mail.of.borg>
References: <20080518184706.631023070@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 May 2008 20:47:18 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 12/18] m68k: Return -ENODEV if no device is found
Content-Disposition: inline; filename=m68k-initcalls-should-return-ENODEV-if-device-not-found.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

According to the tests in do_initcalls(), the proper error code in case no
device is found is -ENODEV, not -ENXIO or -EIO.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/amiflop.c      |    6 +++---
 drivers/block/z2ram.c        |    2 +-
 drivers/input/serio/q40kbd.c |    2 +-
 drivers/video/amifb.c        |    4 ++--
 drivers/video/hpfb.c         |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1714,10 +1714,10 @@ static int __init amiga_floppy_init(void
 	int i, ret;
 
 	if (!MACH_IS_AMIGA)
-		return -ENXIO;
+		return -ENODEV;
 
 	if (!AMIGAHW_PRESENT(AMI_FLOPPY))
-		return -ENXIO;
+		return -ENODEV;
 
 	if (register_blkdev(FLOPPY_MAJOR,"fd"))
 		return -EBUSY;
@@ -1755,7 +1755,7 @@ static int __init amiga_floppy_init(void
 	if (!floppy_queue)
 		goto out_queue;
 
-	ret = -ENXIO;
+	ret = -ENODEV;
 	if (fd_probe_drives() < 1) /* No usable drives */
 		goto out_probe;
 
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -332,7 +332,7 @@ z2_init(void)
     int ret;
 
     if (!MACH_IS_AMIGA)
-	return -ENXIO;
+	return -ENODEV;
 
     ret = -EBUSY;
     if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -156,7 +156,7 @@ static int __init q40kbd_init(void)
 	int error;
 
 	if (!MACH_IS_Q40)
-		return -EIO;
+		return -ENODEV;
 
 	error = platform_driver_register(&q40kbd_driver);
 	if (error)
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2261,7 +2261,7 @@ int __init amifb_init(void)
 	amifb_setup(option);
 #endif
 	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(AMI_VIDEO))
-		return -ENXIO;
+		return -ENODEV;
 
 	/*
 	 * We request all registers starting from bplpt[0]
@@ -2333,7 +2333,7 @@ default_chipset:
 			strcat(fb_info.fix.id, "Unknown");
 			goto default_chipset;
 #else /* CONFIG_FB_AMIGA_OCS */
-			err = -ENXIO;
+			err = -ENODEV;
 			goto amifb_error;
 #endif /* CONFIG_FB_AMIGA_OCS */
 			break;
--- a/drivers/video/hpfb.c
+++ b/drivers/video/hpfb.c
@@ -382,7 +382,7 @@ int __init hpfb_init(void)
 #define INTFBPADDR 0x560000
 
 	if (!MACH_IS_HP300)
-		return -ENXIO;
+		return -ENODEV;
 
 	if (fb_get_options("hpfb", NULL))
 		return -ENODEV;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbYGQTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbYGQTe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbYGQTXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:39 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:49775 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbYGQTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:46 -0400
Message-Id: <20080717191752.480279699@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:18 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 11/29] amifb: Register Amiga-specific video modes with sysfs
Content-Disposition: inline; filename=amifb-add-ami_modedb-to-modelist.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the Amiga-specific video modes with sysfs, so you can see them in
/sys/class/graphics/fb0/modes and change the video mode by writing to
/sys/class/graphics/fb0/mode.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2383,6 +2383,9 @@ default_chipset:
 		goto amifb_error;
 	}
 
+	fb_videomode_to_modelist(ami_modedb, NUM_TOTAL_MODES,
+				 &fb_info.modelist);
+
 	round_down_bpp = 0;
 	chipptr = chipalloc(fb_info.fix.smem_len+
 	                    SPRITEMEMSIZE+

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


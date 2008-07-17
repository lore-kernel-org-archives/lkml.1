Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbYGQTeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbYGQTeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbYGQTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:38 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:52638 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745AbYGQTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:46 -0400
Message-Id: <20080717191752.753964314@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:19 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 12/29] atafb: Register Atari-specific video modes with sysfs
Content-Disposition: inline; filename=atafb-add-atafb_modedb-to-modelist.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the Atari-specific video modes with sysfs, so you can see them in
/sys/class/graphics/fb0/modes and change the video mode by writing to
/sys/class/graphics/fb0/mode.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/atafb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3230,6 +3230,9 @@ int __init atafb_init(void)
 		return -EINVAL;
 	}
 
+	fb_videomode_to_modelist(atafb_modedb, NUM_TOTAL_MODES,
+				 &fb_info.modelist);
+
 	atafb_set_disp(&fb_info);
 
 	fb_alloc_cmap(&(fb_info.cmap), 1 << fb_info.var.bits_per_pixel, 0);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


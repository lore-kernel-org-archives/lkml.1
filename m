Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYHZJwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYHZJwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYHZJwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:52:05 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:8357 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYHZJwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:52:03 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 11/13 v3] viafb: viafbdev.c
Date: Tue, 26 Aug 2008 17:51:47 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB807A42C06@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 11/13 v3] viafb: viafbdev.c
Thread-Index: AckHYVsRzhWi5d4nRMajS13VrJkPDw==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>, <linux-fbdev-devel@lists.sourceforge.net>
Cc: <geert@linux-m68k.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Aug 2008 09:51:57.0319 (UTC) FILETIME=[60C00970:01C90761]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7Q9qudq002712

Remove the marco MMIO_OUT32, and replace it with writel() function.
And replace "u32" with "unsigned long" in writel() function (original 
MMIO_OUT32 marco) for avoiding warning message in 64bit OS.


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/video/via/viafbdev.c	2008-08-07 23:55:46.000000000 +0800
+++ b/drivers/video/via/viafbdev.c	2008-08-23 08:24:31.000000000 +0800
@@ -891,30 +891,32 @@
 	}
 
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* Source Base Address */
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) |
 		      (((pitch * info->
-		      var.bits_per_pixel >> 3) >> 3) << 16)));
+		      var.bits_per_pixel >> 3) >> 3) << 16)),
+		      viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((rect->dy << 16) | rect->dx));
+	writel(((rect->dy << 16) | rect->dx),
+		viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((rect->height - 1) << 16) | (rect->width - 1)));
+	writel((((rect->height - 1) << 16) | (rect->width - 1)),
+		viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* Forground color or Destination color */
-	MMIO_OUT32(VIA_REG_FGCOLOR, col);
+	writel(col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, (0x01 | 0x2000 | (rop << 24)));
+	writel((0x01 | 0x2000 | (rop << 24)),
+		viaparinfo->io_virt + VIA_REG_GECMD);
 
 }
 
@@ -946,33 +948,34 @@
 	}
 
 	/* Source Base Address */
-	/*MMIO_OUT32(VIA_REG_SRCBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_SRCBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
 	/* VIA_PITCH_ENABLE can be omitted now. */
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
 								info->var.
 								bits_per_pixel
 								>> 3) >> 3)
-							      << 16)));
+							      << 16)),
+				viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, ((sy << 16) | sx));
+	writel(((sy << 16) | sx), viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((dy << 16) | dx));
+	writel(((dy << 16) | dx), viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((area->height - 1) << 16) | (area->width - 1)));
+	writel((((area->height - 1) << 16) | (area->width - 1)),
+		   viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, (0x01 | direction | (0xCC << 24)));
+	writel((0x01 | direction | (0xCC << 24)),
+		viaparinfo->io_virt + VIA_REG_GECMD);
 
 }
 
@@ -1005,37 +1008,38 @@
 	size = image->width * image->height;
 
 	/* Source Base Address */
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	/*MMIO_OUT32(VIA_REG_DSTBASE, 0x0); */
-	MMIO_OUT32(VIA_REG_DSTBASE,
-		   ((u32) (info->screen_base) - (u32) viafb_FB_MM) >> 3);
+	writel(((unsigned long) (info->screen_base) -
+		   (unsigned long) viafb_FB_MM) >> 3,
+		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((pitch *
 		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
 								info->var.
 								bits_per_pixel
 								>> 3) >> 3)
-							      << 16)));
+							      << 16)),
+				viaparinfo->io_virt + VIA_REG_PITCH);
 	/* BitBlt Source Address */
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
 	/* BitBlt Destination Address */
-	MMIO_OUT32(VIA_REG_DSTPOS, ((image->dy << 16) | image->dx));
+	writel(((image->dy << 16) | image->dx),
+		viaparinfo->io_virt + VIA_REG_DSTPOS);
 	/* Dimension: width & height */
-	MMIO_OUT32(VIA_REG_DIMENSION,
-		   (((image->height - 1) << 16) | (image->width - 1)));
+	writel((((image->height - 1) << 16) | (image->width - 1)),
+		   viaparinfo->io_virt + VIA_REG_DIMENSION);
 	/* fb color */
-	MMIO_OUT32(VIA_REG_FGCOLOR, fg_col);
+	writel(fg_col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
 	/* bg color */
-	MMIO_OUT32(VIA_REG_BGCOLOR, bg_col);
+	writel(bg_col, viaparinfo->io_virt + VIA_REG_BGCOLOR);
 	/* GE Command */
-	MMIO_OUT32(VIA_REG_GECMD, 0xCC020142);
+	writel(0xCC020142, viaparinfo->io_virt + VIA_REG_GECMD);
 
 	for (i = 0; i < size / 4; i++) {
-		MMIO_OUT32(VIA_MMIO_BLTBASE, *udata);
+		writel(*udata, viaparinfo->io_virt + VIA_MMIO_BLTBASE);
 		udata++;
 	}
 
@@ -1075,7 +1079,7 @@
 	if (cursor->set & FB_CUR_SETHOT) {
 		viacursor.hot = cursor->hot;
 		temp = ((viacursor.hot.x) << 16) + viacursor.hot.y;
-		MMIO_OUT32(VIA_REG_CURSOR_ORG, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
 	}
 
 	if (cursor->set & FB_CUR_SETPOS) {
@@ -1085,11 +1089,11 @@
 		xx = cursor->image.dx - info->var.xoffset;
 		temp = yy & 0xFFFF;
 		temp |= (xx << 16);
-		MMIO_OUT32(VIA_REG_CURSOR_POS, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
 	}
 
 	if (cursor->set & FB_CUR_SETSIZE) {
-		temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+		temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 
 		if ((cursor->image.width <= 32)
 		    && (cursor->image.height <= 32)) {
@@ -1104,7 +1108,7 @@
 			"The cursor image is biger than 64x64 bits...\n");
 			return -ENXIO;
 		}
-		MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+		writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 
 		viacursor.image.height = cursor->image.height;
 		viacursor.image.width = cursor->image.width;
@@ -1164,8 +1168,8 @@
 			    0xFFC0) >> 6);
 		}
 
-		MMIO_OUT32(VIA_REG_CURSOR_BG, bg_col);
-		MMIO_OUT32(VIA_REG_CURSOR_FG, fg_col);
+		writel(bg_col, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
+		writel(fg_col, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
@@ -2112,15 +2116,15 @@
 
 	viaparinfo = (struct viafb_par *)viafbinfo->par;
 	viaparinfo->tmds_setting_info = (struct tmds_setting_information *)
-		((u32)viaparinfo + viafb_par_length);
+		((unsigned long)viaparinfo + viafb_par_length);
 	viaparinfo->lvds_setting_info = (struct lvds_setting_information *)
-		((u32)viaparinfo->tmds_setting_info + tmds_length);
+		((unsigned long)viaparinfo->tmds_setting_info + tmds_length);
 	viaparinfo->lvds_setting_info2 = (struct lvds_setting_information *)
-		((u32)viaparinfo->lvds_setting_info + lvds_length);
+		((unsigned long)viaparinfo->lvds_setting_info + lvds_length);
 	viaparinfo->crt_setting_info = (struct crt_setting_information *)
-		((u32)viaparinfo->lvds_setting_info2 + lvds_length);
+		((unsigned long)viaparinfo->lvds_setting_info2 + lvds_length);
 	viaparinfo->chip_info = (struct chip_information *)
-		((u32)viaparinfo->crt_setting_info + crt_length);
+		((unsigned long)viaparinfo->crt_setting_info + crt_length);
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

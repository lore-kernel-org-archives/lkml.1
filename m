Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYHZJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYHZJwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYHZJwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:52:03 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:8357 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYHZJwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:52:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Patch 3/13 v3] viafb: accel.c & accel.h
Date: Tue, 26 Aug 2008 17:51:46 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB807A42C05@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 3/13 v3] viafb: accel.c & accel.h
Thread-Index: AckHYVoF8uHEHYF4RbawC1OeVj1wbw==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>, <linux-fbdev-devel@lists.sourceforge.net>
Cc: <geert@linux-m68k.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Aug 2008 09:51:56.0991 (UTC) FILETIME=[608DFCF0:01C90761]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7Q9qNdq002691

Remove the marco MMIO_OUT32, and replace it with writel() function.


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/video/via/accel.c	2008-08-07 23:55:46.000000000 +0800
+++ b/drivers/video/via/accel.c	2008-08-23 08:24:29.000000000 +0800
@@ -39,44 +39,44 @@
 	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
 
 	/* init 2D engine regs to reset 2D engine */
-	MMIO_OUT32(VIA_REG_GEMODE, 0x0);
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
-	MMIO_OUT32(VIA_REG_DSTPOS, 0x0);
-	MMIO_OUT32(VIA_REG_DIMENSION, 0x0);
-	MMIO_OUT32(VIA_REG_PATADDR, 0x0);
-	MMIO_OUT32(VIA_REG_FGCOLOR, 0x0);
-	MMIO_OUT32(VIA_REG_BGCOLOR, 0x0);
-	MMIO_OUT32(VIA_REG_CLIPTL, 0x0);
-	MMIO_OUT32(VIA_REG_CLIPBR, 0x0);
-	MMIO_OUT32(VIA_REG_OFFSET, 0x0);
-	MMIO_OUT32(VIA_REG_KEYCONTROL, 0x0);
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
-	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
-	MMIO_OUT32(VIA_REG_PITCH, 0x0);
-	MMIO_OUT32(VIA_REG_MONOPAT1, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_GEMODE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTPOS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DIMENSION);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_PATADDR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_FGCOLOR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_BGCOLOR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPTL);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPBR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_OFFSET);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_KEYCONTROL);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_PITCH);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_MONOPAT1);
 
 	/* Init AGP and VQ regs */
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_K8M890:
 	case UNICHROME_P4M900:
-		MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-		MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x680A0000);
-		MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x02000000);
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+		writel(0x680A0000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+		writel(0x02000000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 		break;
 
 	default:
-		MMIO_OUT32(VIA_REG_TRANSET, 0x00100000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00333004);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x60000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x61000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x62000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x63000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x64000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x7D000000);
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x00333004, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x60000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x61000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x62000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x63000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x64000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x7D000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
 
-		MMIO_OUT32(VIA_REG_TRANSET, 0xFE020000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
+		writel(0xFE020000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
 		break;
 	}
 	if (viaparinfo->VQ_start != 0) {
@@ -105,37 +105,64 @@
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M900:
-			MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQStartEndH);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQStartL);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQEndL);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQLen);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x74301001);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x00000000);
+			writel(0x00100000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+			writel(dwVQStartEndH,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQStartL,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQEndL,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQLen,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(0x74301001,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(0x00000000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 			break;
 		default:
-			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x080003FE);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0A00027C);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0B000260);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0C000274);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0D000264);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0E000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0F000020);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x1000027E);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x110002FE);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x200F0060);
-
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000006);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
-
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartEndH);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartL);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQEndL);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQLen);
+			writel(0x00FE0000,
+				viaparinfo->io_virt + VIA_REG_TRANSET);
+			writel(0x080003FE,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0A00027C,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0B000260,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0C000274,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0D000264,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0E000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0F000020,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x1000027E,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x110002FE,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x200F0060,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+
+			writel(0x00000006,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x40008C0F,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x44000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x45080C04,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x46800408,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+
+			writel(dwVQStartEndH,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQStartL,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQEndL,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQLen,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
 			break;
 		}
 	} else {
@@ -143,38 +170,46 @@
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M900:
-			MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x74301000);
+			writel(0x00100000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+			writel(0x74301000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 			break;
 		default:
-			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000004);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
+			writel(0x00FE0000,
+				viaparinfo->io_virt + VIA_REG_TRANSET);
+			writel(0x00000004,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x40008C0F,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x44000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x45080C04,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x46800408,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
 			break;
 		}
 	}
 
 	viafb_set_2d_color_depth(viaparinfo->bpp);
 
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
-	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
 
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((viaparinfo->hres *
 		      viaparinfo->bpp >> 3) >> 3) | (((viaparinfo->hres *
 						   viaparinfo->
-						   bpp >> 3) >> 3) << 16)));
+						   bpp >> 3) >> 3) << 16)),
+					viaparinfo->io_virt + VIA_REG_PITCH);
 }
 
 void viafb_set_2d_color_depth(int bpp)
 {
 	u32 dwGEMode;
 
-	dwGEMode = MMIO_IN32(0x04) & 0xFFFFFCFF;
+	dwGEMode = readl(viaparinfo->io_virt + 0x04) & 0xFFFFFCFF;
 
 	switch (bpp) {
 	case 16:
@@ -189,17 +224,18 @@
 	}
 
 	/* Set BPP and Pitch */
-	MMIO_OUT32(VIA_REG_GEMODE, dwGEMode);
+	writel(dwGEMode, viaparinfo->io_virt + VIA_REG_GEMODE);
 }
 
 void viafb_hw_cursor_init(void)
 {
 	/* Set Cursor Image Base Address */
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, viaparinfo->cursor_start);
-	MMIO_OUT32(VIA_REG_CURSOR_POS, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_ORG, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_BG, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_FG, 0x0);
+	writel(viaparinfo->cursor_start,
+		viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
 }
 
 void viafb_show_hw_cursor(struct fb_info *info, int Status)
@@ -207,7 +243,7 @@
 	u32 temp;
 	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
 
-	temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+	temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 	switch (Status) {
 	case HW_Cursor_ON:
 		temp |= 0x1;
@@ -224,18 +260,18 @@
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+	writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 }
 
 int viafb_wait_engine_idle(void)
 {
 	int loop = 0;
 
-	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)
-	       && (loop++ < MAXLOOP))
+	while (!(readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+		VIA_VR_QUEUE_BUSY) && (loop++ < MAXLOOP))
 	       cpu_relax();
 
-	while ((MMIO_IN32(VIA_REG_STATUS) &
+	while ((readl(viaparinfo->io_virt + VIA_REG_STATUS) &
 		(VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
 	       (loop++ < MAXLOOP))
 	       cpu_relax();
--- a/drivers/video/via/accel.h	2008-08-07 23:55:46.000000000 +0800
+++ b/drivers/video/via/accel.h	2008-08-23 08:24:29.000000000 +0800
@@ -31,17 +31,6 @@
 #define MMIO_SR_READ                (MMIO_VGABASE + 0x3C4)
 #define MMIO_SR_WRITE               (MMIO_VGABASE + 0x3C5)
 
-#define VIA_MMIO 1
-
-#if VIA_MMIO
-#define MMIO_OUT32(reg, val) writel(val, viaparinfo->io_virt + reg)
-#define MMIO_IN32(reg)      readl(viaparinfo->io_virt + reg)
-
-#else
-#define MMIO_OUT32(reg, val) outl(val, reg)
-#define MMIO_IN32(reg)      inl(reg)
-#endif
-
 /* HW Cursor Status Define */
 #define HW_Cursor_ON    0
 #define HW_Cursor_OFF   1




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

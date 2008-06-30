Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYF3Hoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYF3Hoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYF3HoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:44:25 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:62803 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYF3HoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:44:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [PATCH 10/13] viafb: tbl1636.c, tbl1636.h, tblDPASetting.c, tblDPASetting.h
Date: Mon, 30 Jun 2008 15:44:21 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7890@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/13] viafb: tbl1636.c, tbl1636.h, tblDPASetting.c, tblDPASetting.h
Thread-Index: AcjahRv6Ap5XUA8RRaK4sMdyVGAZ9w==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 30 Jun 2008 07:44:22.0593 (UTC) FILETIME=[1CA1CB10:01C8DA85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5U7ibfq019571

tbl1636.c, tbl1636.h: patch setting for VT1636.
tblDPASetting.c, tblDPASetting.h: patch for graphic clock skew.


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/tbl1636.c b/drivers/video/via/tbl1636.c
--- a/drivers/video/via/tbl1636.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/tbl1636.c	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,71 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include "global.h"
+struct IODATA COMMON_INIT_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	/* Set panel power sequence timing */
+	{0x10, 0xC0, 0x00},
+	/* T1: VDD on - Data on. Each increment is 1 ms. (50ms = 031h) */
+	{0x0B, 0xFF, 0x40},
+	/* T2: Data on - Backlight on. Each increment is 2 ms. (210ms = 068h) */
+	{0x0C, 0xFF, 0x31},
+	/* T3: Backlight off -Data off. Each increment is 2 ms. (210ms = 068h)*/
+	{0x0D, 0xFF, 0x31},
+	/* T4: Data off - VDD off. Each increment is 1 ms. (50ms = 031h) */
+	{0x0E, 0xFF, 0x68},
+	/* T5: VDD off - VDD on. Each increment is 100 ms. (500ms = 04h) */
+	{0x0F, 0xFF, 0x68},
+	/* LVDS output power up */
+	{0x09, 0xA0, 0xA0},
+	/* turn on back light */
+	{0x10, 0x33, 0x13}
+};
+
+struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x08, 0xF0, 0xE0}	/* Input Data Mode Select */
+};
+
+struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x08, 0xF0, 0x00}	/* Input Data Mode Select */
+};
+
+struct IODATA DITHERING_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x0A, 0x70, 0x50}
+};
+
+struct IODATA DITHERING_DISABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x0A, 0x70, 0x00}
+};
+
+struct IODATA VDD_ON_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x10, 0x20, 0x20}
+};
+
+struct IODATA VDD_OFF_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x10, 0x20, 0x00}
+};
diff -Nur a/drivers/video/via/tbl1636.h b/drivers/video/via/tbl1636.h
--- a/drivers/video/via/tbl1636.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/tbl1636.h	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,34 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _TBL1636_H_
+#define _TBL1636_H_
+#include "hw.h"
+
+extern struct IODATA COMMON_INIT_TBL_VT1636[8];
+extern struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[1];
+extern struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[1];
+extern struct IODATA DITHERING_ENABLE_TBL_VT1636[1];
+extern struct IODATA DITHERING_DISABLE_TBL_VT1636[1];
+extern struct IODATA VDD_ON_TBL_VT1636[1];
+extern struct IODATA VDD_OFF_TBL_VT1636[1];
+
+#endif /* _VIA_TBL1636_H_ */
diff -Nur a/drivers/video/via/tblDPASetting.c b/drivers/video/via/tblDPASetting.c
--- a/drivers/video/via/tblDPASetting.c	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/tblDPASetting.c	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,109 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include "global.h"
+/* For VT3324: */
+struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[] = {
+	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
+	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
+	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
+	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
+	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
+	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
+	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
+	{LCD_PANEL_ID6_1600X1200, 0x0B, 0x03}	/* For 1600x1200 */
+};
+
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[] = {
+/*  ClkRange, DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh, DFPLow */
+/*  CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,    CR99   */
+	/* LCK/VCK < 30000000 will use this value */
+	{DPA_CLK_RANGE_30M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
+	 0x00},
+	/* 30000000 < LCK/VCK < 50000000 will use this value */
+	{DPA_CLK_RANGE_30_50M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
+	 0x00},
+	/* 50000000 < LCK/VCK < 70000000 will use this value */
+	{DPA_CLK_RANGE_50_70M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 70000000 < LCK/VCK < 100000000 will use this value */
+	{DPA_CLK_RANGE_70_100M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 100000000 < LCK/VCK < 15000000 will use this value */
+	{DPA_CLK_RANGE_100_150M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 15000000 < LCK/VCK will use this value */
+	{DPA_CLK_RANGE_150M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x0E, 0x00,
+	 0x00},
+};
+
+/* For VT3327: */
+struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[] = {
+	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
+	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
+	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
+	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
+	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
+	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
+	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
+	{LCD_PANEL_ID6_1600X1200, 0x00, 0x00}	/* For 1600x1200 */
+};
+
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[] = {
+/*  ClkRange,DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh,   DFPLow */
+/*   CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,      CR99   */
+/* LCK/VCK < 30000000 will use this value */
+{DPA_CLK_RANGE_30M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 30000000 < LCK/VCK < 50000000 will use this value */
+{DPA_CLK_RANGE_30_50M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 50000000 < LCK/VCK < 70000000 will use this value */
+{DPA_CLK_RANGE_50_70M, 0x06, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 70000000 < LCK/VCK < 100000000 will use this value */
+{DPA_CLK_RANGE_70_100M, 0x03, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x03},
+/* 100000000 < LCK/VCK < 15000000 will use this value */
+{DPA_CLK_RANGE_100_150M, 0x03, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x01, 0x02},
+/* 15000000 < LCK/VCK will use this value */
+{DPA_CLK_RANGE_150M, 0x00, 0x20, 0x00, 0x10, 0x00, 0x03, 0x00, 0x0D, 0x03},
+};
+
+/* For VT3364: */
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3364[] = {
+/*  ClkRange,DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh,   DFPLow */
+/*   CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,      CR99   */
+/* LCK/VCK < 30000000 will use this value */
+{DPA_CLK_RANGE_30M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 30000000 < LCK/VCK < 50000000 will use this value */
+{DPA_CLK_RANGE_30_50M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 50000000 < LCK/VCK < 70000000 will use this value */
+{DPA_CLK_RANGE_50_70M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 70000000 < LCK/VCK < 100000000 will use this value */
+{DPA_CLK_RANGE_70_100M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 100000000 < LCK/VCK < 15000000 will use this value */
+{DPA_CLK_RANGE_100_150M, 0x03, 0x00, 0x02, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 15000000 < LCK/VCK will use this value */
+{DPA_CLK_RANGE_150M, 0x01, 0x00, 0x02, 0x10, 0x00, 0x03, 0x00, 0x00, 0x08},
+};
diff -Nur a/drivers/video/via/tblDPASetting.h b/drivers/video/via/tblDPASetting.h
--- a/drivers/video/via/tblDPASetting.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/video/via/tblDPASetting.h	2008-06-30 08:53:33.000000000 +0800
@@ -0,0 +1,47 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _TBLDPASETTING_H_
+#define _TBLDPASETTING_H_
+#include "global.h"
+
+#define DPA_CLK_30M       30000000
+#define DPA_CLK_50M       50000000
+#define DPA_CLK_70M       70000000
+#define DPA_CLK_100M      100000000
+#define DPA_CLK_150M      150000000
+
+enum DPA_RANGE {
+	DPA_CLK_RANGE_30M,
+	DPA_CLK_RANGE_30_50M,
+	DPA_CLK_RANGE_50_70M,
+	DPA_CLK_RANGE_70_100M,
+	DPA_CLK_RANGE_100_150M,
+	DPA_CLK_RANGE_150M
+};
+
+extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[7];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[6];
+extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[7];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3364[6];
+
+#endif
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbYEGLMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbYEGLMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760097AbYEGLJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:09:50 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:1331 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199AbYEGLJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:09:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 19:09:42 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67759@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 6/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AcivqWbF3qyu30s5RguMHG+BNihXBgAhNGrAAAA1T2AAABOmsAAAH3FwAAAG77AAAAoFIA==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 11:09:43.0522 (UTC) FILETIME=[DA2BDC20:01C8B032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m47BClEB002151

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/tbl1636.c b/drivers/video/via/tbl1636.c
--- a/drivers/video/via/tbl1636.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/tbl1636.c	2008-04-29 02:51:23.000000000 -0400
@@ -0,0 +1,71 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
--- a/drivers/video/via/tbl1636.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/tbl1636.h	2008-04-29 02:51:24.000000000 -0400
@@ -0,0 +1,34 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
--- a/drivers/video/via/tblDPASetting.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/tblDPASetting.c	2008-04-29 02:51:25.000000000 -0400
@@ -0,0 +1,109 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
--- a/drivers/video/via/tblDPASetting.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/tblDPASetting.h	2008-04-29 02:51:25.000000000 -0400
@@ -0,0 +1,47 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
diff -Nur a/drivers/video/via/viafb.modes b/drivers/video/via/viafb.modes
--- a/drivers/video/via/viafb.modes	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/viafb.modes	2008-04-29 02:51:27.000000000 -0400
@@ -0,0 +1,870 @@
+#
+#
+#   These data are based on the CRTC parameters in
+#
+#       VIA Integration Graphics Chip
+#       (C) 2004 VIA Technologies Inc.
+#
+
+#
+#   640x480, 60 Hz, Non-Interlaced (25.175 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      640     480
+#   Scan Frequency      31.469 kHz  59.94 Hz
+#   Sync Width      3.813 us    0.064 ms
+#               12 chars    2 lines
+#   Front Porch     0.636 us    0.318  ms
+#               2 chars     10 lines
+#   Back Porch      1.907 us    1.048  ms
+#               6 chars     33 lines
+#   Active Time     25.422 us   15.253 ms
+#               80 chars    480 lines
+#   Blank Time      6.356 us    1.430 ms
+#               20 chars    45 lines
+#   Polarity        negative    negative
+#
+
+mode "640x480-60"
+# D: 25.175 MHz, H: 31.469 kHz, V: 59.94 Hz
+    geometry 640 480 640 480 32
+    timings 39722 48 16 33 10 96 2 endmode mode "480x640-60"
+# D: 24.823 MHz, H: 39.780 kHz, V: 60.00 Hz
+    geometry 480 640 480 640 32 timings 39722 72 24 19 1 48 3 endmode
+#
+#   640x480, 75 Hz, Non-Interlaced (31.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      640     480
+#   Scan Frequency      37.500 kHz  75.00 Hz
+#   Sync Width      2.032 us    0.080 ms
+#               8 chars     3 lines
+#   Front Porch     0.508 us    0.027 ms
+#               2 chars     1 lines
+#   Back Porch      3.810 us    0.427 ms
+#               15 chars    16 lines
+#   Active Time     20.317 us   12.800 ms
+#               80 chars    480 lines
+#   Blank Time      6.349 us    0.533 ms
+#               25 chars    20 lines
+#   Polarity        negative    negative
+#
+    mode "640x480-75"
+# D: 31.50 MHz, H: 37.500 kHz, V: 75.00 Hz
+    geometry 640 480 640 480 32 timings 31747 120 16 16 1 64 3 endmode
+#
+#   640x480, 85 Hz, Non-Interlaced (36.000 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      640     480
+#   Scan Frequency  43.269 kHz  85.00 Hz
+#   Sync Width      1.556 us    0.069 ms
+#               7 chars     3 lines
+#   Front Porch     1.556 us    0.023 ms
+#               7 chars     1 lines
+#   Back Porch      2.222 us    0.578 ms
+#               10 chars    25 lines
+#   Active Time     17.778 us   11.093 ms
+#               80 chars    480 lines
+#   Blank Time      5.333 us    0.670 ms
+#               24 chars    29 lines
+#   Polarity        negative    negative
+#
+    mode "640x480-85"
+# D: 36.000 MHz, H: 43.269 kHz, V: 85.00 Hz
+    geometry 640 480 640 480 32 timings 27777 80 56 25 1 56 3 endmode
+#
+#   640x480, 100 Hz, Non-Interlaced (43.163 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      640     480
+#   Scan Frequency      50.900 kHz  100.00 Hz
+#   Sync Width      1.483 us    0.058 ms
+#               8 chars     3 lines
+#   Front Porch     0.927 us    0.019 ms
+#               5 chars     1 lines
+#   Back Porch      2.409 us    0.475 ms
+#               13 chars    25 lines
+#   Active Time     14.827 us   9.430 ms
+#               80 chars    480 lines
+#   Blank Time      4.819 us    0.570 ms
+#               26 chars    29 lines
+#   Polarity        positive    positive
+#
+    mode "640x480-100"
+# D: 43.163 MHz, H: 50.900 kHz, V: 100.00 Hz
+    geometry 640 480 640 480 32 timings 23168 104 40 25 1 64 3 endmode
+#
+#   640x480, 120 Hz, Non-Interlaced (52.406 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      640     480
+#   Scan Frequency      61.800 kHz  120.00 Hz
+#   Sync Width      1.221 us    0.048 ms
+#               8 chars         3 lines
+#   Front Porch     0.763 us    0.016 ms
+#               5 chars     1 lines
+#   Back Porch      1.984 us    0.496 ms
+#               13 chars    31 lines
+#   Active Time     12.212 us   7.767 ms
+#               80 chars    480 lines
+#   Blank Time      3.969 us    0.566 ms
+#               26 chars    35 lines
+#   Polarity        positive    positive
+#
+    mode "640x480-120"
+# D: 52.406 MHz, H: 61.800 kHz, V: 120.00 Hz
+    geometry 640 480 640 480 32 timings 19081 104 40 31 1 64 3 endmode
+#
+#   720x480, 60 Hz, Non-Interlaced (26.880 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      720     480
+#   Scan Frequency      30.000 kHz  60.241 Hz
+#   Sync Width      2.679 us    0.099 ms
+#               9 chars     3 lines
+#   Front Porch     0.595 us    0.033 ms
+#               2 chars     1 lines
+#   Back Porch      3.274 us    0.462 ms
+#               11 chars    14 lines
+#   Active Time     26.786 us   16.000 ms
+#               90 chars    480 lines
+#   Blank Time      6.548 us    0.600 ms
+#               22 chars    18 lines
+#   Polarity        positive    positive
+#
+    mode "720x480-60"
+# D: 26.880 MHz, H: 30.000 kHz, V: 60.24 Hz
+    geometry 720 480 720 480 32 timings 37202 88 16 14 1 72 3 endmode
+#
+#   800x480, 60 Hz, Non-Interlaced (29.581 MHz dotclock)
+#
+#               Horizontal    Vertical
+#   Resolution      800         480
+#   Scan Frequency  29.892 kHz  60.00 Hz
+#   Sync Width      2.704 us    100.604 us
+#                   10 chars    3 lines
+#   Front Porch     0.541 us    33.535 us
+#                   2 chars     1 lines
+#   Back Porch      3.245 us    435.949 us
+#                   12 chars    13 lines
+#   Active Time     27.044 us   16.097 ms
+#                   100 chars   480 lines
+#   Blank Time      6.491 us    0.570 ms
+#                   24 chars    17 lines
+#   Polarity        positive    positive
+#
+    mode "800x480-60"
+# D: 29.500 MHz, H: 29.738 kHz, V: 60.00 Hz
+    geometry 800 480 800 480 32 timings 33805 96 24 10 3 72 7 endmode
+#
+#   720x576, 60 Hz, Non-Interlaced (32.668 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      720     576
+#   Scan Frequency      35.820 kHz  60.00 Hz
+#   Sync Width      2.204 us    0.083 ms
+#               9 chars     3 lines
+#   Front Porch     0.735 us    0.027 ms
+#               3 chars     1 lines
+#   Back Porch      2.939 us    0.459 ms
+#               12 chars    17 lines
+#   Active Time     22.040 us   16.080 ms
+#               90 chars    476 lines
+#   Blank Time      5.877 us    0.586 ms
+#               24 chars    21 lines
+#   Polarity        positive    positive
+#
+    mode "720x576-60"
+# D: 32.668 MHz, H: 35.820 kHz, V: 60.00 Hz
+    geometry 720 576 720 576 32 timings 30611 96 24 17 1 72 3 endmode
+#
+#   800x600, 60 Hz, Non-Interlaced (40.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      800     600
+#   Scan Frequency      37.879 kHz  60.32 Hz
+#   Sync Width      3.200 us    0.106 ms
+#               16 chars    4 lines
+#   Front Porch     1.000 us    0.026 ms
+#               5 chars     1 lines
+#   Back Porch      2.200 us    0.607 ms
+#               11 chars    23 lines
+#   Active Time     20.000 us   15.840 ms
+#               100 chars   600 lines
+#   Blank Time      6.400 us    0.739 ms
+#               32 chars    28 lines
+#   Polarity        positive    positive
+#
+    mode "800x600-60"
+# D: 40.00 MHz, H: 37.879 kHz, V: 60.32 Hz
+    geometry 800 600 800 600 32
+    timings 25000 88 40 23 1 128 4 hsync high vsync high endmode
+#
+#   800x600, 75 Hz, Non-Interlaced (49.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      800     600
+#   Scan Frequency      46.875 kHz  75.00 Hz
+#   Sync Width      1.616 us    0.064 ms
+#               10 chars    3 lines
+#   Front Porch     0.323 us    0.021 ms
+#               2 chars     1 lines
+#   Back Porch      3.232 us    0.448 ms
+#               20 chars    21 lines
+#   Active Time     16.162 us   12.800 ms
+#               100 chars   600 lines
+#   Blank Time      5.172 us    0.533 ms
+#               32 chars    25 lines
+#   Polarity        positive    positive
+#
+    mode "800x600-75"
+# D: 49.50 MHz, H: 46.875 kHz, V: 75.00 Hz
+    geometry 800 600 800 600 32
+    timings 20203 160 16 21 1 80 3 hsync high vsync high endmode
+#
+#   800x600, 85 Hz, Non-Interlaced (56.25 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      800     600
+#   Scan Frequency      53.674 kHz  85.061 Hz
+#   Sync Width      1.138 us    0.056 ms
+#               8 chars     3 lines
+#   Front Porch     0.569 us    0.019 ms
+#               4 chars     1 lines
+#   Back Porch      2.702 us    0.503 ms
+#               19 chars    27 lines
+#   Active Time     14.222 us   11.179 ms
+#               100 chars   600 lines
+#   Blank Time      4.409 us    0.578 ms
+#               31 chars    31 lines
+#   Polarity        positive    positive
+#
+    mode "800x600-85"
+# D: 56.25 MHz, H: 53.674 kHz, V: 85.061 Hz
+    geometry 800 600 800 600 32
+    timings 17777 152 32 27 1 64 3 hsync high vsync high endmode
+#
+#   800x600, 100 Hz, Non-Interlaced (67.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      800     600
+#   Scan Frequency      62.500 kHz  100.00 Hz
+#   Sync Width      0.948 us    0.064 ms
+#               8 chars     4 lines
+#   Front Porch     0.000 us    0.112 ms
+#               0 chars     7 lines
+#   Back Porch      3.200 us    0.224 ms
+#               27 chars    14 lines
+#   Active Time     11.852 us   9.600 ms
+#               100 chars   600 lines
+#   Blank Time      4.148 us    0.400 ms
+#               35 chars    25 lines
+#   Polarity        positive    positive
+#
+    mode "800x600-100"
+# D: 67.50 MHz, H: 62.500 kHz, V: 100.00 Hz
+    geometry 800 600 800 600 32
+    timings 14667 216 0 14 7 64 4 hsync high vsync high endmode
+#
+#   800x600, 120 Hz, Non-Interlaced (83.950 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      800     600
+#   Scan Frequency  77.160 kHz  120.00 Hz
+#   Sync Width      1.048 us    0.039 ms
+#               11 chars    3 lines
+#   Front Porch     0.667 us    0.013 ms
+#               7 chars     1 lines
+#   Back Porch      1.715 us    0.507 ms
+#               18 chars    39 lines
+#   Active Time     9.529 us    7.776 ms
+#               100 chars   600 lines
+#   Blank Time      3.431 us    0.557 ms
+#               36 chars    43 lines
+#   Polarity        positive    positive
+#
+    mode "800x600-120"
+# D: 83.950 MHz, H: 77.160 kHz, V: 120.00 Hz
+    geometry 800 600 800 600 32
+    timings 11912 144 56 39 1 88 3 hsync high vsync high endmode
+#
+#   848x480, 60 Hz, Non-Interlaced (31.490 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      848     480
+#   Scan Frequency  29.820 kHz  60.00 Hz
+#   Sync Width      2.795 us    0.099 ms
+#               11 chars    3 lines
+#   Front Porch     0.508 us    0.033 ms
+#               2 chars     1 lines
+#   Back Porch      3.303 us    0.429 ms
+#               13 chars    13 lines
+#   Active Time     26.929 us   16.097 ms
+#               106 chars   480 lines
+#   Blank Time      6.605 us    0.570 ms
+#               26 chars    17 lines
+#   Polarity        positive    positive
+#
+    mode "848x480-60"
+# D: 31.500 MHz, H: 29.830 kHz, V: 60.00 Hz
+    geometry 848 480 848 480 32
+    timings 31746 104 24 12 3 80 5 hsync high vsync high endmode
+#
+#   856x480, 60 Hz, Non-Interlaced (31.728 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      856     480
+#   Scan Frequency  29.820 kHz  60.00 Hz
+#   Sync Width      2.774 us    0.099 ms
+#               11 chars    3 lines
+#   Front Porch     0.504 us    0.033 ms
+#               2 chars     1 lines
+#   Back Porch      3.728 us    0.429 ms
+#               13 chars    13 lines
+#   Active Time     26.979 us   16.097 ms
+#               107 chars   480 lines
+#   Blank Time      6.556 us    0.570 ms
+#               26 chars    17 lines
+#   Polarity        positive    positive
+#
+    mode "856x480-60"
+# D: 31.728 MHz, H: 29.820 kHz, V: 60.00 Hz
+    geometry 856 480 856 480 32
+    timings 31518 104 16 13 1 88 3
+    hsync high vsync high endmode mode "960x600-60"
+# D: 45.250 MHz, H: 37.212 kHz, V: 60.00 Hz
+    geometry 960 600 960 600 32 timings 22099 128 32 15 3 96 6 endmode
+#
+#   1000x600, 60 Hz, Non-Interlaced (48.068 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1000     600
+#   Scan Frequency  37.320 kHz  60.00 Hz
+#   Sync Width      2.164 us    0.080 ms
+#               13 chars    3 lines
+#   Front Porch     0.832 us    0.027 ms
+#               5 chars     1 lines
+#   Back Porch      2.996 us    0.483 ms
+#               18 chars    18 lines
+#   Active Time     20.804 us   16.077 ms
+#               125 chars   600 lines
+#   Blank Time      5.991 us    0.589 ms
+#               36 chars    22 lines
+#   Polarity        negative    positive
+#
+    mode "1000x600-60"
+# D: 48.068 MHz, H: 37.320 kHz, V: 60.00 Hz
+    geometry 1000 600 1000 600 32
+    timings 20834 144 40 18 1 104 3 endmode mode "1024x576-60"
+# D: 46.996 MHz, H: 35.820 kHz, V: 60.00 Hz
+    geometry 1024 576 1024 576 32
+    timings 21278 144 40 17 1 104 3 endmode mode "1024x600-60"
+# D: 48.964 MHz, H: 37.320 kHz, V: 60.00 Hz
+    geometry 1024 600 1024 600 32
+    timings 20461 144 40 18 1 104 3 endmode mode "1088x612-60"
+# D: 52.952 MHz, H: 38.040 kHz, V: 60.00 Hz
+    geometry 1088 612 1088 612 32 timings 18877 152 48 16 3 104 5 endmode
+#
+#   1024x512, 60 Hz, Non-Interlaced (41.291 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1024    512
+#   Scan Frequency  31.860 kHz  60.00 Hz
+#   Sync Width      2.519 us    0.094 ms
+#               13 chars    3 lines
+#   Front Porch     0.775 us    0.031 ms
+#               4 chars     1 lines
+#   Back Porch      3.294 us    0.465 ms
+#               17 chars    15 lines
+#   Active Time     24.800 us   16.070 ms
+#               128 chars   512 lines
+#   Blank Time      6.587 us    0.596 ms
+#               34 chars    19 lines
+#   Polarity        positive    positive
+#
+    mode "1024x512-60"
+# D: 41.291 MHz, H: 31.860 kHz, V: 60.00 Hz
+    geometry 1024 512 1024 512 32
+    timings 24218 126 32 15 1 104 3 hsync high vsync high endmode
+#
+#   1024x600, 60 Hz, Non-Interlaced (48.875 MHz dotclock)
+#
+#                     Horizontal  Vertical
+#   Resolution          1024        768
+#   Scan Frequency      37.252 kHz  60.00 Hz
+#   Sync Width          2.128 us    80.532us
+#                       13 chars    3 lines
+#   Front Porch        0.818 us     26.844 us
+#                       5 chars     1 lines
+#   Back Porch          2.946 us    483.192 us
+#                       18 chars    18 lines
+#   Active Time         20.951 us   16.697 ms
+#                       128 chars   622 lines
+#   Blank Time          5.893 us    0.591 ms
+#                       36 chars    22 lines
+#   Polarity            negative    positive
+#
+#mode "1024x600-60"
+#     # D: 48.875 MHz, H: 37.252 kHz, V: 60.00 Hz
+#     geometry 1024 600 1024 600 32
+#    timings 20460  144 40 18 1 104  3
+# endmode
+#
+#   1024x768, 60 Hz, Non-Interlaced (65.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1024        768
+#   Scan Frequency      48.363 kHz  60.00 Hz
+#   Sync Width      2.092 us    0.124 ms
+#               17 chars    6 lines
+#   Front Porch     0.369 us    0.062 ms
+#               3 chars     3 lines
+#   Back Porch      2.462 us    0.601 ms
+#               20 chars    29 lines
+#   Active Time     15.754 us   15.880 ms
+#               128 chars   768 lines
+#   Blank Time      4.923 us    0.786 ms
+#               40 chars    38 lines
+#   Polarity        negative    negative
+#
+    mode "1024x768-60"
+# D: 65.00 MHz, H: 48.363 kHz, V: 60.00 Hz
+    geometry 1024 768 1024 768 32 timings 15385 160 24 29 3 136 6 endmode
+#
+#   1024x768, 75 Hz, Non-Interlaced (78.75 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1024        768
+#   Scan Frequency      60.023 kHz  75.03 Hz
+#   Sync Width      1.219 us    0.050 ms
+#               12 chars    3 lines
+#   Front Porch     0.203 us    0.017 ms
+#               2 chars     1 lines
+#   Back Porch      2.235 us    0.466 ms
+#               22 chars    28 lines
+#   Active Time     13.003 us   12.795 ms
+#               128 chars   768 lines
+#   Blank Time      3.657 us    0.533 ms
+#               36 chars    32 lines
+#   Polarity        positive    positive
+#
+    mode "1024x768-75"
+# D: 78.75 MHz, H: 60.023 kHz, V: 75.03 Hz
+    geometry 1024 768 1024 768 32
+    timings 12699 176 16 28 1 96 3 hsync high vsync high endmode
+#
+#   1024x768, 85 Hz, Non-Interlaced (94.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1024        768
+#   Scan Frequency  68.677 kHz  85.00 Hz
+#   Sync Width      1.016 us    0.044 ms
+#               12 chars    3 lines
+#   Front Porch     0.508 us    0.015 ms
+#               6 chars     1 lines
+#   Back Porch      2.201 us    0.524 ms
+#               26 chars    36 lines
+#   Active Time     10.836 us   11.183 ms
+#               128 chars   768 lines
+#   Blank Time      3.725 us    0.582 ms
+#               44 chars    40 lines
+#   Polarity        positive    positive
+#
+    mode "1024x768-85"
+# D: 94.50 MHz, H: 68.677 kHz, V: 85.00 Hz
+    geometry 1024 768 1024 768 32
+    timings 10582 208 48 36 1 96 3 hsync high vsync high endmode
+#
+#   1024x768, 100 Hz, Non-Interlaced (110.0 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1024        768
+#   Scan Frequency      79.023 kHz  99.78 Hz
+#   Sync Width      0.800 us    0.101 ms
+#               11 chars    8 lines
+#   Front Porch     0.000 us    0.000 ms
+#               0 chars     0 lines
+#   Back Porch      2.545 us    0.202 ms
+#               35 chars    16 lines
+#   Active Time     9.309 us    9.719 ms
+#               128 chars   768 lines
+#   Blank Time      3.345 us    0.304 ms
+#               46 chars    24 lines
+#   Polarity        negative    negative
+#
+    mode "1024x768-100"
+# D: 113.3 MHz, H: 79.023 kHz, V: 99.78 Hz
+    geometry 1024 768 1024 768 32
+    timings 8825 280 0 16 0 88 8 endmode mode "1152x720-60"
+# D: 66.750 MHz, H: 44.859 kHz, V: 60.00 Hz
+    geometry 1152 720 1152 720 32 timings 14981 168 56 19 3 112 6 endmode
+#
+#   1152x864, 75 Hz, Non-Interlaced (110.0 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1152        864
+#   Scan Frequency      75.137 kHz  74.99 Hz
+#   Sync Width      1.309 us    0.106 ms
+#               18 chars    8 lines
+#   Front Porch     0.245 us    0.599 ms
+#               3 chars     45 lines
+#   Back Porch      1.282 us    1.132 ms
+#               18 chars    85 lines
+#   Active Time     10.473 us   11.499 ms
+#               144 chars   864 lines
+#   Blank Time      2.836 us    1.837 ms
+#               39 chars    138 lines
+#   Polarity        positive    positive
+#
+    mode "1152x864-75"
+# D: 110.0 MHz, H: 75.137 kHz, V: 74.99 Hz
+    geometry 1152 864 1152 864 32
+    timings 9259 144 24 85 45 144 8
+    hsync high vsync high endmode mode "1200x720-60"
+# D: 70.184 MHz, H: 44.760 kHz, V: 60.00 Hz
+    geometry 1200 720 1200 720 32
+    timings 14253 184 28 22 1 128 3 endmode mode "1280x600-60"
+# D: 61.503 MHz, H: 37.320 kHz, V: 60.00 Hz
+    geometry 1280 600 1280 600 32
+    timings 16260 184 28 18 1 128 3 endmode mode "1280x720-50"
+# D: 60.466 MHz, H: 37.050 kHz, V: 50.00 Hz
+    geometry 1280 720 1280 720 32
+    timings 16538 176 48 17 1 128 3 endmode mode "1280x768-50"
+# D: 65.178 MHz, H: 39.550 kHz, V: 50.00 Hz
+    geometry 1280 768 1280 768 32 timings 15342 184 28 19 1 128 3 endmode
+#
+#   1280x768, 60 Hz, Non-Interlaced (80.136 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280    768
+#   Scan Frequency  47.700 kHz  60.00 Hz
+#   Sync Width      1.697 us    0.063 ms
+#               17 chars    3 lines
+#   Front Porch     0.799 us    0.021 ms
+#               8 chars     1 lines
+#   Back Porch      2.496 us    0.483 ms
+#               25 chars    23 lines
+#   Active Time     15.973 us   16.101 ms
+#               160 chars   768 lines
+#   Blank Time      4.992 us    0.566 ms
+#               50 chars    27 lines
+#   Polarity        positive    positive
+#
+    mode "1280x768-60"
+# D: 80.13 MHz, H: 47.700 kHz, V: 60.00 Hz
+    geometry 1280 768 1280 768 32
+    timings 12480 200 48 23 1 126 3 hsync high vsync high endmode
+#
+#   1280x800, 60 Hz, Non-Interlaced (83.375 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280    800
+#   Scan Frequency  49.628 kHz  60.00 Hz
+#   Sync Width      1.631 us    60.450 us
+#                   17 chars    3 lines
+#   Front Porch     0.768 us    20.15 us
+#                   8 chars     1 lines
+#   Back Porch      2.399 us    0.483 ms
+#                   25 chars    24 lines
+#   Active Time     15.352 us   16.120 ms
+#                   160 chars   800 lines
+#   Blank Time      4.798 us    0.564 ms
+#                   50 chars    28 lines
+#   Polarity        negtive    positive
+#
+    mode "1280x800-60"
+# D: 83.500 MHz, H: 49.702 kHz, V: 60.00 Hz
+    geometry 1280 800 1280 800 32 timings 11994 200 72 22 3 128 6 endmode
+#
+#   1280x960, 60 Hz, Non-Interlaced (108.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280    960
+#   Scan Frequency  60.000 kHz  60.00 Hz
+#   Sync Width      1.037 us    0.050 ms
+#               14 chars    3 lines
+#   Front Porch     0.889 us    0.017 ms
+#               12 chars    1 lines
+#   Back Porch      2.889 us    0.600 ms
+#               39 chars    36 lines
+#   Active Time     11.852 us   16.000 ms
+#               160 chars   960 lines
+#   Blank Time      4.815 us    0.667 ms
+#               65 chars    40 lines
+#   Polarity        positive    positive
+#
+    mode "1280x960-60"
+# D: 108.00 MHz, H: 60.000 kHz, V: 60.00 Hz
+    geometry 1280 960 1280 960 32
+    timings 9259 312 96 36 1 112 3 hsync high vsync high endmode
+#
+#   1280x1024, 60 Hz, Non-Interlaced (108.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280        1024
+#   Scan Frequency      63.981 kHz  60.02 Hz
+#   Sync Width      1.037 us    0.047 ms
+#               14 chars    3 lines
+#   Front Porch     0.444 us    0.015 ms
+#               6 chars     1 lines
+#   Back Porch      2.297 us    0.594 ms
+#               31 chars    38 lines
+#   Active Time     11.852 us   16.005 ms
+#               160 chars   1024 lines
+#   Blank Time      3.778 us    0.656 ms
+#               51 chars    42 lines
+#   Polarity        positive    positive
+#
+    mode "1280x1024-60"
+# D: 108.00 MHz, H: 63.981 kHz, V: 60.02 Hz
+    geometry 1280 1024 1280 1024 32
+    timings 9260 248 48 38 1 112 3 hsync high vsync high endmode
+#
+#   1280x1024, 75 Hz, Non-Interlaced (135.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280        1024
+#   Scan Frequency      79.976 kHz  75.02 Hz
+#   Sync Width      1.067 us    0.038 ms
+#               18 chars    3 lines
+#   Front Porch     0.119 us    0.012 ms
+#               2 chars     1 lines
+#   Back Porch      1.837 us    0.475 ms
+#               31 chars    38 lines
+#   Active Time     9.481 us    12.804 ms
+#               160 chars   1024 lines
+#   Blank Time      3.022 us    0.525 ms
+#               51 chars    42 lines
+#   Polarity        positive    positive
+#
+    mode "1280x1024-75"
+# D: 135.00 MHz, H: 79.976 kHz, V: 75.02 Hz
+    geometry 1280 1024 1280 1024 32
+    timings 7408 248 16 38 1 144 3 hsync high vsync high endmode
+#
+#   1280x1024, 85 Hz, Non-Interlaced (157.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280        1024
+#   Scan Frequency  91.146 kHz  85.02 Hz
+#   Sync Width      1.016 us    0.033 ms
+#               20 chars    3 lines
+#   Front Porch     0.406 us    0.011 ms
+#               8 chars     1 lines
+#   Back Porch      1.422 us    0.483 ms
+#               28 chars    44 lines
+#   Active Time     8.127 us    11.235 ms
+#               160 chars   1024 lines
+#   Blank Time      2.844 us    0.527 ms
+#               56 chars    48 lines
+#   Polarity        positive    positive
+#
+    mode "1280x1024-85"
+# D: 157.50 MHz, H: 91.146 kHz, V: 85.02 Hz
+    geometry 1280 1024 1280 1024 32
+    timings 6349 224 64 44 1 160 3
+    hsync high vsync high endmode mode "1440x900-60"
+# D: 106.500 MHz, H: 55.935 kHz, V: 60.00 Hz
+    geometry 1440 900 1440 900 32
+    timings 9390 232 80 25 3 152 6
+    hsync high vsync high endmode mode "1440x900-75"
+# D: 136.750 MHz, H: 70.635 kHz, V: 75.00 Hz
+    geometry 1440 900 1440 900 32
+    timings 7315 248 96 33 3 152 6 hsync high vsync high endmode
+#
+#   1440x1050, 60 Hz, Non-Interlaced (125.10 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1440        1050
+#   Scan Frequency      65.220 kHz  60.00 Hz
+#   Sync Width      1.204 us    0.046 ms
+#               19 chars    3 lines
+#   Front Porch     0.760 us    0.015 ms
+#               12 chars    1 lines
+#   Back Porch      1.964 us    0.495 ms
+#               31 chars    33 lines
+#   Active Time     11.405 us   16.099 ms
+#               180 chars   1050 lines
+#   Blank Time      3.928 us    0.567 ms
+#               62 chars    37 lines
+#   Polarity        positive    positive
+#
+    mode "1440x1050-60"
+# D: 125.10 MHz, H: 65.220 kHz, V: 60.00 Hz
+    geometry 1440 1050 1440 1050 32
+    timings 7993 248 96 33 1 152 3
+    hsync high vsync high endmode mode "1600x900-60"
+# D: 118.250 MHz, H: 55.990 kHz, V: 60.00 Hz
+    geometry 1600 900 1600 900 32
+    timings 8415 256 88 26 3 168 5 endmode mode "1600x1024-60"
+# D: 136.358 MHz, H: 63.600 kHz, V: 60.00 Hz
+    geometry 1600 1024 1600 1024 32 timings 7315 272 104 32 1 168 3 endmode
+#
+#   1600x1200, 60 Hz, Non-Interlaced (156.00 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1600        1200
+#   Scan Frequency      76.200 kHz  60.00 Hz
+#   Sync Width      1.026 us    0.105 ms
+#               20 chars    8 lines
+#   Front Porch     0.205 us    0.131 ms
+#               4 chars     10 lines
+#   Back Porch      1.636 us    0.682 ms
+#               32 chars    52 lines
+#   Active Time     10.256 us   15.748 ms
+#               200 chars   1200 lines
+#   Blank Time      2.872 us    0.866 ms
+#               56 chars    66 lines
+#   Polarity        negative    negative
+#
+    mode "1600x1200-60"
+# D: 156.00 MHz, H: 76.200 kHz, V: 60.00 Hz
+    geometry 1600 1200 1600 1200 32 timings 6172 256 32 52 10 160 8 endmode
+#
+#   1600x1200, 75 Hz, Non-Interlaced (202.50 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1600        1200
+#   Scan Frequency  93.750 kHz  75.00 Hz
+#   Sync Width      0.948 us    0.032 ms
+#               24 chars    3 lines
+#   Front Porch     0.316 us    0.011 ms
+#               8 chars     1 lines
+#   Back Porch      1.501 us    0.491 ms
+#               38 chars    46 lines
+#   Active Time     7.901 us    12.800 ms
+#               200 chars   1200 lines
+#   Blank Time      2.765 us    0.533 ms
+#               70 chars    50 lines
+#   Polarity    positive    positive
+#
+    mode "1600x1200-75"
+# D: 202.50 MHz, H: 93.750 kHz, V: 75.00 Hz
+    geometry 1600 1200 1600 1200 32
+    timings 4938 304 64 46 1 192 3
+    hsync high vsync high endmode mode "1680x1050-60"
+# D: 146.250 MHz, H: 65.290 kHz, V: 59.954 Hz
+    geometry 1680 1050 1680 1050 32
+    timings 6814 280 104 30 3 176 6
+    hsync high vsync high endmode mode "1680x1050-75"
+# D: 187.000 MHz, H: 82.306 kHz, V: 74.892 Hz
+    geometry 1680 1050 1680 1050 32
+    timings 5348 296 120 40 3 176 6
+    hsync high vsync high endmode mode "1792x1344-60"
+# D: 202.975 MHz, H: 83.460 kHz, V: 60.00 Hz
+    geometry 1792 1344 1792 1344 32
+    timings 4902 320 128 43 1 192 3
+    hsync high vsync high endmode mode "1856x1392-60"
+# D: 218.571 MHz, H: 86.460 kHz, V: 60.00 Hz
+    geometry 1856 1392 1856 1392 32
+    timings 4577 336 136 45 1 200 3
+    hsync high vsync high endmode mode "1920x1200-60"
+# D: 193.250 MHz, H: 74.556 kHz, V: 60.00 Hz
+    geometry 1920 1200 1920 1200 32
+    timings 5173 336 136 36 3 200 6
+    hsync high vsync high endmode mode "1920x1440-60"
+# D: 234.000 MHz, H:90.000 kHz, V: 60.00 Hz
+    geometry 1920 1440 1920 1440 32
+    timings 4274 344 128 56 1 208 3
+    hsync high vsync high endmode mode "1920x1440-75"
+# D: 297.000 MHz, H:112.500 kHz, V: 75.00 Hz
+    geometry 1920 1440 1920 1440 32
+    timings 3367 352 144 56 1 224 3
+    hsync high vsync high endmode mode "2048x1536-60"
+# D: 267.250 MHz, H: 95.446 kHz, V: 60.00 Hz
+    geometry 2048 1536 2048 1536 32
+    timings 3742 376 152 49 3 224 4 hsync high vsync high endmode
+#
+#   1280x720, 60 Hz, Non-Interlaced (74.481 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1280        720
+#   Scan Frequency      44.760 kHz  60.00 Hz
+#   Sync Width      1.826 us    67.024 ms
+#               17 chars    3 lines
+#   Front Porch     0.752 us    22.341 ms
+#               7 chars     1 lines
+#   Back Porch      2.578 us    491.510 ms
+#               24 chars    22 lines
+#   Active Time     17.186 us   16.086 ms
+#               160 chars   720 lines
+#   Blank Time      5.156 us    0.581 ms
+#               48 chars    26 lines
+#   Polarity        negative    negative
+#
+    mode "1280x720-60"
+# D: 74.481 MHz, H: 44.760 kHz, V: 60.00 Hz
+    geometry 1280 720 1280 720 32 timings 13426 192 64 22 1 136 3 endmode
+#
+#   1920x1080, 60 Hz, Non-Interlaced (172.798 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1920        1080
+#   Scan Frequency      67.080 kHz  60.00 Hz
+#   Sync Width      1.204 us    44.723 ms
+#               26 chars    3 lines
+#   Front Porch     0.694 us    14.908 ms
+#               15 chars     1 lines
+#   Back Porch      1.898 us    506.857 ms
+#               41 chars    34 lines
+#   Active Time     11.111 us   16.100 ms
+#               240 chars   1080 lines
+#   Blank Time      3.796 us    0.566 ms
+#               82 chars    38 lines
+#   Polarity        negative    negative
+#
+    mode "1920x1080-60"
+# D: 74.481 MHz, H: 67.080 kHz, V: 60.00 Hz
+    geometry 1920 1080 1920 1080 32 timings 5787 328 120 34 1 208 3 endmode
+#
+#   1400x1050, 60 Hz, Non-Interlaced (122.61 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1400        1050
+#   Scan Frequency      65.218 kHz  59.99 Hz
+#   Sync Width      1.037 us    0.047 ms
+#               19 chars    3 lines
+#   Front Porch     0.444 us    0.015 ms
+#               11 chars     1 lines
+#   Back Porch      1.185 us    0.188 ms
+#               30 chars    33 lines
+#   Active Time     12.963 us   16.411 ms
+#               175 chars   1050 lines
+#   Blank Time      2.667 us    0.250 ms
+#               60 chars    37 lines
+#   Polarity        negative    positive
+#
+    mode "1400x1050-60"
+# D: 122.750 MHz, H: 65.317 kHz, V: 59.99 Hz
+    geometry 1400 1050 1408 1050 32
+    timings 8214 232 88 32 3 144 4 endmode mode "1400x1050-75"
+# D: 156.000 MHz, H: 82.278 kHz, V: 74.867 Hz
+    geometry 1400 1050 1408 1050 32 timings 6410 248 104 42 3 144 4 endmode
+#
+#   1366x768, 60 Hz, Non-Interlaced (85.86 MHz dotclock)
+#
+#               Horizontal  Vertical
+#   Resolution      1366        768
+#   Scan Frequency      47.700 kHz  60.00 Hz
+#   Sync Width      1.677 us    0.063 ms
+#               18 chars    3 lines
+#   Front Porch     0.839 us    0.021 ms
+#               9 chars     1 lines
+#   Back Porch      2.516 us    0.482 ms
+#               27 chars    23 lines
+#   Active Time     15.933 us   16.101 ms
+#               171 chars   768 lines
+#   Blank Time      5.031 us    0.566 ms
+#               54 chars    27 lines
+#   Polarity        negative    positive
+#
+    mode "1360x768-60"
+# D: 84.750 MHz, H: 47.720 kHz, V: 60.00 Hz
+    geometry 1360 768 1360 768 32
+    timings 11799 208 72 22 3 136 5 endmode mode "1366x768-60"
+# D: 85.86 MHz, H: 47.700 kHz, V: 60.00 Hz
+    geometry 1366 768 1366 768 32
+    timings 11647 216 72 23 1 144 3 endmode mode "1366x768-50"
+# D: 69,924 MHz, H: 39.550 kHz, V: 50.00 Hz
+    geometry 1366 768 1366 768 32 timings 14301 200 56 19 1 144 3 endmode
diff -Nur a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
--- a/drivers/video/via/via_i2c.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/via_i2c.c	2008-05-04 07:18:43.000000000 -0400
@@ -0,0 +1,469 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
+
+/* i2c delay for microsecond*/
+void delays(int count)
+{
+	u8 data;
+	while (count--) {
+		/* delay 1 us */
+		data = inb(DELAYPORT);
+		data = inb(DELAYPORT);
+		data = inb(DELAYPORT);
+		data = inb(DELAYPORT);
+		data = inb(DELAYPORT);
+	}
+
+}
+
+/*  Write I2C BUS SDA And SCL*/
+void i2cWriteSdaScl(u8 sda, u8 scl)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AMR) {
+
+		data = ((scl << 1) | sda) << 4;
+		/* enable I2C port */
+		data = data | BIT0;
+
+		port_addr = I2CPORT;
+		/* Write Register Value */
+		write_reg(I2CPORTINDEX, port_addr, data);
+	} else {
+		if (chip_info.chip_on_slot == PORT_ON_AGP) {
+			data = ((scl << 1) | sda) << 4;
+			/* enable GPIO write port */
+			data = data | (BIT6 + BIT7);
+			port_addr = GPIOPORT;
+			/* Write Register Value */
+			write_reg(GPIOPORTINDEX, port_addr, data);
+		}
+	}
+}
+
+void i2cWriteScl(u8 scl)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AMR) {
+
+		data = (scl << 1) << 4;
+		/* enable I2C port */
+		data = data | BIT0;
+
+		port_addr = I2CPORT;
+		/* Write Register Value */
+		write_reg(I2CPORTINDEX, port_addr, data);
+	} else {
+		if (chip_info.chip_on_slot == PORT_ON_AGP) {
+			data = (scl << 1) << 4;
+			/* enable GPIO write clock */
+			data = data & 0xBF;
+			port_addr = GPIOPORT;
+			/* Write Register Value */
+			write_reg(GPIOPORTINDEX, port_addr, data);
+		}
+	}
+}
+
+void i2cReadSdaScl(u8 *pSda, u8 *pScl)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AMR) {
+		port_addr = I2CPORT;
+		data = read_reg(port_addr, I2CPORTINDEX);
+		*pSda = (data >> 2) & BIT0;	/* get sda */
+		*pScl = (data >> 3) & BIT0;	/* get scl */
+	} else {
+		if (chip_info.chip_on_slot == PORT_ON_AGP) {
+			port_addr = GPIOPORT;
+			data = read_reg(port_addr, GPIOPORTINDEX);
+			*pSda = (data >> 2) & BIT0;	/* get sda */
+			*pScl = (data >> 3) & BIT0;	/* get scl */
+		}
+	}
+}
+
+void i2cWriteSdaSclDelay(u8 sda, u8 scl)
+{
+	i2cWriteSdaScl(sda, scl);
+	delays(16);		/* Wait 16 uS */
+}
+
+void i2cStartSignal(void)
+{
+	i2cWriteSdaSclDelay(1, 1);
+	i2cWriteSdaSclDelay(0, 1);
+	i2cWriteSdaSclDelay(0, 0);
+}
+
+void i2cStopSignal(void)
+{
+	u8 data;
+	u16 port_addr;
+
+	i2cWriteSdaSclDelay(0, 0);
+	i2cWriteSdaSclDelay(0, 1);
+	i2cWriteSdaSclDelay(1, 1);
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		/* disable GPIO write port */
+		data = 0x3c;
+		port_addr = GPIOPORT;
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+	delays(2);
+
+}
+
+void disableSdaGPIO(void)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		data = read_reg(port_addr, GPIOPORTINDEX);
+		/* disable GPIO write port */
+		data = data & (~BIT6);
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+void enableSdaGPIO(void)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		data = read_reg(port_addr, GPIOPORTINDEX);
+		/* disable GPIO write port */
+		data = data | (BIT6);
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+void writeSclGPIO(u8 scl)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		data = read_reg(port_addr, GPIOPORTINDEX);
+		data = data & (~BIT5);
+		/* write data to clock */
+		data = (data | (scl << 5)) & (~BIT6);
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+void writeSdaGPIO(u8 sda)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		data = read_reg(port_addr, GPIOPORTINDEX);
+
+		data = data & (~BIT4);
+		/* write data to clock */
+		data = (data | (sda << 4)) & (~BIT7);
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+void enableGPIO(void)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		data = read_reg(port_addr, GPIOPORTINDEX);
+		/* enable GPIO write port */
+		data = data | (BIT4 + BIT5 + BIT6 + BIT7);
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+void releaseGPIO(void)
+{
+	u8 data;
+	u16 port_addr;
+
+	if (chip_info.chip_on_slot == PORT_ON_AGP) {
+		port_addr = GPIOPORT;
+		port_addr = port_addr + 1;
+
+		data = read_reg(port_addr, GPIOPORTINDEX);
+		/* disable GPIO write port */
+		data = data & 0x3c;
+		port_addr = GPIOPORT;
+		/* Write Register Value */
+		write_reg(GPIOPORTINDEX, port_addr, data);
+	}
+}
+
+int i2CWaitForSlave(void)
+{
+	int time_out = 20000;
+	u8 sda, scl;
+
+	while (time_out--) {
+		i2cReadSdaScl(&sda, &scl);
+		if (scl)
+			return (OK);	/* Successful stall */
+		delays(1);	/* wait 1 uS */
+	}
+	return (FAIL);		/* Slave fail */
+}
+
+int i2cOutByte(u8 data)
+{
+	u8 sda, scl;
+	u8 out_byte;
+	int bit_count = 8;
+	int status;
+
+	out_byte = data;
+	while (bit_count--) {
+		sda = (out_byte >> 7) & 1;	/* Load MSB */
+		out_byte = out_byte << 1;	/* next bit. */
+		i2cWriteSdaSclDelay(sda, 0);
+		i2cWriteSdaSclDelay(sda, 1);
+
+		status = i2CWaitForSlave();
+		if (status == FAIL)
+			return (status);
+		i2cWriteSdaSclDelay(sda, 0);
+
+	}
+
+	if ((chip_info.chip_on_slot == PORT_ON_AGP)) {
+
+		writeSclGPIO(0);
+		disableSdaGPIO();
+		delays(2);
+		writeSclGPIO(1);
+		delays(2);
+		i2cReadSdaScl(&sda, &scl);
+		writeSclGPIO(0);
+		delays(2);
+		if (sda == 0)
+			status = OK;
+		else
+			status = FAIL;
+
+	} else {
+		i2cWriteSdaSclDelay(1, 0);
+		i2cWriteSdaSclDelay(1, 1);
+		status = i2CWaitForSlave();
+		if (status == FAIL)
+			return (status);
+
+		i2cReadSdaScl(&sda, &scl);
+		if (sda == 0) {
+			i2cWriteSdaSclDelay(1, 0);
+			status = OK;
+		} else {
+
+			i2cWriteSdaSclDelay(1, 0);
+			status = FAIL;
+		}
+	}
+	return (status);
+}
+
+int i2cInputByte(u8 *pInByte, int ack)
+{
+
+	int bit_count = 8;
+	u8 sda, scl;
+	u8 data = 0;
+	int status;
+
+	disableSdaGPIO();
+
+	while (bit_count--) {
+		if ((chip_info.chip_on_slot == PORT_ON_AGP)) {
+
+			writeSclGPIO(1);
+			delays(2);
+			status = i2CWaitForSlave();
+			if (status == FAIL)
+				return (FAIL);
+			i2cReadSdaScl(&sda, &scl);
+			data = data << 1;
+			data |= sda;
+			writeSclGPIO(0);
+			delays(2);
+
+		} else {
+			i2cWriteSdaSclDelay(1, 1);
+			status = i2CWaitForSlave();
+			if (status == FAIL)
+				return (FAIL);
+			i2cReadSdaScl(&sda, &scl);
+			data = data << 1;
+			data |= sda;
+			i2cWriteSdaSclDelay(1, 0);
+		}
+	}
+	*pInByte = data;
+
+	if (ack) {
+		i2cWriteSdaSclDelay(0, 0);
+		i2cWriteSdaSclDelay(0, 1);
+		status = i2CWaitForSlave();
+		if (status == FAIL)
+			return (status);
+		i2cWriteSdaSclDelay(0, 0);
+	} else {
+		i2cWriteSdaSclDelay(1, 0);
+		i2cWriteSdaSclDelay(1, 1);
+		status = i2CWaitForSlave();
+		if (status == FAIL)
+			return (status);
+	}
+	i2cWriteSdaSclDelay(1, 0);
+
+	return (OK);
+}
+
+int i2cReadByte(u8 slave_addr, u8 index, u8 *pData)
+{
+
+	int status;
+
+	i2cStartSignal();
+
+	status = i2cOutByte(slave_addr);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+	status = i2cOutByte(index);
+
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+
+	i2cStartSignal();
+	status = i2cOutByte(slave_addr | BIT0);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+	status = i2cInputByte(pData, 0);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+
+	i2cStopSignal();
+	return (OK);
+}
+
+int i2cWriteByte(u8 slave_addr, u8 index, u8 data)
+{
+
+	int status;
+
+	i2cStartSignal();
+	status = i2cOutByte(slave_addr);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+	status = i2cOutByte(index);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+	status = i2cOutByte(data);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+	i2cStopSignal();
+	return (OK);
+}
+
+int i2cReadBytes(u8 slave_addr, u8 index, u8 *buff, int buff_len)
+{
+
+	int status, i;
+
+	i2cStartSignal();
+
+	status = i2cOutByte(slave_addr);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+
+	status = i2cOutByte(index);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+
+	i2cStartSignal();
+	status = i2cOutByte(slave_addr | BIT0);
+	if (status == FAIL) {
+		i2cStopSignal();
+		return (FAIL);
+	}
+
+	for (i = 0; i < buff_len; i++) {
+		if (buff_len == 1)
+			status = i2cInputByte(buff, 0);	/* send NACK */
+		else if (i < buff_len - 1)
+			status = i2cInputByte(buff, 1);	/* send ACK */
+		else
+			status = i2cInputByte(buff, 0);	/* send NACK */
+		if (status == FAIL) {
+			i2cStopSignal();
+			return (FAIL);
+		}
+		buff++;
+	}
+
+	i2cStopSignal();
+	return (OK);
+}
diff -Nur a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
--- a/drivers/video/via/via_i2c.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/via_i2c.h	2008-04-29 02:51:29.000000000 -0400
@@ -0,0 +1,51 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
+#ifndef __VIA_I2C_H__
+#define __VIA_I2C_H__
+
+#define I2CPORT           0x3c4
+#define I2CPORTINDEX      0x31
+#define GPIOPORT          0x3C4
+#define GPIOPORTINDEX     0x2C
+#define I2C_BUS             1
+#define GPIO_BUS            2
+#define DELAYPORT           0x3C3
+
+void delays(int count);
+void i2cWriteSdaScl(u8 sda, u8 scl);
+void i2cWriteScl(u8 scl);
+void i2cReadSdaScl(u8 *pSda, u8 *pScl);
+void i2cWriteSdaSclDelay(u8 sda, u8 scl);
+void i2cStartSignal(void);
+void i2cStopSignal(void);
+void disableSdaGPIO(void);
+void enableSdaGPIO(void);
+void writeSclGPIO(u8 scl);
+void writeSdaGPIO(u8 sda);
+void enableGPIO(void);
+void releaseGPIO(void);
+int i2CWaitForSlave(void);
+int i2cOutByte(u8 data);
+int i2cInputByte(u8 *pInByte, int ack);
+int i2cReadByte(u8 slave_addr, u8 index, u8 *pData);
+int i2cWriteByte(u8 slave_addr, u8 index, u8 data);
+int i2cReadBytes(u8 slave_addr, u8 index, u8 *buff, int buff_len);
+#endif /* __VIA_I2C_H__ */
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

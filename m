Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZG3UXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZG3UXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG3UXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:23:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:57126 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752370AbZG3UXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:23:11 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/ywaFnZcXylcYDwe4IX2noKXlsrE8IsMa4V0XH6/
	qRYW49uAWa2sBl
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       HaraldWelte@viatech.com
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/2] viafb: remove duplicated CX700 register init
Date: Thu, 30 Jul 2009 20:25:21 +0000
Message-Id: <1248985522-4316-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove duplicated CX700 register init

The current code initializes the register for CX700 chips 2 times due to a
missing break as discovered by Harald Welte.
As CX700 and VX800 have exactly the same register initialization we can use one
for both to avoid duplicated code.
As this is a pure code cleanup no measurable runtime effects are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 hw.c      |    5 +----
 viamode.c |   61 -------------------------------------------------------------
 viamode.h |    1 -
 3 files changed, 1 insertions(+), 66 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index c896000..64a820c 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2271,11 +2271,8 @@ int viafb_setmode(int vmode_index, int hor_res, int ver_res, int video_bpp,
 		break;
 
 	case UNICHROME_CX700:
-		viafb_write_regx(CX700_ModeXregs, NUM_TOTAL_CX700_ModeXregs);
-
 	case UNICHROME_VX800:
-		viafb_write_regx(VX800_ModeXregs, NUM_TOTAL_VX800_ModeXregs);
-
+		viafb_write_regx(CX700_ModeXregs, NUM_TOTAL_CX700_ModeXregs);
 		break;
 	}
 
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 6dcf583..e799b2d 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -329,67 +329,6 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
 };
 
-/* For VT3353: Common Setting for Video Mode */
-struct io_reg VX800_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
-{VIASR, SR15, 0x02, 0x02},
-{VIASR, SR16, 0xBF, 0x08},
-{VIASR, SR17, 0xFF, 0x1F},
-{VIASR, SR18, 0xFF, 0x4E},
-{VIASR, SR1A, 0xFB, 0x08},
-{VIASR, SR1B, 0xFF, 0xF0},
-{VIASR, SR1E, 0xFF, 0x01},
-{VIASR, SR2A, 0xFF, 0x00},
-{VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
-{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
-{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
-{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
-{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
-{VIACR, CR32, 0xFF, 0x00},
-{VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
-{VIACR, CR35, 0xFF, 0x00},
-{VIACR, CR36, 0x08, 0x00},
-{VIACR, CR47, 0xC8, 0x00},	/* Clear VCK Plus. */
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CRA3, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR69, 0xFF, 0x00},
-{VIACR, CR6A, 0xFF, 0x40},
-{VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1             */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2             */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3             */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4             */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5             */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6             */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7             */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8             */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9             */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10            */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11            */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12            */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13            */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14            */
-{VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
-{VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
-{VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
-{VIACR, CRD4, 0xFF, 0x81},	/* Second power sequence control       */
-{VIACR, CR8B, 0xFF, 0x5D},	/* LCD Power Sequence Control 0        */
-{VIACR, CR8C, 0xFF, 0x2B},	/* LCD Power Sequence Control 1        */
-{VIACR, CR8D, 0xFF, 0x6F},	/* LCD Power Sequence Control 2        */
-{VIACR, CR8E, 0xFF, 0x2B},	/* LCD Power Sequence Control 3        */
-{VIACR, CR8F, 0xFF, 0x01},	/* LCD Power Sequence Control 4        */
-{VIACR, CR90, 0xFF, 0x01},	/* LCD Power Sequence Control 5        */
-{VIACR, CR91, 0xFF, 0x80},	/* 24/12 bit LVDS Data off             */
-{VIACR, CR96, 0xFF, 0x00},
-{VIACR, CR97, 0xFF, 0x00},
-{VIACR, CR99, 0xFF, 0x00},
-{VIACR, CR9B, 0xFF, 0x00},
-{VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
-};
-
 /* Video Mode Table */
 /* Common Setting for Video Mode */
 struct io_reg CLE266_ModeXregs[] = { {VIASR, SR1E, 0xF0, 0x00},
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 1a5de50..2ec8bfe 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -56,7 +56,6 @@ struct res_map_refresh {
 #define NUM_TOTAL_CN700_ModeXregs ARRAY_SIZE(CN700_ModeXregs)
 #define NUM_TOTAL_KM400_ModeXregs ARRAY_SIZE(KM400_ModeXregs)
 #define NUM_TOTAL_CX700_ModeXregs ARRAY_SIZE(CX700_ModeXregs)
-#define NUM_TOTAL_VX800_ModeXregs ARRAY_SIZE(VX800_ModeXregs)
 #define NUM_TOTAL_CLE266_ModeXregs ARRAY_SIZE(CLE266_ModeXregs)
 #define NUM_TOTAL_PATCH_MODE ARRAY_SIZE(res_patch_table)
 #define NUM_TOTAL_MODETABLE ARRAY_SIZE(CLE266Modes)
-- 
1.6.3.2


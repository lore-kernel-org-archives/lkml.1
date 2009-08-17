Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZHQLzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZHQLzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbZHQLzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:55:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:41673 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757824AbZHQLzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:55:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+h/7V+qM2hez4ZgMx2mcbnsM1LLkTkBEmJR0KKGC
	GX4vcs5OXDrOpO
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/4] viafb: cleanup viamode.h
Date: Mon, 17 Aug 2009 11:58:07 +0000
Message-Id: <1250510290-3327-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: cleanup viamode.h

This patch removes unneeeded declarations from the header and makes it
more maintainable by evaluating the array size in the file the array
exist in and exporting it via variables. This removes the need to keep
the array size in the header in sync with the real array size.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 viamode.c |   10 ++++
 viamode.h |  138 ++++++++++---------------------------------------------------
 2 files changed, 32 insertions(+), 116 deletions(-)

diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 1a850c3..464903c 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -1011,3 +1011,13 @@ struct VideoModeTable CEA_HDMI_Modes[] = {
 	{VIA_RES_1280X720, CEAM1280x720, ARRAY_SIZE(CEAM1280x720)},
 	{VIA_RES_1920X1080, CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
 };
+
+int NUM_TOTAL_RES_MAP_REFRESH = ARRAY_SIZE(res_map_refresh_tbl);
+int NUM_TOTAL_CEA_MODES = ARRAY_SIZE(CEA_HDMI_Modes);
+int NUM_TOTAL_CN400_ModeXregs = ARRAY_SIZE(CN400_ModeXregs);
+int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
+int NUM_TOTAL_KM400_ModeXregs = ARRAY_SIZE(KM400_ModeXregs);
+int NUM_TOTAL_CX700_ModeXregs = ARRAY_SIZE(CX700_ModeXregs);
+int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
+int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
+int NUM_TOTAL_MODETABLE = ARRAY_SIZE(CLE266Modes);
diff --git a/drivers/video/via/viamode.h b/drivers/video/via/viamode.h
index 2ec8bfe..504e16a 100644
--- a/drivers/video/via/viamode.h
+++ b/drivers/video/via/viamode.h
@@ -50,127 +50,33 @@ struct res_map_refresh {
 	int vmode_refresh;
 };
 
-#define NUM_TOTAL_RES_MAP_REFRESH ARRAY_SIZE(res_map_refresh_tbl)
-#define NUM_TOTAL_CEA_MODES  ARRAY_SIZE(CEA_HDMI_Modes)
-#define NUM_TOTAL_CN400_ModeXregs ARRAY_SIZE(CN400_ModeXregs)
-#define NUM_TOTAL_CN700_ModeXregs ARRAY_SIZE(CN700_ModeXregs)
-#define NUM_TOTAL_KM400_ModeXregs ARRAY_SIZE(KM400_ModeXregs)
-#define NUM_TOTAL_CX700_ModeXregs ARRAY_SIZE(CX700_ModeXregs)
-#define NUM_TOTAL_CLE266_ModeXregs ARRAY_SIZE(CLE266_ModeXregs)
-#define NUM_TOTAL_PATCH_MODE ARRAY_SIZE(res_patch_table)
-#define NUM_TOTAL_MODETABLE ARRAY_SIZE(CLE266Modes)
+extern int NUM_TOTAL_RES_MAP_REFRESH;
+extern int NUM_TOTAL_CEA_MODES;
+extern int NUM_TOTAL_CN400_ModeXregs;
+extern int NUM_TOTAL_CN700_ModeXregs;
+extern int NUM_TOTAL_KM400_ModeXregs;
+extern int NUM_TOTAL_CX700_ModeXregs;
+extern int NUM_TOTAL_CLE266_ModeXregs;
+extern int NUM_TOTAL_PATCH_MODE;
+extern int NUM_TOTAL_MODETABLE;
 
 /********************/
 /* Mode Table       */
 /********************/
 
-/* 480x640 */
-extern struct crt_mode_table CRTM480x640[1];
-/* 640x480*/
-extern struct crt_mode_table CRTM640x480[5];
-/*720x480 (GTF)*/
-extern struct crt_mode_table CRTM720x480[1];
-/*720x576 (GTF)*/
-extern struct crt_mode_table CRTM720x576[1];
-/* 800x480 (CVT) */
-extern struct crt_mode_table CRTM800x480[1];
-/* 800x600*/
-extern struct crt_mode_table CRTM800x600[5];
-/* 848x480 (CVT) */
-extern struct crt_mode_table CRTM848x480[1];
-/*856x480 (GTF) convert to 852x480*/
-extern struct crt_mode_table CRTM852x480[1];
-/*1024x512 (GTF)*/
-extern struct crt_mode_table CRTM1024x512[1];
-/* 1024x600*/
-extern struct crt_mode_table CRTM1024x600[1];
-/* 1024x768*/
-extern struct crt_mode_table CRTM1024x768[4];
-/* 1152x864*/
-extern struct crt_mode_table CRTM1152x864[1];
-/* 1280x720 (HDMI 720P)*/
-extern struct crt_mode_table CRTM1280x720[2];
-/*1280x768 (GTF)*/
-extern struct crt_mode_table CRTM1280x768[2];
-/* 1280x800 (CVT) */
-extern struct crt_mode_table CRTM1280x800[1];
-/*1280x960*/
-extern struct crt_mode_table CRTM1280x960[1];
-/* 1280x1024*/
-extern struct crt_mode_table CRTM1280x1024[3];
-/* 1368x768 (GTF) */
-extern struct crt_mode_table CRTM1368x768[1];
-/*1440x1050 (GTF)*/
-extern struct crt_mode_table CRTM1440x1050[1];
-/* 1600x1200*/
-extern struct crt_mode_table CRTM1600x1200[2];
-/* 1680x1050 (CVT) */
-extern struct crt_mode_table CRTM1680x1050[2];
-/* 1680x1050 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1680x1050_RB[1];
-/* 1920x1080 (CVT)*/
-extern struct crt_mode_table CRTM1920x1080[1];
-/* 1920x1080 (CVT with Reduce Blanking) */
-extern struct crt_mode_table CRTM1920x1080_RB[1];
-/* 1920x1440*/
-extern struct crt_mode_table CRTM1920x1440[2];
-/* 1400x1050 (CVT) */
-extern struct crt_mode_table CRTM1400x1050[2];
-/* 1400x1050 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1400x1050_RB[1];
-/* 960x600 (CVT) */
-extern struct crt_mode_table CRTM960x600[1];
-/* 1000x600 (GTF) */
-extern struct crt_mode_table CRTM1000x600[1];
-/* 1024x576 (GTF) */
-extern struct crt_mode_table CRTM1024x576[1];
-/* 1088x612 (CVT) */
-extern struct crt_mode_table CRTM1088x612[1];
-/* 1152x720 (CVT) */
-extern struct crt_mode_table CRTM1152x720[1];
-/* 1200x720 (GTF) */
-extern struct crt_mode_table CRTM1200x720[1];
-/* 1280x600 (GTF) */
-extern struct crt_mode_table CRTM1280x600[1];
-/* 1360x768 (CVT) */
-extern struct crt_mode_table CRTM1360x768[1];
-/* 1360x768 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1360x768_RB[1];
-/* 1366x768 (GTF) */
-extern struct crt_mode_table CRTM1366x768[2];
-/* 1440x900 (CVT) */
-extern struct crt_mode_table CRTM1440x900[2];
-/* 1440x900 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1440x900_RB[1];
-/* 1600x900 (CVT) */
-extern struct crt_mode_table CRTM1600x900[1];
-/* 1600x900 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1600x900_RB[1];
-/* 1600x1024 (GTF) */
-extern struct crt_mode_table CRTM1600x1024[1];
-/* 1792x1344 (DMT) */
-extern struct crt_mode_table CRTM1792x1344[1];
-/* 1856x1392 (DMT) */
-extern struct crt_mode_table CRTM1856x1392[1];
-/* 1920x1200 (CVT) */
-extern struct crt_mode_table CRTM1920x1200[1];
-/* 1920x1200 (CVT with Reduce Blanking) */
-extern struct crt_mode_table CRTM1920x1200_RB[1];
-/* 2048x1536 (CVT) */
-extern struct crt_mode_table CRTM2048x1536[1];
-extern struct VideoModeTable CLE266Modes[47];
-extern struct crt_mode_table CEAM1280x720[1];
-extern struct crt_mode_table CEAM1920x1080[1];
-extern struct VideoModeTable CEA_HDMI_Modes[2];
+extern struct VideoModeTable CLE266Modes[];
+extern struct crt_mode_table CEAM1280x720[];
+extern struct crt_mode_table CEAM1920x1080[];
+extern struct VideoModeTable CEA_HDMI_Modes[];
 
-extern struct res_map_refresh res_map_refresh_tbl[61];
-extern struct io_reg CN400_ModeXregs[52];
-extern struct io_reg CN700_ModeXregs[66];
-extern struct io_reg KM400_ModeXregs[55];
-extern struct io_reg CX700_ModeXregs[58];
-extern struct io_reg VX800_ModeXregs[58];
-extern struct io_reg CLE266_ModeXregs[32];
-extern struct io_reg PM1024x768[2];
-extern struct patch_table res_patch_table[1];
+extern struct res_map_refresh res_map_refresh_tbl[];
+extern struct io_reg CN400_ModeXregs[];
+extern struct io_reg CN700_ModeXregs[];
+extern struct io_reg KM400_ModeXregs[];
+extern struct io_reg CX700_ModeXregs[];
+extern struct io_reg VX800_ModeXregs[];
+extern struct io_reg CLE266_ModeXregs[];
+extern struct io_reg PM1024x768[];
+extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
 #endif /* __VIAMODE_H__ */
-- 
1.6.3.2


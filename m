Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYKIQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYKIQzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYKIQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:55:09 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37619 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbYKIQzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:55:07 -0500
Date: Sun, 9 Nov 2008 17:55:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/8] drivers/media: use ARRAY_SIZE
Message-ID: <Pine.LNX.4.64.0811091754410.32509@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/common/tuners/mxl5005s.c        |    6 +++---
 drivers/media/video/gspca/gspca.c             |    2 +-
 drivers/media/video/gspca/mars.c              |    2 +-
 drivers/media/video/gspca/spca500.c           |    4 ++--
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index a887824..31522d2 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -3598,7 +3598,7 @@ static u16 MXL_GetInitRegister(struct dvb_frontend *fe, u8 *RegNum,
 		76, 77, 91, 134, 135, 137, 147,
 		156, 166, 167, 168, 25 };
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	status += MXL_BlockInit(fe);
 
@@ -3630,7 +3630,7 @@ static u16 MXL_GetCHRegister(struct dvb_frontend *fe, u8 *RegNum, u8 *RegVal,
 	*/
 #endif
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	for (i = 0 ; i < *count; i++) {
 		RegNum[i] = RegAddr[i];
@@ -3648,7 +3648,7 @@ static u16 MXL_GetCHRegister_ZeroIF(struct dvb_frontend *fe, u8 *RegNum,
 
 	u8 RegAddr[] = {43, 136};
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	for (i = 0; i < *count; i++) {
 		RegNum[i] = RegAddr[i];
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index e48fbfc..e2bd10f 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -728,7 +728,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 			if (fmtdesc->index == index)
 				break;		/* new format */
 			index++;
-			if (index >= sizeof fmt_tb / sizeof fmt_tb[0])
+			if (index >= ARRAY_SIZE(fmt_tb))
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/media/video/gspca/mars.c b/drivers/media/video/gspca/mars.c
index 277ca34..492cdd3 100644
--- a/drivers/media/video/gspca/mars.c
+++ b/drivers/media/video/gspca/mars.c
@@ -123,7 +123,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam = &gspca_dev->cam;
 	cam->epaddr = 0x01;
 	cam->cam_mode = vga_mode;
-	cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+	cam->nmodes = ARRAY_SIZE(vga_mode);
 	sd->qindex = 1;			/* set the quantization table */
 	return 0;
 }
diff --git a/drivers/media/video/gspca/spca500.c b/drivers/media/video/gspca/spca500.c
index bca106c..09ff697 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -633,10 +633,10 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->subtype = id->driver_info;
 	if (sd->subtype != LogitechClickSmart310) {
 		cam->cam_mode = vga_mode;
-		cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+		cam->nmodes = ARRAY_SIZE(vga_mode);
 	} else {
 		cam->cam_mode = sif_mode;
-		cam->nmodes = sizeof sif_mode / sizeof sif_mode[0];
+		cam->nmodes = ARRAY_SIZE(sif_mode);
 	}
 	sd->qindex = 5;
 	sd->brightness = BRIGHTNESS_DEF;
diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index c5d0b44..76b1640 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -159,7 +159,7 @@ static struct saa7134_tvaudio tvaudio[] = {
 		.mode          = TVAUDIO_FM_MONO,
 	}
 };
-#define TVAUDIO (sizeof(tvaudio)/sizeof(struct saa7134_tvaudio))
+#define TVAUDIO ARRAY_SIZE(tvaudio)
 
 /* ------------------------------------------------------------------ */
 

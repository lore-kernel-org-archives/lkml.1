Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZLGAZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZLGAZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932797AbZLGAN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:26 -0500
Received: from kroah.org ([198.145.64.141]:34496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbZLGANV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:51 2009
Message-Id: <20091207000651.565883198@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean-Francois Moine <moinejf@free.fr>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: [064/119] V4L/DVB (12280): gspca - sonixj: Remove auto gain/wb/expo for the ov7660 sensor.
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-12280-gspca-sonixj-remove-auto-gain-wb-expo-for-the-ov7660-sensor.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean-Francois Moine <moinejf@free.fr>

commit d8f400efc1ef7b344e07590fb6b77431bc358ba0 upstream.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/sonixj.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -727,13 +727,13 @@ static const u8 ov7660_sensor_init[][8] 
 	{0xa1, 0x21, 0x12, 0x05, 0x00, 0x00, 0x00, 0x10},
 						/* Outformat = rawRGB */
 	{0xa1, 0x21, 0x13, 0xb8, 0x00, 0x00, 0x00, 0x10}, /* init COM8 */
-	{0xd1, 0x21, 0x00, 0x01, 0x74, 0x74, 0x00, 0x10},
+	{0xd1, 0x21, 0x00, 0x01, 0x74, 0x92, 0x00, 0x10},
 						/* GAIN BLUE RED VREF */
 	{0xd1, 0x21, 0x04, 0x00, 0x7d, 0x62, 0x00, 0x10},
 						/* COM 1 BAVE GEAVE AECHH */
 	{0xb1, 0x21, 0x08, 0x83, 0x01, 0x00, 0x00, 0x10}, /* RAVE COM2 */
 	{0xd1, 0x21, 0x0c, 0x00, 0x08, 0x04, 0x4f, 0x10}, /* COM 3 4 5 6 */
-	{0xd1, 0x21, 0x10, 0x7f, 0x40, 0x05, 0xff, 0x10},
+	{0xd1, 0x21, 0x10, 0x7f, 0x40, 0x05, 0xf8, 0x10},
 						/* AECH CLKRC COM7 COM8 */
 	{0xc1, 0x21, 0x14, 0x2c, 0x00, 0x02, 0x00, 0x10}, /* COM9 COM10 */
 	{0xd1, 0x21, 0x17, 0x10, 0x60, 0x02, 0x7b, 0x10},
@@ -1637,16 +1637,19 @@ static void setfreq(struct gspca_dev *gs
 	if (gspca_dev->ctrl_dis & (1 << FREQ_IDX))
 		return;
 	if (sd->sensor == SENSOR_OV7660) {
+		u8 com8;
+
+		com8 = 0xf8;		/* no auto gain/wb/expo */
 		switch (sd->freq) {
 		case 0: /* Banding filter disabled */
-			i2c_w1(gspca_dev, 0x13, 0xdf);
+			i2c_w1(gspca_dev, 0x13, com8 & 0xdf);
 			break;
 		case 1: /* 50 hz */
-			i2c_w1(gspca_dev, 0x13, 0xff);
+			i2c_w1(gspca_dev, 0x13, com8);
 			i2c_w1(gspca_dev, 0x3b, 0x0a);
 			break;
 		case 2: /* 60 hz */
-			i2c_w1(gspca_dev, 0x13, 0xff);
+			i2c_w1(gspca_dev, 0x13, com8);
 			i2c_w1(gspca_dev, 0x3b, 0x02);
 			break;
 		}



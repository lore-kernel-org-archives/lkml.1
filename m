Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXKERN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXKERN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbXKERHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59516 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757588AbXKERHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:50 -0500
Date: Mon, 5 Nov 2007 18:07:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/video/et61x251/: make 5 functions static
Message-ID: <20071105170726.GN12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions in 
et61x251_core.c static:
- et61x251_read_reg()
- et61x251_i2c_try_read()
- et61x251_i2c_try_write()
- et61x251_i2c_read()
- et61x251_i2c_write()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/et61x251/et61x251_core.c   |   20 ++++++++---------
 drivers/media/video/et61x251/et61x251_sensor.h |    8 ------
 2 files changed, 10 insertions(+), 18 deletions(-)

e176e19b9d562fe3d3fe1cddf3f08136002f1b25 
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index d19d73b..38d2ad0 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -227,7 +227,7 @@ int et61x251_write_reg(struct et61x251_device* cam, u8 value, u16 index)
 }
 
 
-int et61x251_read_reg(struct et61x251_device* cam, u16 index)
+static int et61x251_read_reg(struct et61x251_device* cam, u16 index)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* buff = cam->control_buffer;
@@ -268,9 +268,9 @@ et61x251_i2c_wait(struct et61x251_device* cam,
 }
 
 
-int
-et61x251_i2c_try_read(struct et61x251_device* cam,
-		      const struct et61x251_sensor* sensor, u8 address)
+static int et61x251_i2c_try_read(struct et61x251_device* cam,
+				 const struct et61x251_sensor* sensor,
+				 u8 address)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* data = cam->control_buffer;
@@ -301,10 +301,9 @@ et61x251_i2c_try_read(struct et61x251_device* cam,
 }
 
 
-int
-et61x251_i2c_try_write(struct et61x251_device* cam,
-		       const struct et61x251_sensor* sensor, u8 address,
-		       u8 value)
+static int et61x251_i2c_try_write(struct et61x251_device* cam,
+				  const struct et61x251_sensor* sensor,
+				  u8 address, u8 value)
 {
 	struct usb_device* udev = cam->usbdev;
 	u8* data = cam->control_buffer;
@@ -387,13 +386,14 @@ et61x251_i2c_raw_write(struct et61x251_device* cam, u8 n, u8 data1, u8 data2,
 }
 
 
-int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
+static int et61x251_i2c_read(struct et61x251_device* cam, u8 address)
 {
 	return et61x251_i2c_try_read(cam, &cam->sensor, address);
 }
 
 
-int et61x251_i2c_write(struct et61x251_device* cam, u8 address, u8 value)
+static int et61x251_i2c_write(struct et61x251_device* cam,
+			      u8 address, u8 value)
 {
 	return et61x251_i2c_try_write(cam, &cam->sensor, address, value);
 }
diff --git a/drivers/media/video/et61x251/et61x251_sensor.h b/drivers/media/video/et61x251/et61x251_sensor.h
index e145863..71a0314 100644
--- a/drivers/media/video/et61x251/et61x251_sensor.h
+++ b/drivers/media/video/et61x251/et61x251_sensor.h
@@ -52,14 +52,6 @@ et61x251_attach_sensor(struct et61x251_device* cam,
 /*****************************************************************************/
 
 extern int et61x251_write_reg(struct et61x251_device*, u8 value, u16 index);
-extern int et61x251_read_reg(struct et61x251_device*, u16 index);
-extern int et61x251_i2c_write(struct et61x251_device*, u8 address, u8 value);
-extern int et61x251_i2c_read(struct et61x251_device*, u8 address);
-extern int et61x251_i2c_try_write(struct et61x251_device*,
-				  const struct et61x251_sensor*, u8 address,
-				  u8 value);
-extern int et61x251_i2c_try_read(struct et61x251_device*,
-				 const struct et61x251_sensor*, u8 address);
 extern int et61x251_i2c_raw_write(struct et61x251_device*, u8 n, u8 data1,
 				  u8 data2, u8 data3, u8 data4, u8 data5,
 				  u8 data6, u8 data7, u8 data8, u8 address);


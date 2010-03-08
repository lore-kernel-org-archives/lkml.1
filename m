Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0CHW0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:26:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36485 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0CHW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MjbS7QmOF2dzADNapxxCn/E+yr2+WdwkwXDxAwSQIEW5O0CtEj+IW0DLXFaWrz+BL6
         YGRV4DeYUcy2aGdOUn20HkpPNmlYca2BuGJW40p4XnLXzdryiyFRoN0jvlgzEjpotfij
         VJKiQlpRLNOOruSchxwiYpyVmXXE4aKaVeMGY=
From: Benjamin Adolphi <b.adolphi@googlemail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Benjamin Adolphi <b.adolphi@gmail.com>
Subject: [PATCH] Staging: tm6000: Checkpatch cleanups
Date: Mon,  8 Mar 2010 23:25:26 +0100
Message-Id: <1268087126-6896-1-git-send-email-b.adolphi@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some checkpatch issues in the tm6000 driver.

Signed-off-by: Benjamin Adolphi <b.adolphi@gmail.com>
---
 drivers/staging/tm6000/tm6000-alsa.c     |    5 ++-
 drivers/staging/tm6000/tm6000-i2c.c      |   41 +++++++++++++++--------------
 drivers/staging/tm6000/tm6000-regs.h     |    2 +-
 drivers/staging/tm6000/tm6000-stds.c     |    6 ++--
 drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 7cc2ac7..6873a0f 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -16,7 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/usb.h>
 
-#include <asm/delay.h>
+#include <linux/delay.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -76,7 +76,8 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
 				Module macros
  ****************************************************************************/
 
-MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
+MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 "
+		   "based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index ec4c938..68354e5 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -40,9 +40,9 @@ static unsigned int i2c_debug = 0;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-#define i2c_dprintk(lvl,fmt, args...) if (i2c_debug>=lvl) do{ \
+#define i2c_dprintk(lvl, fmt, args...) if (i2c_debug >= lvl) do { \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
-			dev->name, __FUNCTION__ , ##args); } while (0)
+			dev->name, __func__ , ##args); } while (0)
 
 static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 				__u8 reg, char *buf, int len)
@@ -58,7 +58,8 @@ static int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr,
 	int rc;
 	u8 b[2];
 
-	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
+	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr)
+	    && (reg % 2 == 0)) {
 		/*
 		 * Workaround an I2C bug when reading from zl10353
 		 */
@@ -98,7 +99,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 		return 0;
 	for (i = 0; i < num; i++) {
 		addr = (msgs[i].addr << 1) & 0xff;
-		i2c_dprintk(2,"%s %s addr=0x%x len=%d:",
+		i2c_dprintk(2, "%s %s addr=0x%x len=%d:",
 			 (msgs[i].flags & I2C_M_RD) ? "read" : "write",
 			 i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
 		if (msgs[i].flags & I2C_M_RD) {
@@ -128,15 +129,16 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 					msgs[i].buf[0] << 8 | msgs[i].buf[1],
 					msgs[i + 1].buf, msgs[i + 1].len);
 			} else {
-				rc = tm6000_i2c_recv_regs(dev, addr, msgs[i].buf[0],
-					msgs[i + 1].buf, msgs[i + 1].len);
+				rc = tm6000_i2c_recv_regs(dev, addr,
+					msgs[i].buf[0], msgs[i + 1].buf,
+					msgs[i + 1].len);
 			}
 
 			i++;
 
 			if (addr == dev->tuner_addr << 1) {
-				tm6000_set_reg(dev, 0x32, 0,0);
-				tm6000_set_reg(dev, 0x33, 0,0);
+				tm6000_set_reg(dev, 0x32, 0, 0);
+				tm6000_set_reg(dev, 0x33, 0, 0);
 			}
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
@@ -150,8 +152,8 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				msgs[i].buf + 1, msgs[i].len - 1);
 
 			if (addr == dev->tuner_addr  << 1) {
-				tm6000_set_reg(dev, 0x32, 0,0);
-				tm6000_set_reg(dev, 0x33, 0,0);
+				tm6000_set_reg(dev, 0x32, 0, 0);
+				tm6000_set_reg(dev, 0x33, 0, 0);
 			}
 		}
 		if (i2c_debug >= 2)
@@ -162,7 +164,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	return num;
 err:
-	i2c_dprintk(2," ERROR: %i\n", rc);
+	i2c_dprintk(2, " ERROR: %i\n", rc);
 	return rc;
 }
 
@@ -193,11 +195,10 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev,
 		if (0 == (i % 16))
 			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
 		printk(" %02x", eedata[i]);
-		if ((eedata[i] >= ' ') && (eedata[i] <= 'z')) {
+		if ((eedata[i] >= ' ') && (eedata[i] <= 'z'))
 			bytes[i%16] = eedata[i];
-		} else {
-			bytes[i%16]='.';
-		}
+		else
+			bytes[i%16] = '.';
 
 		i++;
 
@@ -233,14 +234,14 @@ static u32 functionality(struct i2c_adapter *adap)
 
 #define mass_write(addr, reg, data...)					\
 	{ const static u8 _val[] = data;				\
-	rc=tm6000_read_write_usb(dev,USB_DIR_OUT | USB_TYPE_VENDOR,	\
-	REQ_16_SET_GET_I2C_WR1_RDN,(reg<<8)+addr, 0x00, (u8 *) _val,	\
+	rc = tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,	\
+	REQ_16_SET_GET_I2C_WR1_RDN, (reg<<8)+addr, 0x00, (u8 *) _val,	\
 	ARRAY_SIZE(_val));						\
-	if (rc<0) {							\
-		printk(KERN_ERR "Error on line %d: %d\n",__LINE__,rc);	\
+	if (rc < 0) {							\
+		printk(KERN_ERR "Error on line %d: %d\n", __LINE__, rc);\
 		return rc;						\
 	}								\
-	msleep (10);							\
+	msleep(10);							\
 	}
 
 static struct i2c_algorithm tm6000_algo = {
diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 6c93688..15c9057 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -78,7 +78,7 @@
  */
 
 enum {
-	TM6000_URB_MSG_VIDEO=1,
+	TM6000_URB_MSG_VIDEO = 1,
 	TM6000_URB_MSG_AUDIO,
 	TM6000_URB_MSG_VBI,
 	TM6000_URB_MSG_PTS,
diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index 1e142e5..421a6bc 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -763,11 +763,11 @@ static struct tm6000_std_settings svideo_stds[] = {
 void tm6000_get_std_res(struct tm6000_core *dev)
 {
 	/* Currently, those are the only supported resoltions */
-	if (dev->norm & V4L2_STD_525_60) {
+	if (dev->norm & V4L2_STD_525_60)
 		dev->height = 480;
-	} else {
+	else
 		dev->height = 576;
-	}
+
 	dev->width = 720;
 }
 
diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index 5a5049a..e6602bd 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -46,7 +46,7 @@ struct usb_isoc_ctl {
 	int				tmp_buf_len;
 
 		/* Stores already requested buffers */
-	struct tm6000_buffer    	*buf;
+	struct tm6000_buffer		*buf;
 
 		/* Stores the number of received fields */
 	int				nfields;
-- 
1.6.4.4


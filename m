Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307Ab0B0RFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:05:48 -0500
Received: from aliencamel.com ([69.93.184.242]:36916 "EHLO aliencamel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968633Ab0B0RFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:05:45 -0500
Message-ID: <4B8950E2.4030201@aliencamel.com>
Date: Sat, 27 Feb 2010 17:05:38 +0000
From: Stewart Robertson <stewart_r@aliencamel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, m.kozlowski@tuxland.pl,
       julia@diku.dk
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging-comedi-fix-comments-over-80-issue-in-usbdu.patch
Content-Type: multipart/mixed;
 boundary="------------070204030601050909070905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070204030601050909070905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

One more for luck...

Not quite as much to fix in this one but I've still managed to iron out
a few wrinkles.  The remaining going over 80 characters warnings are instances
of code, which I do not know how to wrap effectively.

Once again I have pasted it below and hopefully set Thunderbird to not
mangle it but I have attached the patch in case it does.

Cheers,

Stewart

P.S. If someone could let me know whether the way the emails are arriving is okay
or if I need to change the settings I am using I would appreciate it.


>From 20795e3686e8350e51ad24f8346093c42e39ddf1 Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sat, 27 Feb 2010 16:45:39 +0000
Subject: [PATCH] Staging: comedi: fix comments over 80 issue in usbduxfast.c
 This is a patch to the usbduxfast.c file that fixes comments
 over 80 warnings found by the checkpatch.pl tool
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/usbduxfast.c |   44 +++++++++++++++-----------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2e675cc..4e8ee6a 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -178,8 +178,8 @@ struct usbduxfastsub_s {
 	int16_t *insnBuffer;	/* input buffer for single insn */
 	int ifnum;		/* interface number */
 	struct usb_interface *interface;	/* interface structure */
-	struct comedi_device *comedidev;	/* comedi device for the interrupt
-						   context */
+	/* comedi device for the interrupt context */
+	struct comedi_device *comedidev;
 	short int ai_cmd_running;	/* asynchronous command is running */
 	short int ai_continous;	/* continous aquisition */
 	long int ai_sample_count;	/* number of samples to aquire */
@@ -272,7 +272,8 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 	udfs->ai_cmd_running = 0;
 
 	if (do_unlink)
-		ret = usbduxfastsub_unlink_InURBs(udfs);	/* stop aquistion */
+		/* stop aquistion */
+		ret = usbduxfastsub_unlink_InURBs(udfs);
 
 	return ret;
 }
@@ -452,13 +453,15 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer,	/* address of the transfer buffer */
-			      1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+	/* bRequest, "Firmware" */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+				VENDOR_DIR_OUT,	/* bmRequestType */
+				USBDUXFASTSUB_CPUCS,	/* Value */
+				0x0000,	/* Index */
+				/* address of the transfer buffer */
+				local_transfer_buffer,
+				1,	/* Length */
+				EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -474,7 +477,8 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
+	/* bRequest, "Firmware" */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
 			      VENDOR_DIR_OUT,	/* bmRequestType */
 			      USBDUXFASTSUB_CPUCS,	/* Value */
 			      0x0000,	/* Index */
@@ -500,13 +504,15 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	printk(KERN_DEBUG " to addr %d, first byte=%d.\n",
 	       startAddr, local_transfer_buffer[0]);
 #endif
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* brequest, firmware */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      startAddr,	/* value */
-			      0x0000,	/* index */
-			      local_transfer_buffer,	/* our local safe buffer */
-			      len,	/* length */
-			      EZTIMEOUT);	/* timeout */
+	/* brequest, firmware */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+				VENDOR_DIR_OUT,	/* bmRequestType */
+				startAddr,	/* value */
+				0x0000,	/* index */
+				/* our local safe buffer */
+				local_transfer_buffer,
+				len,	/* length */
+				EZTIMEOUT);	/* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
@@ -1348,7 +1354,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 #define FIRMWARE_MAX_LEN 0x2000
 
 static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
-			  const u8 * firmwareBinary, int sizeFirmware)
+			  const u8 *firmwareBinary, int sizeFirmware)
 {
 	int ret;
 	uint8_t *fwBuf;
-- 
1.6.0.4



--------------070204030601050909070905
Content-Type: text/x-patch;
 name="0004-Staging-comedi-fix-comments-over-80-issue-in-usbdu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0004-Staging-comedi-fix-comments-over-80-issue-in-usbdu.patc";
 filename*1="h"

>From 20795e3686e8350e51ad24f8346093c42e39ddf1 Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sat, 27 Feb 2010 16:45:39 +0000
Subject: [PATCH] Staging: comedi: fix comments over 80 issue in usbduxfast.c
 This is a patch to the usbduxfast.c file that fixes comments
 over 80 warnings found by the checkpatch.pl tool
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/usbduxfast.c |   44 +++++++++++++++-----------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 2e675cc..4e8ee6a 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -178,8 +178,8 @@ struct usbduxfastsub_s {
 	int16_t *insnBuffer;	/* input buffer for single insn */
 	int ifnum;		/* interface number */
 	struct usb_interface *interface;	/* interface structure */
-	struct comedi_device *comedidev;	/* comedi device for the interrupt
-						   context */
+	/* comedi device for the interrupt context */
+	struct comedi_device *comedidev;
 	short int ai_cmd_running;	/* asynchronous command is running */
 	short int ai_continous;	/* continous aquisition */
 	long int ai_sample_count;	/* number of samples to aquire */
@@ -272,7 +272,8 @@ static int usbduxfast_ai_stop(struct usbduxfastsub_s *udfs, int do_unlink)
 	udfs->ai_cmd_running = 0;
 
 	if (do_unlink)
-		ret = usbduxfastsub_unlink_InURBs(udfs);	/* stop aquistion */
+		/* stop aquistion */
+		ret = usbduxfastsub_unlink_InURBs(udfs);
 
 	return ret;
 }
@@ -452,13 +453,15 @@ static int usbduxfastsub_start(struct usbduxfastsub_s *udfs)
 
 	/* 7f92 to zero */
 	local_transfer_buffer[0] = 0;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      USBDUXFASTSUB_CPUCS,	/* Value */
-			      0x0000,	/* Index */
-			      local_transfer_buffer,	/* address of the transfer buffer */
-			      1,	/* Length */
-			      EZTIMEOUT);	/* Timeout */
+	/* bRequest, "Firmware" */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+				VENDOR_DIR_OUT,	/* bmRequestType */
+				USBDUXFASTSUB_CPUCS,	/* Value */
+				0x0000,	/* Index */
+				/* address of the transfer buffer */
+				local_transfer_buffer,
+				1,	/* Length */
+				EZTIMEOUT);	/* Timeout */
 	if (ret < 0) {
 		printk("comedi_: usbduxfast_: control msg failed (start)\n");
 		return ret;
@@ -474,7 +477,8 @@ static int usbduxfastsub_stop(struct usbduxfastsub_s *udfs)
 
 	/* 7f92 to one */
 	local_transfer_buffer[0] = 1;
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* bRequest, "Firmware" */
+	/* bRequest, "Firmware" */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
 			      VENDOR_DIR_OUT,	/* bmRequestType */
 			      USBDUXFASTSUB_CPUCS,	/* Value */
 			      0x0000,	/* Index */
@@ -500,13 +504,15 @@ static int usbduxfastsub_upload(struct usbduxfastsub_s *udfs,
 	printk(KERN_DEBUG " to addr %d, first byte=%d.\n",
 	       startAddr, local_transfer_buffer[0]);
 #endif
-	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,	/* brequest, firmware */
-			      VENDOR_DIR_OUT,	/* bmRequestType */
-			      startAddr,	/* value */
-			      0x0000,	/* index */
-			      local_transfer_buffer,	/* our local safe buffer */
-			      len,	/* length */
-			      EZTIMEOUT);	/* timeout */
+	/* brequest, firmware */
+	ret = usb_control_msg(udfs->usbdev, usb_sndctrlpipe(udfs->usbdev, 0), USBDUXFASTSUB_FIRMWARE,
+				VENDOR_DIR_OUT,	/* bmRequestType */
+				startAddr,	/* value */
+				0x0000,	/* index */
+				/* our local safe buffer */
+				local_transfer_buffer,
+				len,	/* length */
+				EZTIMEOUT);	/* timeout */
 
 #ifdef CONFIG_COMEDI_DEBUG
 	printk(KERN_DEBUG "comedi_: usbduxfast: result=%d\n", ret);
@@ -1348,7 +1354,7 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 #define FIRMWARE_MAX_LEN 0x2000
 
 static int firmwareUpload(struct usbduxfastsub_s *usbduxfastsub,
-			  const u8 * firmwareBinary, int sizeFirmware)
+			  const u8 *firmwareBinary, int sizeFirmware)
 {
 	int ret;
 	uint8_t *fwBuf;
-- 
1.6.0.4


--------------070204030601050909070905--

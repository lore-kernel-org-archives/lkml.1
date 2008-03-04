Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYCDDLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYCDDLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYCDDJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:09:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:10535 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbYCDDJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fvP+u5mlKVR1YJi8dNOCoELZAezPc7+HuPV+xsZno5NRGzJkR3A8bXq3Ju9H6VLxzjrMagzzNx+oU8lrcQG99wBiq00DA6Fd+dhdkIl7ISZ988abnTxujWv+GvRE7mJFqBrqi5zMLavZ3bJsXpFCKuo75ca1YwDzqiUYZfNzTv4=
Subject: [PATCH 03/14] input: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:43 -0800
Message-Id: <1204600183.22933.83.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/joystick/iforce/iforce-usb.c |    6 +++---
 drivers/input/joystick/xpad.c              |   12 ++++++------
 drivers/input/keyboard/lkkbd.c             |    6 +++---
 drivers/input/misc/ati_remote.c            |   18 +++++++++---------
 drivers/input/misc/ati_remote2.c           |   18 +++++++++---------
 drivers/input/misc/keyspan_remote.c        |   20 ++++++++++----------
 drivers/input/misc/powermate.c             |    6 +++---
 drivers/input/misc/yealink.c               |   12 ++++++------
 drivers/input/mouse/appletouch.c           |    8 ++++----
 drivers/input/tablet/acecad.c              |    4 ++--
 drivers/input/tablet/aiptek.c              |    6 +++---
 drivers/input/tablet/kbtab.c               |    6 +++---
 drivers/input/tablet/wacom_sys.c           |    6 +++---
 drivers/input/touchscreen/usbtouchscreen.c |   22 +++++++++++-----------
 14 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index 1457b73..e9bba5f 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -89,10 +89,10 @@ static void iforce_usb_irq(struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
-		dbg("%s - urb has status of: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb has status of: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -103,7 +103,7 @@ exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, status);
+		     __func__, status);
 }
 
 static void iforce_usb_out(struct urb *urb)
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 0380597..8c9486e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -350,11 +350,11 @@ static void xpad_irq_in(struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 		goto exit;
 	}
 
@@ -367,7 +367,7 @@ exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
@@ -384,11 +384,11 @@ static void xpad_irq_out(struct urb *urb)
 		case -ESHUTDOWN:
 			/* this urb is terminated, clean up */
 			dbg("%s - urb shutting down with status: %d",
-				__FUNCTION__, urb->status);
+				__func__, urb->status);
 			return;
 		default:
 			dbg("%s - nonzero urb status received: %d",
-				__FUNCTION__, urb->status);
+				__func__, urb->status);
 			goto exit;
 	}
 
@@ -396,7 +396,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 }
 
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
diff --git a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
index 32e2c26..4730ef3 100644
--- a/drivers/input/keyboard/lkkbd.c
+++ b/drivers/input/keyboard/lkkbd.c
@@ -538,11 +538,11 @@ lkkbd_event (struct input_dev *dev, unsigned int type, unsigned int code,
 			switch (code) {
 				case SND_CLICK:
 					if (value == 0) {
-						DBG ("%s: Deactivating key clicks\n", __FUNCTION__);
+						DBG ("%s: Deactivating key clicks\n", __func__);
 						lk->serio->write (lk->serio, LK_CMD_DISABLE_KEYCLICK);
 						lk->serio->write (lk->serio, LK_CMD_DISABLE_CTRCLICK);
 					} else {
-						DBG ("%s: Activating key clicks\n", __FUNCTION__);
+						DBG ("%s: Activating key clicks\n", __func__);
 						lk->serio->write (lk->serio, LK_CMD_ENABLE_KEYCLICK);
 						lk->serio->write (lk->serio, volume_to_hw (lk->keyclick_volume));
 						lk->serio->write (lk->serio, LK_CMD_ENABLE_CTRCLICK);
@@ -560,7 +560,7 @@ lkkbd_event (struct input_dev *dev, unsigned int type, unsigned int code,
 
 		default:
 			printk (KERN_ERR "%s (): Got unknown type %d, code %d, value %d\n",
-					__FUNCTION__, type, code, value);
+					__func__, type, code, value);
 	}
 
 	return -1;
diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
index f3b86c2..debfc1a 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -330,7 +330,7 @@ static int ati_remote_open(struct input_dev *inputdev)
 	ati_remote->irq_urb->dev = ati_remote->udev;
 	if (usb_submit_urb(ati_remote->irq_urb, GFP_KERNEL)) {
 		dev_err(&ati_remote->interface->dev,
-			"%s: usb_submit_urb failed!\n", __FUNCTION__);
+			"%s: usb_submit_urb failed!\n", __func__);
 		return -EIO;
 	}
 
@@ -356,7 +356,7 @@ static void ati_remote_irq_out(struct urb *urb)
 
 	if (urb->status) {
 		dev_dbg(&ati_remote->interface->dev, "%s: status %d\n",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 		return;
 	}
 
@@ -601,17 +601,17 @@ static void ati_remote_irq_in(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		dev_dbg(&ati_remote->interface->dev, "%s: urb error status, unlink? \n",
-			__FUNCTION__);
+			__func__);
 		return;
 	default:		/* error */
 		dev_dbg(&ati_remote->interface->dev, "%s: Nonzero urb status %d\n",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
 	}
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&ati_remote->interface->dev, "%s: usb_submit_urb()=%d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 }
 
 /*
@@ -734,7 +734,7 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	int err = -ENOMEM;
 
 	if (iface_host->desc.bNumEndpoints != 2) {
-		err("%s: Unexpected desc.bNumEndpoints\n", __FUNCTION__);
+		err("%s: Unexpected desc.bNumEndpoints\n", __func__);
 		return -ENODEV;
 	}
 
@@ -742,11 +742,11 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	endpoint_out = &iface_host->endpoint[1].desc;
 
 	if (!usb_endpoint_is_int_in(endpoint_in)) {
-		err("%s: Unexpected endpoint_in\n", __FUNCTION__);
+		err("%s: Unexpected endpoint_in\n", __func__);
 		return -ENODEV;
 	}
 	if (le16_to_cpu(endpoint_in->wMaxPacketSize) == 0) {
-		err("%s: endpoint_in message size==0? \n", __FUNCTION__);
+		err("%s: endpoint_in message size==0? \n", __func__);
 		return -ENODEV;
 	}
 
@@ -814,7 +814,7 @@ static void ati_remote_disconnect(struct usb_interface *interface)
 	ati_remote = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 	if (!ati_remote) {
-		warn("%s - null device?\n", __FUNCTION__);
+		warn("%s - null device?\n", __func__);
 		return;
 	}
 
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index f2709b8..a7fabaf 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -137,14 +137,14 @@ static int ati_remote2_open(struct input_dev *idev)
 	r = usb_submit_urb(ar2->urb[0], GFP_KERNEL);
 	if (r) {
 		dev_err(&ar2->intf[0]->dev,
-			"%s: usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s: usb_submit_urb() = %d\n", __func__, r);
 		return r;
 	}
 	r = usb_submit_urb(ar2->urb[1], GFP_KERNEL);
 	if (r) {
 		usb_kill_urb(ar2->urb[0]);
 		dev_err(&ar2->intf[1]->dev,
-			"%s: usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s: usb_submit_urb() = %d\n", __func__, r);
 		return r;
 	}
 
@@ -294,17 +294,17 @@ static void ati_remote2_complete_mouse(struct urb *urb)
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&ar2->intf[0]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 		return;
 	default:
 		dev_err(&ar2->intf[0]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 	}
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		dev_err(&ar2->intf[0]->dev,
-			"%s(): usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s(): usb_submit_urb() = %d\n", __func__, r);
 }
 
 static void ati_remote2_complete_key(struct urb *urb)
@@ -321,17 +321,17 @@ static void ati_remote2_complete_key(struct urb *urb)
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&ar2->intf[1]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 		return;
 	default:
 		dev_err(&ar2->intf[1]->dev,
-			"%s(): urb status = %d\n", __FUNCTION__, urb->status);
+			"%s(): urb status = %d\n", __func__, urb->status);
 	}
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		dev_err(&ar2->intf[1]->dev,
-			"%s(): usb_submit_urb() = %d\n", __FUNCTION__, r);
+			"%s(): usb_submit_urb() = %d\n", __func__, r);
 }
 
 static int ati_remote2_input_init(struct ati_remote2 *ar2)
@@ -438,7 +438,7 @@ static int ati_remote2_setup(struct ati_remote2 *ar2)
 			    channel, 0x0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	if (r) {
 		dev_err(&ar2->udev->dev, "%s - failed to set channel due to error: %d\n",
-			__FUNCTION__, r);
+			__func__, r);
 		return r;
 	}
 
diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index 952938a..86afdd1 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -159,7 +159,7 @@ static int keyspan_load_tester(struct usb_keyspan* dev, int bits_needed)
 	if (dev->data.pos >= dev->data.len) {
 		dev_dbg(&dev->udev->dev,
 			"%s - Error ran out of data. pos: %d, len: %d\n",
-			__FUNCTION__, dev->data.pos, dev->data.len);
+			__func__, dev->data.pos, dev->data.len);
 		return -1;
 	}
 
@@ -267,7 +267,7 @@ static void keyspan_check_data(struct usb_keyspan *remote)
 				remote->data.tester = remote->data.tester >> 6;
 				remote->data.bits_left -= 6;
 			} else {
-				err("%s - Unknown sequence found in system data.\n", __FUNCTION__);
+				err("%s - Unknown sequence found in system data.\n", __func__);
 				remote->stage = 0;
 				return;
 			}
@@ -286,7 +286,7 @@ static void keyspan_check_data(struct usb_keyspan *remote)
 				remote->data.tester = remote->data.tester >> 6;
 				remote->data.bits_left -= 6;
 			} else {
-				err("%s - Unknown sequence found in button data.\n", __FUNCTION__);
+				err("%s - Unknown sequence found in button data.\n", __func__);
 				remote->stage = 0;
 				return;
 			}
@@ -302,7 +302,7 @@ static void keyspan_check_data(struct usb_keyspan *remote)
 			remote->data.tester = remote->data.tester >> 6;
 			remote->data.bits_left -= 6;
 		} else {
-			err("%s - Error in message, invalid toggle.\n", __FUNCTION__);
+			err("%s - Error in message, invalid toggle.\n", __func__);
 			remote->stage = 0;
 			return;
 		}
@@ -317,7 +317,7 @@ static void keyspan_check_data(struct usb_keyspan *remote)
 
 		dev_dbg(&remote->udev->dev,
 			"%s found valid message: system: %d, button: %d, toggle: %d\n",
-			__FUNCTION__, message.system, message.button, message.toggle);
+			__func__, message.system, message.button, message.toggle);
 
 		if (message.toggle != remote->toggle) {
 			keyspan_report_button(remote, message.button, 1);
@@ -341,7 +341,7 @@ static int keyspan_setup(struct usb_device* dev)
 				 0x11, 0x40, 0x5601, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set bit rate due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
@@ -349,7 +349,7 @@ static int keyspan_setup(struct usb_device* dev)
 				 0x44, 0x40, 0x0, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to set resume sensitivity due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
@@ -357,11 +357,11 @@ static int keyspan_setup(struct usb_device* dev)
 				 0x22, 0x40, 0x0, 0x0, NULL, 0, 0);
 	if (retval) {
 		dev_dbg(&dev->dev, "%s - failed to turn receive on due to error: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 		return(retval);
 	}
 
-	dev_dbg(&dev->dev, "%s - Setup complete.\n", __FUNCTION__);
+	dev_dbg(&dev->dev, "%s - Setup complete.\n", __func__);
 	return(retval);
 }
 
@@ -397,7 +397,7 @@ static void keyspan_irq_recv(struct urb *urb)
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		err ("%s - usb_submit_urb failed with result: %d", __FUNCTION__, retval);
+		err ("%s - usb_submit_urb failed with result: %d", __func__, retval);
 }
 
 static int keyspan_open(struct input_dev *dev)
diff --git a/drivers/input/misc/powermate.c b/drivers/input/misc/powermate.c
index 7a7b8c7..a53c488 100644
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -96,10 +96,10 @@ static void powermate_irq(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -112,7 +112,7 @@ exit:
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 /* Decide if we need to issue a control message and do so. Must be called with pm->lock taken */
diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
index 46279ef..8a949e7 100644
--- a/drivers/input/misc/yealink.c
+++ b/drivers/input/misc/yealink.c
@@ -427,7 +427,7 @@ static void urb_irq_callback(struct urb *urb)
 	int ret;
 
 	if (urb->status)
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+		err("%s - urb status %d", __func__, urb->status);
 
 	switch (yld->irq_data->cmd) {
 	case CMD_KEYPRESS:
@@ -449,7 +449,7 @@ static void urb_irq_callback(struct urb *urb)
 
 	ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
 	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+		err("%s - usb_submit_urb failed %d", __func__, ret);
 }
 
 static void urb_ctl_callback(struct urb *urb)
@@ -458,7 +458,7 @@ static void urb_ctl_callback(struct urb *urb)
 	int ret;
 
 	if (urb->status)
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+		err("%s - urb status %d", __func__, urb->status);
 
 	switch (yld->ctl_data->cmd) {
 	case CMD_KEYPRESS:
@@ -473,7 +473,7 @@ static void urb_ctl_callback(struct urb *urb)
 	}
 
 	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+		err("%s - usb_submit_urb failed %d", __func__, ret);
 }
 
 /*******************************************************************************
@@ -505,7 +505,7 @@ static int input_open(struct input_dev *dev)
 	struct yealink_dev *yld = input_get_drvdata(dev);
 	int i, ret;
 
-	dbg("%s", __FUNCTION__);
+	dbg("%s", __func__);
 
 	/* force updates to device */
 	for (i = 0; i<sizeof(yld->master); i++)
@@ -521,7 +521,7 @@ static int input_open(struct input_dev *dev)
 	yld->ctl_data->sum	= 0x100-CMD_INIT-10;
 	if ((ret = usb_submit_urb(yld->urb_ctl, GFP_KERNEL)) != 0) {
 		dbg("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, ret);
+		     __func__, ret);
 		return ret;
 	}
 	return 0;
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index b4423a4..1970f88 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -276,7 +276,7 @@ static void atp_reinit(struct work_struct *work)
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
@@ -368,11 +368,11 @@ static void atp_complete(struct urb* urb)
 	case -ESHUTDOWN:
 		/* This urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -554,7 +554,7 @@ exit:
 	retval = usb_submit_urb(dev->urb, GFP_ATOMIC);
 	if (retval) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index b973d0e..570e0e8 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -73,10 +73,10 @@ static void usb_acecad_irq(struct urb *urb)
 		case -ENOENT:
 		case -ESHUTDOWN:
 			/* this urb is terminated, clean up */
-			dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+			dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 			return;
 		default:
-			dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+			dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 			goto resubmit;
 	}
 
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 94683f5..39a748d 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -448,12 +448,12 @@ static void aiptek_irq(struct urb *urb)
 	case -ESHUTDOWN:
 		/* This urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -812,7 +812,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval != 0) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 	}
 }
 
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 1182fc1..8c620bc 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -56,10 +56,10 @@ static void kbtab_irq(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -88,7 +88,7 @@ static void kbtab_irq(struct urb *urb)
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 static struct usb_device_id kbtab_ids[] = {
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index d64b1ea..008106f 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -56,10 +56,10 @@ static void wacom_sys_irq(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -73,7 +73,7 @@ static void wacom_sys_irq(struct urb *urb)
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, retval);
+		     __func__, retval);
 }
 
 void wacom_report_key(void *wcombo, unsigned int key_type, int key_data)
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 63f9664..1690a5c 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -262,7 +262,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
 	dbg("%s - usb_control_msg - MTOUCHUSB_RESET - bytes|err: %d",
-	    __FUNCTION__, ret);
+	    __func__, ret);
 	if (ret < 0)
 		return ret;
 	msleep(150);
@@ -273,7 +273,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
 		dbg("%s - usb_control_msg - MTOUCHUSB_ASYNC_REPORT - bytes|err: %d",
-		    __FUNCTION__, ret);
+		    __func__, ret);
 		if (ret >= 0)
 			break;
 		if (ret != -EPIPE)
@@ -786,18 +786,18 @@ static void usbtouch_irq(struct urb *urb)
 	case -ETIME:
 		/* this urb is timing out */
 		dbg("%s - urb timed out - was the device unplugged?",
-		    __FUNCTION__);
+		    __func__);
 		return;
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		return;
 	default:
 		dbg("%s - nonzero urb status received: %d",
-		    __FUNCTION__, urb->status);
+		    __func__, urb->status);
 		goto exit;
 	}
 
@@ -807,7 +807,7 @@ exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		err("%s - usb_submit_urb failed with result: %d",
-		    __FUNCTION__, retval);
+		    __func__, retval);
 }
 
 static int usbtouch_open(struct input_dev *input)
@@ -876,7 +876,7 @@ static int usbtouch_probe(struct usb_interface *intf,
 
 	usbtouch->irq = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbtouch->irq) {
-		dbg("%s - usb_alloc_urb failed: usbtouch->irq", __FUNCTION__);
+		dbg("%s - usb_alloc_urb failed: usbtouch->irq", __func__);
 		goto out_free_buffers;
 	}
 
@@ -932,14 +932,14 @@ static int usbtouch_probe(struct usb_interface *intf,
 	if (type->init) {
 		err = type->init(usbtouch);
 		if (err) {
-			dbg("%s - type->init() failed, err: %d", __FUNCTION__, err);
+			dbg("%s - type->init() failed, err: %d", __func__, err);
 			goto out_free_buffers;
 		}
 	}
 
 	err = input_register_device(usbtouch->input);
 	if (err) {
-		dbg("%s - input_register_device failed, err: %d", __FUNCTION__, err);
+		dbg("%s - input_register_device failed, err: %d", __func__, err);
 		goto out_free_buffers;
 	}
 
@@ -959,12 +959,12 @@ static void usbtouch_disconnect(struct usb_interface *intf)
 {
 	struct usbtouch_usb *usbtouch = usb_get_intfdata(intf);
 
-	dbg("%s - called", __FUNCTION__);
+	dbg("%s - called", __func__);
 
 	if (!usbtouch)
 		return;
 
-	dbg("%s - usbtouch is initialized, cleaning up", __FUNCTION__);
+	dbg("%s - usbtouch is initialized, cleaning up", __func__);
 	usb_set_intfdata(intf, NULL);
 	usb_kill_urb(usbtouch->irq);
 	input_unregister_device(usbtouch->input);
-- 
1.5.4.3.500.g83a2c



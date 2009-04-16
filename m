Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZDPBpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZDPBpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZDPBo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:44:59 -0400
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:57989 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752244AbZDPBo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:44:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH]  usb/core/hub.c: fix sparse warnings
Date: Wed, 15 Apr 2009 21:44:44 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]  usb/core/hub.c: fix sparse warnings
Thread-Index: Acm+NOsVfKgQN1NDRaifb7COSG57Ig==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 01:44:56.0227 (UTC) FILETIME=[F1DEFF30:01C9BE34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in drivers/usb/core/hub.c.

	warning: symbol 'temp' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index be86ae3..8ab98c9 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -457,13 +457,13 @@ static void hub_tt_kevent (struct work_struct
*work)
 
 	spin_lock_irqsave (&hub->tt.lock, flags);
 	while (--limit && !list_empty (&hub->tt.clear_list)) {
-		struct list_head	*temp;
+		struct list_head	*next;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev = hub->hdev;
 		int			status;
 
-		temp = hub->tt.clear_list.next;
-		clear = list_entry (temp, struct usb_tt_clear,
clear_list);
+		next = hub->tt.clear_list.next;
+		clear = list_entry (next, struct usb_tt_clear,
clear_list);
 		list_del (&clear->clear_list);
 
 		/* drop lock so HCD can concurrently report other TT
errors */
@@ -518,7 +518,7 @@ void usb_hub_tt_clear_buffer (struct usb_device
*udev, int pipe)
 			: (USB_ENDPOINT_XFER_BULK << 11);
 	if (usb_pipein (pipe))
 		clear->devinfo |= 1 << 15;
-	
+
 	/* tell keventd to clear state for this TT */
 	spin_lock_irqsave (&tt->lock, flags);
 	list_add_tail (&clear->clear_list, &tt->clear_list);
@@ -571,7 +571,7 @@ static int hub_hub_status(struct usb_hub *hub,
 			"%s failed (err = %d)\n", __func__, ret);
 	else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
-		*change = le16_to_cpu(hub->status->hub.wHubChange); 
+		*change = le16_to_cpu(hub->status->hub.wHubChange);
 		ret = 0;
 	}
 	mutex_unlock(&hub->status_mutex);
@@ -2330,7 +2330,7 @@ static inline int remote_wakeup(struct usb_device
*udev)
  * Between connect detection and reset signaling there must be a delay
  * of 100ms at least for debounce and power-settling.  The
corresponding
  * timer shall restart whenever the downstream port detects a
disconnect.
- * 
+ *
  * Apparently there are some bluetooth and irda-dongles and a number of
  * low-speed devices for which this debounce period may last over a
second.
  * Not covered by the spec - but easy to deal with.
@@ -2490,7 +2490,7 @@ hub_port_init (struct usb_hub *hub, struct
usb_device *udev, int port1,
 	default:
 		goto fail;
 	}
- 
+
 	type = "";
 	switch (udev->speed) {
 	case USB_SPEED_LOW:	speed = "low";	break;
@@ -2516,7 +2516,7 @@ hub_port_init (struct usb_hub *hub, struct
usb_device *udev, int port1,
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
- 
+
 	/* Why interleave GET_DESCRIPTOR and SET_ADDRESS this way?
 	 * Because device hardware and firmware is sometimes buggy in
 	 * this area, and this is how Linux has done it for ages.
@@ -2647,7 +2647,7 @@ hub_port_init (struct usb_hub *hub, struct
usb_device *udev, int port1,
 		udev->ep0.desc.wMaxPacketSize = cpu_to_le16(i);
 		usb_ep0_reinit(udev);
 	}
-  
+
 	retval = usb_get_device_descriptor(udev, USB_DT_DEVICE_SIZE);
 	if (retval < (signed)sizeof(udev->descriptor)) {
 		dev_err(&udev->dev, "device descriptor read/all, error
%d\n",
@@ -2894,7 +2894,7 @@ static void hub_port_connect_change(struct usb_hub
*hub, int port1,
 				goto loop_disable;
 			}
 		}
- 
+
 		/* check for devices running slower than they could */
 		if (le16_to_cpu(udev->descriptor.bcdUSB) >= 0x0200
 				&& udev->speed == USB_SPEED_FULL
@@ -2951,7 +2951,7 @@ loop:
 			!(hcd->driver->port_handed_over)(hcd, port1))
 		dev_err(hub_dev, "unable to enumerate USB device on port
%d\n",
 				port1);
- 
+
 done:
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent)
@@ -3077,7 +3077,7 @@ static void hub_events(void)
 				 * EM interference sometimes causes
badly
 				 * shielded USB devices to be shutdown
by
 				 * the hub, this hack enables them
again.
-				 * Works at least with mouse driver. 
+				 * Works at least with mouse driver.
 				 */
 				if (!(portstatus & USB_PORT_STAT_ENABLE)
 				    && !connect_change
@@ -3112,7 +3112,7 @@ static void hub_events(void)
 					"resume on port %d, status
%d\n",
 					i, ret);
 			}
-			
+
 			if (portchange & USB_PORT_STAT_C_OVERCURRENT) {
 				dev_err (hub_dev,
 					"over-current change on port
%d\n",
@@ -3386,7 +3386,7 @@ static int usb_reset_and_verify_device(struct
usb_device *udev)
 
 	if (ret < 0)
 		goto re_enumerate;
- 
+
 	/* Device might have changed firmware (DFU or similar) */
 	if (descriptors_changed(udev, &descriptor)) {
 		dev_info(&udev->dev, "device firmware changed\n");
@@ -3440,7 +3440,7 @@ static int usb_reset_and_verify_device(struct
usb_device *udev)
 
 done:
 	return 0;
- 
+
 re_enumerate:
 	hub_port_logical_disconnect(parent_hub, port1);
 	return -ENODEV; 

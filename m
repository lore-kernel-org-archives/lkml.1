Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbXA0CBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbXA0CBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 21:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXA0CBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 21:01:01 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:34694 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXA0CBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 21:01:00 -0500
Date: Sat, 27 Jan 2007 03:00:27 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: kai.germaschewski@gmx.de, kkeil@suse.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070127020235.12590.91019.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/isdn/hisax/: Convert to generic boolean-values
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386

 hfc_usb.c |   40 ++++++++++++++++++++--------------------
 hfc_usb.h |    3 ---
 2 files changed, 20 insertions(+), 23 deletions(-)


diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 5a6989f..aaa6b88 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -183,7 +183,7 @@ typedef struct hfcusb_data {
 	int vend_idx;		/* vendor found */
 	int b_mode[2];		/* B-channel mode */
 	int l1_activated;	/* layer 1 activated */
-	int disc_flag;		/* TRUE if device was disonnected to avoid some USB actions */
+	int disc_flag;		/* 'true' if device was disonnected to avoid some USB actions */
 	int packet_size, iso_packet_size;
 
 	/* control pipe background handling */
@@ -392,7 +392,7 @@ l1_timer_expire_t3(hfcusb_data * hfc)
 	DBG(ISDN_DBG,
 	    "HFC-S USB: PH_DEACTIVATE | INDICATION sent (T3 expire)");
 #endif
-	hfc->l1_activated = FALSE;
+	hfc->l1_activated = false;
 	handle_led(hfc, LED_S0_OFF);
 	/* deactivate : */
 	queue_control_request(hfc, HFCUSB_STATES, 0x10, 1);
@@ -411,7 +411,7 @@ l1_timer_expire_t4(hfcusb_data * hfc)
 	DBG(ISDN_DBG,
 	    "HFC-S USB: PH_DEACTIVATE | INDICATION sent (T4 expire)");
 #endif
-	hfc->l1_activated = FALSE;
+	hfc->l1_activated = false;
 	handle_led(hfc, LED_S0_OFF);
 }
 
@@ -452,7 +452,7 @@ state_handler(hfcusb_data * hfc, __u8 state)
 #ifdef CONFIG_HISAX_DEBUG
 		DBG(ISDN_DBG, "HFC-S USB: PH_ACTIVATE | INDICATION sent");
 #endif
-		hfc->l1_activated = TRUE;
+		hfc->l1_activated = true;
 		handle_led(hfc, LED_S0_ON);
 	} else if (state <= 3 /* && activated */ ) {
 		if (old_state == 7 || old_state == 8) {
@@ -472,7 +472,7 @@ state_handler(hfcusb_data * hfc, __u8 state)
 			DBG(ISDN_DBG,
 			    "HFC-S USB: PH_DEACTIVATE | INDICATION sent");
 #endif
-			hfc->l1_activated = FALSE;
+			hfc->l1_activated = false;
 			handle_led(hfc, LED_S0_OFF);
 		}
 	}
@@ -622,7 +622,7 @@ tx_iso_complete(struct urb *urb)
 	if (fifo->active && !status) {
 		transp_mode = 0;
 		if (fifon < 4 && hfc->b_mode[fifon / 2] == L1_MODE_TRANS)
-			transp_mode = TRUE;
+			transp_mode = true;
 
 		/* is FifoFull-threshold set for our channel? */
 		threshbit = threshtable[fifon] & hfc->threshold_mask;
@@ -640,7 +640,7 @@ tx_iso_complete(struct urb *urb)
 			      tx_iso_complete, urb->context);
 		memset(context_iso_urb->buffer, 0,
 		       sizeof(context_iso_urb->buffer));
-		frame_complete = FALSE;
+		frame_complete = false;
 		/* Generate next Iso Packets */
 		for (k = 0; k < num_isoc_packets; ++k) {
 			if (fifo->skbuff) {
@@ -666,7 +666,7 @@ tx_iso_complete(struct urb *urb)
 						/* add 2 byte flags and 16bit CRC at end of ISDN frame */
 						fifo->bit_line += 32;
 					}
-					frame_complete = TRUE;
+					frame_complete = true;
 				}
 
 				memcpy(context_iso_urb->buffer +
@@ -693,7 +693,7 @@ tx_iso_complete(struct urb *urb)
 			}
 
 			if (frame_complete) {
-				fifo->delete_flg = TRUE;
+				fifo->delete_flg = true;
 				fifo->hif->l1l2(fifo->hif,
 						PH_DATA | CONFIRM,
 						(void *) (unsigned long) fifo->skbuff->
@@ -701,9 +701,9 @@ tx_iso_complete(struct urb *urb)
 				if (fifo->skbuff && fifo->delete_flg) {
 					dev_kfree_skb_any(fifo->skbuff);
 					fifo->skbuff = NULL;
-					fifo->delete_flg = FALSE;
+					fifo->delete_flg = false;
 				}
-				frame_complete = FALSE;
+				frame_complete = false;
 			}
 		}
 		errcode = usb_submit_urb(urb, GFP_ATOMIC);
@@ -837,7 +837,7 @@ collect_rx_frame(usb_fifo * fifo, __u8 * data, int len, int finish)
 	fifon = fifo->fifonum;
 	transp_mode = 0;
 	if (fifon < 4 && hfc->b_mode[fifon / 2] == L1_MODE_TRANS)
-		transp_mode = TRUE;
+		transp_mode = true;
 
 	if (!fifo->skbuff) {
 		fifo->skbuff = dev_alloc_skb(fifo->max_size + 3);
@@ -1176,7 +1176,7 @@ hfc_usb_l2l1(struct hisax_if *my_hisax_if, int pr, void *arg)
 			if (fifo->skbuff && fifo->delete_flg) {
 				dev_kfree_skb_any(fifo->skbuff);
 				fifo->skbuff = NULL;
-				fifo->delete_flg = FALSE;
+				fifo->delete_flg = false;
 			}
 			fifo->skbuff = arg;	/* we have a new buffer */
 			break;
@@ -1262,8 +1262,8 @@ usb_init(hfcusb_data * hfc)
 	hfc->b_mode[0] = L1_MODE_NULL;
 	hfc->b_mode[1] = L1_MODE_NULL;
 
-	hfc->l1_activated = FALSE;
-	hfc->disc_flag = FALSE;
+	hfc->l1_activated = false;
+	hfc->disc_flag = false;
 	hfc->led_state = 0;
 	hfc->led_new_data = 0;
 	hfc->old_led_state = 0;
@@ -1404,7 +1404,7 @@ hfc_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 			/* check for config EOL element */
 			while (validconf[cfg_used][0]) {
-				cfg_found = TRUE;
+				cfg_found = true;
 				vcf = validconf[cfg_used];
 				/* first endpoint descriptor */
 				ep = iface->endpoint;
@@ -1426,7 +1426,7 @@ hfc_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 						idx++;
 					attr = ep->desc.bmAttributes;
 					if (cmptbl[idx] == EP_NUL) {
-						cfg_found = FALSE;
+						cfg_found = false;
 					}
 					if (attr == USB_ENDPOINT_XFER_INT
 					    && cmptbl[idx] == EP_INT)
@@ -1448,7 +1448,7 @@ hfc_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 							    "HFC-S USB: Interrupt Endpoint interval < %d found - skipping config",
 							    vcf[17]);
 #endif
-						cfg_found = FALSE;
+						cfg_found = false;
 					}
 					ep++;
 				}
@@ -1456,7 +1456,7 @@ hfc_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 					/* all entries must be EP_NOP or EP_NUL for a valid config */
 					if (cmptbl[i] != EP_NOP
 					    && cmptbl[i] != EP_NUL)
-						cfg_found = FALSE;
+						cfg_found = false;
 				}
 				if (cfg_found) {
 					if (cfg_used < small_match) {
@@ -1656,7 +1656,7 @@ hfc_usb_disconnect(struct usb_interface
 	hfcusb_data *context = usb_get_intfdata(intf);
 	int i;
 	printk(KERN_INFO "HFC-S USB: device disconnect\n");
-	context->disc_flag = TRUE;
+	context->disc_flag = true;
 	usb_set_intfdata(intf, NULL);
 	if (!context)
 		return;
diff --git a/drivers/isdn/hisax/hfc_usb.h b/drivers/isdn/hisax/hfc_usb.h
index 6349367..471f235 100644
--- a/drivers/isdn/hisax/hfc_usb.h
+++ b/drivers/isdn/hisax/hfc_usb.h
@@ -12,9 +12,6 @@
 
 #define VERBOSE_USB_DEBUG
 
-#define TRUE  1
-#define FALSE 0
-
 
 /***********/
 /* defines */

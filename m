Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbZEHUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbZEHUHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZEHUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:07:23 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:39234 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbZEHUHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:07:21 -0400
Subject: [PATCH] staging/wlan-ng: Change KERN_DEBUG or pr_debug to match
 orig driver
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 08 May 2009 20:54:17 +0100
Message-Id: <1241812457.6459.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=SEH5nWxc8bYA:10 a=P8Lfa8IvCKcA:10 a=NLZqzBF-AAAA:8 a=hMrpyb_uAAAA:8 a=sE4peG7Z8CVV995RbmwA:9 a=8XQht2GE-W5jh0VydQcA:7 a=BXOLbTGFXlXovvoRNpiXxMDJN4oA:4 a=_dQi-Dcv4p4A:10 a=iZulf2v5xPZ5TH6b:21 a=D9eE7xqOJzhaUFb6:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change uses of KERN_DEBUG over to pr_debug to match original driver
where messages are only needed during driver development.

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>

--- c/drivers/staging/wlan-ng/hfa384x_usb.c	2009-05-07 20:02:48.000000000 +0100
+++ d/drivers/staging/wlan-ng/hfa384x_usb.c	2009-05-08 19:05:56.000000000 +0100
@@ -1174,7 +1174,7 @@ int hfa384x_cmd_download(hfa384x_t *hw, 
 	int result = 0;
 	hfa384x_metacmd_t cmd;
 
-	printk(KERN_DEBUG
+	pr_debug(
 	       "mode=%d, lowaddr=0x%04x, highaddr=0x%04x, codelen=%d\n",
 	       mode, lowaddr, highaddr, codelen);
 
@@ -1651,7 +1651,7 @@ hfa384x_dormem(hfa384x_t *hw,
 
 	ctlx->outbufsize = sizeof(ctlx->outbuf.rmemreq);
 
-	printk(KERN_DEBUG
+	pr_debug(
 	       "type=0x%04x frmlen=%d offset=0x%04x page=0x%04x\n",
 	       ctlx->outbuf.rmemreq.type,
 	       ctlx->outbuf.rmemreq.frmlen,
@@ -2035,7 +2035,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t
 	/* NOTE: dlbuffer RID stores the address in AUX format */
 	dlbufaddr =
 	    HFA384x_ADDR_AUX_MKFLAT(hw->bufinfo.page, hw->bufinfo.offset);
-	printk(KERN_DEBUG
+	pr_debug(
 	       "dlbuf.page=0x%04x dlbuf.offset=0x%04x dlbufaddr=0x%08x\n",
 	       hw->bufinfo.page, hw->bufinfo.offset, dlbufaddr);
 
@@ -2323,7 +2323,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t 
 		/* Set the download state */
 		hw->dlstate = HFA384x_DLSTATE_RAMENABLED;
 	} else {
-		printk(KERN_DEBUG
+		pr_debug(
 		       "cmd_download(0x%04x, 0x%04x) failed, result=%d.\n",
 		       lowaddr, hiaddr, result);
 	}
@@ -2629,10 +2629,10 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "First cmd_initialize() failed (result %d),\n",
 			       result1);
-			printk(KERN_DEBUG
+			pr_debug(
 			       "but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
@@ -3301,7 +3301,7 @@ static void hfa384x_usbin_callback(struc
 		break;
 
 	default:
-		printk(KERN_DEBUG
+		pr_debug(
 		       "Unrecognized USBIN packet, type=%x, status=%d\n",
 		       usbin->type, urb_status);
 		break;
@@ -3399,7 +3399,7 @@ retry:
 			 * our request has been acknowledged. Odd,
 			 * but our OUT URB is still alive...
 			 */
-			printk(KERN_DEBUG
+			pr_debug(
 			       "Causality violation: please reboot Universe, or email linux-wlan-devel@lists.linux-wlan.com\n");
 			ctlx->state = CTLX_RESP_COMPLETE;
 			break;
@@ -3552,7 +3552,7 @@ static void hfa384x_usbin_rx(wlandevice_
 			hfa384x_int_rxmonitor(wlandev, &usbin->rxfrm);
 			dev_kfree_skb(skb);
 		} else {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "Received monitor frame: FCSerr set\n");
 		}
 		break;
@@ -4171,13 +4171,13 @@ static int hfa384x_isgood_pdrcode(u16 pd
 	default:
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
-			printk(KERN_DEBUG
+			pr_debug(
 			       "Encountered unknown PDR#=0x%04x, "
 			       "assuming it's ok.\n", pdrcode);
 			return 1;
 		} else {
 			/* bad code */
-			printk(KERN_DEBUG
+			pr_debug(
 			       "Encountered unknown PDR#=0x%04x, "
 			       "(>=0x1000), assuming it's bad.\n", pdrcode);
 			return 0;
--- c/drivers/staging/wlan-ng/p80211conv.c	2009-04-30 05:48:16.000000000 +0100
+++ d/drivers/staging/wlan-ng/p80211conv.c	2009-05-08 19:06:57.000000000 +0100
@@ -329,7 +329,7 @@ int skb_p80211_to_ether(wlandevice_t *wl
 				       skb->data + payload_offset +
 				       payload_length - 4))) {
 			/* de-wep failed, drop skb. */
-			printk(KERN_DEBUG
+			pr_debug(
 			       "Host de-WEP failed, dropping frame (%d).\n",
 			       foo);
 			wlandev->rx.decrypt_err++;
--- c/drivers/staging/wlan-ng/p80211wext.c	2009-04-30 05:48:16.000000000 +0100
+++ d/drivers/staging/wlan-ng/p80211wext.c	2009-05-08 19:09:50.000000000 +0100
@@ -1561,7 +1561,7 @@ static int p80211wext_get_encodeext(stru
 
 	if (idx) {
 		if (idx < 1 || idx > NUM_WEPKEYS) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "get_encode_ext invalid key index [%d]\n", idx);
 			result = -EINVAL;
 			goto exit;
--- c/drivers/staging/wlan-ng/prism2mgmt.c	2009-04-30 05:48:16.000000000 +0100
+++ d/drivers/staging/wlan-ng/prism2mgmt.c	2009-05-08 19:11:11.000000000 +0100
@@ -1096,7 +1096,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 		/* Disable monitor mode */
 		result = hfa384x_cmd_monitor(hw, HFA384x_MONITOR_DISABLE);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to disable monitor mode, result=%d\n",
 			       result);
 			goto failed;
@@ -1104,7 +1104,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 		/* Disable port 0 */
 		result = hfa384x_drvr_disable(hw, 0);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to disable port 0 after sniffing, result=%d\n",
 			       result);
 			goto failed;
@@ -1117,7 +1117,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 						  HFA384x_RID_CNFWEPFLAGS,
 						  hw->presniff_wepflags);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to restore wepflags=0x%04x, result=%d\n",
 			       hw->presniff_wepflags, result);
 			goto failed;
@@ -1130,7 +1130,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 							  HFA384x_RID_CNFPORTTYPE,
 							  word);
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "failed to restore porttype, result=%d\n",
 				       result);
 				goto failed;
@@ -1139,7 +1139,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 			/* Enable the port */
 			result = hfa384x_drvr_enable(hw, 0);
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "failed to enable port to presniff setting, result=%d\n",
 				       result);
 				goto failed;
@@ -1164,7 +1164,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 								  &(hw->
 								    presniff_port_type));
 				if (result) {
-					printk(KERN_DEBUG
+					pr_debug(
 					       "failed to read porttype, result=%d\n",
 					       result);
 					goto failed;
@@ -1175,7 +1175,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 								  &(hw->
 								    presniff_wepflags));
 				if (result) {
-					printk(KERN_DEBUG
+					pr_debug(
 					       "failed to read wepflags, result=%d\n",
 					       result);
 					goto failed;
@@ -1183,7 +1183,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 				hfa384x_drvr_stop(hw);
 				result = hfa384x_drvr_start(hw);
 				if (result) {
-					printk(KERN_DEBUG
+					pr_debug(
 					       "failed to restart the card for sniffing, result=%d\n",
 					       result);
 					goto failed;
@@ -1192,7 +1192,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 				/* Disable the port */
 				result = hfa384x_drvr_disable(hw, 0);
 				if (result) {
-					printk(KERN_DEBUG
+					pr_debug(
 					       "failed to enable port for sniffing, result=%d\n",
 					       result);
 					goto failed;
@@ -1210,7 +1210,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 		hw->sniff_channel = word;
 
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to set channel %d, result=%d\n",
 			       word, result);
 			goto failed;
@@ -1224,7 +1224,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 							  HFA384x_RID_CNFPORTTYPE,
 							  word);
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "failed to set porttype %d, result=%d\n",
 				       word, result);
 				goto failed;
@@ -1243,7 +1243,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 			}
 
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "failed to set wepflags=0x%04x, result=%d\n",
 				       word, result);
 				goto failed;
@@ -1269,7 +1269,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 		/* Enable the port */
 		result = hfa384x_drvr_enable(hw, 0);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to enable port for sniffing, result=%d\n",
 			       result);
 			goto failed;
@@ -1277,7 +1277,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
 		/* Enable monitor mode */
 		result = hfa384x_cmd_monitor(hw, HFA384x_MONITOR_ENABLE);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "failed to enable monitor mode, result=%d\n",
 			       result);
 			goto failed;
--- c/drivers/staging/wlan-ng/prism2sta.c	2009-04-30 05:48:16.000000000 +0100
+++ d/drivers/staging/wlan-ng/prism2sta.c	2009-05-08 19:15:08.000000000 +0100
@@ -1188,7 +1188,7 @@ static void prism2sta_inf_chinforesults(
 			chinforesult->active =
 			    le16_to_cpu(inf->info.chinforesult.result[n].
 					    active);
-			printk(KERN_DEBUG
+			pr_debug(
 			       "chinfo: channel %d, %s level (avg/peak)=%d/%d dB, pcf %d\n",
 			       channel + 1,
 			       chinforesult->
@@ -1276,7 +1276,7 @@ void prism2sta_processing_defer(struct w
 							wlandev->bssid,
 							WLAN_BSSID_LEN);
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "getconfig(0x%02x) failed, result = %d\n",
 				       HFA384x_RID_CURRENTBSSID, result);
 				goto failed;
@@ -1286,7 +1286,7 @@ void prism2sta_processing_defer(struct w
 							HFA384x_RID_CURRENTSSID,
 							&ssid, sizeof(ssid));
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "getconfig(0x%02x) failed, result = %d\n",
 				       HFA384x_RID_CURRENTSSID, result);
 				goto failed;
@@ -1300,7 +1300,7 @@ void prism2sta_processing_defer(struct w
 							  HFA384x_RID_PORTSTATUS,
 							  &portstatus);
 			if (result) {
-				printk(KERN_DEBUG
+				pr_debug(
 				       "getconfig(0x%02x) failed, result = %d\n",
 				       HFA384x_RID_PORTSTATUS, result);
 				goto failed;
@@ -1366,7 +1366,7 @@ void prism2sta_processing_defer(struct w
 						HFA384x_RID_CURRENTBSSID,
 						wlandev->bssid, WLAN_BSSID_LEN);
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "getconfig(0x%02x) failed, result = %d\n",
 			       HFA384x_RID_CURRENTBSSID, result);
 			goto failed;
@@ -1376,7 +1376,7 @@ void prism2sta_processing_defer(struct w
 						HFA384x_RID_CURRENTSSID,
 						&ssid, sizeof(ssid));
 		if (result) {
-			printk(KERN_DEBUG
+			pr_debug(
 			       "getconfig(0x%02x) failed, result = %d\n",
 			       HFA384x_RID_CURRENTSSID, result);
 			goto failed;
@@ -2030,7 +2030,7 @@ void prism2sta_commsqual_defer(struct wo
 					HFA384x_RID_CURRENTBSSID,
 					wlandev->bssid, WLAN_BSSID_LEN);
 	if (result) {
-		printk(KERN_DEBUG
+		pr_debug(
 		       "getconfig(0x%02x) failed, result = %d\n",
 		       HFA384x_RID_CURRENTBSSID, result);
 		goto done;
@@ -2040,7 +2040,7 @@ void prism2sta_commsqual_defer(struct wo
 					HFA384x_RID_CURRENTSSID,
 					&ssid, sizeof(ssid));
 	if (result) {
-		printk(KERN_DEBUG
+		pr_debug(
 		       "getconfig(0x%02x) failed, result = %d\n",
 		       HFA384x_RID_CURRENTSSID, result);
 		goto done;



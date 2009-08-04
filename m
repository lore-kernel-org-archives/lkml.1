Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbZHDO3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbZHDO3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZHDO3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:29:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:57764 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbZHDO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:29:12 -0400
Message-Id: <20090804142710.264995723@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 04 Aug 2009 10:26:22 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Greg KH <gregkh@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 4/5] rtl8192su: stop using skb->tail
References: <20090804142618.455591385@suse.com>
Content-Disposition: inline; filename=patches.rpmify/rtl8192su-skb-fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch replaces uses of skb->tail with skb_tail_pointer(skb).

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/staging/rtl8192su/r8192U_core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -1715,7 +1708,7 @@ static int rtl8192_rx_initiate(struct ne
                 }
 //		printk("nomal packet IN request!\n");
                 usb_fill_bulk_urb(entry, priv->udev,
-                                  usb_rcvbulkpipe(priv->udev, 3), skb->tail,
+                                  usb_rcvbulkpipe(priv->udev, 3), skb_tail_pointer(skb),
                                   RX_URB_SIZE, rtl8192_rx_isr, skb);
                 info = (struct rtl8192_rx_info *) skb->cb;
                 info->urb = entry;
@@ -1745,7 +1738,7 @@ static int rtl8192_rx_initiate(struct ne
                         break;
                 }
                 usb_fill_bulk_urb(entry, priv->udev,
-                                  usb_rcvbulkpipe(priv->udev, 9), skb->tail,
+                                  usb_rcvbulkpipe(priv->udev, 9), skb_tail_pointer(skb),
                                   RX_URB_SIZE, rtl8192_rx_isr, skb);
                 info = (struct rtl8192_rx_info *) skb->cb;
                 info->urb = entry;
@@ -2135,7 +2128,8 @@ static void rtl8192_rx_isr(struct urb *u
         }
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			usb_rcvbulkpipe(priv->udev, out_pipe), skb->tail,
+			usb_rcvbulkpipe(priv->udev, out_pipe),
+			skb_tail_pointer(skb),
 			RX_URB_SIZE, rtl8192_rx_isr, skb);
 
         info = (struct rtl8192_rx_info *) skb->cb;
@@ -2143,7 +2137,7 @@ static void rtl8192_rx_isr(struct urb *u
         info->dev = dev;
 	info->out_pipe = out_pipe;
 
-        urb->transfer_buffer = skb->tail;
+        urb->transfer_buffer = skb_tail_pointer(skb);
         urb->context = skb;
         skb_queue_tail(&priv->rx_queue, skb);
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
@@ -2356,8 +2350,8 @@ struct sk_buff *DrvAggr_Aggregation(stru
 		/* Subframe drv Tx descriptor and firmware info setting */
 		skb = pSendList->tx_agg_frames[i];
 		tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-		tx_agg_desc = (tx_desc_819x_usb_aggr_subframe *)agg_skb->tail;
-		tx_fwinfo = (tx_fwinfo_819x_usb *)(agg_skb->tail + sizeof(tx_desc_819x_usb_aggr_subframe));
+		tx_agg_desc = (tx_desc_819x_usb_aggr_subframe *)agg_skb_tail_pointer(skb);
+		tx_fwinfo = (tx_fwinfo_819x_usb *)(agg_skb_tail_pointer(skb) + sizeof(tx_desc_819x_usb_aggr_subframe));
 
 		memset(tx_fwinfo,0,sizeof(tx_fwinfo_819x_usb));
 		/* DWORD 0 */



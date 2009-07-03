Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZGCOAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZGCOAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbZGCN7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:59:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688AbZGCN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bLozVPZgkJJqERsKQ7w1dqx+deyCq7gM0vYx06pPKlr0ENyGi0sGUMEU+i6jhuScBL
         /L51JbPXUkWRx9WA4SogG39XYDk8QOLKxzhtqfOroBZK03etRwI783I3NaK7g9hOrfWh
         x2FhzkDQUZ6QUFRzqyezHUCQ5j7H4chlw96mc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:06:27 +0200
Message-Id: <20090703140627.7303.87368.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/22] Staging: rtl8192su: remove USE_ONE_PIPE ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove USE_ONE_PIPE ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U.h      |   13 -------------
 drivers/staging/rtl8192su/r8192U_core.c |   15 ---------------
 3 files changed, 29 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -6,7 +6,6 @@ EXTRA_CFLAGS += -mhard-float -DCONFIG_FO
 
 EXTRA_CFLAGS += -DJACKSON_NEW_RX
 EXTRA_CFLAGS += -DTHOMAS_BEACON
-#EXTRA_CFLAGS += -DUSE_ONE_PIPE
 
 EXTRA_CFLAGS += -DRTL8192SU
 EXTRA_CFLAGS += -DRTL8190_Download_Firmware_From_Header=1
Index: b/drivers/staging/rtl8192su/r8192U.h
===================================================================
--- a/drivers/staging/rtl8192su/r8192U.h
+++ b/drivers/staging/rtl8192su/r8192U.h
@@ -1085,18 +1085,6 @@ typedef struct _rt_firmware_info_819xUsb
 #define NUM_OF_FIRMWARE_QUEUE		10
 #define NUM_OF_PAGES_IN_FW		0x100
 
-#ifdef USE_ONE_PIPE
-#define NUM_OF_PAGE_IN_FW_QUEUE_BE	0x000
-#define NUM_OF_PAGE_IN_FW_QUEUE_BK	0x000
-#define NUM_OF_PAGE_IN_FW_QUEUE_VI	0x0ff
-#define NUM_OF_PAGE_IN_FW_QUEUE_VO	0x000
-#define NUM_OF_PAGE_IN_FW_QUEUE_HCCA	0
-#define NUM_OF_PAGE_IN_FW_QUEUE_CMD	0x0
-#define NUM_OF_PAGE_IN_FW_QUEUE_MGNT	0x00
-#define NUM_OF_PAGE_IN_FW_QUEUE_HIGH	0
-#define NUM_OF_PAGE_IN_FW_QUEUE_BCN	0x0
-#define NUM_OF_PAGE_IN_FW_QUEUE_PUB	0x00
-#else
 
 #define NUM_OF_PAGE_IN_FW_QUEUE_BE	0x020
 #define NUM_OF_PAGE_IN_FW_QUEUE_BK	0x020
@@ -1109,7 +1097,6 @@ typedef struct _rt_firmware_info_819xUsb
 #define NUM_OF_PAGE_IN_FW_QUEUE_BCN	0x4
 #define NUM_OF_PAGE_IN_FW_QUEUE_PUB	0x18
 
-#endif
 
 #define APPLIED_RESERVED_QUEUE_IN_FW	0x80000000
 #define RSVD_FW_QUEUE_PAGE_BK_SHIFT	0x00
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2985,11 +2985,7 @@ short rtl819xU_tx_cmd(struct net_device 
 	// Fill up USB_OUT_CONTEXT.
 	//----------------------------------------------------------------------------
 	// Get index to out pipe from specified QueueID.
-#ifndef USE_ONE_PIPE
 	idx_pipe = txqueue2outpipe(priv,queue_index);
-#else
-	idx_pipe = 0x04;
-#endif
 #ifdef JOHN_DUMP_TXDESC
 	int i;
 	printk("<Tx descriptor>--rate %x---",rate);
@@ -3786,11 +3782,7 @@ short rtl8192_tx(struct net_device *dev,
 		tx_desc->TxBufferSize = (u32)(skb->len - USB_HWDESC_HEADER_LEN);
 	}
 	/* Get index to out pipe from specified QueueID */
-#ifndef USE_ONE_PIPE
 	idx_pipe = txqueue2outpipe(priv,tcb_desc->queue_index);
-#else
-	idx_pipe = 0x5;
-#endif
 
 	//RT_DEBUG_DATA(COMP_SEND,tx_fwinfo,sizeof(tx_fwinfo_819x_usb));
 	//RT_DEBUG_DATA(COMP_SEND,tx_desc,sizeof(tx_desc_819x_usb));
@@ -11721,7 +11713,6 @@ static void HalUsbSetQueuePipeMapping819
 	memset(priv->RtOutPipes,0,16);
 	memset(priv->RtInPipes,0,16);
 
-#ifndef USE_ONE_PIPE
 	iface_desc = intf->cur_altsetting;
 	priv->ep_num = iface_desc->desc.bNumEndpoints;
 
@@ -11776,12 +11767,6 @@ static void HalUsbSetQueuePipeMapping819
 	for(i=0; i < 9; i++)
 		printk("%d  ", priv->txqueue_to_outpipemap[i]);
 	printk("\n");
-#else
-	{
-		memset(priv->txqueue_to_outpipemap,0,9);
-		memset(priv->RtOutPipes,4,16);//all use endpoint 4 for out
-	}
-#endif
 
 	return;
 }

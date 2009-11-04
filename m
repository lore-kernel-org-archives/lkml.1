Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbZKDRgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbZKDRgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbZKDRgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:40568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbZKDRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gZDfRVpgxqsMoSi/55Fw1J26rf73qX7SGpoDRViFcDXeYLxEWvdhho+gQMgrLCXEst
         HJv1i9GZCs+zc5BIf0OHVyVRoaSbhyKArIcQyP0ynQtIgCLOeBdwEUGEySI3b2+Iq7oU
         HJ7/Ko4u0OLYa8PWT9VytKx+kAxQgQxpI8OeM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:47 +0100
Message-Id: <20091104173547.28463.36376.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 31/41] rt2800usb: add RXINFO_DESC_SIZE definition
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add RXINFO_DESC_SIZE definition

Add RXINFO_DESC_SIZE definition and use it instead of abusing
RXD_DESC_SIZE one (TXD_DESC_SIZE and RXD_DESC_SIZE are specific
to PCI version of the chipset).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2800usb.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2152,7 +2152,7 @@ static void rt2800usb_fill_rxdone(struct
 	 */
 	memcpy(skbdesc->desc, rxd, skbdesc->desc_len);
 	rxd = (__le32 *)skbdesc->desc;
-	rxwi = &rxd[RXD_DESC_SIZE / sizeof(__le32)];
+	rxwi = &rxd[RXINFO_DESC_SIZE / sizeof(__le32)];
 
 	/*
 	 * It is now safe to read the descriptor on all architectures.
@@ -2874,7 +2874,7 @@ static const struct rt2x00lib_ops rt2800
 static const struct data_queue_desc rt2800usb_queue_rx = {
 	.entry_num		= RX_ENTRIES,
 	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXD_DESC_SIZE + RXWI_DESC_SIZE,
+	.desc_size		= RXINFO_DESC_SIZE + RXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -1747,7 +1747,8 @@ struct mac_iveiv_entry {
 #define TXD_DESC_SIZE			( 4 * sizeof(__le32) )
 #define TXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
 #define TXWI_DESC_SIZE			( 4 * sizeof(__le32) )
-#define RXD_DESC_SIZE			( 1 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 4 * sizeof(__le32) )
+#define RXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
 #define RXWI_DESC_SIZE			( 4 * sizeof(__le32) )
 
 /*

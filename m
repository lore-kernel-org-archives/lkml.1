Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZGMSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZGMSIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZGMSHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:07:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbZGMSHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KuJNs3XyTUYDt8G4gXVP2Td3/BTjmytz3pb21jN5fHVOl1Pdy9XBEoZrY8p41F7gee
         LxrYgiAVK42K1a6VypEs4IZdFmmt9qOIj3+Tx1usp4Bn6KCUL6r/FRV9pWwsfB7f36k/
         7Uxqd7xeMEHpt6WuPPmd5K4vWF/cZldh++Kz8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:13:55 +0200
Message-Id: <20090713181355.16765.15642.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
References: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/10] Staging: rtl8192su: remove JOHN_DUMP[_TXDESC] ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8192su: remove JOHN_DUMP[_TXDESC] ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/TODO                             |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c |   12 ------------
 drivers/staging/rtl8192su/r8192U_core.c                    |    8 --------
 3 files changed, 21 deletions(-)

Index: b/drivers/staging/rtl8192su/TODO
===================================================================
--- a/drivers/staging/rtl8192su/TODO
+++ b/drivers/staging/rtl8192su/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8187se's version:
-  - remove JOHN_DUMP[_DESC] ifdefs
   - remove [IN]_OPENSUSE_SLED definitions
   - remove superflous container_of definition from ieee80211.h
   - remove rtl8192su's specific dead code
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
@@ -502,18 +502,6 @@ static int ieee80211_tkip_decrypt(struct
 	skb_pull(skb, 8);
 	skb_trim(skb, skb->len - 4);
 
-//john's test
-#ifdef JOHN_DUMP
-if( ((u16*)skb->data)[0] & 0x4000){
-        printk("@@ rx decrypted skb->data");
-        int i;
-        for(i=0;i<skb->len;i++){
-                if( (i%24)==0 ) printk("\n");
-                printk("%2x ", ((u8*)skb->data)[i]);
-        }
-        printk("\n");
-}
-#endif /*JOHN_DUMP*/
 	return keyidx;
 }
 
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -1967,14 +1967,6 @@ short rtl8192SU_tx_cmd(struct net_device
 	idx_pipe = txqueue2outpipe(priv,queue_index);
 	//printk("=============>%s queue_index:%d, outpipe:%d\n", __func__,queue_index,priv->RtOutPipes[idx_pipe]);
 
-#ifdef JOHN_DUMP_TXDESC
-	int i;
-	printk("Len = %d\n", skb->len);
-	for (i = 0; i < 8; i++)
-		printk("%2.2x ", *((u8*)skb->data+i));
-	printk("\n");
-#endif
-
 	usb_fill_bulk_urb(tx_urb,
 	                            priv->udev,
 	                            usb_sndbulkpipe(priv->udev,priv->RtOutPipes[idx_pipe]),

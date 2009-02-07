Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZBGBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZBGBVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBGBV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:21:27 -0500
Received: from kroah.org ([198.145.64.141]:60354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752093AbZBGBV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:21:26 -0500
Subject: patch staging-usbip-kmem_cache_alloc-memset-kmem_cache_zalloc.patch added to gregkh-2.6 tree
To: yjwei@cn.fujitsu.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 06 Feb 2009 17:11:19 -0800
In-Reply-To: <498BA9CA.7060700@cn.fujitsu.com>
Message-ID: <12339690792200@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: usbip: kmem_cache_alloc/memset -> kmem_cache_zalloc

to my gregkh-2.6 tree.  Its filename is

    staging-usbip-kmem_cache_alloc-memset-kmem_cache_zalloc.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From yjwei@cn.fujitsu.com  Fri Feb  6 15:53:31 2009
From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 11:08:58 +0800
Subject: Staging: usbip: kmem_cache_alloc/memset -> kmem_cache_zalloc
To: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <498BA9CA.7060700@cn.fujitsu.com>


Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/stub_rx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -334,7 +334,7 @@ static struct stub_priv *stub_priv_alloc
 
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
-	priv = kmem_cache_alloc(stub_priv_cache, GFP_ATOMIC);
+	priv = kmem_cache_zalloc(stub_priv_cache, GFP_ATOMIC);
 	if (!priv) {
 		dev_err(&sdev->interface->dev, "alloc stub_priv\n");
 		spin_unlock_irqrestore(&sdev->priv_lock, flags);
@@ -342,8 +342,6 @@ static struct stub_priv *stub_priv_alloc
 		return NULL;
 	}
 
-	memset(priv, 0, sizeof(struct stub_priv));
-
 	priv->seqnum = pdu->base.seqnum;
 	priv->sdev = sdev;
 


Patches currently in gregkh-2.6 which might be from yjwei@cn.fujitsu.com are

staging/staging-usbip-kmem_cache_alloc-memset-kmem_cache_zalloc.patch

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbZLKBvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbZLKBvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762211AbZLKBvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:51:33 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:35664 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762202AbZLKBvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:51:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fsldma.c: use resource_size()
Date: Thu, 10 Dec 2009 20:51:37 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB0FCE@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma.c: use resource_size()
Thread-Index: Acp6BHmN7hw8QPMGTFG3NqBN+X+JlQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <zw@zh-kernel.org>, <leoli@freescale.com>
X-OriginalArrivalTime: 11 Dec 2009 01:51:38.0186 (UTC) FILETIME=[7A2F52A0:01CA7A04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Zhang Wei <zw@zh-kernel.org>
Cc: Li Yang <leoli@freescale.com>

---

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 296f9e7..ca20a9c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1095,7 +1095,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
 
 	new_fsl_chan->dev = fdev->dev;
 	new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
-			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
+					 resource_size(&new_fsl_chan->reg));
 
 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
 	if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
@@ -1196,8 +1196,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
 			"controller at 0x%llx...\n",
 			match->compatible, (unsigned long long)fdev->reg.start);
-	fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
-						- fdev->reg.start + 1);
+	fdev->reg_base = ioremap(fdev->reg.start, resource_size(&fdev->reg));
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask); 

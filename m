Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZESXRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZESXRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZESXRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:17:05 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37401 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZESXRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ELvrfv4XFE5Ck43ZotdIFiBlc+bFNrZrbAwSs84mY+63WD1oVaBa2AVfHZ4C7QfNzZ
         uVaD58lvPkSsDqqoYHN+xW6+Z9+JwBIKN8Fq0FhY21tRGUGoYraT506GH3htHi4u4WCD
         MS+o7d+JqhJLI0kWhmKWjIUtgzb/yKtpp9Yxk=
Message-ID: <4A133DEF.6080604@gmail.com>
Date: Wed, 20 May 2009 01:17:03 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: leoli@freescale.com
CC: linuxppc-embedded@ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] freescale: beyond ARRAY_SIZE of fdev->chan
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of fdev->chan

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index da8a8ed..391b1bd 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -830,7 +830,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
 
 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
-	if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
+	if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;

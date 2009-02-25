Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZBYMrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZBYMrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZBYMrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:47:11 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:59715 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZBYMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kKpT030ldMafqe6vHmBGefDMcIi9vx+1AXgmQ6vlUawuKQcHZoY5rmjiXQPpgssf2m
         SmUFxVNWQEoYwkvAbzF8PTldi/0XknlAJi3YAFj69Zdnve0UjyQzBdNuFi+2/35SD/gI
         hG7w18gB1rRER1OK0xVgfz6dttK9dw1fR8tx0=
Message-ID: <49A53DCA.4060004@gmail.com>
Date: Wed, 25 Feb 2009 13:47:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dan.j.williams@intel.com
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fsldma: dev_err 1 too early.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If unsuccessful, i reaches 101 after the loop, so 100 is still success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 70126a6..444c4e4 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -168,7 +168,7 @@ static void dma_halt(struct fsl_dma_chan *fsl_chan)
 
 	while (!dma_is_idle(fsl_chan) && (i++ < 100))
 		udelay(10);
-	if (i >= 100 && !dma_is_idle(fsl_chan))
+	if (i > 100 && !dma_is_idle(fsl_chan))
 		dev_err(fsl_chan->dev, "DMA halt timeout!\n");
 }
 

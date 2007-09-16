Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXIPVfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXIPVfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXIPVfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:35:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:56868 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbXIPVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WeU8jh3c/WxQsezvr9OJKT3SF3pqXLMs58e9jrK5uq2uOOFhQL3OlZJ2KfvnQtCHcZglgxP7Y7UmECXq+JWt2Xx03A7ASyRW3wwTFGJ29vNxZnCi7VvQ48P/3hbyb3HkqrhfcE+5GI5+IZPPIVmLbq1Cyza278kpquffTlYwA7s=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove an unused variable from the Intel I/OAT DMA engine driver
Date: Sun, 16 Sep 2007 23:31:50 +0200
User-Agent: KMail/1.9.7
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Chris Leech <christopher.leech@intel.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709162331.50784.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The 'u16 chanctrl' variable in 
drivers/dma/ioatdma.c::ioat_dma_free_chan_resources() is completely 
unused and gcc quite rightfully warns about it:

  drivers/dma/ioatdma.c:247: warning: unused variable 'chanctrl'

This patch removes the unused variable and silences the warning.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 ioatdma.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6/drivers/dma/ioatdma.c~	2007-09-16 23:24:20.000000000 +0200
+++ linux-2.6/drivers/dma/ioatdma.c	2007-09-16 23:24:20.000000000 +0200
@@ -244,7 +244,6 @@ static void ioat_dma_free_chan_resources
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_device *ioat_device = to_ioat_device(chan->device);
 	struct ioat_desc_sw *desc, *_desc;
-	u16 chanctrl;
 	int in_use_descs = 0;
 
 	ioat_dma_memcpy_cleanup(ioat_chan);



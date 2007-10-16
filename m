Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXJPXSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXJPXSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXJPXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:18:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:50812 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXJPXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=pjakwfnQ8uA8ZnyswtTjxm69y/hXkcIWl1qJ4mAwqKI2cBWkq9Ta4eepDvEDyoErYaQBVOl/gXa0yB17V2/snzplfwR/NUcA2z9aERkc2FKWNqJjGhdF1sf7dmNU/owy7PEvCsuczHkfnNz0nxpOEcRIrvQhMK7GwCG2Rx4ywlU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patch] libata build fix
Date: Wed, 17 Oct 2007 01:23:43 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20071015221329.GA8778@havoc.gtf.org>
In-Reply-To: <20071015221329.GA8778@havoc.gtf.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710170123.43244.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007, Jeff Garzik wrote:

> Jeff Garzik (1):
>       [libata] pata_cs5536: new API build fix

We probably need also this one for pata_cs5536:

[PATCH] pata_cs5536: MWDMA fix

* Fix out-of-bound array access for MWDMA modes.

* Bump driver version.

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5536.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_cs5536.c
===================================================================
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -40,7 +40,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.5"
+#define DRV_VERSION	"0.0.6"
 
 enum {
 	CFG			= 0,
@@ -214,7 +214,7 @@ static void cs5536_set_dmamode(struct at
 		cs5536_read(pdev, DTC, &dtc);
 
 		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode] << dshift;
+		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
 
 		cs5536_write(pdev, DTC, dtc);
 	}

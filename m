Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZKZQav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZKZQav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZKZQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:30:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:52387 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbZKZQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:30:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=ifUSlBRxJsfheFTu7BIJVzcaaEDDL3yWvnWSvQpoBL9IDm/MtPr8sX3OAC3IgW0TnR
         sWFoKuDqouyjtFpC2jIyWgThw84ucHzZllW3r/mv9iaMN4HUBpsW9D/huKZOZ25bW1DJ
         HPpl/63OBSDxJQeSfIrt5mS1qfKnirKl/aD04=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_it8213: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 17:28:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200911261728.36433.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MWDMA0 timings cannot be met with the PIIX based controller
programming interface.

This change should be safe as this is how we have been doing
things in IDE it8213 host driver for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Verified with the documentation (similar case as with pata_efar).

On top of patches from yesterday.

 drivers/ata/pata_it8213.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -227,7 +227,7 @@ static int it8213_init_one (struct pci_d
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA6,
 		.port_ops	= &it8213_ops,
 	};

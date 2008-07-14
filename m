Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYGMPNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYGMPNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYGMPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:13:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63536 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYGMPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:13:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QtCbbO2RDXAARLTu19li96sPDv4zr57t38Lz6Ney53dmvGmvcWV7ZJy7ekJsWYIn0M
         7zYAjtx4fFJJ1xVZSY30gtYa7+NjexAthiRg7TSVTsfJ96YMsRAKtmDKiupIejGuyZ67
         4Vn/4MG8zrJEDNYpxFxjkWbVkdAW/a304rw/g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Jul 2008 17:11:09 +0200
Message-Id: <20080714151109.3106.80300.sendpatchset@localhost.localdomain>
In-Reply-To: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
References: <20080714151055.3106.78013.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/5] it821x: remove DECLARE_ITE_DEV() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

* it821x_chipsets[] -> it821x_chipset.

* Fix it821x_chipset's name field (as it is used for IT8211/8212).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it821x.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -622,17 +622,12 @@ static const struct ide_port_ops it821x_
 	.cable_detect		= it821x_cable_detect,
 };
 
-#define DECLARE_ITE_DEV(name_str)			\
-	{						\
-		.name		= name_str,		\
-		.init_chipset	= init_chipset_it821x,	\
-		.init_hwif	= init_hwif_it821x,	\
-		.port_ops	= &it821x_port_ops,	\
-		.pio_mask	= ATA_PIO4,		\
-	}
-
-static const struct ide_port_info it821x_chipsets[] __devinitdata = {
-	/* 0 */ DECLARE_ITE_DEV("IT8212"),
+static const struct ide_port_info it821x_chipset __devinitdata = {
+	.name		= "IT821X",
+	.init_chipset	= init_chipset_it821x,
+	.init_hwif	= init_hwif_it821x,
+	.port_ops	= &it821x_port_ops,
+	.pio_mask	= ATA_PIO4,
 };
 
 /**
@@ -655,7 +650,7 @@ static int __devinit it821x_init_one(str
 		return -ENOMEM;
 	}
 
-	rc = ide_pci_init_one(dev, &it821x_chipsets[id->driver_data], itdevs);
+	rc = ide_pci_init_one(dev, &it821x_chipset, itdevs);
 	if (rc)
 		kfree(itdevs);
 

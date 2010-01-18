Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782Ab0ARRR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0ARRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668Ab0ARRRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:25 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63659 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0ARRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r1t2MW1WSjcshXb+sqDqUTWkmiEbarH+HLwjcSlMgs3Gtx6Z6aBr+9j4ugjvoMQmpQ
         bgwWtw/SdW4kh5iJ3Y01zptKFutKC8sSxkUMmaeF9/J3bpAwIzcdwN8Zsx9VrLwchKBf
         Q4hqI0vAqjuI//UprvJRzo7Hda+26rd9LvM5Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:16:03 +0100
Message-Id: <20100118171603.14623.7966.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 16/64] pata_efar: fix secondary port support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: fix secondary port support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -2,7 +2,7 @@
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
  *	(C) 2005 Red Hat
- *	(C) 2009 Bartlomiej Zolnierkiewicz
+ *	(C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -222,7 +222,7 @@ static int efar_init_one (struct pci_dev
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
+	const struct ata_port_info *ppi[] = { &info, &info };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,

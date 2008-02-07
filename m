Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYBGOag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYBGOag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYBGO3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:29:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:44771 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbYBGO3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eihDjbNQpf4ngG0KZfndgORhbu/sVyuc5Oyn9qU0kdxHWttyJd/aY6CL3lSNBBknfdUqY9VDZRzdIOF5F2TxNxCLtHceBUBNESkCBDsbLbp/zsx3QWWHK3In95wR+WssOeMoz8bY5SpXcGjmFij90AEzSwX/yCRALm/8OvZkvfw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] palm_bk3710: factor out cable detection
Date: Thu, 7 Feb 2008 15:42:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Anton Salnikov <asalnikov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071542.29628.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Factor out cable detection to palm_bk3710_cable_detect().

Cc: Anton Salnikov <asalnikov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -311,6 +311,12 @@ static void __devinit palm_bk3710_chipin
 	palm_bk3710_setpiomode(base, NULL, 0, 600, 0);
 	palm_bk3710_setpiomode(base, NULL, 1, 600, 0);
 }
+
+static u8 __devinit palm_bk3710_cable_detect(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA80;
+}
+
 static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 {
 	struct clk *clkp;
@@ -381,7 +387,7 @@ static int __devinit palm_bk3710_probe(s
 	hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
-	hwif->cbl = ATA_CBL_PATA80;
+	hwif->cbl = palm_bk3710_cable_detect(hwif);
 	hwif->ultra_mask = 0x1f;	/* Ultra DMA Mode 4 Max
 						(input clk 99MHz) */
 	hwif->mwdma_mask = 0x7;

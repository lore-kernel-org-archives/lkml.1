Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYBTAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYBTAgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbYBTAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:36:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:37109 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYBTAg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=b8mSH49PMAkOyOyiCDC88MamDiE+dug6LOgwtTrnDMeuD893hMu8sFd3+W9rsszyyzj6qZ7nPS81wX8xuXcoXmr2vvCzv0iZpmyoqzwMeqhHCyPFiXF5ZrU9td25b6EwVla5eghIu+l1JIjg603F/BHD4ZPdrg2bQ1j6ipFF19Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide_platform: fix resources handling
Date: Wed, 20 Feb 2008 01:45:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802200145.36275.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell IDE layer to not manage resources by always setting hwif->mmio flag
(resources are handled by a platform device).

Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide_platform.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -100,11 +100,10 @@ static int __devinit plat_ide_probe(stru
 	hw.dev = &pdev->dev;
 
 	ide_init_port_hw(hwif, &hw);
+	hwif->mmio = 1;
 
-	if (mmio) {
-		hwif->mmio = 1;
+	if (mmio)
 		default_hwif_mmiops(hwif);
-	}
 
 	idx[0] = hwif->index;
 

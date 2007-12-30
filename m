Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXL3RdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXL3RdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXL3Rbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:31:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:8159 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbXL3Rbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=txVJ/geMvQ/6NUlU2Vsvr2KZJy/fk1w5QZ5rZ8C5ql/YbGCj72sk9xShyjWv84mvOcMN3mklt4dcKiSSjaEtM/eK1nBlCWJuOoqaQpnPe4It/JHaO3eq/J367l4KWrnkWLzXrWMVj2bJdL3Tzu60H/TZcBy2aqh3/HOatl1o528=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] au1xxx-ide/rapide: use hwif->index for ide_unregister()
Date: Sun, 30 Dec 2007 18:25:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301825.30370.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c      |    4 ++--
 drivers/ide/mips/au1xxx-ide.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -78,8 +78,8 @@ static void __devexit rapide_remove(stru
 
 	ecard_set_drvdata(ec, NULL);
 
-	/* there must be a better way */
-	ide_unregister(hwif - ide_hwifs);
+	ide_unregister(hwif->index);
+
 	ecard_release_resources(ec);
 }
 
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -691,7 +691,7 @@ static int au_ide_remove(struct device *
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif - ide_hwifs);
+	ide_unregister(hwif->index);
 
 	iounmap((void *)ahwif->regbase);
 

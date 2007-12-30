Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbXL3Rct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbXL3Rct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXL3Rbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:31:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:8170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXL3Rbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Qzltw+7aFUo3AJmKS5LKzNzbStnnp5hSb1TnzcUKpT5F0zLkiwoncA4HuQWx1cB2cvYGA2UgcWZHqZqg9P2QpEtZwqnVq5MURkDifaLoxAeXjO+zmM1IQ3BCax6BCi+wE2wR4Dnajigf86iLjHOoecuOX4aYxDyjHN4FbfAlPxk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide-pmac: macio resource freeing bugfix
Date: Sun, 30 Dec 2007 18:24:50 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301824.51003.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Release DMA resource before zeroing pmif.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1228,12 +1228,12 @@ pmac_ide_macio_attach(struct macio_dev *
 		/* The inteface is released to the common IDE layer */
 		dev_set_drvdata(&mdev->ofdev.dev, NULL);
 		iounmap(base);
-		if (pmif->dma_regs)
+		if (pmif->dma_regs) {
 			iounmap(pmif->dma_regs);
+			macio_release_resource(mdev, 1);
+		}
 		memset(pmif, 0, sizeof(*pmif));
 		macio_release_resource(mdev, 0);
-		if (pmif->dma_regs)
-			macio_release_resource(mdev, 1);
 	}
 
 	return rc;

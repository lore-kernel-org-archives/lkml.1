Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZHITyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZHITyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZHITyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZHITyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JvC+whNlF0CvnITGM8ud8i6f6//zH+A3rE1y9fTh3tUDqdIm87pelTBMFm6hEMygDL
         a6eVJ9obiRJOmPYNKkLaKzbHIosI3he2YuD8Rbx6Xn+vqR2edgGDH6aemS7/Cnee27GM
         Cif05TtZhwYTiVMm/Ya8CY/v7+xfqYcu+kvtM=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH 06/14] ata: use printk_once
Date: Sun,  9 Aug 2009 21:54:01 +0200
Message-Id: <1249847649-11631-7-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/pata_rz1000.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 0c574c0..a5e4dfe 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -85,7 +85,6 @@ static int rz1000_fifo_disable(struct pci_dev *pdev)
 
 static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int printed_version;
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
@@ -93,8 +92,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	if (!printed_version++)
-		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
+	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	if (rz1000_fifo_disable(pdev) == 0)
 		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL);
-- 
1.6.3.3


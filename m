Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbZHWSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbZHWSXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933514AbZHWSXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 14:23:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51011 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbZHWSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 14:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=W489vAiNkQDD0E+u0IKidjaRXx8pmj+RKB2KQYpnc/UZ92aHFPh7o67uOLWlvvAq4w
         nwRzA09gQhxjshgm2Q3JapHF6x8IaeUhHTKeGwFTZEq6oVovIRA+Y+BqysVdEWA1jAXj
         Jd1ZQDl5WCJ3N5qMcg6hGPVdjcEbIL5kmkbCw=
Message-ID: <4A918926.8020801@gmail.com>
Date: Sun, 23 Aug 2009 20:23:34 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] ata: use printk_once
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
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

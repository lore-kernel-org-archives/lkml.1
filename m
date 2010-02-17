Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab0BQNlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:41:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38180 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933267Ab0BQNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:41:41 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] pata_atiixp: enable parallel scan
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:17:44 +0000
Message-ID: <20100217131736.16884.55479.stgit@localhost.localdomain>
In-Reply-To: <20100217131532.16884.21696.stgit@localhost.localdomain>
References: <20100217131532.16884.21696.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was originally proposed by Bartlomiej but as a device specific
expansion of the init_one function rather than making the helper more
generic.

Enable the parallel scan via the generic flags.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_atiixp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 7143cb0..017e6e1 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -247,7 +247,8 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
 			ppi[i] = &ata_dummy_port_info;
 
-	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL, 0);
+	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL,
+						ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id atiixp[] = {


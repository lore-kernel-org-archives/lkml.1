Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZJFPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZJFPS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbZJFPS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:18:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35844 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756443AbZJFPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:18:28 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] pata_sc1200: Fix crash on boot
To: jeff@garzik.org, linux-kernel@vger.kernel.org
Date: Tue, 06 Oct 2009 16:07:51 +0100
Message-ID: <20091006150737.9610.81541.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SC1200 needs a NULL terminator or it may cause a crash on boot.

Bug #14227

Also correct a bogus comment as the driver had serializing added so can run
dual port.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_sc1200.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index f49814d..3bbed83 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
-	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }


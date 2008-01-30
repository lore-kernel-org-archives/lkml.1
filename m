Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYA3UBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYA3UBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYA3UBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:30 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51700 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYA3UB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:28 -0500
Date: Wed, 30 Jan 2008 22:02:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ata_piix.c:piix_init_one() must be __devinit
Message-ID: <20080130200202.GH29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: drivers/ata/built-in.o(.text+0x15072): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_sata_map()
WARNING: drivers/ata/built-in.o(.text+0x150dd): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_pcs()
WARNING: drivers/ata/built-in.o(.text+0x150e5): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_init_sidpr()
WARNING: drivers/ata/built-in.o(.text+0x15107): Section mismatch in reference from the function piix_init_one() to the function .devinit.text:piix_check_450nx_errata()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
222e97f95d38ce7cb41980671cc4383df28b5f7a 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a65c8ae..7a3b9ef 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1595,7 +1595,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
  *	Zero on success, or -ERRNO value.
  */
 
-static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit piix_init_one(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct device *dev = &pdev->dev;


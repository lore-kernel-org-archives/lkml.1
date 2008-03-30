Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYC3Woi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYC3Woi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYC3WlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:41:15 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57876 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbYC3WlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:41:14 -0400
Date: Mon, 31 Mar 2008 01:41:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] pci/pcie/aer/aerdrv_acpi.c: remove unneeded NULL check
Message-ID: <20080330224101.GO28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for checking pdev->bus for being NULL here (and we'd 
anyway Oops 3 lines below if it was).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 22 Feb 2008

74832021c82be6e2ed6055f4f25dbf152df67cf5 diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8c199ae..1e2a858 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -34,7 +34,7 @@ int aer_osc_setup(struct pcie_device *pciedev)
 	acpi_handle handle = 0;
 
 	/* Find root host bridge */
-	while (pdev->bus && pdev->bus->self)
+	while (pdev->bus->self)
 		pdev = pdev->bus->self;
 	handle = acpi_get_pci_rootbridge_handle(
 		pci_domain_nr(pdev->bus), pdev->bus->number);


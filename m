Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYJEQjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYJEQjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbYJEQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:36:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35293 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761304AbYJEQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:52 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 08/19] qla2xxx: Switch to ROM API
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:36:52 +0100
Message-ID: <20081005163649.3799.96955.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on the pci_enable/disable_rom being exported. Closes #9422
---

 drivers/scsi/qla2xxx/qla_init.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ee89ddd..cabc84b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -134,7 +134,6 @@ int
 qla2100_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -146,9 +145,7 @@ qla2100_pci_config(scsi_qla_host_t *ha)
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -168,7 +165,6 @@ int
 qla2300_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t	w;
-	uint32_t	d;
 	unsigned long   flags = 0;
 	uint32_t	cnt;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -231,9 +227,7 @@ qla2300_pci_config(scsi_qla_host_t *ha)
 	pci_write_config_byte(ha->pdev, PCI_LATENCY_TIMER, 0x80);
 
 	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	/* Get PCI bus information. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -253,7 +247,6 @@ int
 qla24xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
@@ -276,9 +269,7 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 		pcie_set_readrq(ha->pdev, 2048);
 
 	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 
@@ -300,7 +291,6 @@ int
 qla25xx_pci_config(scsi_qla_host_t *ha)
 {
 	uint16_t w;
-	uint32_t d;
 
 	pci_set_master(ha->pdev);
 	pci_try_set_mwi(ha->pdev);
@@ -315,9 +305,7 @@ qla25xx_pci_config(scsi_qla_host_t *ha)
 		pcie_set_readrq(ha->pdev, 2048);
 
 	/* Reset expansion ROM address decode enable */
-	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
-	d &= ~PCI_ROM_ADDRESS_ENABLE;
-	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+	pci_disable_rom(ha->pdev);
 
 	ha->chip_revision = ha->pdev->revision;
 


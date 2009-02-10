Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbZBJWhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbZBJWhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZBJWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:36:53 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:56686 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbZBJWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:36:52 -0500
X-Greylist: delayed 3404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Feb 2009 17:36:52 EST
Date: Tue, 10 Feb 2009 22:40:00 +0100
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Cc: Scott H Kilau <Scott_Kilau@digi.com>, Wendy Xiong <wendyx@us.ibm.com>
Subject: [PATCH] Add device to jsm driver
Message-ID: <20090210214000.GB8307@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Digi Neo 8 PCI card (114f:00b1)
Serial controller: Digi International Digi Neo 8 (rev 05)

that works with the jsm driver after using the following patch.


Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

---
 drivers/serial/jsm/jsm_driver.c |    3 +++
 include/linux/pci_ids.h         |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index 92187e2..ac79cbe 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -84,6 +84,8 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	brd->pci_dev = pdev;
 	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
 		brd->maxports = 4;
+	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
+		brd->maxports = 8;
 	else
 		brd->maxports = 2;
 
@@ -212,6 +214,7 @@ static struct pci_device_id jsm_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0, 2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 52a9fe0..49ff54a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1444,6 +1444,7 @@
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
+#define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA

Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/

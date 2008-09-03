Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYICKtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYICKtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYICKs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:48:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:43736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYICKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:48:26 -0400
Subject: [PATCH 3/3] Define and use PCI_DEVICE_ID_MARVELL_88ALP01_CCIC for
	=?ISO-8859-1?Q?CAF=C9?= camera driver
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, devel@laptop.org
In-Reply-To: <1220438625.patch@pmac.infradead.org>
References: <1220438625.patch@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 11:48:22 +0100
Message-Id: <1220438902.2985.101.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, stop looking at the NAND controller (0x4100) and checking the
device class. For a while during development, all three functions on the
chip had the same ID. We made them fix that fairly promptly, and we can
forget about it now.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
(Carried in git://git.infradead.org/~dwmw2/random-2.6.git)

 drivers/media/video/cafe_ccic.c |   13 +++----------
 include/linux/pci_ids.h         |    1 +
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index c149b7d..ea0db81 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2091,15 +2091,8 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	int ret;
-	u16 classword;
 	struct cafe_camera *cam;
-	/*
-	 * Make sure we have a camera here - we'll get calls for
-	 * the other cafe devices as well.
-	 */
-	pci_read_config_word(pdev, PCI_CLASS_DEVICE, &classword);
-	if (classword != PCI_CLASS_MULTIMEDIA_VIDEO)
-		return -ENODEV;
+
 	/*
 	 * Start putting together one of our big camera structures.
 	 */
@@ -2287,8 +2280,8 @@ static int cafe_pci_resume(struct pci_dev *pdev)
 

 static struct pci_device_id cafe_ids[] = {
-	{ PCI_DEVICE(0x11ab, 0x4100) }, /* Eventual real ID */
-	{ PCI_DEVICE(0x11ab, 0x4102) }, /* Really eventual real ID */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL,
+		     PCI_DEVICE_ID_MARVELL_88ALP01_CCIC) },
 	{ 0, }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index e6240b7..6cf53f4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1523,6 +1523,7 @@
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
 #define PCI_DEVICE_ID_MARVELL_88ALP01_NAND	0x4100
 #define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
+#define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC	0x4102
 
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




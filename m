Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbXCFKBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbXCFKBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbXCFKBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:01:31 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:52140 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbXCFKBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:01:30 -0500
Subject: [kj]patch7:replace pci_find_device in sound/oss/trident.c
From: Surya <surya.prabhakar@wipro.com>
To: alan@redhat.com, mulix@mulix.org
Cc: linux-kernel@vger.kernel.org,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technologies, Bangalore, India.
Date: Tue, 06 Mar 2007 15:31:27 +0530
Message-Id: <1173175287.32705.5.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 06 Mar 2007 10:01:28.0458 (UTC) FILETIME=[6885AEA0:01C75FD6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 Cleanup of pci_find_device to pci_get_device in sound/oss/trident.c
Applies and compiles clean to latest Linus tree. Not tested!

thanks..


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 

diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 72a8a0e..882ab27 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -4450,8 +4450,8 @@ trident_probe(struct pci_dev *pci_dev, c
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl = 0;
-		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL, 
-						PCI_DEVICE_ID_AL_M1533, 
+		pci_dev_m1533 = pci_get_device(PCI_VENDOR_ID_AL,
+						PCI_DEVICE_ID_AL_M1533,
 						pci_dev_m1533);
 		rc = -ENODEV;
 		if (pci_dev_m1533 == NULL)
@@ -4481,6 +4481,7 @@ trident_probe(struct pci_dev *pci_dev, c
 
 	/* claim our irq */
 	rc = -ENODEV;
+	pci_dev_put(pci_dev_m1533);
 	if (request_irq(card->irq, &trident_interrupt, IRQF_SHARED,
 			card_names[pci_id->driver_data], card)) {
 		printk(KERN_ERR "trident: unable to allocate irq %d\n", 

-- 
surya.

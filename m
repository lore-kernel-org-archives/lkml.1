Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbZGYVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbZGYVEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZGYVEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:04:20 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:32885 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZGYVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:03:46 -0400
Message-Id: <f70e75e11069edfbe55be06960854c46860da0a3.1248546897.git.keil@b1-systems.de>
In-Reply-To: <cover.1248546896.git.keil@b1-systems.de>
References: <cover.1248546896.git.keil@b1-systems.de>
Date: Fri, 24 Jul 2009 18:41:23 +0200
Subject: [PATCH 13/13] mISDN: hfcmulti display real PCI ids for not supported cards
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the PCI probe function struct pci_device_id points to the matched
entry of the ID table, but for devices which are matched with
PCI_ANY_ID sub IDs we want display the IDs of the device itself.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index fd77bb1..faed794 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5370,9 +5370,10 @@ hfcmulti_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	    ent->device == PCI_DEVICE_ID_CCD_HFC8S ||
 	    ent->device == PCI_DEVICE_ID_CCD_HFCE1)) {
 		printk(KERN_ERR
-		    "Unknown HFC multiport controller (vendor:%x device:%x "
-		    "subvendor:%x subdevice:%x)\n", ent->vendor, ent->device,
-		    ent->subvendor, ent->subdevice);
+		    "Unknown HFC multiport controller (vendor:%04x device:%04x "
+		    "subvendor:%04x subdevice:%04x)\n", pdev->vendor,
+		    pdev->device, pdev->subsystem_vendor,
+		    pdev->subsystem_device);
 		printk(KERN_ERR
 		    "Please contact the driver maintainer for support.\n");
 		return -ENODEV;
-- 
1.6.0.2


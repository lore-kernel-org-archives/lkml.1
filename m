Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZGTHbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZGTHbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZGTHbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:31:37 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:5278 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752665AbZGTHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:31:36 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KN2KW3-04-F9X-01
Date: Mon, 20 Jul 2009 15:31:12 +0800
From: Crane Cai <crane.cai@amd.com>
To: khali@linux-fr.org
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: Add support for new AMD SMBus devices
Message-ID: <20090720073112.GA18219@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>, khali@linux-fr.org,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 Jul 2009 07:31:10.0156 (UTC) FILETIME=[0D5740C0:01CA090C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use driver to detect SMBus devices with Vendor ID AMD and class code is SMBus.

Signed-off-by: Crane Cai <crane.cai@amd.com>
---
 drivers/i2c/busses/i2c-piix4.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 0249a7d..034f388 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -479,6 +479,10 @@ static struct pci_device_id piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
+	/* AMD Generic, PCI class code and Vendor ID for SMBus */
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_ANY_ID),
+	  .class = PCI_CLASS_SERIAL_SMBUS << 8,
+	  .class_mask = 0xffffff },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
@@ -499,9 +503,10 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 {
 	int retval;
 
-	if ((dev->vendor == PCI_VENDOR_ID_ATI) &&
+	if (((dev->vendor == PCI_VENDOR_ID_ATI) &&
 	    (dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS) &&
-	    (dev->revision >= 0x40))
+	    (dev->revision >= 0x40)) ||
+	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
 		retval = piix4_setup_sb800(dev, id);
 	else
-- 
1.6.0.4


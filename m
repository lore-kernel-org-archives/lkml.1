Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZIJIDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZIJIDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZIJIDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:03:50 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:34919
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752353AbZIJIDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:03:45 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPQX1F-03-3XQ-01
Date: Thu, 10 Sep 2009 16:04:27 +0800
From: Crane Cai <crane.cai@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: add new AMD SMBus device ID
Message-ID: <20090910080427.GA10945@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Sep 2009 08:03:09.0026 (UTC) FILETIME=[228E9420:01CA31ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new SMBus device ID for SB900

---
Hi Jean,

We follow your point, new patch submitted, please apply.

Thanks,
- Crane
---

Signed-off-by: Crane Cai <crane.cai@amd.com>
---
 drivers/i2c/busses/i2c-piix4.c |    8 +++++---
 include/linux/pci_ids.h        |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 0249a7d..a75d216 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -479,6 +479,7 @@ static struct pci_device_id piix4_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SB900_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
@@ -499,9 +500,10 @@ static int __devinit piix4_probe(struct pci_dev *dev,
 {
 	int retval;
 
-	if ((dev->vendor == PCI_VENDOR_ID_ATI) &&
-	    (dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS) &&
-	    (dev->revision >= 0x40))
+	if ((dev->vendor == PCI_VENDOR_ID_ATI &&
+	     dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
+	     dev->revision >= 0x40) ||
+	    dev->vendor == PCI_VENDOR_ID_AMD)
 		/* base address location etc changed in SB800 */
 		retval = piix4_setup_sb800(dev, id);
 	else
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73b46b6..0786ccd 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -537,6 +537,7 @@
 #define PCI_DEVICE_ID_AMD_8131_BRIDGE	0x7450
 #define PCI_DEVICE_ID_AMD_8131_APIC	0x7451
 #define PCI_DEVICE_ID_AMD_8132_BRIDGE	0x7458
+#define PCI_DEVICE_ID_AMD_SB900_SMBUS	0x780b
 #define PCI_DEVICE_ID_AMD_CS5536_ISA    0x2090
 #define PCI_DEVICE_ID_AMD_CS5536_FLASH  0x2091
 #define PCI_DEVICE_ID_AMD_CS5536_AUDIO  0x2093
-- 
1.6.0.4


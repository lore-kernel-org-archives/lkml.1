Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYHYWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYHYWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbYHYWCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:02:15 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:22841 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbYHYWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:02:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 2/5] AGP: follow lspci device/vendor style
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:01:48 -0600
Message-ID: <20080825220148.19210.97403.stgit@tigger.helgaas>
In-Reply-To: <20080825220137.19210.41857.stgit@tigger.helgaas>
References: <20080825220137.19210.41857.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format
used by lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/char/agp/ali-agp.c      |    2 +-
 drivers/char/agp/amd64-agp.c    |    2 +-
 drivers/char/agp/ati-agp.c      |    2 +-
 drivers/char/agp/intel-agp.c    |    2 +-
 drivers/char/agp/isoch.c        |    2 +-
 drivers/char/agp/sis-agp.c      |    2 +-
 drivers/char/agp/sworks-agp.c   |    2 +-
 drivers/char/agp/uninorth-agp.c |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/drivers/char/agp/ali-agp.c b/drivers/char/agp/ali-agp.c
index 31dcd91..895b4fb 100644
--- a/drivers/char/agp/ali-agp.c
+++ b/drivers/char/agp/ali-agp.c
@@ -316,7 +316,7 @@ static int __devinit agp_ali_probe(struct pci_dev *pdev,
 			goto found;
 	}
 
-	dev_err(&pdev->dev, "unsupported ALi chipset [%04x/%04x])\n",
+	dev_err(&pdev->dev, "unsupported ALi chipset [%04x:%04x])\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 7495c52..493fca8 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -505,7 +505,7 @@ static int __devinit agp_amd64_probe(struct pci_dev *pdev,
 	    pdev->device == PCI_DEVICE_ID_AMD_8151_0) {
 		amd8151_init(pdev, bridge);
 	} else {
-		dev_info(&pdev->dev, "AGP bridge [%04x/%04x]\n",
+		dev_info(&pdev->dev, "AGP bridge [%04x:%04x]\n",
 			 pdev->vendor, pdev->device);
 	}
 
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 6ecbcaf..a12fddb 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -486,7 +486,7 @@ static int __devinit agp_ati_probe(struct pci_dev *pdev,
 			goto found;
 	}
 
-	dev_err(&pdev->dev, "unsupported Ati chipset [%04x/%04x])\n",
+	dev_err(&pdev->dev, "unsupported Ati chipset [%04x:%04x])\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 016fdf0..3844c46 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2171,7 +2171,7 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 
 	if (intel_agp_chipsets[i].name == NULL) {
 		if (cap_ptr)
-			dev_warn(&pdev->dev, "unsupported Intel chipset [%04x/%04x]\n",
+			dev_warn(&pdev->dev, "unsupported Intel chipset [%04x:%04x]\n",
 				 pdev->vendor, pdev->device);
 		agp_put_bridge(bridge);
 		return -ENODEV;
diff --git a/drivers/char/agp/isoch.c b/drivers/char/agp/isoch.c
index c73385c..f47464f 100644
--- a/drivers/char/agp/isoch.c
+++ b/drivers/char/agp/isoch.c
@@ -359,7 +359,7 @@ int agp_3_5_enable(struct agp_bridge_data *bridge)
 			case 0x0001:    /* Unclassified device */
 				/* Don't know what this is, but log it for investigation. */
 				if (mcapndx != 0) {
-					dev_info(&td->dev, "wacky, found unclassified AGP device %s [%04x/%04x]\n",
+					dev_info(&td->dev, "wacky, found unclassified AGP device %s [%04x:%04x]\n",
 						 pci_name(dev),
 						 dev->vendor, dev->device);
 				}
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 2587ef9..8479c25 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -188,7 +188,7 @@ static int __devinit agp_sis_probe(struct pci_dev *pdev,
 		return -ENODEV;
 
 
-	dev_info(&pdev->dev, "SiS chipset [%04x/%04x]\n",
+	dev_info(&pdev->dev, "SiS chipset [%04x:%04x]\n",
 		 pdev->vendor, pdev->device);
 	bridge = agp_alloc_bridge();
 	if (!bridge)
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 2fb27fe..8b19cff 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -464,7 +464,7 @@ static int __devinit agp_serverworks_probe(struct pci_dev *pdev,
 	default:
 		if (cap_ptr)
 			dev_err(&pdev->dev, "unsupported Serverworks chipset "
-				"[%04x/%04x]\n", pdev->vendor, pdev->device);
+				"[%04x:%04x]\n", pdev->vendor, pdev->device);
 		return -ENODEV;
 	}
 
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index eef7270..698ebff 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -597,7 +597,7 @@ static int __devinit agp_uninorth_probe(struct pci_dev *pdev,
 		}
 	}
 
-	dev_err(&pdev->dev, "unsupported Apple chipset [%04x/%04x]\n",
+	dev_err(&pdev->dev, "unsupported Apple chipset [%04x:%04x]\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 


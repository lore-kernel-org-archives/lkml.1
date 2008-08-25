Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYHYWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYHYWCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYHYWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:01:57 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40167 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbYHYWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:01:56 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 3/5] V4L/DVB: follow lspci device/vendor style
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:01:53 -0600
Message-ID: <20080825220153.19210.25410.stgit@tigger.helgaas>
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

 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |    2 +-
 drivers/media/dvb/ttpci/av7110.c                  |    2 +-
 drivers/media/dvb/ttpci/budget-av.c               |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c               |    2 +-
 drivers/media/dvb/ttpci/budget-patch.c            |    2 +-
 drivers/media/dvb/ttpci/budget.c                  |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    2 +-
 drivers/media/video/cx18/cx18-driver.c            |    4 ++--
 drivers/media/video/ivtv/ivtv-driver.c            |    4 ++--
 10 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 6afbfbb..48762a2 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -702,7 +702,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 	}
 
 	if (card->fe == NULL)
-		printk("dvb-bt8xx: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-bt8xx: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       card->bt->dev->vendor,
 		       card->bt->dev->device,
 		       card->bt->dev->subsystem_vendor,
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 0777e8f..3b64180 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2256,7 +2256,7 @@ static int frontend_init(struct av7110 *av7110)
 	if (!av7110->fe) {
 		/* FIXME: propagate the failure code from the lower layers */
 		ret = -ENOMEM;
-		printk("dvb-ttpci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-ttpci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       av7110->dev->pci->vendor,
 		       av7110->dev->pci->device,
 		       av7110->dev->pci->subsystem_vendor,
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index b7d1f2f..839c941 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -1049,7 +1049,7 @@ static void frontend_init(struct budget_av *budget_av)
 
 	if (fe == NULL) {
 		printk(KERN_ERR "budget-av: A frontend driver was not found "
-				"for device %04x/%04x subsystem %04x/%04x\n",
+				"for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       saa->pci->vendor,
 		       saa->pci->device,
 		       saa->pci->subsystem_vendor,
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 060e7c7..38dd5cf 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -1153,7 +1153,7 @@ static void frontend_init(struct budget_ci *budget_ci)
 	}
 
 	if (budget_ci->budget.dvb_frontend == NULL) {
-		printk("budget-ci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("budget-ci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget_ci->budget.dev->pci->vendor,
 		       budget_ci->budget.dev->pci->device,
 		       budget_ci->budget.dev->pci->subsystem_vendor,
diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 39bd0a2..e568bd0 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -359,7 +359,7 @@ static void frontend_init(struct budget_patch* budget)
 	}
 
 	if (budget->dvb_frontend == NULL) {
-		printk("dvb-ttpci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-ttpci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget->dev->pci->vendor,
 		       budget->dev->pci->device,
 		       budget->dev->pci->subsystem_vendor,
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 2293d80..57709ef 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -549,7 +549,7 @@ static void frontend_init(struct budget *budget)
 	}
 
 	if (budget->dvb_frontend == NULL) {
-		printk("budget: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("budget: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget->dev->pci->vendor,
 		       budget->dev->pci->device,
 		       budget->dev->pci->subsystem_vendor,
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index e6c9cd2..66ab0c6 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1614,7 +1614,7 @@ static void frontend_init(struct ttusb* ttusb)
 	}
 
 	if (ttusb->fe == NULL) {
-		printk("dvb-ttusb-budget: A frontend driver was not found for device %04x/%04x\n",
+		printk("dvb-ttusb-budget: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(ttusb->dev->descriptor.idVendor),
 		       le16_to_cpu(ttusb->dev->descriptor.idProduct));
 	} else {
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index de5829b..ab33fec 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1665,7 +1665,7 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 	}
 
 	if (dec->fe == NULL) {
-		printk("dvb-ttusb-dec: A frontend driver was not found for device %04x/%04x\n",
+		printk("dvb-ttusb-dec: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(dec->udev->descriptor.idVendor),
 		       le16_to_cpu(dec->udev->descriptor.idProduct));
 	} else {
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 22434aa..a819140 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -395,9 +395,9 @@ done:
 
 	if (cx->card == NULL) {
 		cx->card = cx18_get_card(CX18_CARD_HVR_1600_ESMT);
-		CX18_ERR("Unknown card: vendor/device: %04x/%04x\n",
+		CX18_ERR("Unknown card: vendor/device: [%04x:%04x]\n",
 		     cx->dev->vendor, cx->dev->device);
-		CX18_ERR("              subsystem vendor/device: %04x/%04x\n",
+		CX18_ERR("              subsystem vendor/device: [%04x:%04x]\n",
 		     cx->dev->subsystem_vendor, cx->dev->subsystem_device);
 		CX18_ERR("Defaulting to %s card\n", cx->card->name);
 		CX18_ERR("Please mail the vendor/device and subsystem vendor/device IDs and what kind of\n");
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index aea1664..70a8ad0 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -655,9 +655,9 @@ done:
 
 	if (itv->card == NULL) {
 		itv->card = ivtv_get_card(IVTV_CARD_PVR_150);
-		IVTV_ERR("Unknown card: vendor/device: %04x/%04x\n",
+		IVTV_ERR("Unknown card: vendor/device: [%04x:%04x]\n",
 		     itv->dev->vendor, itv->dev->device);
-		IVTV_ERR("              subsystem vendor/device: %04x/%04x\n",
+		IVTV_ERR("              subsystem vendor/device: [%04x:%04x]\n",
 		     itv->dev->subsystem_vendor, itv->dev->subsystem_device);
 		IVTV_ERR("              %s based\n", chipname);
 		IVTV_ERR("Defaulting to %s card\n", itv->card->name);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbZCYAj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbZCYAj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZCYAaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:06 -0400
Received: from kroah.org ([198.145.64.141]:54109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756853AbZCYAaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sachin Sant <sachinp@in.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/61] USB: FHCI: use dev_name() in place of bus_id.
Date: Tue, 24 Mar 2009 17:26:32 -0700
Message-Id: <1237940825-22904-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Sant <sachinp@in.ibm.com>

Replace references to bus_id with dev_name() to fix fhci driver build break.

drivers/usb/host/fhci-hcd.c:586: error: struct device has no member named bus_id
drivers/usb/host/fhci-hcd.c:653: error: struct device has no member named bus_id
drivers/usb/host/fhci-dbg.c:111: error: struct device has no member named bus_id

Signed-off-by: Sachin Sant <sachinp@in.ibm.com>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/fhci-dbg.c |    2 +-
 drivers/usb/host/fhci-hcd.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/fhci-dbg.c b/drivers/usb/host/fhci-dbg.c
index 34e14ed..ea8a425 100644
--- a/drivers/usb/host/fhci-dbg.c
+++ b/drivers/usb/host/fhci-dbg.c
@@ -108,7 +108,7 @@ void fhci_dfs_create(struct fhci_hcd *fhci)
 {
 	struct device *dev = fhci_to_hcd(fhci)->self.controller;
 
-	fhci->dfs_root = debugfs_create_dir(dev->bus_id, NULL);
+	fhci->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
 	if (!fhci->dfs_root) {
 		WARN_ON(1);
 		return;
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index ba622cc..0951818 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -583,7 +583,7 @@ static int __devinit of_fhci_probe(struct of_device *ofdev,
 	if (sprop && strcmp(sprop, "host"))
 		return -ENODEV;
 
-	hcd = usb_create_hcd(&fhci_driver, dev, dev->bus_id);
+	hcd = usb_create_hcd(&fhci_driver, dev, dev_name(dev));
 	if (!hcd) {
 		dev_err(dev, "could not create hcd\n");
 		return -ENOMEM;
@@ -650,7 +650,7 @@ static int __devinit of_fhci_probe(struct of_device *ofdev,
 			}
 		}
 
-		ret = gpio_request(gpio, dev->bus_id);
+		ret = gpio_request(gpio, dev_name(dev));
 		if (ret) {
 			dev_err(dev, "failed to request gpio %d", i);
 			goto err_gpios;
-- 
1.6.2


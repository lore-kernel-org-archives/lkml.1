Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYCXT53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYCXT53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYCXT5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:57:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51900 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYCXT5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:57:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:55:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: missing PPC PMac feature calls in failure
 path
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.2821164ab5d906e0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balance ohci_pmac_on and ohci_pmac_off if pci_driver.probe fails.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -2285,8 +2285,6 @@ pci_probe(struct pci_dev *dev, const str
 	int err;
 	size_t size;
 
-	ohci_pmac_on(dev);
-
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
 		fw_error("Could not malloc fw_ohci data.\n");
@@ -2295,6 +2293,8 @@ pci_probe(struct pci_dev *dev, const str
 
 	fw_card_initialize(&ohci->card, &ohci_driver, &dev->dev);
 
+	ohci_pmac_on(dev);
+
 	err = pci_enable_device(dev);
 	if (err) {
 		fw_error("Failed to enable OHCI hardware.\n");
@@ -2396,6 +2396,7 @@ pci_probe(struct pci_dev *dev, const str
 	pci_disable_device(dev);
  fail_free:
 	kfree(&ohci->card);
+	ohci_pmac_off(dev);
 
 	return err;
 }

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/


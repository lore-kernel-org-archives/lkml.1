Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZAYWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZAYWts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZAYWtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:49:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23351 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZAYWti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:49:38 -0500
Subject: mca: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:48:47 +0100
Message-Id: <1232923727.2924.12.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: mca: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: James.Bottomley@HansenPartnership.com
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mca/mca-bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -110,7 +110,7 @@ int __init mca_register_device(int bus,
 
 	mca_dev->dev.parent = &mca_bus->dev;
 	mca_dev->dev.bus = &mca_bus_type;
-	sprintf (mca_dev->dev.bus_id, "%02d:%02X", bus, mca_dev->slot);
+	dev_set_name(&mca_dev->dev, "%02d:%02X", bus, mca_dev->slot);
 	mca_dev->dma_mask = mca_bus->default_dma_mask;
 	mca_dev->dev.dma_mask = &mca_dev->dma_mask;
 	mca_dev->dev.coherent_dma_mask = mca_dev->dma_mask;
@@ -151,7 +151,7 @@ struct mca_bus * __devinit mca_attach_bu
 	if (!mca_bus)
 		return NULL;
 
-	sprintf(mca_bus->dev.bus_id,"mca%d",bus);
+	dev_set_name(&mca_bus->dev, "mca%d", bus);
 	sprintf(mca_bus->name,"Host %s MCA Bridge", bus ? "Secondary" : "Primary");
 	if (device_register(&mca_bus->dev)) {
 		kfree(mca_bus);


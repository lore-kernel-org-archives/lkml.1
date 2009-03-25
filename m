Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZCYAiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZCYAiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZCYA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:59 -0400
Received: from kroah.org ([198.145.64.141]:54097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756795AbZCYA3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, James.Bottomley@HansenPartnership.com
Subject: [PATCH 23/61] mca: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:27 -0700
Message-Id: <1237940825-22904-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: James.Bottomley@HansenPartnership.com
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mca/mca-bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
index ef2dbfe..ada5ebb 100644
--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -110,7 +110,7 @@ int __init mca_register_device(int bus, struct mca_device *mca_dev)
 
 	mca_dev->dev.parent = &mca_bus->dev;
 	mca_dev->dev.bus = &mca_bus_type;
-	sprintf (mca_dev->dev.bus_id, "%02d:%02X", bus, mca_dev->slot);
+	dev_set_name(&mca_dev->dev, "%02d:%02X", bus, mca_dev->slot);
 	mca_dev->dma_mask = mca_bus->default_dma_mask;
 	mca_dev->dev.dma_mask = &mca_dev->dma_mask;
 	mca_dev->dev.coherent_dma_mask = mca_dev->dma_mask;
@@ -151,7 +151,7 @@ struct mca_bus * __devinit mca_attach_bus(int bus)
 	if (!mca_bus)
 		return NULL;
 
-	sprintf(mca_bus->dev.bus_id,"mca%d",bus);
+	dev_set_name(&mca_bus->dev, "mca%d", bus);
 	sprintf(mca_bus->name,"Host %s MCA Bridge", bus ? "Secondary" : "Primary");
 	if (device_register(&mca_bus->dev)) {
 		kfree(mca_bus);
-- 
1.6.2


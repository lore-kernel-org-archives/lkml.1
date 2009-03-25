Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZCYAhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZCYAhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZCYA34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:56 -0400
Received: from kroah.org ([198.145.64.141]:54092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756784AbZCYA3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 21/61] eisa: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:25 -0700
Message-Id: <1237940825-22904-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/eisa/eisa-bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index c950bf8..66958b3 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -200,7 +200,7 @@ static int __init eisa_init_device (struct eisa_root_device *root,
 	edev->dev.bus = &eisa_bus_type;
 	edev->dev.dma_mask = &edev->dma_mask;
 	edev->dev.coherent_dma_mask = edev->dma_mask;
-	sprintf (edev->dev.bus_id, "%02X:%02X", root->bus_nr, slot);
+	dev_set_name(&edev->dev, "%02X:%02X", root->bus_nr, slot);
 
 	for (i = 0; i < EISA_MAX_RESOURCES; i++) {
 #ifdef CONFIG_EISA_NAMES
@@ -301,7 +301,7 @@ static int __init eisa_probe (struct eisa_root_device *root)
 	struct eisa_device *edev;
 
         printk (KERN_INFO "EISA: Probing bus %d at %s\n",
-		root->bus_nr, root->dev->bus_id);
+		root->bus_nr, dev_name(root->dev));
 
 	/* First try to get hold of slot 0. If there is no device
 	 * here, simply fail, unless root->force_probe is set. */
-- 
1.6.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZCYAgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZCYAgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZCYA3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:55 -0400
Received: from kroah.org ([198.145.64.141]:54084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756795AbZCYA3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 18/61] amba: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:22 -0700
Message-Id: <1237940825-22904-18-git-send-email-gregkh@suse.de>
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
 drivers/amba/bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 00c46e0..3d763fd 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -210,7 +210,7 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dma_mask;
-	dev->res.name = dev->dev.bus_id;
+	dev->res.name = dev_name(&dev->dev);
 
 	if (!dev->dev.coherent_dma_mask && dev->dma_mask)
 		dev_warn(&dev->dev, "coherent dma mask is unset\n");
@@ -294,7 +294,7 @@ static int amba_find_match(struct device *dev, void *data)
 	if (d->parent)
 		r &= d->parent == dev->parent;
 	if (d->busid)
-		r &= strcmp(dev->bus_id, d->busid) == 0;
+		r &= strcmp(dev_name(dev), d->busid) == 0;
 
 	if (r) {
 		get_device(dev);
-- 
1.6.2


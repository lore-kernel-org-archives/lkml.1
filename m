Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZDGOx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZDGOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZDGOxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:53:20 -0400
Received: from mx1.emlix.com ([193.175.82.87]:60882 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZDGOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:53:19 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] s6gmac: don't use device->bus_id directly
Date: Tue,  7 Apr 2009 16:54:53 +0200
Message-Id: <1239116093-22147-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dev_name() helper to get a name string for a device instead of
open-coding random device field accesses.

With '1fa5ae8 driver core: get rid of struct device's bus_id string
array' in place, this is not just a cleanup but a compilation fix.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/net/s6gmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Andrew, this is for s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch

diff --git a/drivers/net/s6gmac.c b/drivers/net/s6gmac.c
index 74bf583..5345e47 100644
--- a/drivers/net/s6gmac.c
+++ b/drivers/net/s6gmac.c
@@ -795,7 +795,7 @@ static inline int s6gmac_phy_start(struct net_device *dev)
 	struct phy_device *p = NULL;
 	while ((!(p = pd->mii.bus->phy_map[i])) && (i < PHY_MAX_ADDR))
 		i++;
-	p = phy_connect(dev, p->dev.bus_id, &s6gmac_adjust_link, 0,
+	p = phy_connect(dev, dev_name(&p->dev), &s6gmac_adjust_link, 0,
 			PHY_INTERFACE_MODE_RGMII);
 	if (IS_ERR(p)) {
 		printk(KERN_ERR "%s: Could not attach to PHY\n", dev->name);
-- 
1.6.2.107.ge47ee


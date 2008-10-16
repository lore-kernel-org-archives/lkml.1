Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYJPR36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYJPR36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbYJPRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:04 -0400
Received: from kroah.org ([198.145.64.141]:47039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756512AbYJPRPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/46] NET: convert the phy_device file to use bus_find_device_by_name
Date: Thu, 16 Oct 2008 10:10:42 -0700
Message-Id: <1224177047-11859-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core now has this helper function, so might as well use it
instead of forcing the phy code to roll their own version.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/phy/phy_device.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f11e900..e11b03b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -309,11 +309,6 @@ void phy_disconnect(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_disconnect);
 
-static int phy_compare_id(struct device *dev, void *data)
-{
-	return strcmp((char *)data, dev->bus_id) ? 0 : 1;
-}
-
 /**
  * phy_attach - attach a network device to a particular PHY device
  * @dev: network device to attach
@@ -337,8 +332,7 @@ struct phy_device *phy_attach(struct net_device *dev,
 
 	/* Search the list of PHY devices on the mdio bus for the
 	 * PHY with the requested name */
-	d = bus_find_device(bus, NULL, (void *)bus_id, phy_compare_id);
-
+	d = bus_find_device_by_name(bus, NULL, bus_id);
 	if (d) {
 		phydev = to_phy_device(d);
 	} else {
-- 
1.6.0.2


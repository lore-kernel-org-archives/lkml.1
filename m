Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXFQJBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXFQJBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXFQJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:01:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36858 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbXFQJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:01:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Jun 2007 11:01:18 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] driver core: properly get driver in device_release_driver
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.d01dbfd3bbd7140c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/base/dd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.22-rc3/drivers/base/dd.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/base/dd.c
+++ linux-2.6.22-rc3/drivers/base/dd.c
@@ -309,9 +309,8 @@ static void __device_release_driver(stru
 {
 	struct device_driver * drv;
 
-	drv = dev->driver;
+	drv = get_driver(dev->driver);
 	if (drv) {
-		get_driver(drv);
 		driver_sysfs_remove(dev);
 		sysfs_remove_link(&dev->kobj, "driver");
 		klist_remove(&dev->knode_driver);

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


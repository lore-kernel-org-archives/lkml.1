Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbZAFW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbZAFW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZAFWOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:05 -0500
Received: from kroah.org ([198.145.64.141]:51300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756053AbZAFWOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/60] infiniband: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:01 -0800
Message-Id: <1231279939-32728-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/sysfs.c     |    2 +-
 drivers/infiniband/core/ucm.c       |    3 +--
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 4f4d1bb..b43f7d3 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -778,7 +778,7 @@ int ib_device_register_sysfs(struct ib_device *device)
 	class_dev->class      = &ib_class;
 	class_dev->driver_data = device;
 	class_dev->parent     = device->dma_device;
-	strlcpy(class_dev->bus_id, device->name, BUS_ID_SIZE);
+	dev_set_name(class_dev, device->name);
 
 	INIT_LIST_HEAD(&device->port_list);
 
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index e603736..51bd966 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1266,8 +1266,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	ucm_dev->dev.parent = device->dma_device;
 	ucm_dev->dev.devt = ucm_dev->cdev.dev;
 	ucm_dev->dev.release = ib_ucm_release_dev;
-	snprintf(ucm_dev->dev.bus_id, BUS_ID_SIZE, "ucm%d",
-		 ucm_dev->devnum);
+	dev_set_name(&ucm_dev->dev, "ucm%d", ucm_dev->devnum);
 	if (device_register(&ucm_dev->dev))
 		goto err_cdev;
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7c13db8..54c8fe2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1949,8 +1949,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 
 	host->dev.class = &srp_class;
 	host->dev.parent = device->dev->dma_device;
-	snprintf(host->dev.bus_id, BUS_ID_SIZE, "srp-%s-%d",
-		 device->dev->name, port);
+	dev_set_name(&host->dev, "srp-%s-%d", device->dev->name, port);
 
 	if (device_register(&host->dev))
 		goto free_host;
-- 
1.6.0.4


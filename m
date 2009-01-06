Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbZAFWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbZAFWY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZAFWNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:52 -0500
Received: from kroah.org ([198.145.64.141]:51268 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755995AbZAFWNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/60] power-supply: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:52 -0800
Message-Id: <1231279939-32728-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/power/ds2760_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 308ddb2..1d76892 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -354,7 +354,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	di->dev		= &pdev->dev;
 	di->w1_dev	     = pdev->dev.parent;
-	di->bat.name	   = pdev->dev.bus_id;
+	di->bat.name	   = dev_name(&pdev->dev);
 	di->bat.type	   = POWER_SUPPLY_TYPE_BATTERY;
 	di->bat.properties     = ds2760_battery_props;
 	di->bat.num_properties = ARRAY_SIZE(ds2760_battery_props);
@@ -371,7 +371,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	}
 
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
-	di->monitor_wqueue = create_singlethread_workqueue(pdev->dev.bus_id);
+	di->monitor_wqueue = create_singlethread_workqueue(dev_name(&pdev->dev));
 	if (!di->monitor_wqueue) {
 		retval = -ESRCH;
 		goto workqueue_failed;
-- 
1.6.0.4


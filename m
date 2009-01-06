Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZAFWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZAFWXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZAFWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:48 -0500
Received: from kroah.org ([198.145.64.141]:51253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755953AbZAFWNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/60] thermal: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:47 -0800
Message-Id: <1231279939-32728-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/thermal/thermal_sys.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index fe07462..8171ca1 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -579,7 +579,7 @@ static void thermal_release(struct device *dev)
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 
-	if (!strncmp(dev->bus_id, "thermal_zone", sizeof "thermal_zone" - 1)) {
+	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
 	} else {
@@ -630,7 +630,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(char *type,
 	cdev->ops = ops;
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
-	sprintf(cdev->device.bus_id, "cooling_device%d", cdev->id);
+	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	result = device_register(&cdev->device);
 	if (result) {
 		release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
@@ -769,7 +769,7 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
 	tz->trips = trips;
-	sprintf(tz->device.bus_id, "thermal_zone%d", tz->id);
+	dev_set_name(&tz->device, "thermal_zone%d", tz->id);
 	result = device_register(&tz->device);
 	if (result) {
 		release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
-- 
1.6.0.4


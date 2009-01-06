Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZAFWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZAFWag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZAFWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:08 -0500
Received: from kroah.org ([198.145.64.141]:51313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755465AbZAFWOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/60] hwmon: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:05 -0800
Message-Id: <1231279939-32728-46-git-send-email-gregkh@suse.de>
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
 drivers/hwmon/hwmon.c |    2 +-
 drivers/hwmon/lm75.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 076a59c..e15c3e7 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -76,7 +76,7 @@ void hwmon_device_unregister(struct device *dev)
 {
 	int id;
 
-	if (likely(sscanf(dev->bus_id, HWMON_ID_FORMAT, &id) == 1)) {
+	if (likely(sscanf(dev_name(dev), HWMON_ID_FORMAT, &id) == 1)) {
 		device_unregister(dev);
 		spin_lock(&idr_lock);
 		idr_remove(&hwmon_idr, id);
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 8f9595f..55bd87c 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -190,7 +190,7 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	dev_info(&client->dev, "%s: sensor '%s'\n",
-		data->hwmon_dev->bus_id, client->name);
+		 dev_name(data->hwmon_dev), client->name);
 
 	return 0;
 
-- 
1.6.0.4


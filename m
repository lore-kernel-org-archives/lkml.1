Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYGVF0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYGVF0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbYGVFWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:43046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbYGVFWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 13/79] device create: i2c: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:37 -0700
Message-Id: <1216703983-21448-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/i2c/i2c-dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 86727fa..9d55c63 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -521,9 +521,9 @@ static int i2cdev_attach_adapter(struct i2c_adapter *adap)
 		return PTR_ERR(i2c_dev);
 
 	/* register this i2c device with the driver core */
-	i2c_dev->dev = device_create(i2c_dev_class, &adap->dev,
-				     MKDEV(I2C_MAJOR, adap->nr),
-				     "i2c-%d", adap->nr);
+	i2c_dev->dev = device_create_drvdata(i2c_dev_class, &adap->dev,
+					     MKDEV(I2C_MAJOR, adap->nr),
+					     NULL, "i2c-%d", adap->nr);
 	if (IS_ERR(i2c_dev->dev)) {
 		res = PTR_ERR(i2c_dev->dev);
 		goto error;
-- 
1.5.6.3


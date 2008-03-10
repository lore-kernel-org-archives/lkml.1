Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYCJAEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYCJAEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 20:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYCJAEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 20:04:40 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:47110 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYCJAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 20:04:39 -0400
Message-ID: <47D47B11.1000303@tiscali.nl>
Date: Mon, 10 Mar 2008 01:04:33 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: colin@colino.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 9587869..8ea7da2 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
 	int temp = simple_strtol(buf, NULL, 10);
-	temp = temp && 0xFF;
+	temp &= 0xFF;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = temp;

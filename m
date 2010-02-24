Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0BXHih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:37 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab0BXHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=PPqg872y0H8a4VswXcwXTaJh6jHN5XwliXZQGhwWWCDRAP711FccXZdeQVJ9uXssjJ
         TNWi2B0hQjzr0b2ETbpMaQsDJdr8q6M8+CmhTDAVW5shww+xtopd0SSW1++SaL5tbQFd
         ATX7oSBbIxw5hugYU07AQmDwiuAN8eTfJsNnY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 09/14] Regulators: max8660 - annotate probe and remove methods
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:28 -0800
Message-ID: <20100224073828.15964.55037.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/max8660.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index acc2fb7..f12f1bb 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -345,8 +345,8 @@ static struct regulator_desc max8660_reg[] = {
 	},
 };
 
-static int max8660_probe(struct i2c_client *client,
-			      const struct i2c_device_id *i2c_id)
+static int __devinit max8660_probe(struct i2c_client *client,
+				   const struct i2c_device_id *i2c_id)
 {
 	struct regulator_dev **rdev;
 	struct max8660_platform_data *pdata = client->dev.platform_data;
@@ -354,7 +354,7 @@ static int max8660_probe(struct i2c_client *client,
 	int boot_on, i, id, ret = -EINVAL;
 
 	if (pdata->num_subdevs > MAX8660_V_END) {
-		dev_err(&client->dev, "Too much regulators found!\n");
+		dev_err(&client->dev, "Too many regulators found!\n");
 		goto out;
 	}
 
@@ -462,7 +462,7 @@ out:
 	return ret;
 }
 
-static int max8660_remove(struct i2c_client *client)
+static int __devexit max8660_remove(struct i2c_client *client)
 {
 	struct regulator_dev **rdev = i2c_get_clientdata(client);
 	int i;
@@ -485,9 +485,10 @@ MODULE_DEVICE_TABLE(i2c, max8660_id);
 
 static struct i2c_driver max8660_driver = {
 	.probe = max8660_probe,
-	.remove = max8660_remove,
+	.remove = __devexit_p(max8660_remove),
 	.driver		= {
 		.name	= "max8660",
+		.owner	= THIS_MODULE,
 	},
 	.id_table	= max8660_id,
 };


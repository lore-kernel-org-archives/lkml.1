Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0BXHi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:29 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0BXHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=lX/5CyQSZtmc0/20jPqFnw8TPEsTlS1uHS8Tv3v7G6DBlVKjPAWMO4Shcc7+ZaGaUs
         jwht+i7sXfv4sh5AxbPwBGgo0T4OkuCTO/Nr3VZILJCOXie/MpO1Evrdpvmckana4Rny
         OvXmlXjIW4B6/Sm6X9+nncXw15abgCF2+2Hdc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 08/14] Regulators: max1586 - annotate probe and remove methods
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:23 -0800
Message-ID: <20100224073822.15964.51065.stgit@localhost.localdomain>
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

 drivers/regulator/max1586.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 2c082d3..a49fc95 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -179,8 +179,8 @@ static struct regulator_desc max1586_reg[] = {
 	},
 };
 
-static int max1586_pmic_probe(struct i2c_client *client,
-			      const struct i2c_device_id *i2c_id)
+static int __devinit max1586_pmic_probe(struct i2c_client *client,
+					const struct i2c_device_id *i2c_id)
 {
 	struct regulator_dev **rdev;
 	struct max1586_platform_data *pdata = client->dev.platform_data;
@@ -235,7 +235,7 @@ out:
 	return ret;
 }
 
-static int max1586_pmic_remove(struct i2c_client *client)
+static int __devexit max1586_pmic_remove(struct i2c_client *client)
 {
 	struct regulator_dev **rdev = i2c_get_clientdata(client);
 	int i;
@@ -257,9 +257,10 @@ MODULE_DEVICE_TABLE(i2c, max1586_id);
 
 static struct i2c_driver max1586_pmic_driver = {
 	.probe = max1586_pmic_probe,
-	.remove = max1586_pmic_remove,
+	.remove = __devexit_p(max1586_pmic_remove),
 	.driver		= {
 		.name	= "max1586",
+		.owner	= THIS_MODULE,
 	},
 	.id_table	= max1586_id,
 };


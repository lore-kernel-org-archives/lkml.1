Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0BXHjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:39:00 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab0BXHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=JU8FjSbgAOTO/jApf121LIxWe7queBRTith/POEAWAPVikqaFEv4QArKmXFubBF68j
         qi+mgiDmQYtEKvp5bdgEvKdj2vAR0vdvDKI4bfHZDtSELRegHFACwzHWdmMs3azByp2F
         RFOoYjUHo3xoBDHfO5Vy/aV9KuJaYQKzssPAA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 14/14] Regulators: max8925-regulator - clean up driver data
	after removal
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:55 -0800
Message-ID: <20100224073855.15964.38061.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a good tone to reset driver data after unbinding the device.
Also change find_regulator_info() fro inline to __devinit - let compiler
figure out if it wants it to be inlined or not.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/max8925-regulator.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 67873f0..b6218f1 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -230,7 +230,7 @@ static struct max8925_regulator_info max8925_regulator_info[] = {
 	MAX8925_LDO(20, 750, 3900, 50),
 };
 
-static inline struct max8925_regulator_info *find_regulator_info(int id)
+static struct max8925_regulator_info * __devinit find_regulator_info(int id)
 {
 	struct max8925_regulator_info *ri;
 	int i;
@@ -247,7 +247,7 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct max8925_platform_data *pdata = chip->dev->platform_data;
-	struct max8925_regulator_info *ri = NULL;
+	struct max8925_regulator_info *ri;
 	struct regulator_dev *rdev;
 
 	ri = find_regulator_info(pdev->id);
@@ -274,7 +274,9 @@ static int __devexit max8925_regulator_remove(struct platform_device *pdev)
 {
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
 	regulator_unregister(rdev);
+
 	return 0;
 }
 


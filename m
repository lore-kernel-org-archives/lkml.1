Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0BXHio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:44 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0BXHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=gtL3v+6rdLe2VUCRubKMTfl3aducE3OA8RpZ6EG88WnxXNwnNOVQgxHxHhYcQ/V4Nn
         UyIJDMdYM3Df6DzygUfaZBdUlq7bNO03Ji/z/VgY1oMG03NAx4gYorMRKoaDdjI224WM
         6fyRCnNsLJcGms23/IPFG8mi0XHyo9f4RhsB0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 11/14] Regulators: wm831x-xxx - clean up driver data after
	removal
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:39 -0800
Message-ID: <20100224073839.15964.19386.stgit@localhost.localdomain>
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
Also set up drivers owner.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/wm831x-dcdc.c  |   12 ++++++++++++
 drivers/regulator/wm831x-isink.c |    3 +++
 drivers/regulator/wm831x-ldo.c   |    5 +++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 0a65775..6e18e56 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -600,6 +600,8 @@ static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = dcdc->wm831x;
 
+	platform_set_drvdata(pdev, NULL);
+
 	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "HC"), dcdc);
 	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
@@ -615,6 +617,7 @@ static struct platform_driver wm831x_buckv_driver = {
 	.remove = __devexit_p(wm831x_buckv_remove),
 	.driver		= {
 		.name	= "wm831x-buckv",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -769,6 +772,8 @@ static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = dcdc->wm831x;
 
+	platform_set_drvdata(pdev, NULL);
+
 	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	kfree(dcdc);
@@ -781,6 +786,7 @@ static struct platform_driver wm831x_buckp_driver = {
 	.remove = __devexit_p(wm831x_buckp_remove),
 	.driver		= {
 		.name	= "wm831x-buckp",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -895,6 +901,8 @@ static __devexit int wm831x_boostp_remove(struct platform_device *pdev)
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = dcdc->wm831x;
 
+	platform_set_drvdata(pdev, NULL);
+
 	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
 	regulator_unregister(dcdc->regulator);
 	kfree(dcdc);
@@ -907,6 +915,7 @@ static struct platform_driver wm831x_boostp_driver = {
 	.remove = __devexit_p(wm831x_boostp_remove),
 	.driver		= {
 		.name	= "wm831x-boostp",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -979,6 +988,8 @@ static __devexit int wm831x_epe_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
+	platform_set_drvdata(pdev, NULL);
+
 	regulator_unregister(dcdc->regulator);
 	kfree(dcdc);
 
@@ -990,6 +1001,7 @@ static struct platform_driver wm831x_epe_driver = {
 	.remove = __devexit_p(wm831x_epe_remove),
 	.driver		= {
 		.name	= "wm831x-epe",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 4885700..ca0f6b6 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -222,6 +222,8 @@ static __devexit int wm831x_isink_remove(struct platform_device *pdev)
 	struct wm831x_isink *isink = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = isink->wm831x;
 
+	platform_set_drvdata(pdev, NULL);
+
 	wm831x_free_irq(wm831x, platform_get_irq(pdev, 0), isink);
 
 	regulator_unregister(isink->regulator);
@@ -235,6 +237,7 @@ static struct platform_driver wm831x_isink_driver = {
 	.remove = __devexit_p(wm831x_isink_remove),
 	.driver		= {
 		.name	= "wm831x-isink",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 61e02ac..d2406c1 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -371,6 +371,8 @@ static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 	struct wm831x *wm831x = ldo->wm831x;
 
+	platform_set_drvdata(pdev, NULL);
+
 	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), ldo);
 	regulator_unregister(ldo->regulator);
 	kfree(ldo);
@@ -383,6 +385,7 @@ static struct platform_driver wm831x_gp_ldo_driver = {
 	.remove = __devexit_p(wm831x_gp_ldo_remove),
 	.driver		= {
 		.name	= "wm831x-ldo",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -640,6 +643,7 @@ static struct platform_driver wm831x_aldo_driver = {
 	.remove = __devexit_p(wm831x_aldo_remove),
 	.driver		= {
 		.name	= "wm831x-aldo",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -811,6 +815,7 @@ static struct platform_driver wm831x_alive_ldo_driver = {
 	.remove = __devexit_p(wm831x_alive_ldo_remove),
 	.driver		= {
 		.name	= "wm831x-alive-ldo",
+		.owner	= THIS_MODULE,
 	},
 };
 


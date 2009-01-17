Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbZAQPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbZAQPMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZAQPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:12:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:20257 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbZAQPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Tul6tmjsx/vNQu3FfOT4ekU/DRvIUv6GpguPcfW8TnecvLhfCbyMrTMc7p9Mdk7K/q
         YFBvFrEjrZvnyrQ/B5fUWt8vZ/nn47CydZ2VlIDCv2MyXcqkWMrYIpU/p4wlQfgfe9QC
         dosu3wTM56pUmJR3ScAXHBtxoqkTdC+IuIqs0=
Message-ID: <4971F400.4070701@gmail.com>
Date: Sat, 17 Jan 2009 16:06:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: rpurdie@rpsys.net, broonie@opensource.wolfsonmicro.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: Fix bounds checking of wm8350->pmic.led
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bounds checking of wm8350->pmic.led

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7aa3524..5056e23 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1435,7 +1435,7 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
 	struct platform_device *pdev;
 	int ret;
 
-	if (lednum > ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
+	if (lednum >= ARRAY_SIZE(wm8350->pmic.led) || lednum < 0) {
 		dev_err(wm8350->dev, "Invalid LED index %d\n", lednum);
 		return -ENODEV;
 	}

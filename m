Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab0BGBQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 20:16:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48696 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab0BGBQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 20:16:16 -0500
Date: Sun, 07 Feb 2010 10:16:14 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH] mfd: Fix WM8994 error handling
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
       kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Message-id: <4B6E145E.9090300@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 07 Feb 2010 01:15:23.0581 (UTC)
 FILETIME=[05FA6ED0:01CAA793]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong goto statement for error handling on probe.

Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/mfd/wm8994-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 299c1af..844e1c1 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -305,14 +305,14 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 				 wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
-		goto err_get;
+		goto err_supplies;
 	}
 
 	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
 				    wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
-		goto err_supplies;
+		goto err_get;
 	}
 
 	ret = wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET);
-- 
1.6.3.3

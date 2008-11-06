Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYKFNnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYKFNnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYKFNnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:43:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754101AbYKFNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:43:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] mfd: Add WM8350 revision H support
Date: Thu,  6 Nov 2008 13:43:05 +0000
Message-Id: <1225978986-25990-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225978986-25990-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081106134254.GA21855@rakim.wolfsonmicro.main>
 <1225978986-25990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1225978986-25990-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No other software changes are required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |    7 ++++++-
 include/linux/mfd/wm8350/core.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index d63a530..c013afd 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1202,9 +1202,14 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 			dev_info(wm8350->dev, "Found Rev G device\n");
 			wm8350->rev = WM8350_REV_G;
 			break;
+		case WM8350_REV_H:
+			dev_info(wm8350->dev, "Found Rev H device\n");
+			wm8350->rev = WM8350_REV_H;
+			break;
 		default:
 			/* For safety we refuse to run on unknown hardware */
-			dev_info(wm8350->dev, "Found unknown rev\n");
+			dev_info(wm8350->dev, "Found unknown rev %x\n",
+				 (id2 & WM8350_CHIP_REV_MASK) >> 12);
 			ret = -ENODEV;
 			goto err;
 		}
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 6ebf97f..9490ec1 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -536,6 +536,7 @@
 #define WM8350_REV_E				0x4
 #define WM8350_REV_F				0x5
 #define WM8350_REV_G				0x6
+#define WM8350_REV_H				0x7
 
 #define WM8350_NUM_IRQ				63
 
-- 
1.5.6.5


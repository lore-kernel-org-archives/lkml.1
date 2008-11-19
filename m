Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYKSJfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYKSJfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYKSJfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:35:17 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:60200 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYKSJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:35:16 -0500
X-Greylist: delayed 2636 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 04:35:16 EST
From: Mike Rapoport <mike@compulab.co.il>
Cc: rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, eric.miao@marvell.com,
       Mike Rapoport <mike@compulab.co.il>, rpurdie@linux.intel.com
Subject: [PATCH] drivers/video/backlight/da903x.c: introduce one more missing kfree
Date: Wed, 19 Nov 2008 10:51:13 +0200
Message-Id: <1227084673-10079-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more error handling code should have kfree as well

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/backlight/da903x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/da903x.c b/drivers/video/backlight/da903x.c
index 75388b9..93bb434 100644
--- a/drivers/video/backlight/da903x.c
+++ b/drivers/video/backlight/da903x.c
@@ -131,6 +131,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 			data, &da903x_backlight_ops);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
 		return PTR_ERR(bl);
 	}
 
-- 
1.5.6.4


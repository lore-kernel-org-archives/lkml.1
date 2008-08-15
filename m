Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYHOJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYHOJLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHOJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:11:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42928 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYHOJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:11:24 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="73537496"
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/4] Blackfin RTC Driver: do all initialization before we register the rtc and make it available
Date: Fri, 15 Aug 2008 17:01:18 +0800
Message-Id: <1218790880-12477-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
References: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 51741dc..9d2da1c 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -371,6 +371,7 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 	if (unlikely(!rtc))
 		return -ENOMEM;
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(dev, 1);
 
 	/* Grab the IRQ and init the hardware */
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_SHARED, pdev->name, dev);
@@ -386,8 +387,6 @@ static int __devinit bfin_rtc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	device_init_wakeup(dev, 1);
-
 	return 0;
 
  err_irq:
-- 
1.5.6

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbXKWKJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbXKWKJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXKWKIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:41 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:14858 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbXKWKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:39 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44107056:sNHT24296223"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/7] Blackfin RTC driver: we pass in a (struct device*) to the irq handler, not a (struct platform_device*), so fix the irq handler
Date: Fri, 23 Nov 2007 18:08:27 +0800
Message-Id: <1195812512-25979-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 303ed6e..2a801f2 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -144,8 +144,8 @@ static void rtc_bfin_reset(struct bfin_rtc *rtc)
 
 static irqreturn_t bfin_rtc_interrupt(int irq, void *dev_id)
 {
-	struct platform_device *pdev = to_platform_device(dev_id);
-	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
+	struct device *dev = dev_id;
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long events = 0;
 	u16 rtc_istat;
 
-- 
1.5.3.4

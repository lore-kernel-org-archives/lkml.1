Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbXKWKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbXKWKJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbXKWKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:43 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:14858 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXKWKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:40 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44107058:sNHT25622058"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 5/7] Blackfin RTC driver: read_alarm() checks the enabled field, not the pending field.
Date: Fri, 23 Nov 2007 18:08:30 +0800
Message-Id: <1195812512-25979-6-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

also, dont bother using memcpy since we can just do an assignment of the same structure.

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index b14a9c4..a4ed2f8 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -326,7 +326,7 @@ static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
 	memcpy(&alrm->time, &rtc->rtc_alarm, sizeof(struct rtc_time));
-	alrm->pending = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+	alrm->enabled = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
 }
 
@@ -334,7 +334,7 @@ static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	dev_dbg_stamp(dev);
-	memcpy(&rtc->rtc_alarm, &alrm->time, sizeof(struct rtc_time));
+	rtc->rtc_alarm = alrm->time;
 	return 0;
 }
 
-- 
1.5.3.4

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZAFW2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZAFW2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZAFWOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:01 -0500
Received: from kroah.org ([198.145.64.141]:51294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755722AbZAFWN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/60] pm: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:59 -0800
Message-Id: <1231279939-32728-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/power/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 613f169..2399888 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -615,7 +615,7 @@ static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
 	/* this may fail if the RTC hasn't been initialized */
 	status = rtc_read_time(rtc, &alm.time);
 	if (status < 0) {
-		printk(err_readtime, rtc->dev.bus_id, status);
+		printk(err_readtime, dev_name(&rtc->dev), status);
 		return;
 	}
 	rtc_tm_to_time(&alm.time, &now);
@@ -626,7 +626,7 @@ static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
 
 	status = rtc_set_alarm(rtc, &alm);
 	if (status < 0) {
-		printk(err_wakealarm, rtc->dev.bus_id, status);
+		printk(err_wakealarm, dev_name(&rtc->dev), status);
 		return;
 	}
 
@@ -660,7 +660,7 @@ static int __init has_wakealarm(struct device *dev, void *name_ptr)
 	if (!device_may_wakeup(candidate->dev.parent))
 		return 0;
 
-	*(char **)name_ptr = dev->bus_id;
+	*(const char **)name_ptr = dev_name(dev);
 	return 1;
 }
 
-- 
1.6.0.4


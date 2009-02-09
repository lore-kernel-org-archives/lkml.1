Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZBIThu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZBIThu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZBITgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:36:01 -0500
Received: from kroah.org ([198.145.64.141]:34769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757267AbZBITfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Lockwood <lockwood@android.com>
Subject: [PATCH 5/6] Staging: android: fix up units in timed_gpio
Date: Mon,  9 Feb 2009 11:34:05 -0800
Message-Id: <1234208046-2295-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090209193201.GB2194@kroah.com>
References: <20090209193201.GB2194@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last build fix I did messed up the units of the sysfs file.

This puts them back to be milliseconds, like they originally were.


Thanks to Juha Motorsportcom for pointing this out.

Reported-by: Juha Motorsportcom <juha_motorsportcom@luukku.com>
Cc: Mike Lockwood <lockwood@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/timed_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index 903270c..33daff0 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -50,7 +50,7 @@ static ssize_t gpio_enable_show(struct device *dev, struct device_attribute *att
 	if (hrtimer_active(&gpio_data->timer)) {
 		ktime_t r = hrtimer_get_remaining(&gpio_data->timer);
 		struct timeval t = ktime_to_timeval(r);
-		remaining = t.tv_sec * 1000 + t.tv_usec;
+		remaining = t.tv_sec * 1000 + t.tv_usec / 1000;
 	} else
 		remaining = 0;
 
-- 
1.6.0.2


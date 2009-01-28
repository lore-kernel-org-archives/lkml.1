Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZA1Xa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZA1Xa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZA1X2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:15 -0500
Received: from kroah.org ([198.145.64.141]:56987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756901AbZA1X2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Mike Lockwood <lockwood@android.com>
Subject: [PATCH 05/10] Staging: android: fix build error on 64bit boxes
Date: Wed, 28 Jan 2009 15:26:45 -0800
Message-Id: <1233185210-23098-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktime_t isn't ment to directly access on all arches, so use the proper
conversion functions instead to figure out what time is remaining.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Mike Lockwood <lockwood@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/timed_gpio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index b41b20e..903270c 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -49,7 +49,8 @@ static ssize_t gpio_enable_show(struct device *dev, struct device_attribute *att
 
 	if (hrtimer_active(&gpio_data->timer)) {
 		ktime_t r = hrtimer_get_remaining(&gpio_data->timer);
-		remaining = r.tv.sec * 1000 + r.tv.nsec / 1000000;
+		struct timeval t = ktime_to_timeval(r);
+		remaining = t.tv_sec * 1000 + t.tv_usec;
 	} else
 		remaining = 0;
 
-- 
1.6.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbYBNPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbYBNPnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYBNPjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:31 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49927 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753364AbYBNPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 11/14] drivers/net/wireless/atmel.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:49 +0200
Message-Id: <1203003412-11594-12-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-wireless@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 drivers/net/wireless/atmel.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 63ec7a7..ef2da40 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -66,6 +66,7 @@
 #include <linux/device.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
 #include <net/ieee80211.h>
 #include "atmel.h"
 
@@ -516,7 +517,7 @@ struct atmel_private {
 		SITE_SURVEY_IN_PROGRESS,
 		SITE_SURVEY_COMPLETED
 	} site_survey_state;
-	time_t last_survey;
+	unsigned long last_survey;
 
 	int station_was_associated, station_is_associated;
 	int fast_scan;
@@ -2283,7 +2284,7 @@ static int atmel_set_scan(struct net_device *dev,
 		return -EAGAIN;
 
 	/* Timeout old surveys. */
-	if ((jiffies - priv->last_survey) > (20 * HZ))
+	if (time_after(jiffies, priv->last_survey + 20 * HZ))
 		priv->site_survey_state = SITE_SURVEY_IDLE;
 	priv->last_survey = jiffies;
 
-- 
1.5.3.7


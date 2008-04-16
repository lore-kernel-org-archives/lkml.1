Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbYDPPck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbYDPPck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbYDPPcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:32:32 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:60109 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbYDPPcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:32:32 -0400
Message-ID: <48061C0C.2020406@tiscali.nl>
Date: Wed, 16 Apr 2008 17:32:28 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: a.zummo@towertech.it
CC: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] RTC: rtc-ds1374: fix unsigned new_alarm test
References: <480558CA.7090800@tiscali.nl> <48061AFC.9050106@tiscali.nl>
In-Reply-To: <48061AFC.9050106@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the duplicate, I forgot to fix the email header
---
New_alarm is unsigned so the test didn't work.
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 45bda18..119bdc9 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -216,16 +216,16 @@ static int ds1374_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	rtc_tm_to_time(&alarm->time, &new_alarm);
 	rtc_tm_to_time(&now, &itime);
 
-	new_alarm -= itime;
-
 	/* This can happen due to races, in addition to dates that are
 	 * truly in the past.  To avoid requiring the caller to check for
 	 * races, dates in the past are assumed to be in the recent past
 	 * (i.e. not something that we'd rather the caller know about via
 	 * an error), and the alarm is set to go off as soon as possible.
 	 */
-	if (new_alarm <= 0)
+	if (new_alarm <= itime)
 		new_alarm = 1;
+	else
+		new_alarm -= itime;
 
 	mutex_lock(&ds1374->mutex);
 


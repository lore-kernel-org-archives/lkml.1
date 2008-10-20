Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYJTTf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYJTTf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYJTTfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:35:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49588 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751415AbYJTTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:35:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] rtc: Fix handling of missing tm_year data when reading alarms
Date: Mon, 20 Oct 2008 20:35:17 +0100
Message-Id: <1224531318-10349-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081020193328.GA10272@rakim.wolfsonmicro.main>
References: <20081020193328.GA10272@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fixing up invalid years rtc_read_alarm() was calling rtc_valid_tm()
as a boolean but rtc_valid_tm() returns zero on success or a negative
number if the time is not valid so the test was inverted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/rtc/interface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 7af60b9..a04c1b6 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -271,7 +271,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (!rtc_valid_tm(&alarm->time));
+		} while (rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
-- 
1.5.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0BLV5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:57:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:36933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0BLV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=alYMNUAZ40UZD4d8xM1djudi1DenP+v4iPFOtDuKwv+OSY7uvEmx/rMOdjx2IS99P7
         QKMTWZvzRZ9PBHggnUpfU1DhNRFdXeFPRibBZeWyjrSpxqLE5qL6RsgTyeXHU3floJYs
         At+41twA0YH+2+YWOxn/O1/OLTTVeBnF9E8NQ=
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>,
       Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/4] power_supply: bq27x00: fix temperature conversion
Date: Fri, 12 Feb 2010 23:57:13 +0200
Message-Id: <1266011833-31801-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power supply class requires tenths of degree Celsius.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 3ae3e08..3da9e0a 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -74,7 +74,7 @@ static int bq27x00_read(u8 reg, int *rt_value, int b_single,
 }
 
 /*
- * Return the battery temperature in Celsius degrees
+ * Return the battery temperature in tenths of degree Celsius
  * Or < 0 if something fails.
  */
 static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
@@ -88,7 +88,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
 		return ret;
 	}
 
-	return (temp >> 2) - 273;
+	return ((temp >> 2) - 273) * 10;
 }
 
 /*
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968507Ab0B0PGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:06:51 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55764 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968485Ab0B0PGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MDo5d9fSt/vxJ15jPqHOLUOFmMEZps8q6gZfzP4CAfTBJYQM4oJ2bZtriwgkuoPT0O
         Wj25PHuh0oBhsf1qwW1XwSYqLefCV0u0b4LW353YOsAqawcsT1G2+GXxk9BZTlew64ln
         D5h5SGnAm3dmIBxQ0Nh6gLKciLZk5u7lGTNRg=
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>,
       Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/2] power_supply: bq27x00: fix voltage and current units
Date: Sat, 27 Feb 2010 17:06:44 +0200
Message-Id: <1267283204-19181-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip returns voltage and current in mV and mA, but
power supply class uses uV and uA, so add missing conversion.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 5d940fa..bece33e 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -125,7 +125,7 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
 		return ret;
 	}
 
-	return volt;
+	return volt * 1000;
 }
 
 /*
@@ -156,11 +156,11 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 		}
 		if (flags & BQ27000_FLAG_CHGS) {
 			dev_dbg(di->dev, "negative current!\n");
-			return -curr;
+			curr = -curr;
 		}
 	}
 
-	return curr;
+	return curr * 1000;
 }
 
 /*
-- 
1.6.3.3


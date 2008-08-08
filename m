Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYHHQhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYHHQhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYHHQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36082 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYHHQgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:09 -0400
Date: Fri, 8 Aug 2008 19:34:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [3/17] arm: use bcd2bin/bin2bcd
Message-ID: <20080808163435.GJ14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes arm to use the new bcd2bin/bin2bcd functions instead 
of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/arm/mach-footbridge/time.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

de3c66dd1e094cc42303a7ccb65f515fdc6c522c 
diff --git a/arch/arm/mach-footbridge/time.c b/arch/arm/mach-footbridge/time.c
index d5cfcda..6d2b1a8 100644
--- a/arch/arm/mach-footbridge/time.c
+++ b/arch/arm/mach-footbridge/time.c
@@ -49,12 +49,12 @@ static unsigned long __init get_isa_cmos_time(void)
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 	}
 	if ((year += 1900) < 1970)
 		year += 100;
@@ -76,7 +76,7 @@ static int set_isa_cmos_time(void)
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -92,8 +92,8 @@ static int set_isa_cmos_time(void)
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);


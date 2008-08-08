Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYHHQho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYHHQho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYHHQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49892 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYHHQgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:11 -0400
Date: Fri, 8 Aug 2008 19:34:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [4/17] cris: use bcd2bin/bin2bcd
Message-ID: <20080808163436.GK14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes cris to use the new bcd2bin/bin2bcd functions instead 
of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/cris/arch-v10/drivers/ds1302.c  |   24 ++++++++++++------------
 arch/cris/arch-v10/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/arch-v32/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/kernel/time.c              |   18 +++++++++---------
 4 files changed, 45 insertions(+), 45 deletions(-)

c694119299bf04f3e43e5df419cde78ea385d411 
diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index c9aa390..3bdfaf4 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -215,12 +215,12 @@ get_rtc_time(struct rtc_time *rtc_tm)
 
 	local_irq_restore(flags);
 	
-	BCD_TO_BIN(rtc_tm->tm_sec);
-	BCD_TO_BIN(rtc_tm->tm_min);
-	BCD_TO_BIN(rtc_tm->tm_hour);
-	BCD_TO_BIN(rtc_tm->tm_mday);
-	BCD_TO_BIN(rtc_tm->tm_mon);
-	BCD_TO_BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -295,12 +295,12 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			else
 				yrs -= 1900;	/* RTC (70, 71, ... 99) */
 
-			BIN_TO_BCD(sec);
-			BIN_TO_BCD(min);
-			BIN_TO_BCD(hrs);
-			BIN_TO_BCD(day);
-			BIN_TO_BCD(mon);
-			BIN_TO_BCD(yrs);
+			sec = bin2bcd(sec);
+			min = bin2bcd(min);
+			hrs = bin2bcd(hrs);
+			day = bin2bcd(day);
+			mon = bin2bcd(mon);
+			yrs = bin2bcd(yrs);
 
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 8769dc9..1e90c1a 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -122,7 +122,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -131,11 +131,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -282,12 +282,12 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index f263ab5..f447850 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -118,7 +118,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -127,11 +127,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -279,12 +279,12 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index ff4c6aa..074fe7d 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -127,7 +127,7 @@ int set_rtc_mmss(unsigned long nowtime)
 		return 0;
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	BCD_TO_BIN(cmos_minutes);
+	cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -142,8 +142,8 @@ int set_rtc_mmss(unsigned long nowtime)
 	real_minutes %= 60;
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
-		BIN_TO_BCD(real_seconds);
-		BIN_TO_BCD(real_minutes);
+		real_seconds = bin2bcd(real_seconds);
+		real_minutes = bin2bcd(real_minutes);
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
@@ -170,12 +170,12 @@ get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	BCD_TO_BIN(sec);
-	BCD_TO_BIN(min);
-	BCD_TO_BIN(hour);
-	BCD_TO_BIN(day);
-	BCD_TO_BIN(mon);
-	BCD_TO_BIN(year);
+	sec = bcd2bin(sec);
+	min = bcd2bin(min);
+	hour = bcd2bin(hour);
+	day = bcd2bin(day);
+	mon = bcd2bin(mon);
+	year = bcd2bin(year);
 
 	if ((year += 1900) < 1970)
 		year += 100;


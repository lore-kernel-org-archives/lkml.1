Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYHHQkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYHHQkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbYHHQga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36107 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbYHHQg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:28 -0400
Date: Fri, 8 Aug 2008 19:34:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: paulus@samba.org, benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [12/17] powerpc: use bcd2bin/bin2bcd
Message-ID: <20080808163453.GS14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes powerpc to use the new bcd2bin/bin2bcd functions 
instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/powerpc/platforms/chrp/time.c  |   24 ++++++++++++------------
 arch/powerpc/platforms/iseries/mf.c |   26 +++++++++++++-------------
 arch/powerpc/platforms/maple/time.c |   24 ++++++++++++------------
 3 files changed, 37 insertions(+), 37 deletions(-)

e6d9f2f91ed9e6b761aba2754ec5339b4c76beed 
diff --git a/arch/powerpc/platforms/chrp/time.c b/arch/powerpc/platforms/chrp/time.c
index 96d1e4b..054dfe5 100644
--- a/arch/powerpc/platforms/chrp/time.c
+++ b/arch/powerpc/platforms/chrp/time.c
@@ -94,12 +94,12 @@ int chrp_set_rtc_time(struct rtc_time *tmarg)
 	chrp_cmos_clock_write((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(tm.tm_sec);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_year);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_year = bin2bcd(tm.tm_year);
 	}
 	chrp_cmos_clock_write(tm.tm_sec,RTC_SECONDS);
 	chrp_cmos_clock_write(tm.tm_min,RTC_MINUTES);
@@ -136,12 +136,12 @@ void chrp_get_rtc_time(struct rtc_time *tm)
 	} while (sec != chrp_cmos_clock_read(RTC_SECONDS));
 
 	if (!(chrp_cmos_clock_read(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
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
 	if (year < 70)
 		year += 100;
diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 1dc7295..8dfc78e 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -722,13 +722,13 @@ static int mf_set_rtc(struct rtc_time *tm)
 	day = tm->tm_mday;
 	mon = tm->tm_mon + 1;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hour);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(y1);
-	BIN_TO_BCD(y2);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hour = bin2bcd(hour);
+	mon = bin2bcd(mon);
+	day = bin2bcd(day);
+	y1 = bin2bcd(y1);
+	y2 = bin2bcd(y2);
 
 	memset(ce_time, 0, sizeof(ce_time));
 	ce_time[3] = 0x41;
@@ -777,12 +777,12 @@ static int rtc_set_tm(int rc, u8 *ce_msg, struct rtc_time *tm)
 		u8 day = ce_msg[10];
 		u8 mon = ce_msg[11];
 
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
 
 		if (year <= 69)
 			year += 100;
diff --git a/arch/powerpc/platforms/maple/time.c b/arch/powerpc/platforms/maple/time.c
index 53bca13..eac569d 100644
--- a/arch/powerpc/platforms/maple/time.c
+++ b/arch/powerpc/platforms/maple/time.c
@@ -68,12 +68,12 @@ void maple_get_rtc_time(struct rtc_time *tm)
 
 	if (!(maple_clock_read(RTC_CONTROL) & RTC_DM_BINARY)
 	    || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(tm->tm_sec);
-		BCD_TO_BIN(tm->tm_min);
-		BCD_TO_BIN(tm->tm_hour);
-		BCD_TO_BIN(tm->tm_mday);
-		BCD_TO_BIN(tm->tm_mon);
-		BCD_TO_BIN(tm->tm_year);
+		tm->tm_sec = bcd2bin(tm->tm_sec);
+		tm->tm_min = bcd2bin(tm->tm_min);
+		tm->tm_hour = bcd2bin(tm->tm_hour);
+		tm->tm_mday = bcd2bin(tm->tm_mday);
+		tm->tm_mon = bcd2bin(tm->tm_mon);
+		tm->tm_year = bcd2bin(tm->tm_year);
 	  }
 	if ((tm->tm_year + 1900) < 1970)
 		tm->tm_year += 100;
@@ -104,12 +104,12 @@ int maple_set_rtc_time(struct rtc_time *tm)
 	year = tm->tm_year;
 
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(sec);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(hour);
-		BIN_TO_BCD(mon);
-		BIN_TO_BCD(mday);
-		BIN_TO_BCD(year);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hour = bin2bcd(hour);
+		mon = bin2bcd(mon);
+		mday = bin2bcd(mday);
+		year = bin2bcd(year);
 	}
 	maple_clock_write(sec, RTC_SECONDS);
 	maple_clock_write(min, RTC_MINUTES);


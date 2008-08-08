Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYHHQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYHHQgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYHHQgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48004 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbYHHQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:08 -0400
Date: Fri, 8 Aug 2008 19:34:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [2/17] alpha: use bcd2bin/bin2bcd
Message-ID: <20080808163433.GI14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes alpha to use the new bcd2bin/bin2bcd functions 
instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/alpha/kernel/core_marvel.c |    4 ++--
 arch/alpha/kernel/time.c        |   18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

b917dc58f9fd065acf295b6c83ac30ed5a57ef2b 
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 04dcc5e..9cd8dca 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -655,7 +655,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 
 	case 0x71:					/* RTC_PORT(1) */
 		rtc_access.index = index;
-		rtc_access.data = BCD_TO_BIN(b);
+		rtc_access.data = bcd2bin(b);
 		rtc_access.function = 0x48 + !write;	/* GET/PUT_TOY */
 
 #ifdef CONFIG_SMP
@@ -668,7 +668,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 #else
 		__marvel_access_rtc(&rtc_access);
 #endif
-		ret = BIN_TO_BCD(rtc_access.data);
+		ret = bin2bcd(rtc_access.data);
 		break;
 
 	default:
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 75480ca..e6a2314 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -346,12 +346,12 @@ time_init(void)
 	year = CMOS_READ(RTC_YEAR);
 
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
 
 	/* PC-like is standard; used for year >= 70 */
@@ -525,7 +525,7 @@ set_rtc_mmss(unsigned long nowtime)
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -543,8 +543,8 @@ set_rtc_mmss(unsigned long nowtime)
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);


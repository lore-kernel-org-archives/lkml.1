Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYHHQkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYHHQkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757986AbYHHQg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48027 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbYHHQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:26 -0400
Date: Fri, 8 Aug 2008 19:34:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [11/17] mn10300: use bcd2bin/bin2bcd
Message-ID: <20080808163452.GR14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes mn10300 to use the new bcd2bin/bin2bcd functions 
instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mn10300/kernel/rtc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

194906d923ff1afdb03e053bef7393bda888e49c 
diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 042f792..7978470 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -67,7 +67,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -84,8 +84,8 @@ static int set_rtc_mmss(unsigned long nowtime)
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);


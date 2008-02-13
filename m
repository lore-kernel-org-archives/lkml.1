Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbYBMVj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbYBMVj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYBMVad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:33 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50807 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbYBMVab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:31 -0500
Date: Wed, 13 Feb 2008 23:30:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andy Sharp <andy.sharp@onstor.com>, a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ds1511_rtc_{read,set}_time() static
Message-ID: <20080213213015.GZ3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ds1511_rtc_{read,set}_time() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/rtc/rtc-ds1511.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

2ca22d827507d309cfd7182b9360d1edca531072 diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index d74b808..d82fd71 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -181,8 +181,7 @@ ds1511_wdog_disable(void)
  * stupidly, some callers call with year unmolested;
  * and some call with  year = year - 1900.  thanks.
  */
- int
-ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
+static int ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	u8 mon, day, dow, hrs, min, sec, yrs, cen;
 	unsigned int flags;
@@ -245,8 +244,7 @@ ds1511_rtc_set_time(struct device *dev, struct rtc_time *rtc_tm)
 	return 0;
 }
 
- int
-ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
+static int ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	unsigned int century;
 	unsigned int flags;


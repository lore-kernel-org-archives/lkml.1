Return-Path: <linux-kernel-owner+w=401wt.eu-S1946613AbXBIQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946613AbXBIQlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946656AbXBIQkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:60833 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946613AbXBIQki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:38 -0500
Date: Fri, 9 Feb 2007 17:40:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] DS1302: local_irq_disable() is redundant after local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702091735560.22290@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702091739290.22290@jikos.suse.cz>
References: <Pine.LNX.4.64.0702091735560.22290@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DS1302: local_irq_disable() is redundant after local_irq_save()

drivers/char/ds1302.c::get_rtc_time() contains local_irq_disable() call 
after local_irq_save(). This looks redundant.

drivers/char/ds1302.c::rtc_ioctl() contains local_irq_disable() call after 
local_irq_save(). This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/char/ds1302.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index bcdb107..fada6dd 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -120,7 +120,6 @@ get_rtc_time(struct rtc_time *rtc_tm)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	rtc_tm->tm_sec = CMOS_READ(RTC_SECONDS);
 	rtc_tm->tm_min = CMOS_READ(RTC_MINUTES);
@@ -219,7 +218,6 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			BIN_TO_BCD(yrs);
 
 			local_irq_save(flags);
-			local_irq_disable();
 			CMOS_WRITE(yrs, RTC_YEAR);
 			CMOS_WRITE(mon, RTC_MONTH);
 			CMOS_WRITE(day, RTC_DAY_OF_MONTH);

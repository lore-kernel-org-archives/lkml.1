Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbXKWKKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbXKWKKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbXKWKIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:08:44 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:7015 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXKWKIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:08:41 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="56898552:sNHT28019320"
From: Bryan Wu <bryan.wu@analog.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/7] Blackfin RTC driver: cleanup proc handler (we dont need RTC reg dump now that we have MMR filesystem in sysfs)
Date: Fri, 23 Nov 2007 18:08:28 +0800
Message-Id: <1195812512-25979-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
References: <1195812512-25979-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/rtc/rtc-bfin.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 2a801f2..343f284 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -45,7 +45,7 @@
 
 #include <asm/blackfin.h>
 
-#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __FUNCTION__, __LINE__, ## args)
+#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
 
 struct bfin_rtc {
@@ -343,22 +343,20 @@ static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-#define yesno(x) (x ? "yes" : "no")
+#define yesno(x) ((x) ? "yes" : "no")
 	u16 ictl = bfin_read_RTC_ICTL();
 	stampit();
-	seq_printf(seq, "alarm_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_ALARM));
-	seq_printf(seq, "wkalarm_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_ALARM_DAY));
-	seq_printf(seq, "seconds_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_SEC));
-	seq_printf(seq, "periodic_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_STOPWATCH));
-#ifdef DEBUG
-	seq_printf(seq, "RTC_STAT\t: 0x%08X\n", bfin_read_RTC_STAT());
-	seq_printf(seq, "RTC_ICTL\t: 0x%04X\n", bfin_read_RTC_ICTL());
-	seq_printf(seq, "RTC_ISTAT\t: 0x%04X\n", bfin_read_RTC_ISTAT());
-	seq_printf(seq, "RTC_SWCNT\t: 0x%04X\n", bfin_read_RTC_SWCNT());
-	seq_printf(seq, "RTC_ALARM\t: 0x%08X\n", bfin_read_RTC_ALARM());
-	seq_printf(seq, "RTC_PREN\t: 0x%04X\n", bfin_read_RTC_PREN());
-#endif
+	seq_printf(seq,
+		"alarm_IRQ\t: %s\n"
+		"wkalarm_IRQ\t: %s\n"
+		"seconds_IRQ\t: %s\n"
+		"periodic_IRQ\t: %s\n",
+		yesno(ictl & RTC_ISTAT_ALARM),
+		yesno(ictl & RTC_ISTAT_ALARM_DAY),
+		yesno(ictl & RTC_ISTAT_SEC),
+		yesno(ictl & RTC_ISTAT_STOPWATCH));
 	return 0;
+#undef yesno
 }
 
 /**
-- 
1.5.3.4

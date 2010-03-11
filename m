Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0CKUKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:10:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:29682 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab0CKUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:10:40 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: mach-sa1100: fix checkpatch.pl issues.
Date: Thu, 11 Mar 2010 17:10:22 -0300
Message-Id: <1268338225-32253-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl issues in drivers/rtc/rtc-sa1100.c,
which I will later mofify.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index e4a44b6..e19ed0f 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -39,7 +39,7 @@
 #include <mach/regs-ost.h>
 #endif
 
-#define RTC_DEF_DIVIDER		32768 - 1
+#define RTC_DEF_DIVIDER		(32768 - 1)
 #define RTC_DEF_TRIM		0
 
 static unsigned long rtc_freq = 1024;
@@ -61,7 +61,8 @@ static inline int rtc_periodic_alarm(struct rtc_time *tm)
  * Calculate the next alarm time given the requested alarm time mask
  * and the current time.
  */
-static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now, struct rtc_time *alrm)
+static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
+	struct rtc_time *alrm)
 {
 	unsigned long next_time;
 	unsigned long now_time;
@@ -178,7 +179,7 @@ static int sa1100_rtc_read_callback(struct device *dev, int data)
 		 * Here we compare (match - OSCR) 8 instead of 0 --
 		 * see comment in pxa_timer_interrupt() for explanation.
 		 */
-		while( (signed long)((osmr1 = OSMR1) - OSCR) <= 8 ) {
+		while ((signed long)((osmr1 = OSMR1) - OSCR) <= 8) {
 			data += 0x100;
 			OSSR = OSSR_M1;	/* clear match on timer 1 */
 			OSMR1 = osmr1 + period;
@@ -192,19 +193,19 @@ static int sa1100_rtc_open(struct device *dev)
 	int ret;
 
 	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
-				"rtc 1Hz", dev);
+		"rtc 1Hz", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
 		goto fail_ui;
 	}
 	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, IRQF_DISABLED,
-				"rtc Alrm", dev);
+		"rtc Alrm", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 		goto fail_ai;
 	}
 	ret = request_irq(IRQ_OST1, timer1_interrupt, IRQF_DISABLED,
-				"rtc timer", dev);
+		"rtc timer", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_OST1);
 		goto fail_pi;
@@ -236,7 +237,7 @@ static void sa1100_rtc_release(struct device *dev)
 static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 		unsigned long arg)
 {
-	switch(cmd) {
+	switch (cmd) {
 	case RTC_AIE_OFF:
 		spin_lock_irq(&sa1100_rtc_lock);
 		RTSR &= ~RTSR_ALE;
@@ -364,7 +365,8 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	 */
 	if (RTTR == 0) {
 		RTTR = RTC_DEF_DIVIDER + (RTC_DEF_TRIM << 16);
-		dev_warn(&pdev->dev, "warning: initializing default clock divider/trim value\n");
+		dev_warn(&pdev->dev, "warning: "
+			"initializing default clock divider/trim value\n");
 		/* The current RTC value probably doesn't make sense either */
 		RCNR = 0;
 	}
@@ -386,7 +388,7 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
- 	if (rtc)
+	if (rtc)
 		rtc_device_unregister(rtc);
 
 	return 0;
-- 
1.7.0.1


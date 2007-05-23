Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbXEXBMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbXEXBMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbXEXBMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:12:12 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:1608 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756792AbXEXBML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:12:11 -0400
X-Greylist: delayed 3559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 21:12:11 EDT
To: linux-kernel@vger.kernel.org
Message-Id: <e5ea703bf068a19cc9a4cc76a9b6b8990380ee75.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:23:06 -0400
Subject: [PATCH 4/6] RTC: Ratelimit "lost interrupts" message
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 drivers/char/rtc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 20380a2..22cf7aa 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -1159,7 +1159,8 @@ static void rtc_dropped_irq(unsigned long data)
 
 	spin_unlock_irq(&rtc_lock);
 
-	printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
+	if (printk_ratelimit())
+		printk(KERN_WARNING "rtc: lost some interrupts at %ldHz.\n", freq);
 
 	/* Now we have new data */
 	wake_up_interruptible(&rtc_wait);
-- 
1.5.1.4


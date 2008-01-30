Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbYA3Jih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbYA3Jih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbYA3Ji0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:38:26 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:34029 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYA3JiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:38:25 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61205078"
From: Bryan Wu <bryan.wu@analog.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [Blackfin] Watchdog driver: relocate all strings used in __init functions to __initdata
Date: Wed, 30 Jan 2008 17:38:21 +0800
Message-Id: <1201685901-29364-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/watchdog/bfin_wdt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 472be10..1237113 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -29,6 +29,7 @@
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
+#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
 #define PFX WATCHDOG_NAME ": "
@@ -445,19 +446,19 @@ static int __init bfin_wdt_init(void)
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_init(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		pr_init(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
 
-	printk(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
+	pr_init(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
 	       timeout, nowayout);
 
 	return 0;
-- 
1.5.3.4

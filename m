Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbXHSNbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbXHSNbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXHSNbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:31:41 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:60758 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbXHSNbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:31:40 -0400
Date: Sun, 19 Aug 2007 22:32:56 +0900 (JST)
Message-Id: <20070819.223256.72707398.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net, ralf@linux-mips.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Torsten Ertbjerg Rasmussen <tr@newtec.dk>
Subject: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware (take 2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-ds1742 platform driver name doesn't match its module name,
which might prevents it from properly hotplugging.  There is only two
in-tree user of its driver, which are fixed by this patch too.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 arch/mips/jmr3927/rbhma3100/setup.c                |    2 +-
 .../toshiba_rbtx4927/toshiba_rbtx4927_setup.c      |    2 +-
 drivers/rtc/rtc-ds1742.c                           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/jmr3927/rbhma3100/setup.c b/arch/mips/jmr3927/rbhma3100/setup.c
index fde56e8..ffae163 100644
--- a/arch/mips/jmr3927/rbhma3100/setup.c
+++ b/arch/mips/jmr3927/rbhma3100/setup.c
@@ -427,7 +427,7 @@ static int __init jmr3927_rtc_init(void)
 		.flags	= IORESOURCE_MEM,
 	};
 	struct platform_device *dev;
-	dev = platform_device_register_simple("ds1742", -1, &res, 1);
+	dev = platform_device_register_simple("rtc-ds1742", -1, &res, 1);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(jmr3927_rtc_init);
diff --git a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
index 3e84237..91bd3d1 100644
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
+++ b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -969,7 +969,7 @@ static int __init toshiba_rbtx4927_rtc_init(void)
 		.flags	= IORESOURCE_MEM,
 	};
 	struct platform_device *dev =
-		platform_device_register_simple("ds1742", -1, &res, 1);
+		platform_device_register_simple("rtc-ds1742", -1, &res, 1);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(toshiba_rbtx4927_rtc_init);
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index b2e5481..5562830 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -251,7 +251,7 @@ static struct platform_driver ds1742_rtc_driver = {
 	.probe		= ds1742_rtc_probe,
 	.remove		= __devexit_p(ds1742_rtc_remove),
 	.driver		= {
-		.name	= "ds1742",
+		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
 	},
 };

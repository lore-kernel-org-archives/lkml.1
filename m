Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYDIWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYDIWp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYDIWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:45:15 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:29529 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753155AbYDIWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:45:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kNxzxYgHlx7s4f7UVq8dkCvxFQS1cMn0SWyjeHdDHsU/4crEneLgWU3iUaiboS+3do+HHbH0alF+BXh+zPCBcAB3bPZ1ntdI/eU7DaUfZZKfsgqyp5NkQHrPtbl0tXxUR2UgE7ijDojoldR2srPw/Z93o+l0rUilBPa/hgC0IiA=  ;
X-YMail-OSG: DSIHMg8VM1nbpRFDBZhC6Bz3_BPlPWM30CNynSxua7_msb6POhBpXWbgRtK.uqUQhjkGnWS3vA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [patch 2.6.25-rc8] watchdog: fix platform driver hotplug/coldplug
Date: Wed, 9 Apr 2008 15:45:09 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091545.10206.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable watchdog drivers, to re-enable auto loading.

[ dbrownell@users.sourceforge.net: more drivers; registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc:  Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/at32ap700x_wdt.c |    3 +++
 drivers/watchdog/at91rm9200_wdt.c |    1 +
 drivers/watchdog/davinci_wdt.c    |    2 ++
 drivers/watchdog/ks8695_wdt.c     |    1 +
 drivers/watchdog/mpc83xx_wdt.c    |    2 ++
 drivers/watchdog/mpcore_wdt.c     |    3 +++
 drivers/watchdog/mtx-1_wdt.c      |    2 ++
 drivers/watchdog/mv64x60_wdt.c    |    1 +
 drivers/watchdog/omap_wdt.c       |    1 +
 drivers/watchdog/pnx4008_wdt.c    |    2 ++
 drivers/watchdog/s3c2410_wdt.c    |    1 +
 drivers/watchdog/txx9wdt.c        |    1 +
 12 files changed, 20 insertions(+)

--- g26.orig/drivers/watchdog/at32ap700x_wdt.c	2008-04-09 15:19:13.000000000 -0700
+++ g26/drivers/watchdog/at32ap700x_wdt.c	2008-04-09 15:20:48.000000000 -0700
@@ -418,6 +418,9 @@ static int at32_wdt_resume(struct platfo
 #define at32_wdt_resume NULL
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:at32_wdt");
+
 static struct platform_driver at32_wdt_driver = {
 	.remove		= __exit_p(at32_wdt_remove),
 	.suspend	= at32_wdt_suspend,
--- g26.orig/drivers/watchdog/at91rm9200_wdt.c	2008-04-09 15:16:18.000000000 -0700
+++ g26/drivers/watchdog/at91rm9200_wdt.c	2008-04-09 15:18:34.000000000 -0700
@@ -286,3 +286,4 @@ MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91RM9200");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:at91_wdt");
--- g26.orig/drivers/watchdog/davinci_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/davinci_wdt.c	2008-04-09 15:25:44.000000000 -0700
@@ -248,6 +248,7 @@ static int davinci_wdt_remove(struct pla
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
+		.owner	= THIS_MODULE,
 	},
 	.probe = davinci_wdt_probe,
 	.remove = davinci_wdt_remove,
@@ -277,3 +278,4 @@ MODULE_PARM_DESC(heartbeat,
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:watchdog");
--- g26.orig/drivers/watchdog/ks8695_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/ks8695_wdt.c	2008-04-09 15:18:34.000000000 -0700
@@ -306,3 +306,4 @@ MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for KS8695");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:ks8695_wdt");
--- g26.orig/drivers/watchdog/mpc83xx_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/mpc83xx_wdt.c	2008-04-09 15:27:38.000000000 -0700
@@ -206,6 +206,7 @@ static struct platform_driver mpc83xx_wd
 	.remove		= __devexit_p(mpc83xx_wdt_remove),
 	.driver		= {
 		.name	= "mpc83xx_wdt",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -226,3 +227,4 @@ MODULE_AUTHOR("Dave Updegraff, Kumar Gal
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:mpc83xx_wdt");
--- g26.orig/drivers/watchdog/mpcore_wdt.c	2008-04-09 15:19:13.000000000 -0700
+++ g26/drivers/watchdog/mpcore_wdt.c	2008-04-09 15:28:17.000000000 -0700
@@ -392,6 +392,9 @@ static int __devexit mpcore_wdt_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:mpcore_wdt");
+
 static struct platform_driver mpcore_wdt_driver = {
 	.probe		= mpcore_wdt_probe,
 	.remove		= __devexit_p(mpcore_wdt_remove),
--- g26.orig/drivers/watchdog/mtx-1_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/mtx-1_wdt.c	2008-04-09 15:28:37.000000000 -0700
@@ -243,6 +243,7 @@ static struct platform_driver mtx1_wdt =
 	.probe = mtx1_wdt_probe,
 	.remove = mtx1_wdt_remove,
 	.driver.name = "mtx1-wdt",
+	.driver.owner = THIS_MODULE,
 };
 
 static int __init mtx1_wdt_init(void)
@@ -262,3 +263,4 @@ MODULE_AUTHOR("Michael Stickel, Florian 
 MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:mtx1-wdt");
--- g26.orig/drivers/watchdog/mv64x60_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/mv64x60_wdt.c	2008-04-09 15:30:30.000000000 -0700
@@ -324,3 +324,4 @@ MODULE_AUTHOR("James Chapman <jchapman@k
 MODULE_DESCRIPTION("MV64x60 watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:" MV64x60_WDT_NAME);
--- g26.orig/drivers/watchdog/omap_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/omap_wdt.c	2008-04-09 15:18:34.000000000 -0700
@@ -387,3 +387,4 @@ module_exit(omap_wdt_exit);
 MODULE_AUTHOR("George G. Davis");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:omap_wdt");
--- g26.orig/drivers/watchdog/pnx4008_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/pnx4008_wdt.c	2008-04-09 15:30:49.000000000 -0700
@@ -321,6 +321,7 @@ static int pnx4008_wdt_remove(struct pla
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
+		.owner	= THIS_MODULE,
 	},
 	.probe = pnx4008_wdt_probe,
 	.remove = pnx4008_wdt_remove,
@@ -354,3 +355,4 @@ MODULE_PARM_DESC(nowayout,
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:watchdog");
--- g26.orig/drivers/watchdog/s3c2410_wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/s3c2410_wdt.c	2008-04-09 15:18:34.000000000 -0700
@@ -561,3 +561,4 @@ MODULE_AUTHOR("Ben Dooks <ben@simtec.co.
 MODULE_DESCRIPTION("S3C2410 Watchdog Device Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:s3c2410-wdt");
--- g26.orig/drivers/watchdog/txx9wdt.c	2008-04-09 15:16:17.000000000 -0700
+++ g26/drivers/watchdog/txx9wdt.c	2008-04-09 15:18:34.000000000 -0700
@@ -274,3 +274,4 @@ module_exit(watchdog_exit);
 MODULE_DESCRIPTION("TXx9 Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:txx9wdt");

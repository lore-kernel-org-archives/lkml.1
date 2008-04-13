Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYDMRXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYDMRXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYDMRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:23:07 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:26623 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750953AbYDMRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:23:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6VnEGj8SLLpGr1Iu7k3Z76ZOEHUBiMw/sllp3nkbZBcyZmjz4iMFRRfUeYjv5MsPM23XWZHET+ubhs3HUIm4pAPAep5Iu4AfZ2e0OEeq2CE70fLLHdr9jhJRPUyUDB3yS93WU8uPUt7dyLpFuiRH4QoDLbCcR5c/EBK+xMdT71U=  ;
X-YMail-OSG: gdjXdRsVM1mQfyrFToS6QOQcroaJNcXilie1Jv5Q7rwXtHF3lMX5JAA9II2m5psCxJZMAfg85w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc9] misc: fix platform driver hotplug/coldplug
Date: Sun, 13 Apr 2008 10:06:52 -0700
User-Agent: KMail/1.9.6
Cc: kay.sievers@vrfy.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131006.52988.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable 'misc' platform drivers, to re-enable auto loading.

[ dbrownell@users.sourceforge.net:  bugfix, registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/misc/atmel-ssc.c              |    2 ++
 drivers/misc/atmel_pwm.c              |    1 +
 drivers/misc/hdpuftrs/hdpu_cpustate.c |    2 ++
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    2 ++
 4 files changed, 7 insertions(+)

--- g26.orig/drivers/misc/atmel-ssc.c	2008-04-12 21:25:41.000000000 -0700
+++ g26/drivers/misc/atmel-ssc.c	2008-04-12 21:27:37.000000000 -0700
@@ -154,6 +154,7 @@ static struct platform_driver ssc_driver
 	.remove		= __devexit_p(ssc_remove),
 	.driver		= {
 		.name		= "ssc",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -172,3 +173,4 @@ module_exit(ssc_exit);
 MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
 MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ssc");
--- g26.orig/drivers/misc/atmel_pwm.c	2008-04-12 21:25:41.000000000 -0700
+++ g26/drivers/misc/atmel_pwm.c	2008-04-12 21:26:11.000000000 -0700
@@ -407,3 +407,4 @@ module_exit(pwm_exit);
 
 MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_pwm");
--- g26.orig/drivers/misc/hdpuftrs/hdpu_cpustate.c	2008-04-12 21:25:41.000000000 -0700
+++ g26/drivers/misc/hdpuftrs/hdpu_cpustate.c	2008-04-12 21:49:25.000000000 -0700
@@ -164,6 +164,7 @@ static struct platform_driver hdpu_cpust
 	.remove = hdpu_cpustate_remove,
 	.driver = {
 		.name = HDPU_CPUSTATE_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -248,3 +249,4 @@ module_exit(cpustate_exit);
 
 MODULE_AUTHOR("Brian Waite");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" HDPU_CPUSTATE_NAME);
--- g26.orig/drivers/misc/hdpuftrs/hdpu_nexus.c	2008-04-12 21:25:41.000000000 -0700
+++ g26/drivers/misc/hdpuftrs/hdpu_nexus.c	2008-04-12 21:34:19.000000000 -0700
@@ -55,6 +55,7 @@ static struct platform_driver hdpu_nexus
 	.remove = hdpu_nexus_remove,
 	.driver = {
 		.name = HDPU_NEXUS_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -151,3 +152,4 @@ module_exit(nexus_exit);
 
 MODULE_AUTHOR("Brian Waite");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" HDPU_NEXUS_NAME);

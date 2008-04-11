Return-Path: <linux-kernel-owner+w=401wt.eu-S1762199AbYDKRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762199AbYDKRip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbYDKRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:38:38 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27774 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760582AbYDKRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:38:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DkFJjYUENb+jri9d0jEeYzjOPfE31HCXASozhYj8npbS6tw17GvfeJYiXztpRPn1jTRv2eBO8gAIdOOfiYaKwFtI1Pcw+aEv7YAf8DG9m9ddRrwyPQEwTFXgigelaa3Xjzn02FKZP9L8O5C17LzTBvu24sA3pocecRsg2VdBHsQ=  ;
X-YMail-OSG: rJXsA.gVM1n.0i3TnnS.kLEl3.f9SkSDa9hsicmKjT5N1VQPqmIAxPpJlxerSgx8teqTbpuk5g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Richard Purdie <rpurdie@rpsys.net>, lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.25-rc8] leds: fix platform driver hotplug/coldplug
Date: Fri, 11 Apr 2008 10:38:34 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111038.34879.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable platform LED drivers, to re-enable auto loading.

[ dbrownell@users.sourceforge.net: more drivers, registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/leds/leds-ams-delta.c   |    2 ++
 drivers/leds/leds-atmel-pwm.c   |    3 +++
 drivers/leds/leds-clevo-mail.c  |    1 +
 drivers/leds/leds-cm-x270.c     |    2 ++
 drivers/leds/leds-cobalt-qube.c |    3 +++
 drivers/leds/leds-corgi.c       |    2 ++
 drivers/leds/leds-gpio.c        |    1 +
 drivers/leds/leds-h1940.c       |    2 ++
 drivers/leds/leds-hp6xx.c       |    4 ++++
 drivers/leds/leds-s3c24xx.c     |    1 +
 drivers/leds/leds-spitz.c       |    2 ++
 drivers/leds/leds-tosa.c        |    2 ++
 12 files changed, 25 insertions(+)

--- g26.orig/drivers/leds/leds-ams-delta.c	2008-04-11 10:22:44.000000000 -0700
+++ g26/drivers/leds/leds-ams-delta.c	2008-04-11 10:26:21.000000000 -0700
@@ -140,6 +140,7 @@ static struct platform_driver ams_delta_
 	.resume		= ams_delta_led_resume,
 	.driver		= {
 		.name = "ams-delta-led",
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -159,3 +160,4 @@ module_exit(ams_delta_led_exit);
 MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
 MODULE_DESCRIPTION("Amstrad Delta LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ams-delta-led");
--- g26.orig/drivers/leds/leds-cm-x270.c	2008-04-11 10:22:43.000000000 -0700
+++ g26/drivers/leds/leds-cm-x270.c	2008-04-11 10:28:11.000000000 -0700
@@ -101,6 +101,7 @@ static struct platform_driver cmx270led_
 #endif
 	.driver		= {
 		.name		= "cm-x270-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -120,3 +121,4 @@ module_exit(cmx270led_exit);
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_DESCRIPTION("CM-x270 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:cm-x270-led");
--- g26.orig/drivers/leds/leds-corgi.c	2008-04-11 10:22:43.000000000 -0700
+++ g26/drivers/leds/leds-corgi.c	2008-04-11 10:29:14.000000000 -0700
@@ -99,6 +99,7 @@ static struct platform_driver corgiled_d
 #endif
 	.driver		= {
 		.name		= "corgi-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -118,3 +119,4 @@ module_exit(corgiled_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
 MODULE_DESCRIPTION("Corgi LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:corgi-led");
--- g26.orig/drivers/leds/leds-gpio.c	2008-04-11 10:22:43.000000000 -0700
+++ g26/drivers/leds/leds-gpio.c	2008-04-11 10:25:27.000000000 -0700
@@ -199,3 +199,4 @@ module_exit(gpio_led_exit);
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-gpio");
--- g26.orig/drivers/leds/leds-h1940.c	2008-04-11 10:22:44.000000000 -0700
+++ g26/drivers/leds/leds-h1940.c	2008-04-11 10:29:43.000000000 -0700
@@ -139,6 +139,7 @@ static int h1940leds_remove(struct platf
 static struct platform_driver h1940leds_driver = {
 	.driver		= {
 		.name	= "h1940-leds",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= h1940leds_probe,
 	.remove		= h1940leds_remove,
@@ -161,3 +162,4 @@ module_exit(h1940leds_exit);
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("LED driver for the iPAQ H1940");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:h1940-leds");
--- g26.orig/drivers/leds/leds-s3c24xx.c	2008-04-11 10:22:44.000000000 -0700
+++ g26/drivers/leds/leds-s3c24xx.c	2008-04-11 10:25:28.000000000 -0700
@@ -160,3 +160,4 @@ module_exit(s3c24xx_led_exit);
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C24XX LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c24xx_led");
--- g26.orig/drivers/leds/leds-spitz.c	2008-04-11 10:22:44.000000000 -0700
+++ g26/drivers/leds/leds-spitz.c	2008-04-11 10:30:29.000000000 -0700
@@ -105,6 +105,7 @@ static struct platform_driver spitzled_d
 #endif
 	.driver		= {
 		.name		= "spitz-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -124,3 +125,4 @@ module_exit(spitzled_exit);
 MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
 MODULE_DESCRIPTION("Spitz LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:spitz-led");
--- g26.orig/drivers/leds/leds-tosa.c	2008-04-11 10:22:44.000000000 -0700
+++ g26/drivers/leds/leds-tosa.c	2008-04-11 10:30:39.000000000 -0700
@@ -109,6 +109,7 @@ static struct platform_driver tosaled_dr
 	.resume		= tosaled_resume,
 	.driver		= {
 		.name		= "tosa-led",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -128,3 +129,4 @@ module_exit(tosaled_exit);
 MODULE_AUTHOR("Dirk Opfer <Dirk@Opfer-Online.de>");
 MODULE_DESCRIPTION("Tosa LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:tosa-led");
--- g26.orig/drivers/leds/leds-atmel-pwm.c	2008-04-11 10:25:34.000000000 -0700
+++ g26/drivers/leds/leds-atmel-pwm.c	2008-04-11 10:27:12.000000000 -0700
@@ -132,6 +132,9 @@ static int __exit pwmled_remove(struct p
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:leds-atmel-pwm");
+
 static struct platform_driver pwmled_driver = {
 	.driver = {
 		.name =		"leds-atmel-pwm",
--- g26.orig/drivers/leds/leds-clevo-mail.c	2008-04-11 10:25:34.000000000 -0700
+++ g26/drivers/leds/leds-clevo-mail.c	2008-04-11 10:27:54.000000000 -0700
@@ -170,6 +170,7 @@ static struct platform_driver clevo_mail
 	.resume		= clevo_mail_led_resume,
 	.driver		= {
 		.name		= KBUILD_MODNAME,
+		.owner		= THIS_MODULE,
 	},
 };
 
--- g26.orig/drivers/leds/leds-cobalt-qube.c	2008-04-11 10:25:34.000000000 -0700
+++ g26/drivers/leds/leds-cobalt-qube.c	2008-04-11 10:28:33.000000000 -0700
@@ -75,6 +75,9 @@ static int __devexit cobalt_qube_led_rem
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:cobalt-qube-leds");
+
 static struct platform_driver cobalt_qube_led_driver = {
 	.probe	= cobalt_qube_led_probe,
 	.remove	= __devexit_p(cobalt_qube_led_remove),
--- g26.orig/drivers/leds/leds-hp6xx.c	2008-04-11 10:25:34.000000000 -0700
+++ g26/drivers/leds/leds-hp6xx.c	2008-04-11 10:30:06.000000000 -0700
@@ -90,6 +90,9 @@ static int hp6xxled_remove(struct platfo
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:hp6xx-led");
+
 static struct platform_driver hp6xxled_driver = {
 	.probe		= hp6xxled_probe,
 	.remove		= hp6xxled_remove,
@@ -99,6 +102,7 @@ static struct platform_driver hp6xxled_d
 #endif
 	.driver		= {
 		.name		= "hp6xx-led",
+		.owner		= THIS_MODULE,
 	},
 };
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXGWLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXGWLRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbXGWLRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:17:08 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:35640 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbXGWLRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:17:07 -0400
Date: Mon, 23 Jul 2007 04:17:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, acpi4asus-u@pimp.vs19.net,
       Gabriel C <nix.or.die@googlemail.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Corentin Chary <corentincj@iksaif.net>
Subject: Re: [1/2] 2.6.23-rc1: known regressions
In-Reply-To: <46A47932.8000709@googlemail.com>
Message-ID: <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net>
References: <46A47932.8000709@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Michal Piotrowski wrote:
> ACPI
>
> Subject         : drivers/misc/asus-laptop.c:*: error: 'struct led_classdev' has no member named 'class_dev'
> References      : http://lkml.org/lkml/2007/7/22/299
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

Here's a trivial patch for this one.
------------------------------------------------------------------------
asus-laptop: Sync with changes to led class

Driver was broken by commit f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f
	leds: Convert from struct class_device to struct device

	Convert the LEDs class from struct class_device to struct device
	since class_device is scheduled for removal.

Use (struct led_classdev).dev instead of (struct led_classdev).class_dev

diff -r 3f21143ca44c drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c	Sun Jul 22 21:30:24 2007 +0000
+++ b/drivers/misc/asus-laptop.c	Mon Jul 23 03:47:55 2007 -0700
@@ -1067,8 +1067,8 @@ static void asus_backlight_exit(void)
 }

 #define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
+	if(object##_led.dev					\
+	   && !IS_ERR(object##_led.dev))			\
 		led_classdev_unregister(&object##_led)

 static void asus_led_exit(void)

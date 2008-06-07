Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbYFGPh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbYFGPh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYFGPhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:37:16 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58420 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757273AbYFGPhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:37:15 -0400
Message-Id: <20080607153712.202340716@fluff.org.uk>
References: <20080607153655.026170849@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jun 2008 16:36:59 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Linux ARM Kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/5] sparse: leds-h1940.c: make non-exported symbols static
Content-Disposition: inline; filename=sparse-fix-h1940-leds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to export any of the routines inside
drivers/leds/leds-h1940.c, so make them all static to
quieten the sparse output for this driver.

Fixes the following sparse errors:
drivers/leds/leds-h1940.c:26:6: warning: symbol 'h1940_greenled_set' was not declared. Should it be static?
drivers/leds/leds-h1940.c:55:6: warning: symbol 'h1940_redled_set' was not declared. Should it be static?
drivers/leds/leds-h1940.c:85:6: warning: symbol 'h1940_blueled_set' was not declared. Should it be static?

CC: Richard Purdie <rpurdie@rpsys.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5/drivers/leds/leds-h1940.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/leds/leds-h1940.c	2008-06-07 16:12:19.000000000 +0100
+++ linux-2.6.26-rc5/drivers/leds/leds-h1940.c	2008-06-07 16:13:18.000000000 +0100
@@ -23,7 +23,8 @@
 /*
  * Green led.
  */
-void h1940_greenled_set(struct led_classdev *led_dev, enum led_brightness value)
+static void h1940_greenled_set(struct led_classdev *led_dev,
+			       enum led_brightness value)
 {
 	switch (value) {
 	case LED_HALF:
@@ -52,7 +53,8 @@ static struct led_classdev h1940_greenle
 /*
  * Red led.
  */
-void h1940_redled_set(struct led_classdev *led_dev, enum led_brightness value)
+static void h1940_redled_set(struct led_classdev *led_dev,
+			     enum led_brightness value)
 {
 	switch (value) {
 	case LED_HALF:
@@ -82,7 +84,8 @@ static struct led_classdev h1940_redled 
  * Blue led.
  * (it can only be blue flashing led)
  */
-void h1940_blueled_set(struct led_classdev *led_dev, enum led_brightness value)
+static void h1940_blueled_set(struct led_classdev *led_dev,
+			      enum led_brightness value)
 {
 	if (value) {
 		/* flashing Blue */

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

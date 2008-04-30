Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbYD3UD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbYD3UD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbYD3UDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:03:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873AbYD3UDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:03:49 -0400
Date: Wed, 30 Apr 2008 22:03:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] input: JOYSTICK_XPAD build fix
Message-ID: <20080430200340.GA13757@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86.git testing found the following build failure in -git:

 ERROR: "led_classdev_register" [drivers/input/joystick/xpad.ko] undefined!
 ERROR: "led_classdev_unregister" [drivers/input/joystick/xpad.ko] undefined!

which triggers with the following config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_21_43_17_CEST_2008.bad

the reason is dependency on NEW_LEDS that was not spelled out in the
Kconfig entry of JOYSTICK_XPAD.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/input/joystick/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/input/joystick/Kconfig
===================================================================
--- linux.orig/drivers/input/joystick/Kconfig
+++ linux/drivers/input/joystick/Kconfig
@@ -268,6 +268,7 @@ config JOYSTICK_JOYDUMP
 config JOYSTICK_XPAD
 	tristate "X-Box gamepad support"
 	depends on USB_ARCH_HAS_HCD
+	depends on NEW_LEDS
 	select USB
 	help
 	  Say Y here if you want to use the X-Box pad with your computer.

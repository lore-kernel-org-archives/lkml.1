Return-Path: <linux-kernel-owner+w=401wt.eu-S1763002AbYECMrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002AbYECMrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYECMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:47:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbYECMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:47:24 -0400
Date: Sat, 3 May 2008 14:47:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [patch/bugreport] rt2x00: build fix
Message-ID: <20080503124711.GA18244@elte.hu>
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


x86.git testing found the following build failure on latest -git:

   Building modules, stage 2.
   MODPOST 332 modules
 ERROR: "led_classdev_unregister" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
 ERROR: "led_classdev_resume" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
 ERROR: "led_classdev_register" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
 ERROR: "led_classdev_suspend" [drivers/net/wireless/rt2x00/rt2x00lib.ko] undefined!
 make[1]: *** [__modpost] Error 1
 make: *** [modules] Error 2

config can be found at:

  http://redhat.com/~mingo/misc/config-Sat_May__3_13_24_19_CEST_2008.bad

the patch here is just a quick workaround for now for my test-setup, it 
makes the leds features in this driver depend on NEW_LEDS. Have not 
checked how far away this is from the real fix. Hm, and i think think i 
sent another patch for a similar build failure a week ago already - did 
i miss some patch to try?

	Ingo

---
 drivers/net/wireless/rt2x00/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- linux.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux/drivers/net/wireless/rt2x00/Kconfig
@@ -61,6 +61,7 @@ config RT2400PCI_RFKILL
 config RT2400PCI_LEDS
 	bool "RT2400 leds support"
 	depends on RT2400PCI
+	depends on NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -88,6 +89,7 @@ config RT2500PCI_RFKILL
 config RT2500PCI_LEDS
 	bool "RT2500 leds support"
 	depends on RT2500PCI
+	depends on NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -117,6 +119,7 @@ config RT61PCI_RFKILL
 config RT61PCI_LEDS
 	bool "RT61 leds support"
 	depends on RT61PCI
+	depends on NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -134,6 +137,7 @@ config RT2500USB
 config RT2500USB_LEDS
 	bool "RT2500 leds support"
 	depends on RT2500USB
+	depends on NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---
@@ -153,6 +157,7 @@ config RT73USB
 config RT73USB_LEDS
 	bool "RT73 leds support"
 	depends on RT73USB
+	depends on NEW_LEDS
 	select LEDS_CLASS
 	select RT2X00_LIB_LEDS
 	---help---

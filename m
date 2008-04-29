Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbYD2IVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbYD2IVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYD2IVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:21:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYD2IVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:21:32 -0400
Date: Tue, 29 Apr 2008 10:21:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, Len Brown <lenb@kernel.org>
Subject: [patch] ACER_WMI/ASUS_LAPTOP: fix build bug
Message-ID: <20080429082119.GA14597@elte.hu>
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


randconfig testing in x86.git found the following upstream build bug:

 drivers/built-in.o: In function `acer_led_exit':
 acer-wmi.c:(.text+0xdc76e): undefined reference to `led_classdev_unregister'
 drivers/built-in.o: In function `acer_platform_probe':
 acer-wmi.c:(.devinit.text+0x63e6): undefined reference to `led_classdev_register'

which was due to acer-wmi.o only depending on CONFIG_LEDS_CLASS, while 
also using a symbol offered by CONFIG_NEW_LEDS. Also fix a similar bug 
in CONFIG_ASUS_LAPTOP.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/misc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/misc/Kconfig
===================================================================
--- linux.orig/drivers/misc/Kconfig
+++ linux/drivers/misc/Kconfig
@@ -140,6 +140,7 @@ config ACER_WMI
 	depends on EXPERIMENTAL
 	depends on ACPI
 	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
 	select ACPI_WMI
@@ -160,6 +161,7 @@ config ASUS_LAPTOP
         depends on ACPI
 	depends on EXPERIMENTAL && !ACPI_ASUS
 	depends on LEDS_CLASS
+	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
         ---help---
 	  This is the new Linux driver for Asus laptops. It may also support some

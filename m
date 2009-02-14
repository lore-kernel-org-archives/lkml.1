Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZBNUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZBNUa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZBNUav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:30:51 -0500
Received: from bu3sch.de ([62.75.166.246]:60034 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZBNUav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:30:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bcm47xx: Fix GPIO API return codes
Date: Sat, 14 Feb 2009 21:27:19 +0100
User-Agent: KMail/1.9.9
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142127.19521.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO API is supposed to return 0 or a negative error code,
but the SSB GPIO functions return the bitmask of the GPIO register.
Fix this by ignoring the bitmask and always returning 0. The SSB GPIO functions can't fail.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-01-01 19:27:06.000000000 +0100
+++ linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-02-14 21:26:14.000000000 +0100
@@ -31,24 +31,28 @@ static inline void gpio_set_value(unsign
 
 static inline int gpio_direction_input(unsigned gpio)
 {
-	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
+	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
+	return 0;
 }
 
 static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
+	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
+	return 0;
 }
 
-static int gpio_intmask(unsigned gpio, int value)
+static inline int gpio_intmask(unsigned gpio, int value)
 {
-	return ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
-				value ? 1 << gpio : 0);
+	ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
+			 value ? 1 << gpio : 0);
+	return 0;
 }
 
-static int gpio_polarity(unsigned gpio, int value)
+static inline int gpio_polarity(unsigned gpio, int value)
 {
-	return ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
-				 value ? 1 << gpio : 0);
+	ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
+			  value ? 1 << gpio : 0);
+	return 0;
 }
 
 


-- 
Greetings, Michael.

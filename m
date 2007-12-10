Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbXLJExX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbXLJExX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXLJEwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:52:05 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28974 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752224AbXLJEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:51:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=mS4EO2nuRennrBA4RvVdQ8dd+SXhoqiRHQmfym5WqbYi2fhqSR6wVIQw4O8pK8be10e6rckRltZG//nWMzhbeTDI33KQzZJJ+OURmXde3cWqUQdTuk35IeRfRgkohvrTdAmiQh0DgKTesk2i2s6Iw7zQFjHOW12aMk52bCkmlzg=  ;
X-YMail-OSG: 2SP_AngVM1n6f5d.Y2CiZQZS1PP_N0MOVInAFlUX5wzc3reh1NS0RgrZV8dmzYHeq7BwmD14Kg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc4-mm 4/6] gpiolib:  create empty drivers/gpio
Date: Sun, 9 Dec 2007 20:39:57 -0800
User-Agent: KMail/1.9.6
Cc: eric miao <eric.y.miao@marvell.com>, Jean Delvare <khali@linux-fr.org>
References: <200712092022.14062.david-b@pacbell.net>
In-Reply-To: <200712092022.14062.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712092039.57722.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add an empty drivers/gpio directory for gpiolib based GPIO expanders.
We already have three of them (two I2C, one SPI), and there are dozens
of similar chips that only exist for GPIO expansion.

This won't be the only place to hold such gpio_chip code.  Many external
chips add a few GPIOs as secondary functionality, and platform code
frequently needs to closely integrate GPIO and IRQ support.

This is placed *early* in the build/link sequence since it's common for
other drivers to depend on GPIOs to do their work, so they need to be
initialized early in the device_initcall() sequence.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/Kconfig      |    2 ++
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    1 +
 drivers/gpio/Kconfig  |   14 ++++++++++++++
 drivers/gpio/Makefile |    1 +
 5 files changed, 20 insertions(+)

--- a/arch/arm/Kconfig	2007-12-09 19:50:39.000000000 -0800
+++ b/arch/arm/Kconfig	2007-12-09 19:51:04.000000000 -0800
@@ -1034,6 +1034,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- a/drivers/Kconfig	2007-12-09 19:50:39.000000000 -0800
+++ b/drivers/Kconfig	2007-12-09 19:51:04.000000000 -0800
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/gpio/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
--- a/drivers/Makefile	2007-12-09 19:50:39.000000000 -0800
+++ b/drivers/Makefile	2007-12-09 19:51:04.000000000 -0800
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-$(CONFIG_GPIO_LIB)		+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/gpio/Kconfig	2007-12-09 19:51:04.000000000 -0800
@@ -0,0 +1,14 @@
+#
+# platform-neutral GPIO support
+#
+
+menu "GPIO Expanders"
+	depends on GPIO_LIB
+
+# put expanders in the right section, in alphabetical order
+
+comment "I2C GPIO expanders:"
+
+comment "SPI GPIO expanders:"
+
+endmenu
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/gpio/Makefile	2007-12-09 19:51:04.000000000 -0800
@@ -0,0 +1 @@
+# gpio support: dedicated expander chips, etc

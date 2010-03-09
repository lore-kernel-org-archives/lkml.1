Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0CITOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:14:01 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57456 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0CITN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=R15zPGnXmSMm+SuhwlmHfvUrqOWKct+vMzDQ2B0wy5ObQQ/o7ca+g8uuCGmisX7BCW
         nKlqALZmbx9yBCuXVxZyol6rIUoqMlfQrUSMjnMnpYqRTSupyiDQ4Sq6fez6c4iin+0F
         OLILsR+i2vB1QB2jDyUZ0p38Kw8lC4mM/gJSI=
MIME-Version: 1.0
In-Reply-To: <20091215221357.GA26024@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
	 <20091215221357.GA26024@opensource.wolfsonmicro.com>
Date: Tue, 9 Mar 2010 20:13:56 +0100
X-Google-Sender-Auth: 559a97f462e3a13f
Message-ID: <10f740e81003091113j5b55edf7r7eec8728bcc87821@mail.gmail.com>
Subject: Re: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 23:13, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Dec 15, 2009 at 10:00:02PM +0100, Geert Uytterhoeven wrote:
>> From e2def3261a58e9c0e56b710b2020858df010a2c1 Mon Sep 17 00:00:00 2001
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> Date: Tue, 15 Dec 2009 21:49:57 +0100
>> Subject: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
>>
>> commit 5fb4d38b19d95a5f980f0a10adba798f5b92128c ("mfd: Move WM831x to generic
>> IRQ") didn't take into account that genirq support depends on GENERIC_HARDIRQS.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This patch still hasn't made it. In addition, 3 more drivers started
to show the same problems
on architectures that don't use genirq yet, so I updated it.

>From a11ebba6c1a49bc97220bec57f7c8f4cddff0824 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Dec 2009 21:49:57 +0100
Subject: [PATCH] mfd: Several MFD drivers should depend on GENERIC_HARDIRQS

commit 5fb4d38b19d95a5f980f0a10adba798f5b92128c ("mfd: Move WM831x to generic
IRQ") didn't take into account that genirq support depends on GENERIC_HARDIRQS.

Additionally, 2.6.34-rc1 added:
  - commit 2afa62ea76027b00e472ddb672191e6e15425b43 ("mfd: Use genirq in
    88pm860x").
  - commit 760e4518788df6762700e6bb9dd8692379f11168 ("mfd: Convert WM8350 to
    genirq").
  - commit 1f1cf8f98cf6588365efeaab8e7e7758aaa77f6e ("mfd: Update irq handler
    in max8925")

Make all of them depend on GENERIC_HARDIRQS to avoid compile errors on
architectures that don't support genirq yet.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/Kconfig |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 951fa9b..2a5a0b7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -11,7 +11,7 @@ config MFD_CORE

 config MFD_88PM860X
 	bool "Support Marvell 88PM8606/88PM8607"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  This supports for Marvell 88PM8606/88PM8607 Power Management IC.
@@ -205,7 +205,7 @@ config PMIC_ADP5520

 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
@@ -226,7 +226,7 @@ config MFD_WM8400
 config MFD_WM831X
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
 	select MFD_CORE
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
 	  This driver provides common support for accessing the device,
@@ -235,6 +235,7 @@ config MFD_WM831X

 config MFD_WM8350
 	bool
+	depends on GENERIC_HARDIRQS

 config MFD_WM8350_CONFIG_MODE_0
 	bool
@@ -287,7 +288,7 @@ config MFD_WM8352_CONFIG_MODE_3
 config MFD_WM8350_I2C
 	bool "Support Wolfson Microelectronics WM8350 with I2C"
 	select MFD_WM8350
-	depends on I2C=y
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8350 is an integrated audio and power management
 	  subsystem with watchdog and RTC functionality for embedded
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

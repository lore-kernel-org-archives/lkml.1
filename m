Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZLBOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZLBOBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZLBOB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:01:29 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:52507 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbZLBOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:01:28 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 09:01:28 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=raSMZpEWoar9j6Zutei16ucPVVO2guHl+SQeLUBO2q1DMX2nLu01Kbyl2FCriR07tn
         +itkjATaTpLr9Mt4fHiWzP0x1QSEkjygyTh73tpIhyd/eChCW8Toxfba74WDZfkbUxr2
         0IwBh3T5+fDi7uQq7QaOfG9d/NEAzD7fq2I9M=
Message-ID: <4B167149.50809@gmail.com>
Date: Wed, 02 Dec 2009 21:53:13 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/4]ARM: NUC900: add clk definition support for nuc932
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

This patch adds clk definition support for nuc932.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/nuc932.c |   47 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-w90x900/nuc932.c b/arch/arm/mach-w90x900/nuc932.c
index 6ad68aa..140fa2f 100644
--- a/arch/arm/mach-w90x900/nuc932.c
+++ b/arch/arm/mach-w90x900/nuc932.c
@@ -14,11 +14,58 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+
 #include <asm/mach/map.h>
 #include <mach/hardware.h>
 #include "cpu.h"
 
+/* Initial nuc932 clock declarations. */
+static DEFINE_CLK(audio, 2);
+static DEFINE_CLK(sd, 3);
+static DEFINE_CLK(jpg, 4);
+static DEFINE_CLK(video, 5);
+static DEFINE_CLK(vpost, 6);
+static DEFINE_CLK(2d, 7);
+static DEFINE_CLK(gpu, 8);
+static DEFINE_CLK(gdma, 9);
+static DEFINE_CLK(adc, 10);
+static DEFINE_CLK(uart, 11);
+static DEFINE_CLK(spi, 12);
+static DEFINE_CLK(pwm, 13);
+static DEFINE_CLK(timer, 14);
+static DEFINE_CLK(wdt, 15);
+static DEFINE_CLK(ac97, 16);
+static DEFINE_CLK(i2s, 16);
+static DEFINE_CLK(usbck, 17);
+static DEFINE_CLK(usb48, 18);
+static DEFINE_CLK(usbh, 19);
+static DEFINE_CLK(i2c, 20);
+static DEFINE_CLK(ext, 0);
+
 static struct clk_lookup nuc932_clkregs[] = {
+	DEF_CLKLOOK(&clk_audio, "nuc932-audio", NULL),
+	DEF_CLKLOOK(&clk_sd, "nuc932-sd", NULL),
+	DEF_CLKLOOK(&clk_jpg, "nuc932-jpg", "NULL"),
+	DEF_CLKLOOK(&clk_video, "nuc932-video", "NULL"),
+	DEF_CLKLOOK(&clk_vpost, "nuc932-vpost", NULL),
+	DEF_CLKLOOK(&clk_2d, "nuc932-2d", NULL),
+	DEF_CLKLOOK(&clk_gpu, "nuc932-gpu", NULL),
+	DEF_CLKLOOK(&clk_gdma, "nuc932-gdma", "NULL"),
+	DEF_CLKLOOK(&clk_adc, "nuc932-adc", NULL),
+	DEF_CLKLOOK(&clk_uart, NULL, "uart"),
+	DEF_CLKLOOK(&clk_spi, "nuc932-spi", NULL),
+	DEF_CLKLOOK(&clk_pwm, "nuc932-pwm", NULL),
+	DEF_CLKLOOK(&clk_timer, NULL, "timer"),
+	DEF_CLKLOOK(&clk_wdt, "nuc932-wdt", NULL),
+	DEF_CLKLOOK(&clk_ac97, "nuc932-ac97", NULL),
+	DEF_CLKLOOK(&clk_i2s, "nuc932-i2s", NULL),
+	DEF_CLKLOOK(&clk_usbck, "nuc932-usbck", NULL),
+	DEF_CLKLOOK(&clk_usb48, "nuc932-usb48", NULL),
+	DEF_CLKLOOK(&clk_usbh, "nuc932-usbh", NULL),
+	DEF_CLKLOOK(&clk_i2c, "nuc932-i2c", NULL),
+	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
 };
 
 /* define specific CPU platform io map */
-- 
1.5.6.3

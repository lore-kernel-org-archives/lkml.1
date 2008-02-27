Return-Path: <linux-kernel-owner+w=401wt.eu-S1764594AbYB0Hiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764594AbYB0Hiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYB0Hig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:38:36 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37699 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbYB0Hig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:38:36 -0500
Date: Wed, 27 Feb 2008 09:37:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: khali@linux-fr.org
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] I2C_ELEKTOR must depend on HAS_IOPORT
Message-ID: <20080227073728.GD10603@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error on m32r:

<--  snip  -->

...
  CC [M]  drivers/i2c/busses/i2c-elektor.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_setbyte':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:80: error: implicit declaration of function 'iowrite8'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_getbyte':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:90: error: implicit declaration of function 'ioread8'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'pcf_isa_init':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: error: implicit declaration of function 'ioport_map'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:153: warning: assignment makes pointer from integer without a cast
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c: In function 'elektor_probe':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/i2c/busses/i2c-elektor.c:290: error: implicit declaration of function 'ioport_unmap'
make[4]: *** [drivers/i2c/busses/i2c-elektor.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
c8a75f0dd2390ae8c8f91c451ff6b0e113d0ebd0 diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 476b0bb..3bed6b9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -129,7 +129,7 @@ config I2C_DAVINCI
 
 config I2C_ELEKTOR
 	tristate "Elektor ISA card"
-	depends on ISA && BROKEN_ON_SMP
+	depends on ISA && HAS_IOPORT && BROKEN_ON_SMP
 	select I2C_ALGOPCF
 	help
 	  This supports the PCF8584 ISA bus I2C adapter.  Say Y if you own


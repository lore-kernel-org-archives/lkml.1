Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYDROXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYDROXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYDROXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:23:16 -0400
Received: from mail0.scram.de ([78.47.204.202]:48044 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYDROXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:23:15 -0400
X-Spam-Score: -4.202
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4808AEC7.8040000@scram.de>
Date: Fri, 18 Apr 2008 16:23:03 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] [POWERPC] i2c: fix build breakage introduced by OF helpers
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build breakage introduced in commit
"[POWERPC] i2c: OF helpers for the i2c API".
If i2c-core is compiled as module, the helper needs to be
compiled as module, as well. Rename i2c.c to of_i2c.c to
avoid name space conflict.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/of/Kconfig             |    2 +-
 drivers/of/Makefile            |    2 +-
 drivers/of/{i2c.c => of_i2c.c} |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/of/{i2c.c => of_i2c.c} (100%)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 7c30531..0e39f00 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -9,7 +9,7 @@ config OF_GPIO
 	  OpenFirmware GPIO accessors
 
 config OF_I2C
-	def_bool y
+	def_tristate I2C
 	depends on OF && I2C
 	help
 	  OpenFirmware I2C accessors
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index a07b953..548772e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,4 +1,4 @@
 obj-y = base.o
 obj-$(CONFIG_OF_DEVICE) += device.o platform.o
 obj-$(CONFIG_OF_GPIO)   += gpio.o
-obj-$(CONFIG_OF_I2C)	+= i2c.o
+obj-$(CONFIG_OF_I2C)	+= of_i2c.o
diff --git a/drivers/of/i2c.c b/drivers/of/of_i2c.c
similarity index 100%
rename from drivers/of/i2c.c
rename to drivers/of/of_i2c.c
-- 
1.5.5


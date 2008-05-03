Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYECMnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYECMnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYECMnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:43:00 -0400
Received: from mail0.scram.de ([78.47.204.202]:35230 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668AbYECMm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:42:59 -0400
X-Spam-Score: -4.086
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <481C5DD0.5090503@scram.de>
Date: Sat, 03 May 2008 14:42:56 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] [POWERPC] Fix of_i2c include for module compilation
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that of_i2c may be compiled as module, the header must be
exported for module compilation, as well.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 include/linux/of_i2c.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 2e5a967..dca6013 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -14,7 +14,7 @@
 
 #include <linux/i2c.h>
 
-#ifdef CONFIG_OF_I2C
+#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
 
 void of_register_i2c_devices(struct i2c_adapter *adap,
 			     struct device_node *adap_node);
-- 
1.5.5.1


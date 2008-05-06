Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbYEFSlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbYEFSlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765363AbYEFSkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:40:10 -0400
Received: from mail0.scram.de ([78.47.204.202]:55904 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbYEFSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:40:07 -0400
X-Spam-Score: -4.083
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <4820A601.2020801@scram.de>
Date: Tue, 06 May 2008 20:40:01 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Kumar Gala <galak@kernel.crashing.org>, Jean Delvare <khali@linux-fr.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCHv2 2.6.26-rc1] [POWERPC] Fix of_i2c include for module compilation
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove #ifdef CONFIG_OF_I2C as this breaks module compilation.
Drivers using this header should depend on OF_I2C anyways, so
there's no need to make this conditional

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 include/linux/of_i2c.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
index 2e5a967..bd2a870 100644
--- a/include/linux/of_i2c.h
+++ b/include/linux/of_i2c.h
@@ -14,11 +14,7 @@
 
 #include <linux/i2c.h>
 
-#ifdef CONFIG_OF_I2C
-
 void of_register_i2c_devices(struct i2c_adapter *adap,
 			     struct device_node *adap_node);
 
-#endif /* CONFIG_OF_I2C */
-
 #endif /* __LINUX_OF_I2C_H */
-- 
1.5.5.1


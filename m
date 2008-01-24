Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYAXPTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYAXPTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYAXPTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:19:15 -0500
Received: from mail0.scram.de ([78.47.204.202]:59095 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYAXPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:19:13 -0500
X-Spam-Score: -4.269
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.1 AWL AWL: From: address is in the auto white-list
Message-ID: <4798AC65.9000203@scram.de>
Date: Thu, 24 Jan 2008 16:19:01 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv3 5/7] [POWERPC] Get rid of conditional includes of board
 specific setup
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly include mpc885ads.h from mpc885ads_setup.c. Now we can get rid
of the arch dependent includes in mpc8xx.h.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/platforms/8xx/m8xx_setup.c      |    3 +--
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    1 +
 include/asm-powerpc/mpc8xx.h                 |   20 --------------------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1867a07..184f998 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/rtc.h>
+#include <linux/fsl_devices.h>
 
 #include <asm/io.h>
 #include <asm/mpc8xx.h>
@@ -28,9 +29,7 @@
 
 #include "mpc8xx.h"
 
-#ifdef CONFIG_PCMCIA_M8XX
 struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
-#endif
 
 extern int cpm_pic_init(void);
 extern int cpm_get_irq(void);
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index bdceb57..3be115e 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -40,6 +40,7 @@
 #include <asm/fs_pd.h>
 #include <asm/udbg.h>
 
+#include "mpc885ads.h"
 #include "mpc8xx.h"
 
 static u32 __iomem *bcsr, *bcsr5;
diff --git a/include/asm-powerpc/mpc8xx.h b/include/asm-powerpc/mpc8xx.h
index 2be014b..98f3c4f 100644
--- a/include/asm-powerpc/mpc8xx.h
+++ b/include/asm-powerpc/mpc8xx.h
@@ -4,29 +4,9 @@
  * file that has to include MPC8xx configuration, they all include
  * this one and the configuration switching is done here.
  */
-#ifdef __KERNEL__
 #ifndef __CONFIG_8xx_DEFS
 #define __CONFIG_8xx_DEFS
 
-
-#ifdef CONFIG_8xx
-
-#ifdef CONFIG_FADS
-#include <platforms/fads.h>
-#endif
-
-#if defined(CONFIG_MPC86XADS)
-#include <platforms/8xx/mpc86xads.h>
-#endif
-
-#if defined(CONFIG_MPC885ADS)
-#include <platforms/8xx/mpc885ads.h>
-#endif
-
-#ifdef CONFIG_PCMCIA_M8XX
 extern struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
-#endif
 
-#endif /* CONFIG_8xx */
 #endif /* __CONFIG_8xx_DEFS */
-#endif /* __KERNEL__ */
-- 
1.5.3.8



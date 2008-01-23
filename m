Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYAWQCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYAWQCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYAWQBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:01:50 -0500
Received: from mail0.scram.de ([78.47.204.202]:34227 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYAWQBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:01:49 -0500
X-Spam-Score: -4.214
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <479764D8.8010507@scram.de>
Date: Wed, 23 Jan 2008 17:01:28 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 6/8] [POWERPC] Get rid of conditional includes of board
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
  arch/powerpc/platforms/8xx/mpc885ads_setup.c |    2 +
  include/asm-powerpc/mpc8xx.h                 |   34 +++++++-------------------
  2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index ae69e93..426b897 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -40,6 +40,8 @@
  #include <asm/fs_pd.h>
  #include <asm/udbg.h>

+#include "mpc885ads.h"
+
  static u32 __iomem *bcsr, *bcsr5;

  #ifdef CONFIG_PCMCIA_M8XX
diff --git a/include/asm-powerpc/mpc8xx.h b/include/asm-powerpc/mpc8xx.h
index 2af9fcb..70fd8a7 100644
--- a/include/asm-powerpc/mpc8xx.h
+++ b/include/asm-powerpc/mpc8xx.h
@@ -1,16 +1,16 @@
-/* This is the single file included by all MPC8xx build options.
- * Since there are many different boards and no standard configuration,
- * we have a unique include file for each.  Rather than change every
- * file that has to include MPC8xx configuration, they all include
- * this one and the configuration switching is done here.
+/*
+ * Prototypes, etc. for the Freescale MPC8xx embedded cpu chips
+ * May need to be cleaned as the port goes on ...
+ *
+ * Copyright (C) 2008 Jochen Friedrich <jochen@scram.de>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
   */
-#ifdef __KERNEL__
  #ifndef __CONFIG_8xx_DEFS
  #define __CONFIG_8xx_DEFS

-
-#ifdef CONFIG_8xx
-
  extern void mpc8xx_restart(char *cmd);
  extern void mpc8xx_calibrate_decr(void);
  extern int mpc8xx_set_rtc_time(struct rtc_time *tm);
@@ -18,22 +18,6 @@ extern void mpc8xx_get_rtc_time(struct rtc_time *tm);
  extern void mpc8xx_pics_init(void);
  extern unsigned int mpc8xx_get_irq(void);

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



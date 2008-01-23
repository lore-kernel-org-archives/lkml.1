Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYAWQB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYAWQB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYAWQBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:01:18 -0500
Received: from mail0.scram.de ([78.47.204.202]:55936 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbYAWQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:01:15 -0500
X-Spam-Score: -4.201
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <479764B8.4010909@scram.de>
Date: Wed, 23 Jan 2008 17:00:56 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 5/8] [POWERPC] Remove sysdev/commproc.h
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move cpm1 specific prototypes to asm/commproc.h and mpc8xx specific
prototypes to asm/mpc8xx.h. Adjust includes accordingly. Remove now
unneeded sysdev/commproc.h.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
  arch/powerpc/platforms/8xx/ep88xc.c          |    3 +--
  arch/powerpc/platforms/8xx/m8xx_setup.c      |    1 -
  arch/powerpc/platforms/8xx/mpc86xads_setup.c |    2 --
  arch/powerpc/platforms/8xx/mpc885ads_setup.c |    2 --
  arch/powerpc/sysdev/commproc.c               |    1 -
  arch/powerpc/sysdev/commproc.h               |   12 ------------
  arch/powerpc/sysdev/mpc8xx_pic.c             |    1 -
  drivers/net/fs_enet/mac-scc.c                |    1 -
  include/asm-powerpc/commproc.h               |    2 ++
  include/asm-powerpc/mpc8xx.h                 |    7 +++++++
  10 files changed, 10 insertions(+), 22 deletions(-)
  delete mode 100644 arch/powerpc/sysdev/commproc.h

diff --git a/arch/powerpc/platforms/8xx/ep88xc.c b/arch/powerpc/platforms/8xx/ep88xc.c
index c883c31..9365f07 100644
--- a/arch/powerpc/platforms/8xx/ep88xc.c
+++ b/arch/powerpc/platforms/8xx/ep88xc.c
@@ -16,8 +16,7 @@
  #include <asm/io.h>
  #include <asm/udbg.h>
  #include <asm/commproc.h>
-
-#include <sysdev/commproc.h>
+#include <asm/mpc8xx.h>

  struct cpm_pin {
  	int port, pin, flags;
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 85abd61..c6a4663 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -25,7 +25,6 @@
  #include <mm/mmu_decl.h>

  #include <sysdev/mpc8xx_pic.h>
-#include <sysdev/commproc.h>

  #ifdef CONFIG_PCMCIA_M8XX
  struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index dea1df1..7389590 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -27,8 +27,6 @@
  #include <asm/fs_pd.h>
  #include <asm/udbg.h>

-#include <sysdev/commproc.h>
-
  #include "mpc86xads.h"

  struct cpm_pin {
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 8f2aa04..ae69e93 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -40,8 +40,6 @@
  #include <asm/fs_pd.h>
  #include <asm/udbg.h>

-#include <sysdev/commproc.h>
-
  static u32 __iomem *bcsr, *bcsr5;

  #ifdef CONFIG_PCMCIA_M8XX
diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index 818d4b0..ef82587 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -30,7 +30,6 @@
  #include <linux/interrupt.h>
  #include <linux/irq.h>
  #include <linux/module.h>
-#include <asm/mpc8xx.h>
  #include <asm/page.h>
  #include <asm/pgtable.h>
  #include <asm/8xx_immap.h>
diff --git a/arch/powerpc/sysdev/commproc.h b/arch/powerpc/sysdev/commproc.h
deleted file mode 100644
index f481adf..0000000
--- a/arch/powerpc/sysdev/commproc.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _POWERPC_SYSDEV_COMMPROC_H
-#define _POWERPC_SYSDEV_COMMPROC_H
-
-extern void cpm_reset(void);
-extern void mpc8xx_restart(char *cmd);
-extern void mpc8xx_calibrate_decr(void);
-extern int mpc8xx_set_rtc_time(struct rtc_time *tm);
-extern void mpc8xx_get_rtc_time(struct rtc_time *tm);
-extern void mpc8xx_pics_init(void);
-extern unsigned int mpc8xx_get_irq(void);
-
-#endif
diff --git a/arch/powerpc/sysdev/mpc8xx_pic.c b/arch/powerpc/sysdev/mpc8xx_pic.c
index 7aa4ff5..0e74a4b 100644
--- a/arch/powerpc/sysdev/mpc8xx_pic.c
+++ b/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -10,7 +10,6 @@
  #include <asm/irq.h>
  #include <asm/io.h>
  #include <asm/8xx_immap.h>
-#include <asm/mpc8xx.h>

  #include "mpc8xx_pic.h"

diff --git a/drivers/net/fs_enet/mac-scc.c b/drivers/net/fs_enet/mac-scc.c
index fe3d8a6..1502dbf 100644
--- a/drivers/net/fs_enet/mac-scc.c
+++ b/drivers/net/fs_enet/mac-scc.c
@@ -39,7 +39,6 @@
  #ifdef CONFIG_8xx
  #include <asm/8xx_immap.h>
  #include <asm/pgtable.h>
-#include <asm/mpc8xx.h>
  #include <asm/commproc.h>
  #endif

diff --git a/include/asm-powerpc/commproc.h b/include/asm-powerpc/commproc.h
index 9757521..ec87b8f 100644
--- a/include/asm-powerpc/commproc.h
+++ b/include/asm-powerpc/commproc.h
@@ -89,6 +89,8 @@ extern void cpm_setbrg(uint brg, uint rate);

  extern void cpm_load_patch(cpm8xx_t *cp);

+extern void cpm_reset(void);
+
  /* Buffer descriptors used by many of the CPM protocols.
  */
  typedef struct cpm_buf_desc {
diff --git a/include/asm-powerpc/mpc8xx.h b/include/asm-powerpc/mpc8xx.h
index 2be014b..2af9fcb 100644
--- a/include/asm-powerpc/mpc8xx.h
+++ b/include/asm-powerpc/mpc8xx.h
@@ -11,6 +11,13 @@

  #ifdef CONFIG_8xx

+extern void mpc8xx_restart(char *cmd);
+extern void mpc8xx_calibrate_decr(void);
+extern int mpc8xx_set_rtc_time(struct rtc_time *tm);
+extern void mpc8xx_get_rtc_time(struct rtc_time *tm);
+extern void mpc8xx_pics_init(void);
+extern unsigned int mpc8xx_get_irq(void);
+
  #ifdef CONFIG_FADS
  #include <platforms/fads.h>
  #endif
-- 
1.5.3.8



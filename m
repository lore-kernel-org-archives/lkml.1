Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYAWQBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYAWQBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYAWQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:00:53 -0500
Received: from mail0.scram.de ([78.47.204.202]:51543 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbYAWQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:00:52 -0500
X-Spam-Score: -4.199
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4797646E.5080409@scram.de>
Date: Wed, 23 Jan 2008 16:59:42 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 2/8] [POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m8xx_pic_init calls both mpc8xx_pic_init and cpm_pic_init. Renaming the
function to use the same name space as the rest of the mpc8xx
specific funtions and to be more meaningful.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
  arch/powerpc/platforms/8xx/ep88xc.c          |    2 +-
  arch/powerpc/platforms/8xx/m8xx_setup.c      |    4 ++--
  arch/powerpc/platforms/8xx/mpc86xads_setup.c |    2 +-
  arch/powerpc/platforms/8xx/mpc885ads_setup.c |    2 +-
  arch/powerpc/sysdev/commproc.h               |    2 +-
  5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/ep88xc.c b/arch/powerpc/platforms/8xx/ep88xc.c
index c518b6c..c883c31 100644
--- a/arch/powerpc/platforms/8xx/ep88xc.c
+++ b/arch/powerpc/platforms/8xx/ep88xc.c
@@ -166,7 +166,7 @@ define_machine(ep88xc) {
  	.name = "Embedded Planet EP88xC",
  	.probe = ep88xc_probe,
  	.setup_arch = ep88xc_setup_arch,
-	.init_IRQ = m8xx_pic_init,
+	.init_IRQ = mpc8xx_pics_init,
  	.get_irq	= mpc8xx_get_irq,
  	.restart = mpc8xx_restart,
  	.calibrate_decr = mpc8xx_calibrate_decr,
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index ba645c2..1337457 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -237,13 +237,13 @@ static void cpm_cascade(unsigned int irq, struct irq_desc *desc)
  	desc->chip->eoi(irq);
  }

-/* Initialize the internal interrupt controller.  The number of
+/* Initialize the internal interrupt controllers.  The number of
   * interrupts supported can vary with the processor type, and the
   * 82xx family can have up to 64.
   * External interrupts can be either edge or level triggered, and
   * need to be initialized by the appropriate driver.
   */
-void __init m8xx_pic_init(void)
+void __init mpc8xx_pics_init(void)
  {
  	int irq;

diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index d2927a4..dea1df1 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -139,7 +139,7 @@ define_machine(mpc86x_ads) {
  	.name			= "MPC86x ADS",
  	.probe			= mpc86xads_probe,
  	.setup_arch		= mpc86xads_setup_arch,
-	.init_IRQ		= m8xx_pic_init,
+	.init_IRQ		= mpc8xx_pics_init,
  	.get_irq		= mpc8xx_get_irq,
  	.restart		= mpc8xx_restart,
  	.calibrate_decr		= mpc8xx_calibrate_decr,
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 2cf1b6a..8f2aa04 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -275,7 +275,7 @@ define_machine(mpc885_ads) {
  	.name			= "Freescale MPC885 ADS",
  	.probe			= mpc885ads_probe,
  	.setup_arch		= mpc885ads_setup_arch,
-	.init_IRQ		= m8xx_pic_init,
+	.init_IRQ		= mpc8xx_pics_init,
  	.get_irq		= mpc8xx_get_irq,
  	.restart		= mpc8xx_restart,
  	.calibrate_decr		= mpc8xx_calibrate_decr,
diff --git a/arch/powerpc/sysdev/commproc.h b/arch/powerpc/sysdev/commproc.h
index 9155ba4..f481adf 100644
--- a/arch/powerpc/sysdev/commproc.h
+++ b/arch/powerpc/sysdev/commproc.h
@@ -6,7 +6,7 @@ extern void mpc8xx_restart(char *cmd);
  extern void mpc8xx_calibrate_decr(void);
  extern int mpc8xx_set_rtc_time(struct rtc_time *tm);
  extern void mpc8xx_get_rtc_time(struct rtc_time *tm);
-extern void m8xx_pic_init(void);
+extern void mpc8xx_pics_init(void);
  extern unsigned int mpc8xx_get_irq(void);

  #endif
-- 
1.5.3.8



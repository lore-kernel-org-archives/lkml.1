Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYAXPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYAXPS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYAXPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:18:21 -0500
Received: from mail0.scram.de ([78.47.204.202]:36480 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYAXPSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:18:20 -0500
X-Spam-Score: -4.239
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4798AC0C.1060103@scram.de>
Date: Thu, 24 Jan 2008 16:17:32 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv3 2/7] [POWERPC] Rename m8xx_pic_init to mpc8xx_pics_init
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m8xx_pic_init calls both mpc8xx_pic_init and cpm_pic_init. Renaming the
function to use the same name space as the rest of the mpc8xx
specific funtions and to be more meaningful.
m8xx_pic_init is declared in ppc8xx_pic.h but defined nowhere in the ppc
tree. Remove it.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/platforms/8xx/ep88xc.c          |    2 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c      |    4 ++--
 arch/powerpc/platforms/8xx/mpc86xads_setup.c |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    2 +-
 arch/powerpc/sysdev/commproc.h               |    2 +-
 arch/ppc/syslib/ppc8xx_pic.h                 |    1 -
 6 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/ep88xc.c b/arch/powerpc/platforms/8xx/ep88xc.c
index 88afa35..372b1e2 100644
--- a/arch/powerpc/platforms/8xx/ep88xc.c
+++ b/arch/powerpc/platforms/8xx/ep88xc.c
@@ -165,7 +165,7 @@ define_machine(ep88xc) {
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
index d7965f8..2a4a50f 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -138,7 +138,7 @@ define_machine(mpc86x_ads) {
 	.name			= "MPC86x ADS",
 	.probe			= mpc86xads_probe,
 	.setup_arch		= mpc86xads_setup_arch,
-	.init_IRQ		= m8xx_pic_init,
+	.init_IRQ		= mpc8xx_pics_init,
 	.get_irq		= mpc8xx_get_irq,
 	.restart		= mpc8xx_restart,
 	.calibrate_decr		= mpc8xx_calibrate_decr,
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 6ef8e9e..2931bae 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -274,7 +274,7 @@ define_machine(mpc885_ads) {
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
diff --git a/arch/ppc/syslib/ppc8xx_pic.h b/arch/ppc/syslib/ppc8xx_pic.h
index d7d9f65..53bcd97 100644
--- a/arch/ppc/syslib/ppc8xx_pic.h
+++ b/arch/ppc/syslib/ppc8xx_pic.h
@@ -6,7 +6,6 @@
 
 extern struct hw_interrupt_type ppc8xx_pic;
 
-void m8xx_pic_init(void);
 void m8xx_do_IRQ(struct pt_regs *regs,
                  int            cpu);
 int m8xx_get_irq(struct pt_regs *regs);
-- 
1.5.3.8



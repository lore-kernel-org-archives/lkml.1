Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZLDWm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZLDWm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbZLDWm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:42:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbZLDWmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:42:55 -0500
Message-ID: <4B19909C.8020809@gmail.com>
Date: Fri, 04 Dec 2009 23:43:40 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, tony@atomide.com,
       khilman@deeprootsystems.com, eric.y.miao@gmail.com,
       linux@arm.linux.org.uk, hskinnemoen@atmel.com, vapier@gentoo.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org,
       lenb@kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 26/31] Constify struct platform_suspend_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct platform_suspend_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/arm/mach-at91/pm.c                   |    2 +-
 arch/arm/mach-omap1/pm.c                  |    2 +-
 arch/arm/mach-omap2/pm24xx.c              |    2 +-
 arch/arm/mach-omap2/pm34xx.c              |    2 +-
 arch/arm/mach-pnx4008/pm.c                |    2 +-
 arch/arm/mach-pxa/pm.c                    |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c            |    2 +-
 arch/arm/mach-sa1100/pm.c                 |    2 +-
 arch/arm/plat-s3c/pm.c                    |    2 +-
 arch/avr32/mach-at32ap/pm.c               |    2 +-
 arch/blackfin/mach-common/pm.c            |    2 +-
 arch/mips/alchemy/devboards/pm.c          |    2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    2 +-
 arch/powerpc/platforms/83xx/suspend.c     |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c            |    2 +-
 arch/sh/kernel/cpu/shmobile/pm.c          |    2 +-
 drivers/acpi/sleep.c                      |    4 ++--
 drivers/macintosh/via-pmu.c               |    2 +-
 include/linux/suspend.h                   |   22 +++++++++++-----------
 kernel/power/suspend.c                    |    4 ++--
 21 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 4028724..beec230 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -348,7 +348,7 @@ static void at91_pm_end(void)
 }
 
 
-static struct platform_suspend_ops at91_pm_ops ={
+static const struct platform_suspend_ops at91_pm_ops ={
 	.valid	= at91_pm_valid_state,
 	.begin	= at91_pm_begin,
 	.enter	= at91_pm_enter,
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 5218943..0a34552 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -647,7 +647,7 @@ static struct irqaction omap_wakeup_irq = {
 
 
 
-static struct platform_suspend_ops omap_pm_ops ={
+static const struct platform_suspend_ops omap_pm_ops ={
 	.prepare	= omap_pm_prepare,
 	.enter		= omap_pm_enter,
 	.finish		= omap_pm_finish,
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index bff5c4e..d4c649b 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -326,7 +326,7 @@ static void omap2_pm_finish(void)
 	enable_hlt();
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.prepare	= omap2_pm_prepare,
 	.enter		= omap2_pm_enter,
 	.finish		= omap2_pm_finish,
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 8946319..7d3e661 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -401,7 +401,7 @@ static void omap3_pm_end(void)
 	return;
 }
 
-static struct platform_suspend_ops omap_pm_ops = {
+static const struct platform_suspend_ops omap_pm_ops = {
 	.begin		= omap3_pm_begin,
 	.end		= omap3_pm_end,
 	.prepare	= omap3_pm_prepare,
diff --git a/arch/arm/mach-pnx4008/pm.c b/arch/arm/mach-pnx4008/pm.c
index b3d8d53..6e68ebc 100644
--- a/arch/arm/mach-pnx4008/pm.c
+++ b/arch/arm/mach-pnx4008/pm.c
@@ -116,7 +116,7 @@ static int pnx4008_pm_valid(suspend_state_t state)
 	       (state == PM_SUSPEND_MEM);
 }
 
-static struct platform_suspend_ops pnx4008_pm_ops = {
+static const struct platform_suspend_ops pnx4008_pm_ops = {
 	.enter = pnx4008_pm_enter,
 	.valid = pnx4008_pm_valid,
 };
diff --git a/arch/arm/mach-pxa/pm.c b/arch/arm/mach-pxa/pm.c
index 7693355..9beb00a 100644
--- a/arch/arm/mach-pxa/pm.c
+++ b/arch/arm/mach-pxa/pm.c
@@ -95,7 +95,7 @@ void pxa_pm_finish(void)
 		pxa_cpu_pm_fns->finish();
 }
 
-static struct platform_suspend_ops pxa_pm_ops = {
+static const struct platform_suspend_ops pxa_pm_ops = {
 	.valid		= pxa_pm_valid,
 	.enter		= pxa_pm_enter,
 	.prepare	= pxa_pm_prepare,
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 629e05d..06be589 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -891,7 +891,7 @@ static void sharpsl_apm_get_power_status(struct apm_power_info *info)
 }
 
 #ifdef CONFIG_PM
-static struct platform_suspend_ops sharpsl_pm_ops = {
+static const struct platform_suspend_ops sharpsl_pm_ops = {
 	.prepare	= pxa_pm_prepare,
 	.finish		= pxa_pm_finish,
 	.enter		= corgi_pxa_pm_enter,
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index c83fdc8..ab9fc44 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -120,7 +120,7 @@ unsigned long sleep_phys_sp(void *sp)
 	return virt_to_phys(sp);
 }
 
-static struct platform_suspend_ops sa11x0_pm_ops = {
+static const struct platform_suspend_ops sa11x0_pm_ops = {
 	.enter		= sa11x0_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/arm/plat-s3c/pm.c b/arch/arm/plat-s3c/pm.c
index 8d97db2..b66cfa5 100644
--- a/arch/arm/plat-s3c/pm.c
+++ b/arch/arm/plat-s3c/pm.c
@@ -355,7 +355,7 @@ static void s3c_pm_finish(void)
 	s3c_pm_check_cleanup();
 }
 
-static struct platform_suspend_ops s3c_pm_ops = {
+static const struct platform_suspend_ops s3c_pm_ops = {
 	.enter		= s3c_pm_enter,
 	.prepare	= s3c_pm_prepare,
 	.finish		= s3c_pm_finish,
diff --git a/arch/avr32/mach-at32ap/pm.c b/arch/avr32/mach-at32ap/pm.c
index f021edf..32d680e 100644
--- a/arch/avr32/mach-at32ap/pm.c
+++ b/arch/avr32/mach-at32ap/pm.c
@@ -176,7 +176,7 @@ out:
 	return 0;
 }
 
-static struct platform_suspend_ops avr32_pm_ops = {
+static const struct platform_suspend_ops avr32_pm_ops = {
 	.valid	= avr32_pm_valid_state,
 	.enter	= avr32_pm_enter,
 };
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 8837be4..b2fb413 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -255,7 +255,7 @@ static int bfin_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-struct platform_suspend_ops bfin_pm_ops = {
+const struct platform_suspend_ops bfin_pm_ops = {
 	.enter = bfin_pm_enter,
 	.valid	= bfin_pm_valid,
 };
diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index 632f986..fd0378d 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -78,7 +78,7 @@ static void db1x_pm_end(void)
 
 }
 
-static struct platform_suspend_ops db1x_pm_ops = {
+static const struct platform_suspend_ops db1x_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 	.begin		= db1x_pm_begin,
 	.enter		= db1x_pm_enter,
diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index b5c753d..8f01abe 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -235,7 +235,7 @@ static void lite5200_pm_end(void)
 	lite5200_pm_target_state = PM_SUSPEND_ON;
 }
 
-static struct platform_suspend_ops lite5200_pm_ops = {
+static const struct platform_suspend_ops lite5200_pm_ops = {
 	.valid		= lite5200_pm_valid,
 	.begin		= lite5200_pm_begin,
 	.prepare	= lite5200_pm_prepare,
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pm.c b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
index a55b0b6..478c18e 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -180,7 +180,7 @@ void mpc52xx_pm_finish(void)
 	iounmap(mbar);
 }
 
-static struct platform_suspend_ops mpc52xx_pm_ops = {
+static const struct platform_suspend_ops mpc52xx_pm_ops = {
 	.valid		= mpc52xx_pm_valid,
 	.prepare	= mpc52xx_pm_prepare,
 	.enter		= mpc52xx_pm_enter,
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index 08e65fc..643d3ac 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -273,7 +273,7 @@ static int mpc83xx_is_pci_agent(void)
 	return ret;
 }
 
-static struct platform_suspend_ops mpc83xx_suspend_ops = {
+static const struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.valid = mpc83xx_suspend_valid,
 	.begin = mpc83xx_suspend_begin,
 	.enter = mpc83xx_suspend_enter,
diff --git a/arch/sh/boards/mach-hp6xx/pm.c b/arch/sh/boards/mach-hp6xx/pm.c
index d936c1a..304a252 100644
--- a/arch/sh/boards/mach-hp6xx/pm.c
+++ b/arch/sh/boards/mach-hp6xx/pm.c
@@ -143,7 +143,7 @@ static int hp6x0_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops hp6x0_pm_ops = {
+static const struct platform_suspend_ops hp6x0_pm_ops = {
 	.enter		= hp6x0_pm_enter,
 	.valid		= suspend_valid_only_mem,
 };
diff --git a/arch/sh/kernel/cpu/shmobile/pm.c b/arch/sh/kernel/cpu/shmobile/pm.c
index ee3c2aa..c49cee6 100644
--- a/arch/sh/kernel/cpu/shmobile/pm.c
+++ b/arch/sh/kernel/cpu/shmobile/pm.c
@@ -58,7 +58,7 @@ static int sh_pm_enter(suspend_state_t state)
 	return 0;
 }
 
-static struct platform_suspend_ops sh_pm_ops = {
+static const struct platform_suspend_ops sh_pm_ops = {
 	.enter          = sh_pm_enter,
 	.valid          = suspend_valid_only_mem,
 };
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 5f2c379..1851ae2 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -297,7 +297,7 @@ static int acpi_suspend_state_valid(suspend_state_t pm_state)
 	}
 }
 
-static struct platform_suspend_ops acpi_suspend_ops = {
+static const struct platform_suspend_ops acpi_suspend_ops = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin,
 	.prepare_late = acpi_pm_prepare,
@@ -325,7 +325,7 @@ static int acpi_suspend_begin_old(suspend_state_t pm_state)
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering has
  * been requested.
  */
-static struct platform_suspend_ops acpi_suspend_ops_old = {
+static const struct platform_suspend_ops acpi_suspend_ops_old = {
 	.valid = acpi_suspend_state_valid,
 	.begin = acpi_suspend_begin_old,
 	.prepare_late = acpi_pm_disable_gpes,
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6f308a4..b5f7ff7 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2232,7 +2232,7 @@ static int pmu_sleep_valid(suspend_state_t state)
 		&& (pmac_call_feature(PMAC_FTR_SLEEP_STATE, NULL, 0, -1) >= 0);
 }
 
-static struct platform_suspend_ops pmu_pm_ops = {
+static const struct platform_suspend_ops pmu_pm_ops = {
 	.enter = powerbook_sleep,
 	.valid = pmu_sleep_valid,
 };
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..3a2553d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -104,15 +104,15 @@ typedef int __bitwise suspend_state_t;
  *	which require special recovery actions in that situation.
  */
 struct platform_suspend_ops {
-	int (*valid)(suspend_state_t state);
-	int (*begin)(suspend_state_t state);
-	int (*prepare)(void);
-	int (*prepare_late)(void);
-	int (*enter)(suspend_state_t state);
-	void (*wake)(void);
-	void (*finish)(void);
-	void (*end)(void);
-	void (*recover)(void);
+	int (* const valid)(suspend_state_t state);
+	int (* const begin)(suspend_state_t state);
+	int (* const prepare)(void);
+	int (* const prepare_late)(void);
+	int (* const enter)(suspend_state_t state);
+	void (* const wake)(void);
+	void (* const finish)(void);
+	void (* const end)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_SUSPEND
@@ -120,7 +120,7 @@ struct platform_suspend_ops {
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
  */
-extern void suspend_set_ops(struct platform_suspend_ops *ops);
+extern void suspend_set_ops(const struct platform_suspend_ops *ops);
 extern int suspend_valid_only_mem(suspend_state_t state);
 
 /**
@@ -145,7 +145,7 @@ extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
-static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
+static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
 #endif /* !CONFIG_SUSPEND */
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6f10dfc..08e1e7b 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -23,13 +23,13 @@ const char *const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_MEM]	= "mem",
 };
 
-static struct platform_suspend_ops *suspend_ops;
+static const struct platform_suspend_ops *suspend_ops;
 
 /**
  *	suspend_set_ops - Set the global suspend method table.
  *	@ops:	Pointer to ops structure.
  */
-void suspend_set_ops(struct platform_suspend_ops *ops)
+void suspend_set_ops(const struct platform_suspend_ops *ops)
 {
 	mutex_lock(&pm_mutex);
 	suspend_ops = ops;


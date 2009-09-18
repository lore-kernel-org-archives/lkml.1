Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZIRIrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZIRIrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 04:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZIRIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 04:47:12 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:26633 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZIRIrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 04:47:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGXmskpR9cUc/2dsb2JhbADEBpAGCYIgBoFtBYFYcw
Date: Fri, 18 Sep 2009 10:47:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>,
       Wan ZongShun <mcuos.com@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Florian Fainelli <florian@openwrt.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [WATCHDOG] Pull request for v2.6.32-rc
Message-ID: <20090918084704.GD3929@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig            |   38 +++
 drivers/watchdog/Makefile           |    3 
 drivers/watchdog/ar7_wdt.c          |  107 ++++----
 drivers/watchdog/booke_wdt.c        |   57 ++++
 drivers/watchdog/coh901327_wdt.c    |    2 
 drivers/watchdog/davinci_wdt.c      |   19 +
 drivers/watchdog/iop_wdt.c          |    2 
 drivers/watchdog/nuc900_wdt.c       |  353 ++++++++++++++++++++++++++++
 drivers/watchdog/rm9k_wdt.c         |    2 
 drivers/watchdog/sbc_fitpc2_wdt.c   |  267 +++++++++++++++++++++
 drivers/watchdog/sc1200wdt.c        |    2 
 drivers/watchdog/wdt_pci.c          |   21 -
 drivers/watchdog/wm831x_wdt.c       |  441 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/watchdog.h |   52 ++++
 14 files changed, 1293 insertions(+), 73 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Sep 2 09:10:07 2009 +0000

    [WATCHDOG] sizeof cleanup
    
    Use sizeof(*) instead of sizeof * (See Codingstyle documentation).
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Aug 7 15:02:00 2009 -0700

    [WATCHDOG] wdt_pci: fix printk and variable type
    
    Fix printk format warning:
    drivers/watchdog/wdt_pci.c:652: warning: format '%04x' expects type 'unsigned int', but argument 2 has type 'resource_size_t'
    
    and then use resource_size_t for the "io" variable as well
    so that it won't be truncated.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Aug 6 18:57:49 2009 +0000

    [WATCHDOG] wdt_pci - use pci_request_region
    
    Use pci_request_region instead of request_region for this pci_driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Aug 31 13:49:14 2009 +0000

    [WATCHDOG] ar7_wdt: Fix error handling during probe.
    
    Fix error handling in the probe function.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Tested-by: Florian Fainelli <florian@openwrt.org>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Tue Jul 21 12:11:32 2009 +0200

    [WATCHDOG] ar7_wdt: convert to become a platform driver
    
    This patch converts the ar7_wdt driver to become
    a platform driver. The AR7 SoC specific identification
    and base register calculation is performed by the board
    code, therefore we no longer need to have access to
    ar7_chip_id. We also remove the reboot notifier code to
    use the platform shutdown method as Wim suggested.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Chris Friesen <cfriesen@nortel.com>
Date:   Wed Aug 12 12:02:46 2009 -0600

    [WATCHDOG] fix book E watchdog to take WDIOC_SETTIMEOUT arg in seconds
    
    The WDIOC_SETTIMEOUT argument is supposed to be a "seconds" value.
    However, the book E wdt currently treats it as a "period" which is
    interpreted in a board-specific way.
    
    This patch allows the user to pass in a "seconds" value and the driver
    will set the smallest timeout that is at least as large as specified
    by the user.  It's been tested on e500 hardware and works as
    expected.
    
    The patch only modifies the CONFIG_FSL_BOOKE case, the CONFIG_4xx case
    is left unmodified as I don't have any hardware to test it on.
    
    Signed-off-by: Chris Friesen <cfriesen@nortel.com>
    Cc: Kumar Gala <galak@gate.crashing.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Kevin Hilman <khilman@deeprootsystems.com>
Date:   Tue Feb 10 20:30:37 2009 -0800

    [WATCHDOG] davinci: use clock framework for timer frequency
    
    Remove use of CLOCK_TICK_RATE in favor of using clock framework
    for getting timer frequency.
    
    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
    Signed-off-by: Russell King <linux@arm.linux.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Aug 10 00:04:35 2009 +0200

    [WATCHDOG] Use DIV_ROUND_UP() macro in the coh901327 WDT
    
    I saw Julia Lawalls various commits fixing up the use of rounding
    macros and since my already submitted patch was not caught in this
    I took it upon myself to fix it up for this driver as well.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Mon Jul 27 14:46:12 2009 +0100

    [WATCHDOG] Add support for WM831x watchdog
    
    The WM831x series of devices provide a watchdog with configurable
    behaviour on timer expiry.
    
    Currently this driver support refreshes via a register or GPIO line and
    autonomous refreshes from a hardware source (eg, a clock).
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wan ZongShun <mcuos.com@gmail.com>
Date:   Mon Aug 17 18:00:01 2009 +0800

    [WATCHDOG] Add watchdog driver for NUC900
    
    Add watchdog device driver for the Nuvoton NUC900 series SoCs.
    
    Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Denis Turischev <denis@compulab.co.il>
Date:   Tue Jul 21 13:13:29 2009 +0300

    [WATCHDOG] add SBC-FITPC2 watchdog driver
    
    Add support for watchdog found on SBC-FITPC2 board.
    
    Signed-off-by: Denis Turischev <denis@compulab.co.il>
    Signed-off-by: Mike Rapoport <mike@compulab.co.il>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b1ccc04..ff3eb8f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -55,6 +55,13 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config WM831X_WATCHDOG
+	tristate "WM831x watchdog"
+	depends on MFD_WM831X
+	help
+	  Support for the watchdog in the WM831x AudioPlus PMICs.  When
+	  the watchdog triggers the system will be reset.
+
 config WM8350_WATCHDOG
 	tristate "WM8350 watchdog"
 	depends on MFD_WM8350
@@ -266,6 +273,15 @@ config STMP3XXX_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called stmp3xxx_wdt.
 
+config NUC900_WATCHDOG
+	tristate "Nuvoton NUC900 watchdog"
+	depends on ARCH_W90X900
+	help
+	  Say Y here if to include support for the watchdog timer
+	  for the Nuvoton NUC900 series SoCs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called nuc900_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
@@ -369,6 +385,28 @@ config SC520_WDT
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called sc520_wdt.
 
+config SBC_FITPC2_WATCHDOG
+	tristate "Compulab SBC-FITPC2 watchdog"
+	depends on X86
+	---help---
+	  This is the driver for the built-in watchdog timer on the fit-PC2
+	  Single-board computer made by Compulab.
+
+	  It`s possible to enable watchdog timer either from BIOS (F2) or from booted Linux.
+	  When "Watchdog Timer Value" enabled one can set 31-255 s operational range.
+
+	  Entering BIOS setup temporary disables watchdog operation regardless to current state,
+	  so system will not be restarted while user in BIOS setup.
+
+	  Once watchdog was enabled the system will be restarted every
+	  "Watchdog Timer Value" period, so to prevent it user can restart or
+	  disable the watchdog.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc_fitpc2_wdt.
+
+	  Most people will say N.
+
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 3d77429..348b3b8 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
+obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -64,6 +65,7 @@ obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
+obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
@@ -139,5 +141,6 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 # XTENSA Architecture
 
 # Architecture Independant
+obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2f8643e..2e94b71 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -28,9 +28,8 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
+#include <linux/platform_device.h>
 #include <linux/watchdog.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
@@ -76,24 +75,10 @@ static unsigned expect_close;
 /* XXX currently fixed, allows max margin ~68.72 secs */
 #define prescale_value 0xffff
 
-/* Offset of the WDT registers */
-static unsigned long ar7_regs_wdt;
+/* Resource of the WDT registers */
+static struct resource *ar7_regs_wdt;
 /* Pointer to the remapped WDT IO space */
 static struct ar7_wdt *ar7_wdt;
-static void ar7_wdt_get_regs(void)
-{
-	u16 chip_id = ar7_chip_id();
-	switch (chip_id) {
-	case AR7_CHIP_7100:
-	case AR7_CHIP_7200:
-		ar7_regs_wdt = AR7_REGS_WDT;
-		break;
-	default:
-		ar7_regs_wdt = UR8_REGS_WDT;
-		break;
-	}
-}
-
 
 static void ar7_wdt_kick(u32 value)
 {
@@ -202,20 +187,6 @@ static int ar7_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int ar7_wdt_notify_sys(struct notifier_block *this,
-			      unsigned long code, void *unused)
-{
-	if (code == SYS_HALT || code == SYS_POWER_OFF)
-		if (!nowayout)
-			ar7_wdt_disable_wdt();
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ar7_wdt_notifier = {
-	.notifier_call = ar7_wdt_notify_sys,
-};
-
 static ssize_t ar7_wdt_write(struct file *file, const char *data,
 			     size_t len, loff_t *ppos)
 {
@@ -299,56 +270,86 @@ static struct miscdevice ar7_wdt_miscdev = {
 	.fops		= &ar7_wdt_fops,
 };
 
-static int __init ar7_wdt_init(void)
+static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 {
 	int rc;
 
 	spin_lock_init(&wdt_lock);
 
-	ar7_wdt_get_regs();
+	ar7_regs_wdt =
+		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
+	if (!ar7_regs_wdt) {
+		printk(KERN_ERR DRVNAME ": could not get registers resource\n");
+		rc = -ENODEV;
+		goto out;
+	}
 
-	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
-							LONGNAME)) {
+	if (!request_mem_region(ar7_regs_wdt->start,
+				resource_size(ar7_regs_wdt), LONGNAME)) {
 		printk(KERN_WARNING DRVNAME ": watchdog I/O region busy\n");
-		return -EBUSY;
+		rc = -EBUSY;
+		goto out;
 	}
 
-	ar7_wdt = (struct ar7_wdt *)
-			ioremap(ar7_regs_wdt, sizeof(struct ar7_wdt));
+	ar7_wdt = ioremap(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
+	if (!ar7_wdt) {
+		printk(KERN_ERR DRVNAME ": could not ioremap registers\n");
+		rc = -ENXIO;
+		goto out_mem_region;
+	}
 
 	ar7_wdt_disable_wdt();
 	ar7_wdt_prescale(prescale_value);
 	ar7_wdt_update_margin(margin);
 
-	rc = register_reboot_notifier(&ar7_wdt_notifier);
-	if (rc) {
-		printk(KERN_ERR DRVNAME
-			": unable to register reboot notifier\n");
-		goto out_alloc;
-	}
-
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
 		printk(KERN_ERR DRVNAME ": unable to register misc device\n");
-		goto out_register;
+		goto out_alloc;
 	}
 	goto out;
 
-out_register:
-	unregister_reboot_notifier(&ar7_wdt_notifier);
 out_alloc:
 	iounmap(ar7_wdt);
-	release_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt));
+out_mem_region:
+	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
 out:
 	return rc;
 }
 
-static void __exit ar7_wdt_cleanup(void)
+static int __devexit ar7_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&ar7_wdt_miscdev);
-	unregister_reboot_notifier(&ar7_wdt_notifier);
 	iounmap(ar7_wdt);
-	release_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt));
+	release_mem_region(ar7_regs_wdt->start, resource_size(ar7_regs_wdt));
+
+	return 0;
+}
+
+static void ar7_wdt_shutdown(struct platform_device *pdev)
+{
+	if (!nowayout)
+		ar7_wdt_disable_wdt();
+}
+
+static struct platform_driver ar7_wdt_driver = {
+	.probe = ar7_wdt_probe,
+	.remove = __devexit_p(ar7_wdt_remove),
+	.shutdown = ar7_wdt_shutdown,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "ar7_wdt",
+	},
+};
+
+static int __init ar7_wdt_init(void)
+{
+	return platform_driver_register(&ar7_wdt_driver);
+}
+
+static void __exit ar7_wdt_cleanup(void)
+{
+	platform_driver_unregister(&ar7_wdt_driver);
 }
 
 module_init(ar7_wdt_init);
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 225398f..e8380ef 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -22,6 +22,8 @@
 
 #include <asm/reg_booke.h>
 #include <asm/system.h>
+#include <asm/time.h>
+#include <asm/div64.h>
 
 /* If the kernel parameter wdt=1, the watchdog will be enabled at boot.
  * Also, the wdt_period sets the watchdog timer period timeout.
@@ -32,7 +34,7 @@
  */
 
 #ifdef	CONFIG_FSL_BOOKE
-#define WDT_PERIOD_DEFAULT 63	/* Ex. wdt_period=28 bus=333Mhz,reset=~40sec */
+#define WDT_PERIOD_DEFAULT 38	/* Ex. wdt_period=28 bus=333Mhz,reset=~40sec */
 #else
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
@@ -41,7 +43,7 @@ u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
-#define WDTP(x)		((((63-x)&0x3)<<30)|(((63-x)&0x3c)<<15))
+#define WDTP(x)		((((x)&0x3)<<30)|(((x)&0x3c)<<15))
 #define WDTP_MASK	(WDTP(0))
 #else
 #define WDTP(x)		(TCR_WP(x))
@@ -50,6 +52,45 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 static DEFINE_SPINLOCK(booke_wdt_lock);
 
+/* For the specified period, determine the number of seconds
+ * corresponding to the reset time.  There will be a watchdog
+ * exception at approximately 3/5 of this time.
+ *
+ * The formula to calculate this is given by:
+ * 2.5 * (2^(63-period+1)) / timebase_freq
+ *
+ * In order to simplify things, we assume that period is
+ * at least 1.  This will still result in a very long timeout.
+ */
+static unsigned long long period_to_sec(unsigned int period)
+{
+	unsigned long long tmp = 1ULL << (64 - period);
+	unsigned long tmp2 = ppc_tb_freq;
+
+	/* tmp may be a very large number and we don't want to overflow,
+	 * so divide the timebase freq instead of multiplying tmp
+	 */
+	tmp2 = tmp2 / 5 * 2;
+
+	do_div(tmp, tmp2);
+	return tmp;
+}
+
+/*
+ * This procedure will find the highest period which will give a timeout
+ * greater than the one required. e.g. for a bus speed of 66666666 and
+ * and a parameter of 2 secs, then this procedure will return a value of 38.
+ */
+static unsigned int sec_to_period(unsigned int secs)
+{
+	unsigned int period;
+	for (period = 63; period > 0; period--) {
+		if (period_to_sec(period) >= secs)
+			return period;
+	}
+	return 0;
+}
+
 static void __booke_wdt_ping(void *data)
 {
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
@@ -93,7 +134,7 @@ static long booke_wdt_ioctl(struct file *file,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(arg, &ident, sizeof(struct watchdog_info)))
+		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
 		return put_user(ident.options, p);
@@ -115,8 +156,16 @@ static long booke_wdt_ioctl(struct file *file,
 		booke_wdt_ping();
 		return 0;
 	case WDIOC_SETTIMEOUT:
-		if (get_user(booke_wdt_period, p))
+		if (get_user(tmp, p))
 			return -EFAULT;
+#ifdef	CONFIG_FSL_BOOKE
+		/* period of 1 gives the largest possible timeout */
+		if (tmp > period_to_sec(1))
+			return -EINVAL;
+		booke_wdt_period = sec_to_period(tmp);
+#else
+		booke_wdt_period = tmp;
+#endif
 		mtspr(SPRN_TCR, (mfspr(SPRN_TCR) & ~WDTP_MASK) |
 						WDTP(booke_wdt_period));
 		return 0;
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index aec7cef..381026c 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -110,7 +110,7 @@ static void coh901327_enable(u16 timeout)
 	 * Wait 3 32 kHz cycles for it to take effect
 	 */
 	freq = clk_get_rate(clk);
-	delay_ns = (1000000000 + freq - 1) / freq; /* Freq to ns and round up */
+	delay_ns = DIV_ROUND_UP(1000000000, freq); /* Freq to ns and round up */
 	delay_ns = 3 * delay_ns; /* Wait 3 cycles */
 	ndelay(delay_ns);
 	/* Enable the watchdog interrupt */
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 83e22e7..9d7520f 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/device.h>
+#include <linux/clk.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -69,6 +70,7 @@ static unsigned long wdt_status;
 
 static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
+struct clk		*wdt_clk;
 
 static void wdt_service(void)
 {
@@ -86,6 +88,9 @@ static void wdt_enable(void)
 {
 	u32 tgcr;
 	u32 timer_margin;
+	unsigned long wdt_freq;
+
+	wdt_freq = clk_get_rate(wdt_clk);
 
 	spin_lock(&io_lock);
 
@@ -99,9 +104,9 @@ static void wdt_enable(void)
 	iowrite32(0, wdt_base + TIM12);
 	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
+	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
 	iowrite32(timer_margin, wdt_base + PRD12);
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
+	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
 	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
 	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
@@ -199,6 +204,12 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device *dev = &pdev->dev;
 
+	wdt_clk = clk_get(dev, NULL);
+	if (WARN_ON(IS_ERR(wdt_clk)))
+		return PTR_ERR(wdt_clk);
+
+	clk_enable(wdt_clk);
+
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
@@ -245,6 +256,10 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
 		kfree(wdt_mem);
 		wdt_mem = NULL;
 	}
+
+	clk_disable(wdt_clk);
+	clk_put(wdt_clk);
+
 	return 0;
 }
 
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index 0c90596..aef9478 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -139,7 +139,7 @@ static long iop_wdt_ioctl(struct file *file,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof ident))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			ret = -EFAULT;
 		else
 			ret = 0;
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
new file mode 100644
index 0000000..adefe3a
--- /dev/null
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -0,0 +1,353 @@
+/*
+ * Copyright (c) 2009 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+
+#define REG_WTCR		0x1c
+#define WTCLK			(0x01 << 10)
+#define WTE			(0x01 << 7)	/*wdt enable*/
+#define WTIS			(0x03 << 4)
+#define WTIF			(0x01 << 3)
+#define WTRF			(0x01 << 2)
+#define WTRE			(0x01 << 1)
+#define WTR			(0x01 << 0)
+/*
+ * The watchdog time interval can be calculated via following formula:
+ * WTIS		real time interval (formula)
+ * 0x00		((2^ 14 ) * ((external crystal freq) / 256))seconds
+ * 0x01		((2^ 16 ) * ((external crystal freq) / 256))seconds
+ * 0x02		((2^ 18 ) * ((external crystal freq) / 256))seconds
+ * 0x03		((2^ 20 ) * ((external crystal freq) / 256))seconds
+ *
+ * The external crystal freq is 15Mhz in the nuc900 evaluation board.
+ * So 0x00 = +-0.28 seconds, 0x01 = +-1.12 seconds, 0x02 = +-4.48 seconds,
+ * 0x03 = +- 16.92 seconds..
+ */
+#define WDT_HW_TIMEOUT		0x02
+#define WDT_TIMEOUT		(HZ/2)
+#define WDT_HEARTBEAT		15
+
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
+	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct nuc900_wdt {
+	struct resource  *res;
+	struct clk	 *wdt_clock;
+	struct platform_device *pdev;
+	void __iomem	 *wdt_base;
+	char		 expect_close;
+	struct timer_list timer;
+	spinlock_t       wdt_lock;
+	unsigned long next_heartbeat;
+};
+
+static unsigned long nuc900wdt_busy;
+struct nuc900_wdt *nuc900_wdt;
+
+static inline void nuc900_wdt_keepalive(void)
+{
+	unsigned int val;
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val |= (WTR | WTIF);
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+}
+
+static inline void nuc900_wdt_start(void)
+{
+	unsigned int val;
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val |= (WTRE | WTE | WTR | WTCLK | WTIF);
+	val &= ~WTIS;
+	val |= (WDT_HW_TIMEOUT << 0x04);
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+
+	nuc900_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+	mod_timer(&nuc900_wdt->timer, jiffies + WDT_TIMEOUT);
+}
+
+static inline void nuc900_wdt_stop(void)
+{
+	unsigned int val;
+
+	del_timer(&nuc900_wdt->timer);
+
+	spin_lock(&nuc900_wdt->wdt_lock);
+
+	val = __raw_readl(nuc900_wdt->wdt_base + REG_WTCR);
+	val &= ~WTE;
+	__raw_writel(val, nuc900_wdt->wdt_base + REG_WTCR);
+
+	spin_unlock(&nuc900_wdt->wdt_lock);
+}
+
+static inline void nuc900_wdt_ping(void)
+{
+	nuc900_wdt->next_heartbeat = jiffies + heartbeat * HZ;
+}
+
+static int nuc900_wdt_open(struct inode *inode, struct file *file)
+{
+
+	if (test_and_set_bit(0, &nuc900wdt_busy))
+		return -EBUSY;
+
+	nuc900_wdt_start();
+
+	return nonseekable_open(inode, file);
+}
+
+static int nuc900_wdt_close(struct inode *inode, struct file *file)
+{
+	if (nuc900_wdt->expect_close == 42)
+		nuc900_wdt_stop();
+	else {
+		dev_crit(&nuc900_wdt->pdev->dev,
+			"Unexpected close, not stopping watchdog!\n");
+		nuc900_wdt_ping();
+	}
+
+	nuc900_wdt->expect_close = 0;
+	clear_bit(0, &nuc900wdt_busy);
+	return 0;
+}
+
+static const struct watchdog_info nuc900_wdt_info = {
+	.identity	= "nuc900 watchdog",
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+						WDIOF_MAGICCLOSE,
+};
+
+static long nuc900_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &nuc900_wdt_info,
+				sizeof(nuc900_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		nuc900_wdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		heartbeat = new_value;
+		nuc900_wdt_ping();
+
+		return put_user(new_value, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static ssize_t nuc900_wdt_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
+{
+	if (!len)
+		return 0;
+
+	/* Scan for magic character */
+	if (!nowayout) {
+		size_t i;
+
+		nuc900_wdt->expect_close = 0;
+
+		for (i = 0; i < len; i++) {
+			char c;
+			if (get_user(c, data + i))
+				return -EFAULT;
+			if (c == 'V') {
+				nuc900_wdt->expect_close = 42;
+				break;
+			}
+		}
+	}
+
+	nuc900_wdt_ping();
+	return len;
+}
+
+static void nuc900_wdt_timer_ping(unsigned long data)
+{
+	if (time_before(jiffies, nuc900_wdt->next_heartbeat)) {
+		nuc900_wdt_keepalive();
+		mod_timer(&nuc900_wdt->timer, jiffies + WDT_TIMEOUT);
+	} else
+		dev_warn(&nuc900_wdt->pdev->dev, "Will reset the machine !\n");
+}
+
+static const struct file_operations nuc900wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= nuc900_wdt_ioctl,
+	.open		= nuc900_wdt_open,
+	.release	= nuc900_wdt_close,
+	.write		= nuc900_wdt_write,
+};
+
+static struct miscdevice nuc900wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &nuc900wdt_fops,
+};
+
+static int __devinit nuc900wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
+	if (!nuc900_wdt)
+		return -ENOMEM;
+
+	nuc900_wdt->pdev = pdev;
+
+	spin_lock_init(&nuc900_wdt->wdt_lock);
+
+	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (nuc900_wdt->res == NULL) {
+		dev_err(&pdev->dev, "no memory resource specified\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	if (!request_mem_region(nuc900_wdt->res->start,
+				resource_size(nuc900_wdt->res), pdev->name)) {
+		dev_err(&pdev->dev, "failed to get memory region\n");
+		ret = -ENOENT;
+		goto err_get;
+	}
+
+	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+	if (nuc900_wdt->wdt_base == NULL) {
+		dev_err(&pdev->dev, "failed to ioremap() region\n");
+		ret = -EINVAL;
+		goto err_req;
+	}
+
+	nuc900_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(nuc900_wdt->wdt_clock)) {
+		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
+		ret = PTR_ERR(nuc900_wdt->wdt_clock);
+		goto err_map;
+	}
+
+	clk_enable(nuc900_wdt->wdt_clock);
+
+	setup_timer(&nuc900_wdt->timer, nuc900_wdt_timer_ping, 0);
+
+	if (misc_register(&nuc900wdt_miscdev)) {
+		dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto err_clk;
+	}
+
+	return 0;
+
+err_clk:
+	clk_disable(nuc900_wdt->wdt_clock);
+	clk_put(nuc900_wdt->wdt_clock);
+err_map:
+	iounmap(nuc900_wdt->wdt_base);
+err_req:
+	release_mem_region(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+err_get:
+	kfree(nuc900_wdt);
+	return ret;
+}
+
+static int __devexit nuc900wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&nuc900wdt_miscdev);
+
+	clk_disable(nuc900_wdt->wdt_clock);
+	clk_put(nuc900_wdt->wdt_clock);
+
+	iounmap(nuc900_wdt->wdt_base);
+
+	release_mem_region(nuc900_wdt->res->start,
+					resource_size(nuc900_wdt->res));
+
+	kfree(nuc900_wdt);
+
+	return 0;
+}
+
+static struct platform_driver nuc900wdt_driver = {
+	.probe		= nuc900wdt_probe,
+	.remove		= __devexit_p(nuc900wdt_remove),
+	.driver		= {
+		.name	= "nuc900-wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init nuc900_wdt_init(void)
+{
+	return platform_driver_register(&nuc900wdt_driver);
+}
+
+static void __exit nuc900_wdt_exit(void)
+{
+	platform_driver_unregister(&nuc900wdt_driver);
+}
+
+module_init(nuc900_wdt_init);
+module_exit(nuc900_wdt_exit);
+
+MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
+MODULE_DESCRIPTION("Watchdog driver for NUC900");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:nuc900-wdt");
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index 2e44426..bb66958 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -340,7 +340,7 @@ static const struct resource *wdt_gpi_get_resource(struct platform_device *pdv,
 					const char *name, unsigned int type)
 {
 	char buf[80];
-	if (snprintf(buf, sizeof buf, "%s_0", name) >= sizeof buf)
+	if (snprintf(buf, sizeof(buf), "%s_0", name) >= sizeof(buf))
 		return NULL;
 	return platform_get_resource_byname(pdv, type, buf);
 }
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
new file mode 100644
index 0000000..852ca19
--- /dev/null
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -0,0 +1,267 @@
+/*
+ * Watchdog driver for SBC-FITPC2 board
+ *
+ * Author: Denis Turischev <denis@compulab.co.il>
+ *
+ * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/moduleparam.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/system.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int margin = 60;	/* (secs) Default is 1 minute */
+static unsigned long wdt_status;
+static DEFINE_SPINLOCK(wdt_lock);
+
+#define WDT_IN_USE		0
+#define WDT_OK_TO_CLOSE		1
+
+#define COMMAND_PORT		0x4c
+#define DATA_PORT		0x48
+
+#define IFACE_ON_COMMAND	1
+#define REBOOT_COMMAND		2
+
+#define WATCHDOG_NAME 		"SBC-FITPC2 Watchdog"
+
+static void wdt_send_data(unsigned char command, unsigned char data)
+{
+	outb(command, COMMAND_PORT);
+	mdelay(100);
+	outb(data, DATA_PORT);
+	mdelay(200);
+}
+
+static void wdt_enable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 1);
+	wdt_send_data(REBOOT_COMMAND, margin);
+	spin_unlock(&wdt_lock);
+}
+
+static void wdt_disable(void)
+{
+	spin_lock(&wdt_lock);
+	wdt_send_data(IFACE_ON_COMMAND, 0);
+	wdt_send_data(REBOOT_COMMAND, 0);
+	spin_unlock(&wdt_lock);
+}
+
+static int fitpc2_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t fitpc2_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
+{
+	size_t i;
+
+	if (!len)
+		return 0;
+
+	if (nowayout) {
+		len = 0;
+		goto out;
+	}
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	for (i = 0; i != len; i++) {
+		char c;
+
+		if (get_user(c, data + i))
+			return -EFAULT;
+
+		if (c == 'V')
+			set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	}
+
+out:
+	wdt_enable();
+
+	return len;
+}
+
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING,
+	.identity	= WATCHDOG_NAME,
+};
+
+
+static long fitpc2_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, (int *)arg);
+		if (ret)
+			break;
+
+		if (time < 31 || time > 255) {
+			ret = -EINVAL;
+			break;
+		}
+
+		margin = time;
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(margin, (int *)arg);
+		break;
+	}
+
+	return ret;
+}
+
+static int fitpc2_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+		wdt_disable();
+		pr_info("Device disabled\n");
+	} else {
+		pr_warning("Device closed unexpectedly -"
+			" timer will not stop\n");
+		wdt_enable();
+	}
+
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+
+static const struct file_operations fitpc2_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= fitpc2_wdt_write,
+	.unlocked_ioctl	= fitpc2_wdt_ioctl,
+	.open		= fitpc2_wdt_open,
+	.release	= fitpc2_wdt_release,
+};
+
+static struct miscdevice fitpc2_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &fitpc2_wdt_fops,
+};
+
+static int __init fitpc2_wdt_init(void)
+{
+	int err;
+
+	if (strcmp("SBC-FITPC2", dmi_get_system_info(DMI_BOARD_NAME))) {
+		pr_info("board name is: %s. Should be SBC-FITPC2\n",
+			dmi_get_system_info(DMI_BOARD_NAME));
+		return -ENODEV;
+	}
+
+	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
+		return -EIO;
+	}
+
+	if (!request_region(DATA_PORT, 1, WATCHDOG_NAME)) {
+		pr_err("I/O address 0x%04x already in use\n", DATA_PORT);
+		err = -EIO;
+		goto err_data_port;
+	}
+
+	if (margin < 31 || margin > 255) {
+		pr_err("margin must be in range 31 - 255"
+		       " seconds, you tried to set %d\n", margin);
+		err = -EINVAL;
+		goto err_margin;
+	}
+
+	err = misc_register(&fitpc2_wdt_miscdev);
+	if (!err) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, err);
+		goto err_margin;
+	}
+
+	return 0;
+
+err_margin:
+	release_region(DATA_PORT, 1);
+err_data_port:
+	release_region(COMMAND_PORT, 1);
+
+	return err;
+}
+
+static void __exit fitpc2_wdt_exit(void)
+{
+	misc_deregister(&fitpc2_wdt_miscdev);
+	release_region(DATA_PORT, 1);
+	release_region(COMMAND_PORT, 1);
+}
+
+module_init(fitpc2_wdt_init);
+module_exit(fitpc2_wdt_exit);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("SBC-FITPC2 Watchdog");
+
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index b5e19c1..c01daca 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -197,7 +197,7 @@ static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof ident))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 7a1bdc7..f368dd8 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -80,7 +80,7 @@ static unsigned long open_lock;
 static DEFINE_SPINLOCK(wdtpci_lock);
 static char expect_close;
 
-static int io;
+static resource_size_t io;
 static int irq;
 
 /* Default timeout */
@@ -647,14 +647,15 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 		goto out_pci;
 	}
 
-	irq = dev->irq;
-	io = pci_resource_start(dev, 2);
-
-	if (request_region(io, 16, "wdt_pci") == NULL) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n", io);
+	if (pci_request_region(dev, 2, "wdt_pci")) {
+		printk(KERN_ERR PFX "I/O address 0x%llx already in use\n",
+			(unsigned long long)pci_resource_start(dev, 2));
 		goto out_pci;
 	}
 
+	irq = dev->irq;
+	io = pci_resource_start(dev, 2);
+
 	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
 		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
@@ -662,8 +663,8 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	}
 
 	printk(KERN_INFO
-	 "PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
-								io, irq);
+	 "PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%llx (Interrupt %d)\n",
+					(unsigned long long)io, irq);
 
 	/* Check that the heartbeat value is within its range;
 	   if not reset to the default */
@@ -717,7 +718,7 @@ out_rbt:
 out_irq:
 	free_irq(irq, &wdtpci_miscdev);
 out_reg:
-	release_region(io, 16);
+	pci_release_region(dev, 2);
 out_pci:
 	pci_disable_device(dev);
 	goto out;
@@ -733,7 +734,7 @@ static void __devexit wdtpci_remove_one(struct pci_dev *pdev)
 		misc_deregister(&temp_miscdev);
 	unregister_reboot_notifier(&wdtpci_notifier);
 	free_irq(irq, &wdtpci_miscdev);
-	release_region(io, 16);
+	pci_release_region(pdev, 2);
 	pci_disable_device(pdev);
 	dev_count--;
 }
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
new file mode 100644
index 0000000..775bcd8
--- /dev/null
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -0,0 +1,441 @@
+/*
+ * Watchdog driver for the wm831x PMICs
+ *
+ * Copyright (C) 2009 Wolfson Microelectronics
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/watchdog.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static unsigned long wm831x_wdt_users;
+static struct miscdevice wm831x_wdt_miscdev;
+static int wm831x_wdt_expect_close;
+static DEFINE_MUTEX(wdt_mutex);
+static struct wm831x *wm831x;
+static unsigned int update_gpio;
+static unsigned int update_state;
+
+/* We can't use the sub-second values here but they're included
+ * for completeness.  */
+static struct {
+	int time;  /* Seconds */
+	u16 val;   /* WDOG_TO value */
+} wm831x_wdt_cfgs[] = {
+	{  1, 2 },
+	{  2, 3 },
+	{  4, 4 },
+	{  8, 5 },
+	{ 16, 6 },
+	{ 32, 7 },
+	{ 33, 7 },  /* Actually 32.768s so include both, others round down */
+};
+
+static int wm831x_wdt_set_timeout(struct wm831x *wm831x, u16 value)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_TO_MASK, value);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_start(struct wm831x *wm831x)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_ENA, WM831X_WDOG_ENA);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_stop(struct wm831x *wm831x)
+{
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_ENA, 0);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_kick(struct wm831x *wm831x)
+{
+	int ret;
+	u16 reg;
+
+	mutex_lock(&wdt_mutex);
+
+	if (update_gpio) {
+		gpio_set_value_cansleep(update_gpio, update_state);
+		update_state = !update_state;
+		ret = 0;
+		goto out;
+	}
+
+
+	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+
+	if (!(reg & WM831X_WDOG_RST_SRC)) {
+		dev_err(wm831x->dev, "Hardware watchdog update unsupported\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	reg |= WM831X_WDOG_RESET;
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_reg_write(wm831x, WM831X_WATCHDOG, reg);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
+	}
+
+out:
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int wm831x_wdt_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if (!wm831x)
+		return -ENODEV;
+
+	if (test_and_set_bit(0, &wm831x_wdt_users))
+		return -EBUSY;
+
+	ret = wm831x_wdt_start(wm831x);
+	if (ret != 0)
+		return ret;
+
+	return nonseekable_open(inode, file);
+}
+
+static int wm831x_wdt_release(struct inode *inode, struct file *file)
+{
+	if (wm831x_wdt_expect_close)
+		wm831x_wdt_stop(wm831x);
+	else {
+		dev_warn(wm831x->dev, "Watchdog device closed uncleanly\n");
+		wm831x_wdt_kick(wm831x);
+	}
+
+	clear_bit(0, &wm831x_wdt_users);
+
+	return 0;
+}
+
+static ssize_t wm831x_wdt_write(struct file *file,
+				const char __user *data, size_t count,
+				loff_t *ppos)
+{
+	size_t i;
+
+	if (count) {
+		wm831x_wdt_kick(wm831x);
+
+		if (!nowayout) {
+			/* In case it was set long ago */
+			wm831x_wdt_expect_close = 0;
+
+			/* scan to see whether or not we got the magic
+			   character */
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					wm831x_wdt_expect_close = 42;
+			}
+		}
+	}
+	return count;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "WM831x Watchdog",
+};
+
+static long wm831x_wdt_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	int ret = -ENOTTY, time, i;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	u16 reg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		ret = -EINVAL;
+
+		/* Setting both simultaneously means at least one must fail */
+		if (options == WDIOS_DISABLECARD)
+			ret = wm831x_wdt_start(wm831x);
+
+		if (options == WDIOS_ENABLECARD)
+			ret = wm831x_wdt_stop(wm831x);
+		break;
+	}
+
+	case WDIOC_KEEPALIVE:
+		ret = wm831x_wdt_kick(wm831x);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+
+		if (time == 0) {
+			if (nowayout)
+				ret = -EINVAL;
+			else
+				wm831x_wdt_stop(wm831x);
+			break;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+			if (wm831x_wdt_cfgs[i].time == time)
+				break;
+		if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+			ret = -EINVAL;
+		else
+			ret = wm831x_wdt_set_timeout(wm831x,
+						     wm831x_wdt_cfgs[i].val);
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+		reg &= WM831X_WDOG_TO_MASK;
+		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+			if (wm831x_wdt_cfgs[i].val == reg)
+				break;
+		if (i == ARRAY_SIZE(wm831x_wdt_cfgs)) {
+			dev_warn(wm831x->dev,
+				 "Unknown watchdog configuration: %x\n", reg);
+			ret = -EINVAL;
+		} else
+			ret = put_user(wm831x_wdt_cfgs[i].time, p);
+
+	}
+
+	return ret;
+}
+
+static const struct file_operations wm831x_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = wm831x_wdt_write,
+	.unlocked_ioctl = wm831x_wdt_ioctl,
+	.open = wm831x_wdt_open,
+	.release = wm831x_wdt_release,
+};
+
+static struct miscdevice wm831x_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wm831x_wdt_fops,
+};
+
+static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
+{
+	struct wm831x_pdata *chip_pdata;
+	struct wm831x_watchdog_pdata *pdata;
+	int reg, ret;
+
+	wm831x = dev_get_drvdata(pdev->dev.parent);
+
+	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read watchdog status: %d\n",
+			ret);
+		goto err;
+	}
+	reg = ret;
+
+	if (reg & WM831X_WDOG_DEBUG)
+		dev_warn(wm831x->dev, "Watchdog is paused\n");
+
+	/* Apply any configuration */
+	if (pdev->dev.parent->platform_data) {
+		chip_pdata = pdev->dev.parent->platform_data;
+		pdata = chip_pdata->watchdog;
+	} else {
+		pdata = NULL;
+	}
+
+	if (pdata) {
+		reg &= ~(WM831X_WDOG_SECACT_MASK | WM831X_WDOG_PRIMACT_MASK |
+			 WM831X_WDOG_RST_SRC);
+
+		reg |= pdata->primary << WM831X_WDOG_PRIMACT_SHIFT;
+		reg |= pdata->secondary << WM831X_WDOG_SECACT_SHIFT;
+		reg |= pdata->software << WM831X_WDOG_RST_SRC_SHIFT;
+
+		if (pdata->update_gpio) {
+			ret = gpio_request(pdata->update_gpio,
+					   "Watchdog update");
+			if (ret < 0) {
+				dev_err(wm831x->dev,
+					"Failed to request update GPIO: %d\n",
+					ret);
+				goto err;
+			}
+
+			ret = gpio_direction_output(pdata->update_gpio, 0);
+			if (ret != 0) {
+				dev_err(wm831x->dev,
+					"gpio_direction_output returned: %d\n",
+					ret);
+				goto err_gpio;
+			}
+
+			update_gpio = pdata->update_gpio;
+
+			/* Make sure the watchdog takes hardware updates */
+			reg |= WM831X_WDOG_RST_SRC;
+		}
+
+		ret = wm831x_reg_unlock(wm831x);
+		if (ret == 0) {
+			ret = wm831x_reg_write(wm831x, WM831X_WATCHDOG, reg);
+			wm831x_reg_lock(wm831x);
+		} else {
+			dev_err(wm831x->dev,
+				"Failed to unlock security key: %d\n", ret);
+			goto err_gpio;
+		}
+	}
+
+	wm831x_wdt_miscdev.parent = &pdev->dev;
+
+	ret = misc_register(&wm831x_wdt_miscdev);
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to register miscdev: %d\n", ret);
+		goto err_gpio;
+	}
+
+	return 0;
+
+err_gpio:
+	if (update_gpio) {
+		gpio_free(update_gpio);
+		update_gpio = 0;
+	}
+err:
+	return ret;
+}
+
+static int __devexit wm831x_wdt_remove(struct platform_device *pdev)
+{
+	if (update_gpio) {
+		gpio_free(update_gpio);
+		update_gpio = 0;
+	}
+
+	misc_deregister(&wm831x_wdt_miscdev);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_wdt_driver = {
+	.probe = wm831x_wdt_probe,
+	.remove = __devexit_p(wm831x_wdt_remove),
+	.driver = {
+		.name = "wm831x-watchdog",
+	},
+};
+
+static int __init wm831x_wdt_init(void)
+{
+	return platform_driver_register(&wm831x_wdt_driver);
+}
+module_init(wm831x_wdt_init);
+
+static void __exit wm831x_wdt_exit(void)
+{
+	platform_driver_unregister(&wm831x_wdt_driver);
+}
+module_exit(wm831x_wdt_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM831x Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-watchdog");
diff --git a/include/linux/mfd/wm831x/watchdog.h b/include/linux/mfd/wm831x/watchdog.h
new file mode 100644
index 0000000..97a99b5
--- /dev/null
+++ b/include/linux/mfd/wm831x/watchdog.h
@@ -0,0 +1,52 @@
+/*
+ * include/linux/mfd/wm831x/watchdog.h -- Watchdog for WM831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_WATCHDOG_H__
+#define __MFD_WM831X_WATCHDOG_H__
+
+
+/*
+ * R16388 (0x4004) - Watchdog
+ */
+#define WM831X_WDOG_ENA                         0x8000  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_MASK                    0x8000  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_SHIFT                       15  /* WDOG_ENA */
+#define WM831X_WDOG_ENA_WIDTH                        1  /* WDOG_ENA */
+#define WM831X_WDOG_DEBUG                       0x4000  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_MASK                  0x4000  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_SHIFT                     14  /* WDOG_DEBUG */
+#define WM831X_WDOG_DEBUG_WIDTH                      1  /* WDOG_DEBUG */
+#define WM831X_WDOG_RST_SRC                     0x2000  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_MASK                0x2000  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_SHIFT                   13  /* WDOG_RST_SRC */
+#define WM831X_WDOG_RST_SRC_WIDTH                    1  /* WDOG_RST_SRC */
+#define WM831X_WDOG_SLPENA                      0x1000  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_MASK                 0x1000  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_SHIFT                    12  /* WDOG_SLPENA */
+#define WM831X_WDOG_SLPENA_WIDTH                     1  /* WDOG_SLPENA */
+#define WM831X_WDOG_RESET                       0x0800  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_MASK                  0x0800  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_SHIFT                     11  /* WDOG_RESET */
+#define WM831X_WDOG_RESET_WIDTH                      1  /* WDOG_RESET */
+#define WM831X_WDOG_SECACT_MASK                 0x0300  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_SECACT_SHIFT                     8  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_SECACT_WIDTH                     2  /* WDOG_SECACT - [9:8] */
+#define WM831X_WDOG_PRIMACT_MASK                0x0030  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_PRIMACT_SHIFT                    4  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_PRIMACT_WIDTH                    2  /* WDOG_PRIMACT - [5:4] */
+#define WM831X_WDOG_TO_MASK                     0x0007  /* WDOG_TO - [2:0] */
+#define WM831X_WDOG_TO_SHIFT                         0  /* WDOG_TO - [2:0] */
+#define WM831X_WDOG_TO_WIDTH                         3  /* WDOG_TO - [2:0] */
+
+#endif

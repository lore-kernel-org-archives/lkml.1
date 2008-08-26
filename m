Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYHZUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYHZUhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYHZUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:36:56 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:18224 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYHZUgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:36:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAJgFtEhR9cri/2dsb2JhbACBZbIEhxdkgQc
Date: Tue, 26 Aug 2008 22:36:48 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: v2.6.27-rc4 watchdog patches
Message-ID: <20080826203648.GC2763@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig          |   24 ++
 drivers/watchdog/Makefile         |    3 
 drivers/watchdog/at91rm9200_wdt.c |    2 
 drivers/watchdog/hpwdt.c          |   93 +++++-----
 drivers/watchdog/mpc8xx_wdt.c     |  170 ------------------
 drivers/watchdog/mpc8xxx_wdt.c    |   11 +
 drivers/watchdog/pc87413_wdt.c    |    1 
 drivers/watchdog/rc32434_wdt.c    |  344 ++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/rdc321x_wdt.c    |  285 +++++++++++++++++++++++++++++++
 drivers/watchdog/s3c2410_wdt.c    |   16 -
 10 files changed, 714 insertions(+), 235 deletions(-)

with these Changes:

Author: Huang Weiyi <weiyi.huang@gmail.com>
Date:   Sun Aug 17 07:51:12 2008 +0800

    [WATCHDOG] removed unused #include <version.h>
    
    The drivers below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
      drivers/watchdog/pc87413_wdt.c
    
    This patch removes the said #include <version.h>.
    
    Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Date:   Tue Aug 19 09:01:14 2008 +0300

    [WATCHDOG] at91rm9200_wdt.c: fix misleading indentation
    
    Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Wed Aug 20 16:38:36 2008 -0700

    [WATCHDOG] mpc8xxx_wdt: fix modular build
    
    Fix the following build error when mpc8xxx_wdt is selected to build as a
    module:
    
    drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of '__inittest'
    drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of '__inittest' was here
    drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of 'init_module'
    drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of 'init_module' was here
    
    Reported-by: Dave Jones <davej@redhat.com>
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Tue Jul 15 19:40:41 2008 +0000

    [WATCHDOG] hpwdt.c kdebug support
    
    add kdebug support for the hpwdt.c driver.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian.fainelli@telecomint.eu>
Date:   Mon Feb 25 13:11:31 2008 +0100

    [WATCHDOG] Add support for the IDT RC32434 watchdog
    
    Add driver for the IDT RC32434 SoC built-in watchdog.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian.fainelli@telecomint.eu>
Date:   Mon Feb 25 12:59:26 2008 +0100

    [WATCHDOG] Add support for the built-int RDC R-321x SoC watchdog
    
    This patch adds support for the built-in RDC R-321x SoC watchdog.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jochen Friedrich <jochen@scram.de>
Date:   Thu Jul 24 12:22:05 2008 +0200

    [WATHDOG] delete unused driver mpc8xx_wdt.c
    
    The watchdog driver mpc8xx_wdt.c was a device interface to
    arch/ppc/syslib/m8xx_wdt.c for MPC8xx hardware. Now that ARCH=ppc is
    gone, this driver is of no more use. For ARCH=powerpc, MPC8xx hardware
    is supported by mpc8xxx_wdt.c.
    
    Signed-off-by: Jochen Friedrich <jochen@scram.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Acked-by: Vitaly Bordug <vitb@kernel.crashing.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:51 2008 +0100

    [WATCHDOG] Fix s3c2410_wdt driver coding style issues
    
    Fixup coding style issues in the s3c2410_wdt driver.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:50 2008 +0100

    [WATCHDOG] Clean out header of s3c2410_wdt driver.
    
    Remove the changelog from the top of the driver, which
    is redundant as this information is more accurately
    represented from the revision control holding the
    file.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Sun Jun 22 22:36:49 2008 +0100

    [WATCHDOG] Fix NULL usage in s3c2410_wdt driver.
    
    Fix comparison of a pointer to 0, instead of using
    NULL for a invalid pointer.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index db20542..c510367 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -465,6 +465,16 @@ config PC87413_WDT
 
 	  Most people will say N.
 
+config RDC321X_WDT
+	tristate "RDC R-321x SoC watchdog"
+	depends on X86_RDC321X
+	help
+	  This is the driver for the built in hardware watchdog
+	  in the RDC R-321x SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rdc321x_wdt.
+
 config 60XX_WDT
 	tristate "SBC-60XX Watchdog Timer"
 	depends on X86
@@ -633,6 +643,16 @@ config SBC_EPX_C3_WATCHDOG
 
 # MIPS Architecture
 
+config RC32434_WDT
+	tristate "IDT RC32434 SoC Watchdog Timer"
+	depends on MIKROTIK_RB532
+	help
+	  Hardware driver for the IDT RC32434 SoC built-in
+	  watchdog timer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rc32434_wdt.
+
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
 	depends on SGI_HAS_INDYDOG
@@ -692,10 +712,6 @@ config MPC5200_WDT
 	tristate "MPC5200 Watchdog Timer"
 	depends on PPC_MPC52xx
 
-config 8xx_WDT
-	tristate "MPC8xx Watchdog Timer"
-	depends on 8xx
-
 config 8xxx_WDT
 	tristate "MPC8xxx Platform Watchdog Timer"
 	depends on PPC_8xx || PPC_83xx || PPC_86xx
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ca3dc04..e0ef123 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
+obj-$(CONFIG_RDC321X_WDT) += rdc321x_wdt.o
 obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
 obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
 obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
@@ -94,6 +95,7 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 # M68KNOMMU Architecture
 
 # MIPS Architecture
+obj-$(CONFIG_RC32434_WDT) += rc32434_wdt.o
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
@@ -104,7 +106,6 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 # PARISC Architecture
 
 # POWERPC Architecture
-obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index d061f0a..993e5f5 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -241,7 +241,7 @@ static int at91wdt_resume(struct platform_device *pdev)
 {
 	if (at91wdt_busy)
 		at91_wdt_start();
-		return 0;
+	return 0;
 }
 
 #else
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index d039d5f..a3765e0 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -116,6 +116,7 @@ static unsigned int reload;			/* the computed soft_margin */
 static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
+static unsigned int allow_kdump;
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
@@ -221,19 +222,19 @@ static int __devinit cru_detect(unsigned long map_entry,
 
 	if (cmn_regs.u1.ral != 0) {
 		printk(KERN_WARNING
-		       "hpwdt: Call succeeded but with an error: 0x%x\n",
-		       cmn_regs.u1.ral);
+			"hpwdt: Call succeeded but with an error: 0x%x\n",
+			cmn_regs.u1.ral);
 	} else {
 		physical_bios_base = cmn_regs.u2.rebx;
 		physical_bios_offset = cmn_regs.u4.redx;
 		cru_length = cmn_regs.u3.recx;
 		cru_physical_address =
-		    physical_bios_base + physical_bios_offset;
+			physical_bios_base + physical_bios_offset;
 
 		/* If the values look OK, then map it in. */
 		if ((physical_bios_base + physical_bios_offset)) {
 			cru_rom_addr =
-			    ioremap(cru_physical_address, cru_length);
+				ioremap(cru_physical_address, cru_length);
 			if (cru_rom_addr)
 				retval = 0;
 		}
@@ -356,7 +357,6 @@ asm(".text                      \n\t"
     "call       *%r12           \n\t"
     "pushfq                     \n\t"
     "popq        %r12           \n\t"
-    "popfq                      \n\t"
     "movl       %eax, (%r9)     \n\t"
     "movl       %ebx, 4(%r9)    \n\t"
     "movl       %ecx, 8(%r9)    \n\t"
@@ -390,10 +390,10 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm)
 		smbios_cru64_ptr = (struct smbios_cru64_info *) dm;
 		if (smbios_cru64_ptr->signature == CRU_BIOS_SIGNATURE_VALUE) {
 			cru_physical_address =
-			    smbios_cru64_ptr->physical_address +
-			    smbios_cru64_ptr->double_offset;
+				smbios_cru64_ptr->physical_address +
+				smbios_cru64_ptr->double_offset;
 			cru_rom_addr = ioremap(cru_physical_address,
-				    smbios_cru64_ptr->double_length);
+				smbios_cru64_ptr->double_length);
 		}
 	}
 }
@@ -405,7 +405,7 @@ static int __devinit detect_cru_service(void)
 	dmi_walk(dmi_find_cru);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
-	return ((cru_rom_addr != NULL) ? 0: -ENODEV);
+	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
 }
 
 /* ------------------------------------------------------------------------- */
@@ -413,34 +413,6 @@ static int __devinit detect_cru_service(void)
 #endif
 
 /*
- *	NMI Handler
- */
-static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
-			    void *data)
-{
-	unsigned long rom_pl;
-	static int die_nmi_called;
-
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	spin_lock_irqsave(&rom_lock, rom_pl);
-	if (!die_nmi_called)
-		asminline_call(&cmn_regs, cru_rom_addr);
-	die_nmi_called = 1;
-	spin_unlock_irqrestore(&rom_lock, rom_pl);
-	if (cmn_regs.u1.ral == 0) {
-		printk(KERN_WARNING "hpwdt: An NMI occurred, "
-		       "but unable to determine source.\n");
-	} else {
-		panic("An NMI occurred, please see the Integrated "
-			"Management Log for details.\n");
-	}
-
-	return NOTIFY_STOP;
-}
-
-/*
  *	Watchdog operations
  */
 static void hpwdt_start(void)
@@ -484,6 +456,36 @@ static int hpwdt_change_timer(int new_margin)
 }
 
 /*
+ *	NMI Handler
+ */
+static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
+				void *data)
+{
+	unsigned long rom_pl;
+	static int die_nmi_called;
+
+	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (!die_nmi_called)
+		asminline_call(&cmn_regs, cru_rom_addr);
+	die_nmi_called = 1;
+	spin_unlock_irqrestore(&rom_lock, rom_pl);
+	if (cmn_regs.u1.ral == 0) {
+		printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			"but unable to determine source.\n");
+	} else {
+		if (allow_kdump)
+			hpwdt_stop();
+		panic("An NMI occurred, please see the Integrated "
+			"Management Log for details.\n");
+	}
+
+	return NOTIFY_STOP;
+}
+
+/*
  *	/dev/watchdog handling
  */
 static int hpwdt_open(struct inode *inode, struct file *file)
@@ -625,17 +627,18 @@ static struct notifier_block die_notifier = {
  */
 
 static int __devinit hpwdt_init_one(struct pci_dev *dev,
-				    const struct pci_device_id *ent)
+					const struct pci_device_id *ent)
 {
 	int retval;
 
 	/*
 	 * First let's find out if we are on an iLO2 server. We will
 	 * not run on a legacy ASM box.
+	 * So we only support the G5 ProLiant servers and higher.
 	 */
 	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
 		dev_warn(&dev->dev,
-		       "This server does not have an iLO2 ASIC.\n");
+			"This server does not have an iLO2 ASIC.\n");
 		return -ENODEV;
 	}
 
@@ -669,7 +672,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	retval = detect_cru_service();
 	if (retval < 0) {
 		dev_warn(&dev->dev,
-		       "Unable to detect the %d Bit CRU Service.\n",
+			"Unable to detect the %d Bit CRU Service.\n",
 			HPWDT_ARCH);
 		goto error_get_cru;
 	}
@@ -684,7 +687,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 	retval = register_die_notifier(&die_notifier);
 	if (retval != 0) {
 		dev_warn(&dev->dev,
-		       "Unable to register a die notifier (err=%d).\n",
+			"Unable to register a die notifier (err=%d).\n",
 			retval);
 		goto error_die_notifier;
 	}
@@ -699,8 +702,9 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 
 	printk(KERN_INFO
 		"hp Watchdog Timer Driver: 1.00"
-		", timer margin: %d seconds( nowayout=%d).\n",
-		soft_margin, nowayout);
+		", timer margin: %d seconds (nowayout=%d)"
+		", allow kernel dump: %s (default = 0/OFF).\n",
+		soft_margin, nowayout, (allow_kdump == 0) ? "OFF" : "ON");
 
 	return 0;
 
@@ -755,6 +759,9 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
+module_param(allow_kdump, int, 0);
+MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
+
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
diff --git a/drivers/watchdog/mpc8xx_wdt.c b/drivers/watchdog/mpc8xx_wdt.c
deleted file mode 100644
index 1336425..0000000
--- a/drivers/watchdog/mpc8xx_wdt.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * mpc8xx_wdt.c - MPC8xx watchdog userspace interface
- *
- * Author: Florian Schirmer <jolt@tuxbox.org>
- *
- * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/watchdog.h>
-#include <asm/8xx_immap.h>
-#include <linux/uaccess.h>
-#include <linux/io.h>
-#include <syslib/m8xx_wdt.h>
-
-static unsigned long wdt_opened;
-static int wdt_status;
-static spinlock_t wdt_lock;
-
-static void mpc8xx_wdt_handler_disable(void)
-{
-	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
-
-	if (!m8xx_has_internal_rtc)
-		m8xx_wdt_stop_timer();
-	else
-		out_be32(piscr, in_be32(piscr) & ~(PISCR_PIE | PISCR_PTE));
-	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler deactivated\n");
-}
-
-static void mpc8xx_wdt_handler_enable(void)
-{
-	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
-
-	if (!m8xx_has_internal_rtc)
-		m8xx_wdt_install_timer();
-	else
-		out_be32(piscr, in_be32(piscr) | PISCR_PIE | PISCR_PTE);
-	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler activated\n");
-}
-
-static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &wdt_opened))
-		return -EBUSY;
-	m8xx_wdt_reset();
-	mpc8xx_wdt_handler_disable();
-	return nonseekable_open(inode, file);
-}
-
-static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
-{
-	m8xx_wdt_reset();
-#if !defined(CONFIG_WATCHDOG_NOWAYOUT)
-	mpc8xx_wdt_handler_enable();
-#endif
-	clear_bit(0, &wdt_opened);
-	return 0;
-}
-
-static ssize_t mpc8xx_wdt_write(struct file *file, const char *data,
-						size_t len, loff_t *ppos)
-{
-	if (len) {
-		spin_lock(&wdt_lock);
-		m8xx_wdt_reset();
-		spin_unlock(&wdt_lock);
-	}
-	return len;
-}
-
-static long mpc8xx_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int timeout;
-	static struct watchdog_info info = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 0,
-		.identity = "MPC8xx watchdog",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user((void *)arg, &info, sizeof(info)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		if (put_user(wdt_status, (int *)arg))
-			return -EFAULT;
-		wdt_status &= ~WDIOF_KEEPALIVEPING;
-		break;
-
-	case WDIOC_GETTEMP:
-		return -EOPNOTSUPP;
-
-	case WDIOC_SETOPTIONS:
-		return -EOPNOTSUPP;
-
-	case WDIOC_KEEPALIVE:
-		spin_lock(&wdt_lock);
-		m8xx_wdt_reset();
-		wdt_status |= WDIOF_KEEPALIVEPING;
-		spin_unlock(&wdt_lock);
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		return -EOPNOTSUPP;
-
-	case WDIOC_GETTIMEOUT:
-		spin_lock(&wdt_lock);
-		timeout = m8xx_wdt_get_timeout();
-		spin_unlock(&wdt_lock);
-		if (put_user(timeout, (int *)arg))
-			return -EFAULT;
-		break;
-
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-static const struct file_operations mpc8xx_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = mpc8xx_wdt_write,
-	.unlocked_ioctl = mpc8xx_wdt_ioctl,
-	.open = mpc8xx_wdt_open,
-	.release = mpc8xx_wdt_release,
-};
-
-static struct miscdevice mpc8xx_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &mpc8xx_wdt_fops,
-};
-
-static int __init mpc8xx_wdt_init(void)
-{
-	spin_lock_init(&wdt_lock);
-	return misc_register(&mpc8xx_wdt_miscdev);
-}
-
-static void __exit mpc8xx_wdt_exit(void)
-{
-	misc_deregister(&mpc8xx_wdt_miscdev);
-
-	m8xx_wdt_reset();
-	mpc8xx_wdt_handler_enable();
-}
-
-module_init(mpc8xx_wdt_init);
-module_exit(mpc8xx_wdt_exit);
-
-MODULE_AUTHOR("Florian Schirmer <jolt@tuxbox.org>");
-MODULE_DESCRIPTION("MPC8xx watchdog driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index f209496..38c588e 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -48,6 +48,7 @@ struct mpc8xxx_wdt_type {
 };
 
 static struct mpc8xxx_wdt __iomem *wd_base;
+static int mpc8xxx_wdt_init_late(void);
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
@@ -213,6 +214,12 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
 	else
 		timeout_sec = timeout / freq;
 
+#ifdef MODULE
+	ret = mpc8xxx_wdt_init_late();
+	if (ret)
+		goto err_unmap;
+#endif
+
 	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
 		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
 		timeout_sec);
@@ -280,7 +287,7 @@ static struct of_platform_driver mpc8xxx_wdt_driver = {
  * very early to start pinging the watchdog (misc devices are not yet
  * available), and later module_init() just registers the misc device.
  */
-static int __init mpc8xxx_wdt_init_late(void)
+static int mpc8xxx_wdt_init_late(void)
 {
 	int ret;
 
@@ -295,7 +302,9 @@ static int __init mpc8xxx_wdt_init_late(void)
 	}
 	return 0;
 }
+#ifndef MODULE
 module_init(mpc8xxx_wdt_init_late);
+#endif
 
 static int __init mpc8xxx_wdt_init(void)
 {
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index e91ada7..484c215 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
new file mode 100644
index 0000000..6756bcb
--- /dev/null
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -0,0 +1,344 @@
+/*
+ *  IDT Interprise 79RC32434 watchdog driver
+ *
+ *  Copyright (C) 2006, Ondrej Zajicek <santiago@crfreenet.org>
+ *  Copyright (C) 2008, Florian Fainelli <florian@openwrt.org>
+ *
+ *  based on
+ *  SoftDog 0.05:	A Software Watchdog Device
+ *
+ *  (c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/reboot.h>
+#include <linux/smp_lock.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+
+#include <asm/bootinfo.h>
+#include <asm/time.h>
+#include <asm/mach-rc32434/integ.h>
+
+#define MAX_TIMEOUT			20
+#define RC32434_WDT_INTERVAL		(15 * HZ)
+
+#define VERSION "0.2"
+
+static struct {
+	struct completion stop;
+	int running;
+	struct timer_list timer;
+	int queue;
+	int default_ticks;
+	unsigned long inuse;
+} rc32434_wdt_device;
+
+static struct integ __iomem *wdt_reg;
+static int ticks = 100 * HZ;
+
+static int expect_close;
+static int timeout;
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+
+static void rc32434_wdt_start(void)
+{
+	u32 val;
+
+	if (!rc32434_wdt_device.inuse) {
+		writel(0, &wdt_reg->wtcount);
+
+		val = RC32434_ERR_WRE;
+		writel(readl(&wdt_reg->errcs) | val, &wdt_reg->errcs);
+
+		val = RC32434_WTC_EN;
+		writel(readl(&wdt_reg->wtc) | val, &wdt_reg->wtc);
+	}
+	rc32434_wdt_device.running++;
+}
+
+static void rc32434_wdt_stop(void)
+{
+	u32 val;
+
+	if (rc32434_wdt_device.running) {
+
+		val = ~RC32434_WTC_EN;
+		writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
+
+		val = ~RC32434_ERR_WRE;
+		writel(readl(&wdt_reg->errcs) & val, &wdt_reg->errcs);
+
+		rc32434_wdt_device.running = 0;
+	}
+}
+
+static void rc32434_wdt_set(int new_timeout)
+{
+	u32 cmp = new_timeout * HZ;
+	u32 state, val;
+
+	timeout = new_timeout;
+	/*
+	 * store and disable WTC
+	 */
+	state = (u32)(readl(&wdt_reg->wtc) & RC32434_WTC_EN);
+	val = ~RC32434_WTC_EN;
+	writel(readl(&wdt_reg->wtc) & val, &wdt_reg->wtc);
+
+	writel(0, &wdt_reg->wtcount);
+	writel(cmp, &wdt_reg->wtcompare);
+
+	/*
+	 * restore WTC
+	 */
+
+	writel(readl(&wdt_reg->wtc) | state, &wdt_reg);
+}
+
+static void rc32434_wdt_reset(void)
+{
+	ticks = rc32434_wdt_device.default_ticks;
+}
+
+static void rc32434_wdt_update(unsigned long unused)
+{
+	if (rc32434_wdt_device.running)
+		ticks--;
+
+	writel(0, &wdt_reg->wtcount);
+
+	if (rc32434_wdt_device.queue && ticks)
+		mod_timer(&rc32434_wdt_device.timer,
+			jiffies + RC32434_WDT_INTERVAL);
+	else
+		complete(&rc32434_wdt_device.stop);
+}
+
+static int rc32434_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &rc32434_wdt_device.inuse))
+		return -EBUSY;
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	return nonseekable_open(inode, file);
+}
+
+static int rc32434_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close && nowayout == 0) {
+		rc32434_wdt_stop();
+		printk(KERN_INFO KBUILD_MODNAME ": disabling watchdog timer\n");
+		module_put(THIS_MODULE);
+	} else
+		printk(KERN_CRIT KBUILD_MODNAME
+			": device closed unexpectedly. WDT will not stop !\n");
+
+	clear_bit(0, &rc32434_wdt_device.inuse);
+	return 0;
+}
+
+static ssize_t rc32434_wdt_write(struct file *file, const char *data,
+				size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 1;
+			}
+		}
+		rc32434_wdt_update(0);
+		return len;
+	}
+	return 0;
+}
+
+static int rc32434_wdt_ioctl(struct inode *inode, struct file *file,
+	unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int new_timeout;
+	unsigned int value;
+	static struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.identity =		"RC32434_WDT Watchdog",
+	};
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		rc32434_wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		value = readl(&wdt_reg->wtcount);
+		if (copy_to_user(argp, &value, sizeof(int)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (copy_from_user(&value, argp, sizeof(int)))
+			return -EFAULT;
+		switch (value) {
+		case WDIOS_ENABLECARD:
+			rc32434_wdt_start();
+			break;
+		case WDIOS_DISABLECARD:
+			rc32434_wdt_stop();
+		default:
+			return -EINVAL;
+		}
+		break;
+	case WDIOC_SETTIMEOUT:
+		if (copy_from_user(&new_timeout, argp, sizeof(int)))
+			return -EFAULT;
+		if (new_timeout < 1)
+			return -EINVAL;
+		if (new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		rc32434_wdt_set(new_timeout);
+	case WDIOC_GETTIMEOUT:
+		return copy_to_user(argp, &timeout, sizeof(int));
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static struct file_operations rc32434_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= rc32434_wdt_write,
+	.ioctl		= rc32434_wdt_ioctl,
+	.open		= rc32434_wdt_open,
+	.release	= rc32434_wdt_release,
+};
+
+static struct miscdevice rc32434_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &rc32434_wdt_fops,
+};
+
+static char banner[] = KERN_INFO KBUILD_MODNAME
+		": Watchdog Timer version " VERSION ", timer margin: %d sec\n";
+
+static int rc32434_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb500_wdt_res");
+	if (!r) {
+		printk(KERN_ERR KBUILD_MODNAME
+			"failed to retrieve resources\n");
+		return -ENODEV;
+	}
+
+	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
+	if (!wdt_reg) {
+		printk(KERN_ERR KBUILD_MODNAME
+			"failed to remap I/O resources\n");
+		return -ENXIO;
+	}
+
+	ret = misc_register(&rc32434_wdt_miscdev);
+
+	if (ret < 0) {
+		printk(KERN_ERR KBUILD_MODNAME
+			"failed to register watchdog device\n");
+		goto unmap;
+	}
+
+	init_completion(&rc32434_wdt_device.stop);
+	rc32434_wdt_device.queue = 0;
+
+	clear_bit(0, &rc32434_wdt_device.inuse);
+
+	setup_timer(&rc32434_wdt_device.timer, rc32434_wdt_update, 0L);
+
+	rc32434_wdt_device.default_ticks = ticks;
+
+	rc32434_wdt_start();
+
+	printk(banner, timeout);
+
+	return 0;
+
+unmap:
+	iounmap(wdt_reg);
+	return ret;
+}
+
+static int rc32434_wdt_remove(struct platform_device *pdev)
+{
+	if (rc32434_wdt_device.queue) {
+		rc32434_wdt_device.queue = 0;
+		wait_for_completion(&rc32434_wdt_device.stop);
+	}
+	misc_deregister(&rc32434_wdt_miscdev);
+
+	iounmap(wdt_reg);
+
+	return 0;
+}
+
+static struct platform_driver rc32434_wdt = {
+	.probe	= rc32434_wdt_probe,
+	.remove = rc32434_wdt_remove,
+	.driver = {
+		.name = "rc32434_wdt",
+	}
+};
+
+static int __init rc32434_wdt_init(void)
+{
+	return platform_driver_register(&rc32434_wdt);
+}
+
+static void __exit rc32434_wdt_exit(void)
+{
+	platform_driver_unregister(&rc32434_wdt);
+}
+
+module_init(rc32434_wdt_init);
+module_exit(rc32434_wdt_exit);
+
+MODULE_AUTHOR("Ondrej Zajicek <santiago@crfreenet.org>,"
+		"Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION("Driver for the IDT RC32434 SoC watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
new file mode 100644
index 0000000..9108efa
--- /dev/null
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -0,0 +1,285 @@
+/*
+ * RDC321x watchdog driver
+ *
+ * Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
+ *
+ * This driver is highly inspired from the cpu5_wdt driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/timer.h>
+#include <linux/completion.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/mach-rdc321x/rdc321x_defs.h>
+
+#define RDC_WDT_MASK	0x80000000 /* Mask */
+#define RDC_WDT_EN	0x00800000 /* Enable bit */
+#define RDC_WDT_WTI	0x00200000 /* Generate CPU reset/NMI/WDT on timeout */
+#define RDC_WDT_RST	0x00100000 /* Reset bit */
+#define RDC_WDT_WIF	0x00040000 /* WDT IRQ Flag */
+#define RDC_WDT_IRT	0x00000100 /* IRQ Routing table */
+#define RDC_WDT_CNT	0x00000001 /* WDT count */
+
+#define RDC_CLS_TMR	0x80003844 /* Clear timer */
+
+#define RDC_WDT_INTERVAL	(HZ/10+1)
+
+static int ticks = 1000;
+
+/* some device data */
+
+static struct {
+	struct completion stop;
+	int running;
+	struct timer_list timer;
+	int queue;
+	int default_ticks;
+	unsigned long inuse;
+	spinlock_t lock;
+} rdc321x_wdt_device;
+
+/* generic helper functions */
+
+static void rdc321x_wdt_trigger(unsigned long unused)
+{
+	unsigned long flags;
+
+	if (rdc321x_wdt_device.running)
+		ticks--;
+
+	/* keep watchdog alive */
+	spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
+	outl(RDC_WDT_EN | inl(RDC3210_CFGREG_DATA),
+		RDC3210_CFGREG_DATA);
+	spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
+
+	/* requeue?? */
+	if (rdc321x_wdt_device.queue && ticks)
+		mod_timer(&rdc321x_wdt_device.timer,
+				jiffies + RDC_WDT_INTERVAL);
+	else {
+		/* ticks doesn't matter anyway */
+		complete(&rdc321x_wdt_device.stop);
+	}
+
+}
+
+static void rdc321x_wdt_reset(void)
+{
+	ticks = rdc321x_wdt_device.default_ticks;
+}
+
+static void rdc321x_wdt_start(void)
+{
+	unsigned long flags;
+
+	if (!rdc321x_wdt_device.queue) {
+		rdc321x_wdt_device.queue = 1;
+
+		/* Clear the timer */
+		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
+		outl(RDC_CLS_TMR, RDC3210_CFGREG_ADDR);
+
+		/* Enable watchdog and set the timeout to 81.92 us */
+		outl(RDC_WDT_EN | RDC_WDT_CNT, RDC3210_CFGREG_DATA);
+		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
+
+		mod_timer(&rdc321x_wdt_device.timer,
+				jiffies + RDC_WDT_INTERVAL);
+	}
+
+	/* if process dies, counter is not decremented */
+	rdc321x_wdt_device.running++;
+}
+
+static int rdc321x_wdt_stop(void)
+{
+	if (rdc321x_wdt_device.running)
+		rdc321x_wdt_device.running = 0;
+
+	ticks = rdc321x_wdt_device.default_ticks;
+
+	return -EIO;
+}
+
+/* filesystem operations */
+static int rdc321x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &rdc321x_wdt_device.inuse))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+static int rdc321x_wdt_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &rdc321x_wdt_device.inuse);
+	return 0;
+}
+
+static int rdc321x_wdt_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	unsigned int value;
+	static struct watchdog_info ident = {
+		.options = WDIOF_CARDRESET,
+		.identity = "RDC321x WDT",
+	};
+	unsigned long flags;
+
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		rdc321x_wdt_reset();
+		break;
+	case WDIOC_GETSTATUS:
+		/* Read the value from the DATA register */
+		spin_lock_irqsave(&rdc321x_wdt_device.lock, flags);
+		value = inl(RDC3210_CFGREG_DATA);
+		spin_unlock_irqrestore(&rdc321x_wdt_device.lock, flags);
+		if (copy_to_user(argp, &value, sizeof(int)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_SETOPTIONS:
+		if (copy_from_user(&value, argp, sizeof(int)))
+			return -EFAULT;
+		switch (value) {
+		case WDIOS_ENABLECARD:
+			rdc321x_wdt_start();
+			break;
+		case WDIOS_DISABLECARD:
+			return rdc321x_wdt_stop();
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
+
+static ssize_t rdc321x_wdt_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	if (!count)
+		return -EIO;
+
+	rdc321x_wdt_reset();
+
+	return count;
+}
+
+static const struct file_operations rdc321x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= rdc321x_wdt_ioctl,
+	.open		= rdc321x_wdt_open,
+	.write		= rdc321x_wdt_write,
+	.release	= rdc321x_wdt_release,
+};
+
+static struct miscdevice rdc321x_wdt_misc = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &rdc321x_wdt_fops,
+};
+
+static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
+{
+	int err;
+
+	err = misc_register(&rdc321x_wdt_misc);
+	if (err < 0) {
+		printk(KERN_ERR PFX "watchdog misc_register failed\n");
+		return err;
+	}
+
+	spin_lock_init(&rdc321x_wdt_device.lock);
+
+	/* Reset the watchdog */
+	outl(RDC_WDT_RST, RDC3210_CFGREG_DATA);
+
+	init_completion(&rdc321x_wdt_device.stop);
+	rdc321x_wdt_device.queue = 0;
+
+	clear_bit(0, &rdc321x_wdt_device.inuse);
+
+	setup_timer(&rdc321x_wdt_device.timer, rdc321x_wdt_trigger, 0);
+
+	rdc321x_wdt_device.default_ticks = ticks;
+
+	printk(KERN_INFO PFX "watchdog init success\n");
+
+	return 0;
+}
+
+static int rdc321x_wdt_remove(struct platform_device *pdev)
+{
+	if (rdc321x_wdt_device.queue) {
+		rdc321x_wdt_device.queue = 0;
+		wait_for_completion(&rdc321x_wdt_device.stop);
+	}
+
+	misc_deregister(&rdc321x_wdt_misc);
+
+	return 0;
+}
+
+static struct platform_driver rdc321x_wdt_driver = {
+	.probe = rdc321x_wdt_probe,
+	.remove = rdc321x_wdt_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "rdc321x-wdt",
+	},
+};
+
+static int __init rdc321x_wdt_init(void)
+{
+	return platform_driver_register(&rdc321x_wdt_driver);
+}
+
+static void __exit rdc321x_wdt_exit(void)
+{
+	platform_driver_unregister(&rdc321x_wdt_driver);
+}
+
+module_init(rdc321x_wdt_init);
+module_exit(rdc321x_wdt_exit);
+
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION("RDC321x watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 22715e3..86d4280 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -21,18 +21,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Changelog:
- *	05-Oct-2004	BJD	Added semaphore init to stop crashes on open
- *				Fixed tmr_count / wdt_count confusion
- *				Added configurable debug
- *
- *	11-Jan-2005	BJD	Fixed divide-by-2 in timeout code
- *
- *	25-Jan-2005	DA	Added suspend/resume support
- *				Replaced reboot notifier with .shutdown method
- *
- *	10-Mar-2005	LCVR	Changed S3C2410_VA to S3C24XX_VA
 */
 
 #include <linux/module.h>
@@ -365,7 +353,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = (res->end-res->start)+1;
+	size = (res->end - res->start) + 1;
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n");
@@ -374,7 +362,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	wdt_base = ioremap(res->start, size);
-	if (wdt_base == 0) {
+	if (wdt_base == NULL) {
 		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
 		goto err_req;

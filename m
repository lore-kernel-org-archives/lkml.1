Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYAYIV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYAYIV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbYAYIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:53688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763713AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 176/196] Driver core: change sysdev classes to use dynamic kobject names
Date: Thu, 24 Jan 2008 23:33:25 -0800
Message-Id: <1201246425-5058-97-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

All kobjects require a dynamically allocated name now. We no longer
need to keep track if the name is statically assigned, we can just
unconditionally free() all kobject names on cleanup.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/kernel/time.c                   |    4 ++--
 arch/arm/mach-integrator/integrator_ap.c |    2 +-
 arch/arm/mach-pxa/cm-x270.c              |    2 +-
 arch/arm/mach-pxa/lpd270.c               |    2 +-
 arch/arm/mach-pxa/lubbock.c              |    2 +-
 arch/arm/mach-pxa/mainstone.c            |    2 +-
 arch/arm/mach-s3c2410/s3c2410.c          |    2 +-
 arch/arm/mach-s3c2412/s3c2412.c          |    2 +-
 arch/arm/mach-s3c2440/mach-osiris.c      |    2 +-
 arch/arm/mach-s3c2443/s3c2443.c          |    2 +-
 arch/arm/mach-sa1100/irq.c               |    2 +-
 arch/arm/oprofile/common.c               |    2 +-
 arch/arm/plat-omap/gpio.c                |    2 +-
 arch/arm/plat-s3c24xx/dma.c              |    2 +-
 arch/arm/plat-s3c24xx/s3c244x.c          |    4 ++--
 arch/avr32/kernel/time.c                 |    2 +-
 arch/mips/kernel/i8259.c                 |    2 +-
 arch/powerpc/platforms/cell/spu_base.c   |    2 +-
 arch/powerpc/platforms/powermac/pic.c    |    2 +-
 arch/powerpc/sysdev/ipic.c               |    2 +-
 arch/powerpc/sysdev/mpic.c               |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c       |    2 +-
 arch/ppc/syslib/ipic.c                   |    2 +-
 arch/ppc/syslib/open_pic.c               |    2 +-
 arch/ppc/syslib/open_pic2.c              |    2 +-
 arch/s390/kernel/time.c                  |    2 +-
 arch/sh/drivers/dma/dma-sysfs.c          |    2 +-
 arch/sh/kernel/time.c                    |    2 +-
 arch/x86/kernel/apic_32.c                |    2 +-
 arch/x86/kernel/apic_64.c                |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c      |    2 +-
 arch/x86/kernel/i8237.c                  |    2 +-
 arch/x86/kernel/i8259_32.c               |    2 +-
 arch/x86/kernel/i8259_64.c               |    2 +-
 arch/x86/kernel/io_apic_32.c             |    2 +-
 arch/x86/kernel/io_apic_64.c             |    2 +-
 arch/x86/kernel/nmi_32.c                 |    2 +-
 arch/x86/kernel/nmi_64.c                 |    2 +-
 arch/x86/oprofile/nmi_int.c              |    2 +-
 drivers/acpi/pci_link.c                  |    2 +-
 drivers/base/class.c                     |    2 +-
 drivers/base/cpu.c                       |    2 +-
 drivers/base/memory.c                    |    2 +-
 drivers/base/node.c                      |    2 +-
 drivers/base/sys.c                       |    1 +
 drivers/edac/edac_module.c               |    2 +-
 drivers/kvm/kvm_main.c                   |    2 +-
 drivers/macintosh/via-pmu.c              |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c      |    2 +-
 include/linux/kobject.h                  |   13 ++-----------
 include/linux/sysdev.h                   |    1 +
 kernel/rtmutex-tester.c                  |    2 +-
 kernel/time/clocksource.c                |    2 +-
 kernel/time/timekeeping.c                |    2 +-
 lib/kobject.c                            |   14 +++++---------
 55 files changed, 62 insertions(+), 73 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 1533d3e..f6f3689 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -195,7 +195,7 @@ static int leds_shutdown(struct sys_device *dev)
 }
 
 static struct sysdev_class leds_sysclass = {
-	set_kset_name("leds"),
+	.name		= "leds",
 	.shutdown	= leds_shutdown,
 	.suspend	= leds_suspend,
 	.resume		= leds_resume,
@@ -369,7 +369,7 @@ static int timer_resume(struct sys_device *dev)
 #endif
 
 static struct sysdev_class timer_sysclass = {
-	set_kset_name("timer"),
+	.name		= "timer",
 	.suspend	= timer_suspend,
 	.resume		= timer_resume,
 };
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 7228075..df37e93 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -214,7 +214,7 @@ static int irq_resume(struct sys_device *dev)
 #endif
 
 static struct sysdev_class irq_class = {
-	set_kset_name("irq"),
+	.name		= "irq",
 	.suspend	= irq_suspend,
 	.resume		= irq_resume,
 };
diff --git a/arch/arm/mach-pxa/cm-x270.c b/arch/arm/mach-pxa/cm-x270.c
index 177664c..a163492 100644
--- a/arch/arm/mach-pxa/cm-x270.c
+++ b/arch/arm/mach-pxa/cm-x270.c
@@ -566,7 +566,7 @@ static int cmx270_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class cmx270_pm_sysclass = {
-	set_kset_name("pm"),
+	.name = "pm",
 	.resume = cmx270_resume,
 	.suspend = cmx270_suspend,
 };
diff --git a/arch/arm/mach-pxa/lpd270.c b/arch/arm/mach-pxa/lpd270.c
index 2611644..78ebad0 100644
--- a/arch/arm/mach-pxa/lpd270.c
+++ b/arch/arm/mach-pxa/lpd270.c
@@ -122,7 +122,7 @@ static int lpd270_irq_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class lpd270_irq_sysclass = {
-	set_kset_name("cpld_irq"),
+	.name = "cpld_irq",
 	.resume = lpd270_irq_resume,
 };
 
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index 011a1a7..1d3112d 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -126,7 +126,7 @@ static int lubbock_irq_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class lubbock_irq_sysclass = {
-	set_kset_name("cpld_irq"),
+	.name = "cpld_irq",
 	.resume = lubbock_irq_resume,
 };
 
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index a4bc348..41d8c6c 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -120,7 +120,7 @@ static int mainstone_irq_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class mainstone_irq_sysclass = {
-	set_kset_name("cpld_irq"),
+	.name = "cpld_irq",
 	.resume = mainstone_irq_resume,
 };
 
diff --git a/arch/arm/mach-s3c2410/s3c2410.c b/arch/arm/mach-s3c2410/s3c2410.c
index e580303..0e79919 100644
--- a/arch/arm/mach-s3c2410/s3c2410.c
+++ b/arch/arm/mach-s3c2410/s3c2410.c
@@ -100,7 +100,7 @@ void __init s3c2410_init_clocks(int xtal)
 }
 
 struct sysdev_class s3c2410_sysclass = {
-	set_kset_name("s3c2410-core"),
+	.name = "s3c2410-core",
 };
 
 static struct sys_device s3c2410_sysdev = {
diff --git a/arch/arm/mach-s3c2412/s3c2412.c b/arch/arm/mach-s3c2412/s3c2412.c
index 4f92a15..265cd3f 100644
--- a/arch/arm/mach-s3c2412/s3c2412.c
+++ b/arch/arm/mach-s3c2412/s3c2412.c
@@ -196,7 +196,7 @@ void __init s3c2412_init_clocks(int xtal)
 */
 
 struct sysdev_class s3c2412_sysclass = {
-	set_kset_name("s3c2412-core"),
+	.name = "s3c2412-core",
 };
 
 static int __init s3c2412_core_init(void)
diff --git a/arch/arm/mach-s3c2440/mach-osiris.c b/arch/arm/mach-s3c2440/mach-osiris.c
index c326983..78af766 100644
--- a/arch/arm/mach-s3c2440/mach-osiris.c
+++ b/arch/arm/mach-s3c2440/mach-osiris.c
@@ -312,7 +312,7 @@ static int osiris_pm_resume(struct sys_device *sd)
 #endif
 
 static struct sysdev_class osiris_pm_sysclass = {
-	set_kset_name("mach-osiris"),
+	.name		= "mach-osiris",
 	.suspend	= osiris_pm_suspend,
 	.resume		= osiris_pm_resume,
 };
diff --git a/arch/arm/mach-s3c2443/s3c2443.c b/arch/arm/mach-s3c2443/s3c2443.c
index 8d81171..9ce4905 100644
--- a/arch/arm/mach-s3c2443/s3c2443.c
+++ b/arch/arm/mach-s3c2443/s3c2443.c
@@ -43,7 +43,7 @@ static struct map_desc s3c2443_iodesc[] __initdata = {
 };
 
 struct sysdev_class s3c2443_sysclass = {
-	set_kset_name("s3c2443-core"),
+	.name = "s3c2443-core",
 };
 
 static struct sys_device s3c2443_sysdev = {
diff --git a/arch/arm/mach-sa1100/irq.c b/arch/arm/mach-sa1100/irq.c
index edf3347..3dc17d7 100644
--- a/arch/arm/mach-sa1100/irq.c
+++ b/arch/arm/mach-sa1100/irq.c
@@ -283,7 +283,7 @@ static int sa1100irq_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class sa1100irq_sysclass = {
-	set_kset_name("sa11x0-irq"),
+	.name		= "sa11x0-irq",
 	.suspend	= sa1100irq_suspend,
 	.resume		= sa1100irq_resume,
 };
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index a9de727..0a5cf3a 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -96,7 +96,7 @@ static int op_arm_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class oprofile_sysclass = {
-	set_kset_name("oprofile"),
+	.name		= "oprofile",
 	.resume		= op_arm_resume,
 	.suspend	= op_arm_suspend,
 };
diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 6097753..b2a87b8 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1455,7 +1455,7 @@ static int omap_gpio_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class omap_gpio_sysclass = {
-	set_kset_name("gpio"),
+	.name		= "gpio",
 	.suspend	= omap_gpio_suspend,
 	.resume		= omap_gpio_resume,
 };
diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 29696e4..aae1b9c 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -1265,7 +1265,7 @@ static int s3c2410_dma_resume(struct sys_device *dev)
 #endif /* CONFIG_PM */
 
 struct sysdev_class dma_sysclass = {
-	set_kset_name("s3c24xx-dma"),
+	.name		= "s3c24xx-dma",
 	.suspend	= s3c2410_dma_suspend,
 	.resume		= s3c2410_dma_resume,
 };
diff --git a/arch/arm/plat-s3c24xx/s3c244x.c b/arch/arm/plat-s3c24xx/s3c244x.c
index 3444b13..f197bb3 100644
--- a/arch/arm/plat-s3c24xx/s3c244x.c
+++ b/arch/arm/plat-s3c24xx/s3c244x.c
@@ -151,13 +151,13 @@ static int s3c244x_resume(struct sys_device *dev)
 /* Since the S3C2442 and S3C2440 share  items, put both sysclasses here */
 
 struct sysdev_class s3c2440_sysclass = {
-	set_kset_name("s3c2440-core"),
+	.name		= "s3c2440-core",
 	.suspend	= s3c244x_suspend,
 	.resume		= s3c244x_resume
 };
 
 struct sysdev_class s3c2442_sysclass = {
-	set_kset_name("s3c2442-core"),
+	.name		= "s3c2442-core",
 	.suspend	= s3c244x_suspend,
 	.resume		= s3c244x_resume
 };
diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 7014a35..36a46c3 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -214,7 +214,7 @@ void __init time_init(void)
 }
 
 static struct sysdev_class timer_class = {
-	set_kset_name("timer"),
+	.name = "timer",
 };
 
 static struct sys_device timer_device = {
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 4710135..197d797 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -238,7 +238,7 @@ static int i8259A_shutdown(struct sys_device *dev)
 }
 
 static struct sysdev_class i8259_sysdev_class = {
-	set_kset_name("i8259"),
+	.name = "i8259",
 	.resume = i8259A_resume,
 	.shutdown = i8259A_shutdown,
 };
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index c83c3e3..a088622 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -459,7 +459,7 @@ static int spu_shutdown(struct sys_device *sysdev)
 }
 
 static struct sysdev_class spu_sysdev_class = {
-	set_kset_name("spu"),
+	.name = "spu",
 	.shutdown = spu_shutdown,
 };
 
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 999f5e1..84c0d4e 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -663,7 +663,7 @@ static int pmacpic_resume(struct sys_device *sysdev)
 #endif /* CONFIG_PM && CONFIG_PPC32 */
 
 static struct sysdev_class pmacpic_sysclass = {
-	set_kset_name("pmac_pic"),
+	.name = "pmac_pic",
 };
 
 static struct sys_device device_pmacpic = {
diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
index 05a56e5..e898ff4 100644
--- a/arch/powerpc/sysdev/ipic.c
+++ b/arch/powerpc/sysdev/ipic.c
@@ -725,7 +725,7 @@ unsigned int ipic_get_irq(void)
 }
 
 static struct sysdev_class ipic_sysclass = {
-	set_kset_name("ipic"),
+	.name = "ipic",
 };
 
 static struct sys_device device_ipic = {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index e479388..212a94f 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1584,7 +1584,7 @@ static struct sysdev_class mpic_sysclass = {
 	.resume = mpic_resume,
 	.suspend = mpic_suspend,
 #endif
-	set_kset_name("mpic"),
+	.name = "mpic",
 };
 
 static int mpic_init_sys(void)
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
index e1c0fd6..f59444d 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -483,7 +483,7 @@ int qe_ic_set_high_priority(unsigned int virq, unsigned int priority, int high)
 }
 
 static struct sysdev_class qe_ic_sysclass = {
-	set_kset_name("qe_ic"),
+	.name = "qe_ic",
 };
 
 static struct sys_device device_qe_ic = {
diff --git a/arch/ppc/syslib/ipic.c b/arch/ppc/syslib/ipic.c
index 9192777..4f163e2 100644
--- a/arch/ppc/syslib/ipic.c
+++ b/arch/ppc/syslib/ipic.c
@@ -614,7 +614,7 @@ int ipic_get_irq(void)
 }
 
 static struct sysdev_class ipic_sysclass = {
-	set_kset_name("ipic"),
+	.name = "ipic",
 };
 
 static struct sys_device device_ipic = {
diff --git a/arch/ppc/syslib/open_pic.c b/arch/ppc/syslib/open_pic.c
index 18ec947..da36522 100644
--- a/arch/ppc/syslib/open_pic.c
+++ b/arch/ppc/syslib/open_pic.c
@@ -1043,7 +1043,7 @@ int openpic_resume(struct sys_device *sysdev)
 #endif /* CONFIG_PM */
 
 static struct sysdev_class openpic_sysclass = {
-	set_kset_name("openpic"),
+	.name = "openpic",
 };
 
 static struct sys_device device_openpic = {
diff --git a/arch/ppc/syslib/open_pic2.c b/arch/ppc/syslib/open_pic2.c
index d585207..449075a 100644
--- a/arch/ppc/syslib/open_pic2.c
+++ b/arch/ppc/syslib/open_pic2.c
@@ -666,7 +666,7 @@ int openpic2_resume(struct sys_device *sysdev)
 
 /* HACK ALERT */
 static struct sysdev_class openpic2_sysclass = {
-	set_kset_name("openpic2"),
+	.name = "openpic2",
 };
 
 static struct sys_device device_openpic2 = {
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 22b800c..3bbac12 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -1145,7 +1145,7 @@ static void etr_work_fn(struct work_struct *work)
  * Sysfs interface functions
  */
 static struct sysdev_class etr_sysclass = {
-	set_kset_name("etr")
+	.name	= "etr",
 };
 
 static struct sys_device etr_port0_dev = {
diff --git a/arch/sh/drivers/dma/dma-sysfs.c b/arch/sh/drivers/dma/dma-sysfs.c
index eebcd47..51b57c0 100644
--- a/arch/sh/drivers/dma/dma-sysfs.c
+++ b/arch/sh/drivers/dma/dma-sysfs.c
@@ -19,7 +19,7 @@
 #include <asm/dma.h>
 
 static struct sysdev_class dma_sysclass = {
-	set_kset_name("dma"),
+	.name = "dma",
 };
 EXPORT_SYMBOL(dma_sysclass);
 
diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index a3a67d1..2bc04bf 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -174,7 +174,7 @@ int timer_resume(struct sys_device *dev)
 #endif
 
 static struct sysdev_class timer_sysclass = {
-	set_kset_name("timer"),
+	.name	 = "timer",
 	.suspend = timer_suspend,
 	.resume	 = timer_resume,
 };
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index edb5108..a56c782 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1530,7 +1530,7 @@ static int lapic_resume(struct sys_device *dev)
  */
 
 static struct sysdev_class lapic_sysclass = {
-	set_kset_name("lapic"),
+	.name		= "lapic",
 	.resume		= lapic_resume,
 	.suspend	= lapic_suspend,
 };
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index f28ccb5..fa6cdee 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -639,7 +639,7 @@ static int lapic_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class lapic_sysclass = {
-	set_kset_name("lapic"),
+	.name		= "lapic",
 	.resume		= lapic_resume,
 	.suspend	= lapic_suspend,
 };
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 4b21d29..242e866 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -745,7 +745,7 @@ static void mce_restart(void)
 
 static struct sysdev_class mce_sysclass = {
 	.resume = mce_resume,
-	set_kset_name("machinecheck"),
+	.name = "machinecheck",
 };
 
 DEFINE_PER_CPU(struct sys_device, device_mce);
diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index 2931383..dbd6c1d 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -51,7 +51,7 @@ static int i8237A_suspend(struct sys_device *dev, pm_message_t state)
 }
 
 static struct sysdev_class i8237_sysdev_class = {
-	set_kset_name("i8237"),
+	.name = "i8237",
 	.suspend = i8237A_suspend,
 	.resume = i8237A_resume,
 };
diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index f634fc7..5f3496d 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -258,7 +258,7 @@ static int i8259A_shutdown(struct sys_device *dev)
 }
 
 static struct sysdev_class i8259_sysdev_class = {
-	set_kset_name("i8259"),
+	.name = "i8259",
 	.suspend = i8259A_suspend,
 	.resume = i8259A_resume,
 	.shutdown = i8259A_shutdown,
diff --git a/arch/x86/kernel/i8259_64.c b/arch/x86/kernel/i8259_64.c
index 3f27ea0..ba6d572 100644
--- a/arch/x86/kernel/i8259_64.c
+++ b/arch/x86/kernel/i8259_64.c
@@ -370,7 +370,7 @@ static int i8259A_shutdown(struct sys_device *dev)
 }
 
 static struct sysdev_class i8259_sysdev_class = {
-	set_kset_name("i8259"),
+	.name = "i8259",
 	.suspend = i8259A_suspend,
 	.resume = i8259A_resume,
 	.shutdown = i8259A_shutdown,
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a6b1490..ab77f19 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2401,7 +2401,7 @@ static int ioapic_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class ioapic_sysdev_class = {
-	set_kset_name("ioapic"),
+	.name = "ioapic",
 	.suspend = ioapic_suspend,
 	.resume = ioapic_resume,
 };
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index cbac167..23a3ac0 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1850,7 +1850,7 @@ static int ioapic_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class ioapic_sysdev_class = {
-	set_kset_name("ioapic"),
+	.name = "ioapic",
 	.suspend = ioapic_suspend,
 	.resume = ioapic_resume,
 };
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 852db29..4f4bfd3 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -176,7 +176,7 @@ static int lapic_nmi_resume(struct sys_device *dev)
 
 
 static struct sysdev_class nmi_sysclass = {
-	set_kset_name("lapic_nmi"),
+	.name		= "lapic_nmi",
 	.resume		= lapic_nmi_resume,
 	.suspend	= lapic_nmi_suspend,
 };
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index 4253c4e..c3d1476 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -211,7 +211,7 @@ static int lapic_nmi_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class nmi_sysclass = {
-	set_kset_name("lapic_nmi"),
+	.name		= "lapic_nmi",
 	.resume		= lapic_nmi_resume,
 	.suspend	= lapic_nmi_suspend,
 };
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 944bbcd..c8ab79e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -51,7 +51,7 @@ static int nmi_resume(struct sys_device *dev)
 
 
 static struct sysdev_class oprofile_sysclass = {
-	set_kset_name("oprofile"),
+	.name		= "oprofile",
 	.resume		= nmi_resume,
 	.suspend	= nmi_suspend,
 };
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index c9f526e..5400ea1 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -911,7 +911,7 @@ __setup("acpi_irq_balance", acpi_irq_balance_set);
 
 /* FIXME: we will remove this interface after all drivers call pci_disable_device */
 static struct sysdev_class irqrouter_sysdev_class = {
-	set_kset_name("irqrouter"),
+	.name = "irqrouter",
 	.resume = irqrouter_resume,
 };
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 61fd26c..b962a76 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -466,7 +466,6 @@ static struct kset_uevent_ops class_uevent_ops = {
  * entirely soon.
  */
 static struct kset class_obj_subsys = {
-	.kobj = { .k_name = "class_obj", },
 	.uevent_ops = &class_uevent_ops,
 };
 
@@ -872,6 +871,7 @@ int __init classes_init(void)
 	/* ick, this is ugly, the things we go through to keep from showing up
 	 * in sysfs... */
 	kset_init(&class_obj_subsys);
+	kobject_set_name(&class_obj_subsys.kobj, "class_obj");
 	if (!class_obj_subsys.kobj.parent)
 		class_obj_subsys.kobj.parent = &class_obj_subsys.kobj;
 	return 0;
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 4054507..c5885f5 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -14,7 +14,7 @@
 #include "base.h"
 
 struct sysdev_class cpu_sysdev_class = {
-	set_kset_name("cpu"),
+	.name = "cpu",
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7868707..7ae413f 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -26,7 +26,7 @@
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
-	set_kset_name(MEMORY_CLASS_NAME),
+	.name = MEMORY_CLASS_NAME,
 };
 
 static const char *memory_uevent_name(struct kset *kset, struct kobject *kobj)
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 88eeed7..e59861f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -15,7 +15,7 @@
 #include <linux/device.h>
 
 static struct sysdev_class node_class = {
-	set_kset_name("node"),
+	.name = "node",
 };
 
 
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index e666441..2f79c55 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -136,6 +136,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
+	kobject_set_name(&cls->kset.kobj, cls->name);
 	return kset_register(&cls->kset);
 }
 
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index e0c4a40..7e1374a 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -31,7 +31,7 @@ struct workqueue_struct *edac_workqueue;
  *	need to export to other files in this modules
  */
 static struct sysdev_class edac_class = {
-	set_kset_name("edac"),
+	.name = "edac",
 };
 static int edac_class_valid;
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 47c10b8..c0f372f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3451,7 +3451,7 @@ static int kvm_resume(struct sys_device *dev)
 }
 
 static struct sysdev_class kvm_sysdev_class = {
-	set_kset_name("kvm"),
+	.name = "kvm",
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
 };
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6123c70..ac420b1 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2796,7 +2796,7 @@ static int pmu_sys_resume(struct sys_device *sysdev)
 #endif /* CONFIG_PM_SLEEP && CONFIG_PPC32 */
 
 static struct sysdev_class pmu_sysclass = {
-	set_kset_name("pmu"),
+	.name = "pmu",
 };
 
 static struct sys_device device_pmu = {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7663841..a3fdc57 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -464,7 +464,7 @@ int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	res = sas_phy_reset(phy, 1);
 	if (res)
 		SAS_DPRINTK("Bus reset of %s failed 0x%x\n",
-			    phy->dev.kobj.k_name,
+			    kobject_name(&phy->dev.kobj),
 			    res);
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
 		return SUCCESS;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 504ac0e..4adbe1d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -61,7 +61,7 @@ enum kobject_action {
 };
 
 struct kobject {
-	const char		* k_name;
+	const char		*name;
 	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		* parent;
@@ -69,7 +69,6 @@ struct kobject {
 	struct kobj_type	* ktype;
 	struct sysfs_dirent	* sd;
 	unsigned int state_initialized:1;
-	unsigned int state_name_set:1;
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
 	unsigned int state_remove_uevent_sent:1;
@@ -80,7 +79,7 @@ extern int kobject_set_name(struct kobject *, const char *, ...)
 
 static inline const char * kobject_name(const struct kobject * kobj)
 {
-	return kobj->k_name;
+	return kobj->name;
 }
 
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
@@ -189,14 +188,6 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
 
 extern struct kobject * kset_find_obj(struct kset *, const char *);
 
-
-/*
- * Use this when initializing an embedded kset with no other 
- * fields to initialize.
- */
-#define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
-
-
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index e285746..f752e73 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -29,6 +29,7 @@
 struct sys_device;
 
 struct sysdev_class {
+	const char *name;
 	struct list_head	drivers;
 
 	/* Default operations for these types of devices */
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index e3055ba..092e4c6 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -394,7 +394,7 @@ static SYSDEV_ATTR(status, 0600, sysfs_test_status, NULL);
 static SYSDEV_ATTR(command, 0600, NULL, sysfs_test_command);
 
 static struct sysdev_class rttest_sysclass = {
-	set_kset_name("rttest"),
+	.name = "rttest",
 };
 
 static int init_test_thread(int id)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c8a9d13..8d6125a 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -441,7 +441,7 @@ static SYSDEV_ATTR(available_clocksource, 0600,
 		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
-	set_kset_name("clocksource"),
+	.name = "clocksource",
 };
 
 static struct sys_device device_clocksource = {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e5e466b..ab46ae8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -335,9 +335,9 @@ static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
 
 /* sysfs resume/suspend bits for timekeeping */
 static struct sysdev_class timekeeping_sysclass = {
+	.name		= "timekeeping",
 	.resume		= timekeeping_resume,
 	.suspend	= timekeeping_suspend,
-	set_kset_name("timekeeping"),
 };
 
 static struct sys_device device_timer = {
diff --git a/lib/kobject.c b/lib/kobject.c
index a077373..8dc3245 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -165,7 +165,7 @@ static int kobject_add_internal(struct kobject *kobj)
 	if (!kobj)
 		return -ENOENT;
 
-	if (!kobj->k_name || !kobj->k_name[0]) {
+	if (!kobj->name || !kobj->name[0]) {
 		pr_debug("kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
 		WARN_ON(1);
@@ -228,13 +228,11 @@ static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 	if (!name)
 		return -ENOMEM;
 
-
 	/* Free the old name, if necessary. */
-	kfree(kobj->k_name);
+	kfree(kobj->name);
 
 	/* Now, set the new name */
-	kobj->k_name = name;
-	kobj->state_name_set = 1;
+	kobj->name = name;
 
 	return 0;
 }
@@ -295,7 +293,6 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
 	kobj->ktype = ktype;
-	kobj->state_name_set = 0;
 	kobj->state_in_sysfs = 0;
 	kobj->state_add_uevent_sent = 0;
 	kobj->state_remove_uevent_sent = 0;
@@ -551,8 +548,7 @@ struct kobject * kobject_get(struct kobject * kobj)
 static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type *t = get_ktype(kobj);
-	const char *name = kobj->k_name;
-	int name_set = kobj->state_name_set;
+	const char *name = kobj->name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __FUNCTION__);
@@ -583,7 +579,7 @@ static void kobject_cleanup(struct kobject *kobj)
 	}
 
 	/* free name if we allocated it */
-	if (name_set && name) {
+	if (name) {
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree(name);
 	}
-- 
1.5.3.8


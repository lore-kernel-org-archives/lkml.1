Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbXE1Qni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbXE1Qni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762804AbXE1Qn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:43:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54222 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbXE1Qn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:43:28 -0400
Date: Mon, 28 May 2007 18:44:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: fix section mismatch warnings
Message-ID: <20070528164427.GB29174@uranus.ravnborg.org>
References: <20070528163253.GA29174@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528163253.GA29174@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes these section mismatch warnings:

WARNING: drivers/built-in.o(.text+0x49f5c): Section mismatch: reference to .init.text:pcmcia_assabet_init (between 'sa11x0_drv_pcmcia_probe' and 'assabet_pcmcia_socket_state')
WARNING: arch/arm/mach-at91/built-in.o(.text+0xdf4): Section mismatch: reference to .init.data:dk_nand_partition (between 'nand_partitions' and 'at91_leds_event')
WARNING: arch/arm/mach-at91/built-in.o(.text+0xbdc): Section mismatch: reference to .init.data:ek_nand_partition (after 'nand_partitions')
WARNING: arch/arm/mach-at91/built-in.o(.text+0xbdc): Section mismatch: reference to .init.data:ek_nand_partition (between 'nand_partitions' and 'ads7843_pendown_state')
WARNING: arch/arm/mach-at91/built-in.o(.text+0xbdc): Section mismatch: reference to .init.data:ek_nand_partition (after 'nand_partitions')
WARNING: drivers/pcmcia/sa1100_cs.o(.text+0xc): Section mismatch: reference to .init.text:pcmcia_cerf_init (between 'sa11x0_drv_pcmcia_probe' and 'cerf_pcmcia_socket_state')
WARNING: arch/arm/mach-footbridge/built-in.o(.text+0xaa4): Section mismatch: reference to .init.data:cats_pci (between 'cats_pci_init' and 'ebsa285_leds_event')
WARNING: drivers/built-in.o(.text+0x3df80): Section mismatch: reference to .init.text:pcmcia_h3600_init (between 'sa11x0_drv_pcmcia_probe' and 'h3600_pcmcia_socket_state')
WARNING: arch/arm/mach-ixp2000/built-in.o(.text+0xb54): Section mismatch: reference to .init.text:ixp2000_init_irq (between 'ixdp2x00_init_irq' and 'ixdp2x00_irq_handler')
WARNING: arch/arm/mach-ixp23xx/built-in.o(.text+0x670): Section mismatch: reference to .init.text:ixp23xx_pci_common_init (between 'ixp23xx_pci_slave_init' and 'ixp23xx_pci_scan_bus')
WARNING: arch/arm/mach-ixp23xx/built-in.o(.text+0x890): Section mismatch: reference to .init.text:ixp23xx_init_irq (between 'ixdp2351_init_irq' and 'roadrunner_pci_preinit')
WARNING: arch/arm/mach-ixp23xx/built-in.o(.text+0x9a8): Section mismatch: reference to .init.text:ixp23xx_pci_preinit (after 'roadrunner_pci_preinit')
WARNING: arch/arm/mach-at91/built-in.o(.text+0xc28): Section mismatch: reference to .init.data:kb9202_nand_partition (after 'nand_partitions')
WARNING: arch/arm/mach-ks8695/built-in.o(.text+0x2b8): Section mismatch: reference to .init.text:ks8695_add_device_wan (after 'micrel_init')
WARNING: arch/arm/mach-ks8695/built-in.o(.text+0x2bc): Section mismatch: reference to .init.text:ks8695_add_device_lan (after 'micrel_init')
WARNING: drivers/built-in.o(.text+0x3f100): Section mismatch: reference to .init.text:ps2_clear_input (between 'ps2_probe' and 'ps2_cmd_aborted')
WARNING: drivers/built-in.o(.text+0x3f1c8): Section mismatch: reference to .init.text:ps2_clear_input (between 'ps2_probe' and 'ps2_cmd_aborted')
WARNING: arch/arm/mach-imx/built-in.o(__ksymtab+0x80): Section mismatch: reference to .init.text:imx_set_mmc_info (between '__ksymtab_imx_set_mmc_info' and '__ksymtab_set_imx_fb_info')
WARNING: arch/arm/mach-imx/built-in.o(__ksymtab+0x88): Section mismatch: reference to .init.text:set_imx_fb_info (after '__ksymtab_set_imx_fb_info')
WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1930): Section mismatch: reference to .init.data:neponset_port_fns (between 'neponset_probe' and 'assabet_leds_event')
WARNING: drivers/built-in.o(.text+0x4dc8c): Section mismatch: reference to .init.text:pcmcia_assabet_init (between 'sa11x0_drv_pcmcia_probe' and 'assabet_pcmcia_socket_state')
WARNING: drivers/built-in.o(.text+0x4e0bc): Section mismatch: reference to .init.text:pcmcia_neponset_init (between 'pcmcia_probe' and 'sa1111_pcmcia_socket_suspend')
WARNING: drivers/built-in.o(.text+0x4f988): Section mismatch: reference to .init.text:ps2_clear_input (between 'ps2_probe' and 'ps2_cmd_aborted')
WARNING: drivers/built-in.o(.text+0x4fa50): Section mismatch: reference to .init.text:ps2_clear_input (between 'ps2_probe' and 'ps2_cmd_aborted')

All changes are build tested only.
The ones that introduce __devinit ought to have a close review before applying.
The rest are trivial.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/arm/mach-at91/board-dk.c b/arch/arm/mach-at91/board-dk.c
index 6043c38..af49789 100644
--- a/arch/arm/mach-at91/board-dk.c
+++ b/arch/arm/mach-at91/board-dk.c
@@ -132,7 +132,7 @@ static struct mtd_partition __initdata dk_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(dk_nand_partition);
 	return dk_nand_partition;
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 76f6e1e..7d9b1a2 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -96,7 +96,7 @@ static struct mtd_partition __initdata kb9202_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(kb9202_nand_partition);
 	return kb9202_nand_partition;
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 1f0c8a4..26ca8ab 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -178,7 +178,7 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(ek_nand_partition);
 	return ek_nand_partition;
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index f574585..c164c8e 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -180,7 +180,7 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(ek_nand_partition);
 	return ek_nand_partition;
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 30c79ac..9b61320 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -87,7 +87,7 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(ek_nand_partition);
 	return ek_nand_partition;
diff --git a/arch/arm/mach-footbridge/cats-pci.c b/arch/arm/mach-footbridge/cats-pci.c
index 4f984fd..35eb232 100644
--- a/arch/arm/mach-footbridge/cats-pci.c
+++ b/arch/arm/mach-footbridge/cats-pci.c
@@ -45,7 +45,7 @@ static struct hw_pci cats_pci __initdata = {
 	.postinit		= dc21285_postinit,
 };
 
-static int cats_pci_init(void)
+static int __init cats_pci_init(void)
 {
 	if (machine_is_cats())
 		pci_common_init(&cats_pci);
diff --git a/arch/arm/mach-imx/generic.c b/arch/arm/mach-imx/generic.c
index 7a7fa51..1c474cf 100644
--- a/arch/arm/mach-imx/generic.c
+++ b/arch/arm/mach-imx/generic.c
@@ -201,7 +201,6 @@ void __init imx_set_mmc_info(struct imxmmc_platform_data *info)
 {
 	imx_mmc_device.dev.platform_data = info;
 }
-EXPORT_SYMBOL(imx_set_mmc_info);
 
 static struct imxfb_mach_info imx_fb_info;
 
diff --git a/arch/arm/mach-ixp2000/ixdp2400.c b/arch/arm/mach-ixp2000/ixdp2400.c
index 0fdd03a..ce7c15c 100644
--- a/arch/arm/mach-ixp2000/ixdp2400.c
+++ b/arch/arm/mach-ixp2000/ixdp2400.c
@@ -164,7 +164,7 @@ int __init ixdp2400_pci_init(void)
 
 subsys_initcall(ixdp2400_pci_init);
 
-void ixdp2400_init_irq(void)
+void __init ixdp2400_init_irq(void)
 {
 	ixdp2x00_init_irq(IXDP2400_CPLD_INT_STAT, IXDP2400_CPLD_INT_MASK, IXDP2400_NR_IRQS);
 }
diff --git a/arch/arm/mach-ixp2000/ixdp2800.c b/arch/arm/mach-ixp2000/ixdp2800.c
index 70d247f..14f09b8 100644
--- a/arch/arm/mach-ixp2000/ixdp2800.c
+++ b/arch/arm/mach-ixp2000/ixdp2800.c
@@ -279,7 +279,7 @@ int __init ixdp2800_pci_init(void)
 
 subsys_initcall(ixdp2800_pci_init);
 
-void ixdp2800_init_irq(void)
+void __init ixdp2800_init_irq(void)
 {
 	ixdp2x00_init_irq(IXDP2800_CPLD_INT_STAT, IXDP2800_CPLD_INT_MASK, IXDP2800_NR_IRQS);
 }
diff --git a/arch/arm/mach-ixp2000/ixdp2x00.c b/arch/arm/mach-ixp2000/ixdp2x00.c
index 011065b..73c651e 100644
--- a/arch/arm/mach-ixp2000/ixdp2x00.c
+++ b/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -145,7 +145,7 @@ static struct irq_chip ixdp2x00_cpld_irq_chip = {
 	.unmask	= ixdp2x00_irq_unmask
 };
 
-void ixdp2x00_init_irq(volatile unsigned long *stat_reg, volatile unsigned long *mask_reg, unsigned long nr_irqs)
+void __init ixdp2x00_init_irq(volatile unsigned long *stat_reg, volatile unsigned long *mask_reg, unsigned long nr_irqs)
 {
 	unsigned int irq;
 
diff --git a/arch/arm/mach-ixp23xx/ixdp2351.c b/arch/arm/mach-ixp23xx/ixdp2351.c
index 7a86a25..c41a6b5 100644
--- a/arch/arm/mach-ixp23xx/ixdp2351.c
+++ b/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -124,7 +124,7 @@ static struct irq_chip ixdp2351_intb_chip = {
 	.unmask	= ixdp2351_intb_unmask
 };
 
-void ixdp2351_init_irq(void)
+void __init ixdp2351_init_irq(void)
 {
 	int irq;
 
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index ac7d43d..227f808 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -284,7 +284,7 @@ int ixp23xx_pci_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-void ixp23xx_pci_slave_init(void)
+void __init ixp23xx_pci_slave_init(void)
 {
 	ixp23xx_pci_common_init();
 }
diff --git a/arch/arm/mach-ixp23xx/roadrunner.c b/arch/arm/mach-ixp23xx/roadrunner.c
index d06e21b..e356449 100644
--- a/arch/arm/mach-ixp23xx/roadrunner.c
+++ b/arch/arm/mach-ixp23xx/roadrunner.c
@@ -110,7 +110,7 @@ static int __init roadrunner_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
 	return NO_IRQ;
 }
 
-static void roadrunner_pci_preinit(void)
+static void __init roadrunner_pci_preinit(void)
 {
 	set_irq_type(IRQ_ROADRUNNER_PCI_INTC, IRQT_LOW);
 	set_irq_type(IRQ_ROADRUNNER_PCI_INTD, IRQT_LOW);
diff --git a/arch/arm/mach-ks8695/board-micrel.c b/arch/arm/mach-ks8695/board-micrel.c
index 8fc0edb..136ec1a 100644
--- a/arch/arm/mach-ks8695/board-micrel.c
+++ b/arch/arm/mach-ks8695/board-micrel.c
@@ -35,7 +35,7 @@ static struct ks8695_pci_cfg micrel_pci = {
 #endif
 
 
-static void micrel_init(void)
+static void __init micrel_init(void)
 {
 	printk(KERN_INFO "Micrel KS8695 Development Board initializing\n");
 
diff --git a/arch/arm/mach-sa1100/neponset.c b/arch/arm/mach-sa1100/neponset.c
index d7c038a..17ebdc4 100644
--- a/arch/arm/mach-sa1100/neponset.c
+++ b/arch/arm/mach-sa1100/neponset.c
@@ -139,12 +139,12 @@ static u_int neponset_get_mctrl(struct uart_port *port)
 	return ret;
 }
 
-static struct sa1100_port_fns neponset_port_fns __initdata = {
+static struct sa1100_port_fns neponset_port_fns __devinitdata = {
 	.set_mctrl	= neponset_set_mctrl,
 	.get_mctrl	= neponset_get_mctrl,
 };
 
-static int neponset_probe(struct platform_device *dev)
+static int __devinit neponset_probe(struct platform_device *dev)
 {
 	sa1100_register_uart_fns(&neponset_port_fns);
 
@@ -299,7 +299,7 @@ static struct platform_device *devices[] __initdata = {
 	&smc91x_device,
 };
 
-static int __init neponset_init(void)
+static int __devinit neponset_init(void)
 {
 	platform_driver_register(&neponset_device_driver);
 
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 5595087..d31ece8 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -170,7 +170,7 @@ static void ps2_close(struct serio *io)
 /*
  * Clear the input buffer.
  */
-static void __init ps2_clear_input(struct ps2if *ps2if)
+static void __devinit ps2_clear_input(struct ps2if *ps2if)
 {
 	int maxread = 100;
 
@@ -228,7 +228,7 @@ static int __init ps2_test(struct ps2if *ps2if)
 /*
  * Add one device to this driver.
  */
-static int ps2_probe(struct sa1111_dev *dev)
+static int __devinit ps2_probe(struct sa1111_dev *dev)
 {
 	struct ps2if *ps2if;
 	struct serio *serio;
diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index c5b2a44..9fb8eaa 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -44,7 +44,7 @@
 
 int __init pcmcia_collie_init(struct device *dev);
 
-static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) = {
+static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) __initdata = {
 #ifdef CONFIG_SA1100_ASSABET
 	pcmcia_assabet_init,
 #endif
@@ -65,7 +65,7 @@ static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) = {
 #endif
 };
 
-static int sa11x0_drv_pcmcia_probe(struct device *dev)
+static int __init sa11x0_drv_pcmcia_probe(struct device *dev)
 {
 	int i, ret = -ENODEV;
 

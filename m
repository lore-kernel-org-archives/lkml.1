Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXHENEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXHENEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 09:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXHENEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 09:04:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:19432 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXHENET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 09:04:19 -0400
X-IronPort-AV: i="4.19,221,1183348800"; 
   d="scan'208"; a="47434660:sNHT59288859"
Subject: [GIT PULL] Blackfin arch update for 2.6.23
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sun, 05 Aug 2007 21:02:49 +0800
Message-Id: <1186318969.16030.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 05 Aug 2007 13:04:15.0864 (UTC) FILETIME=[20650780:01C7D761]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |    2 +-
 arch/blackfin/kernel/bfin_gpio.c                  |  291 ++++++++++++++--
 arch/blackfin/kernel/init_task.c                  |    1 +
 arch/blackfin/kernel/process.c                    |    2 +
 arch/blackfin/kernel/sys_bfin.c                   |    1 +
 arch/blackfin/kernel/traps.c                      |    1 +
 arch/blackfin/mach-bf548/Kconfig                  |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |  367 ++++++++++++++++++++-
 arch/blackfin/mach-bf548/gpio.c                   |   98 +++++-
 arch/blackfin/mach-common/ints-priority-dc.c      |    4 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |    8 +-
 drivers/spi/spi_bfin5xx.c                         |  149 +++++----
 include/asm-blackfin/bfin5xx_spi.h                |    6 +
 include/asm-blackfin/gpio.h                       |   31 ++
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf533/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf533/irq.h             |    2 +
 include/asm-blackfin/mach-bf533/portmux.h         |    2 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   23 +-
 include/asm-blackfin/mach-bf537/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf537/irq.h             |    2 +
 include/asm-blackfin/mach-bf537/portmux.h         |   35 ++-
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |   39 +--
 include/asm-blackfin/mach-bf548/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf548/defBF54x_base.h   |   17 +
 include/asm-blackfin/mach-bf548/gpio.h            |    5 -
 include/asm-blackfin/mach-bf548/irq.h             |    2 +
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf561/blackfin.h        |    2 +-
 include/asm-blackfin/mach-bf561/irq.h             |    2 +
 include/asm-blackfin/portmux.h                    |   22 ++
 31 files changed, 971 insertions(+), 175 deletions(-)

Bryan Wu (4):
      Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
      Blackfin arch: update platform driver resource information to the ezkitBF548 board file
      Blackfin arch: after removing fs.h from mm.h, fix the broken on Blackfin arch.
      Blackfin SPI driver: Initial supporting BF54x in SPI driver

Michael Hennerich (11):
      Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
      Blackfin arch: add peripheral resource allocation support
      Blackfin arch: Add label to call new GPIO API
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
      Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
      Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
      Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
      Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
      Blackfin serial driver: use new GPIO API
      Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
      Blackfin SPI driver: use new GPIO API and add error handling

Mike Frysinger (1):
      Blackfin arch: scrub remaining ASSEMBLY usage since the switch to __ASSEMBLY__

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 017defa..5c1e215 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_TIME
 	bool
 	default n
 
-config GENERIC_CALIBRATE_DELAY
+config GENERIC_GPIO
 	bool
 	default y
 
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bafcfa5..f712772 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -84,6 +84,7 @@
 #include <linux/err.h>
 #include <asm/blackfin.h>
 #include <asm/gpio.h>
+#include <asm/portmux.h>
 #include <linux/irq.h>
 
 #ifdef BF533_FAMILY
@@ -115,7 +116,11 @@ static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 };
 #endif
 
-static unsigned short reserved_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_gpio_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_peri_map[gpio_bank(MAX_BLACKFIN_GPIOS + 16)];
+char *str_ident = NULL;
+
+#define RESOURCE_LABEL_SIZE 16
 
 #ifdef CONFIG_PM
 static unsigned short wakeup_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
@@ -143,22 +148,100 @@ inline int check_gpio(unsigned short gpio)
 	return 0;
 }
 
+static void set_label(unsigned short ident, const char *label)
+{
+
+	if (label && str_ident) {
+		strncpy(str_ident + ident * RESOURCE_LABEL_SIZE, label,
+			 RESOURCE_LABEL_SIZE);
+		str_ident[ident * RESOURCE_LABEL_SIZE +
+			 RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(unsigned short ident)
+{
+	if (!str_ident)
+		return "UNKNOWN";
+
+	return (str_ident[ident * RESOURCE_LABEL_SIZE] ?
+		(str_ident + ident * RESOURCE_LABEL_SIZE) : "UNKNOWN");
+}
+
+static int cmp_label(unsigned short ident, const char *label)
+{
+	if (label && str_ident)
+		return strncmp(str_ident + ident * RESOURCE_LABEL_SIZE,
+				 label, strlen(label));
+	else
+		return -EINVAL;
+}
+
 #ifdef BF537_FAMILY
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
-	if (usage == GPIO_USAGE) {
-		if (*port_fer[gpio_bank(gpio)] & gpio_bit(gpio))
-			printk(KERN_WARNING "bfin-gpio: Possible Conflict with Peripheral "
-			       "usage and GPIO %d detected!\n", gpio);
-		*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
-	} else
-		*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
-	SSYNC();
+	if (!check_gpio(gpio)) {
+		if (usage == GPIO_USAGE) {
+			*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+		} else
+			*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
+		SSYNC();
+	}
 }
 #else
 # define port_setup(...)  do { } while (0)
 #endif
 
+#ifdef BF537_FAMILY
+
+#define PMUX_LUT_RES		0
+#define PMUX_LUT_OFFSET		1
+#define PMUX_LUT_ENTRIES	41
+#define PMUX_LUT_SIZE		2
+
+static unsigned short port_mux_lut[PMUX_LUT_ENTRIES][PMUX_LUT_SIZE] = {
+	{P_PPI0_D13, 11}, {P_PPI0_D14, 11}, {P_PPI0_D15, 11},
+	{P_SPORT1_TFS, 11}, {P_SPORT1_TSCLK, 11}, {P_SPORT1_DTPRI, 11},
+	{P_PPI0_D10, 10}, {P_PPI0_D11, 10}, {P_PPI0_D12, 10},
+	{P_SPORT1_RSCLK, 10}, {P_SPORT1_RFS, 10}, {P_SPORT1_DRPRI, 10},
+	{P_PPI0_D8, 9}, {P_PPI0_D9, 9}, {P_SPORT1_DRSEC, 9},
+	{P_SPORT1_DTSEC, 9}, {P_TMR2, 8}, {P_PPI0_FS3, 8}, {P_TMR3, 7},
+	{P_SPI0_SSEL4, 7}, {P_TMR4, 6}, {P_SPI0_SSEL5, 6}, {P_TMR5, 5},
+	{P_SPI0_SSEL6, 5}, {P_UART1_RX, 4}, {P_UART1_TX, 4}, {P_TMR6, 4},
+	{P_TMR7, 4}, {P_UART0_RX, 3}, {P_UART0_TX, 3}, {P_DMAR0, 3},
+	{P_DMAR1, 3}, {P_SPORT0_DTSEC, 1}, {P_SPORT0_DRSEC, 1},
+	{P_CAN0_RX, 1}, {P_CAN0_TX, 1}, {P_SPI0_SSEL7, 1},
+	{P_SPORT0_TFS, 0}, {P_SPORT0_DTPRI, 0}, {P_SPI0_SSEL2, 0},
+	{P_SPI0_SSEL3, 0}
+};
+
+static void portmux_setup(unsigned short per, unsigned short function)
+{
+	u16 y, muxreg, offset;
+
+	for (y = 0; y < PMUX_LUT_ENTRIES; y++) {
+		if (port_mux_lut[y][PMUX_LUT_RES] == per) {
+
+			/* SET PORTMUX REG */
+
+			offset = port_mux_lut[y][PMUX_LUT_OFFSET];
+			muxreg = bfin_read_PORT_MUX();
+
+			if (offset != 1) {
+				muxreg &= ~(1 << offset);
+			} else {
+				muxreg &= ~(3 << 1);
+			}
+
+			muxreg |= (function << offset);
+			bfin_write_PORT_MUX(muxreg);
+		}
+	}
+}
+
+#else
+# define portmux_setup(...)  do { } while (0)
+#endif
 
 static void default_gpio(unsigned short gpio)
 {
@@ -179,22 +262,15 @@ static void default_gpio(unsigned short gpio)
 
 static int __init bfin_gpio_init(void)
 {
-	int i;
-
-	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
-	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE)
-		reserved_map[gpio_bank(i)] = 0;
+	str_ident = kzalloc(RESOURCE_LABEL_SIZE * 256, GFP_KERNEL);
+	if (!str_ident)
+		return -ENOMEM;
 
-#if defined(BF537_FAMILY) && (defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
-# if defined(CONFIG_BFIN_MAC_RMII)
-	reserved_map[gpio_bank(PORT_H)] = 0xC373;
-# else
-	reserved_map[gpio_bank(PORT_H)] = 0xFFFF;
-# endif
-#endif
+	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
 	return 0;
+
 }
 
 arch_initcall(bfin_gpio_init);
@@ -223,7 +299,7 @@ arch_initcall(bfin_gpio_init);
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	local_irq_save(flags); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name |= gpio_bit(gpio); \
@@ -243,7 +319,7 @@ SET_GPIO(both)
 #define SET_GPIO_SC(name) \
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name ## _set = gpio_bit(gpio); \
 	else \
@@ -258,7 +334,7 @@ SET_GPIO_SC(maskb)
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	if (arg)
 		gpio_bankb[gpio_bank(gpio)]->data_set = gpio_bit(gpio);
@@ -277,7 +353,7 @@ SET_GPIO_SC(data)
 void set_gpio_toggle(unsigned short gpio)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 	bfin_read_CHIPID();
@@ -286,7 +362,7 @@ void set_gpio_toggle(unsigned short gpio)
 #else
 void set_gpio_toggle(unsigned short gpio)
 {
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 }
 #endif
@@ -350,7 +426,7 @@ unsigned short get_gpio_data(unsigned short gpio)
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = 0x01 & (gpio_bankb[gpio_bank(gpio)]->data >> gpio_sub_n(gpio));
 	bfin_read_CHIPID();
@@ -494,13 +570,14 @@ u32 gpio_pm_setup(void)
 			gpio_bank_saved[bank].dir   = gpio_bankb[bank]->dir;
 			gpio_bank_saved[bank].edge  = gpio_bankb[bank]->edge;
 			gpio_bank_saved[bank].both  = gpio_bankb[bank]->both;
-			gpio_bank_saved[bank].reserved = reserved_map[bank];
+			gpio_bank_saved[bank].reserved =
+						reserved_gpio_map[bank];
 
 			gpio = i;
 
 			while (mask) {
 				if (mask & 1) {
-					reserved_map[gpio_bank(gpio)] |=
+					reserved_gpio_map[gpio_bank(gpio)] |=
 							gpio_bit(gpio);
 					bfin_gpio_wakeup_type(gpio,
 						wakeup_flags_map[gpio]);
@@ -540,7 +617,8 @@ void gpio_pm_restore(void)
 			gpio_bankb[bank]->edge  = gpio_bank_saved[bank].edge;
 			gpio_bankb[bank]->both  = gpio_bank_saved[bank].both;
 
-			reserved_map[bank] = gpio_bank_saved[bank].reserved;
+			reserved_gpio_map[bank] =
+					gpio_bank_saved[bank].reserved;
 
 		}
 
@@ -550,6 +628,147 @@ void gpio_pm_restore(void)
 
 #endif
 
+
+
+
+int peripheral_request(unsigned short per, const char *label)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	/*
+	 * Don't cares are pins with only one dedicated function
+	 */
+
+	if (per & P_DONTCARE)
+		return 0;
+
+	if (!(per & P_DEFINED))
+		return -ENODEV;
+
+	local_irq_save(flags);
+
+	if (!check_gpio(ident)) {
+
+	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
+		printk(KERN_ERR
+		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
+		       __FUNCTION__, ident, get_label(ident));
+		dump_stack();
+		local_irq_restore(flags);
+		return -EBUSY;
+	}
+
+	}
+
+	if (unlikely(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident))) {
+
+	/*
+	 * Pin functions like AMC address strobes my
+	 * be requested and used by several drivers
+	 */
+
+	if (!(per & P_MAYSHARE)) {
+
+	/*
+	 * Allow that the identical pin function can
+	 * be requested from the same driver twice
+	 */
+
+		if (cmp_label(ident, label) == 0)
+			goto anyway;
+
+			printk(KERN_ERR
+			       "%s: Peripheral %d function %d is already"
+			       "reserved by %s !\n",
+			       __FUNCTION__, ident, P_FUNCT2MUX(per),
+				get_label(ident));
+			dump_stack();
+			local_irq_restore(flags);
+			return -EBUSY;
+		}
+
+	}
+
+anyway:
+
+
+	portmux_setup(per, P_FUNCT2MUX(per));
+
+	port_setup(ident, PERIPHERAL_USAGE);
+
+	reserved_peri_map[gpio_bank(ident)] |= gpio_bit(ident);
+	local_irq_restore(flags);
+	set_label(ident, label);
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request);
+
+int peripheral_request_list(unsigned short per[], const char *label)
+{
+	u16 cnt;
+	int ret;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+
+		ret = peripheral_request(per[cnt], label);
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request_list);
+
+void peripheral_free(unsigned short per)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	if (per & P_DONTCARE)
+		return;
+
+	if (!(per & P_DEFINED))
+		return;
+
+	if (check_gpio(ident) < 0)
+		return;
+
+	local_irq_save(flags);
+
+	if (unlikely(!(reserved_peri_map[gpio_bank(ident)]
+			 & gpio_bit(ident)))) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	if (!(per & P_MAYSHARE)) {
+		port_setup(ident, GPIO_USAGE);
+	}
+
+	reserved_peri_map[gpio_bank(ident)] &= ~gpio_bit(ident);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(peripheral_free);
+
+void peripheral_free_list(unsigned short per[])
+{
+	u16 cnt;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+		peripheral_free(per[cnt]);
+	}
+
+}
+EXPORT_SYMBOL(peripheral_free_list);
+
 /***********************************************************
 *
 * FUNCTIONS: Blackfin GPIO Driver
@@ -574,13 +793,13 @@ int gpio_request(unsigned short gpio, const char *label)
 
 	local_irq_save(flags);
 
-	if (unlikely(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
+	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
 	}
-	reserved_map[gpio_bank(gpio)] |= gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] |= gpio_bit(gpio);
 
 	local_irq_restore(flags);
 
@@ -599,7 +818,7 @@ void gpio_free(unsigned short gpio)
 
 	local_irq_save(flags);
 
-	if (unlikely(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
+	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d wasn't reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
@@ -608,7 +827,7 @@ void gpio_free(unsigned short gpio)
 
 	default_gpio(gpio);
 
-	reserved_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
 
 	local_irq_restore(flags);
 }
@@ -618,7 +837,7 @@ void gpio_direction_input(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->dir &= ~gpio_bit(gpio);
@@ -631,7 +850,7 @@ void gpio_direction_output(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
diff --git a/arch/blackfin/kernel/init_task.c b/arch/blackfin/kernel/init_task.c
index b45188f..673c860 100644
--- a/arch/blackfin/kernel/init_task.c
+++ b/arch/blackfin/kernel/init_task.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/fs.h>
 
 static struct fs_struct init_fs = INIT_FS;
 static struct files_struct init_files = INIT_FILES;
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 5a51dd6..6a7aefe 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -33,6 +33,8 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/err.h>
 
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
diff --git a/arch/blackfin/kernel/sys_bfin.c b/arch/blackfin/kernel/sys_bfin.c
index f5e1ae3..abcd148 100644
--- a/arch/blackfin/kernel/sys_bfin.c
+++ b/arch/blackfin/kernel/sys_bfin.c
@@ -37,6 +37,7 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/ipc.h>
 #include <linux/unistd.h>
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8766bd6..792a841 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/fs.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index e78b03d..3976b7f 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -282,7 +282,7 @@ menu "Assignment"
 
 config PINTx_REASSIGN
 	bool "Reprogram PINT Assignment"
-	default n
+	default y
 	help
 	  The interrupt assignment registers controls the pin-to-interrupt
 	  assignment in a byte-wide manner. Each option allows you to select
@@ -303,7 +303,7 @@ config PINT1_ASSIGN
 config PINT2_ASSIGN
 	hex "PINT2_ASSIGN"
 	depends on PINTx_REASSIGN
-	default 0x00000101
+	default 0x07000101
 config PINT3_ASSIGN
 	hex "PINT3_ASSIGN"
 	depends on PINTx_REASSIGN
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 96ad95f..59e64c5 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -35,9 +35,13 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/irq.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
+#include <asm/dma.h>
+#include <asm/gpio.h>
+#include <asm/mach/nand.h>
+#include <asm/mach/bf54x_keys.h>
+#include <linux/spi/ad7877.h>
 
 /*
  * Name the Board for the /proc/cpuinfo
@@ -48,6 +52,87 @@ char *bfin_board_name = "ADSP-BF548-EZKIT";
  *  Driver needs to know address, irq and flag pin.
  */
 
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+
+#include <asm/mach/bf54x-lq043.h>
+
+static struct bfin_bf54xfb_mach_info bf54x_lq043_data = {
+	.width =	480,
+	.height =	272,
+	.xres =		{480, 480, 480},
+	.yres =		{272, 272, 272},
+	.bpp =		{24, 24, 24},
+	.disp =		GPIO_PE3,
+};
+
+static struct resource bf54x_lq043_resources[] = {
+	{
+		.start = IRQ_EPPI0_ERR,
+		.end = IRQ_EPPI0_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_lq043_device = {
+	.name		= "bf54x-lq043",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_lq043_resources),
+	.resource 	= bf54x_lq043_resources,
+	.dev		= {
+		.platform_data = &bf54x_lq043_data,
+	},
+};
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+static int bf548_keymap[] = {
+	KEYVAL(0, 0, KEY_ENTER),
+	KEYVAL(0, 1, KEY_HELP),
+	KEYVAL(0, 2, KEY_0),
+	KEYVAL(0, 3, KEY_BACKSPACE),
+	KEYVAL(1, 0, KEY_TAB),
+	KEYVAL(1, 1, KEY_9),
+	KEYVAL(1, 2, KEY_8),
+	KEYVAL(1, 3, KEY_7),
+	KEYVAL(2, 0, KEY_DOWN),
+	KEYVAL(2, 1, KEY_6),
+	KEYVAL(2, 2, KEY_5),
+	KEYVAL(2, 3, KEY_4),
+	KEYVAL(3, 0, KEY_UP),
+	KEYVAL(3, 1, KEY_3),
+	KEYVAL(3, 2, KEY_2),
+	KEYVAL(3, 3, KEY_1),
+};
+
+static struct bfin_kpad_platform_data bf54x_kpad_data = {
+	.rows			= 4,
+	.cols			= 4,
+	.keymap 		= bf548_keymap,
+	.keymapsize 		= ARRAY_SIZE(bf548_keymap),
+	.debounce_time		= 5000,	/* ns (5ms) */
+	.coldrive_time		= 1000, /* ns (1ms) */
+	.keyup_test_interval	= 50, /* ms (50ms) */
+};
+
+static struct resource bf54x_kpad_resources[] = {
+	{
+		.start = IRQ_KEY,
+		.end = IRQ_KEY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_kpad_device = {
+	.name		= "bf54x-keys",
+	.id		= -1,
+	.num_resources 	= ARRAY_SIZE(bf54x_kpad_resources),
+	.resource 	= bf54x_kpad_resources,
+	.dev		= {
+		.platform_data = &bf54x_kpad_data,
+	},
+};
+#endif
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
@@ -94,6 +179,248 @@ static struct platform_device bfin_uart_device = {
 };
 #endif
 
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+static struct resource smsc911x_resources[] = {
+	{
+		.name = "smsc911x-memory",
+		.start = 0x24000000,
+		.end = 0x24000000 + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_PE8,
+		.end = IRQ_PE8,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+static struct platform_device smsc911x_device = {
+	.name = "smsc911x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smsc911x_resources),
+	.resource = smsc911x_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+static struct resource bf54x_hcd_resources[] = {
+	{
+		.start = 0xFFC03C00,
+		.end = 0xFFC040FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bf54x_hcd = {
+	.name = "bf54x-hcd",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_hcd_resources),
+	.resource = bf54x_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+static struct resource bfin_atapi_resources[] = {
+	{
+		.start = 0xFFC03800,
+		.end = 0xFFC0386F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_ATAPI_ERR,
+		.end = IRQ_ATAPI_ERR,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_atapi_device = {
+	.name = "bf54x-atapi",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_atapi_resources),
+	.resource = bfin_atapi_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+static struct mtd_partition partition_info[] = {
+	{
+		.name = "Linux Kernel",
+		.offset = 0,
+		.size = 4 * SIZE_1M,
+	},
+	{
+		.name = "File System",
+		.offset = 4 * SIZE_1M,
+		.size = (256 - 4) * SIZE_1M,
+	},
+};
+
+static struct bf54x_nand_platform bf54x_nand_platform = {
+	.page_size = NFC_PG_SIZE_256,
+	.data_width = NFC_NWIDTH_8,
+	.partitions = partition_info,
+	.nr_partitions = ARRAY_SIZE(partition_info),
+	.rd_dly = 3,
+	.wr_dly = 3,
+};
+
+static struct resource bf54x_nand_resources[] = {
+	{
+		.start = 0xFFC03B00,
+		.end = 0xFFC03B4F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = CH_NFC,
+		.end = CH_NFC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf54x_nand_device = {
+	.name = "bf54x-nand",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf54x_nand_resources),
+	.resource = bf54x_nand_resources,
+	.dev = {
+		.platform_data = &bf54x_nand_platform,
+	},
+};
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+/* SPI flash chip (m25p16) */
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00030000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel",
+		.size = 0x1d0000,
+		.offset = 0x30000
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p16",
+};
+
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+	.cs_change_per_word = 0,
+};
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
+	.cs_change_per_word = 1,
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static const struct ad7877_platform_data bfin_ad7877_ts_info = {
+	.model			= 7877,
+	.vref_delay_usecs	= 50,	/* internal, no capacitor */
+	.x_plate_ohms		= 419,
+	.y_plate_ohms		= 486,
+	.pressure_max		= 1000,
+	.pressure_min		= 0,
+	.stopacq_polarity 	= 1,
+	.first_conversion_delay = 3,
+	.acquisition_time 	= 1,
+	.averaging 		= 1,
+	.pen_down_acc_interval 	= 1,
+};
+#endif
+
+static struct spi_board_info bf54x_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) \
+	|| defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* SPI_SSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
+{
+	.modalias		= "ad7877",
+	.platform_data		= &bfin_ad7877_ts_info,
+	.irq			= IRQ_PJ11,
+	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
+	.bus_num		= 1,
+	.chip_select  		= 2,
+	.controller_data = &spi_ad7877_chip_info,
+},
+#endif
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = CH_SPI0,
+		.end   = CH_SPI0,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bf54x_spi_master_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+static struct platform_device bf54x_spi_master_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = 0xFFC01400,
+		.end   = 0xFFC014FF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI0,
+		.end   = IRQ_TWI0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi0_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
@@ -102,12 +429,50 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
+
+#if defined(CONFIG_FB_BF54X_LQ043) || defined(CONFIG_FB_BF54X_LQ043_MODULE)
+	&bf54x_lq043_device,
+#endif
+
+#if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
+	&smsc911x_device,
+#endif
+
+#if defined(CONFIG_USB_BF54x_HCD) || defined(CONFIG_USB_BF54x_HCD_MODULE)
+	&bf54x_hcd,
+#endif
+
+#if defined(CONFIG_PATA_BF54X) || defined(CONFIG_PATA_BF54X_MODULE)
+	&bfin_atapi_device,
+#endif
+
+#if defined(CONFIG_MTD_NAND_BF54X) || defined(CONFIG_MTD_NAND_BF54X_MODULE)
+	&bf54x_nand_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bf54x_spi_master_device,
+#endif
+
+#if defined(CONFIG_KEYBOARD_BFIN) || defined(CONFIG_KEYBOARD_BFIN_MODULE)
+	&bf54x_kpad_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi0_device,
+#endif
 };
 
 static int __init stamp_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bf54x_spi_board_info,
+			ARRAY_SIZE(bf54x_spi_board_info));
+#endif
+
 	return 0;
 }
 
diff --git a/arch/blackfin/mach-bf548/gpio.c b/arch/blackfin/mach-bf548/gpio.c
index 0da5f00..f3b9dea 100644
--- a/arch/blackfin/mach-bf548/gpio.c
+++ b/arch/blackfin/mach-bf548/gpio.c
@@ -49,6 +49,9 @@ static struct gpio_port_t *gpio_array[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 
 static unsigned short reserved_gpio_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
 static unsigned short reserved_peri_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+char *str_ident = NULL;
+
+#define RESOURCE_LABEL_SIZE 16
 
 inline int check_gpio(unsigned short gpio)
 {
@@ -70,7 +73,6 @@ inline void portmux_setup(unsigned short portno, unsigned short function)
 	pmux |= (function & 0x3) << (2 * gpio_sub_n(portno));
 
 	gpio_array[gpio_bank(portno)]->port_mux = pmux;
-
 }
 
 inline u16 get_portmux(unsigned short portno)
@@ -80,16 +82,11 @@ inline u16 get_portmux(unsigned short portno)
 	pmux = gpio_array[gpio_bank(portno)]->port_mux;
 
 	return (pmux >> (2 * gpio_sub_n(portno)) & 0x3);
-
 }
 
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
 	if (usage == GPIO_USAGE) {
-		if (gpio_array[gpio_bank(gpio)]->port_fer & gpio_bit(gpio))
-			printk(KERN_WARNING
-			       "bfin-gpio: Possible Conflict with Peripheral "
-			       "usage and GPIO %d detected!\n", gpio);
 		gpio_array[gpio_bank(gpio)]->port_fer &= ~gpio_bit(gpio);
 	} else
 		gpio_array[gpio_bank(gpio)]->port_fer |= gpio_bit(gpio);
@@ -98,6 +95,11 @@ static void port_setup(unsigned short gpio, unsigned short usage)
 
 static int __init bfin_gpio_init(void)
 {
+
+	str_ident = kzalloc(RESOURCE_LABEL_SIZE * 256, GFP_KERNEL);
+	if (!str_ident)
+		return -ENOMEM;
+
 	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
 	return 0;
@@ -105,11 +107,47 @@ static int __init bfin_gpio_init(void)
 
 arch_initcall(bfin_gpio_init);
 
+static void set_label(unsigned short ident, const char *label)
+{
+
+	if (label && str_ident) {
+		strncpy(str_ident + ident * RESOURCE_LABEL_SIZE, label,
+			 RESOURCE_LABEL_SIZE);
+		str_ident[ident * RESOURCE_LABEL_SIZE +
+			 RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(unsigned short ident)
+{
+	if (!str_ident)
+		return "UNKNOWN";
+
+	return (str_ident[ident * RESOURCE_LABEL_SIZE] ?
+		(str_ident + ident * RESOURCE_LABEL_SIZE) : "UNKNOWN");
+}
+
+static int cmp_label(unsigned short ident, const char *label)
+{
+	if (label && str_ident)
+		return strncmp(str_ident + ident * RESOURCE_LABEL_SIZE,
+				 label, strlen(label));
+	else
+		return -EINVAL;
+}
+
 int peripheral_request(unsigned short per, const char *label)
 {
 	unsigned long flags;
 	unsigned short ident = P_IDENT(per);
 
+	/*
+	 * Don't cares are pins with only one dedicated function
+	 */
+
+	if (per & P_DONTCARE)
+		return 0;
+
 	if (!(per & P_DEFINED))
 		return -ENODEV;
 
@@ -120,8 +158,8 @@ int peripheral_request(unsigned short per, const char *label)
 
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
-		       "%s: Peripheral %d is already reserved as GPIO!\n",
-		       __FUNCTION__, per);
+		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
+		       __FUNCTION__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -131,22 +169,38 @@ int peripheral_request(unsigned short per, const char *label)
 
 		u16 funct = get_portmux(ident);
 
+	/*
+	 * Pin functions like AMC address strobes my
+	 * be requested and used by several drivers
+	 */
+
 		if (!((per & P_MAYSHARE) && (funct == P_FUNCT2MUX(per)))) {
+
+		/*
+		 * Allow that the identical pin function can
+		 * be requested from the same driver twice
+		 */
+
+		if (cmp_label(ident, label) == 0)
+			goto anyway;
+
 			printk(KERN_ERR
-			       "%s: Peripheral %d is already reserved!\n",
-			       __FUNCTION__, per);
+			       "%s: Peripheral %d function %d is already reserved by %s !\n",
+			       __FUNCTION__, ident, P_FUNCT2MUX(per), get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
 			return -EBUSY;
 		}
 	}
 
+anyway:
 	reserved_peri_map[gpio_bank(ident)] |= gpio_bit(ident);
 
 	portmux_setup(ident, P_FUNCT2MUX(per));
 	port_setup(ident, PERIPHERAL_USAGE);
 
 	local_irq_restore(flags);
+	set_label(ident, label);
 
 	return 0;
 }
@@ -154,16 +208,22 @@ EXPORT_SYMBOL(peripheral_request);
 
 int peripheral_request_list(unsigned short per[], const char *label)
 {
-
 	u16 cnt;
 	int ret;
 
 	for (cnt = 0; per[cnt] != 0; cnt++) {
+
 		ret = peripheral_request(per[cnt], label);
-		if (ret < 0)
-			return ret;
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
 	}
 
+
 	return 0;
 }
 EXPORT_SYMBOL(peripheral_request_list);
@@ -173,6 +233,9 @@ void peripheral_free(unsigned short per)
 	unsigned long flags;
 	unsigned short ident = P_IDENT(per);
 
+	if (per & P_DONTCARE)
+		return;
+
 	if (!(per & P_DEFINED))
 		return;
 
@@ -182,8 +245,6 @@ void peripheral_free(unsigned short per)
 	local_irq_save(flags);
 
 	if (unlikely(!(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident)))) {
-		printk(KERN_ERR "bfin-gpio: Peripheral %d wasn't reserved!\n", per);
-		dump_stack();
 		local_irq_restore(flags);
 		return;
 	}
@@ -234,7 +295,8 @@ int gpio_request(unsigned short gpio, const char *label)
 	local_irq_save(flags);
 
 	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved!\n", gpio);
+		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved by %s !\n",
+			 gpio, get_label(gpio));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -242,7 +304,8 @@ int gpio_request(unsigned short gpio, const char *label)
 
 	if (unlikely(reserved_peri_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		printk(KERN_ERR
-		       "bfin-gpio: GPIO %d is already reserved as Peripheral!\n", gpio);
+		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
+		       gpio, get_label(gpio));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -253,6 +316,7 @@ int gpio_request(unsigned short gpio, const char *label)
 	local_irq_restore(flags);
 
 	port_setup(gpio, GPIO_USAGE);
+	set_label(gpio, label);
 
 	return 0;
 }
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 660f881..d5d9e57 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -221,7 +221,7 @@ static unsigned int bf561_gpio_irq_startup(unsigned int irq)
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 
@@ -261,7 +261,7 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
 
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 4708023..505b948 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -343,7 +343,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PF0;
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -377,7 +377,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
@@ -587,7 +587,7 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	}
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -627,7 +627,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 48587c2..05a5b3f 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1,17 +1,20 @@
 /*
- * File:         drivers/spi/bfin5xx_spi.c
- * Based on:     N/A
- * Author:       Luke Yang (Analog Devices Inc.)
+ * File:	drivers/spi/bfin5xx_spi.c
+ * Maintainer:
+ * 		Bryan Wu <bryan.wu@analog.com>
+ * Original Author:
+ * 		Luke Yang (Analog Devices Inc.)
  *
- * Created:      March. 10th 2006
- * Description:  SPI controller driver for Blackfin 5xx
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * Created:	March. 10th 2006
+ * Description:	SPI controller driver for Blackfin BF5xx
+ * Bugs:	Enter bugs at http://blackfin.uclinux.org/
  *
  * Modified:
  *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
  *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
+ *      July  17, 2007  add support for BF54x SPI0 controller (Bryan Wu)
  *
- * Copyright 2004-2006 Analog Devices Inc.
+ * Copyright 2004-2007 Analog Devices Inc.
  *
  * This program is free software ;  you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,28 +34,27 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/irq.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
-#include <linux/delay.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/delay.h>
 #include <asm/dma.h>
-
+#include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
 
-MODULE_AUTHOR("Luke Yang");
-MODULE_DESCRIPTION("Blackfin 5xx SPI Contoller");
+MODULE_AUTHOR("Bryan Wu, Luke Yang");
+MODULE_DESCRIPTION("Blackfin BF5xx SPI Contoller Driver");
 MODULE_LICENSE("GPL");
 
+#define DRV_NAME	"bfin-spi-master"
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
 #define DEFINE_SPI_REG(reg, off) \
@@ -125,6 +127,7 @@ struct chip_data {
 	u16 flag;
 
 	u8 chip_select_num;
+	u8 chip_select_requested;
 	u8 n_bytes;
 	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
@@ -189,53 +192,37 @@ static void restore_state(struct driver_data *drv_data)
 	bfin_spi_disable(drv_data);
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
-#if defined(CONFIG_BF534) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
-	dev_dbg(&drv_data->pdev->dev, 
-		"chip select number is %d\n", chip->chip_select_num);
-	
-	switch (chip->chip_select_num) {
-	case 1:
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3c00);
-		SSYNC();
-		break;
+	if (!chip->chip_select_requested) {
 
-	case 2:
-	case 3:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJSE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
-
-	case 4:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS4E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3840);
-		SSYNC();
-		break;
-
-	case 5:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS5E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3820);
-		SSYNC();
-		break;
+		dev_dbg(&drv_data->pdev->dev,
+		"chip select number is %d\n", chip->chip_select_num);
 
-	case 6:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS6E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3810);
-		SSYNC();
-		break;
+		switch (chip->chip_select_num) {
+		case 1:
+			peripheral_request(P_SPI0_SSEL1, DRV_NAME);
+			break;
+		case 2:
+			peripheral_request(P_SPI0_SSEL2, DRV_NAME);
+			break;
+		case 3:
+			peripheral_request(P_SPI0_SSEL3, DRV_NAME);
+			break;
+		case 4:
+			peripheral_request(P_SPI0_SSEL4, DRV_NAME);
+			break;
+		case 5:
+			peripheral_request(P_SPI0_SSEL5, DRV_NAME);
+			break;
+		case 6:
+			peripheral_request(P_SPI0_SSEL6, DRV_NAME);
+			break;
+		case 7:
+			peripheral_request(P_SPI0_SSEL7, DRV_NAME);
+			break;
+		}
 
-	case 7:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJCE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
+		chip->chip_select_requested = 1;
 	}
-#endif
 
 	/* Load the registers */
 	write_CTRL(chip->ctl_reg);
@@ -278,7 +265,7 @@ static void null_reader(struct driver_data *drv_data)
 
 static void u8_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -317,7 +304,7 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 static void u8_reader(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT());
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
@@ -404,7 +391,7 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 static void u16_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT());
 
 	while (drv_data->tx < drv_data->tx_end) {
@@ -817,7 +804,7 @@ static void pump_transfers(unsigned long data)
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
@@ -835,7 +822,7 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -850,7 +837,7 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_READ | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -862,7 +849,7 @@ static void pump_transfers(unsigned long data)
 		}
 
 		if (!tranf_success) {
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write error!\n");
 			message->state = ERROR_STATE;
 		} else {
@@ -917,8 +904,8 @@ static void pump_messages(struct work_struct *work)
 		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
    		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
    		drv_data->cur_chip->ctl_reg);
-	
-	dev_dbg(&drv_data->pdev->dev, 
+
+	dev_dbg(&drv_data->pdev->dev,
 		"the first transfer len is %d\n",
 		drv_data->cur_transfer->len);
 
@@ -1178,6 +1165,22 @@ static inline int destroy_queue(struct driver_data *drv_data)
 	return 0;
 }
 
+static int setup_pin_mux(int action)
+{
+
+	u16 pin_req[] = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0};
+
+	if (action) {
+		if (peripheral_request_list(pin_req, DRV_NAME)) {
+			return -EFAULT;
+		}
+	} else {
+		peripheral_free_list(pin_req);
+	}
+
+	return 0;
+}
+
 static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1194,6 +1197,12 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can not alloc spi_master\n");
 		return -ENOMEM;
 	}
+
+	if (setup_pin_mux(1)) {
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error;
+	}
+
 	drv_data = spi_master_get_devdata(master);
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
@@ -1227,9 +1236,11 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "controller probe successfully\n");
 	return status;
 
-      out_error_queue_alloc:
+out_error_queue_alloc:
 	destroy_queue(drv_data);
+out_error:
 	spi_master_put(master);
+
 	return status;
 }
 
@@ -1259,6 +1270,8 @@ static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
+	setup_pin_mux(0);
+
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/asm-blackfin/bfin5xx_spi.h b/include/asm-blackfin/bfin5xx_spi.h
index 95c1c95..8b211ff 100644
--- a/include/asm-blackfin/bfin5xx_spi.h
+++ b/include/asm-blackfin/bfin5xx_spi.h
@@ -150,6 +150,12 @@
 #define CFG_SPI_CS6VALUE    6
 #define CFG_SPI_CS7VALUE    7
 
+#if defined(CONFIG_BF54x)
+#define CH_SPI			CH_SPI0
+#define bfin_read_SPI_STAT	bfin_read_SPI0_STAT
+#endif
+
+
 /* device.platform_data for SSP controller devices */
 struct bfin5xx_spi_master {
 	u16 num_chipselect;
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 7480cfa..dd203cd 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -144,6 +144,24 @@
 
 #ifdef BF533_FAMILY
 #define MAX_BLACKFIN_GPIOS 16
+
+#define	GPIO_PF0	0
+#define	GPIO_PF1	1
+#define	GPIO_PF2	2
+#define	GPIO_PF3	3
+#define	GPIO_PF4	4
+#define	GPIO_PF5	5
+#define	GPIO_PF6	6
+#define	GPIO_PF7	7
+#define	GPIO_PF8	8
+#define	GPIO_PF9	9
+#define	GPIO_PF10	10
+#define	GPIO_PF11	11
+#define	GPIO_PF12	12
+#define	GPIO_PF13	13
+#define	GPIO_PF14	14
+#define	GPIO_PF15	15
+
 #endif
 
 #ifdef BF537_FAMILY
@@ -421,6 +439,19 @@ unsigned short gpio_get_value(unsigned short gpio);
 void gpio_direction_input(unsigned short gpio);
 void gpio_direction_output(unsigned short gpio);
 
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+#include <asm/irq.h>
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return (gpio + GPIO_IRQ_BASE);
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return (irq - GPIO_IRQ_BASE);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ARCH_BLACKFIN_GPIO_H__ */
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf533/blackfin.h b/include/asm-blackfin/mach-bf533/blackfin.h
index e438449..f3b240a 100644
--- a/include/asm-blackfin/mach-bf533/blackfin.h
+++ b/include/asm-blackfin/mach-bf533/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF532.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF532.h"
 #endif
 
diff --git a/include/asm-blackfin/mach-bf533/irq.h b/include/asm-blackfin/mach-bf533/irq.h
index 9879e68..452fb82 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -128,6 +128,8 @@ Core        Emulation               **
 #define IRQ_PF14		47
 #define IRQ_PF15		48
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define	NR_IRQS		(IRQ_PF15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf533/portmux.h b/include/asm-blackfin/mach-bf533/portmux.h
index b88d7a0..137f488 100644
--- a/include/asm-blackfin/mach-bf533/portmux.h
+++ b/include/asm-blackfin/mach-bf533/portmux.h
@@ -42,7 +42,7 @@
 #define P_SPORT0_DRPRI	(P_DONTCARE)
 
 #define P_SPI0_MOSI	(P_DONTCARE)
-#define P_SPI0_MIS0	(P_DONTCARE)
+#define P_SPI0_MISO	(P_DONTCARE)
 #define P_SPI0_SCK	(P_DONTCARE)
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(GPIO_PF7))
 #define P_SPI0_SSEL6	(P_DEFINED | P_IDENT(GPIO_PF6))
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 8f5d9c4..6fb328f 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		2
 
@@ -122,25 +123,29 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
-	unsigned short val;
-	val = bfin_read16(BFIN_PORT_MUX);
-	val &= ~(PFDE | PFTE);
-	bfin_write16(BFIN_PORT_MUX, val);
 
-	val = bfin_read16(PORTF_FER);
-	val |= 0xF;
-	bfin_write16(PORTF_FER, val);
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+#endif
 
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf537/blackfin.h b/include/asm-blackfin/mach-bf537/blackfin.h
index bbd9705..f196588 100644
--- a/include/asm-blackfin/mach-bf537/blackfin.h
+++ b/include/asm-blackfin/mach-bf537/blackfin.h
@@ -43,7 +43,7 @@
 #include "defBF537.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF534.h"
 
 /* UART 0*/
diff --git a/include/asm-blackfin/mach-bf537/irq.h b/include/asm-blackfin/mach-bf537/irq.h
index 8af2a83..36c44bc 100644
--- a/include/asm-blackfin/mach-bf537/irq.h
+++ b/include/asm-blackfin/mach-bf537/irq.h
@@ -160,6 +160,8 @@ Core        Emulation               **
 #define IRQ_PH14        96
 #define IRQ_PH15        97
 
+#define GPIO_IRQ_BASE	IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PH15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf537/portmux.h b/include/asm-blackfin/mach-bf537/portmux.h
index 23e13c5..ae6c53b 100644
--- a/include/asm-blackfin/mach-bf537/portmux.h
+++ b/include/asm-blackfin/mach-bf537/portmux.h
@@ -106,4 +106,37 @@
 #define P_SPI0_SSEL2	(P_DEFINED | P_IDENT(PORT_PJ11) | P_FUNCT(1))
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(PORT_PJ5) | P_FUNCT(2))
 
-#endif /* _MACH_PORTMUX_H_ */
+#define P_MII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxD2, \
+	P_MII0_ETxD3, \
+	P_MII0_ETxEN, \
+	P_MII0_TxCLK, \
+	P_MII0_PHYINT, \
+	P_MII0_COL, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxD2, \
+	P_MII0_ERxD3, \
+	P_MII0_ERxDV, \
+	P_MII0_ERxCLK, \
+	P_MII0_ERxER, \
+	P_MII0_CRS, \
+	P_MDC, \
+	P_MDIO, 0}
+
+
+#define P_RMII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxEN, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxER, \
+	P_RMII0_REF_CLK, \
+	P_RMII0_MDINT, \
+	P_RMII0_CRS_DV, \
+	P_MDC, \
+	P_MDIO, 0}
+#endif			        	/* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 2f4afc9..f21a162 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		4
 
@@ -143,50 +144,48 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 #ifdef CONFIG_SERIAL_BFIN_UART0
-	/* Enable UART0 RX and TX on pin 7 & 8 of PORT E */
-	bfin_write_PORTE_FER(0x180 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(0x3C000 | bfin_read_PORTE_MUX());
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART1
-	/* Enable UART1 RX and TX on pin 0 & 1 of PORT H */
-	bfin_write_PORTH_FER(0x3 | bfin_read_PORTH_FER());
-	bfin_write_PORTH_MUX(~0xF & bfin_read_PORTH_MUX());
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART1_CTSRTS
-	/* Enable UART1 RTS and CTS on pin 9 & 10 of PORT E */
-	bfin_write_PORTE_FER(0x600 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(~0x3C0000 & bfin_read_PORTE_MUX());
+	peripheral_request(P_UART1_RTS, DRIVER_NAME);
+	peripheral_request(P_UART1_CTS DRIVER_NAME);
 #endif
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART2
-	/* Enable UART2 RX and TX on pin 4 & 5 of PORT B */
-	bfin_write_PORTB_FER(0x30 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF00 & bfin_read_PORTB_MUX());
+	peripheral_request(P_UART2_TX, DRIVER_NAME);
+	peripheral_request(P_UART2_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART3
-	/* Enable UART3 RX and TX on pin 6 & 7 of PORT B */
-	bfin_write_PORTB_FER(0xC0 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF000 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_TX, DRIVER_NAME);
+	peripheral_request(P_UART3_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART3_CTSRTS
-	/* Enable UART3 RTS and CTS on pin 2 & 3 of PORT B */
-	bfin_write_PORTB_FER(0xC | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF0 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_RTS, DRIVER_NAME);
+	peripheral_request(P_UART3_CTS DRIVER_NAME);
 #endif
 #endif
 	SSYNC();
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf548/blackfin.h b/include/asm-blackfin/mach-bf548/blackfin.h
index 791218f..19e84dd 100644
--- a/include/asm-blackfin/mach-bf548/blackfin.h
+++ b/include/asm-blackfin/mach-bf548/blackfin.h
@@ -54,7 +54,7 @@
 #include "defBF549.h"
 #endif
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #ifdef CONFIG_BF542
 #include "cdefBF542.h"
 #endif
diff --git a/include/asm-blackfin/mach-bf548/defBF54x_base.h b/include/asm-blackfin/mach-bf548/defBF54x_base.h
index 895ddd4..56f0a76 100644
--- a/include/asm-blackfin/mach-bf548/defBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/defBF54x_base.h
@@ -1637,8 +1637,25 @@
 #define                   RESTART  0x20       /* Work Unit Transitions */
 #define                    DI_SEL  0x40       /* Data Interrupt Timing Select */
 #define                     DI_EN  0x80       /* Data Interrupt Enable */
+
 #define                    NDSIZE  0xf00      /* Flex Descriptor Size */
+#define                  NDSIZE_0 0x0000      /* Next Descriptor Size = 0 (Stop/Autobuffer) */
+#define                  NDSIZE_1 0x0100      /* Next Descriptor Size = 1 */
+#define                  NDSIZE_2 0x0200      /* Next Descriptor Size = 2 */
+#define                  NDSIZE_3 0x0300      /* Next Descriptor Size = 3 */
+#define                  NDSIZE_4 0x0400      /* Next Descriptor Size = 4 */
+#define                  NDSIZE_5 0x0500      /* Next Descriptor Size = 5 */
+#define                  NDSIZE_6 0x0600      /* Next Descriptor Size = 6 */
+#define                  NDSIZE_7 0x0700      /* Next Descriptor Size = 7 */
+#define                  NDSIZE_8 0x0800      /* Next Descriptor Size = 8 */
+#define                  NDSIZE_9 0x0900      /* Next Descriptor Size = 9 */
+
 #define                   DMAFLOW  0xf000     /* Next Operation */
+#define              DMAFLOW_STOP  0x0000     /* Stop Mode */
+#define              DMAFLOW_AUTO  0x1000     /* Autobuffer Mode */
+#define             DMAFLOW_ARRAY  0x4000     /* Descriptor Array Mode */
+#define             DMAFLOW_SMALL  0x6000     /* Small Model Descriptor List Mode */
+#define             DMAFLOW_LARGE  0x7000     /* Large Model Descriptor List Mode */
 
 /* Bit masks for DMAx_IRQ_STATUS, MDMA_Sx_IRQ_STATUS, MDMA_Dx_IRQ_STATUS */
 
diff --git a/include/asm-blackfin/mach-bf548/gpio.h b/include/asm-blackfin/mach-bf548/gpio.h
index dbf66bc..cb8b0f1 100644
--- a/include/asm-blackfin/mach-bf548/gpio.h
+++ b/include/asm-blackfin/mach-bf548/gpio.h
@@ -209,8 +209,3 @@ struct gpio_port_t {
 	unsigned short dummy7;
 	unsigned int port_mux;
 };
-
-int gpio_request(unsigned short gpio, const char *label);
-void peripheral_free(unsigned short per);
-int peripheral_request_list(unsigned short per[], const char *label);
-void peripheral_free_list(unsigned short per[]);
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
index e548d3c..21f06f7 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -337,6 +337,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_PJ14	BFIN_PJ_IRQ(14)		/* N/A */
 #define IRQ_PJ15	BFIN_PJ_IRQ(15)		/* N/A */
 
+#define GPIO_IRQ_BASE	IRQ_PA0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PJ15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf561/blackfin.h b/include/asm-blackfin/mach-bf561/blackfin.h
index 2537c84..562aee3 100644
--- a/include/asm-blackfin/mach-bf561/blackfin.h
+++ b/include/asm-blackfin/mach-bf561/blackfin.h
@@ -38,7 +38,7 @@
 #include "defBF561.h"
 #include "anomaly.h"
 
-#if !(defined(__ASSEMBLY__) || defined(ASSEMBLY))
+#if !defined(__ASSEMBLY__)
 #include "cdefBF561.h"
 #endif
 
diff --git a/include/asm-blackfin/mach-bf561/irq.h b/include/asm-blackfin/mach-bf561/irq.h
index a753ce7..1278992 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -289,6 +289,8 @@
 #define IRQ_PF46		119
 #define IRQ_PF47		120
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS			(IRQ_PF47 + 1)
 #else
diff --git a/include/asm-blackfin/portmux.h b/include/asm-blackfin/portmux.h
index 9d3681e..d1bcd91 100644
--- a/include/asm-blackfin/portmux.h
+++ b/include/asm-blackfin/portmux.h
@@ -14,6 +14,12 @@
 #define P_MAYSHARE	0x2000
 #define P_DONTCARE	0x1000
 
+
+int peripheral_request(unsigned short per, const char *label);
+void peripheral_free(unsigned short per);
+int peripheral_request_list(unsigned short per[], const char *label);
+void peripheral_free_list(unsigned short per[]);
+
 #include <asm/gpio.h>
 #include <asm/mach/portmux.h>
 
@@ -513,6 +519,22 @@
 #define P_SPI0_SSEL3 P_UNDEF
 #endif
 
+#ifndef P_SPI0_SSEL4
+#define P_SPI0_SSEL4 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL5
+#define P_SPI0_SSEL5 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL6
+#define P_SPI0_SSEL6 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL7
+#define P_SPI0_SSEL7 P_UNDEF
+#endif
+
 #ifndef P_UART0_TX
 #define P_UART0_TX P_UNDEF
 #endif

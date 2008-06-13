Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYFMJrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYFMJrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYFMJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:47:13 -0400
Received: from mail.atmel.fr ([81.80.104.162]:42390 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbYFMJrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:47:10 -0400
X-Greylist: delayed 4036 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 05:47:08 EDT
Message-ID: <4852324C.9000604@atmel.com>
Date: Fri, 13 Jun 2008 10:39:40 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
CC: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
       VILCHEZ Patrice <Patrice.VILCHEZ@atmel.com>,
       Justin Waters <justin.waters@timesys.com>
Subject: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s
 SOC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s SOC.

At91sam9g20 is an evolution of the at91sam9260 with a faster clock speed.
We created a new board for this device but based the chip support directly
on 9260 files with little updates.
Here is the chip page on Atmel website :
http://atmel.com/dyn/products/product_card.asp?part_id=4337

Signed-off-by: Sedji Gaouaou <sedji.gaouaou@atmel.com>
Signed-off-by: Justin Waters <justin.waters@timesys.com>
---
This patch is against rmk devel git tree.

 arch/arm/mach-at91/Kconfig               |   29 ++++-
 arch/arm/mach-at91/Makefile              |    4 +
 arch/arm/mach-at91/at91sam9260.c         |   16 ++
 arch/arm/mach-at91/at91sam9260_devices.c |   44 +++++--
 arch/arm/mach-at91/board-sam9g20ek.c     |  222 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/clock.c               |   19 ++-
 arch/arm/mach-at91/pm.c                  |    2 +-
 arch/arm/mm/Kconfig                      |    4 +-
 drivers/mmc/host/at91_mci.c              |    4 +-
 drivers/net/Kconfig                      |    2 +-
 drivers/usb/gadget/at91_udc.c            |    4 +-
 include/asm-arm/arch-at91/at91sam9260.h  |   11 ++
 include/asm-arm/arch-at91/board.h        |    2 +-
 include/asm-arm/arch-at91/cpu.h          |    7 +
 include/asm-arm/arch-at91/hardware.h     |    2 +-
 include/asm-arm/arch-at91/timex.h        |    5 +
 sound/soc/at91/at91-ssc.c                |    2 +-
 17 files changed, 348 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm/mach-at91/board-sam9g20ek.c

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index cae5c67..5bad6b9 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -30,6 +30,11 @@ config ARCH_AT91SAM9RL
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 
+config ARCH_AT91SAM9G20
+	bool "AT91SAM9G20"
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select GENERIC_TIME
@@ -239,6 +244,20 @@ endif
 
 # ----------------------------------------------------------
 
+if ARCH_AT91SAM9G20
+
+comment "AT91SAM9G20 Board Type"
+
+config MACH_AT91SAM9G20EK
+	bool "Atmel AT91SAM9G20-EK Evaluation Kit"
+	depends on ARCH_AT91SAM9G20
+	help
+	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit.
+
+endif
+
+# ----------------------------------------------------------
+
 if ARCH_AT91CAP9
 
 comment "AT91CAP9 Board Type"
@@ -274,13 +293,13 @@ comment "AT91 Board Options"
 
 config MTD_AT91_DATAFLASH_CARD
 	bool "Enable DataFlash Card support"
-	depends on (ARCH_AT91RM9200DK || MACH_AT91RM9200EK || MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK || MACH_SAM9_L9260 || MACH_ECBAT91)
+	depends on (ARCH_AT91RM9200DK || MACH_AT91RM9200EK || MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_ECBAT91 || MACH_SAM9_L9260 || MACH_AT91CAP9ADK)
 	help
 	  Enable support for the DataFlash card.
 
 config MTD_NAND_AT91_BUSWIDTH_16
 	bool "Enable 16-bit data bus interface to NAND flash"
-	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK)
+	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91CAP9ADK)
 	help
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).
@@ -329,15 +348,15 @@ config AT91_EARLY_USART2
 
 config AT91_EARLY_USART3
 	bool "USART3"
-	depends on (ARCH_AT91RM9200 || ARCH_AT91SAM9RL || ARCH_AT91SAM9260)
+	depends on (ARCH_AT91RM9200 || ARCH_AT91SAM9RL || ARCH_AT91SAM9260 || ARCH_AT91SAM9G20)
 
 config AT91_EARLY_USART4
 	bool "USART4"
-	depends on ARCH_AT91SAM9260
+	depends on ARCH_AT91SAM9260 || ARCH_AT91SAM9G20
 
 config AT91_EARLY_USART5
 	bool "USART5"
-	depends on ARCH_AT91SAM9260
+	depends on ARCH_AT91SAM9260 || ARCH_AT91SAM9G20
 
 endchoice
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 932d171..7d641f9 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_ARCH_AT91SAM9260)	+= at91sam9260.o at91sam926x_time.o at91sam9260_d
 obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261.o at91sam926x_time.o at91sam9261_devices.o
 obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_devices.o
 obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o
+obj-$(CONFIG_ARCH_AT91SAM9G20)	+= at91sam9260.o at91sam926x_time.o at91sam9260_devices.o
 obj-$(CONFIG_ARCH_AT91CAP9)	+= at91cap9.o at91sam926x_time.o at91cap9_devices.o
 obj-$(CONFIG_ARCH_AT91X40)	+= at91x40.o at91x40_time.o
 
@@ -49,6 +50,9 @@ obj-$(CONFIG_MACH_USB_A9263)	+= board-usb-a9263.o
 # AT91SAM9RL board-specific support
 obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
 
+# AT91SAM9G20 board-specific support
+obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
+
 # AT91CAP9 board-specific support
 obj-$(CONFIG_MACH_AT91CAP9ADK)	+= board-cap9adk.o
 
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index ee26550..380f12a 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -47,6 +47,20 @@ static struct map_desc at91sam9260_sram_desc[] __initdata = {
 	}
 };
 
+static struct map_desc at91sam9g20_sram_desc[] __initdata = {
+	{
+		.virtual	= AT91_IO_VIRT_BASE - AT91SAM9G20_SRAM0_SIZE,
+		.pfn		= __phys_to_pfn(AT91SAM9G20_SRAM0_BASE),
+		.length		= AT91SAM9G20_SRAM0_SIZE,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= AT91_IO_VIRT_BASE - AT91SAM9G20_SRAM0_SIZE - AT91SAM9G20_SRAM1_SIZE,
+		.pfn		= __phys_to_pfn(AT91SAM9G20_SRAM1_BASE),
+		.length		= AT91SAM9G20_SRAM1_SIZE,
+		.type		= MT_DEVICE,
+	}
+};
+
 static struct map_desc at91sam9xe_sram_desc[] __initdata = {
 	{
 		.pfn		= __phys_to_pfn(AT91SAM9XE_SRAM_BASE),
@@ -307,6 +321,8 @@ void __init at91sam9260_initialize(unsigned long main_clock)
 
 	if (cpu_is_at91sam9xe())
 		at91sam9xe_initialize();
+	else if (cpu_is_at91sam9g20())
+		iotable_init(at91sam9g20_sram_desc, ARRAY_SIZE(at91sam9g20_sram_desc));
 	else
 		iotable_init(at91sam9260_sram_desc, ARRAY_SIZE(at91sam9260_sram_desc));
 
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 393a32a..ddcd0f7 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -18,6 +18,7 @@
 
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
+#include <asm/arch/cpu.h>
 #include <asm/arch/at91sam9260.h>
 #include <asm/arch/at91sam9260_matrix.h>
 #include <asm/arch/at91sam9_smc.h>
@@ -320,20 +321,41 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	csa = at91_sys_read(AT91_MATRIX_EBICSA);
 	at91_sys_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
 
-	/* set the bus interface characteristics */
-	at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(0) | AT91_SMC_NCS_WRSETUP_(0)
-			| AT91_SMC_NRDSETUP_(0) | AT91_SMC_NCS_RDSETUP_(0));
+	if (cpu_is_at91sam9260()){
+		/* Timing for sam9260 */
+		/* set the bus interface characteristics */
+		at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(1) | AT91_SMC_NCS_WRSETUP_(0)
+				| AT91_SMC_NRDSETUP_(1) | AT91_SMC_NCS_RDSETUP_(0));
 
-	at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
-			| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
+		at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(3) | AT91_SMC_NCS_WRPULSE_(3)
+				| AT91_SMC_NRDPULSE_(3) | AT91_SMC_NCS_RDPULSE_(3));
 
-	at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
+		at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(5) | AT91_SMC_NRDCYCLE_(5));
 
-	if (data->bus_width_16)
-		mode = AT91_SMC_DBW_16;
-	else
-		mode = AT91_SMC_DBW_8;
-	at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
+		if (data->bus_width_16)
+			mode = AT91_SMC_DBW_16;
+		else
+			mode = AT91_SMC_DBW_8;
+		at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(2));
+	}
+
+	if (cpu_is_at91sam9g20()){
+		/* Timing for sam9g20 */
+		/* set the bus interface characteristics */
+		at91_sys_write(AT91_SMC_SETUP(3), AT91_SMC_NWESETUP_(2) | AT91_SMC_NCS_WRSETUP_(0)
+				| AT91_SMC_NRDSETUP_(2) | AT91_SMC_NCS_RDSETUP_(0));
+
+		at91_sys_write(AT91_SMC_PULSE(3), AT91_SMC_NWEPULSE_(4) | AT91_SMC_NCS_WRPULSE_(4)
+				| AT91_SMC_NRDPULSE_(4) | AT91_SMC_NCS_RDPULSE_(4));
+
+		at91_sys_write(AT91_SMC_CYCLE(3), AT91_SMC_NWECYCLE_(7) | AT91_SMC_NRDCYCLE_(7));
+
+		if (data->bus_width_16)
+			mode = AT91_SMC_DBW_16;
+		else
+			mode = AT91_SMC_DBW_8;
+		at91_sys_write(AT91_SMC_MODE(3), mode | AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_TDF_(3));
+	}
 
 	/* enable pin */
 	if (data->enable_pin)
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
new file mode 100644
index 0000000..42c845e
--- /dev/null
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -0,0 +1,222 @@
+/*
+ * linux/arch/arm/mach-at91/board-sam9g20ek.c
+ *
+ *  Copyright (C) 2005 SAN People
+ *  Copyright (C) 2008 Atmel
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/at73c213.h>
+#include <linux/clk.h>
+
+#include <asm/hardware.h>
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/irq.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include <asm/arch/board.h>
+#include <asm/arch/gpio.h>
+
+#include "generic.h"
+
+
+static void __init ek_map_io(void)
+{
+	/* Initialize processor: 18.432 MHz crystal */
+	at91sam9260_initialize(18432000);
+
+	/* DGBU on ttyS0. (Rx & Tx only) */
+	at91_register_uart(0, 0, 0);
+
+	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
+	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
+			   | ATMEL_UART_DTR | ATMEL_UART_DSR | ATMEL_UART_DCD
+			   | ATMEL_UART_RI);
+
+	/* USART1 on ttyS2. (Rx, Tx, RTS, CTS) */
+	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_CTS | ATMEL_UART_RTS);
+
+	/* set serial console to ttyS0 (ie, DBGU) */
+	at91_set_serial_console(0);
+}
+
+static void __init ek_init_irq(void)
+{
+	at91sam9260_init_interrupts(NULL);
+}
+
+
+/*
+ * USB Host port
+ */
+static struct at91_usbh_data __initdata ek_usbh_data = {
+	.ports		= 2,
+};
+
+/*
+ * USB Device port
+ */
+static struct at91_udc_data __initdata ek_udc_data = {
+	.vbus_pin	= AT91_PIN_PC5,
+	.pullup_pin	= 0,		/* pull-up driven by UDC */
+};
+
+
+/*
+ * SPI devices.
+ */
+static struct spi_board_info ek_spi_devices[] = {
+#if !defined(CONFIG_MMC_AT91)
+	{	/* DataFlash chip */
+		.modalias	= "mtd_dataflash",
+		.chip_select	= 1,
+		.max_speed_hz	= 15 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+#if defined(CONFIG_MTD_AT91_DATAFLASH_CARD)
+	{	/* DataFlash card */
+		.modalias	= "mtd_dataflash",
+		.chip_select	= 0,
+		.max_speed_hz	= 15 * 1000 * 1000,
+		.bus_num	= 0,
+	},
+#endif
+#endif
+};
+
+
+/*
+ * MACB Ethernet device
+ */
+static struct at91_eth_data __initdata ek_macb_data = {
+	.phy_irq_pin	= AT91_PIN_PA7,
+	.is_rmii	= 1,
+};
+
+
+/*
+ * NAND flash
+ */
+static struct mtd_partition __initdata ek_nand_partition[] = {
+        {
+                .name   = "Bootstrap",
+                .offset = 0,
+                .size   = 4 * 1024 * 1024,
+	},
+	{
+		.name	= "Partition 1",
+		.offset	= 4 * 1024 * 1024,
+		.size	= 60 * 1024 * 1024,
+	},
+	{
+		.name	= "Partition 2",
+		.offset	= 64 * 1024 * 1024,
+		.size	= MTDPART_SIZ_FULL,
+	},
+};
+
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
+{
+	*num_partitions = ARRAY_SIZE(ek_nand_partition);
+	return ek_nand_partition;
+}
+
+static struct at91_nand_data __initdata ek_nand_data = {
+	.ale		= 21,
+	.cle		= 22,
+//	.det_pin	= ... not connected
+	.rdy_pin	= AT91_PIN_PC13,
+	.enable_pin	= AT91_PIN_PC14,
+	.partition_info	= nand_partitions,
+#if defined(CONFIG_MTD_NAND_AT91_BUSWIDTH_16)
+	.bus_width_16	= 1,
+#else
+	.bus_width_16	= 0,
+#endif
+};
+
+
+/*
+ * MCI (SD/MMC)
+ */
+static struct at91_mmc_data __initdata ek_mmc_data = {
+	.slot_b		= 1,
+	.wire4		= 1,
+//	.det_pin	= ... not connected
+//	.wp_pin		= ... not connected
+//	.vcc_pin	= ... not connected
+};
+
+
+/*
+ * LEDs
+ */
+static struct gpio_led ek_leds[] = {
+	{	/* "bottom" led, green, userled1 to be defined */
+		.name			= "ds5",
+		.gpio			= AT91_PIN_PA6,
+		.active_low		= 1,
+		.default_trigger	= "none",
+	},
+	{	/* "power" led, yellow */
+		.name			= "ds1",
+		.gpio			= AT91_PIN_PA9,
+		.default_trigger	= "heartbeat",
+	}
+};
+
+static void __init ek_board_init(void)
+{
+	/* Serial */
+	at91_add_device_serial();
+	/* USB Host */
+	at91_add_device_usbh(&ek_usbh_data);
+	/* USB Device */
+	at91_add_device_udc(&ek_udc_data);
+	/* SPI */
+	at91_add_device_spi(ek_spi_devices, ARRAY_SIZE(ek_spi_devices));
+	/* NAND */
+	at91_add_device_nand(&ek_nand_data);
+	/* Ethernet */
+	at91_add_device_eth(&ek_macb_data);
+	/* MMC */
+	at91_add_device_mmc(0, &ek_mmc_data);
+	/* I2C */
+	at91_add_device_i2c(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
+}
+
+MACHINE_START(AT91SAM9G20EK, "Atmel AT91SAM9G20-EK")
+	/* Maintainer: Atmel */
+	.phys_io	= AT91_BASE_SYS,
+	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
+	.boot_params	= AT91_SDRAM_BASE + 0x100,
+	.timer		= &at91sam926x_timer,
+	.map_io		= ek_map_io,
+	.init_irq	= ek_init_irq,
+	.init_machine	= ek_board_init,
+MACHINE_END
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index e8ce8f0..92bb30e 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -515,14 +515,19 @@ static unsigned __init at91_pll_calc(unsigned main_freq, unsigned out_freq)
 		/*
 		 * PLL input between 1MHz and 32MHz per spec, but lower
 		 * frequences seem necessary in some cases so allow 100K.
+		 * Warning: some newer products need 2MHz min.
 		 */
 		input = main_freq / i;
+		if (cpu_is_at91sam9g20() && input < 2000000)
+			continue;
 		if (input < 100000)
 			continue;
 		if (input > 32000000)
 			continue;
 
 		mul1 = out_freq / input;
+		if (cpu_is_at91sam9g20() && mul > 63)
+			continue;
 		if (mul1 > 2048)
 			continue;
 		if (mul1 < 2)
@@ -582,7 +587,8 @@ int __init at91_clock_init(unsigned long main_clock)
 
 	/* report if PLLA is more than mildly overclocked */
 	plla.rate_hz = at91_pll_rate(&plla, main_clock, at91_sys_read(AT91_CKGR_PLLAR));
-	if (plla.rate_hz > 209000000)
+	if ((!cpu_is_at91sam9g20() && plla.rate_hz > 209000000)
+	   || (cpu_is_at91sam9g20() && plla.rate_hz > 800000000))
 		pr_info("Clocks: PLLA overclocked, %ld MHz\n", plla.rate_hz / 1000000);
 
 	/*
@@ -597,7 +603,7 @@ int __init at91_clock_init(unsigned long main_clock)
 		uhpck.pmc_mask = AT91RM9200_PMC_UHP;
 		udpck.pmc_mask = AT91RM9200_PMC_UDP;
 		at91_sys_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
-	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263()) {
+	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
 		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
 		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
 	} else if (cpu_is_at91cap9()) {
@@ -629,8 +635,13 @@ int __init at91_clock_init(unsigned long main_clock)
 	freq /= (1 << ((mckr & AT91_PMC_PRES) >> 2));				/* prescale */
 	if (cpu_is_at91rm9200())
 		mck.rate_hz = freq / (1 + ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
-	else
-		mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >> 8));	/* mdiv */
+	else if (cpu_is_at91sam9g20()) {
+		mck.rate_hz = (mckr & AT91_PMC_MDIV) ?
+			freq / ((mckr & AT91_PMC_MDIV) >> 7) : freq;	/* mdiv ; (x >> 7) = ((x >> 8) * 2) */
+		if (mckr & AT91_PMC_PDIV)
+			freq /= 2;		/* processor clock division */
+	}
+	else mck.rate_hz = freq / (1 << ((mckr & AT91_PMC_MDIV) >>8));      /* mdiv */
 
 	/* Register the PMC's standard clocks */
 	for (i = 0; i < ARRAY_SIZE(standard_pmc_clocks); i++)
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index aa863c1..8ab4feb 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -202,7 +202,7 @@ static int at91_pm_verify_clocks(void)
 			pr_debug("AT91: PM - Suspend-to-RAM with USB still active\n");
 			return 0;
 		}
-	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263()) {
+	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
 		if ((scsr & (AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP)) != 0) {
 			pr_debug("AT91: PM - Suspend-to-RAM with USB still active\n");
 			return 0;
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 33ed048..750d895 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -180,8 +180,8 @@ config CPU_ARM925T
 # ARM926T
 config CPU_ARM926T
 	bool "Support ARM926T processor"
-	depends on ARCH_INTEGRATOR || ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || MACH_REALVIEW_EB || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
-	default y if ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
+	depends on ARCH_INTEGRATOR || ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || MACH_REALVIEW_EB || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G20 || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
+	default y if ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G20 || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
 	select CPU_32v5
 	select CPU_ABRT_EV5TJ
 	select CPU_PABRT_NOIFAR
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index a28fc2f..8e19a71 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -372,7 +372,7 @@ static void at91_mci_enable(struct at91mci_host *host)
 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
 	mr = AT91_MCI_PDCMODE | 0x34a;
 
-	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+	if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9rl() || cpu_is_at91sam9g20())
 		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;
 
 	at91_mci_write(host, AT91_MCI_MR, mr);
@@ -849,7 +849,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	host->bus_mode = 0;
 	host->board = pdev->dev.platform_data;
 	if (host->board->wire4) {
-		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
+		if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9rl()  || cpu_is_at91sam9g20())
 			mmc->caps |= MMC_CAP_4_BIT_DATA;
 		else
 			dev_warn(&pdev->dev, "4 wire bus mode not supported"
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9f6cc8a..be3b13c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -217,7 +217,7 @@ config MII
 
 config MACB
 	tristate "Atmel MACB support"
-	depends on AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91CAP9
+	depends on AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91CAP9
 	select PHYLIB
 	help
 	  The Atmel MACB ethernet interface is found on many AT32 and AT91
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 274c60a..b6b2a0a 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -888,7 +888,7 @@ static void pullup(struct at91_udc *udc, int is_on)
 		at91_udp_write(udc, AT91_UDP_TXVC, 0);
 		if (cpu_is_at91rm9200())
 			gpio_set_value(udc->board.pullup_pin, active);
-		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
+		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
 			u32	txvc = at91_udp_read(udc, AT91_UDP_TXVC);
 
 			txvc |= AT91_UDP_TXVC_PUON;
@@ -906,7 +906,7 @@ static void pullup(struct at91_udc *udc, int is_on)
 		at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 		if (cpu_is_at91rm9200())
 			gpio_set_value(udc->board.pullup_pin, !active);
-		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
+		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sam9g20()) {
 			u32	txvc = at91_udp_read(udc, AT91_UDP_TXVC);
 
 			txvc &= ~AT91_UDP_TXVC_PUON;
diff --git a/include/asm-arm/arch-at91/at91sam9260.h b/include/asm-arm/arch-at91/at91sam9260.h
index c8934fe..889872a 100644
--- a/include/asm-arm/arch-at91/at91sam9260.h
+++ b/include/asm-arm/arch-at91/at91sam9260.h
@@ -6,6 +6,8 @@
  * Common definitions.
  * Based on AT91SAM9260 datasheet revision A (Preliminary).
  *
+ * Includes also definitions for AT91SAM9XE and AT91SAM9G families
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -123,5 +125,14 @@
 #define AT91SAM9XE_FLASH_BASE	0x00200000	/* Internal FLASH base address */
 #define AT91SAM9XE_SRAM_BASE	0x00300000	/* Internal SRAM base address */
 
+#define AT91SAM9G20_ROM_BASE	0x00100000	/* Internal ROM base address */
+#define AT91SAM9G20_ROM_SIZE	SZ_32K		/* Internal ROM size (32Kb) */
+
+#define AT91SAM9G20_SRAM0_BASE	0x00200000	/* Internal SRAM 0 base address */
+#define AT91SAM9G20_SRAM0_SIZE	SZ_16K		/* Internal SRAM 0 size (16Kb) */
+#define AT91SAM9G20_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
+#define AT91SAM9G20_SRAM1_SIZE	SZ_16K		/* Internal SRAM 1 size (16Kb) */
+
+#define AT91SAM9G20_UHP_BASE	0x00500000	/* USB Host controller */
 
 #endif
diff --git a/include/asm-arm/arch-at91/board.h b/include/asm-arm/arch-at91/board.h
index 1f24702..94de788 100644
--- a/include/asm-arm/arch-at91/board.h
+++ b/include/asm-arm/arch-at91/board.h
@@ -77,7 +77,7 @@ struct at91_eth_data {
 };
 extern void __init at91_add_device_eth(struct at91_eth_data *data);
 
-#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9)
+#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91SAM9G20) || defined(CONFIG_ARCH_AT91CAP9)
 #define eth_platform_data	at91_eth_data
 #endif
 
diff --git a/include/asm-arm/arch-at91/cpu.h b/include/asm-arm/arch-at91/cpu.h
index 7145166..52df794 100644
--- a/include/asm-arm/arch-at91/cpu.h
+++ b/include/asm-arm/arch-at91/cpu.h
@@ -21,6 +21,7 @@
 #define ARCH_ID_AT91SAM9260	0x019803a0
 #define ARCH_ID_AT91SAM9261	0x019703a0
 #define ARCH_ID_AT91SAM9263	0x019607a0
+#define ARCH_ID_AT91SAM9G20	0x019905a0
 #define ARCH_ID_AT91SAM9RL64	0x019b03a0
 #define ARCH_ID_AT91CAP9	0x039A03A0
 
@@ -63,6 +64,12 @@ static inline unsigned long at91_arch_identify(void)
 #define cpu_is_at91sam9260()	(0)
 #endif
 
+#ifdef CONFIG_ARCH_AT91SAM9G20
+#define cpu_is_at91sam9g20()	(at91_cpu_identify() == ARCH_ID_AT91SAM9G20)
+#else
+#define cpu_is_at91sam9g20()	(0)
+#endif
+
 #ifdef CONFIG_ARCH_AT91SAM9261
 #define cpu_is_at91sam9261()	(at91_cpu_identify() == ARCH_ID_AT91SAM9261)
 #else
diff --git a/include/asm-arm/arch-at91/hardware.h b/include/asm-arm/arch-at91/hardware.h
index 2c826d8..016a3a3 100644
--- a/include/asm-arm/arch-at91/hardware.h
+++ b/include/asm-arm/arch-at91/hardware.h
@@ -18,7 +18,7 @@
 
 #if defined(CONFIG_ARCH_AT91RM9200)
 #include <asm/arch/at91rm9200.h>
-#elif defined(CONFIG_ARCH_AT91SAM9260)
+#elif defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9G20)
 #include <asm/arch/at91sam9260.h>
 #elif defined(CONFIG_ARCH_AT91SAM9261)
 #include <asm/arch/at91sam9261.h>
diff --git a/include/asm-arm/arch-at91/timex.h b/include/asm-arm/arch-at91/timex.h
index 6e084eb..298d831 100644
--- a/include/asm-arm/arch-at91/timex.h
+++ b/include/asm-arm/arch-at91/timex.h
@@ -57,6 +57,11 @@
 #define AT91SAM9_MASTER_CLOCK	100000000
 #define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
+#elif defined(CONFIG_ARCH_AT91SAM9G20)
+
+#define AT91SAM9_MASTER_CLOCK	132096000
+#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+
 #elif defined(CONFIG_ARCH_AT91CAP9)
 
 #define AT91CAP9_MASTER_CLOCK	100000000
diff --git a/sound/soc/at91/at91-ssc.c b/sound/soc/at91/at91-ssc.c
index bc35d00..1a42609 100644
--- a/sound/soc/at91/at91-ssc.c
+++ b/sound/soc/at91/at91-ssc.c
@@ -41,7 +41,7 @@
 #define	DBG(x...)
 #endif
 
-#if defined(CONFIG_ARCH_AT91SAM9260)
+#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9G20)
 #define NUM_SSC_DEVICES		1
 #else
 #define NUM_SSC_DEVICES		3
-- 
1.5.3.7



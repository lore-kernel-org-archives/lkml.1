Return-Path: <linux-kernel-owner+w=401wt.eu-S1764878AbXGYPoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764878AbXGYPoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXGYPn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:43:58 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11502 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXGYPnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:43:51 -0400
X-IronPort-AV: i="4.16,581,1175486400"; 
   d="scan'208"; a="35655993:sNHT166882142"
Subject: [GIT PULL try#2] Blackfin update
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Analog Devices, Ltd.
Date: Wed, 25 Jul 2007 23:26:56 +0800
Message-Id: <1185377216.12354.12.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 25 Jul 2007 15:43:37.0091 (UTC) FILETIME=[90C93D30:01C7CED2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ for-linus

to receive the following updates:

 - Bug fixing, code cleanup, anomaly handling update and GPIO API update.
 - Serial, SPI, EMAC and RTC driver updating.

 arch/blackfin/Kconfig                              |   83 ++++-
 arch/blackfin/Makefile                             |    4 +
 arch/blackfin/kernel/bfin_gpio.c                   |  301 +++++++++++--
 arch/blackfin/kernel/cplbinit.c                    |    4 +-
 arch/blackfin/kernel/dma-mapping.c                 |    3 +-
 arch/blackfin/kernel/irqchip.c                     |    9 +
 arch/blackfin/kernel/setup.c                       |   25 +-
 arch/blackfin/kernel/traps.c                       |   55 ++-
 arch/blackfin/kernel/vmlinux.lds.S                 |   16 +-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memcpy.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    4 +-
 arch/blackfin/mach-bf533/head.S                    |   24 +-
 arch/blackfin/mach-bf537/head.S                    |   32 +-
 arch/blackfin/mach-bf548/Kconfig                   |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   30 ++
 arch/blackfin/mach-bf548/gpio.c                    |   98 ++++-
 arch/blackfin/mach-bf548/head.S                    |   16 +-
 arch/blackfin/mach-bf561/head.S                    |   35 +-
 arch/blackfin/mach-common/cache.S                  |    8 +-
 arch/blackfin/mach-common/cacheinit.S              |    9 +-
 arch/blackfin/mach-common/cplbmgr.S                |   54 ++--
 arch/blackfin/mach-common/dpmc.S                   |   52 ++--
 arch/blackfin/mach-common/entry.S                  |   83 ++++-
 arch/blackfin/mach-common/interrupt.S              |    6 +-
 arch/blackfin/mach-common/ints-priority-dc.c       |   43 +-
 arch/blackfin/mach-common/ints-priority-sc.c       |   56 ++-
 arch/blackfin/mach-common/lock.S                   |   20 +-
 arch/blackfin/oprofile/op_blackfin.h               |    8 +-
 drivers/i2c/busses/Kconfig                         |    4 +-
 drivers/input/serio/Kconfig                        |    2 +-
 drivers/net/bfin_mac.c                             |    6 +-
 drivers/rtc/rtc-bfin.c                             |    2 +-
 drivers/serial/bfin_5xx.c                          |   14 +-
 drivers/spi/spi_bfin5xx.c                          |  202 ++++-----
 include/asm-blackfin/bfin-global.h                 |    1 +
 include/asm-blackfin/bfin5xx_spi.h                 |    6 +
 include/asm-blackfin/blackfin.h                    |  124 +++---
 include/asm-blackfin/gpio.h                        |   31 ++
 include/asm-blackfin/mach-bf533/anomaly.h          |  467 ++++++++++----------
 include/asm-blackfin/mach-bf533/bf533.h            |    2 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |   11 +-
 include/asm-blackfin/mach-bf533/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf533/cdefBF532.h        |   10 +-
 include/asm-blackfin/mach-bf533/irq.h              |    2 +
 include/asm-blackfin/mach-bf533/portmux.h          |    2 +-
 include/asm-blackfin/mach-bf537/anomaly.h          |  248 ++++++-----
 include/asm-blackfin/mach-bf537/bf537.h            |    2 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h  |   23 +-
 include/asm-blackfin/mach-bf537/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf537/cdefBF534.h        |    4 +-
 include/asm-blackfin/mach-bf537/irq.h              |    2 +
 include/asm-blackfin/mach-bf537/portmux.h          |   35 ++-
 include/asm-blackfin/mach-bf548/anomaly.h          |  130 +++---
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |   39 +-
 include/asm-blackfin/mach-bf548/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |   37 ++-
 include/asm-blackfin/mach-bf548/defBF54x_base.h    |   17 +
 include/asm-blackfin/mach-bf548/gpio.h             |    5 -
 include/asm-blackfin/mach-bf548/irq.h              |    3 +
 include/asm-blackfin/mach-bf561/anomaly.h          |  409 ++++++++++-------
 include/asm-blackfin/mach-bf561/bf561.h            |    2 +-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |   11 +-
 include/asm-blackfin/mach-bf561/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf561/cdefBF561.h        |   15 +-
 include/asm-blackfin/mach-bf561/defBF561.h         |    4 +
 include/asm-blackfin/mach-bf561/irq.h              |    2 +
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    4 +-
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |  132 +++---
 include/asm-blackfin/portmux.h                     |   22 +
 include/asm-blackfin/system.h                      |   93 +++--
 include/asm-blackfin/thread_info.h                 |   12 +-
 include/asm-blackfin/trace.h                       |   55 ++-
 73 files changed, 2058 insertions(+), 1228 deletions(-)

Bernd Schmidt (3):
      Blackfin arch: fix bug which unaligns the init thread's stack and causes the current macro to fail.
      Blackfin arch: Initialize the exception vectors early in the boot process
      Blackfin arch: Load P0 before storing through it

Bryan Wu (5):
      Blackfin arch: fix a compiling warning about dma-mapping
      Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
      Blackfin arch: add BF54x I2C/TWI TWI0 driver support
      Blackfin SPI driver: Initial supporting BF54x in SPI driver
      Blackfin SPI driver update:

Michael Hennerich (14):
      Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
      Blackfin arch: add peripheral resource allocation support
      Blackfin arch: Add label to call new GPIO API
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
      Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
      Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
      Blackfin arch: add error message when IRQ no available
      Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
      Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
      Blackfin Ethernet MAC driver: fix bug Report returned -ENOMEM upwards (in case L1/uncached memory alloc fails)
      Blackfin serial driver: use new GPIO API
      Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
      Blackfin SPI driver: use new GPIO API and add error handling
      Input Serio: Blackfin doesnt support I8042 - make sure it doesnt get selected

Mike Frysinger (12):
      Blackfin arch: cleanup and standardize anomaly.h file format -- no functional changes
      Blackfin arch: setup aliases for some core Core A MMRs
      Blackfin arch: use bfin_read_SWRST() now that BF561 provides it
      Blackfin arch: add selections for BF544 and BF542
      Blackfin arch: use HI/LO macros rather than masking the bit ranges ourselves
      Blackfin arch: switch to using proper defines this time THREAD_SIZE and PAGE_SIZE instead of just PAGE_SIZE everywhere
      Blackfin arch: revise anomaly handling by basing things on the compiler not the kconfig defines
      Blackfin arch: scrub remaining ASSEMBLY usage since the switch to __ASSEMBLY__
      Blackfin arch: update BF54x anomaly list
      Blackfin arch: use the [CS]SYNC() macros which include anomaly workarounds rather than __builtin_bfin_[cs]sync()
      Blackfin arch: reorganize headers slightly so we can be sure things are defined early enough
      Blackfin On-Chip RTC driver update for supporting BF54x

Robin Getz (1):
      Blackfin arch: Add ability to expend the hardware trace buffer

Sonic Zhang (1):
      Blackfin arch: fix KGDB bug, dont forget last parameter.

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 017defa..cbc6812 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_TIME
 	bool
 	default n
 
-config GENERIC_CALIBRATE_DELAY
+config GENERIC_GPIO
 	bool
 	default y
 
@@ -973,8 +973,89 @@ config DEBUG_HUNT_FOR_ZERO
 	  Enabling this option will take up an extra entry in CPLB table.
 	  Otherwise, there is no extra overhead.
 
+config DEBUG_BFIN_HWTRACE_ON
+	bool "Turn on Blackfin's Hardware Trace"
+	default y
+	help
+	  All Blackfins include a Trace Unit which stores a history of the last
+	  16 changes in program flow taken by the program sequencer. The history
+	  allows the user to recreate the program sequencer’s recent path. This
+	  can be handy when an application dies - we print out the execution
+	  path of how it got to the offending instruction.
+
+	  By turning this off, you may save a tiny amount of power.
+
+choice
+	prompt "Omit loop Tracing"
+	default DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	depends on DEBUG_BFIN_HWTRACE_ON
+	help
+	  The trace buffer can be configured to omit recording of changes in
+	  program flow that match either the last entry or one of the last
+	  two entries. Omitting one of these entries from the record prevents
+	  the trace buffer from overflowing because of any sort of loop (for, do
+	  while, etc) in the program.
+
+	  Because zero-overhead Hardware loops are not recorded in the trace buffer,
+	  this feature can be used to prevent trace overflow from loops that
+	  are nested four deep.
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	bool "Trace all Loops"
+	help
+	  The trace buffer records all changes of flow 
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
+	bool "Compress single-level loops"
+	help
+	  The trace buffer does not record single loops - helpful if trace 
+	  is spinning on a while or do loop.
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
+	bool "Compress two-level loops"
+	help
+	  The trace buffer does not record loops two levels deep. Helpful if
+	  the trace is spinning in a nested loop
+
+endchoice
+
+config DEBUG_BFIN_HWTRACE_COMPRESSION
+	int
+	depends on DEBUG_BFIN_HWTRACE_ON
+	default 0 if DEBUG_BFIN_HWTRACE_COMPRESSION_OFF
+	default 1 if DEBUG_BFIN_HWTRACE_COMPRESSION_ONE
+	default 2 if DEBUG_BFIN_HWTRACE_COMPRESSION_TWO
+
+
+config DEBUG_BFIN_HWTRACE_EXPAND
+	bool "Expand Trace Buffer greater than 16 entries"
+	depends on DEBUG_BFIN_HWTRACE_ON
+	default n
+	help
+	  By selecting this option, every time the 16 hardware entries in
+	  the Blackfin's HW Trace buffer are full, the kernel will move them
+	  into a software buffer, for dumping when there is an issue. This 
+	  has a great impact on performance, (an interrupt every 16 change of 
+	  flows) and should normally be turned off, except in those nasty
+	  debugging sessions
+
+config DEBUG_BFIN_HWTRACE_EXPAND_LEN
+	int "Size of Trace buffer (in power of 2k)"
+	range 0 4
+	depends on DEBUG_BFIN_HWTRACE_EXPAND
+	default 1
+	help
+	  This sets the size of the software buffer that the trace information
+	  is kept in.
+	  0 for (2^0)  1k, or 256 entries,
+	  1 for (2^1)  2k, or 512 entries,
+	  2 for (2^2)  4k, or 1024 entries,
+	  3 for (2^3)  8k, or 2048 entries,
+	  4 for (2^4) 16k, or 4096 entries
+
 config DEBUG_BFIN_NO_KERN_HWTRACE
 	bool "Trace user apps (turn off hwtrace in kernel)"
+	depends on DEBUG_BFIN_HWTRACE_ON
 	default n
 	help
 	  Some pieces of the kernel contain a lot of flow changes which can
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index 1b75672..2084166 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -24,6 +24,8 @@ machine-$(CONFIG_BF533) := bf533
 machine-$(CONFIG_BF534) := bf537
 machine-$(CONFIG_BF536) := bf537
 machine-$(CONFIG_BF537) := bf537
+machine-$(CONFIG_BF542) := bf548
+machine-$(CONFIG_BF544) := bf548
 machine-$(CONFIG_BF548) := bf548
 machine-$(CONFIG_BF549) := bf548
 machine-$(CONFIG_BF561) := bf561
@@ -36,6 +38,8 @@ cpu-$(CONFIG_BF533) := bf533
 cpu-$(CONFIG_BF534) := bf534
 cpu-$(CONFIG_BF536) := bf536
 cpu-$(CONFIG_BF537) := bf537
+cpu-$(CONFIG_BF542) := bf542
+cpu-$(CONFIG_BF544) := bf544
 cpu-$(CONFIG_BF548) := bf548
 cpu-$(CONFIG_BF549) := bf549
 cpu-$(CONFIG_BF561) := bf561
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bafcfa5..979cf79 100644
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
@@ -254,11 +330,11 @@ EXPORT_SYMBOL(set_gpio_ ## name);
 SET_GPIO_SC(maska)
 SET_GPIO_SC(maskb)
 
-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	if (arg)
 		gpio_bankb[gpio_bank(gpio)]->data_set = gpio_bit(gpio);
@@ -273,11 +349,11 @@ SET_GPIO_SC(data)
 #endif
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
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
@@ -311,7 +387,7 @@ SET_GPIO_P(maska)
 SET_GPIO_P(maskb)
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 void set_gpiop_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
@@ -345,12 +421,12 @@ GET_GPIO(maska)
 GET_GPIO(maskb)
 

-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 unsigned short get_gpio_data(unsigned short gpio)
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = 0x01 & (gpio_bankb[gpio_bank(gpio)]->data >> gpio_sub_n(gpio));
 	bfin_read_CHIPID();
@@ -379,7 +455,7 @@ GET_GPIO_P(both)
 GET_GPIO_P(maska)
 GET_GPIO_P(maskb)
 
-#if defined(ANOMALY_05000311)
+#if ANOMALY_05000311
 unsigned short get_gpiop_data(unsigned short gpio)
 {
 	unsigned long flags;
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
diff --git a/arch/blackfin/kernel/cplbinit.c b/arch/blackfin/kernel/cplbinit.c
index bbdb403..3b1c87c 100644
--- a/arch/blackfin/kernel/cplbinit.c
+++ b/arch/blackfin/kernel/cplbinit.c
@@ -230,8 +230,8 @@ static void __fill_code_cplbtab(struct cplb_tab *t, int i, u32 a_start, u32 a_en
 				cplb_data[i].psize,
 				cplb_data[i].i_conf);
 	} else {
-#if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
-		if (i == SDRAM_KERN) {
+#if defined(CONFIG_BLKFIN_CACHE)
+		if (ANOMALY_05000263 && i == SDRAM_KERN) {
 			fill_cplbtab(t,
 					cplb_data[i].start,
 					cplb_data[i].end,
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index ea48d5b..94d7b11 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -160,7 +160,8 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++) {
-		sg->dma_address = page_address(sg->page) + sg->offset;
+		sg->dma_address = (dma_addr_t)(page_address(sg->page) +
+					sg->offset);
 
 		invalidate_dcache_range(sg_dma_address(sg),
 					sg_dma_address(sg) +
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 1fc001c..462ae41 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -34,6 +34,7 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <asm/trace.h>
 
 static unsigned long irq_err_count;
 static spinlock_t irq_controller_lock;
@@ -144,4 +145,12 @@ void __init init_IRQ(void)
 	}
 
 	init_arch_irq();
+
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+	/* Now that evt_ivhw is set up, turn this on */
+	trace_buff_offset = 0;
+	bfin_write_TBUFCTL(BFIN_TRACE_ON);
+	printk(KERN_INFO "Hardware Trace expanded to %ik\n",
+	  1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN);
+#endif
 }
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index f59dcee..02c1527 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -179,14 +179,16 @@ void __init setup_arch(char **cmdline_p)
 	cclk = get_cclk();
 	sclk = get_sclk();
 
-#if !defined(CONFIG_BFIN_KERNEL_CLOCK) && defined(ANOMALY_05000273)
-	if (cclk == sclk)
+#if !defined(CONFIG_BFIN_KERNEL_CLOCK)
+	if (ANOMALY_05000273 && cclk == sclk)
 		panic("ANOMALY 05000273, SCLK can not be same as CCLK");
 #endif
 
-#if defined(ANOMALY_05000266)
-	bfin_read_IMDMA_D0_IRQ_STATUS();
-	bfin_read_IMDMA_D1_IRQ_STATUS();
+#ifdef BF561_FAMILY
+	if (ANOMALY_05000266) {
+		bfin_read_IMDMA_D0_IRQ_STATUS();
+		bfin_read_IMDMA_D1_IRQ_STATUS();
+	}
 #endif
 
 #ifdef DEBUG_SERIAL_EARLY_INIT
@@ -260,7 +262,7 @@ void __init setup_arch(char **cmdline_p)
 	    && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
 		mtd_size =
 		    PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
-#  if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
+#  if (defined(CONFIG_BLKFIN_CACHE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -289,7 +291,7 @@ void __init setup_arch(char **cmdline_p)
 	_ebss = memory_mtd_start;	/* define _ebss for compatible */
 #endif				/* CONFIG_MTD_UCLINUX */
 
-#if (defined(CONFIG_BLKFIN_CACHE) && defined(ANOMALY_05000263))
+#if (defined(CONFIG_BLKFIN_CACHE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -337,10 +339,8 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu Mhz System Clock\n",
 	       cclk / 1000000,  sclk / 1000000);
 
-#if defined(ANOMALY_05000273)
-	if ((cclk >> 1) <= sclk)
+	if (ANOMALY_05000273 && (cclk >> 1) <= sclk)
 		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
-#endif
 
 	printk(KERN_INFO "Board Memory: %ldMB\n", physical_mem_end >> 20);
 	printk(KERN_INFO "Kernel Managed Memory: %ldMB\n", _ramend >> 20);
@@ -402,11 +402,7 @@ void __init setup_arch(char **cmdline_p)
 	if (l1_length > L1_DATA_A_LENGTH)
 		panic("L1 data memory overflow\n");
 
-#ifdef BF561_FAMILY
-	_bfin_swrst = bfin_read_SICA_SWRST();
-#else
 	_bfin_swrst = bfin_read_SWRST();
-#endif
 
 	/* Copy atomic sequences to their fixed location, and sanity check that
 	   these locations are the ones that we advertise to userspace.  */
@@ -429,6 +425,7 @@ void __init setup_arch(char **cmdline_p)
 	BUG_ON((char *)&atomic_xor32 - (char *)&fixed_code_start
 	       != ATOMIC_XOR32 - FIXED_CODE_START);
 
+	init_exception_vectors();
 	bf53x_cache_init();
 }
 
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 3909f5b..3bc787a 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -54,6 +54,7 @@ asmlinkage void trap_c(struct pt_regs *fp);
 
 int kstack_depth_to_print = 48;
 
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 static int printk_address(unsigned long address)
 {
 	struct vm_list_struct *vml;
@@ -130,17 +131,21 @@ static int printk_address(unsigned long address)
 	/* we were unable to find this address anywhere */
 	return printk("[<0x%p>]", (void *)address);
 }
+#endif
 
 asmlinkage void trap_c(struct pt_regs *fp)
 {
-	int j, sig = 0;
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+	int j;
+#endif
+	int sig = 0;
 	siginfo_t info;
 	unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
 
 #ifdef CONFIG_KGDB
 # define CHK_DEBUGGER_TRAP() \
 	do { \
-		CHK_DEBUGGER(trapnr, sig, info.si_code, fp); \
+		CHK_DEBUGGER(trapnr, sig, info.si_code, fp, ); \
 	} while (0)
 # define CHK_DEBUGGER_TRAP_MAYBE() \
 	do { \
@@ -428,24 +433,56 @@ asmlinkage void trap_c(struct pt_regs *fp)
 
 /* Typical exception handling routines	*/
 
+#define EXPAND_LEN ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 256 - 1)
+
 void dump_bfin_trace_buffer(void)
 {
-	int tflags;
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+	int tflags, i = 0;
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+	int j, index;
+#endif
+
 	trace_buffer_save(tflags);
 
+	printk(KERN_EMERG "Hardware Trace:\n");
+
 	if (likely(bfin_read_TBUFSTAT() & TBUFCNT)) {
-		int i;
-		printk(KERN_EMERG "Hardware Trace:\n");
-		for (i = 0; bfin_read_TBUFSTAT() & TBUFCNT; i++) {
-			printk(KERN_EMERG "%2i Target : ", i);
+		for (; bfin_read_TBUFSTAT() & TBUFCNT; i++) {
+			printk(KERN_EMERG "%4i Target : ", i);
 			printk_address((unsigned long)bfin_read_TBUF());
-			printk("\n" KERN_EMERG "   Source : ");
+			printk("\n" KERN_EMERG "     Source : ");
 			printk_address((unsigned long)bfin_read_TBUF());
 			printk("\n");
 		}
 	}
 
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+	if (trace_buff_offset)
+		index = trace_buff_offset/4 - 1;
+	else
+		index = EXPAND_LEN;
+
+	j = (1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 128;
+	while (j) {
+		printk(KERN_EMERG "%4i Target : ", i);
+		printk_address(software_trace_buff[index]);
+		index -= 1;
+		if (index < 0 )
+			index = EXPAND_LEN;
+		printk("\n" KERN_EMERG "     Source : ");
+		printk_address(software_trace_buff[index]);
+		index -= 1;
+		if (index < 0)
+			index = EXPAND_LEN;
+		printk("\n");
+		j--;
+		i++;
+	}
+#endif
+
 	trace_buffer_restore(tflags);
+#endif
 }
 EXPORT_SYMBOL(dump_bfin_trace_buffer);
 
@@ -509,7 +546,9 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 void dump_stack(void)
 {
 	unsigned long stack;
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 	int tflags;
+#endif
 	trace_buffer_save(tflags);
 	dump_bfin_trace_buffer();
 	show_stack(current, &stack);
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index d06f860..fb53780 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -32,6 +32,7 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/mem_map.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf32-bfin")
 ENTRY(__start)
@@ -64,8 +65,12 @@ SECTIONS
 
 	.data :
 	{
-		. = ALIGN(PAGE_SIZE);
+		/* make sure the init_task is aligned to the
+		 * kernel thread size so we can locate the kernel
+		 * stack properly and quickly.
+		 */
 		__sdata = .;
+		. = ALIGN(THREAD_SIZE);
 		*(.data.init_task)
 		DATA_DATA
 		CONSTRUCTORS
@@ -73,14 +78,14 @@ SECTIONS
 		. = ALIGN(32);
 		*(.data.cacheline_aligned)
 
-		. = ALIGN(PAGE_SIZE);
+		. = ALIGN(THREAD_SIZE);
 		__edata = .;
 	}
 
-	. = ALIGN(PAGE_SIZE);
 	___init_begin = .;
 	.init :
 	{
+		. = ALIGN(PAGE_SIZE);
 		__sinittext = .;
 		*(.init.text)
 		__einittext = .;
@@ -153,10 +158,9 @@ SECTIONS
 		__ebss_b_l1 = .;
 	}
 
-	. = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
-	___init_end = ALIGN(PAGE_SIZE);
+	___init_end = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
 
-	.bss ___init_end :
+	.bss LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1) :
 	{
 		. = ALIGN(4);
 		___bss_start = .;
diff --git a/arch/blackfin/lib/memcmp.S b/arch/blackfin/lib/memcmp.S
index b88c5d2..219fa28 100644
--- a/arch/blackfin/lib/memcmp.S
+++ b/arch/blackfin/lib/memcmp.S
@@ -61,7 +61,7 @@ ENTRY(_memcmp)
 
 	LSETUP (.Lquad_loop_s, .Lquad_loop_e) LC0=P1;
 .Lquad_loop_s:
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 	R0 = [P0++];
 	R1 = [I0++];
 #else
diff --git a/arch/blackfin/lib/memcpy.S b/arch/blackfin/lib/memcpy.S
index 14a5585..2e63364 100644
--- a/arch/blackfin/lib/memcpy.S
+++ b/arch/blackfin/lib/memcpy.S
@@ -98,7 +98,7 @@ ENTRY(_memcpy)
 	R0 = R1;
 	I1 = P1;
 	R3 = [I1++];
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 .Lword_loops:
 	[P0++] = R3;
 .Lword_loope:
diff --git a/arch/blackfin/lib/memmove.S b/arch/blackfin/lib/memmove.S
index 6ee6e20..33f8653 100644
--- a/arch/blackfin/lib/memmove.S
+++ b/arch/blackfin/lib/memmove.S
@@ -70,7 +70,7 @@ ENTRY(_memmove)
 	R1 = [I0++];
 
 	LSETUP (.Lquad_loops, .Lquad_loope) LC0=P1;
-#ifdef ANOMALY_05000202
+#if ANOMALY_05000202
 .Lquad_loops:
 	[P0++] = R1;
 .Lquad_loope:
@@ -102,7 +102,7 @@ ENTRY(_memmove)
 	R1 = B[P3--] (Z);
 	CC = P2 == 0;
 	IF CC JUMP .Lno_loop;
-#ifdef ANOMALY_05000245
+#if ANOMALY_05000245
 	NOP;
 	NOP;
 #endif
diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 7dd0e9c..bdc796e 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -97,7 +97,7 @@ ENTRY(__start)
 	M2 = r0;
 	M3 = r0;
 
-	trace_buffer_start(p0,r0);
+	trace_buffer_init(p0,r0);
 	P0 = R1;
 	R0 = R1;
 
@@ -144,38 +144,38 @@ ENTRY(__start)
 	ssync;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -264,7 +264,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -417,8 +417,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 429c8a1..166a7d7 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -95,43 +95,43 @@ ENTRY(__start)
 	M2 = r0;
 	M3 = r0;
 
-	trace_buffer_start(p0,r0);
+	trace_buffer_init(p0,r0);
 	P0 = R1;
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -141,12 +141,12 @@ ENTRY(__start)
 	 */
 	p0.h = hi(BFIN_PORT_MUX);
 	p0.l = lo(BFIN_PORT_MUX);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	R0.L = W[P0]; /* Read */
 	SSYNC;
 #endif
 	R0 = (PGDE_UART | PFTE_UART)(Z);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	W[P0] = R0.L; /* Write */
 	SSYNC;
 #endif
@@ -155,12 +155,12 @@ ENTRY(__start)
 
 	p0.h = hi(PORTF_FER);
 	p0.l = lo(PORTF_FER);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	R0.L = W[P0]; /* Read */
 	SSYNC;
 #endif
 	R0 = 0x000F(Z);
-#ifdef ANOMALY_05000212
+#if ANOMALY_05000212
 	W[P0] = R0.L; /* Write */
 	SSYNC;
 #endif
@@ -274,7 +274,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -436,8 +436,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
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
index 96ad95f..12677c2 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -94,6 +94,26 @@ static struct platform_device bfin_uart_device = {
 };
 #endif
 
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+static struct spi_board_info bf54x_spi_board_info[] __initdata = {
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bf54x_spi_master_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+static struct platform_device bf54x_spi_master_device = {
+	.name = "bfin-spi-master",
+	.id = 1, /* Bus number */
+	.dev = {
+		.platform_data = &bf54x_spi_master_info, /* Passed to driver */
+		},
+};
+#endif  /* spi master and devices */
+
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
@@ -102,12 +122,22 @@ static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bf54x_spi_master_device,
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
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 06751ae..72d8da4 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -92,13 +92,13 @@ ENTRY(__stext)
 	M2 = r0;
 	M3 = r0;
 
-	trace_buffer_start(p0,r0);
+	trace_buffer_init(p0,r0);
 	P0 = R1;
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
@@ -106,8 +106,8 @@ ENTRY(__stext)
 	SSYNC;
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
@@ -172,7 +172,7 @@ ENTRY(__stext)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined (ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop;
 	nop;
 	nop;
@@ -335,8 +335,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 2f08bcb..f5eaafc 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -95,43 +95,42 @@ ENTRY(__start)
 	M2 = r0;
 	M3 = r0;
 
-	trace_buffer_start(p0,r0);
+	trace_buffer_init(p0,r0);
 	P0 = R1;
 	R0 = R1;
 
 	/* Turn off the icache */
-	p0.l = (IMEM_CONTROL & 0xFFFF);
-	p0.h = (IMEM_CONTROL >> 16);
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
-	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
 	/* Turn off the dcache */
-	p0.l = (DMEM_CONTROL & 0xFFFF);
-	p0.h = (DMEM_CONTROL >> 16);
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
 	R1 = [p0];
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
 	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	CLI R2;
 	SSYNC;
 #endif
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 	STI R2;
 #endif
 
@@ -220,7 +219,7 @@ ENTRY(__start)
 	p0.l = .LWAIT_HERE;
 	p0.h = .LWAIT_HERE;
 	reti = p0;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	nop; nop; nop;
 #endif
 	rti;
@@ -372,8 +371,8 @@ ENTRY(_start_dma_code)
 	w[p0] = r0.l;
 	ssync;
 
-	p0.l = (EBIU_SDBCTL & 0xFFFF);
-	p0.h = (EBIU_SDBCTL >> 16);     /* SDRAM Memory Bank Control Register */
+	p0.l = LO(EBIU_SDBCTL);
+	p0.h = HI(EBIU_SDBCTL);     /* SDRAM Memory Bank Control Register */
 	r0 = mem_SDBCTL;
 	w[p0] = r0.l;
 	ssync;
@@ -440,15 +439,15 @@ ENTRY(_bfin_reset)
 	SSYNC;
 
 	/* make sure SYSCR is set to use BMODE */
-	P0.h = hi(SICA_SYSCR);
-	P0.l = lo(SICA_SYSCR);
-	R0.l = 0x20;
+	P0.h = hi(SYSCR);
+	P0.l = lo(SYSCR);
+	R0.l = 0x20;		/* on BF561, disable core b */
 	W[P0] = R0.l;
 	SSYNC;
 
 	/* issue a system soft reset */
-	P1.h = hi(SICA_SWRST);
-	P1.l = lo(SICA_SWRST);
+	P1.h = hi(SWRST);
+	P1.l = lo(SWRST);
 	R1.l = 0x0007;
 	W[P1] = R1;
 	SSYNC;
diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index 7063795..0521b15 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -79,8 +79,8 @@ ENTRY(_icache_invalidate)
 ENTRY(_invalidate_entire_icache)
 	[--SP] = ( R7:5);
 
-	P0.L = (IMEM_CONTROL & 0xFFFF);
-	P0.H = (IMEM_CONTROL >> 16);
+	P0.L = LO(IMEM_CONTROL);
+	P0.H = HI(IMEM_CONTROL);
 	R7 = [P0];
 
 	/* Clear the IMC bit , All valid bits in the instruction
@@ -197,8 +197,8 @@ ENTRY(_invalidate_entire_dcache)
 ENTRY(_dcache_invalidate)
 	[--SP] = ( R7:6);
 
-	P0.L = (DMEM_CONTROL & 0xFFFF);
-	P0.H = (DMEM_CONTROL >> 16);
+	P0.L = LO(DMEM_CONTROL);
+	P0.H = HI(DMEM_CONTROL);
 	R7 = [P0];
 
 	/* Clear the DMC[1:0] bits, All valid bits in the data
diff --git a/arch/blackfin/mach-common/cacheinit.S b/arch/blackfin/mach-common/cacheinit.S
index 9d47562..afa0adf 100644
--- a/arch/blackfin/mach-common/cacheinit.S
+++ b/arch/blackfin/mach-common/cacheinit.S
@@ -38,13 +38,13 @@
 
 .text
 
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 #if defined(CONFIG_BLKFIN_CACHE)
 ENTRY(_bfin_write_IMEM_CONTROL)
 
 	/* Enable Instruction Cache */
-	P0.l = (IMEM_CONTROL & 0xFFFF);
-	P0.h = (IMEM_CONTROL >> 16);
+	P0.l = LO(IMEM_CONTROL);
+	P0.h = HI(IMEM_CONTROL);
 
 	/* Anomaly 05000125 */
 	CLI R1;
@@ -60,6 +60,9 @@ ENDPROC(_bfin_write_IMEM_CONTROL)
 
 #if defined(CONFIG_BLKFIN_DCACHE)
 ENTRY(_bfin_write_DMEM_CONTROL)
+	P0.l = (DMEM_CONTROL & 0xFFFF);
+	P0.h = (DMEM_CONTROL >> 16);
+
 	CLI R1;
 	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
 	.align 8;
diff --git a/arch/blackfin/mach-common/cplbmgr.S b/arch/blackfin/mach-common/cplbmgr.S
index e4b47e0..cef94c1 100644
--- a/arch/blackfin/mach-common/cplbmgr.S
+++ b/arch/blackfin/mach-common/cplbmgr.S
@@ -75,15 +75,15 @@ ENTRY(_cplb_mgr)
 	* from the configuration table.
  	*/
 
-	P4.L = (ICPLB_FAULT_ADDR & 0xFFFF);
-	P4.H = (ICPLB_FAULT_ADDR >> 16);
+	P4.L = LO(ICPLB_FAULT_ADDR);
+	P4.H = HI(ICPLB_FAULT_ADDR);
 
 	P1 = 16;
 	P5.L = _page_size_table;
 	P5.H = _page_size_table;
 
-	P0.L = (ICPLB_DATA0 & 0xFFFF);
-	P0.H = (ICPLB_DATA0 >> 16);
+	P0.L = LO(ICPLB_DATA0);
+	P0.H = HI(ICPLB_DATA0);
 	R4 = [P4];		/* Get faulting address*/
 	R6 = 64;		/* Advance past the fault address, which*/
 	R6 = R6 + R4;		/* we'll use if we find a match*/
@@ -117,13 +117,13 @@ ENTRY(_cplb_mgr)
 	I0 = R4;		/* Fault address we'll search for*/
 
 	/* set up pointers */
-	P0.L = (ICPLB_DATA0 & 0xFFFF);
-	P0.H = (ICPLB_DATA0 >> 16);
+	P0.L = LO(ICPLB_DATA0);
+	P0.H = HI(ICPLB_DATA0);
 
 	/* The replacement procedure for ICPLBs */
 
-	P4.L = (IMEM_CONTROL & 0xFFFF);
-	P4.H = (IMEM_CONTROL >> 16);
+	P4.L = LO(IMEM_CONTROL);
+	P4.H = HI(IMEM_CONTROL);
 
 	/* disable cplbs */
 	R5 = [P4];		/* Control Register*/
@@ -243,8 +243,8 @@ ENTRY(_cplb_mgr)
 	 * last entry of the table.
 	 */
 
-	P1.L = (ICPLB_DATA15 & 0xFFFF);		/* ICPLB_DATA15 */
-	P1.H = (ICPLB_DATA15 >> 16);
+	P1.L = LO(ICPLB_DATA15);		/* ICPLB_DATA15 */
+	P1.H = HI(ICPLB_DATA15);
 	[P1] = R2;
 	[P1-0x100] = R4;
 #ifdef	CONFIG_CPLB_INFO
@@ -292,10 +292,10 @@ ENTRY(_cplb_mgr)
 	 * pending writes associated with the CPLB.
 	 */
 
-	P4.L = (DCPLB_STATUS & 0xFFFF);
-	P4.H = (DCPLB_STATUS >> 16);
-	P3.L = (DCPLB_DATA0 & 0xFFFF);
-	P3.H = (DCPLB_DATA0 >> 16);
+	P4.L = LO(DCPLB_STATUS);
+	P4.H = HI(DCPLB_STATUS);
+	P3.L = LO(DCPLB_DATA0);
+	P3.H = HI(DCPLB_DATA0);
 	R5 = [P4];
 
 	/* A protection violation can be caused by more than just writes
@@ -355,11 +355,11 @@ ENTRY(_cplb_mgr)
 	 * config table, that covers the faulting address.
 	 */
 
-	P1.L = (DCPLB_DATA15 & 0xFFFF);
-	P1.H = (DCPLB_DATA15 >> 16);
+	P1.L = LO(DCPLB_DATA15);
+	P1.H = HI(DCPLB_DATA15);
 
-	P4.L = (DCPLB_FAULT_ADDR & 0xFFFF);
-	P4.H = (DCPLB_FAULT_ADDR >> 16);
+	P4.L = LO(DCPLB_FAULT_ADDR);
+	P4.H = HI(DCPLB_FAULT_ADDR);
 	R4 = [P4];
 	I0 = R4;
 
@@ -368,8 +368,8 @@ ENTRY(_cplb_mgr)
 	R6 = R1;	/* Save for later*/
 
 	/* Turn off CPLBs while we work.*/
-	P4.L = (DMEM_CONTROL & 0xFFFF);
-	P4.H = (DMEM_CONTROL >> 16);
+	P4.L = LO(DMEM_CONTROL);
+	P4.H = HI(DMEM_CONTROL);
 	R5 = [P4];
 	BITCLR(R5,ENDCPLB_P);
 	CLI R0;
@@ -384,8 +384,8 @@ ENTRY(_cplb_mgr)
 	 * are no good.
 	 */
 
-	I1.L = (DCPLB_DATA0 & 0xFFFF);
-	I1.H = (DCPLB_DATA0 >> 16);
+	I1.L = LO(DCPLB_DATA0);
+	I1.H = HI(DCPLB_DATA0);
 	P1 = 2;
 	P2 = 16;
 	I2.L = _dcplb_preference;
@@ -405,7 +405,7 @@ ENTRY(_cplb_mgr)
 	P3.L = _page_size_table; /* retrieve end address */
 	P3.H = _page_size_table; /* retrieve end address */
 	R3 = 0x1002;		/* 16th - position, 2 bits -length */
-#ifdef ANOMALY_05000209
+#if ANOMALY_05000209
 	nop;			/* Anomaly 05000209 */
 #endif
 	R7 = EXTRACT(R1,R3.l);
@@ -475,8 +475,8 @@ ENTRY(_cplb_mgr)
 	 * one space closer to the start.
 	 */
 
-	R1.L = (DCPLB_DATA16 & 0xFFFF);		/* DCPLB_DATA15 + 4 */
-	R1.H = (DCPLB_DATA16 >> 16);
+	R1.L = LO(DCPLB_DATA16);		/* DCPLB_DATA15 + 4 */
+	R1.H = HI(DCPLB_DATA16);
 	R0 = P0;
 
 	/* If the victim happens to be in DCPLB15,
@@ -549,8 +549,8 @@ ENTRY(_cplb_mgr)
 	 * if necessary.
 	 */
 
-	P1.L = (DCPLB_DATA15 & 0xFFFF);
-	P1.H = (DCPLB_DATA15 >> 16);
+	P1.L = LO(DCPLB_DATA15);
+	P1.H = HI(DCPLB_DATA15);
 
 	/* If the DCPLB has cache bits set, but caching hasn't
 	 * been enabled, then we want to mask off the cache-in-L1
diff --git a/arch/blackfin/mach-common/dpmc.S b/arch/blackfin/mach-common/dpmc.S
index 97cdcd6..04194dc 100644
--- a/arch/blackfin/mach-common/dpmc.S
+++ b/arch/blackfin/mach-common/dpmc.S
@@ -39,8 +39,8 @@ ENTRY(_unmask_wdog_wakeup_evt)
 	P0.H = hi(SICA_IWR1);
 	P0.L = lo(SICA_IWR1);
 #else
-	P0.h = (SIC_IWR >> 16);
-	P0.l = (SIC_IWR & 0xFFFF);
+	P0.h = HI(SIC_IWR);
+	P0.l = LO(SIC_IWR);
 #endif
 	R7 = [P0];
 #if defined(CONFIG_BF561)
@@ -60,11 +60,11 @@ ENTRY(_unmask_wdog_wakeup_evt)
 	 */
 	R7 = 0x0000(z);
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_STAT >> 16);
-	P0.l = (WDOGA_STAT & 0xFFFF);
+	P0.h = HI(WDOGA_STAT);
+	P0.l = LO(WDOGA_STAT);
 #else
-	P0.h = (WDOG_STAT >> 16);
-	P0.l = (WDOG_STAT & 0xFFFF);
+	P0.h = HI(WDOG_STAT);
+	P0.l = LO(WDOG_STAT);
 #endif
 	[P0] = R7;
 	SSYNC;
@@ -73,21 +73,21 @@ ENTRY(_unmask_wdog_wakeup_evt)
 ENTRY(_program_wdog_timer)
 	[--SP] = ( R7:0, P5:0 );
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CNT >> 16);
-	P0.l = (WDOGA_CNT & 0xFFFF);
+	P0.h = HI(WDOGA_CNT);
+	P0.l = LO(WDOGA_CNT);
 #else
-	P0.h = (WDOG_CNT >> 16);
-	P0.l = (WDOG_CNT & 0xFFFF);
+	P0.h = HI(WDOG_CNT);
+	P0.l = LO(WDOG_CNT);
 #endif
 	[P0] = R0;
 	SSYNC;
 
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = W[P0](Z);
 	CC = BITTST(R7,1);
@@ -97,11 +97,11 @@ ENTRY(_program_wdog_timer)
 
 .LSKIP_WRITE_TO_STAT:
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	    P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	    P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = W[P0](Z);
 	BITCLR(R7,1);   /* Enable GP event */
@@ -122,11 +122,11 @@ ENTRY(_clear_wdog_wakeup_evt)
 	[--SP] = ( R7:0, P5:0 );
 
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = 0x0AD6(Z);
 	W[P0] = R7.L;
@@ -149,11 +149,11 @@ ENTRY(_clear_wdog_wakeup_evt)
 ENTRY(_disable_wdog_timer)
 	[--SP] = ( R7:0, P5:0 );
 #if defined(CONFIG_BF561)
-	P0.h = (WDOGA_CTL >> 16);
-	P0.l = (WDOGA_CTL & 0xFFFF);
+	P0.h = HI(WDOGA_CTL);
+	P0.l = LO(WDOGA_CTL);
 #else
-	P0.h = (WDOG_CTL >> 16);
-	P0.l = (WDOG_CTL & 0xFFFF);
+	P0.h = HI(WDOG_CTL);
+	P0.l = LO(WDOG_CTL);
 #endif
 	R7 = 0xAD6(Z);
 	W[P0] = R7.L;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index d61bba9..f86ce76 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -69,7 +69,7 @@
  * patch up CPLB misses on the kernel stack.
  */
 ENTRY(_ex_dcplb)
-#if defined(ANOMALY_05000261)
+#if ANOMALY_05000261
 	/*
 	 * Work around an anomaly: if we see a new DCPLB fault, return
 	 * without doing anything.  Then, if we get the same fault again,
@@ -137,7 +137,7 @@ ENTRY(_ex_single_step)
 
 _return_from_exception:
 	DEBUG_START_HWTRACE(p5, r7)
-#ifdef ANOMALY_05000257
+#if ANOMALY_05000257
 	R7=LC0;
 	LC0=R7;
 	R7=LC1;
@@ -634,7 +634,7 @@ ENTRY(_return_from_int)
 	p1.h = _schedule_and_signal_from_int;
 	[p0] = p1;
 	csync;
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	r0.l = lo(CONFIG_BOOT_LOAD);
 	r0.h = hi(CONFIG_BOOT_LOAD);
 	reti = r0;
@@ -648,7 +648,7 @@ ENTRY(_return_from_int)
 ENDPROC(_return_from_int)
 
 ENTRY(_lower_to_irq14)
-#if defined(ANOMALY_05000281)
+#if ANOMALY_05000281
 	r0.l = lo(CONFIG_BOOT_LOAD);
 	r0.h = hi(CONFIG_BOOT_LOAD);
 	reti = r0;
@@ -731,6 +731,75 @@ ENTRY(_init_exception_buff)
 	rts;
 ENDPROC(_init_exception_buff)
 
+/* We handle this 100% in exception space - to reduce overhead
+ * Only potiential problem is if the software buffer gets swapped out of the
+ * CPLB table - then double fault. - so we don't let this happen in other places
+ */
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+ENTRY(_ex_trace_buff_full)
+	[--sp] = P3;
+	[--sp] = P2;
+	[--sp] = LC0;
+	[--sp] = LT0;
+	[--sp] = LB0;
+	P5.L = _trace_buff_offset;
+	P5.H = _trace_buff_offset;
+	P3 = [P5];              /* trace_buff_offset */
+	P5.L = lo(TBUFSTAT);
+	P5.H = hi(TBUFSTAT);
+	R7 = [P5];
+	R7 <<= 1;               /* double, since we need to read twice */
+	LC0 = R7;
+	R7 <<= 2;               /* need to shift over again,
+				 * to get the number of bytes */
+	P5.L = lo(TBUF);
+	P5.H = hi(TBUF);
+	R6 = ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN)*1024) - 1;
+
+	P2 = R7;
+	P3 = P3 + P2;
+	R7 = P3;
+	R7 = R7 & R6;
+	P3 = R7;
+	P2.L = _trace_buff_offset;
+	P2.H = _trace_buff_offset;
+	[P2] = P3;
+
+	P2.L = _software_trace_buff;
+	P2.H = _software_trace_buff;
+
+	LSETUP (.Lstart, .Lend) LC0;
+.Lstart:
+	R7 = [P5];      /* read TBUF */
+	P4 = P3 + P2;
+	[P4] = R7;
+	P3 += -4;
+	R7 = P3;
+	R7 = R7 & R6;
+.Lend:
+	P3 = R7;
+
+	LB0 = [sp++];
+	LT0 = [sp++];
+	LC0 = [sp++];
+	P2 = [sp++];
+	P3 = [sp++];
+	jump _return_from_exception;
+
+#if CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN == 4
+.data
+#else
+.section .l1.data.B
+#endif
+ENTRY(_trace_buff_offset)
+        .long 0;
+ALIGN
+ENTRY(_software_trace_buff)
+	.rept ((1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN)*256);
+	.long 0
+	.endr
+#endif
+
 /*
  * Put these in the kernel data section - that should always be covered by
  * a CPLB. This is needed to ensure we don't get double fault conditions
@@ -764,7 +833,11 @@ _extable:
 	.long _ex_trap_c        /* 0x0E - User Defined */
 	.long _ex_trap_c        /* 0x0F - User Defined */
 	.long _ex_single_step   /* 0x10 - HW Single step */
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+	.long _ex_trace_buff_full /* 0x11 - Trace Buffer Full */
+#else
 	.long _ex_trap_c        /* 0x11 - Trace Buffer Full */
+#endif
 	.long _ex_trap_c        /* 0x12 - Reserved */
 	.long _ex_trap_c        /* 0x13 - Reserved */
 	.long _ex_trap_c        /* 0x14 - Reserved */
@@ -1169,7 +1242,7 @@ _exception_stack:
 	.endr
 _exception_stack_top:
 
-#if defined(ANOMALY_05000261)
+#if ANOMALY_05000261
 /* Used by the assembly entry point to work around an anomaly.  */
 _last_cplb_fault_retx:
 	.long 0;
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index 203e207..14ef800 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -140,7 +140,7 @@ __common_int_entry:
 	fp = 0;
 #endif
 
-#if defined (ANOMALY_05000283) || defined (ANOMALY_05000315)
+#if ANOMALY_05000283 || ANOMALY_05000315
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
@@ -163,7 +163,7 @@ ENTRY(_evt_ivhw)
 #ifdef CONFIG_FRAME_POINTER
 	fp = 0;
 #endif
-#ifdef	ANOMALY_05000283
+#if ANOMALY_05000283
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
@@ -207,7 +207,7 @@ ENTRY(_evt_evt2)
 #ifdef CONFIG_FRAME_POINTER
 	fp = 0;
 #endif
-#ifdef	ANOMALY_05000283
+#if ANOMALY_05000283
 	cc = r7 == r7;
 	p5.h = 0xffc0;
 	p5.l = 0x0014;
diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 6b9fd03..d5d9e57 100644
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
 
@@ -358,26 +358,10 @@ static void bf561_demux_gpio_irq(unsigned int inta_irq,
 
 #endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
 
-/*
- * This function should be called during kernel startup to initialize
- * the BFin IRQ handling routines.
- */
-int __init init_arch_irq(void)
+void __init init_exception_vectors(void)
 {
-	int irq;
-	unsigned long ilat = 0;
-	/*  Disable all the peripheral intrs  - page 4-29 HW Ref manual */
-	bfin_write_SICA_IMASK0(SIC_UNMASK_ALL);
-	bfin_write_SICA_IMASK1(SIC_UNMASK_ALL);
 	SSYNC();
 
-	bfin_write_SICA_IWR0(IWR_ENABLE_ALL);
-	bfin_write_SICA_IWR1(IWR_ENABLE_ALL);
-
-	local_irq_disable();
-
-	init_exception_buff();
-
 #ifndef CONFIG_KGDB
 	bfin_write_EVT0(evt_emulation);
 #endif
@@ -395,6 +379,27 @@ int __init init_arch_irq(void)
 	bfin_write_EVT14(evt14_softirq);
 	bfin_write_EVT15(evt_system_call);
 	CSYNC();
+}
+
+/*
+ * This function should be called during kernel startup to initialize
+ * the BFin IRQ handling routines.
+ */
+int __init init_arch_irq(void)
+{
+	int irq;
+	unsigned long ilat = 0;
+	/*  Disable all the peripheral intrs  - page 4-29 HW Ref manual */
+	bfin_write_SICA_IMASK0(SIC_UNMASK_ALL);
+	bfin_write_SICA_IMASK1(SIC_UNMASK_ALL);
+	SSYNC();
+
+	bfin_write_SICA_IWR0(IWR_ENABLE_ALL);
+	bfin_write_SICA_IWR1(IWR_ENABLE_ALL);
+
+	local_irq_disable();
+
+	init_exception_buff();
 
 	for (irq = 0; irq <= SYS_IRQS; irq++) {
 		if (irq <= IRQ_CORETMR)
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 28a878c..505b948 100644
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
@@ -579,11 +579,15 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PA0;
 	u8 pint_val = irq2pint_lut[irq - SYS_IRQS];
 
-	if (pint_val == IRQ_NOT_AVAIL)
+	if (pint_val == IRQ_NOT_AVAIL) {
+		printk(KERN_ERR
+		"GPIO IRQ %d :Not in PINT Assign table "
+		"Reconfigure Interrupt to Port Assignemt\n", irq);
 		return -ENODEV;
+	}
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-		ret = gpio_request(gpionr, NULL);
+		ret = gpio_request(gpionr, "IRQ");
 		if (ret)
 			return ret;
 	}
@@ -623,7 +627,7 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-			ret = gpio_request(gpionr, NULL);
+			ret = gpio_request(gpionr, "IRQ");
 			if (ret)
 				return ret;
 		}
@@ -713,6 +717,29 @@ static void bfin_demux_gpio_irq(unsigned int intb_irq,
 }
 #endif				/* CONFIG_IRQCHIP_DEMUX_GPIO */
 
+void __init init_exception_vectors(void)
+{
+	SSYNC();
+
+#ifndef CONFIG_KGDB
+	bfin_write_EVT0(evt_emulation);
+#endif
+	bfin_write_EVT2(evt_evt2);
+	bfin_write_EVT3(trap);
+	bfin_write_EVT5(evt_ivhw);
+	bfin_write_EVT6(evt_timer);
+	bfin_write_EVT7(evt_evt7);
+	bfin_write_EVT8(evt_evt8);
+	bfin_write_EVT9(evt_evt9);
+	bfin_write_EVT10(evt_evt10);
+	bfin_write_EVT11(evt_evt11);
+	bfin_write_EVT12(evt_evt12);
+	bfin_write_EVT13(evt_evt13);
+	bfin_write_EVT14(evt14_softirq);
+	bfin_write_EVT15(evt_system_call);
+	CSYNC();
+}
+
 /*
  * This function should be called during kernel startup to initialize
  * the BFin IRQ handling routines.
@@ -733,29 +760,10 @@ int __init init_arch_irq(void)
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
 	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
 #endif
-
 	SSYNC();
 
 	local_irq_disable();
 
-#ifndef CONFIG_KGDB
-	bfin_write_EVT0(evt_emulation);
-#endif
-	bfin_write_EVT2(evt_evt2);
-	bfin_write_EVT3(trap);
-	bfin_write_EVT5(evt_ivhw);
-	bfin_write_EVT6(evt_timer);
-	bfin_write_EVT7(evt_evt7);
-	bfin_write_EVT8(evt_evt8);
-	bfin_write_EVT9(evt_evt9);
-	bfin_write_EVT10(evt_evt10);
-	bfin_write_EVT11(evt_evt11);
-	bfin_write_EVT12(evt_evt12);
-	bfin_write_EVT13(evt_evt13);
-	bfin_write_EVT14(evt14_softirq);
-	bfin_write_EVT15(evt_system_call);
-	CSYNC();
-
 #if defined(CONFIG_IRQCHIP_DEMUX_GPIO) && defined(CONFIG_BF54x)
 #ifdef CONFIG_PINTx_REASSIGN
 	pint[0]->assign = CONFIG_PINT0_ASSIGN;
diff --git a/arch/blackfin/mach-common/lock.S b/arch/blackfin/mach-common/lock.S
index 386ac8d..190edb3 100644
--- a/arch/blackfin/mach-common/lock.S
+++ b/arch/blackfin/mach-common/lock.S
@@ -43,12 +43,12 @@ ENTRY(_cache_grab_lock)
 
 	[--SP]=( R7:0,P5:0 );
 
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
-	P5.H = (ICPLB_ADDR0 >> 16);
-	P5.L = (ICPLB_ADDR0 & 0xFFFF);
-	P4.H = (ICPLB_DATA0 >> 16);
-	P4.L = (ICPLB_DATA0 & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
+	P5.H = HI(ICPLB_ADDR0);
+	P5.L = LO(ICPLB_ADDR0);
+	P4.H = HI(ICPLB_DATA0);
+	P4.L = LO(ICPLB_DATA0);
 	R7 = R0;
 
 	/* If the code of interest already resides in the cache
@@ -167,8 +167,8 @@ ENTRY(_cache_lock)
 
 	[--SP]=( R7:0,P5:0 );
 
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
 
 	/* Disable the Interrupts*/
 	CLI R3;
@@ -195,8 +195,8 @@ ENDPROC(_cache_lock)
  */
 
 ENTRY(_read_iloc)
-	P1.H = (IMEM_CONTROL >> 16);
-	P1.L = (IMEM_CONTROL & 0xFFFF);
+	P1.H = HI(IMEM_CONTROL);
+	P1.L = LO(IMEM_CONTROL);
 	R1 = 0xF;
 	R0 = [P1];
 	R0 = R0 >> 3;
diff --git a/arch/blackfin/oprofile/op_blackfin.h b/arch/blackfin/oprofile/op_blackfin.h
index f88f446..05dd08c 100644
--- a/arch/blackfin/oprofile/op_blackfin.h
+++ b/arch/blackfin/oprofile/op_blackfin.h
@@ -68,7 +68,7 @@ static inline unsigned int ctr_read(void)
 	unsigned int tmp;
 
 	tmp = bfin_read_PFCTL();
-	__builtin_bfin_csync();
+	CSYNC();
 
 	return tmp;
 }
@@ -76,21 +76,21 @@ static inline unsigned int ctr_read(void)
 static inline void ctr_write(unsigned int val)
 {
 	bfin_write_PFCTL(val);
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 static inline void count_read(unsigned int *count)
 {
 	count[0] = bfin_read_PFCNTR0();
 	count[1] = bfin_read_PFCNTR1();
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 static inline void count_write(unsigned int *count)
 {
 	bfin_write_PFCNTR0(count[0]);
 	bfin_write_PFCNTR1(count[1]);
-	__builtin_bfin_csync();
+	CSYNC();
 }
 
 extern int pm_overflow_handler(int irq, struct pt_regs *regs);
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index da16478..1842f52 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -92,9 +92,9 @@ config I2C_AU1550
 
 config I2C_BLACKFIN_TWI
 	tristate "Blackfin TWI I2C support"
-	depends on BF534 || BF536 || BF537
+	depends on BF534 || BF536 || BF537 || BF54x
 	help
-	  This is the TWI I2C device driver for Blackfin 534/536/537.
+	  This is the TWI I2C device driver for Blackfin 534/536/537/54x.
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-bfin-twi.
 
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index adef447..5ce632c 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -21,7 +21,7 @@ if SERIO
 config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
 	default y
-	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K
+	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && !M68K && !BFIN
 	---help---
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 9a08d65..2bb97d4 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -798,6 +798,7 @@ static void bf537mac_shutdown(struct net_device *dev)
  */
 static int bf537mac_open(struct net_device *dev)
 {
+	int retval;
 	pr_debug("%s: %s\n", dev->name, __FUNCTION__);
 
 	/*
@@ -811,7 +812,10 @@ static int bf537mac_open(struct net_device *dev)
 	}
 
 	/* initial rx and tx list */
-	desc_list_init();
+	retval = desc_list_init();
+
+	if (retval)
+		return retval;
 
 	bf537mac_setphy(dev);
 	setup_system_regs(dev);
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 260ead9..1aa709d 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -1,6 +1,6 @@
 /*
  * Blackfin On-Chip Real Time Clock Driver
- *  Supports BF531/BF532/BF533/BF534/BF536/BF537
+ *  Supports BF53[123]/BF53[467]/BF54[2489]
  *
  * Copyright 2004-2007 Analog Devices Inc.
  *
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 66c92bc..1e79ee6 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -173,12 +173,12 @@ void kgdb_put_debug_char(int chr)
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
 	
 	while (!(UART_GET_LSR(uart) & THRE)) {
-		__builtin_bfin_ssync();
+		SSYNC();
 	}
 	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	__builtin_bfin_ssync();
+	SSYNC();
 	UART_PUT_CHAR(uart, (unsigned char)chr);
-	__builtin_bfin_ssync();
+	SSYNC();
 }
 
 int kgdb_get_debug_char(void)
@@ -192,12 +192,12 @@ int kgdb_get_debug_char(void)
 		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
 	
 	while(!(UART_GET_LSR(uart) & DR)) {
-		__builtin_bfin_ssync();
+		SSYNC();
 	}
 	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	__builtin_bfin_ssync();
+	SSYNC();
 	chr = UART_GET_CHAR(uart);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	return chr;
 }
@@ -1203,7 +1203,7 @@ static int __init bfin_serial_init(void)
 			IRQF_DISABLED, "BFIN_UART_RX", uart);
 		pr_info("Request irq for kgdb uart port\n");
 		UART_PUT_IER(uart, UART_GET_IER(uart) | ERBFI);
-		__builtin_bfin_ssync();
+		SSYNC();
 		t.c_cflag = CS8|B57600;
 		t.c_iflag = 0;
 		t.c_oflag = 0;
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 48587c2..fa4ce61 100644
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
@@ -31,36 +34,34 @@
 
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
 static inline u16 read_##reg(void) \
-            { return *(volatile unsigned short*)(SPI0_REGBASE + off); } \
+	{ return bfin_read16(SPI0_REGBASE + off); } \
 static inline void write_##reg(u16 v) \
-            {*(volatile unsigned short*)(SPI0_REGBASE + off) = v;\
-             SSYNC();}
+	{bfin_write16(SPI0_REGBASE + off, v); }
 
 DEFINE_SPI_REG(CTRL, 0x00)
 DEFINE_SPI_REG(FLAG, 0x04)
@@ -125,6 +126,7 @@ struct chip_data {
 	u16 flag;
 
 	u8 chip_select_num;
+	u8 chip_select_requested;
 	u8 n_bytes;
 	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
@@ -142,7 +144,6 @@ static void bfin_spi_enable(struct driver_data *drv_data)
 
 	cr = read_CTRL();
 	write_CTRL(cr | BIT_CTL_ENABLE);
-	SSYNC();
 }
 
 static void bfin_spi_disable(struct driver_data *drv_data)
@@ -151,7 +152,6 @@ static void bfin_spi_disable(struct driver_data *drv_data)
 
 	cr = read_CTRL();
 	write_CTRL(cr & (~BIT_CTL_ENABLE));
-	SSYNC();
 }
 
 /* Caculate the SPI_BAUD register value based on input HZ */
@@ -179,68 +179,44 @@ static int flush(struct driver_data *drv_data)
 	return limit;
 }
 
+#define MAX_SPI0_SSEL	7
+
 /* stop controller and re-config current chip*/
-static void restore_state(struct driver_data *drv_data)
+static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
+	int ret = 0;
+	u16 ssel[MAX_SPI0_SSEL] = {P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+					P_SPI0_SSEL4, P_SPI0_SSEL5,
+					P_SPI0_SSEL6, P_SPI0_SSEL7,};
 
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
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
-
-	case 2:
-	case 3:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJSE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
+	/* Load the registers */
+	write_CTRL(chip->ctl_reg);
+	write_BAUD(chip->baud);
+	write_FLAG(chip->flag);
 
-	case 4:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS4E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3840);
-		SSYNC();
-		break;
+	if (!chip->chip_select_requested) {
+		int i = chip->chip_select_num;
 
-	case 5:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS5E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3820);
-		SSYNC();
-		break;
+		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
 
-	case 6:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS6E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3810);
-		SSYNC();
-		break;
+		if ((i > 0) && (i <= MAX_SPI0_SSEL))
+			ret = peripheral_request(ssel[i-1], DRV_NAME);
 
-	case 7:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJCE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
+		chip->chip_select_requested = 1;
 	}
-#endif
 
-	/* Load the registers */
-	write_CTRL(chip->ctl_reg);
-	write_BAUD(chip->baud);
-	write_FLAG(chip->flag);
+	if (ret)
+		dev_dbg(&drv_data->pdev->dev,
+			": request chip select number %d failed\n",
+			chip->chip_select_num);
+
+	return ret;
 }
 
 /* used to kick off transfer in rx mode */
@@ -278,7 +254,7 @@ static void null_reader(struct driver_data *drv_data)
 
 static void u8_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -298,7 +274,6 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (read_STAT() & BIT_STAT_TXS)
@@ -306,18 +281,18 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_reader(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT());
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
@@ -344,7 +319,6 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -353,13 +327,13 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 			continue;
 		*(u8 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u8_duplex(struct driver_data *drv_data)
@@ -383,7 +357,7 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
+
 
 		write_TDBR(*(u8 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -392,19 +366,19 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
+
 }
 
 static void u16_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT());
 
 	while (drv_data->tx < drv_data->tx_end) {
@@ -425,7 +399,6 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while ((read_STAT() & BIT_STAT_TXS))
@@ -433,13 +406,12 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 		while (!(read_STAT() & BIT_STAT_SPIF))
 			continue;
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_reader(struct driver_data *drv_data)
@@ -467,7 +439,6 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 
 	while (drv_data->rx < drv_data->rx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		read_RDBR();	/* kick off */
 		while (!(read_STAT() & BIT_STAT_RXS))
@@ -476,13 +447,12 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 			continue;
 		*(u16 *) (drv_data->rx) = read_SHAW();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 static void u16_duplex(struct driver_data *drv_data)
@@ -506,7 +476,6 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_FLAG(chip->flag);
-		SSYNC();
 
 		write_TDBR(*(u16 *) (drv_data->tx));
 		while (!(read_STAT() & BIT_STAT_SPIF))
@@ -515,14 +484,13 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR();
 		write_FLAG(0xFF00 | chip->flag);
-		SSYNC();
+
 		if (chip->cs_chg_udelay)
 			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
 	write_FLAG(0xFF00);
-	SSYNC();
 }
 
 /* test if ther is more transfer to be done */
@@ -817,14 +785,13 @@ static void pump_transfers(unsigned long data)
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
 				"IO duplex: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->duplex(drv_data);
 
@@ -835,11 +802,10 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->write(drv_data);
 
@@ -850,11 +816,10 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_READ | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
-			SSYNC();
 
 			drv_data->read(drv_data);
 			if (drv_data->rx != drv_data->rx_end)
@@ -862,7 +827,7 @@ static void pump_transfers(unsigned long data)
 		}
 
 		if (!tranf_success) {
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write error!\n");
 			message->state = ERROR_STATE;
 		} else {
@@ -903,6 +868,14 @@ static void pump_messages(struct work_struct *work)
 	/* Extract head of queue */
 	drv_data->cur_msg = list_entry(drv_data->queue.next,
 				       struct spi_message, queue);
+
+	/* Setup the SSP using the per chip configuration */
+	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
+	if (restore_state(drv_data)) {
+		spin_unlock_irqrestore(&drv_data->lock, flags);
+		return;
+	};
+
 	list_del_init(&drv_data->cur_msg->queue);
 
 	/* Initial message state */
@@ -910,15 +883,12 @@ static void pump_messages(struct work_struct *work)
 	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
 					    struct spi_transfer, transfer_list);
 
-	/* Setup the SSP using the per chip configuration */
-	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	restore_state(drv_data);
 	dev_dbg(&drv_data->pdev->dev,
 		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
-   		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
-   		drv_data->cur_chip->ctl_reg);
-	
-	dev_dbg(&drv_data->pdev->dev, 
+		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
+		drv_data->cur_chip->ctl_reg);
+
+	dev_dbg(&drv_data->pdev->dev,
 		"the first transfer len is %d\n",
 		drv_data->cur_transfer->len);
 
@@ -1178,6 +1148,22 @@ static inline int destroy_queue(struct driver_data *drv_data)
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
@@ -1194,6 +1180,12 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
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
@@ -1227,9 +1219,11 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
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
 
@@ -1259,6 +1253,8 @@ static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
+	setup_pin_mux(0);
+
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index c4d6cbb..a970781 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -61,6 +61,7 @@ extern void bfin_dcache_init(void);
 extern int read_iloc(void);
 extern int bfin_console_init(void);
 extern asmlinkage void lower_to_irq14(void);
+extern void init_exception_vectors(void);
 extern void init_dma(void);
 extern void program_IAR(void);
 extern void evt14_softirq(void);
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
diff --git a/include/asm-blackfin/blackfin.h b/include/asm-blackfin/blackfin.h
index 25b934b..5ecf0aa 100644
--- a/include/asm-blackfin/blackfin.h
+++ b/include/asm-blackfin/blackfin.h
@@ -11,78 +11,71 @@
 #define HI(con32) (((con32) >> 16) & 0xFFFF)
 #define hi(con32) (((con32) >> 16) & 0xFFFF)
 
-#include <asm/mach/blackfin.h>
-#include <asm/bfin-global.h>
+#include <asm/mach/anomaly.h>
 
 #ifndef __ASSEMBLY__
 
 /* SSYNC implementation for C file */
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"nop;nop;\n\t"
-			"ssync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
-}
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void SSYNC (void)
+static inline void SSYNC(void)
 {
 	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"ssync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
+	if (ANOMALY_05000312 && ANOMALY_05000244)
+		__asm__ __volatile__(
+			"cli %0;"
+			"nop;"
+			"nop;"
+			"ssync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (ANOMALY_05000312 && !ANOMALY_05000244)
+		__asm__ __volatile__(
+			"cli %0;"
+			"ssync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (!ANOMALY_05000312 && ANOMALY_05000244)
+		__asm__ __volatile__(
+			"nop;"
+			"nop;"
+			"nop;"
+			"ssync;"
+		);
+	else
+		__asm__ __volatile__("ssync;");
 }
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	__asm__ __volatile__ ("nop; nop; nop;\n\t"
-			"ssync;\n\t"
-			::);
-}
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void SSYNC (void)
-{
-	__asm__ __volatile__ ("ssync;\n\t");
-}
-#endif
 
 /* CSYNC implementation for C file */
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void CSYNC (void)
+static inline void CSYNC(void)
 {
 	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"nop;nop;\n\t"
-			"csync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
+	if (ANOMALY_05000312 && ANOMALY_05000244)
+		__asm__ __volatile__(
+			"cli %0;"
+			"nop;"
+			"nop;"
+			"csync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (ANOMALY_05000312 && !ANOMALY_05000244)
+		__asm__ __volatile__(
+			"cli %0;"
+			"csync;"
+			"sti %0;"
+			: "=d" (_tmp)
+		);
+	else if (!ANOMALY_05000312 && ANOMALY_05000244)
+		__asm__ __volatile__(
+			"nop;"
+			"nop;"
+			"nop;"
+			"ssync;"
+		);
+	else
+		__asm__ __volatile__("csync;");
 }
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	int _tmp;
-	__asm__ __volatile__ ("cli %0;\n\t"
-			"csync;\n\t"
-			"sti %0;\n\t"
-			:"=d"(_tmp):);
-}
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	__asm__ __volatile__ ("nop; nop; nop;\n\t"
-			"ssync;\n\t"
-			::);
-}
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
-static inline void CSYNC (void)
-{
-	__asm__ __volatile__ ("csync;\n\t");
-}
-#endif
 
 #else  /* __ASSEMBLY__ */
 
@@ -91,19 +84,19 @@ static inline void CSYNC (void)
 #define ssync(x) SSYNC(x)
 #define csync(x) CSYNC(x)
 
-#if defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
+#if ANOMALY_05000312 && ANOMALY_05000244
 #define SSYNC(scratch) cli scratch; nop; nop; SSYNC; sti scratch;
 #define CSYNC(scratch) cli scratch; nop; nop; CSYNC; sti scratch;
 
-#elif defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
+#elif ANOMALY_05000312 && !ANOMALY_05000244
 #define SSYNC(scratch) cli scratch; nop; nop; SSYNC; sti scratch;
 #define CSYNC(scratch) cli scratch; nop; nop; CSYNC; sti scratch;
 
-#elif !defined(ANOMALY_05000312) && defined(ANOMALY_05000244)
+#elif !ANOMALY_05000312 && ANOMALY_05000244
 #define SSYNC(scratch) nop; nop; nop; SSYNC;
 #define CSYNC(scratch) nop; nop; nop; CSYNC;
 
-#elif !defined(ANOMALY_05000312) && !defined(ANOMALY_05000244)
+#elif !ANOMALY_05000312 && !ANOMALY_05000244
 #define SSYNC(scratch) SSYNC;
 #define CSYNC(scratch) CSYNC;
 
@@ -111,4 +104,7 @@ static inline void CSYNC (void)
 
 #endif /* __ASSEMBLY__ */
 
+#include <asm/mach/blackfin.h>
+#include <asm/bfin-global.h>
+
 #endif				/* _BLACKFIN_H_ */
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
diff --git a/include/asm-blackfin/mach-bf533/anomaly.h b/include/asm-blackfin/mach-bf533/anomaly.h
index 7302f29..caea0b0 100644
--- a/include/asm-blackfin/mach-bf533/anomaly.h
+++ b/include/asm-blackfin/mach-bf533/anomaly.h
@@ -1,247 +1,258 @@
 /*
- * File:         include/asm-blackfin/mach-bf533/anomaly.h
- * Based on:
- * Author:
+ * File: include/asm-blackfin/mach-bf533/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision U, May 17, 2006; ADSP-BF533 Blackfin Processor Anomaly List
- *  - Revision Y, May 17, 2006; ADSP-BF532 Blackfin Processor Anomaly List
- *  - Revision T, May 17, 2006; ADSP-BF531 Blackfin Processor Anomaly List
+ *  - Revision X,  March 23, 2007; ADSP-BF533 Blackfin Processor Anomaly List
+ *  - Revision AB, March 23, 2007; ADSP-BF532 Blackfin Processor Anomaly List
+ *  - Revision W,  March 23, 2007; ADSP-BF531 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
 /* We do not support 0.1 or 0.2 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1) || defined(CONFIG_BF_REV_0_2))
-#error Kernel will not work on BF533 Version 0.1 or 0.2
+#if __SILICON_REVISION__ < 3
+# error Kernel will not work on BF533 silicon version 0.0, 0.1, or 0.2
 #endif
 
-/* Issues that are common to 0.5, 0.4, and 0.3 silicon */
-#if  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_4) \
-		|| defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000105 /* Watchpoint Status Register (WPSTAT) bits are set on
-                            every corresponding match */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-                            Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-                            registers. */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits*/
-#define ANOMALY_05000167 /* Turning Serial Ports on With External Frame Syncs */
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#define ANOMALY_05000208 /* VSTAT status bit in PLL_STAT register is not
-                            functional */
-#define ANOMALY_05000219 /* NMI event at boot time results in unpredictable
-                            state */
-#define ANOMALY_05000229 /* SPI Slave Boot Mode modifies registers */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000273 /* Writes to Synchronous SDRAM memory may be lost */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-                            control */
-#define ANOMALY_05000283 /* A system MMR write is stalled indefinitely when
-                            killed in a particular stage*/
-#define ANOMALY_05000311 /* Erroneous flag pin operations under specific
-			    sequences */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
-#define ANOMALY_05000313 /* PPI Is Level-Sensitive on First Transfer  */
-#define ANOMALY_05000315 /* Killed System MMR Write Completes Erroneously On
-			  *  Next System MMR Access */
-#define ANOMALY_05000319 /* Internal Voltage Regulator Values of 1.05V, 1.10V
-			  *  and 1.15V Not Allowed for LQFP Packages */
-#endif /* Issues that are common to 0.5, 0.4, and 0.3 silicon */
+#if defined(__ADSPBF531__)
+# define ANOMALY_BF531 1
+#else
+# define ANOMALY_BF531 0
+#endif
+#if defined(__ADSPBF532__)
+# define ANOMALY_BF532 1
+#else
+# define ANOMALY_BF532 0
+#endif
+#if defined(__ADSPBF533__)
+# define ANOMALY_BF533 1
+#else
+# define ANOMALY_BF533 0
+#endif
 
-/* These issues only occur on 0.3 or 0.4 BF533 */
-#if (defined(CONFIG_BF_REV_0_4) || defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000099 /* UART Line Status Register (UART_LSR) bits are not
-                            updated at the same time. */
-#define ANOMALY_05000158 /* Boot fails when data cache enabled: Data from a Data
-        		    Cache Fill can be corrupted after or during
-                            Instruction DMA if certain core stalls exist */
-#define ANOMALY_05000179 /* PPI_COUNT cannot be programmed to 0 in General
-                            Purpose TX or RX modes */
-#define ANOMALY_05000198 /* Failing SYSTEM MMR accesses when stalled by
-                            preceding memory read */
-#define ANOMALY_05000200 /* SPORT TFS and DT are incorrectly driven during
-                            inactive channels in certain conditions */
-#define ANOMALY_05000202 /* Possible infinite stall with specific dual dag
-                            situation */
-#define ANOMALY_05000215 /* UART TX Interrupt masked erroneously */
-#define ANOMALY_05000225 /* Incorrect pulse-width of UART start-bit */
-#define ANOMALY_05000227 /* Scratchpad memory bank reads may return incorrect
-                            data*/
-#define ANOMALY_05000230 /* UART Receiver is less robust against Baudrate
-                            Differences in certain Conditions */
-#define ANOMALY_05000231 /* UART STB bit incorrectly affects receiver setting */
-#define ANOMALY_05000242 /* DF bit in PLL_CTL register does not respond to
-                            hardware reset */
-#define ANOMALY_05000244 /* With instruction cache enabled, a CSYNC or SSYNC or
-                            IDLE around a Change of Control causes
-                            unpredictable results */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an access in the
-                            shadow of a conditional branch */
-#define ANOMALY_05000246 /* Data CPLB's should prevent spurious hardware
-                            errors */
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-                            interrupt not functional */
-#define ANOMALY_05000257 /* An interrupt or exception during short Hardware
-                            loops may cause the instruction fetch unit to
-                            malfunction */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bit 9 and 12 of
-                            the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB exception */
-#define ANOMALY_05000264 /* A Sync instruction (CSYNC, SSYNC) or an IDLE
-                            instruction will cause an infinite stall in the
-                            second to last instruction in a hardware loop */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            SPORT external receive and transmit clocks. */
-#define ANOMALY_05000269 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to increase. */
-#define ANOMALY_05000270 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to decrease */
-#endif /* issues only occur on 0.3 or 0.4 BF533 */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
+#define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
+/* Watchpoint Status Register (WPSTAT) Bits Are Set on Every Corresponding Match */
+#define ANOMALY_05000105 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Instruction DMA Can Cause Data Cache Fills to Fail (Boot Implications) */
+#define ANOMALY_05000158 (__SILICON_REVISION__ < 5)
+/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+#define ANOMALY_05000166 (1)
+/* Turning Serial Ports on with External Frame Syncs */
+#define ANOMALY_05000167 (1)
+/* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
+#define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
+/* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
+#define ANOMALY_05000180 (1)
+/* Timer Pin Limitations for PPI TX Modes with External Frame Syncs */
+#define ANOMALY_05000183 (__SILICON_REVISION__ < 4)
+/* False Protection Exceptions */
+#define ANOMALY_05000189 (__SILICON_REVISION__ < 4)
+/* False I/O Pin Interrupts on Edge-Sensitive Inputs When Polarity Setting Is Changed */
+#define ANOMALY_05000193 (__SILICON_REVISION__ < 4)
+/* Restarting SPORT in Specific Modes May Cause Data Corruption */
+#define ANOMALY_05000194 (__SILICON_REVISION__ < 4)
+/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+#define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
+/* Current DMA Address Shows Wrong Value During Carry Fix */
+#define ANOMALY_05000199 (__SILICON_REVISION__ < 4)
+/* SPORT TFS and DT Are Incorrectly Driven During Inactive Channels in Certain Conditions */
+#define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
+/* Receive Frame Sync Not Ignored During Active Frames in SPORT Multi-Channel Mode */
+#define ANOMALY_05000201 (__SILICON_REVISION__ < 4)
+/* Possible Infinite Stall with Specific Dual-DAG Situation */
+#define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
+/* Specific Sequence That Can Cause DMA Error or DMA Stopping */
+#define ANOMALY_05000203 (__SILICON_REVISION__ < 4)
+/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+#define ANOMALY_05000204 (__SILICON_REVISION__ < 4 && ANOMALY_BF533)
+/* Recovery from "Brown-Out" Condition */
+#define ANOMALY_05000207 (__SILICON_REVISION__ < 4)
+/* VSTAT Status Bit in PLL_STAT Register Is Not Functional */
+#define ANOMALY_05000208 (1)
+/* Speed Path in Computational Unit Affects Certain Instructions */
+#define ANOMALY_05000209 (__SILICON_REVISION__ < 4)
+/* UART TX Interrupt Masked Erroneously */
+#define ANOMALY_05000215 (__SILICON_REVISION__ < 5)
+/* NMI Event at Boot Time Results in Unpredictable State */
+#define ANOMALY_05000219 (1)
+/* Incorrect Pulse-Width of UART Start Bit */
+#define ANOMALY_05000225 (__SILICON_REVISION__ < 5)
+/* Scratchpad Memory Bank Reads May Return Incorrect Data */
+#define ANOMALY_05000227 (__SILICON_REVISION__ < 5)
+/* SPI Slave Boot Mode Modifies Registers from Reset Value */
+#define ANOMALY_05000229 (1)
+/* UART Receiver is Less Robust Against Baudrate Differences in Certain Conditions */
+#define ANOMALY_05000230 (__SILICON_REVISION__ < 5)
+/* UART STB Bit Incorrectly Affects Receiver Setting */
+#define ANOMALY_05000231 (__SILICON_REVISION__ < 5)
+/* PPI_FS3 Is Not Driven in 2 or 3 Internal Frame Sync Transmit Modes */
+#define ANOMALY_05000233 (__SILICON_REVISION__ < 4)
+/* Incorrect Revision Number in DSPID Register */
+#define ANOMALY_05000234 (__SILICON_REVISION__ == 4)
+/* DF Bit in PLL_CTL Register Does Not Respond to Hardware Reset */
+#define ANOMALY_05000242 (__SILICON_REVISION__ < 4)
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (1)
+/* Data CPLBs Should Prevent Spurious Hardware Errors */
+#define ANOMALY_05000246 (__SILICON_REVISION__ < 5)
+/* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ == 4)
+/* Maximum External Clock Speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 5)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 4)
+/* Entering Hibernate State with RTC Seconds Interrupt Not Functional */
+#define ANOMALY_05000255 (__SILICON_REVISION__ < 5)
+/* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 5)
+/* Instruction Cache Is Corrupted When Bits 9 and 12 of the ICPLB Data Registers Differ */
+#define ANOMALY_05000258 (__SILICON_REVISION__ < 5)
+/* ICPLB_STATUS MMR Register May Be Corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ < 5)
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 5)
+/* Stores To Data Cache May Be Lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 5)
+/* Hardware Loop Corrupted When Taking an ICPLB Exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ < 5)
+/* CSYNC/SSYNC/IDLE Causes Infinite Stall in Penultimate Instruction in Hardware Loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 5)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (__SILICON_REVISION__ < 5)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Increase */
+#define ANOMALY_05000269 (__SILICON_REVISION__ < 5)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
+#define ANOMALY_05000270 (__SILICON_REVISION__ < 5)
+/* Spontaneous Reset of Internal Voltage Regulator */
+#define ANOMALY_05000271 (__SILICON_REVISION__ < 4)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* Writes to Synchronous SDRAM Memory May Be Lost */
+#define ANOMALY_05000273 (1)
+/* Timing Requirements Change for External Frame Sync PPI Modes with Non-Zero PPI_DELAY */
+#define ANOMALY_05000276 (1)
+/* Writes to an I/O Data Register One SCLK Cycle after an Edge Is Detected May Clear Interrupt */
+#define ANOMALY_05000277 (1)
+/* Disabling Peripherals with DMA Running May Cause DMA System Instability */
+#define ANOMALY_05000278 (1)
+/* False Hardware Error Exception When ISR Context Is Not Restored */
+#define ANOMALY_05000281 (1)
+/* Memory DMA Corruption with 32-Bit Data and Traffic Control */
+#define ANOMALY_05000282 (1)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (1)
+/* SPORTs May Receive Bad Data If FIFOs Fill Up */
+#define ANOMALY_05000288 (1)
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+#define ANOMALY_05000302 (__SILICON_REVISION__ < 5)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
+/* New Feature: Additional PPI Frame Sync Sampling Options (Not Available On Older Silicon) */
+#define ANOMALY_05000306 (__SILICON_REVISION__ < 5)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Erroneous Flag (GPIO) Pin Operations under Specific Sequences */
+#define ANOMALY_05000311 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI Is Level-Sensitive on First Transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (1)
+/* Internal Voltage Regulator Values of 1.05V, 1.10V and 1.15V Not Allowed for LQFP Packages */
+#define ANOMALY_05000319 (ANOMALY_BF531 || ANOMALY_BF532)
 
-/* These issues are only on 0.4 silicon */
-#if (defined(CONFIG_BF_REV_0_4))
-#define ANOMALY_05000234 /* Incorrect Revision Number in DSPID Register */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) */
-#endif /* issues are only on 0.4 silicon */
+/* These anomalies have been "phased" out of analog.com anomaly sheets and are
+ * here to show running on older silicon just isn't feasible.
+ */
 
-/* These issues are only on 0.3 silicon */
-#if defined(CONFIG_BF_REV_0_3)
-#define ANOMALY_05000183 /* Timer Pin limitations for PPI TX Modes with
-                            External Frame Syncs */
-#define ANOMALY_05000189 /* False Protection Exceptions caused by Speculative
-                            Instruction or Data Fetches, or by Fetches at the
-                            boundary of reserved memory space */
-#define ANOMALY_05000193 /* False Flag Pin Interrupts on Edge Sensitive Inputs
-                            when polarity setting is changed */
-#define ANOMALY_05000194 /* Sport Restarting in specific modes may cause data
-                            corruption */
-#define ANOMALY_05000199 /* DMA current address shows wrong value during carry
-                            fix */
-#define ANOMALY_05000201 /* Receive frame sync not ignored during active
-                            frames in sport MCM */
-#define ANOMALY_05000203 /* Specific sequence that can cause DMA error or DMA
-                            stopping */
-#if defined(CONFIG_BF533)
-#define ANOMALY_05000204 /* Incorrect data read with write-through cache and
-                            allocate cache lines on reads only mode */
-#endif /* CONFIG_BF533 */
-#define ANOMALY_05000207 /* Recovery from "brown-out" condition */
-#define ANOMALY_05000209 /* Speed-Path in computational unit affects certain
-                            instructions */
-#define ANOMALY_05000233 /* PPI_FS3 is not driven in 2 or 3 internal Frame
-                            Sync Transmit Mode */
-#define ANOMALY_05000271 /* Spontaneous reset of Internal Voltage Regulator */
-#endif /* only on 0.3 silicon */
+/* Watchpoints (Hardware Breakpoints) are not supported */
+#define ANOMALY_05000067 (__SILICON_REVISION__ < 3)
+/* Reserved bits in SYSCFG register not set at power on */
+#define ANOMALY_05000109 (__SILICON_REVISION__ < 3)
+/* Trace Buffers may record discontinuities into emulation mode and/or exception, NMI, reset handlers */
+#define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
+/* DTEST_COMMAND initiated memory access may be incorrect if data cache or DMA is active */
+#define ANOMALY_05000123 (__SILICON_REVISION__ < 3)
+/* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
+#define ANOMALY_05000124 (__SILICON_REVISION__ < 3)
+/* Erroneous exception when enabling cache */
+#define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
+/* SPI clock polarity and phase bits incorrect during booting */
+#define ANOMALY_05000126 (__SILICON_REVISION__ < 3)
+/* DMEM_CONTROL is not set on Reset */
+#define ANOMALY_05000137 (__SILICON_REVISION__ < 3)
+/* SPI boot will not complete if there is a zero fill block in the loader file */
+#define ANOMALY_05000138 (__SILICON_REVISION__ < 3)
+/* Allowing the SPORT RX FIFO to fill will cause an overflow */
+#define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
+/* An Infinite Stall occurs with a particular sequence of consecutive dual dag events */
+#define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
+/* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
+#define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
+/* A read from external memory may return a wrong value with data cache enabled */
+#define ANOMALY_05000143 (__SILICON_REVISION__ < 3)
+/* DMA and TESTSET conflict when both are accessing external memory */
+#define ANOMALY_05000144 (__SILICON_REVISION__ < 3)
+/* In PWM_OUT mode, you must enable the PPI block to generate a waveform from PPI_CLK */
+#define ANOMALY_05000145 (__SILICON_REVISION__ < 3)
+/* MDMA may lose the first few words of a descriptor chain */
+#define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
+/* The source MDMA descriptor may stop with a DMA Error */
+#define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
+/* When booting from a 16-bit asynchronous memory device, the upper 8-bits of each word must be 0x00 */
+#define ANOMALY_05000148 (__SILICON_REVISION__ < 3)
+/* Frame Delay in SPORT Multichannel Mode */
+#define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
+/* SPORT TFS signal is active in Multi-channel mode outside of valid channels */
+#define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
+/* Timer1 can not be used for PWMOUT mode when a certain PPI mode is in use */
+#define ANOMALY_05000155 (__SILICON_REVISION__ < 3)
+/* A killed 32-bit System MMR write will lead to the next system MMR access thinking it should be 32-bit. */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
+/* SPORT transmit data is not gated by external frame sync in certain conditions */
+#define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
+/* SDRAM auto-refresh and subsequent Power Ups */
+#define ANOMALY_05000168 (__SILICON_REVISION__ < 3)
+/* DATA CPLB page miss can result in lost write-through cache data writes */
+#define ANOMALY_05000169 (__SILICON_REVISION__ < 3)
+/* DMA vs Core accesses to external memory */
+#define ANOMALY_05000173 (__SILICON_REVISION__ < 3)
+/* Cache Fill Buffer Data lost */
+#define ANOMALY_05000174 (__SILICON_REVISION__ < 3)
+/* Overlapping Sequencer and Memory Stalls */
+#define ANOMALY_05000175 (__SILICON_REVISION__ < 3)
+/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+#define ANOMALY_05000176 (__SILICON_REVISION__ < 3)
+/* Disabling the PPI resets the PPI configuration registers */
+#define ANOMALY_05000181 (__SILICON_REVISION__ < 3)
+/* PPI TX Mode with 2 External Frame Syncs */
+#define ANOMALY_05000185 (__SILICON_REVISION__ < 3)
+/* PPI does not invert the Driving PPICLK edge in Transmit Modes */
+#define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
+/* In PPI Transmit Modes with External Frame Syncs POLC */
+#define ANOMALY_05000192 (__SILICON_REVISION__ < 3)
+/* Internal Voltage Regulator may not start up */
+#define ANOMALY_05000206 (__SILICON_REVISION__ < 3)
 
-#if defined(CONFIG_BF_REV_0_2)
-#define ANOMALY_05000067 /* Watchpoints (Hardware Breakpoints) are not
-			  *  supported */
-#define ANOMALY_05000109 /* Reserved bits in SYSCFG register not set at
-			  *  power on */
-#define ANOMALY_05000116 /* Trace Buffers may record discontinuities into
-			  *  emulation mode and/or exception, NMI, reset
-			  *  handlers */
-#define ANOMALY_05000123 /* DTEST_COMMAND initiated memory access may be
-			  *  incorrect if data cache or DMA is active */
-#define ANOMALY_05000124 /* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1,
-			  *  or 1:1 */
-#define ANOMALY_05000125 /* Erroneous exception when enabling cache */
-#define ANOMALY_05000126 /* SPI clock polarity and phase bits incorrect
-			  *  during booting */
-#define ANOMALY_05000137 /* DMEM_CONTROL is not set on Reset */
-#define ANOMALY_05000138 /* SPI boot will not complete if there is a zero fill
-			  * block in the loader file */
-#define ANOMALY_05000140 /* Allowing the SPORT RX FIFO to fill will cause an
-			  *  overflow */
-#define ANOMALY_05000141 /* An Infinite Stall occurs with a particular sequence
-			  *  of consecutive dual dag events */
-#define ANOMALY_05000142 /* Interrupts may be lost when a programmable input
-			  *  flag is configured to be edge sensitive */
-#define ANOMALY_05000143 /* A read from external memory may return a wrong
-			  *  value with data cache enabled */
-#define ANOMALY_05000144 /* DMA and TESTSET conflict when both are accessing
-			  *  external memory */
-#define ANOMALY_05000145 /* In PWM_OUT mode, you must enable the PPI block to
-			  *  generate a waveform from PPI_CLK */
-#define ANOMALY_05000146 /* MDMA may lose the first few words of a descriptor
-			  *  chain */
-#define ANOMALY_05000147 /* The source MDMA descriptor may stop with a DMA
-			  *  Error */
-#define ANOMALY_05000148 /* When booting from a 16-bit asynchronous memory
-			  *  device, the upper 8-bits of each word must be
-			  *  0x00 */
-#define ANOMALY_05000153 /* Frame Delay in SPORT Multichannel Mode */
-#define ANOMALY_05000154 /* SPORT TFS signal is active in Multi-channel mode
-			  *  outside of valid channels */
-#define ANOMALY_05000155 /* Timer1 can not be used for PWMOUT mode when a
-			  *  certain PPI mode is in use */
-#define ANOMALY_05000157 /* A killed 32-bit System MMR write will lead to
-			  *  the next system MMR access thinking it should be
-			  *  32-bit. */
-#define ANOMALY_05000163 /* SPORT transmit data is not gated by external frame
-			  *  sync in certain conditions */
-#define ANOMALY_05000168 /* SDRAM auto-refresh and subsequent Power Ups */
-#define ANOMALY_05000169 /* DATA CPLB page miss can result in lost
-			  *  write-through cache data writes */
-#define ANOMALY_05000173 /* DMA vs Core accesses to external memory */
-#define ANOMALY_05000174 /* Cache Fill Buffer Data lost */
-#define ANOMALY_05000175 /* Overlapping Sequencer and Memory Stalls */
-#define ANOMALY_05000176 /* Multiplication of (-1) by (-1) followed by an
-			  *  accumulator saturation */
-#define ANOMALY_05000181 /* Disabling the PPI resets the PPI configuration
-			  *  registers */
-#define ANOMALY_05000185 /* PPI TX Mode with 2 External Frame Syncs */
-#define ANOMALY_05000191 /* PPI does not invert the Driving PPICLK edge in
-			  *  Transmit Modes */
-#define ANOMALY_05000192 /* In PPI Transmit Modes with External Frame Syncs
-			  *  POLC */
-#define ANOMALY_05000206 /* Internal Voltage Regulator may not start up */
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000266 (0)
 
 #endif
-
-#endif /*  _MACH_ANOMALY_H_ */
diff --git a/include/asm-blackfin/mach-bf533/bf533.h b/include/asm-blackfin/mach-bf533/bf533.h
index 185fc12..41e4e83 100644
--- a/include/asm-blackfin/mach-bf533/bf533.h
+++ b/include/asm-blackfin/mach-bf533/bf533.h
@@ -226,7 +226,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
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
 
diff --git a/include/asm-blackfin/mach-bf533/cdefBF532.h b/include/asm-blackfin/mach-bf533/cdefBF532.h
index 74f967b..40c1ad3 100644
--- a/include/asm-blackfin/mach-bf533/cdefBF532.h
+++ b/include/asm-blackfin/mach-bf533/cdefBF532.h
@@ -30,11 +30,9 @@
 
 #ifndef _CDEF_BF532_H
 #define _CDEF_BF532_H
-/*
-#if !defined(__ADSPLPBLACKFIN__)
-#warning cdefBF532.h should only be included for 532 compatible chips.
-#endif
-*/
+
+#include <asm/blackfin.h>
+
 /*include all Core registers and bit definitions*/
 #include "defBF532.h"
 
@@ -65,7 +63,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
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
diff --git a/include/asm-blackfin/mach-bf537/anomaly.h b/include/asm-blackfin/mach-bf537/anomaly.h
index 4453e61..dc736c6 100644
--- a/include/asm-blackfin/mach-bf537/anomaly.h
+++ b/include/asm-blackfin/mach-bf537/anomaly.h
@@ -1,139 +1,143 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf537/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
+ * File: include/asm-blackfin/mach-bf537/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision J, June 1, 2006; ADSP-BF537 Blackfin Processor Anomaly List
- *  - Revision I, June 1, 2006; ADSP-BF536 Blackfin Processor Anomaly List
- *  - Revision J, June 1, 2006; ADSP-BF534 Blackfin Processor Anomaly List
+ *  - Revision M, March 13, 2007; ADSP-BF537 Blackfin Processor Anomaly List
+ *  - Revision L, March 13, 2007; ADSP-BF536 Blackfin Processor Anomaly List
+ *  - Revision M, March 13, 2007; ADSP-BF534 Blackfin Processor Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
 /* We do not support 0.1 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1))
-#error Kernel will not work on BF537/6/4 Version 0.1
+#if __SILICON_REVISION__ < 2
+# error Kernel will not work on BF537 silicon version 0.0 or 0.1
 #endif
 
-#if (defined(CONFIG_BF_REV_0_3) || defined(CONFIG_BF_REV_0_2))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-                            Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-                            registers. */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits*/
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000247 /* CLKIN Buffer Output Enable Reset Behavior Is
-                            Changed */
-#endif
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            SPORT external receive and transmit clocks. */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000273 /* Writes to Synchronous SDRAM memory may be lost */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-                            control */
-#define ANOMALY_05000283 /* A system MMR write is stalled indefinitely when
-                            killed in a particular stage*/
-#define ANOMALY_05000310 /* False hardware errors caused by fetches at the
-			  *  boundary of reserved memory */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
-#define ANOMALY_05000313 /* PPI is level sensitive on first transfer */
-#define ANOMALY_05000322 /* EMAC RMII mode at 10-Base-T speed: RX frames not
-			  *  received properly */
+#if defined(__ADSPBF534__)
+# define ANOMALY_BF534 1
+#else
+# define ANOMALY_BF534 0
 #endif
-
-#if defined(CONFIG_BF_REV_0_2)
-#define ANOMALY_05000244 /* With instruction cache enabled, a CSYNC or SSYNC or
-                            IDLE around a Change of Control causes
-                            unpredictable results */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000252 /* EMAC Tx DMA error after an early frame abort */
+#if defined(__ADSPBF536__)
+# define ANOMALY_BF536 1
+#else
+# define ANOMALY_BF536 0
 #endif
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-                            interrupt not functional */
-#if (defined(CONFIG_BF537) || defined(CONFIG_BF536))
-#define ANOMALY_05000256 /* EMAC MDIO input latched on wrong MDC edge */
+#if defined(__ADSPBF537__)
+# define ANOMALY_BF537 1
+#else
+# define ANOMALY_BF537 0
 #endif
-#define ANOMALY_05000257 /* An interrupt or exception during short Hardware
-                            loops may cause the instruction fetch unit to
-                            malfunction */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bit 9 and 12 of
-                            the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB exception */
-#define ANOMALY_05000264 /* A Sync instruction (CSYNC, SSYNC) or an IDLE
-                            instruction will cause an infinite stall in the
-                            second to last instruction in a hardware loop */
-#define ANOMALY_05000268 /* Memory DMA error when peripheral DMA is running
-                            and non-zero DEB_TRAFFIC_PERIOD value */
-#define ANOMALY_05000270 /* High I/O activity causes the output voltage of the
-                            internal voltage regulator (VDDint) to decrease */
-#define ANOMALY_05000277 /* Writes to a flag data register one SCLK cycle after
-                            an edge is detected may clear interrupt */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000280 /* SPI Master boot mode does not work well with
-                            Atmel Dataflash devices */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context
-			  *  is not restored */
-#define ANOMALY_05000282 /* Memory DMA corruption with 32-bit data and traffic
-			  *  control */
-#define ANOMALY_05000283 /* System MMR Write Is Stalled Indefinitely When
-			  *  Killed in a Particular Stage */
-#define ANOMALY_05000285 /* New Feature: EMAC TX DMA Word Alignment
-			  *  (Not Available On Older Silicon) */
-#define ANOMALY_05000288 /* SPORTs may receive bad data if FIFOs fill up */
-#define ANOMALY_05000315 /* Killed System MMR Write Completes Erroneously
-			  *  On Next System MMR Access */
-#define ANOMALY_05000316 /* EMAC RMII mode: collisions occur in Full Duplex
-			  *  mode */
-#define ANOMALY_05000321 /* EMAC RMII mode: TX frames in half duplex fail with
-			  *  status No Carrier */
-#endif  /* CONFIG_BF_REV_0_2 */
 
-#endif /* _MACH_ANOMALY_H_ */
+/* Multi-issue instruction with dsp32shiftimm in slot1 and P-reg store in slot 2 not supported */
+#define ANOMALY_05000074 (1)
+/* DMA_RUN bit is not valid after a Peripheral Receive Channel DMA stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H cannot be used to access 16-bit System MMR registers */
+#define ANOMALY_05000122 (1)
+/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 2)
+/* PPI Data Lengths Between 8 and 16 do not zero out upper bits*/
+#define ANOMALY_05000166 (1)	/* XXX: deleted from BF537 sheet ? */
+/* PPI_DELAY not functional in PPI modes with 0 frame syncs */
+#define ANOMALY_05000180 (1)
+/* Instruction Cache Is Not Functional */
+#define ANOMALY_05000237 (__SILICON_REVISION__ < 2)
+/* If i-cache is on, CSYNC/SSYNC/IDLE around Change of Control causes failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 3)
+/* Spurious Hardware Error from an access in the shadow of a conditional branch */
+#define ANOMALY_05000245 (1)
+/* CLKIN Buffer Output Enable Reset Behavior Is Changed */
+#define ANOMALY_05000247 (1)
+/* Incorrect Bit-Shift of Data Word in Multichannel (TDM) mode in certain conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ < 3)
+/* EMAC Tx DMA error after an early frame abort */
+#define ANOMALY_05000252 (__SILICON_REVISION__ < 3)
+/* Maximum external clock speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 3)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT mode with external clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 2)
+/* Entering Hibernate Mode with RTC Seconds event interrupt not functional */
+#define ANOMALY_05000255 (__SILICON_REVISION__ < 3)
+/* EMAC MDIO input latched on wrong MDC edge */
+#define ANOMALY_05000256 (__SILICON_REVISION__ < 3)
+/* Interrupt/Exception during short hardware loop may cause bad instruction fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 3)
+/* Instruction Cache is corrupted when bits 9 and 12 of the ICPLB Data registers differ */
+#define ANOMALY_05000258 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ == 1) || __SILICON_REVISION__ == 2)
+/* ICPLB_STATUS MMR register may be corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ == 2)
+/* DCPLB_FAULT_ADDR MMR register may be corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 3)
+/* Stores to data cache may be lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 3)
+/* Hardware loop corrupted when taking an ICPLB exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ == 2)
+/* CSYNC/SSYNC/IDLE causes infinite stall in second to last instruction in hardware loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 3)
+/* Sensitivity to noise with slow input edge rates on external SPORT TX and RX clocks */
+#define ANOMALY_05000265 (1)
+/* Memory DMA error when peripheral DMA is running with non-zero DEB_TRAFFIC_PERIOD */
+#define ANOMALY_05000268 (__SILICON_REVISION__ < 3)
+/* High I/O activity causes output voltage of internal voltage regulator (VDDint) to decrease */
+#define ANOMALY_05000270 (__SILICON_REVISION__ < 3)
+/* Certain data cache write through modes fail for VDDint <=0.9V */
+#define ANOMALY_05000272 (1)
+/* Writes to Synchronous SDRAM memory may be lost */
+#define ANOMALY_05000273 (__SILICON_REVISION__ < 3)
+/* Writes to an I/O data register one SCLK cycle after an edge is detected may clear interrupt */
+#define ANOMALY_05000277 (__SILICON_REVISION__ < 3)
+/* Disabling Peripherals with DMA running may cause DMA system instability */
+#define ANOMALY_05000278 (((ANOMALY_BF536 || ANOMALY_BF537) && __SILICON_REVISION__ < 3) || (ANOMALY_BF534 && __SILICON_REVISION__ < 2))
+/* SPI Master boot mode does not work well with Atmel Data flash devices */
+#define ANOMALY_05000280 (1)
+/* False Hardware Error Exception when ISR context is not restored */
+#define ANOMALY_05000281 (__SILICON_REVISION__ < 3)
+/* Memory DMA corruption with 32-bit data and traffic control */
+#define ANOMALY_05000282 (__SILICON_REVISION__ < 3)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (__SILICON_REVISION__ < 3)
+/* New Feature: EMAC TX DMA Word Alignment (Not Available On Older Silicon) */
+#define ANOMALY_05000285 (__SILICON_REVISION__ < 3)
+/* SPORTs may receive bad data if FIFOs fill up */
+#define ANOMALY_05000288 (__SILICON_REVISION__ < 3)
+/* Memory to memory DMA source/destination descriptors must be in same memory space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always Handled Correctly */
+#define ANOMALY_05000304 (__SILICON_REVISION__ < 3)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 3)
+/* SCKELOW Bit Does Not Maintain State Through Hibernate */
+#define ANOMALY_05000307 (__SILICON_REVISION__ < 3)
+/* Writing UART_THR while UART clock is disabled sends erroneous start bit */
+#define ANOMALY_05000309 (__SILICON_REVISION__ < 3)
+/* False hardware errors caused by fetches at the boundary of reserved memory */
+#define ANOMALY_05000310 (1)
+/* Errors when SSYNC, CSYNC, or loads to LT, LB and LC registers are interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI is level sensitive on first transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode: collisions occur in Full Duplex mode */
+#define ANOMALY_05000316 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode: TX frames in half duplex fail with status No Carrier */
+#define ANOMALY_05000321 (__SILICON_REVISION__ < 3)
+/* EMAC RMII mode at 10-Base-T speed: RX frames not received properly */
+#define ANOMALY_05000322 (1)
+
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000125 (0)
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000198 (0)
+#define ANOMALY_05000266 (0)
+#define ANOMALY_05000311 (0)
+
+#endif
diff --git a/include/asm-blackfin/mach-bf537/bf537.h b/include/asm-blackfin/mach-bf537/bf537.h
index b8924cd..04b0816 100644
--- a/include/asm-blackfin/mach-bf537/bf537.h
+++ b/include/asm-blackfin/mach-bf537/bf537.h
@@ -206,7 +206,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
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
diff --git a/include/asm-blackfin/mach-bf537/cdefBF534.h b/include/asm-blackfin/mach-bf537/cdefBF534.h
index 84e58fa..78227bc 100644
--- a/include/asm-blackfin/mach-bf537/cdefBF534.h
+++ b/include/asm-blackfin/mach-bf537/cdefBF534.h
@@ -32,6 +32,8 @@
 #ifndef _CDEF_BF534_H
 #define _CDEF_BF534_H
 
+#include <asm/blackfin.h>
+
 /* Include all Core registers and bit definitions 									*/
 #include "defBF534.h"
 
@@ -57,7 +59,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR, IWR_ENABLE(0));
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
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
diff --git a/include/asm-blackfin/mach-bf548/anomaly.h b/include/asm-blackfin/mach-bf548/anomaly.h
index aca1d4b..37e0bd2 100644
--- a/include/asm-blackfin/mach-bf548/anomaly.h
+++ b/include/asm-blackfin/mach-bf548/anomaly.h
@@ -1,74 +1,70 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf548/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * File: include/asm-blackfin/mach-bf548/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+/* This file shoule be up to date with:
+ *  - Revision B, April 6, 2007; ADSP-BF549 Silicon Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-			    slot1 and store of a P register in slot 2 is not
-			    supported */
-#define ANOMALY_05000119 /* DMA_RUN bit is not valid after a Peripheral Receive
-			    Channel DMA stops */
-#define ANOMALY_05000122 /* Rx.H can not be used to access 16-bit System MMR
-			    registers. */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an Access in the
-			    Shadow of a Conditional Branch */
-#define ANOMALY_05000255 /* Entering Hibernate Mode with RTC Seconds event
-			    interrupt not functional */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-			    SPORT external receive and transmit clocks. */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-			    VDDint <=0.9V */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-			    not restored */
-#define ANOMALY_05000310 /* False Hardware Errors Caused by Fetches at the
-			    Boundary of Reserved Memory */
-#define ANOMALY_05000312 /* Errors When SSYNC, CSYNC, or Loads to LT, LB and
-			    LC Registers Are Interrupted */
-#define ANOMALY_05000324 /* TWI Slave Boot Mode Is Not Functional */
-#define ANOMALY_05000325 /* External FIFO Boot Mode Is Not Functional */
-#define ANOMALY_05000327 /* Data Lost When Core and DMA Accesses Are Made to
-			    the USB FIFO Simultaneously */
-#define ANOMALY_05000328 /* Incorrect Access of OTP_STATUS During otp_write()
-			    function */
-#define ANOMALY_05000329 /* Synchronous Burst Flash Boot Mode Is Not Functional
-			    */
-#define ANOMALY_05000330 /* Host DMA Boot Mode Is Not Functional */
-#define ANOMALY_05000334 /* Inadequate Timing Margins on DDR DQS to DQ and DQM
-			    Skew */
-#define ANOMALY_05000335 /* Inadequate Rotary Debounce Logic Duration */
-#define ANOMALY_05000336 /* Phantom Interrupt Occurs After First Configuration
-			    of Host DMA Port */
-#define ANOMALY_05000337 /* Disallowed Configuration Prevents Subsequent
-			    Allowed Configuration on Host DMA Port */
-#define ANOMALY_05000338 /* Slave-Mode SPI0 MISO Failure With CPHA = 0 */
 
-#endif /* _MACH_ANOMALY_H_ */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* DMA_RUN Bit Is Not Valid after a Peripheral Receive Channel DMA Stops */
+#define ANOMALY_05000119 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (1)
+/* Entering Hibernate State with RTC Seconds Interrupt Not Functional */
+#define ANOMALY_05000255 (1)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (1)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* False Hardware Error Exception when ISR context is not restored */
+#define ANOMALY_05000281 (1)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* TWI Slave Boot Mode Is Not Functional */
+#define ANOMALY_05000324 (1)
+/* External FIFO Boot Mode Is Not Functional */
+#define ANOMALY_05000325 (1)
+/* Data Lost When Core and DMA Accesses Are Made to the USB FIFO Simultaneously */
+#define ANOMALY_05000327 (1)
+/* Incorrect Access of OTP_STATUS During otp_write() Function */
+#define ANOMALY_05000328 (1)
+/* Synchronous Burst Flash Boot Mode Is Not Functional */
+#define ANOMALY_05000329 (1)
+/* Host DMA Boot Mode Is Not Functional */
+#define ANOMALY_05000330 (1)
+/* Inadequate Timing Margins on DDR DQS to DQ and DQM Skew */
+#define ANOMALY_05000334 (1)
+/* Inadequate Rotary Debounce Logic Duration */
+#define ANOMALY_05000335 (1)
+/* Phantom Interrupt Occurs After First Configuration of Host DMA Port */
+#define ANOMALY_05000336 (1)
+/* Disallowed Configuration Prevents Subsequent Allowed Configuration on Host DMA Port */
+#define ANOMALY_05000337 (1)
+/* Slave-Mode SPI0 MISO Failure With CPHA = 0 */
+#define ANOMALY_05000338 (1)
+
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000125 (0)
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000198 (0)
+#define ANOMALY_05000244 (0)
+#define ANOMALY_05000261 (0)
+#define ANOMALY_05000263 (0)
+#define ANOMALY_05000266 (0)
+#define ANOMALY_05000273 (0)
+#define ANOMALY_05000311 (0)
+
+#endif
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
diff --git a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
index 98d35a9..aefab3f 100644
--- a/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/cdefBF54x_base.h
@@ -31,6 +31,8 @@
 #ifndef _CDEF_BF54X_H
 #define _CDEF_BF54X_H
 
+#include <asm/blackfin.h>
+
 #include "defBF54x_base.h"
 #include <asm/system.h>
 
@@ -60,7 +62,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR2, 0);
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
@@ -242,6 +244,39 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_read_TWI0_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
 #define bfin_write_TWI0_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
 
+#define bfin_read_TWI_CLKDIV()			bfin_read16(TWI0_CLKDIV)
+#define bfin_write_TWI_CLKDIV(val)		bfin_write16(TWI0_CLKDIV, val)
+#define bfin_read_TWI_CONTROL()			bfin_read16(TWI0_CONTROL)
+#define bfin_write_TWI_CONTROL(val)		bfin_write16(TWI0_CONTROL, val)
+#define bfin_read_TWI_SLAVE_CTRL()		bfin_read16(TWI0_SLAVE_CTRL)
+#define bfin_write_TWI_SLAVE_CTRL(val)		bfin_write16(TWI0_SLAVE_CTRL, val)
+#define bfin_read_TWI_SLAVE_STAT()		bfin_read16(TWI0_SLAVE_STAT)
+#define bfin_write_TWI_SLAVE_STAT(val)		bfin_write16(TWI0_SLAVE_STAT, val)
+#define bfin_read_TWI_SLAVE_ADDR()		bfin_read16(TWI0_SLAVE_ADDR)
+#define bfin_write_TWI_SLAVE_ADDR(val)		bfin_write16(TWI0_SLAVE_ADDR, val)
+#define bfin_read_TWI_MASTER_CTL()		bfin_read16(TWI0_MASTER_CTRL)
+#define bfin_write_TWI_MASTER_CTL(val)		bfin_write16(TWI0_MASTER_CTRL, val)
+#define bfin_read_TWI_MASTER_STAT()		bfin_read16(TWI0_MASTER_STAT)
+#define bfin_write_TWI_MASTER_STAT(val)		bfin_write16(TWI0_MASTER_STAT, val)
+#define bfin_read_TWI_MASTER_ADDR()		bfin_read16(TWI0_MASTER_ADDR)
+#define bfin_write_TWI_MASTER_ADDR(val)		bfin_write16(TWI0_MASTER_ADDR, val)
+#define bfin_read_TWI_INT_STAT()		bfin_read16(TWI0_INT_STAT)
+#define bfin_write_TWI_INT_STAT(val)		bfin_write16(TWI0_INT_STAT, val)
+#define bfin_read_TWI_INT_MASK()		bfin_read16(TWI0_INT_MASK)
+#define bfin_write_TWI_INT_MASK(val)		bfin_write16(TWI0_INT_MASK, val)
+#define bfin_read_TWI_FIFO_CTL()		bfin_read16(TWI0_FIFO_CTRL)
+#define bfin_write_TWI_FIFO_CTL(val)		bfin_write16(TWI0_FIFO_CTRL, val)
+#define bfin_read_TWI_FIFO_STAT()		bfin_read16(TWI0_FIFO_STAT)
+#define bfin_write_TWI_FIFO_STAT(val)		bfin_write16(TWI0_FIFO_STAT, val)
+#define bfin_read_TWI_XMT_DATA8()		bfin_read16(TWI0_XMT_DATA8)
+#define bfin_write_TWI_XMT_DATA8(val)		bfin_write16(TWI0_XMT_DATA8, val)
+#define bfin_read_TWI_XMT_DATA16()		bfin_read16(TWI0_XMT_DATA16)
+#define bfin_write_TWI_XMT_DATA16(val)		bfin_write16(TWI0_XMT_DATA16, val)
+#define bfin_read_TWI_RCV_DATA8()		bfin_read16(TWI0_RCV_DATA8)
+#define bfin_write_TWI_RCV_DATA8(val)		bfin_write16(TWI0_RCV_DATA8, val)
+#define bfin_read_TWI_RCV_DATA16()		bfin_read16(TWI0_RCV_DATA16)
+#define bfin_write_TWI_RCV_DATA16(val)		bfin_write16(TWI0_RCV_DATA16, val)
+
 /* SPORT0 is not defined in the shared file because it is not available on the ADSP-BF542 and ADSP-BF544 bfin_read_()rocessors */
 
 /* SPORT1 Registers */
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
index 0b3325b..21f06f7 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -112,6 +112,7 @@ Events         (highest priority)  EMU         0
 #define IRQ_ATAPI_TX	BFIN_IRQ(44)	/* ATAPI TX (DMA11) Interrupt */
 #define IRQ_TWI0	BFIN_IRQ(45)	/* TWI0 Interrupt */
 #define IRQ_TWI1	BFIN_IRQ(46)	/* TWI1 Interrupt */
+#define IRQ_TWI		IRQ_TWI0	/* TWI Interrupt */
 #define IRQ_CAN0_RX	BFIN_IRQ(47)	/* CAN0 Receive Interrupt */
 #define IRQ_CAN0_TX	BFIN_IRQ(48)	/* CAN0 Transmit Interrupt */
 #define IRQ_MDMAS2	BFIN_IRQ(49)	/* MDMA Stream 2 Interrupt */
@@ -336,6 +337,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_PJ14	BFIN_PJ_IRQ(14)		/* N/A */
 #define IRQ_PJ15	BFIN_PJ_IRQ(15)		/* N/A */
 
+#define GPIO_IRQ_BASE	IRQ_PA0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PJ15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf561/anomaly.h b/include/asm-blackfin/mach-bf561/anomaly.h
index f5b32d6..4cb3337 100644
--- a/include/asm-blackfin/mach-bf561/anomaly.h
+++ b/include/asm-blackfin/mach-bf561/anomaly.h
@@ -1,184 +1,255 @@
-
 /*
- * File:         include/asm-blackfin/mach-bf561/anomaly.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * File: include/asm-blackfin/mach-bf561/anomaly.h
+ * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2004-2007 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
 /* This file shoule be up to date with:
- *  - Revision L, 10Aug2006; ADSP-BF561 Silicon Anomaly List
+ *  - Revision N, March 28, 2007; ADSP-BF561 Silicon Anomaly List
  */
 
 #ifndef _MACH_ANOMALY_H_
 #define _MACH_ANOMALY_H_
 
-/* We do not support 0.1 or 0.4 silicon - sorry */
-#if (defined(CONFIG_BF_REV_0_1) || defined(CONFIG_BF_REV_0_2) || defined(CONFIG_BF_REV_0_4))
-#error Kernel will not work on BF561 Version 0.1, 0.2, or 0.4
+/* We do not support 0.1, 0.2, or 0.4 silicon - sorry */
+#if __SILICON_REVISION__ < 3 || __SILICON_REVISION__ == 4
+# error Kernel will not work on BF561 silicon version 0.0, 0.1, 0.2, or 0.4
 #endif
 
-/* Issues that are common to 0.5 and  0.3 silicon */
-#if  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000074 /* A multi issue instruction with dsp32shiftimm in
-                            slot1 and store of a P register in slot 2 is not
-                            supported */
-#define ANOMALY_05000099 /* UART Line Status Register (UART_LSR) bits are not
-                            updated at the same time. */
-#define ANOMALY_05000120 /* Testset instructions restricted to 32-bit aligned
-                            memory locations */
-#define ANOMALY_05000122 /* Rx.H cannot be used to access 16-bit System MMR
-                            registers */
-#define ANOMALY_05000127 /* Signbits instruction not functional under certain
-                            conditions */
-#define ANOMALY_05000149 /* IMDMA S1/D1 channel may stall */
-#define ANOMALY_05000166 /* PPI Data Lengths Between 8 and 16 do not zero out
-                            upper bits */
-#define ANOMALY_05000167 /* Turning Serial Ports on With External Frame Syncs */
-#define ANOMALY_05000180 /* PPI_DELAY not functional in PPI modes with 0 frame
-                            syncs */
-#define ANOMALY_05000182 /* IMDMA does not operate to full speed for 600MHz
-                            and higher devices */
-#define ANOMALY_05000187 /* IMDMA Corrupted Data after a Halt */
-#define ANOMALY_05000190 /* PPI not functional at core voltage < 1Volt */
-#define ANOMALY_05000208 /* VSTAT status bit in PLL_STAT register is not
-                            functional */
-#define ANOMALY_05000245 /* Spurious Hardware Error from an access in the
-                            shadow of a conditional branch */
-#define ANOMALY_05000257 /* Interrupt/Exception during short hardware loop
-                            may cause bad instruction fetches */
-#define ANOMALY_05000265 /* Sensitivity to noise with slow input edge rates on
-                            external SPORT TX and RX clocks */
-#define ANOMALY_05000267 /* IMDMA may corrupt data under certain conditions */
-#define ANOMALY_05000269 /* High I/O activity causes output voltage of internal
-                            voltage regulator (VDDint) to increase */
-#define ANOMALY_05000270 /* High I/O activity causes output voltage of internal
-                            voltage regulator (VDDint) to decrease */
-#define ANOMALY_05000272 /* Certain data cache write through modes fail for
-                            VDDint <=0.9V */
-#define ANOMALY_05000274 /* Data cache write back to external synchronous memory
-                            may be lost */
-#define ANOMALY_05000275 /* PPI Timing and sampling informaton updates */
-#define ANOMALY_05000312 /* Errors when SSYNC, CSYNC, or loads to LT, LB and LC
-			    registers are interrupted */
+/* Multi-Issue Instruction with dsp32shiftimm in slot1 and P-reg Store in slot 2 Not Supported */
+#define ANOMALY_05000074 (1)
+/* UART Line Status Register (UART_LSR) Bits Are Not Updated at the Same Time */
+#define ANOMALY_05000099 (__SILICON_REVISION__ < 5)
+/* Trace Buffers may contain errors in emulation mode and/or exception, NMI, reset handlers */
+#define ANOMALY_05000116 (__SILICON_REVISION__ < 3)
+/* Testset instructions restricted to 32-bit aligned memory locations */
+#define ANOMALY_05000120 (1)
+/* Rx.H Cannot Be Used to Access 16-bit System MMR Registers */
+#define ANOMALY_05000122 (1)
+/* Erroneous exception when enabling cache */
+#define ANOMALY_05000125 (__SILICON_REVISION__ < 3)
+/* Signbits instruction not functional under certain conditions */
+#define ANOMALY_05000127 (1)
+/* Two bits in the Watchpoint Status Register (WPSTAT) are swapped */
+#define ANOMALY_05000134 (__SILICON_REVISION__ < 3)
+/* Enable wires from the Data Watchpoint Address Control Register (WPDACTL) are swapped */
+#define ANOMALY_05000135 (__SILICON_REVISION__ < 3)
+/* Stall in multi-unit DMA operations */
+#define ANOMALY_05000136 (__SILICON_REVISION__ < 3)
+/* Allowing the SPORT RX FIFO to fill will cause an overflow */
+#define ANOMALY_05000140 (__SILICON_REVISION__ < 3)
+/* Infinite Stall may occur with a particular sequence of consecutive dual dag events */
+#define ANOMALY_05000141 (__SILICON_REVISION__ < 3)
+/* Interrupts may be lost when a programmable input flag is configured to be edge sensitive */
+#define ANOMALY_05000142 (__SILICON_REVISION__ < 3)
+/* DMA and TESTSET conflict when both are accessing external memory */
+#define ANOMALY_05000144 (__SILICON_REVISION__ < 3)
+/* In PWM_OUT mode, you must enable the PPI block to generate a waveform from PPI_CLK */
+#define ANOMALY_05000145 (__SILICON_REVISION__ < 3)
+/* MDMA may lose the first few words of a descriptor chain */
+#define ANOMALY_05000146 (__SILICON_REVISION__ < 3)
+/* Source MDMA descriptor may stop with a DMA Error near beginning of descriptor fetch */
+#define ANOMALY_05000147 (__SILICON_REVISION__ < 3)
+/* IMDMA S1/D1 channel may stall */
+#define ANOMALY_05000149 (1)
+/* DMA engine may lose data due to incorrect handshaking */
+#define ANOMALY_05000150 (__SILICON_REVISION__ < 3)
+/* DMA stalls when all three controllers read data from the same source */
+#define ANOMALY_05000151 (__SILICON_REVISION__ < 3)
+/* Execution stall when executing in L2 and doing external accesses */
+#define ANOMALY_05000152 (__SILICON_REVISION__ < 3)
+/* Frame Delay in SPORT Multichannel Mode */
+#define ANOMALY_05000153 (__SILICON_REVISION__ < 3)
+/* SPORT TFS signal stays active in multichannel mode outside of valid channels */
+#define ANOMALY_05000154 (__SILICON_REVISION__ < 3)
+/* Timers in PWM-Out Mode with PPI GP Receive (Input) Mode with 0 Frame Syncs */
+#define ANOMALY_05000156 (__SILICON_REVISION__ < 4)
+/* Killed 32-bit MMR write leads to next system MMR access thinking it should be 32-bit */
+#define ANOMALY_05000157 (__SILICON_REVISION__ < 3)
+/* DMA Lock-up at CCLK to SCLK ratios of 4:1, 2:1, or 1:1 */
+#define ANOMALY_05000159 (__SILICON_REVISION__ < 3)
+/* A read from external memory may return a wrong value with data cache enabled */
+#define ANOMALY_05000160 (__SILICON_REVISION__ < 3)
+/* Data Cache Fill data can be corrupted after/during Instruction DMA if certain core stalls exist */
+#define ANOMALY_05000161 (__SILICON_REVISION__ < 3)
+/* DMEM_CONTROL<12> is not set on Reset */
+#define ANOMALY_05000162 (__SILICON_REVISION__ < 3)
+/* SPORT transmit data is not gated by external frame sync in certain conditions */
+#define ANOMALY_05000163 (__SILICON_REVISION__ < 3)
+/* PPI Data Lengths Between 8 and 16 Do Not Zero Out Upper Bits */
+#define ANOMALY_05000166 (1)
+/* Turning Serial Ports on with External Frame Syncs */
+#define ANOMALY_05000167 (1)
+/* SDRAM auto-refresh and subsequent Power Ups */
+#define ANOMALY_05000168 (__SILICON_REVISION__ < 5)
+/* DATA CPLB page miss can result in lost write-through cache data writes */
+#define ANOMALY_05000169 (__SILICON_REVISION__ < 5)
+/* Boot-ROM code modifies SICA_IWRx wakeup registers */
+#define ANOMALY_05000171 (__SILICON_REVISION__ < 5)
+/* DSPID register values incorrect */
+#define ANOMALY_05000172 (__SILICON_REVISION__ < 3)
+/* DMA vs Core accesses to external memory */
+#define ANOMALY_05000173 (__SILICON_REVISION__ < 3)
+/* Cache Fill Buffer Data lost */
+#define ANOMALY_05000174 (__SILICON_REVISION__ < 5)
+/* Overlapping Sequencer and Memory Stalls */
+#define ANOMALY_05000175 (__SILICON_REVISION__ < 5)
+/* Multiplication of (-1) by (-1) followed by an accumulator saturation */
+#define ANOMALY_05000176 (__SILICON_REVISION__ < 5)
+/* PPI_COUNT Cannot Be Programmed to 0 in General Purpose TX or RX Modes */
+#define ANOMALY_05000179 (__SILICON_REVISION__ < 5)
+/* PPI_DELAY Not Functional in PPI Modes with 0 Frame Syncs */
+#define ANOMALY_05000180 (1)
+/* Disabling the PPI resets the PPI configuration registers */
+#define ANOMALY_05000181 (__SILICON_REVISION__ < 5)
+/* IMDMA does not operate to full speed for 600MHz and higher devices */
+#define ANOMALY_05000182 (1)
+/* Timer Pin limitations for PPI TX Modes with External Frame Syncs */
+#define ANOMALY_05000184 (__SILICON_REVISION__ < 5)
+/* PPI TX Mode with 2 External Frame Syncs */
+#define ANOMALY_05000185 (__SILICON_REVISION__ < 5)
+/* PPI packing with Data Length greater than 8 bits (not a meaningful mode) */
+#define ANOMALY_05000186 (__SILICON_REVISION__ < 5)
+/* IMDMA Corrupted Data after a Halt */
+#define ANOMALY_05000187 (1)
+/* IMDMA Restrictions on Descriptor and Buffer Placement in Memory */
+#define ANOMALY_05000188 (__SILICON_REVISION__ < 5)
+/* False Protection Exceptions */
+#define ANOMALY_05000189 (__SILICON_REVISION__ < 5)
+/* PPI not functional at core voltage < 1Volt */
+#define ANOMALY_05000190 (1)
+/* PPI does not invert the Driving PPICLK edge in Transmit Modes */
+#define ANOMALY_05000191 (__SILICON_REVISION__ < 3)
+/* False I/O Pin Interrupts on Edge-Sensitive Inputs When Polarity Setting Is Changed */
+#define ANOMALY_05000193 (__SILICON_REVISION__ < 5)
+/* Restarting SPORT in Specific Modes May Cause Data Corruption */
+#define ANOMALY_05000194 (__SILICON_REVISION__ < 5)
+/* Failing MMR Accesses When Stalled by Preceding Memory Read */
+#define ANOMALY_05000198 (__SILICON_REVISION__ < 5)
+/* Current DMA Address Shows Wrong Value During Carry Fix */
+#define ANOMALY_05000199 (__SILICON_REVISION__ < 5)
+/* SPORT TFS and DT Are Incorrectly Driven During Inactive Channels in Certain Conditions */
+#define ANOMALY_05000200 (__SILICON_REVISION__ < 5)
+/* Possible Infinite Stall with Specific Dual-DAG Situation */
+#define ANOMALY_05000202 (__SILICON_REVISION__ < 5)
+/* Incorrect data read with write-through cache and allocate cache lines on reads only mode */
+#define ANOMALY_05000204 (__SILICON_REVISION__ < 5)
+/* Specific sequence that can cause DMA error or DMA stopping */
+#define ANOMALY_05000205 (__SILICON_REVISION__ < 5)
+/* Recovery from "Brown-Out" Condition */
+#define ANOMALY_05000207 (__SILICON_REVISION__ < 5)
+/* VSTAT Status Bit in PLL_STAT Register Is Not Functional */
+#define ANOMALY_05000208 (1)
+/* Speed Path in Computational Unit Affects Certain Instructions */
+#define ANOMALY_05000209 (__SILICON_REVISION__ < 5)
+/* UART TX Interrupt Masked Erroneously */
+#define ANOMALY_05000215 (__SILICON_REVISION__ < 5)
+/* NMI Event at Boot Time Results in Unpredictable State */
+#define ANOMALY_05000219 (__SILICON_REVISION__ < 5)
+/* Data Corruption with Cached External Memory and Non-Cached On-Chip L2 Memory */
+#define ANOMALY_05000220 (__SILICON_REVISION__ < 5)
+/* Incorrect Pulse-Width of UART Start Bit */
+#define ANOMALY_05000225 (__SILICON_REVISION__ < 5)
+/* Scratchpad Memory Bank Reads May Return Incorrect Data */
+#define ANOMALY_05000227 (__SILICON_REVISION__ < 5)
+/* UART Receiver is Less Robust Against Baudrate Differences in Certain Conditions */
+#define ANOMALY_05000230 (__SILICON_REVISION__ < 5)
+/* UART STB Bit Incorrectly Affects Receiver Setting */
+#define ANOMALY_05000231 (__SILICON_REVISION__ < 5)
+/* SPORT data transmit lines are incorrectly driven in multichannel mode */
+#define ANOMALY_05000232 (__SILICON_REVISION__ < 5)
+/* DF Bit in PLL_CTL Register Does Not Respond to Hardware Reset */
+#define ANOMALY_05000242 (__SILICON_REVISION__ < 5)
+/* If I-Cache Is On, CSYNC/SSYNC/IDLE Around Change of Control Causes Failures */
+#define ANOMALY_05000244 (__SILICON_REVISION__ < 5)
+/* Spurious Hardware Error from an Access in the Shadow of a Conditional Branch */
+#define ANOMALY_05000245 (__SILICON_REVISION__ < 5)
+/* TESTSET operation forces stall on the other core */
+#define ANOMALY_05000248 (__SILICON_REVISION__ < 5)
+/* Incorrect Bit Shift of Data Word in Multichannel (TDM) Mode in Certain Conditions */
+#define ANOMALY_05000250 (__SILICON_REVISION__ > 2 && __SILICON_REVISION__ < 5)
+/* Exception Not Generated for MMR Accesses in Reserved Region */
+#define ANOMALY_05000251 (__SILICON_REVISION__ < 5)
+/* Maximum External Clock Speed for Timers */
+#define ANOMALY_05000253 (__SILICON_REVISION__ < 5)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with External Clock */
+#define ANOMALY_05000254 (__SILICON_REVISION__ > 3)
+/* Interrupt/Exception During Short Hardware Loop May Cause Bad Instruction Fetches */
+#define ANOMALY_05000257 (__SILICON_REVISION__ < 5)
+/* Instruction Cache Is Corrupted When Bits 9 and 12 of the ICPLB Data Registers Differ */
+#define ANOMALY_05000258 (__SILICON_REVISION__ < 5)
+/* ICPLB_STATUS MMR Register May Be Corrupted */
+#define ANOMALY_05000260 (__SILICON_REVISION__ < 5)
+/* DCPLB_FAULT_ADDR MMR Register May Be Corrupted */
+#define ANOMALY_05000261 (__SILICON_REVISION__ < 5)
+/* Stores To Data Cache May Be Lost */
+#define ANOMALY_05000262 (__SILICON_REVISION__ < 5)
+/* Hardware Loop Corrupted When Taking an ICPLB Exception */
+#define ANOMALY_05000263 (__SILICON_REVISION__ < 5)
+/* CSYNC/SSYNC/IDLE Causes Infinite Stall in Penultimate Instruction in Hardware Loop */
+#define ANOMALY_05000264 (__SILICON_REVISION__ < 5)
+/* Sensitivity To Noise with Slow Input Edge Rates on External SPORT TX and RX Clocks */
+#define ANOMALY_05000265 (__SILICON_REVISION__ < 5)
+/* IMDMA destination IRQ status must be read prior to using IMDMA */
+#define ANOMALY_05000266 (__SILICON_REVISION__ > 3)
+/* IMDMA may corrupt data under certain conditions */
+#define ANOMALY_05000267 (1)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Increase */
+#define ANOMALY_05000269 (1)
+/* High I/O Activity Causes Output Voltage of Internal Voltage Regulator (Vddint) to Decrease */
+#define ANOMALY_05000270 (1)
+/* Certain Data Cache Writethrough Modes Fail for Vddint <= 0.9V */
+#define ANOMALY_05000272 (1)
+/* Data cache write back to external synchronous memory may be lost */
+#define ANOMALY_05000274 (1)
+/* PPI Timing and Sampling Information Updates */
+#define ANOMALY_05000275 (__SILICON_REVISION__ > 2)
+/* Timing Requirements Change for External Frame Sync PPI Modes with Non-Zero PPI_DELAY */
+#define ANOMALY_05000276 (__SILICON_REVISION__ < 5)
+/* Disabling Peripherals with DMA Running May Cause DMA System Instability */
+#define ANOMALY_05000278 (__SILICON_REVISION__ < 5)
+/* False Hardware Error Exception When ISR Context Is Not Restored */
+#define ANOMALY_05000281 (__SILICON_REVISION__ < 5)
+/* System MMR Write Is Stalled Indefinitely When Killed in a Particular Stage */
+#define ANOMALY_05000283 (1)
+/* A read will receive incorrect data under certain conditions */
+#define ANOMALY_05000287 (__SILICON_REVISION__ < 5)
+/* SPORTs May Receive Bad Data If FIFOs Fill Up */
+#define ANOMALY_05000288 (__SILICON_REVISION__ < 5)
+/* Memory-To-Memory DMA Source/Destination Descriptors Must Be in Same Memory Space */
+#define ANOMALY_05000301 (1)
+/* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
+#define ANOMALY_05000302 (1)
+/* New Feature: Additional Hysteresis on SPORT Input Pins (Not Available On Older Silicon) */
+#define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
+/* SCKELOW Bit Does Not Maintain State Through Hibernate */
+#define ANOMALY_05000307 (__SILICON_REVISION__ < 5)
+/* False Hardware Errors Caused by Fetches at the Boundary of Reserved Memory */
+#define ANOMALY_05000310 (1)
+/* Errors When SSYNC, CSYNC, or Loads to LT, LB and LC Registers Are Interrupted */
+#define ANOMALY_05000312 (1)
+/* PPI Is Level-Sensitive on First Transfer */
+#define ANOMALY_05000313 (1)
+/* Killed System MMR Write Completes Erroneously On Next System MMR Access */
+#define ANOMALY_05000315 (1)
+/* PF2 Output Remains Asserted After SPI Master Boot */
+#define ANOMALY_05000320 (__SILICON_REVISION__ > 3)
+/* Erroneous GPIO Flag Pin Operations Under Specific Sequences */
+#define ANOMALY_05000323 (1)
+/* SPORT Secondary Receive Channel Not Functional When Word Length Exceeds 16 Bits */
+#define ANOMALY_05000326 (__SILICON_REVISION__ > 3)
+/* New Feature: 24-Bit SPI Boot Mode Support (Not Available On Older Silicon) */
+#define ANOMALY_05000331 (__SILICON_REVISION__ < 5)
+/* New Feature: Slave SPI Boot Mode Supported (Not Available On Older Silicon) */
+#define ANOMALY_05000332 (__SILICON_REVISION__ < 5)
+/* Flag Data Register Writes One SCLK Cycle After Edge Is Detected May Clear Interrupt Status */
+#define ANOMALY_05000333 (__SILICON_REVISION__ < 5)
 
-#endif /*  (defined(CONFIG_BF_REV_0_5) || defined(CONFIG_BF_REV_0_3)) */
+/* Anomalies that don't exist on this proc */
+#define ANOMALY_05000183 (0)
+#define ANOMALY_05000273 (0)
+#define ANOMALY_05000311 (0)
 
-#if  (defined(CONFIG_BF_REV_0_5))
-#define ANOMALY_05000254 /* Incorrect Timer Pulse Width in Single-Shot PWM_OUT
-                            mode with external clock */
-#define ANOMALY_05000266 /* IMDMA destination IRQ status must be read prior to
-                            using IMDMA */
 #endif
-
-#if  (defined(CONFIG_BF_REV_0_3))
-#define ANOMALY_05000156 /* Timers in PWM-Out Mode with PPI GP Receive (Input)
-                            Mode with 0 Frame Syncs */
-#define ANOMALY_05000168 /* SDRAM auto-refresh and subsequent Power Ups */
-#define ANOMALY_05000169 /* DATA CPLB page miss can result in lost write-through
-                            cache data writes */
-#define ANOMALY_05000171 /* Boot-ROM code modifies SICA_IWRx wakeup registers */
-#define ANOMALY_05000174 /* Cache Fill Buffer Data lost */
-#define ANOMALY_05000175 /* Overlapping Sequencer and Memory Stalls */
-#define ANOMALY_05000176 /* Multiplication of (-1) by (-1) followed by an
-                            accumulator saturation */
-#define ANOMALY_05000179 /* PPI_COUNT cannot be programmed to 0 in General
-                            Purpose TX or RX modes */
-#define ANOMALY_05000181 /* Disabling the PPI resets the PPI configuration
-                            registers */
-#define ANOMALY_05000184 /* Timer Pin limitations for PPI TX Modes with
-                            External Frame Syncs */
-#define ANOMALY_05000185 /* PPI TX Mode with 2 External Frame Syncs */
-#define ANOMALY_05000186 /* PPI packing with Data Length greater than 8 bits
-                            (not a meaningful mode) */
-#define ANOMALY_05000188 /* IMDMA Restrictions on Descriptor and Buffer
-                            Placement in Memory */
-#define ANOMALY_05000189 /* False Protection Exception */
-#define ANOMALY_05000193 /* False Flag Pin Interrupts on Edge Sensitive Inputs
-                            when polarity setting is changed */
-#define ANOMALY_05000194 /* Restarting SPORT in specific modes may cause data
-                            corruption */
-#define ANOMALY_05000198 /* Failing MMR accesses when stalled by preceding
-                            memory read */
-#define ANOMALY_05000199 /* DMA current address shows wrong value during carry
-                            fix */
-#define ANOMALY_05000200 /* SPORT TFS and DT are incorrectly driven during
-                            inactive channels in certain conditions */
-#define ANOMALY_05000202 /* Possible infinite stall with specific dual-DAG
-                            situation */
-#define ANOMALY_05000204 /* Incorrect data read with write-through cache and
-                            allocate cache lines on reads only mode */
-#define ANOMALY_05000205 /* Specific sequence that can cause DMA error or DMA
-                            stopping */
-#define ANOMALY_05000207 /* Recovery from "brown-out" condition */
-#define ANOMALY_05000209 /* Speed-Path in computational unit affects certain
-                            instructions */
-#define ANOMALY_05000215 /* UART TX Interrupt masked erroneously */
-#define ANOMALY_05000219 /* NMI event at boot time results in unpredictable
-                            state */
-#define ANOMALY_05000220 /* Data Corruption with Cached External Memory and
-                            Non-Cached On-Chip L2 Memory */
-#define ANOMALY_05000225 /* Incorrect pulse-width of UART start-bit */
-#define ANOMALY_05000227 /* Scratchpad memory bank reads may return incorrect
-                            data */
-#define ANOMALY_05000230 /* UART Receiver is less robust against Baudrate
-                            Differences in certain Conditions */
-#define ANOMALY_05000231 /* UART STB bit incorrectly affects receiver setting */
-#define ANOMALY_05000232 /* SPORT data transmit lines are incorrectly driven in
-                            multichannel mode */
-#define ANOMALY_05000242 /* DF bit in PLL_CTL register does not respond to
-                            hardware reset */
-#define ANOMALY_05000244 /* If i-cache is on, CSYNC/SSYNC/IDLE around Change of
-                            Control causes failures */
-#define ANOMALY_05000248 /* TESTSET operation forces stall on the other core */
-#define ANOMALY_05000250 /* Incorrect Bit-Shift of Data Word in Multichannel
-                            (TDM) mode in certain conditions */
-#define ANOMALY_05000251 /* Exception not generated for MMR accesses in
-                            reserved region */
-#define ANOMALY_05000253 /* Maximum external clock speed for Timers */
-#define ANOMALY_05000258 /* Instruction Cache is corrupted when bits 9 and 12
-                            of the ICPLB Data registers differ */
-#define ANOMALY_05000260 /* ICPLB_STATUS MMR register may be corrupted */
-#define ANOMALY_05000261 /* DCPLB_FAULT_ADDR MMR register may be corrupted */
-#define ANOMALY_05000262 /* Stores to data cache may be lost */
-#define ANOMALY_05000263 /* Hardware loop corrupted when taking an ICPLB
-                            exception */
-#define ANOMALY_05000264 /* CSYNC/SSYNC/IDLE causes infinite stall in second
-                            to last instruction in hardware loop */
-#define ANOMALY_05000276 /* Timing requirements change for External Frame
-                            Sync PPI Modes with non-zero PPI_DELAY */
-#define ANOMALY_05000278 /* Disabling Peripherals with DMA running may cause
-                            DMA system instability */
-#define ANOMALY_05000281 /* False Hardware Error Exception when ISR context is
-                            not restored */
-#define ANOMALY_05000283 /* An MMR write is stalled indefinitely when killed
-                            in a particular stage */
-#define ANOMALY_05000287 /* A read will receive incorrect data under certain
-                            conditions */
-#define ANOMALY_05000288 /* SPORTs may receive bad data if FIFOs fill up */
-#endif
-
-#endif /* _MACH_ANOMALY_H_ */
diff --git a/include/asm-blackfin/mach-bf561/bf561.h b/include/asm-blackfin/mach-bf561/bf561.h
index 96a5d3a..8cc2e00 100644
--- a/include/asm-blackfin/mach-bf561/bf561.h
+++ b/include/asm-blackfin/mach-bf561/bf561.h
@@ -311,7 +311,7 @@
 #define CONFIG_CCLK_ACT_DIV   CONFIG_CCLK_DIV_not_defined_properly
 #endif
 
-#if defined(ANOMALY_05000273) && (CONFIG_CCLK_DIV == 1)
+#if ANOMALY_05000273 && (CONFIG_CCLK_DIV == 1)
 #error ANOMALY 05000273, please make sure CCLK is at least 2x SCLK
 #endif
 
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
 
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 1a8ec9e..de97479 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -31,11 +31,8 @@
 #ifndef _CDEF_BF561_H
 #define _CDEF_BF561_H
 
-/*
-#if !defined(__ADSPBF561__)
-#warning cdefBF561.h should only be included for BF561 chip.
-#endif
-*/
+#include <asm/blackfin.h>
+
 /* include all Core registers and bit definitions */
 #include "defBF561.h"
 
@@ -67,7 +64,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SICA_IWR1, 0);
 
 	bfin_write16(VR_CTL, val);
-	__builtin_bfin_ssync();
+	SSYNC();
 
 	local_irq_save(flags);
 	asm("IDLE;");
@@ -81,6 +78,12 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_write_PLL_LOCKCNT(val)          bfin_write16(PLL_LOCKCNT,val)
 #define bfin_read_CHIPID()                   bfin_read32(CHIPID)
 
+/* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
+#define bfin_read_SWRST()                    bfin_read_SICA_SWRST()
+#define bfin_write_SWRST()                   bfin_write_SICA_SWRST()
+#define bfin_read_SYSCR()                    bfin_read_SICA_SYSCR()
+#define bfin_write_SYSCR()                   bfin_write_SICA_SYSCR()
+
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define bfin_read_SICA_SWRST()               bfin_read16(SICA_SWRST)
 #define bfin_write_SICA_SWRST(val)           bfin_write16(SICA_SWRST,val)
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h b/include/asm-blackfin/mach-bf561/defBF561.h
index 89150ec..0f2dc6e 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -52,6 +52,10 @@
 #define PLL_LOCKCNT            0xFFC00010	/* PLL Lock Count register (16-bit) */
 #define CHIPID                 0xFFC00014       /* Chip ID Register */
 
+/* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
+#define SWRST                   SICA_SWRST
+#define SYSCR                   SICA_SYSCR
+
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define SICA_SWRST              0xFFC00100	/* Software Reset register */
 #define SICA_SYSCR              0xFFC00104	/* System Reset Configuration register */
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
diff --git a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
index 94ed381..ede210e 100644
--- a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
@@ -39,7 +39,7 @@
 #define bfin_read_SRAM_BASE_ADDRESS()        bfin_read32(SRAM_BASE_ADDRESS)
 #define bfin_write_SRAM_BASE_ADDRESS(val)    bfin_write32(SRAM_BASE_ADDRESS,val)
 #define bfin_read_DMEM_CONTROL()             bfin_read32(DMEM_CONTROL)
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 extern void bfin_write_DMEM_CONTROL(unsigned int val);
 #else
 #define bfin_write_DMEM_CONTROL(val)         bfin_write32(DMEM_CONTROL,val)
@@ -129,7 +129,7 @@ extern void bfin_write_DMEM_CONTROL(unsigned int val);
 #define DTEST_DATA3            0xFFE0040C
 */
 #define bfin_read_IMEM_CONTROL()             bfin_read32(IMEM_CONTROL)
-#ifdef ANOMALY_05000125
+#if ANOMALY_05000125
 extern void bfin_write_IMEM_CONTROL(unsigned int val);
 #else
 #define bfin_write_IMEM_CONTROL(val)         bfin_write32(IMEM_CONTROL,val)
diff --git a/include/asm-blackfin/mach-common/def_LPBlackfin.h b/include/asm-blackfin/mach-common/def_LPBlackfin.h
index be1ece8..260515d 100644
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -33,81 +33,77 @@
 
 #include <asm/mach/anomaly.h>
 
-/*#if !defined(__ADSPLPBLACKFIN__)
-#warning def_LPBlackfin.h should only be included for 532 compatible chips.
-#endif
-*/
-
 #define MK_BMSK_(x) (1<<x)
 
-#if defined(ANOMALY_05000198)
-
-#define bfin_read8(addr) ({ unsigned char __v; \
-		__asm__ __volatile__ ("NOP;\n\t" \
-			"%0 = b[%1] (z);\n\t" \
-			: "=d"(__v) : "a"(addr)); \
-		__v; })
-
-#define bfin_read16(addr) ({ unsigned __v; \
-                       __asm__ __volatile__ ("NOP;\n\t"\
-	         			     			"%0 = w[%1] (z);\n\t"\
-  : "=d"(__v) : "a"(addr)); (unsigned short)__v; })
-
-#define bfin_read32(addr) ({ unsigned __v; \
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "%0 = [%1];\n\t"\
-  : "=d"(__v) : "a"(addr)); __v; })
+#ifndef __ASSEMBLY__
 
-#define bfin_write8(addr, val) ({ \
-		__asm__ __volatile__ ("NOP;\n\t" \
-			"b[%0] = %1;\n\t" \
-			: : "a"(addr), "d"(val) : "memory");})
-
-#define bfin_write16(addr,val) ({\
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "w[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
-#define bfin_write32(addr,val) ({\
-                      __asm__ __volatile__ ("NOP;\n\t"\
-                                            "[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
+#include <linux/types.h>
 
+#if ANOMALY_05000198
+# define NOP_PAD_ANOMALY_05000198 "nop;"
 #else
-
-#define bfin_read8(addr) ({ unsigned char __v; \
-		__asm__ __volatile__ ( \
-			"%0 = b[%1] (z);\n\t" \
-			:"=d"(__v) : "a"(addr)); \
-		__v; })
-
-#define bfin_read16(addr) ({ unsigned __v; \
-                       __asm__ __volatile__ (\
-	         			     			"%0 = w[%1] (z);\n\t"\
-  : "=d"(__v) : "a"(addr)); (unsigned short)__v; })
-
-#define bfin_read32(addr) ({ unsigned __v; \
-                      __asm__ __volatile__ (\
-                                            "%0 = [%1];\n\t"\
-  : "=d"(__v) : "a"(addr)); __v; })
-
-#define bfin_write8(addr, val) ({ \
-		__asm__ __volatile__ ( \
-			"b[%0] = %1; \n\t" \
-			::"a"(addr), "d"(val) : "memory");})
-
-#define bfin_write16(addr,val) ({\
-                      __asm__ __volatile__ (\
-                                            "w[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
-#define bfin_write32(addr,val) ({\
-                      __asm__ __volatile__ (\
-                                            "[%0] = %1;\n\t"\
-  : : "a"(addr) , "d"(val) : "memory");})
-
+# define NOP_PAD_ANOMALY_05000198
 #endif
 
+#define bfin_read8(addr) ({ \
+	uint8_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = b[%1] (z);" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_read16(addr) ({ \
+	uint16_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = w[%1] (z);" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_read32(addr) ({ \
+	uint32_t __v; \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"%0 = [%1];" \
+		: "=d" (__v) \
+		: "a" (addr) \
+	); \
+	__v; })
+
+#define bfin_write8(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"b[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#define bfin_write16(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"w[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#define bfin_write32(addr, val) \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000198 \
+		"[%0] = %1;" \
+		: \
+		: "a" (addr), "d" (val) \
+		: "memory" \
+	)
+
+#endif /* __ASSEMBLY__ */
+
 /**************************************************
  * System Register Bits
  **************************************************/
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
diff --git a/include/asm-blackfin/system.h b/include/asm-blackfin/system.h
index 5e5f1a0..b03cf7d 100644
--- a/include/asm-blackfin/system.h
+++ b/include/asm-blackfin/system.h
@@ -36,6 +36,7 @@
 
 #include <linux/linkage.h>
 #include <linux/compiler.h>
+#include <asm/mach/anomaly.h>
 
 /*
  * Interrupt configuring macros.
@@ -43,53 +44,60 @@
 
 extern unsigned long irq_flags;
 
-#define local_irq_enable() do {		\
-	__asm__ __volatile__ (		\
-		"sti %0;"		\
-		::"d"(irq_flags));	\
-} while (0)
+#define local_irq_enable() \
+	__asm__ __volatile__( \
+		"sti %0;" \
+		: \
+		: "d" (irq_flags) \
+	)
 
-#define local_irq_disable() do {	\
-	int _tmp_dummy;			\
-	__asm__ __volatile__ (		\
-		"cli %0;"		\
-		:"=d" (_tmp_dummy):);	\
-} while (0)
+#define local_irq_disable() \
+	do { \
+		int __tmp_dummy; \
+		__asm__ __volatile__( \
+			"cli %0;" \
+			: "=d" (__tmp_dummy) \
+		); \
+	} while (0)
 
-#if defined(ANOMALY_05000244) && defined (CONFIG_BLKFIN_CACHE)
-#define idle_with_irq_disabled() do {   \
-        __asm__ __volatile__ (          \
-                "nop; nop;\n"           \
-                ".align 8;\n"           \
-                "sti %0; idle;\n"       \
-                ::"d" (irq_flags));     \
-} while (0)
+#if ANOMALY_05000244 && defined(CONFIG_BLKFIN_CACHE)
+# define NOP_PAD_ANOMALY_05000244 "nop; nop;"
 #else
-#define idle_with_irq_disabled() do {   \
-	__asm__ __volatile__ (          \
-		".align 8;\n"           \
-		"sti %0; idle;\n"       \
-		::"d" (irq_flags));     \
-} while (0)
+# define NOP_PAD_ANOMALY_05000244
 #endif
 
+#define idle_with_irq_disabled() \
+	__asm__ __volatile__( \
+		NOP_PAD_ANOMALY_05000244 \
+		".align 8;" \
+		"sti %0;" \
+		"idle;" \
+		: \
+		: "d" (irq_flags) \
+	)
+
 #ifdef CONFIG_DEBUG_HWERR
-#define __save_and_cli(x) do {			\
-	__asm__ __volatile__ (		        \
-		"cli %0;\n\tsti %1;"		\
-		:"=&d"(x): "d" (0x3F));		\
-} while (0)
+# define __save_and_cli(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		"sti %1;" \
+		: "=&d" (x) \
+		: "d" (0x3F) \
+	)
 #else
-#define __save_and_cli(x) do {		\
-	__asm__ __volatile__ (          \
-		"cli %0;"		\
-		:"=&d"(x):);		\
-} while (0)
+# define __save_and_cli(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		: "=&d" (x) \
+	)
 #endif
 
-#define local_save_flags(x) asm volatile ("cli %0;"     \
-					  "sti %0;"     \
-				    	  :"=d"(x):);
+#define local_save_flags(x) \
+	__asm__ __volatile__( \
+		"cli %0;" \
+		"sti %0;" \
+		: "=d" (x) \
+	)
 
 #ifdef CONFIG_DEBUG_HWERR
 #define irqs_enabled_from_flags(x) (((x) & ~0x3f) != 0)
@@ -97,10 +105,11 @@ extern unsigned long irq_flags;
 #define irqs_enabled_from_flags(x) ((x) != 0x1f)
 #endif
 
-#define local_irq_restore(x) do {			\
-	if (irqs_enabled_from_flags(x))			\
-		local_irq_enable ();			\
-} while (0)
+#define local_irq_restore(x) \
+	do { \
+		if (irqs_enabled_from_flags(x)) \
+			local_irq_enable(); \
+	} while (0)
 
 /* For spinlocks etc */
 #define local_irq_save(x) __save_and_cli(x)
diff --git a/include/asm-blackfin/thread_info.h b/include/asm-blackfin/thread_info.h
index fa8f08c..34d3c2e 100644
--- a/include/asm-blackfin/thread_info.h
+++ b/include/asm-blackfin/thread_info.h
@@ -39,6 +39,11 @@
  */
 #define ALIGN_PAGE_MASK         0xffffe000
 
+/*
+ * Size of kernel stack for each process. This must be a power of 2...
+ */
+#define THREAD_SIZE		8192	/* 2 pages */
+
 #ifndef __ASSEMBLY__
 
 typedef unsigned long mm_segment_t;
@@ -76,11 +81,6 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
-/*
- * Size of kernel stack for each process. This must be a power of 2...
- */
-#define THREAD_SIZE		8192	/* 2 pages */
-
 /* How to get the thread information struct from C */
 
 static inline struct thread_info *current_thread_info(void)
@@ -94,7 +94,7 @@ static inline struct thread_info *current_thread_info(void)
 	struct thread_info *ti;
       __asm__("%0 = sp;": "=&d"(ti):
 	);
-	return (struct thread_info *)((long)ti & ~8191UL);
+	return (struct thread_info *)((long)ti & ~((long)THREAD_SIZE-1));
 }
 
 /* thread information allocation */
diff --git a/include/asm-blackfin/trace.h b/include/asm-blackfin/trace.h
index 9c2474c..6313aac 100644
--- a/include/asm-blackfin/trace.h
+++ b/include/asm-blackfin/trace.h
@@ -6,23 +6,46 @@
 #ifndef _BLACKFIN_TRACE_
 #define _BLACKFIN_TRACE_
 
+/* Normally, we use ON, but you can't turn on software expansion until
+ * interrupts subsystem is ready
+ */
+
+#define BFIN_TRACE_INIT ((CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION << 4) | 0x03)
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+#define BFIN_TRACE_ON   (BFIN_TRACE_INIT | (CONFIG_DEBUG_BFIN_HWTRACE_EXPAND << 2))
+#else
+#define BFIN_TRACE_ON   (BFIN_TRACE_INIT)
+#endif
+
 #ifndef __ASSEMBLY__
+extern unsigned long trace_buff_offset;
+extern unsigned long software_trace_buff[];
+
 /* Trace Macros for C files */
 
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+
 #define trace_buffer_save(x) \
-        do { \
-                (x) = bfin_read_TBUFCTL(); \
-                bfin_write_TBUFCTL((x) & ~TBUFEN); \
-        } while (0)
+	do { \
+		(x) = bfin_read_TBUFCTL(); \
+		bfin_write_TBUFCTL((x) & ~TBUFEN); \
+	} while (0)
 
 #define trace_buffer_restore(x) \
-        do { \
-                bfin_write_TBUFCTL((x));        \
-        } while (0)
+	do { \
+		bfin_write_TBUFCTL((x));        \
+	} while (0)
+#else /* DEBUG_BFIN_HWTRACE_ON */
+
+#define trace_buffer_save(x)
+#define trace_buffer_restore(x)
+#endif /* CONFIG_DEBUG_BFIN_HWTRACE_ON */
 
 #else
 /* Trace Macros for Assembly files */
 
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+
 #define TRACE_BUFFER_START(preg, dreg) trace_buffer_start(preg, dreg)
 #define TRACE_BUFFER_STOP(preg, dreg)  trace_buffer_stop(preg, dreg)
 
@@ -32,12 +55,26 @@
 	dreg = 0x1;			\
 	[preg] = dreg;
 
-#define trace_buffer_start(preg, dreg) \
+#define trace_buffer_start(preg, dreg)	\
 	preg.L = LO(TBUFCTL);		\
 	preg.H = HI(TBUFCTL);		\
-	dreg = 0x13;			\
+	dreg = BFIN_TRACE_ON;		\
+	[preg] = dreg;
+
+#define trace_buffer_init(preg, dreg) \
+	preg.L = LO(TBUFCTL);         \
+	preg.H = HI(TBUFCTL);         \
+	dreg = BFIN_TRACE_INIT;       \
 	[preg] = dreg;
 
+#else /* CONFIG_DEBUG_BFIN_HWTRACE_ON */
+
+#define trace_buffer_stop(preg, dreg)
+#define trace_buffer_start(preg, dreg)
+#define trace_buffer_init(preg, dreg)
+
+#endif /* CONFIG_DEBUG_BFIN_HWTRACE_ON */
+
 #ifdef CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE
 # define DEBUG_START_HWTRACE(preg, dreg) trace_buffer_start(preg, dreg)
 # define DEBUG_STOP_HWTRACE(preg, dreg) trace_buffer_stop(preg, dreg)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYGRRK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYGRRK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760917AbYGRRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:10:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:36338 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760774AbYGRRJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:09:51 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] kgdb, mips: Remove existing kgdb implementation
Date: Fri, 18 Jul 2008 12:08:46 -0500
Message-Id: <1216400928-29097-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com>
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jul 2008 17:08:45.0504 (UTC) FILETIME=[EFEF7400:01C8E8F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch explicitly removes the kgdb implementation, for mips which
is intended to be followed by a patch that adds a kgdb implementation
for mips that makes use of the kgdb core in the kernel.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/mips/Kconfig                          |    6 -
 arch/mips/Kconfig.debug                    |   22 -
 arch/mips/au1000/Kconfig                   |    1 -
 arch/mips/au1000/common/Makefile           |    1 -
 arch/mips/au1000/common/dbg_io.c           |  109 ---
 arch/mips/basler/excite/Makefile           |    1 -
 arch/mips/basler/excite/excite_dbg_io.c    |  121 ---
 arch/mips/basler/excite/excite_irq.c       |    7 -
 arch/mips/basler/excite/excite_setup.c     |    4 +-
 arch/mips/configs/db1000_defconfig         |    1 -
 arch/mips/configs/db1100_defconfig         |    1 -
 arch/mips/configs/db1200_defconfig         |    1 -
 arch/mips/configs/db1500_defconfig         |    1 -
 arch/mips/configs/db1550_defconfig         |    1 -
 arch/mips/configs/excite_defconfig         |    1 -
 arch/mips/configs/ip27_defconfig           |    1 -
 arch/mips/configs/msp71xx_defconfig        |    2 -
 arch/mips/configs/mtx1_defconfig           |    1 -
 arch/mips/configs/pb1100_defconfig         |    1 -
 arch/mips/configs/pb1500_defconfig         |    1 -
 arch/mips/configs/pb1550_defconfig         |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig    |    4 +-
 arch/mips/configs/pnx8550-stb810_defconfig |    4 +-
 arch/mips/configs/rbtx49xx_defconfig       |    1 -
 arch/mips/configs/sb1250-swarm_defconfig   |    1 -
 arch/mips/configs/yosemite_defconfig       |    2 -
 arch/mips/kernel/Makefile                  |    1 -
 arch/mips/kernel/gdb-low.S                 |  394 ----------
 arch/mips/kernel/gdb-stub.c                | 1155 ----------------------------
 arch/mips/kernel/irq.c                     |   21 -
 arch/mips/mti-malta/Makefile               |    1 -
 arch/mips/mti-malta/malta-init.c           |   54 --
 arch/mips/mti-malta/malta-kgdb.c           |  133 ----
 arch/mips/mti-malta/malta-setup.c          |    4 -
 arch/mips/nxp/pnx8550/common/Makefile      |    1 -
 arch/mips/nxp/pnx8550/common/gdb_hook.c    |  109 ---
 arch/mips/nxp/pnx8550/common/setup.c       |   12 -
 arch/mips/pmc-sierra/msp71xx/msp_serial.c  |   73 --
 arch/mips/pmc-sierra/yosemite/Makefile     |    1 -
 arch/mips/pmc-sierra/yosemite/dbg_io.c     |  180 -----
 arch/mips/pmc-sierra/yosemite/irq.c        |    9 -
 arch/mips/sgi-ip22/ip22-setup.c            |   24 -
 arch/mips/sgi-ip27/Makefile                |    1 -
 arch/mips/sgi-ip27/ip27-dbgio.c            |   60 --
 arch/mips/sibyte/bcm1480/irq.c             |   80 --
 arch/mips/sibyte/cfe/setup.c               |   14 -
 arch/mips/sibyte/sb1250/irq.c              |   60 --
 arch/mips/sibyte/swarm/Makefile            |    1 -
 arch/mips/sibyte/swarm/dbg_io.c            |   76 --
 arch/mips/txx9/Kconfig                     |    2 -
 arch/mips/txx9/generic/Makefile            |    1 -
 arch/mips/txx9/generic/dbgio.c             |   48 --
 arch/mips/txx9/jmr3927/Makefile            |    1 -
 arch/mips/txx9/jmr3927/kgdb_io.c           |  105 ---
 54 files changed, 4 insertions(+), 2914 deletions(-)
 delete mode 100644 arch/mips/au1000/common/dbg_io.c
 delete mode 100644 arch/mips/basler/excite/excite_dbg_io.c
 delete mode 100644 arch/mips/kernel/gdb-low.S
 delete mode 100644 arch/mips/kernel/gdb-stub.c
 delete mode 100644 arch/mips/mti-malta/malta-kgdb.c
 delete mode 100644 arch/mips/nxp/pnx8550/common/gdb_hook.c
 delete mode 100644 arch/mips/pmc-sierra/yosemite/dbg_io.c
 delete mode 100644 arch/mips/sgi-ip27/ip27-dbgio.c
 delete mode 100644 arch/mips/sibyte/swarm/dbg_io.c
 delete mode 100644 arch/mips/txx9/generic/dbgio.c
 delete mode 100644 arch/mips/txx9/jmr3927/kgdb_io.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d21df5f..1c07cb9 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -34,7 +34,6 @@ config BASLER_EXCITE
 	select SYS_HAS_CPU_RM9000
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	help
 	  The eXcite is a smart camera platform manufactured by
 	  Basler Vision Technologies AG.
@@ -280,7 +279,6 @@ config PMC_MSP
 	select SYS_HAS_CPU_MIPS32_R2
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select IRQ_CPU
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
@@ -306,7 +304,6 @@ config PMC_YOSEMITE
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_SMP
 	help
 	  Yosemite is an evaluation board for the RM9000x2 processor
@@ -358,7 +355,6 @@ config SGI_IP27
 	select SYS_HAS_CPU_R10000
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SMP
 	select GENERIC_HARDIRQS_NO__DO_IRQ
@@ -475,7 +471,6 @@ config SIBYTE_SWARM
 	select SYS_HAS_CPU_SB1
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
-	select SYS_SUPPORTS_KGDB
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select ZONE_DMA32 if 64BIT
 
@@ -850,7 +845,6 @@ config SOC_PNX8550
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select GENERIC_HARDIRQS_NO__DO_IRQ
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_GPIO
 
 config SWAP_IO_SPACE
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index f18cf92..765c8e2 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -34,28 +34,6 @@ config SMTC_IDLE_HOOK_DEBUG
 	  arch/mips/kernel/smtc.c.  This debugging option result in significant
 	  overhead so should be disabled in production kernels.
 
-config KGDB
-	bool "Remote GDB kernel debugging"
-	depends on DEBUG_KERNEL && SYS_SUPPORTS_KGDB
-	select DEBUG_INFO
-	help
-	  If you say Y here, it will be possible to remotely debug the MIPS
-	  kernel using gdb. This enlarges your kernel image disk size by
-	  several megabytes and requires a machine with more than 16 MB,
-	  better 32 MB RAM to avoid excessive linking time. This is only
-	  useful for kernel hackers. If unsure, say N.
-
-config SYS_SUPPORTS_KGDB
-	bool
-
-config GDB_CONSOLE
-	bool "Console output to GDB"
-	depends on KGDB
-	help
-	  If you are using GDB for remote debugging over a serial port and
-	  would like kernel messages to be formatted into GDB $O packets so
-	  that GDB prints them as program output, say 'Y'.
-
 config SB1XXX_CORELIS
 	bool "Corelis Debugger"
 	depends on SIBYTE_SB1xxx_SOC
diff --git a/arch/mips/au1000/Kconfig b/arch/mips/au1000/Kconfig
index 1fe97cc..e4a057d 100644
--- a/arch/mips/au1000/Kconfig
+++ b/arch/mips/au1000/Kconfig
@@ -134,4 +134,3 @@ config SOC_AU1X00
 	select SYS_HAS_CPU_MIPS32_R1
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_APM_EMULATION
-	select SYS_SUPPORTS_KGDB
diff --git a/arch/mips/au1000/common/Makefile b/arch/mips/au1000/common/Makefile
index dd0e19d..df48fd6 100644
--- a/arch/mips/au1000/common/Makefile
+++ b/arch/mips/au1000/common/Makefile
@@ -9,7 +9,6 @@ obj-y += prom.o irq.o puts.o time.o reset.o \
 	au1xxx_irqmap.o clocks.o platform.o power.o setup.o \
 	sleeper.o cputable.o dma.o dbdma.o gpio.o
 
-obj-$(CONFIG_KGDB)		+= dbg_io.o
 obj-$(CONFIG_PCI)		+= pci.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/au1000/common/dbg_io.c b/arch/mips/au1000/common/dbg_io.c
deleted file mode 100644
index af5be7d..0000000
--- a/arch/mips/au1000/common/dbg_io.c
+++ /dev/null
@@ -1,109 +0,0 @@
-#include <linux/types.h>
-
-#include <asm/mach-au1x00/au1000.h>
-
-#ifdef CONFIG_KGDB
-
-/*
- * FIXME the user should be able to select the
- * uart to be used for debugging.
- */
-#define DEBUG_BASE  UART_DEBUG_BASE
-
-#define         UART16550_BAUD_2400             2400
-#define         UART16550_BAUD_4800             4800
-#define         UART16550_BAUD_9600             9600
-#define         UART16550_BAUD_19200            19200
-#define         UART16550_BAUD_38400            38400
-#define         UART16550_BAUD_57600            57600
-#define         UART16550_BAUD_115200           115200
-
-#define         UART16550_PARITY_NONE           0
-#define         UART16550_PARITY_ODD            0x08
-#define         UART16550_PARITY_EVEN           0x18
-#define         UART16550_PARITY_MARK           0x28
-#define         UART16550_PARITY_SPACE          0x38
-
-#define         UART16550_DATA_5BIT             0x0
-#define         UART16550_DATA_6BIT             0x1
-#define         UART16550_DATA_7BIT             0x2
-#define         UART16550_DATA_8BIT             0x3
-
-#define         UART16550_STOP_1BIT             0x0
-#define         UART16550_STOP_2BIT             0x4
-
-
-#define UART_RX		0	/* Receive buffer */
-#define UART_TX		4	/* Transmit buffer */
-#define UART_IER	8	/* Interrupt Enable Register */
-#define UART_IIR	0xC	/* Interrupt ID Register */
-#define UART_FCR	0x10	/* FIFO Control Register */
-#define UART_LCR	0x14	/* Line Control Register */
-#define UART_MCR	0x18	/* Modem Control Register */
-#define UART_LSR	0x1C	/* Line Status Register */
-#define UART_MSR	0x20	/* Modem Status Register */
-#define UART_CLK	0x28	/* Baud Rat4e Clock Divider */
-#define UART_MOD_CNTRL	0x100	/* Module Control */
-
-/* memory-mapped read/write of the port */
-#define UART16550_READ(y)     (au_readl(DEBUG_BASE + y) & 0xff)
-#define UART16550_WRITE(y, z) (au_writel(z & 0xff, DEBUG_BASE + y))
-
-extern unsigned long calc_clock(void);
-
-void debugInit(u32 baud, u8 data, u8 parity, u8 stop)
-{
-	if (UART16550_READ(UART_MOD_CNTRL) != 0x3)
-		UART16550_WRITE(UART_MOD_CNTRL, 3);
-	calc_clock();
-
-	/* disable interrupts */
-	UART16550_WRITE(UART_IER, 0);
-
-	/* set up baud rate */
-	{
-		u32 divisor;
-
-		/* set divisor */
-		divisor = get_au1x00_uart_baud_base() / baud;
-		UART16550_WRITE(UART_CLK, divisor & 0xffff);
-	}
-
-	/* set data format */
-	UART16550_WRITE(UART_LCR, (data | parity | stop));
-}
-
-static int remoteDebugInitialized;
-
-u8 getDebugChar(void)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(UART16550_BAUD_115200,
-			  UART16550_DATA_8BIT,
-			  UART16550_PARITY_NONE,
-			  UART16550_STOP_1BIT);
-	}
-
-	while ((UART16550_READ(UART_LSR) & 0x1) == 0);
-	return UART16550_READ(UART_RX);
-}
-
-
-int putDebugChar(u8 byte)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(UART16550_BAUD_115200,
-			  UART16550_DATA_8BIT,
-			  UART16550_PARITY_NONE,
-			  UART16550_STOP_1BIT);
-	}
-
-	while ((UART16550_READ(UART_LSR) & 0x40) == 0);
-	UART16550_WRITE(UART_TX, byte);
-
-	return 1;
-}
-
-#endif
diff --git a/arch/mips/basler/excite/Makefile b/arch/mips/basler/excite/Makefile
index 519142c..cff29cf 100644
--- a/arch/mips/basler/excite/Makefile
+++ b/arch/mips/basler/excite/Makefile
@@ -5,5 +5,4 @@
 obj-$(CONFIG_BASLER_EXCITE)	+= excite_irq.o excite_prom.o excite_setup.o \
 				   excite_device.o excite_procfs.o
 
-obj-$(CONFIG_KGDB)		+= excite_dbg_io.o
 obj-m				+= excite_iodev.o
diff --git a/arch/mips/basler/excite/excite_dbg_io.c b/arch/mips/basler/excite/excite_dbg_io.c
deleted file mode 100644
index d289e3a..0000000
--- a/arch/mips/basler/excite/excite_dbg_io.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <asm/gdb-stub.h>
-#include <asm/rm9k-ocd.h>
-#include <excite.h>
-
-#if defined(CONFIG_SERIAL_8250) && CONFIG_SERIAL_8250_NR_UARTS > 1
-#error Debug port used by serial driver
-#endif
-
-#define UART_CLK		25000000
-#define BASE_BAUD		(UART_CLK / 16)
-#define REGISTER_BASE_0		0x0208UL
-#define REGISTER_BASE_1		0x0238UL
-
-#define REGISTER_BASE_DBG	REGISTER_BASE_1
-
-#define CPRR	0x0004
-#define UACFG	0x0200
-#define UAINTS	0x0204
-#define UARBR	(REGISTER_BASE_DBG + 0x0000)
-#define UATHR	(REGISTER_BASE_DBG + 0x0004)
-#define UADLL	(REGISTER_BASE_DBG + 0x0008)
-#define UAIER	(REGISTER_BASE_DBG + 0x000c)
-#define UADLH	(REGISTER_BASE_DBG + 0x0010)
-#define UAIIR	(REGISTER_BASE_DBG + 0x0014)
-#define UAFCR	(REGISTER_BASE_DBG + 0x0018)
-#define UALCR	(REGISTER_BASE_DBG + 0x001c)
-#define UAMCR	(REGISTER_BASE_DBG + 0x0020)
-#define UALSR	(REGISTER_BASE_DBG + 0x0024)
-#define UAMSR	(REGISTER_BASE_DBG + 0x0028)
-#define UASCR	(REGISTER_BASE_DBG + 0x002c)
-
-#define	PARITY_NONE	0
-#define	PARITY_ODD	0x08
-#define	PARITY_EVEN	0x18
-#define	PARITY_MARK	0x28
-#define	PARITY_SPACE	0x38
-
-#define	DATA_5BIT	0x0
-#define	DATA_6BIT	0x1
-#define	DATA_7BIT	0x2
-#define	DATA_8BIT	0x3
-
-#define	STOP_1BIT	0x0
-#define	STOP_2BIT	0x4
-
-#define BAUD_DBG	57600
-#define	PARITY_DBG	PARITY_NONE
-#define	DATA_DBG	DATA_8BIT
-#define	STOP_DBG	STOP_1BIT
-
-/* Initialize the serial port for KGDB debugging */
-void __init excite_kgdb_init(void)
-{
-	const u32 divisor = BASE_BAUD / BAUD_DBG;
-
-	/* Take the UART out of reset */
-	titan_writel(0x00ff1cff, CPRR);
-	titan_writel(0x00000000, UACFG);
-	titan_writel(0x00000002, UACFG);
-
-	titan_writel(0x0, UALCR);
-	titan_writel(0x0, UAIER);
-
-	/* Disable FIFOs */
-	titan_writel(0x00, UAFCR);
-
-	titan_writel(0x80, UALCR);
-	titan_writel(divisor & 0xff, UADLL);
-	titan_writel((divisor & 0xff00) >> 8, UADLH);
-	titan_writel(0x0, UALCR);
-
-	titan_writel(DATA_DBG | PARITY_DBG | STOP_DBG, UALCR);
-
-	/* Enable receiver interrupt */
-	titan_readl(UARBR);
-	titan_writel(0x1, UAIER);
-}
-
-int getDebugChar(void)
-{
-	while (!(titan_readl(UALSR) & 0x1));
-	return titan_readl(UARBR);
-}
-
-int putDebugChar(int data)
-{
-	while (!(titan_readl(UALSR) & 0x20));
-	titan_writel(data, UATHR);
-	return 1;
-}
-
-/* KGDB interrupt handler */
-asmlinkage void excite_kgdb_inthdl(void)
-{
-	if (unlikely(
-		((titan_readl(UAIIR) & 0x7) == 4)
-		&& ((titan_readl(UARBR) & 0xff) == 0x3)))
-			set_async_breakpoint(&regs->cp0_epc);
-}
diff --git a/arch/mips/basler/excite/excite_irq.c b/arch/mips/basler/excite/excite_irq.c
index 4903e06..934e0a6 100644
--- a/arch/mips/basler/excite/excite_irq.c
+++ b/arch/mips/basler/excite/excite_irq.c
@@ -50,10 +50,6 @@ void __init arch_init_irq(void)
 	mips_cpu_irq_init();
 	rm7k_cpu_irq_init();
 	rm9k_cpu_irq_init();
-
-#ifdef CONFIG_KGDB
-	excite_kgdb_init();
-#endif
 }
 
 asmlinkage void plat_irq_dispatch(void)
@@ -90,9 +86,6 @@ asmlinkage void plat_irq_dispatch(void)
 	msgint	    = msgintflags & msgintmask & (0x1 << (TITAN_MSGINT % 0x20));
 	if ((pending & (1 << TITAN_IRQ)) && msgint) {
 		ocd_writel(msgint, INTP0Clear0 + (TITAN_MSGINT / 0x20 * 0x10));
-#if defined(CONFIG_KGDB)
-		excite_kgdb_inthdl();
-#endif
 		do_IRQ(TITAN_IRQ);
 		return;
 	}
diff --git a/arch/mips/basler/excite/excite_setup.c b/arch/mips/basler/excite/excite_setup.c
index 6dd8f0d..d66b3b8 100644
--- a/arch/mips/basler/excite/excite_setup.c
+++ b/arch/mips/basler/excite/excite_setup.c
@@ -95,13 +95,13 @@ static int __init excite_init_console(void)
 	/* Take the DUART out of reset */
 	titan_writel(0x00ff1cff, CPRR);
 
-#if defined(CONFIG_KGDB) || (CONFIG_SERIAL_8250_NR_UARTS > 1)
+#if (CONFIG_SERIAL_8250_NR_UARTS > 1)
 	/* Enable both ports */
 	titan_writel(MASK_SER0 | MASK_SER1, UACFG);
 #else
 	/* Enable port #0 only */
 	titan_writel(MASK_SER0, UACFG);
-#endif	/* defined(CONFIG_KGDB) */
+#endif
 
  	/*
 	 * Set up serial port #0. Do not use autodetection; the result is
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
index ebb8ad6..a279165 100644
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -1092,7 +1092,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/db1100_defconfig b/arch/mips/configs/db1100_defconfig
index ad4e5ef..8944d15 100644
--- a/arch/mips/configs/db1100_defconfig
+++ b/arch/mips/configs/db1100_defconfig
@@ -1092,7 +1092,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index d0dc2e8..ab17973 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -1174,7 +1174,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE="mem=48M"
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/db1500_defconfig b/arch/mips/configs/db1500_defconfig
index 9155082..b65803f 100644
--- a/arch/mips/configs/db1500_defconfig
+++ b/arch/mips/configs/db1500_defconfig
@@ -1392,7 +1392,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/db1550_defconfig b/arch/mips/configs/db1550_defconfig
index e4e3244..a190ac0 100644
--- a/arch/mips/configs/db1550_defconfig
+++ b/arch/mips/configs/db1550_defconfig
@@ -1209,7 +1209,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/excite_defconfig b/arch/mips/configs/excite_defconfig
index 3572e80..4e465e9 100644
--- a/arch/mips/configs/excite_defconfig
+++ b/arch/mips/configs/excite_defconfig
@@ -1269,7 +1269,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 138c575..831d3e5 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -943,7 +943,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/msp71xx_defconfig b/arch/mips/configs/msp71xx_defconfig
index 59d1947..dd13db4 100644
--- a/arch/mips/configs/msp71xx_defconfig
+++ b/arch/mips/configs/msp71xx_defconfig
@@ -1415,8 +1415,6 @@ CONFIG_FORCED_INLINING=y
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_KGDB is not set
-CONFIG_SYS_SUPPORTS_KGDB=y
 # CONFIG_RUNTIME_DEBUG is not set
 # CONFIG_MIPS_UNCACHED is not set
 
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index bacf0dd..db92726 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -3020,7 +3020,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/pb1100_defconfig b/arch/mips/configs/pb1100_defconfig
index 6dfe6f7..9e21e33 100644
--- a/arch/mips/configs/pb1100_defconfig
+++ b/arch/mips/configs/pb1100_defconfig
@@ -1085,7 +1085,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/pb1500_defconfig b/arch/mips/configs/pb1500_defconfig
index c965a87..af67ed4 100644
--- a/arch/mips/configs/pb1500_defconfig
+++ b/arch/mips/configs/pb1500_defconfig
@@ -1202,7 +1202,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/pb1550_defconfig b/arch/mips/configs/pb1550_defconfig
index 0778996..7956f56 100644
--- a/arch/mips/configs/pb1550_defconfig
+++ b/arch/mips/configs/pb1550_defconfig
@@ -1195,7 +1195,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/pnx8550-jbs_defconfig b/arch/mips/configs/pnx8550-jbs_defconfig
index 37c7b5f..723bd51 100644
--- a/arch/mips/configs/pnx8550-jbs_defconfig
+++ b/arch/mips/configs/pnx8550-jbs_defconfig
@@ -1216,10 +1216,8 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
-CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
+CONFIG_CMDLINE="console=ttyS1,38400n8 root=/dev/nfs ip=bootp"
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_KGDB is not set
-CONFIG_SYS_SUPPORTS_KGDB=y
 # CONFIG_RUNTIME_DEBUG is not set
 
 #
diff --git a/arch/mips/configs/pnx8550-stb810_defconfig b/arch/mips/configs/pnx8550-stb810_defconfig
index 893e5c4..b5052fb 100644
--- a/arch/mips/configs/pnx8550-stb810_defconfig
+++ b/arch/mips/configs/pnx8550-stb810_defconfig
@@ -1206,10 +1206,8 @@ CONFIG_DEBUG_SLAB=y
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 CONFIG_CROSSCOMPILE=y
-CONFIG_CMDLINE="console=ttyS1,38400n8 kgdb=ttyS0 root=/dev/nfs ip=bootp"
+CONFIG_CMDLINE="console=ttyS1,38400n8 root=/dev/nfs ip=bootp"
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_KGDB is not set
-CONFIG_SYS_SUPPORTS_KGDB=y
 # CONFIG_RUNTIME_DEBUG is not set
 
 #
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index e42aed5..c7c0864 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -742,7 +742,6 @@ CONFIG_DEBUG_FS=y
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_SAMPLES is not set
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 
 #
 # Security options
diff --git a/arch/mips/configs/sb1250-swarm_defconfig b/arch/mips/configs/sb1250-swarm_defconfig
index 1ea9786..a9acaa2 100644
--- a/arch/mips/configs/sb1250-swarm_defconfig
+++ b/arch/mips/configs/sb1250-swarm_defconfig
@@ -963,7 +963,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_KERNEL is not set
 # CONFIG_SAMPLES is not set
 CONFIG_CMDLINE=""
-CONFIG_SYS_SUPPORTS_KGDB=y
 # CONFIG_SB1XXX_CORELIS is not set
 
 #
diff --git a/arch/mips/configs/yosemite_defconfig b/arch/mips/configs/yosemite_defconfig
index 7f86c43..ea8249c 100644
--- a/arch/mips/configs/yosemite_defconfig
+++ b/arch/mips/configs/yosemite_defconfig
@@ -827,8 +827,6 @@ CONFIG_FORCED_INLINING=y
 CONFIG_CROSSCOMPILE=y
 CONFIG_CMDLINE=""
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_KGDB is not set
-CONFIG_SYS_SUPPORTS_KGDB=y
 # CONFIG_RUNTIME_DEBUG is not set
 
 #
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 0fd3197..73ff048 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -71,7 +71,6 @@ obj-$(CONFIG_MIPS32_COMPAT)	+= linux32.o ptrace32.o signal32.o
 obj-$(CONFIG_MIPS32_N32)	+= binfmt_elfn32.o scall64-n32.o signal_n32.o
 obj-$(CONFIG_MIPS32_O32)	+= binfmt_elfo32.o scall64-o32.o
 
-obj-$(CONFIG_KGDB)		+= gdb-low.o gdb-stub.o
 obj-$(CONFIG_PROC_FS)		+= proc.o
 
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
diff --git a/arch/mips/kernel/gdb-low.S b/arch/mips/kernel/gdb-low.S
deleted file mode 100644
index 2c44606..0000000
--- a/arch/mips/kernel/gdb-low.S
+++ /dev/null
@@ -1,394 +0,0 @@
-/*
- * gdb-low.S contains the low-level trap handler for the GDB stub.
- *
- * Copyright (C) 1995 Andreas Busse
- */
-#include <linux/sys.h>
-
-#include <asm/asm.h>
-#include <asm/errno.h>
-#include <asm/irqflags.h>
-#include <asm/mipsregs.h>
-#include <asm/regdef.h>
-#include <asm/stackframe.h>
-#include <asm/gdb-stub.h>
-
-#ifdef CONFIG_32BIT
-#define DMFC0	mfc0
-#define DMTC0	mtc0
-#define LDC1	lwc1
-#define SDC1	lwc1
-#endif
-#ifdef CONFIG_64BIT
-#define DMFC0	dmfc0
-#define DMTC0	dmtc0
-#define LDC1	ldc1
-#define SDC1	ldc1
-#endif
-
-/*
- * [jsun] We reserves about 2x GDB_FR_SIZE in stack.  The lower (addressed)
- * part is used to store registers and passed to exception handler.
- * The upper part is reserved for "call func" feature where gdb client
- * saves some of the regs, setups call frame and passes args.
- *
- * A trace shows about 200 bytes are used to store about half of all regs.
- * The rest should be big enough for frame setup and passing args.
- */
-
-/*
- * The low level trap handler
- */
-		.align 	5
-		NESTED(trap_low, GDB_FR_SIZE, sp)
-		.set	noat
-		.set 	noreorder
-
-		mfc0	k0, CP0_STATUS
-		sll	k0, 3     		/* extract cu0 bit */
-		bltz	k0, 1f
-		move	k1, sp
-
-		/*
-		 * Called from user mode, go somewhere else.
-		 */
-		mfc0	k0, CP0_CAUSE
-		andi	k0, k0, 0x7c
-#ifdef CONFIG_64BIT
-		dsll	k0, k0, 1
-#endif
-		PTR_L	k1, saved_vectors(k0)
-		jr	k1
-		nop
-1:
-		move	k0, sp
-		PTR_SUBU sp, k1, GDB_FR_SIZE*2	# see comment above
-		LONG_S	k0, GDB_FR_REG29(sp)
-		LONG_S	$2, GDB_FR_REG2(sp)
-
-/*
- * First save the CP0 and special registers
- */
-
-		mfc0	v0, CP0_STATUS
-		LONG_S	v0, GDB_FR_STATUS(sp)
-		mfc0	v0, CP0_CAUSE
-		LONG_S	v0, GDB_FR_CAUSE(sp)
-		DMFC0	v0, CP0_EPC
-		LONG_S	v0, GDB_FR_EPC(sp)
-		DMFC0	v0, CP0_BADVADDR
-		LONG_S	v0, GDB_FR_BADVADDR(sp)
-		mfhi	v0
-		LONG_S	v0, GDB_FR_HI(sp)
-		mflo	v0
-		LONG_S	v0, GDB_FR_LO(sp)
-
-/*
- * Now the integer registers
- */
-
-		LONG_S	zero, GDB_FR_REG0(sp)		/* I know... */
-		LONG_S	$1, GDB_FR_REG1(sp)
-		/* v0 already saved */
-		LONG_S	$3, GDB_FR_REG3(sp)
-		LONG_S	$4, GDB_FR_REG4(sp)
-		LONG_S	$5, GDB_FR_REG5(sp)
-		LONG_S	$6, GDB_FR_REG6(sp)
-		LONG_S	$7, GDB_FR_REG7(sp)
-		LONG_S	$8, GDB_FR_REG8(sp)
-		LONG_S	$9, GDB_FR_REG9(sp)
-		LONG_S	$10, GDB_FR_REG10(sp)
-		LONG_S	$11, GDB_FR_REG11(sp)
-		LONG_S	$12, GDB_FR_REG12(sp)
-		LONG_S	$13, GDB_FR_REG13(sp)
-		LONG_S	$14, GDB_FR_REG14(sp)
-		LONG_S	$15, GDB_FR_REG15(sp)
-		LONG_S	$16, GDB_FR_REG16(sp)
-		LONG_S	$17, GDB_FR_REG17(sp)
-		LONG_S	$18, GDB_FR_REG18(sp)
-		LONG_S	$19, GDB_FR_REG19(sp)
-		LONG_S	$20, GDB_FR_REG20(sp)
-		LONG_S	$21, GDB_FR_REG21(sp)
-		LONG_S	$22, GDB_FR_REG22(sp)
-		LONG_S	$23, GDB_FR_REG23(sp)
-		LONG_S	$24, GDB_FR_REG24(sp)
-		LONG_S	$25, GDB_FR_REG25(sp)
-		LONG_S	$26, GDB_FR_REG26(sp)
-		LONG_S	$27, GDB_FR_REG27(sp)
-		LONG_S	$28, GDB_FR_REG28(sp)
-		/* sp already saved */
-		LONG_S	$30, GDB_FR_REG30(sp)
-		LONG_S	$31, GDB_FR_REG31(sp)
-
-		CLI				/* disable interrupts */
-		TRACE_IRQS_OFF
-
-/*
- * Followed by the floating point registers
- */
-		mfc0	v0, CP0_STATUS		/* FPU enabled? */
-		srl	v0, v0, 16
-		andi	v0, v0, (ST0_CU1 >> 16)
-
-		beqz	v0,2f			/* disabled, skip */
-		 nop
-
-		SDC1	$0, GDB_FR_FPR0(sp)
-		SDC1	$1, GDB_FR_FPR1(sp)
-		SDC1	$2, GDB_FR_FPR2(sp)
-		SDC1	$3, GDB_FR_FPR3(sp)
-		SDC1	$4, GDB_FR_FPR4(sp)
-		SDC1	$5, GDB_FR_FPR5(sp)
-		SDC1	$6, GDB_FR_FPR6(sp)
-		SDC1	$7, GDB_FR_FPR7(sp)
-		SDC1	$8, GDB_FR_FPR8(sp)
-		SDC1	$9, GDB_FR_FPR9(sp)
-		SDC1	$10, GDB_FR_FPR10(sp)
-		SDC1	$11, GDB_FR_FPR11(sp)
-		SDC1	$12, GDB_FR_FPR12(sp)
-		SDC1	$13, GDB_FR_FPR13(sp)
-		SDC1	$14, GDB_FR_FPR14(sp)
-		SDC1	$15, GDB_FR_FPR15(sp)
-		SDC1	$16, GDB_FR_FPR16(sp)
-		SDC1	$17, GDB_FR_FPR17(sp)
-		SDC1	$18, GDB_FR_FPR18(sp)
-		SDC1	$19, GDB_FR_FPR19(sp)
-		SDC1	$20, GDB_FR_FPR20(sp)
-		SDC1	$21, GDB_FR_FPR21(sp)
-		SDC1	$22, GDB_FR_FPR22(sp)
-		SDC1	$23, GDB_FR_FPR23(sp)
-		SDC1	$24, GDB_FR_FPR24(sp)
-		SDC1	$25, GDB_FR_FPR25(sp)
-		SDC1	$26, GDB_FR_FPR26(sp)
-		SDC1	$27, GDB_FR_FPR27(sp)
-		SDC1	$28, GDB_FR_FPR28(sp)
-		SDC1	$29, GDB_FR_FPR29(sp)
-		SDC1	$30, GDB_FR_FPR30(sp)
-		SDC1	$31, GDB_FR_FPR31(sp)
-
-/*
- * FPU control registers
- */
-
-		cfc1	v0, CP1_STATUS
-		LONG_S	v0, GDB_FR_FSR(sp)
-		cfc1	v0, CP1_REVISION
-		LONG_S	v0, GDB_FR_FIR(sp)
-
-/*
- * Current stack frame ptr
- */
-
-2:
-		LONG_S	sp, GDB_FR_FRP(sp)
-
-/*
- * CP0 registers (R4000/R4400 unused registers skipped)
- */
-
-		mfc0	v0, CP0_INDEX
-		LONG_S	v0, GDB_FR_CP0_INDEX(sp)
-		mfc0	v0, CP0_RANDOM
-		LONG_S	v0, GDB_FR_CP0_RANDOM(sp)
-		DMFC0	v0, CP0_ENTRYLO0
-		LONG_S	v0, GDB_FR_CP0_ENTRYLO0(sp)
-		DMFC0	v0, CP0_ENTRYLO1
-		LONG_S	v0, GDB_FR_CP0_ENTRYLO1(sp)
-		DMFC0	v0, CP0_CONTEXT
-		LONG_S	v0, GDB_FR_CP0_CONTEXT(sp)
-		mfc0	v0, CP0_PAGEMASK
-		LONG_S	v0, GDB_FR_CP0_PAGEMASK(sp)
-		mfc0	v0, CP0_WIRED
-		LONG_S	v0, GDB_FR_CP0_WIRED(sp)
-		DMFC0	v0, CP0_ENTRYHI
-		LONG_S	v0, GDB_FR_CP0_ENTRYHI(sp)
-		mfc0	v0, CP0_PRID
-		LONG_S	v0, GDB_FR_CP0_PRID(sp)
-
-		.set	at
-
-/*
- * Continue with the higher level handler
- */
-
-		move	a0,sp
-
-		jal	handle_exception
-		 nop
-
-/*
- * Restore all writable registers, in reverse order
- */
-
-		.set	noat
-
-		LONG_L	v0, GDB_FR_CP0_ENTRYHI(sp)
-		LONG_L	v1, GDB_FR_CP0_WIRED(sp)
-		DMTC0	v0, CP0_ENTRYHI
-		mtc0	v1, CP0_WIRED
-		LONG_L	v0, GDB_FR_CP0_PAGEMASK(sp)
-		LONG_L	v1, GDB_FR_CP0_ENTRYLO1(sp)
-		mtc0	v0, CP0_PAGEMASK
-		DMTC0	v1, CP0_ENTRYLO1
-		LONG_L	v0, GDB_FR_CP0_ENTRYLO0(sp)
-		LONG_L	v1, GDB_FR_CP0_INDEX(sp)
-		DMTC0	v0, CP0_ENTRYLO0
-		LONG_L	v0, GDB_FR_CP0_CONTEXT(sp)
-		mtc0	v1, CP0_INDEX
-		DMTC0	v0, CP0_CONTEXT
-
-
-/*
- * Next, the floating point registers
- */
-		mfc0	v0, CP0_STATUS		/* check if the FPU is enabled */
-		srl	v0, v0, 16
-		andi	v0, v0, (ST0_CU1 >> 16)
-
-		beqz	v0, 3f			/* disabled, skip */
-		 nop
-
-		LDC1	$31, GDB_FR_FPR31(sp)
-		LDC1	$30, GDB_FR_FPR30(sp)
-		LDC1	$29, GDB_FR_FPR29(sp)
-		LDC1	$28, GDB_FR_FPR28(sp)
-		LDC1	$27, GDB_FR_FPR27(sp)
-		LDC1	$26, GDB_FR_FPR26(sp)
-		LDC1	$25, GDB_FR_FPR25(sp)
-		LDC1	$24, GDB_FR_FPR24(sp)
-		LDC1	$23, GDB_FR_FPR23(sp)
-		LDC1	$22, GDB_FR_FPR22(sp)
-		LDC1	$21, GDB_FR_FPR21(sp)
-		LDC1	$20, GDB_FR_FPR20(sp)
-		LDC1	$19, GDB_FR_FPR19(sp)
-		LDC1	$18, GDB_FR_FPR18(sp)
-		LDC1	$17, GDB_FR_FPR17(sp)
-		LDC1	$16, GDB_FR_FPR16(sp)
-		LDC1	$15, GDB_FR_FPR15(sp)
-		LDC1	$14, GDB_FR_FPR14(sp)
-		LDC1	$13, GDB_FR_FPR13(sp)
-		LDC1	$12, GDB_FR_FPR12(sp)
-		LDC1	$11, GDB_FR_FPR11(sp)
-		LDC1	$10, GDB_FR_FPR10(sp)
-		LDC1	$9, GDB_FR_FPR9(sp)
-		LDC1	$8, GDB_FR_FPR8(sp)
-		LDC1	$7, GDB_FR_FPR7(sp)
-		LDC1	$6, GDB_FR_FPR6(sp)
-		LDC1	$5, GDB_FR_FPR5(sp)
-		LDC1	$4, GDB_FR_FPR4(sp)
-		LDC1	$3, GDB_FR_FPR3(sp)
-		LDC1	$2, GDB_FR_FPR2(sp)
-		LDC1	$1, GDB_FR_FPR1(sp)
-		LDC1	$0, GDB_FR_FPR0(sp)
-
-/*
- * Now the CP0 and integer registers
- */
-
-3:
-#ifdef CONFIG_MIPS_MT_SMTC
-		/* Read-modify write of Status must be atomic */
-		mfc0	t2, CP0_TCSTATUS
-		ori	t1, t2, TCSTATUS_IXMT
-		mtc0	t1, CP0_TCSTATUS
-		andi	t2, t2, TCSTATUS_IXMT
-		_ehb
-		DMT	9				# dmt	t1
-		jal	mips_ihb
-		nop
-#endif /* CONFIG_MIPS_MT_SMTC */
-		mfc0	t0, CP0_STATUS
-		ori	t0, 0x1f
-		xori	t0, 0x1f
-		mtc0	t0, CP0_STATUS
-#ifdef CONFIG_MIPS_MT_SMTC
-        	andi    t1, t1, VPECONTROL_TE
-        	beqz    t1, 9f
-		nop
-        	EMT					# emt
-9:
-		mfc0	t1, CP0_TCSTATUS
-		xori	t1, t1, TCSTATUS_IXMT
-		or	t1, t1, t2
-		mtc0	t1, CP0_TCSTATUS
-		_ehb
-#endif /* CONFIG_MIPS_MT_SMTC */
-		LONG_L	v0, GDB_FR_STATUS(sp)
-		LONG_L	v1, GDB_FR_EPC(sp)
-		mtc0	v0, CP0_STATUS
-		DMTC0	v1, CP0_EPC
-		LONG_L	v0, GDB_FR_HI(sp)
-		LONG_L	v1, GDB_FR_LO(sp)
-		mthi	v0
-		mtlo	v1
-		LONG_L	$31, GDB_FR_REG31(sp)
-		LONG_L	$30, GDB_FR_REG30(sp)
-		LONG_L	$28, GDB_FR_REG28(sp)
-		LONG_L	$27, GDB_FR_REG27(sp)
-		LONG_L	$26, GDB_FR_REG26(sp)
-		LONG_L	$25, GDB_FR_REG25(sp)
-		LONG_L	$24, GDB_FR_REG24(sp)
-		LONG_L	$23, GDB_FR_REG23(sp)
-		LONG_L	$22, GDB_FR_REG22(sp)
-		LONG_L	$21, GDB_FR_REG21(sp)
-		LONG_L	$20, GDB_FR_REG20(sp)
-		LONG_L	$19, GDB_FR_REG19(sp)
-		LONG_L	$18, GDB_FR_REG18(sp)
-		LONG_L	$17, GDB_FR_REG17(sp)
-		LONG_L	$16, GDB_FR_REG16(sp)
-		LONG_L	$15, GDB_FR_REG15(sp)
-		LONG_L	$14, GDB_FR_REG14(sp)
-		LONG_L	$13, GDB_FR_REG13(sp)
-		LONG_L	$12, GDB_FR_REG12(sp)
-		LONG_L	$11, GDB_FR_REG11(sp)
-		LONG_L	$10, GDB_FR_REG10(sp)
-		LONG_L	$9, GDB_FR_REG9(sp)
-		LONG_L	$8, GDB_FR_REG8(sp)
-		LONG_L	$7, GDB_FR_REG7(sp)
-		LONG_L	$6, GDB_FR_REG6(sp)
-		LONG_L	$5, GDB_FR_REG5(sp)
-		LONG_L	$4, GDB_FR_REG4(sp)
-		LONG_L	$3, GDB_FR_REG3(sp)
-		LONG_L	$2, GDB_FR_REG2(sp)
-		LONG_L	$1, GDB_FR_REG1(sp)
-#if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
-		LONG_L	k0, GDB_FR_EPC(sp)
-		LONG_L	$29, GDB_FR_REG29(sp)		/* Deallocate stack */
-		jr	k0
-		rfe
-#else
-		LONG_L	sp, GDB_FR_REG29(sp)		/* Deallocate stack */
-
-		.set	mips3
-		eret
-		.set	mips0
-#endif
-		.set	at
-		.set	reorder
-		END(trap_low)
-
-LEAF(kgdb_read_byte)
-4:		lb	t0, (a0)
-		sb	t0, (a1)
-		li	v0, 0
-		jr	ra
-		.section __ex_table,"a"
-		PTR	4b, kgdbfault
-		.previous
-		END(kgdb_read_byte)
-
-LEAF(kgdb_write_byte)
-5:		sb	a0, (a1)
-		li	v0, 0
-		jr	ra
-		.section __ex_table,"a"
-		PTR	5b, kgdbfault
-		.previous
-		END(kgdb_write_byte)
-
-		.type	kgdbfault@function
-		.ent	kgdbfault
-
-kgdbfault:	li	v0, -EFAULT
-		jr	ra
-		.end	kgdbfault
diff --git a/arch/mips/kernel/gdb-stub.c b/arch/mips/kernel/gdb-stub.c
deleted file mode 100644
index 25f4eab..0000000
--- a/arch/mips/kernel/gdb-stub.c
+++ /dev/null
@@ -1,1155 +0,0 @@
-/*
- *  arch/mips/kernel/gdb-stub.c
- *
- *  Originally written by Glenn Engel, Lake Stevens Instrument Division
- *
- *  Contributed by HP Systems
- *
- *  Modified for SPARC by Stu Grossman, Cygnus Support.
- *
- *  Modified for Linux/MIPS (and MIPS in general) by Andreas Busse
- *  Send complaints, suggestions etc. to <andy@waldorf-gmbh.de>
- *
- *  Copyright (C) 1995 Andreas Busse
- *
- *  Copyright (C) 2003 MontaVista Software Inc.
- *  Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- */
-
-/*
- *  To enable debugger support, two things need to happen.  One, a
- *  call to set_debug_traps() is necessary in order to allow any breakpoints
- *  or error conditions to be properly intercepted and reported to gdb.
- *  Two, a breakpoint needs to be generated to begin communication.  This
- *  is most easily accomplished by a call to breakpoint().  Breakpoint()
- *  simulates a breakpoint by executing a BREAK instruction.
- *
- *
- *    The following gdb commands are supported:
- *
- * command          function                               Return value
- *
- *    g             return the value of the CPU registers  hex data or ENN
- *    G             set the value of the CPU registers     OK or ENN
- *
- *    mAA..AA,LLLL  Read LLLL bytes at address AA..AA      hex data or ENN
- *    MAA..AA,LLLL: Write LLLL bytes at address AA.AA      OK or ENN
- *
- *    c             Resume at current address              SNN   ( signal NN)
- *    cAA..AA       Continue at address AA..AA             SNN
- *
- *    s             Step one instruction                   SNN
- *    sAA..AA       Step one instruction from AA..AA       SNN
- *
- *    k             kill
- *
- *    ?             What was the last sigval ?             SNN   (signal NN)
- *
- *    bBB..BB	    Set baud rate to BB..BB		   OK or BNN, then sets
- *							   baud rate
- *
- * All commands and responses are sent with a packet which includes a
- * checksum.  A packet consists of
- *
- * $<packet info>#<checksum>.
- *
- * where
- * <packet info> :: <characters representing the command or response>
- * <checksum>    :: < two hex digits computed as modulo 256 sum of <packetinfo>>
- *
- * When a packet is received, it is first acknowledged with either '+' or '-'.
- * '+' indicates a successful transfer.  '-' indicates a failed transfer.
- *
- * Example:
- *
- * Host:                  Reply:
- * $m0,10#2a               +$00010203040506070809101112131415#42
- *
- *
- *  ==============
- *  MORE EXAMPLES:
- *  ==============
- *
- *  For reference -- the following are the steps that one
- *  company took (RidgeRun Inc) to get remote gdb debugging
- *  going. In this scenario the host machine was a PC and the
- *  target platform was a Galileo EVB64120A MIPS evaluation
- *  board.
- *
- *  Step 1:
- *  First download gdb-5.0.tar.gz from the internet.
- *  and then build/install the package.
- *
- *  Example:
- *    $ tar zxf gdb-5.0.tar.gz
- *    $ cd gdb-5.0
- *    $ ./configure --target=mips-linux-elf
- *    $ make
- *    $ install
- *    $ which mips-linux-elf-gdb
- *    /usr/local/bin/mips-linux-elf-gdb
- *
- *  Step 2:
- *  Configure linux for remote debugging and build it.
- *
- *  Example:
- *    $ cd ~/linux
- *    $ make menuconfig <go to "Kernel Hacking" and turn on remote debugging>
- *    $ make
- *
- *  Step 3:
- *  Download the kernel to the remote target and start
- *  the kernel running. It will promptly halt and wait
- *  for the host gdb session to connect. It does this
- *  since the "Kernel Hacking" option has defined
- *  CONFIG_KGDB which in turn enables your calls
- *  to:
- *     set_debug_traps();
- *     breakpoint();
- *
- *  Step 4:
- *  Start the gdb session on the host.
- *
- *  Example:
- *    $ mips-linux-elf-gdb vmlinux
- *    (gdb) set remotebaud 115200
- *    (gdb) target remote /dev/ttyS1
- *    ...at this point you are connected to
- *       the remote target and can use gdb
- *       in the normal fasion. Setting
- *       breakpoints, single stepping,
- *       printing variables, etc.
- */
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/reboot.h>
-
-#include <asm/asm.h>
-#include <asm/cacheflush.h>
-#include <asm/mipsregs.h>
-#include <asm/pgtable.h>
-#include <asm/system.h>
-#include <asm/gdb-stub.h>
-#include <asm/inst.h>
-
-/*
- * external low-level support routines
- */
-
-extern int putDebugChar(char c);    /* write a single character      */
-extern char getDebugChar(void);     /* read and return a single char */
-extern void trap_low(void);
-
-/*
- * breakpoint and test functions
- */
-extern void breakpoint(void);
-extern void breakinst(void);
-extern void async_breakpoint(void);
-extern void async_breakinst(void);
-extern void adel(void);
-
-/*
- * local prototypes
- */
-
-static void getpacket(char *buffer);
-static void putpacket(char *buffer);
-static int computeSignal(int tt);
-static int hex(unsigned char ch);
-static int hexToInt(char **ptr, int *intValue);
-static int hexToLong(char **ptr, long *longValue);
-static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault);
-void handle_exception(struct gdb_regs *regs);
-
-int kgdb_enabled;
-
-/*
- * spin locks for smp case
- */
-static DEFINE_SPINLOCK(kgdb_lock);
-static raw_spinlock_t kgdb_cpulock[NR_CPUS] = {
-	[0 ... NR_CPUS-1] = __RAW_SPIN_LOCK_UNLOCKED,
-};
-
-/*
- * BUFMAX defines the maximum number of characters in inbound/outbound buffers
- * at least NUMREGBYTES*2 are needed for register packets
- */
-#define BUFMAX 2048
-
-static char input_buffer[BUFMAX];
-static char output_buffer[BUFMAX];
-static int initialized;	/* !0 means we've been initialized */
-static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
-
-/* Used to prevent crashes in memory access.  Note that they'll crash anyway if
-   we haven't set up fault handlers yet... */
-int kgdb_read_byte(unsigned char *address, unsigned char *dest);
-int kgdb_write_byte(unsigned char val, unsigned char *dest);
-
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch-'a'+10;
-	if (ch >= '0' && ch <= '9')
-		return ch-'0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch-'A'+10;
-	return -1;
-}
-
-/*
- * scan for the sequence $<data>#<checksum>
- */
-static void getpacket(char *buffer)
-{
-	unsigned char checksum;
-	unsigned char xmitcsum;
-	int i;
-	int count;
-	unsigned char ch;
-
-	do {
-		/*
-		 * wait around for the start character,
-		 * ignore all other characters
-		 */
-		while ((ch = (getDebugChar() & 0x7f)) != '$') ;
-
-		checksum = 0;
-		xmitcsum = -1;
-		count = 0;
-
-		/*
-		 * now, read until a # or end of buffer is found
-		 */
-		while (count < BUFMAX) {
-			ch = getDebugChar();
-			if (ch == '#')
-				break;
-			checksum = checksum + ch;
-			buffer[count] = ch;
-			count = count + 1;
-		}
-
-		if (count >= BUFMAX)
-			continue;
-
-		buffer[count] = 0;
-
-		if (ch == '#') {
-			xmitcsum = hex(getDebugChar() & 0x7f) << 4;
-			xmitcsum |= hex(getDebugChar() & 0x7f);
-
-			if (checksum != xmitcsum)
-				putDebugChar('-');	/* failed checksum */
-			else {
-				putDebugChar('+'); /* successful transfer */
-
-				/*
-				 * if a sequence char is present,
-				 * reply the sequence ID
-				 */
-				if (buffer[2] == ':') {
-					putDebugChar(buffer[0]);
-					putDebugChar(buffer[1]);
-
-					/*
-					 * remove sequence chars from buffer
-					 */
-					count = strlen(buffer);
-					for (i=3; i <= count; i++)
-						buffer[i-3] = buffer[i];
-				}
-			}
-		}
-	}
-	while (checksum != xmitcsum);
-}
-
-/*
- * send the packet in buffer.
- */
-static void putpacket(char *buffer)
-{
-	unsigned char checksum;
-	int count;
-	unsigned char ch;
-
-	/*
-	 * $<packet info>#<checksum>.
-	 */
-
-	do {
-		putDebugChar('$');
-		checksum = 0;
-		count = 0;
-
-		while ((ch = buffer[count]) != 0) {
-			if (!(putDebugChar(ch)))
-				return;
-			checksum += ch;
-			count += 1;
-		}
-
-		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
-
-	}
-	while ((getDebugChar() & 0x7f) != '+');
-}
-
-
-/*
- * Convert the memory pointed to by mem into hex, placing result in buf.
- * Return a pointer to the last char put in buf (null), in case of mem fault,
- * return 0.
- * may_fault is non-zero if we are reading from arbitrary memory, but is currently
- * not used.
- */
-static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault)
-{
-	unsigned char ch;
-
-	while (count-- > 0) {
-		if (kgdb_read_byte(mem++, &ch) != 0)
-			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
-	}
-
-	*buf = 0;
-
-	return buf;
-}
-
-/*
- * convert the hex array pointed to by buf into binary to be placed in mem
- * return a pointer to the character AFTER the last byte written
- * may_fault is non-zero if we are reading from arbitrary memory, but is currently
- * not used.
- */
-static char *hex2mem(char *buf, char *mem, int count, int binary, int may_fault)
-{
-	int i;
-	unsigned char ch;
-
-	for (i=0; i<count; i++)
-	{
-		if (binary) {
-			ch = *buf++;
-			if (ch == 0x7d)
-				ch = 0x20 ^ *buf++;
-		}
-		else {
-			ch = hex(*buf++) << 4;
-			ch |= hex(*buf++);
-		}
-		if (kgdb_write_byte(ch, mem++) != 0)
-			return 0;
-	}
-
-	return mem;
-}
-
-/*
- * This table contains the mapping between SPARC hardware trap types, and
- * signals, which are primarily what GDB understands.  It also indicates
- * which hardware traps we need to commandeer when initializing the stub.
- */
-static struct hard_trap_info {
-	unsigned char tt;		/* Trap type code for MIPS R3xxx and R4xxx */
-	unsigned char signo;		/* Signal that we map this trap into */
-} hard_trap_info[] = {
-	{ 6, SIGBUS },			/* instruction bus error */
-	{ 7, SIGBUS },			/* data bus error */
-	{ 9, SIGTRAP },			/* break */
-	{ 10, SIGILL },			/* reserved instruction */
-/*	{ 11, SIGILL },		*/	/* CPU unusable */
-	{ 12, SIGFPE },			/* overflow */
-	{ 13, SIGTRAP },		/* trap */
-	{ 14, SIGSEGV },		/* virtual instruction cache coherency */
-	{ 15, SIGFPE },			/* floating point exception */
-	{ 23, SIGSEGV },		/* watch */
-	{ 31, SIGSEGV },		/* virtual data cache coherency */
-	{ 0, 0}				/* Must be last */
-};
-
-/* Save the normal trap handlers for user-mode traps. */
-void *saved_vectors[32];
-
-/*
- * Set up exception handlers for tracing and breakpoints
- */
-void set_debug_traps(void)
-{
-	struct hard_trap_info *ht;
-	unsigned long flags;
-	unsigned char c;
-
-	local_irq_save(flags);
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		saved_vectors[ht->tt] = set_except_vector(ht->tt, trap_low);
-
-	putDebugChar('+'); /* 'hello world' */
-	/*
-	 * In case GDB is started before us, ack any packets
-	 * (presumably "$?#xx") sitting there.
-	 */
-	while((c = getDebugChar()) != '$');
-	while((c = getDebugChar()) != '#');
-	c = getDebugChar(); /* eat first csum byte */
-	c = getDebugChar(); /* eat second csum byte */
-	putDebugChar('+'); /* ack it */
-
-	initialized = 1;
-	local_irq_restore(flags);
-}
-
-void restore_debug_traps(void)
-{
-	struct hard_trap_info *ht;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		set_except_vector(ht->tt, saved_vectors[ht->tt]);
-	local_irq_restore(flags);
-}
-
-/*
- * Convert the MIPS hardware trap type code to a Unix signal number.
- */
-static int computeSignal(int tt)
-{
-	struct hard_trap_info *ht;
-
-	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
-		if (ht->tt == tt)
-			return ht->signo;
-
-	return SIGHUP;		/* default for things we don't know about */
-}
-
-/*
- * While we find nice hex chars, build an int.
- * Return number of chars processed.
- */
-static int hexToInt(char **ptr, int *intValue)
-{
-	int numChars = 0;
-	int hexValue;
-
-	*intValue = 0;
-
-	while (**ptr) {
-		hexValue = hex(**ptr);
-		if (hexValue < 0)
-			break;
-
-		*intValue = (*intValue << 4) | hexValue;
-		numChars ++;
-
-		(*ptr)++;
-	}
-
-	return (numChars);
-}
-
-static int hexToLong(char **ptr, long *longValue)
-{
-	int numChars = 0;
-	int hexValue;
-
-	*longValue = 0;
-
-	while (**ptr) {
-		hexValue = hex(**ptr);
-		if (hexValue < 0)
-			break;
-
-		*longValue = (*longValue << 4) | hexValue;
-		numChars ++;
-
-		(*ptr)++;
-	}
-
-	return numChars;
-}
-
-
-#if 0
-/*
- * Print registers (on target console)
- * Used only to debug the stub...
- */
-void show_gdbregs(struct gdb_regs * regs)
-{
-	/*
-	 * Saved main processor registers
-	 */
-	printk("$0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg0, regs->reg1, regs->reg2, regs->reg3,
-	       regs->reg4, regs->reg5, regs->reg6, regs->reg7);
-	printk("$8 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg8, regs->reg9, regs->reg10, regs->reg11,
-	       regs->reg12, regs->reg13, regs->reg14, regs->reg15);
-	printk("$16: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg16, regs->reg17, regs->reg18, regs->reg19,
-	       regs->reg20, regs->reg21, regs->reg22, regs->reg23);
-	printk("$24: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
-	       regs->reg24, regs->reg25, regs->reg26, regs->reg27,
-	       regs->reg28, regs->reg29, regs->reg30, regs->reg31);
-
-	/*
-	 * Saved cp0 registers
-	 */
-	printk("epc  : %08lx\nStatus: %08lx\nCause : %08lx\n",
-	       regs->cp0_epc, regs->cp0_status, regs->cp0_cause);
-}
-#endif /* dead code */
-
-/*
- * We single-step by setting breakpoints. When an exception
- * is handled, we need to restore the instructions hoisted
- * when the breakpoints were set.
- *
- * This is where we save the original instructions.
- */
-static struct gdb_bp_save {
-	unsigned long addr;
-	unsigned int val;
-} step_bp[2];
-
-#define BP 0x0000000d  /* break opcode */
-
-/*
- * Set breakpoint instructions for single stepping.
- */
-static void single_step(struct gdb_regs *regs)
-{
-	union mips_instruction insn;
-	unsigned long targ;
-	int is_branch, is_cond, i;
-
-	targ = regs->cp0_epc;
-	insn.word = *(unsigned int *)targ;
-	is_branch = is_cond = 0;
-
-	switch (insn.i_format.opcode) {
-	/*
-	 * jr and jalr are in r_format format.
-	 */
-	case spec_op:
-		switch (insn.r_format.func) {
-		case jalr_op:
-		case jr_op:
-			targ = *(&regs->reg0 + insn.r_format.rs);
-			is_branch = 1;
-			break;
-		}
-		break;
-
-	/*
-	 * This group contains:
-	 * bltz_op, bgez_op, bltzl_op, bgezl_op,
-	 * bltzal_op, bgezal_op, bltzall_op, bgezall_op.
-	 */
-	case bcond_op:
-		is_branch = is_cond = 1;
-		targ += 4 + (insn.i_format.simmediate << 2);
-		break;
-
-	/*
-	 * These are unconditional and in j_format.
-	 */
-	case jal_op:
-	case j_op:
-		is_branch = 1;
-		targ += 4;
-		targ >>= 28;
-		targ <<= 28;
-		targ |= (insn.j_format.target << 2);
-		break;
-
-	/*
-	 * These are conditional.
-	 */
-	case beq_op:
-	case beql_op:
-	case bne_op:
-	case bnel_op:
-	case blez_op:
-	case blezl_op:
-	case bgtz_op:
-	case bgtzl_op:
-	case cop0_op:
-	case cop1_op:
-	case cop2_op:
-	case cop1x_op:
-		is_branch = is_cond = 1;
-		targ += 4 + (insn.i_format.simmediate << 2);
-		break;
-	}
-
-	if (is_branch) {
-		i = 0;
-		if (is_cond && targ != (regs->cp0_epc + 8)) {
-			step_bp[i].addr = regs->cp0_epc + 8;
-			step_bp[i++].val = *(unsigned *)(regs->cp0_epc + 8);
-			*(unsigned *)(regs->cp0_epc + 8) = BP;
-		}
-		step_bp[i].addr = targ;
-		step_bp[i].val  = *(unsigned *)targ;
-		*(unsigned *)targ = BP;
-	} else {
-		step_bp[0].addr = regs->cp0_epc + 4;
-		step_bp[0].val  = *(unsigned *)(regs->cp0_epc + 4);
-		*(unsigned *)(regs->cp0_epc + 4) = BP;
-	}
-}
-
-/*
- *  If asynchronously interrupted by gdb, then we need to set a breakpoint
- *  at the interrupted instruction so that we wind up stopped with a
- *  reasonable stack frame.
- */
-static struct gdb_bp_save async_bp;
-
-/*
- * Swap the interrupted EPC with our asynchronous breakpoint routine.
- * This is safer than stuffing the breakpoint in-place, since no cache
- * flushes (or resulting smp_call_functions) are required.  The
- * assumption is that only one CPU will be handling asynchronous bp's,
- * and only one can be active at a time.
- */
-extern spinlock_t smp_call_lock;
-
-void set_async_breakpoint(unsigned long *epc)
-{
-	/* skip breaking into userland */
-	if ((*epc & 0x80000000) == 0)
-		return;
-
-#ifdef CONFIG_SMP
-	/* avoid deadlock if someone is make IPC */
-	if (spin_is_locked(&smp_call_lock))
-		return;
-#endif
-
-	async_bp.addr = *epc;
-	*epc = (unsigned long)async_breakpoint;
-}
-
-#ifdef CONFIG_SMP
-static void kgdb_wait(void *arg)
-{
-	unsigned flags;
-	int cpu = smp_processor_id();
-
-	local_irq_save(flags);
-
-	__raw_spin_lock(&kgdb_cpulock[cpu]);
-	__raw_spin_unlock(&kgdb_cpulock[cpu]);
-
-	local_irq_restore(flags);
-}
-#endif
-
-/*
- * GDB stub needs to call kgdb_wait on all processor with interrupts
- * disabled, so it uses it's own special variant.
- */
-static int kgdb_smp_call_kgdb_wait(void)
-{
-#ifdef CONFIG_SMP
-	cpumask_t mask = cpu_online_map;
-	struct call_data_struct data;
-	int cpu = smp_processor_id();
-	int cpus;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	BUG_ON(!cpu_online(cpu));
-
-	cpu_clear(cpu, mask);
-	cpus = cpus_weight(mask);
-	if (!cpus)
-		return 0;
-
-	if (spin_is_locked(&smp_call_lock)) {
-		/*
-		 * Some other processor is trying to make us do something
-		 * but we're not going to respond... give up
-		 */
-		return -1;
-		}
-
-	/*
-	 * We will continue here, accepting the fact that
-	 * the kernel may deadlock if another CPU attempts
-	 * to call smp_call_function now...
-	 */
-
-	data.func = kgdb_wait;
-	data.info = NULL;
-	atomic_set(&data.started, 0);
-	data.wait = 0;
-
-	spin_lock(&smp_call_lock);
-	call_data = &data;
-	mb();
-
-	core_send_ipi_mask(mask, SMP_CALL_FUNCTION);
-
-	/* Wait for response */
-	/* FIXME: lock-up detection, backtrace on lock-up */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	call_data = NULL;
-	spin_unlock(&smp_call_lock);
-#endif
-
-	return 0;
-}
-
-/*
- * This function does all command processing for interfacing to gdb.  It
- * returns 1 if you should skip the instruction at the trap address, 0
- * otherwise.
- */
-void handle_exception(struct gdb_regs *regs)
-{
-	int trap;			/* Trap type */
-	int sigval;
-	long addr;
-	int length;
-	char *ptr;
-	unsigned long *stack;
-	int i;
-	int bflag = 0;
-
-	kgdb_started = 1;
-
-	/*
-	 * acquire the big kgdb spinlock
-	 */
-	if (!spin_trylock(&kgdb_lock)) {
-		/*
-		 * some other CPU has the lock, we should go back to
-		 * receive the gdb_wait IPC
-		 */
-		return;
-	}
-
-	/*
-	 * If we're in async_breakpoint(), restore the real EPC from
-	 * the breakpoint.
-	 */
-	if (regs->cp0_epc == (unsigned long)async_breakinst) {
-		regs->cp0_epc = async_bp.addr;
-		async_bp.addr = 0;
-	}
-
-	/*
-	 * acquire the CPU spinlocks
-	 */
-	for_each_online_cpu(i)
-		if (__raw_spin_trylock(&kgdb_cpulock[i]) == 0)
-			panic("kgdb: couldn't get cpulock %d\n", i);
-
-	/*
-	 * force other cpus to enter kgdb
-	 */
-	kgdb_smp_call_kgdb_wait();
-
-	/*
-	 * If we're in breakpoint() increment the PC
-	 */
-	trap = (regs->cp0_cause & 0x7c) >> 2;
-	if (trap == 9 && regs->cp0_epc == (unsigned long)breakinst)
-		regs->cp0_epc += 4;
-
-	/*
-	 * If we were single_stepping, restore the opcodes hoisted
-	 * for the breakpoint[s].
-	 */
-	if (step_bp[0].addr) {
-		*(unsigned *)step_bp[0].addr = step_bp[0].val;
-		step_bp[0].addr = 0;
-
-		if (step_bp[1].addr) {
-			*(unsigned *)step_bp[1].addr = step_bp[1].val;
-			step_bp[1].addr = 0;
-		}
-	}
-
-	stack = (long *)regs->reg29;			/* stack ptr */
-	sigval = computeSignal(trap);
-
-	/*
-	 * reply to host that an exception has occurred
-	 */
-	ptr = output_buffer;
-
-	/*
-	 * Send trap type (converted to signal)
-	 */
-	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
-
-	/*
-	 * Send Error PC
-	 */
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	/*
-	 * Send frame pointer
-	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	/*
-	 * Send stack pointer
-	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
-	*ptr++ = ':';
-	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
-	*ptr++ = ';';
-
-	*ptr++ = 0;
-	putpacket(output_buffer);	/* send it off... */
-
-	/*
-	 * Wait for input from remote GDB
-	 */
-	while (1) {
-		output_buffer[0] = 0;
-		getpacket(input_buffer);
-
-		switch (input_buffer[0])
-		{
-		case '?':
-			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
-			output_buffer[3] = 0;
-			break;
-
-		/*
-		 * Detach debugger; let CPU run
-		 */
-		case 'D':
-			putpacket(output_buffer);
-			goto finish_kgdb;
-			break;
-
-		case 'd':
-			/* toggle debug flag */
-			break;
-
-		/*
-		 * Return the value of the CPU registers
-		 */
-		case 'g':
-			ptr = output_buffer;
-			ptr = mem2hex((char *)&regs->reg0, ptr, 32*sizeof(long), 0); /* r0...r31 */
-			ptr = mem2hex((char *)&regs->cp0_status, ptr, 6*sizeof(long), 0); /* cp0 */
-			ptr = mem2hex((char *)&regs->fpr0, ptr, 32*sizeof(long), 0); /* f0...31 */
-			ptr = mem2hex((char *)&regs->cp1_fsr, ptr, 2*sizeof(long), 0); /* cp1 */
-			ptr = mem2hex((char *)&regs->frame_ptr, ptr, 2*sizeof(long), 0); /* frp */
-			ptr = mem2hex((char *)&regs->cp0_index, ptr, 16*sizeof(long), 0); /* cp0 */
-			break;
-
-		/*
-		 * set the value of the CPU registers - return OK
-		 */
-		case 'G':
-		{
-			ptr = &input_buffer[1];
-			hex2mem(ptr, (char *)&regs->reg0, 32*sizeof(long), 0, 0);
-			ptr += 32*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp0_status, 6*sizeof(long), 0, 0);
-			ptr += 6*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->fpr0, 32*sizeof(long), 0, 0);
-			ptr += 32*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp1_fsr, 2*sizeof(long), 0, 0);
-			ptr += 2*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->frame_ptr, 2*sizeof(long), 0, 0);
-			ptr += 2*(2*sizeof(long));
-			hex2mem(ptr, (char *)&regs->cp0_index, 16*sizeof(long), 0, 0);
-			strcpy(output_buffer, "OK");
-		 }
-		break;
-
-		/*
-		 * mAA..AA,LLLL  Read LLLL bytes at address AA..AA
-		 */
-		case 'm':
-			ptr = &input_buffer[1];
-
-			if (hexToLong(&ptr, &addr)
-				&& *ptr++ == ','
-				&& hexToInt(&ptr, &length)) {
-				if (mem2hex((char *)addr, output_buffer, length, 1))
-					break;
-				strcpy(output_buffer, "E03");
-			} else
-				strcpy(output_buffer, "E01");
-			break;
-
-		/*
-		 * XAA..AA,LLLL: Write LLLL escaped binary bytes at address AA.AA
-		 */
-		case 'X':
-			bflag = 1;
-			/* fall through */
-
-		/*
-		 * MAA..AA,LLLL: Write LLLL bytes at address AA.AA return OK
-		 */
-		case 'M':
-			ptr = &input_buffer[1];
-
-			if (hexToLong(&ptr, &addr)
-				&& *ptr++ == ','
-				&& hexToInt(&ptr, &length)
-				&& *ptr++ == ':') {
-				if (hex2mem(ptr, (char *)addr, length, bflag, 1))
-					strcpy(output_buffer, "OK");
-				else
-					strcpy(output_buffer, "E03");
-			}
-			else
-				strcpy(output_buffer, "E02");
-			break;
-
-		/*
-		 * cAA..AA    Continue at address AA..AA(optional)
-		 */
-		case 'c':
-			/* try to read optional parameter, pc unchanged if no parm */
-
-			ptr = &input_buffer[1];
-			if (hexToLong(&ptr, &addr))
-				regs->cp0_epc = addr;
-
-			goto exit_kgdb_exception;
-			break;
-
-		/*
-		 * kill the program; let us try to restart the machine
-		 * Reset the whole machine.
-		 */
-		case 'k':
-		case 'r':
-			machine_restart("kgdb restarts machine");
-			break;
-
-		/*
-		 * Step to next instruction
-		 */
-		case 's':
-			/*
-			 * There is no single step insn in the MIPS ISA, so we
-			 * use breakpoints and continue, instead.
-			 */
-			single_step(regs);
-			goto exit_kgdb_exception;
-			/* NOTREACHED */
-			break;
-
-		/*
-		 * Set baud rate (bBB)
-		 * FIXME: Needs to be written
-		 */
-		case 'b':
-		{
-#if 0
-			int baudrate;
-			extern void set_timer_3();
-
-			ptr = &input_buffer[1];
-			if (!hexToInt(&ptr, &baudrate))
-			{
-				strcpy(output_buffer, "B01");
-				break;
-			}
-
-			/* Convert baud rate to uart clock divider */
-
-			switch (baudrate)
-			{
-				case 38400:
-					baudrate = 16;
-					break;
-				case 19200:
-					baudrate = 33;
-					break;
-				case 9600:
-					baudrate = 65;
-					break;
-				default:
-					baudrate = 0;
-					strcpy(output_buffer, "B02");
-					goto x1;
-			}
-
-			if (baudrate) {
-				putpacket("OK");	/* Ack before changing speed */
-				set_timer_3(baudrate); /* Set it */
-			}
-#endif
-		}
-		break;
-
-		}			/* switch */
-
-		/*
-		 * reply to the request
-		 */
-
-		putpacket(output_buffer);
-
-	} /* while */
-
-	return;
-
-finish_kgdb:
-	restore_debug_traps();
-
-exit_kgdb_exception:
-	/* release locks so other CPUs can go */
-	for_each_online_cpu(i)
-		__raw_spin_unlock(&kgdb_cpulock[i]);
-	spin_unlock(&kgdb_lock);
-
-	__flush_cache_all();
-	return;
-}
-
-/*
- * This function will generate a breakpoint exception.  It is used at the
- * beginning of a program to sync up with a debugger and can be used
- * otherwise as a quick means to stop program execution and "break" into
- * the debugger.
- */
-void breakpoint(void)
-{
-	if (!initialized)
-		return;
-
-	__asm__ __volatile__(
-			".globl	breakinst\n\t"
-			".set\tnoreorder\n\t"
-			"nop\n"
-			"breakinst:\tbreak\n\t"
-			"nop\n\t"
-			".set\treorder"
-			);
-}
-
-/* Nothing but the break; don't pollute any registers */
-void async_breakpoint(void)
-{
-	__asm__ __volatile__(
-			".globl	async_breakinst\n\t"
-			".set\tnoreorder\n\t"
-			"nop\n"
-			"async_breakinst:\tbreak\n\t"
-			"nop\n\t"
-			".set\treorder"
-			);
-}
-
-void adel(void)
-{
-	__asm__ __volatile__(
-			".globl\tadel\n\t"
-			"lui\t$8,0x8000\n\t"
-			"lw\t$9,1($8)\n\t"
-			);
-}
-
-/*
- * malloc is needed by gdb client in "call func()", even a private one
- * will make gdb happy
- */
-static void __used *malloc(size_t size)
-{
-	return kmalloc(size, GFP_ATOMIC);
-}
-
-static void __used free(void *where)
-{
-	kfree(where);
-}
-
-#ifdef CONFIG_GDB_CONSOLE
-
-void gdb_putsn(const char *str, int l)
-{
-	char outbuf[18];
-
-	if (!kgdb_started)
-		return;
-
-	outbuf[0]='O';
-
-	while(l) {
-		int i = (l>8)?8:l;
-		mem2hex((char *)str, &outbuf[1], i, 0);
-		outbuf[(i*2)+1]=0;
-		putpacket(outbuf);
-		str += i;
-		l -= i;
-	}
-}
-
-static void gdb_console_write(struct console *con, const char *s, unsigned n)
-{
-	gdb_putsn(s, n);
-}
-
-static struct console gdb_console = {
-	.name	= "gdb",
-	.write	= gdb_console_write,
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1
-};
-
-static int __init register_gdb_console(void)
-{
-	register_console(&gdb_console);
-
-	return 0;
-}
-
-console_initcall(register_gdb_console);
-
-#endif
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 6045b9a..8acba08 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -126,19 +126,6 @@ asmlinkage void spurious_interrupt(void)
 	atomic_inc(&irq_err_count);
 }
 
-#ifdef CONFIG_KGDB
-extern void breakpoint(void);
-extern void set_debug_traps(void);
-
-static int kgdb_flag = 1;
-static int __init nokgdb(char *str)
-{
-	kgdb_flag = 0;
-	return 1;
-}
-__setup("nokgdb", nokgdb);
-#endif
-
 void __init init_IRQ(void)
 {
 	int i;
@@ -147,12 +134,4 @@ void __init init_IRQ(void)
 		set_irq_noprobe(i);
 
 	arch_init_irq();
-
-#ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		printk("Wait for gdb client connection ...\n");
-		set_debug_traps();
-		breakpoint();
-	}
-#endif
 }
diff --git a/arch/mips/mti-malta/Makefile b/arch/mips/mti-malta/Makefile
index f806444..3b7dd72 100644
--- a/arch/mips/mti-malta/Makefile
+++ b/arch/mips/mti-malta/Makefile
@@ -13,7 +13,6 @@ obj-y				:= malta-amon.o malta-cmdline.o \
 
 obj-$(CONFIG_EARLY_PRINTK)	+= malta-console.o
 obj-$(CONFIG_PCI)		+= malta-pci.o
-obj-$(CONFIG_KGDB)		+= malta-kgdb.o
 
 # FIXME FIXME FIXME
 obj-$(CONFIG_MIPS_MT_SMTC)	+= malta_smtc.o
diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
index c065302..4832af2 100644
--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -37,15 +37,6 @@
 
 #include <asm/mips-boards/malta.h>
 
-#ifdef CONFIG_KGDB
-extern int rs_kgdb_hook(int, int);
-extern int rs_putDebugChar(char);
-extern char rs_getDebugChar(void);
-extern int saa9730_kgdb_hook(int);
-extern int saa9730_putDebugChar(char);
-extern char saa9730_getDebugChar(void);
-#endif
-
 int prom_argc;
 int *_prom_argv, *_prom_envp;
 
@@ -173,51 +164,6 @@ static void __init console_config(void)
 }
 #endif
 
-#ifdef CONFIG_KGDB
-void __init kgdb_config(void)
-{
-	extern int (*generic_putDebugChar)(char);
-	extern char (*generic_getDebugChar)(void);
-	char *argptr;
-	int line, speed;
-
-	argptr = prom_getcmdline();
-	if ((argptr = strstr(argptr, "kgdb=ttyS")) != NULL) {
-		argptr += strlen("kgdb=ttyS");
-		if (*argptr != '0' && *argptr != '1')
-			printk("KGDB: Unknown serial line /dev/ttyS%c, "
-			       "falling back to /dev/ttyS1\n", *argptr);
-		line = *argptr == '0' ? 0 : 1;
-		printk("KGDB: Using serial line /dev/ttyS%d for session\n", line);
-
-		speed = 0;
-		if (*++argptr == ',')
-		{
-			int c;
-			while ((c = *++argptr) && ('0' <= c && c <= '9'))
-				speed = speed * 10 + c - '0';
-		}
-		{
-			speed = rs_kgdb_hook(line, speed);
-			generic_putDebugChar = rs_putDebugChar;
-			generic_getDebugChar = rs_getDebugChar;
-		}
-
-		pr_info("KGDB: Using serial line /dev/ttyS%d at %d for "
-		        "session, please connect your debugger\n",
-		        line ? 1 : 0, speed);
-
-		{
-			char *s;
-			for (s = "Please connect GDB to this port\r\n"; *s; )
-				generic_putDebugChar(*s++);
-		}
-
-		/* Breakpoint is invoked after interrupts are initialised */
-	}
-}
-#endif
-
 static void __init mips_nmi_setup(void)
 {
 	void *base;
diff --git a/arch/mips/mti-malta/malta-kgdb.c b/arch/mips/mti-malta/malta-kgdb.c
deleted file mode 100644
index 6a1854d..0000000
--- a/arch/mips/mti-malta/malta-kgdb.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * This is the interface to the remote debugger stub.
- */
-#include <linux/types.h>
-#include <linux/serial.h>
-#include <linux/serialP.h>
-#include <linux/serial_reg.h>
-
-#include <asm/serial.h>
-#include <asm/io.h>
-
-static struct serial_state rs_table[] = {
-	SERIAL_PORT_DFNS	/* Defined in serial.h */
-};
-
-static struct async_struct kdb_port_info = {0};
-
-int (*generic_putDebugChar)(char);
-char (*generic_getDebugChar)(void);
-
-static __inline__ unsigned int serial_in(struct async_struct *info, int offset)
-{
-	return inb(info->port + offset);
-}
-
-static __inline__ void serial_out(struct async_struct *info, int offset,
-				int value)
-{
-	outb(value, info->port+offset);
-}
-
-int rs_kgdb_hook(int tty_no, int speed) {
-	int t;
-	struct serial_state *ser = &rs_table[tty_no];
-
-	kdb_port_info.state = ser;
-	kdb_port_info.magic = SERIAL_MAGIC;
-	kdb_port_info.port = ser->port;
-	kdb_port_info.flags = ser->flags;
-
-	/*
-	 * Clear all interrupts
-	 */
-	serial_in(&kdb_port_info, UART_LSR);
-	serial_in(&kdb_port_info, UART_RX);
-	serial_in(&kdb_port_info, UART_IIR);
-	serial_in(&kdb_port_info, UART_MSR);
-
-	/*
-	 * Now, initialize the UART
-	 */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8);	/* reset DLAB */
-	if (kdb_port_info.flags & ASYNC_FOURPORT) {
-		kdb_port_info.MCR = UART_MCR_DTR | UART_MCR_RTS;
-		t = UART_MCR_DTR | UART_MCR_OUT1;
-	} else {
-		kdb_port_info.MCR
-			= UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2;
-		t = UART_MCR_DTR | UART_MCR_RTS;
-	}
-
-	kdb_port_info.MCR = t;		/* no interrupts, please */
-	serial_out(&kdb_port_info, UART_MCR, kdb_port_info.MCR);
-
-	/*
-	 * and set the speed of the serial port
-	 */
-	if (speed == 0)
-		speed = 9600;
-
-	t = kdb_port_info.state->baud_base / speed;
-	/* set DLAB */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8 | UART_LCR_DLAB);
-	serial_out(&kdb_port_info, UART_DLL, t & 0xff);/* LS of divisor */
-	serial_out(&kdb_port_info, UART_DLM, t >> 8);  /* MS of divisor */
-	/* reset DLAB */
-	serial_out(&kdb_port_info, UART_LCR, UART_LCR_WLEN8);
-
-	return speed;
-}
-
-int putDebugChar(char c)
-{
-	return generic_putDebugChar(c);
-}
-
-char getDebugChar(void)
-{
-	return generic_getDebugChar();
-}
-
-int rs_putDebugChar(char c)
-{
-
-	if (!kdb_port_info.state) { 	/* need to init device first */
-		return 0;
-	}
-
-	while ((serial_in(&kdb_port_info, UART_LSR) & UART_LSR_THRE) == 0)
-		;
-
-	serial_out(&kdb_port_info, UART_TX, c);
-
-	return 1;
-}
-
-char rs_getDebugChar(void)
-{
-	if (!kdb_port_info.state) { 	/* need to init device first */
-		return 0;
-	}
-
-	while (!(serial_in(&kdb_port_info, UART_LSR) & 1))
-		;
-
-	return serial_in(&kdb_port_info, UART_RX);
-}
diff --git a/arch/mips/mti-malta/malta-setup.c b/arch/mips/mti-malta/malta-setup.c
index e7cad54..dc78b89 100644
--- a/arch/mips/mti-malta/malta-setup.c
+++ b/arch/mips/mti-malta/malta-setup.c
@@ -199,10 +199,6 @@ void __init plat_mem_setup(void)
 	 */
 	enable_dma(4);
 
-#ifdef CONFIG_KGDB
-	kgdb_config();
-#endif
-
 #ifdef CONFIG_DMA_COHERENT
 	if (mips_revision_sconid != MIPS_REVISION_SCON_BONITO)
 		panic("Hardware DMA cache coherency not supported");
diff --git a/arch/mips/nxp/pnx8550/common/Makefile b/arch/mips/nxp/pnx8550/common/Makefile
index 31cc1a5..dd9e7b1 100644
--- a/arch/mips/nxp/pnx8550/common/Makefile
+++ b/arch/mips/nxp/pnx8550/common/Makefile
@@ -24,6 +24,5 @@
 
 obj-y := setup.o prom.o int.o reset.o time.o proc.o platform.o
 obj-$(CONFIG_PCI) += pci.o
-obj-$(CONFIG_KGDB) += gdb_hook.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/nxp/pnx8550/common/gdb_hook.c b/arch/mips/nxp/pnx8550/common/gdb_hook.c
deleted file mode 100644
index ad4624f..0000000
--- a/arch/mips/nxp/pnx8550/common/gdb_hook.c
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- *
- * This is the interface to the remote debugger stub.
- *
- */
-#include <linux/types.h>
-#include <linux/serial.h>
-#include <linux/serialP.h>
-#include <linux/serial_reg.h>
-#include <linux/serial_ip3106.h>
-
-#include <asm/serial.h>
-#include <asm/io.h>
-
-#include <uart.h>
-
-static struct serial_state rs_table[IP3106_NR_PORTS] = {
-};
-static struct async_struct kdb_port_info = {0};
-
-void rs_kgdb_hook(int tty_no)
-{
-	struct serial_state *ser = &rs_table[tty_no];
-
-	kdb_port_info.state = ser;
-	kdb_port_info.magic = SERIAL_MAGIC;
-	kdb_port_info.port  = tty_no;
-	kdb_port_info.flags = ser->flags;
-
-	/*
-	 * Clear all interrupts
-	 */
-	/* Clear all the transmitter FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, tty_no) |= IP3106_UART_LCR_TX_RST;
-	/* Clear all the receiver FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, tty_no) |= IP3106_UART_LCR_RX_RST;
-	/* Clear all interrupts */
-	ip3106_iclr(UART_BASE, tty_no) = IP3106_UART_INT_ALLRX |
-		IP3106_UART_INT_ALLTX;
-
-	/*
-	 * Now, initialize the UART
-	 */
-	ip3106_lcr(UART_BASE, tty_no) = IP3106_UART_LCR_8BIT;
-	ip3106_baud(UART_BASE, tty_no) = 5; // 38400 Baud
-}
-
-int putDebugChar(char c)
-{
-	/* Wait until FIFO not full */
-	while (((ip3106_fifo(UART_BASE, kdb_port_info.port) & IP3106_UART_FIFO_TXFIFO) >> 16) >= 16)
-		;
-	/* Send one char */
-	ip3106_fifo(UART_BASE, kdb_port_info.port) = c;
-
-	return 1;
-}
-
-char getDebugChar(void)
-{
-	char ch;
-
-	/* Wait until there is a char in the FIFO */
-	while (!((ip3106_fifo(UART_BASE, kdb_port_info.port) &
-					IP3106_UART_FIFO_RXFIFO) >> 8))
-		;
-	/* Read one char */
-	ch = ip3106_fifo(UART_BASE, kdb_port_info.port) &
-		IP3106_UART_FIFO_RBRTHR;
-	/* Advance the RX FIFO read pointer */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_RX_NEXT;
-	return (ch);
-}
-
-void rs_disable_debug_interrupts(void)
-{
-	ip3106_ien(UART_BASE, kdb_port_info.port) = 0; /* Disable all interrupts */
-}
-
-void rs_enable_debug_interrupts(void)
-{
-	/* Clear all the transmitter FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_TX_RST;
-	/* Clear all the receiver FIFO counters (pointer and status) */
-	ip3106_lcr(UART_BASE, kdb_port_info.port) |= IP3106_UART_LCR_RX_RST;
-	/* Clear all interrupts */
-	ip3106_iclr(UART_BASE, kdb_port_info.port) = IP3106_UART_INT_ALLRX |
-		IP3106_UART_INT_ALLTX;
-	ip3106_ien(UART_BASE, kdb_port_info.port)  = IP3106_UART_INT_ALLRX; /* Enable RX interrupts */
-}
diff --git a/arch/mips/nxp/pnx8550/common/setup.c b/arch/mips/nxp/pnx8550/common/setup.c
index 92d764c..2aed50f 100644
--- a/arch/mips/nxp/pnx8550/common/setup.c
+++ b/arch/mips/nxp/pnx8550/common/setup.c
@@ -47,7 +47,6 @@ extern void pnx8550_machine_halt(void);
 extern void pnx8550_machine_power_off(void);
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
-extern void rs_kgdb_hook(int tty_no);
 extern char *prom_getcmdline(void);
 
 struct resource standard_io_resources[] = {
@@ -142,16 +141,5 @@ void __init plat_mem_setup(void)
 		ip3106_baud(UART_BASE, pnx8550_console_port) = 5;
 	}
 
-#ifdef CONFIG_KGDB
-	argptr = prom_getcmdline();
-	if ((argptr = strstr(argptr, "kgdb=ttyS")) != NULL) {
-		int line;
-		argptr += strlen("kgdb=ttyS");
-		line = *argptr == '0' ? 0 : 1;
-		rs_kgdb_hook(line);
-		pr_info("KGDB: Using ttyS%i for session, "
-		        "please connect your debugger\n", line ? 1 : 0);
-	}
-#endif
 	return;
 }
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_serial.c b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
index 9de3430..f726162 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_serial.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
@@ -38,68 +38,6 @@
 #include <msp_int.h>
 #include <msp_regs.h>
 
-#ifdef CONFIG_KGDB
-/*
- * kgdb uses serial port 1 so the console can remain on port 0.
- * To use port 0 change the definition to read as follows:
- * #define DEBUG_PORT_BASE KSEG1ADDR(MSP_UART0_BASE)
- */
-#define DEBUG_PORT_BASE KSEG1ADDR(MSP_UART1_BASE)
-
-int putDebugChar(char c)
-{
-	volatile uint32_t *uart = (volatile uint32_t *)DEBUG_PORT_BASE;
-	uint32_t val = (uint32_t)c;
-
-	local_irq_disable();
-	while( !(uart[5] & 0x20) ); /* Wait for TXRDY */
-	uart[0] = val;
-	while( !(uart[5] & 0x20) ); /* Wait for TXRDY */
-	local_irq_enable();
-
-	return 1;
-}
-
-char getDebugChar(void)
-{
-	volatile uint32_t *uart = (volatile uint32_t *)DEBUG_PORT_BASE;
-	uint32_t val;
-
-	while( !(uart[5] & 0x01) ); /* Wait for RXRDY */
-	val = uart[0];
-
-	return (char)val;
-}
-
-void initDebugPort(unsigned int uartclk, unsigned int baudrate)
-{
-	unsigned int baud_divisor = (uartclk + 8 * baudrate)/(16 * baudrate);
-
-	/* Enable FIFOs */
-	writeb(UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR |
-			UART_FCR_CLEAR_XMIT | UART_FCR_TRIGGER_4,
-		(char *)DEBUG_PORT_BASE + (UART_FCR * 4));
-
-	/* Select brtc divisor */
-	writeb(UART_LCR_DLAB, (char *)DEBUG_PORT_BASE + (UART_LCR * 4));
-
-	/* Store divisor lsb */
-	writeb(baud_divisor, (char *)DEBUG_PORT_BASE + (UART_TX * 4));
-
-	/* Store divisor msb */
-	writeb(baud_divisor >> 8, (char *)DEBUG_PORT_BASE + (UART_IER * 4));
-
-	/* Set 8N1 mode */
-	writeb(UART_LCR_WLEN8, (char *)DEBUG_PORT_BASE + (UART_LCR * 4));
-
-	/* Disable flow control */
-	writeb(0, (char *)DEBUG_PORT_BASE + (UART_MCR * 4));
-
-	/* Disable receive interrupt(!) */
-	writeb(0, (char *)DEBUG_PORT_BASE + (UART_IER * 4));
-}
-#endif
-
 void __init msp_serial_setup(void)
 {
 	char    *s;
@@ -139,17 +77,6 @@ void __init msp_serial_setup(void)
 		case MACH_MSP7120_FPGA:
 			/* Enable UART1 on MSP4200 and MSP7120 */
 			*GPIO_CFG2_REG = 0x00002299;
-
-#ifdef CONFIG_KGDB
-			/* Initialize UART1 for kgdb since PMON doesn't */
-			if( DEBUG_PORT_BASE == KSEG1ADDR(MSP_UART1_BASE) ) {
-				if( mips_machtype == MACH_MSP4200_FPGA
-				 || mips_machtype == MACH_MSP7120_FPGA )
-					initDebugPort(uartclk, 19200);
-				else
-					initDebugPort(uartclk, 57600);
-			}
-#endif
 			break;
 
 		default:
diff --git a/arch/mips/pmc-sierra/yosemite/Makefile b/arch/mips/pmc-sierra/yosemite/Makefile
index 8fd9a04..b16f95c 100644
--- a/arch/mips/pmc-sierra/yosemite/Makefile
+++ b/arch/mips/pmc-sierra/yosemite/Makefile
@@ -4,7 +4,6 @@
 
 obj-y    += irq.o prom.o py-console.o setup.o
 
-obj-$(CONFIG_KGDB)		+= dbg_io.o
 obj-$(CONFIG_SMP)		+= smp.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/pmc-sierra/yosemite/dbg_io.c b/arch/mips/pmc-sierra/yosemite/dbg_io.c
deleted file mode 100644
index 6362c70..0000000
--- a/arch/mips/pmc-sierra/yosemite/dbg_io.c
+++ /dev/null
@@ -1,180 +0,0 @@
-/*
- * Copyright 2003 PMC-Sierra
- * Author: Manish Lachwani (lachwani@pmc-sierra.com)
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-/*
- * Support for KGDB for the Yosemite board. We make use of single serial
- * port to be used for KGDB as well as console. The second serial port
- * seems to be having a problem. Single IRQ is allocated for both the
- * ports. Hence, the interrupt routing code needs to figure out whether
- * the interrupt came from channel A or B.
- */
-
-#include <asm/serial.h>
-
-/*
- * Baud rate, Parity, Data and Stop bit settings for the
- * serial port on the Yosemite. Note that the Early printk
- * patch has been added. So, we should be all set to go
- */
-#define	YOSEMITE_BAUD_2400	2400
-#define	YOSEMITE_BAUD_4800	4800
-#define	YOSEMITE_BAUD_9600	9600
-#define	YOSEMITE_BAUD_19200	19200
-#define	YOSEMITE_BAUD_38400	38400
-#define	YOSEMITE_BAUD_57600	57600
-#define	YOSEMITE_BAUD_115200	115200
-
-#define	YOSEMITE_PARITY_NONE	0
-#define	YOSEMITE_PARITY_ODD	0x08
-#define	YOSEMITE_PARITY_EVEN	0x18
-#define	YOSEMITE_PARITY_MARK	0x28
-#define	YOSEMITE_PARITY_SPACE	0x38
-
-#define	YOSEMITE_DATA_5BIT	0x0
-#define	YOSEMITE_DATA_6BIT	0x1
-#define	YOSEMITE_DATA_7BIT	0x2
-#define	YOSEMITE_DATA_8BIT	0x3
-
-#define	YOSEMITE_STOP_1BIT	0x0
-#define	YOSEMITE_STOP_2BIT	0x4
-
-/* This is crucial */
-#define	SERIAL_REG_OFS		0x1
-
-#define	SERIAL_RCV_BUFFER	0x0
-#define	SERIAL_TRANS_HOLD	0x0
-#define	SERIAL_SEND_BUFFER	0x0
-#define	SERIAL_INTR_ENABLE	(1 * SERIAL_REG_OFS)
-#define	SERIAL_INTR_ID		(2 * SERIAL_REG_OFS)
-#define	SERIAL_DATA_FORMAT	(3 * SERIAL_REG_OFS)
-#define	SERIAL_LINE_CONTROL	(3 * SERIAL_REG_OFS)
-#define	SERIAL_MODEM_CONTROL	(4 * SERIAL_REG_OFS)
-#define	SERIAL_RS232_OUTPUT	(4 * SERIAL_REG_OFS)
-#define	SERIAL_LINE_STATUS	(5 * SERIAL_REG_OFS)
-#define	SERIAL_MODEM_STATUS	(6 * SERIAL_REG_OFS)
-#define	SERIAL_RS232_INPUT	(6 * SERIAL_REG_OFS)
-#define	SERIAL_SCRATCH_PAD	(7 * SERIAL_REG_OFS)
-
-#define	SERIAL_DIVISOR_LSB	(0 * SERIAL_REG_OFS)
-#define	SERIAL_DIVISOR_MSB	(1 * SERIAL_REG_OFS)
-
-/*
- * Functions to READ and WRITE to serial port 0
- */
-#define	SERIAL_READ(ofs)		(*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE + ofs)))
-
-#define	SERIAL_WRITE(ofs, val)		((*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE + ofs))) = val)
-
-/*
- * Functions to READ and WRITE to serial port 1
- */
-#define	SERIAL_READ_1(ofs)		(*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE_1 + ofs)))
-
-#define	SERIAL_WRITE_1(ofs, val)	((*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE_1 + ofs))) = val)
-
-/*
- * Second serial port initialization
- */
-void init_second_port(void)
-{
-	/* Disable Interrupts */
-	SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x0);
-	SERIAL_WRITE_1(SERIAL_INTR_ENABLE, 0x0);
-
-	{
-		unsigned int divisor;
-
-		SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x80);
-		divisor = TITAN_SERIAL_BASE_BAUD / YOSEMITE_BAUD_115200;
-		SERIAL_WRITE_1(SERIAL_DIVISOR_LSB, divisor & 0xff);
-
-		SERIAL_WRITE_1(SERIAL_DIVISOR_MSB,
-			       (divisor & 0xff00) >> 8);
-		SERIAL_WRITE_1(SERIAL_LINE_CONTROL, 0x0);
-	}
-
-	SERIAL_WRITE_1(SERIAL_DATA_FORMAT, YOSEMITE_DATA_8BIT |
-		       YOSEMITE_PARITY_NONE | YOSEMITE_STOP_1BIT);
-
-	/* Enable Interrupts */
-	SERIAL_WRITE_1(SERIAL_INTR_ENABLE, 0xf);
-}
-
-/* Initialize the serial port for KGDB debugging */
-void debugInit(unsigned int baud, unsigned char data, unsigned char parity,
-	       unsigned char stop)
-{
-	/* Disable Interrupts */
-	SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x0);
-	SERIAL_WRITE(SERIAL_INTR_ENABLE, 0x0);
-
-	{
-		unsigned int divisor;
-
-		SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x80);
-
-		divisor = TITAN_SERIAL_BASE_BAUD / baud;
-		SERIAL_WRITE(SERIAL_DIVISOR_LSB, divisor & 0xff);
-
-		SERIAL_WRITE(SERIAL_DIVISOR_MSB, (divisor & 0xff00) >> 8);
-		SERIAL_WRITE(SERIAL_LINE_CONTROL, 0x0);
-	}
-
-	SERIAL_WRITE(SERIAL_DATA_FORMAT, data | parity | stop);
-}
-
-static int remoteDebugInitialized = 0;
-
-unsigned char getDebugChar(void)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(YOSEMITE_BAUD_115200,
-			  YOSEMITE_DATA_8BIT,
-			  YOSEMITE_PARITY_NONE, YOSEMITE_STOP_1BIT);
-	}
-
-	while ((SERIAL_READ(SERIAL_LINE_STATUS) & 0x1) == 0);
-	return SERIAL_READ(SERIAL_RCV_BUFFER);
-}
-
-int putDebugChar(unsigned char byte)
-{
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(YOSEMITE_BAUD_115200,
-			  YOSEMITE_DATA_8BIT,
-			  YOSEMITE_PARITY_NONE, YOSEMITE_STOP_1BIT);
-	}
-
-	while ((SERIAL_READ(SERIAL_LINE_STATUS) & 0x20) == 0);
-	SERIAL_WRITE(SERIAL_SEND_BUFFER, byte);
-
-	return 1;
-}
diff --git a/arch/mips/pmc-sierra/yosemite/irq.c b/arch/mips/pmc-sierra/yosemite/irq.c
index 4decc28..5f673eb 100644
--- a/arch/mips/pmc-sierra/yosemite/irq.c
+++ b/arch/mips/pmc-sierra/yosemite/irq.c
@@ -141,10 +141,6 @@ asmlinkage void plat_irq_dispatch(void)
 	}
 }
 
-#ifdef CONFIG_KGDB
-extern void init_second_port(void);
-#endif
-
 /*
  * Initialize the next level interrupt handler
  */
@@ -156,11 +152,6 @@ void __init arch_init_irq(void)
 	rm7k_cpu_irq_init();
 	rm9k_cpu_irq_init();
 
-#ifdef CONFIG_KGDB
-	/* At this point, initialize the second serial port */
-	init_second_port();
-#endif
-
 #ifdef CONFIG_GDB_CONSOLE
 	register_gdb_console();
 #endif
diff --git a/arch/mips/sgi-ip22/ip22-setup.c b/arch/mips/sgi-ip22/ip22-setup.c
index 5f389ee..0adcea5 100644
--- a/arch/mips/sgi-ip22/ip22-setup.c
+++ b/arch/mips/sgi-ip22/ip22-setup.c
@@ -81,30 +81,6 @@ void __init plat_mem_setup(void)
 		add_preferred_console("arc", 0, NULL);
 	}
 
-#ifdef CONFIG_KGDB
-	{
-	char *kgdb_ttyd = prom_getcmdline();
-
-	if ((kgdb_ttyd = strstr(kgdb_ttyd, "kgdb=ttyd")) != NULL) {
-		int line;
-		kgdb_ttyd += strlen("kgdb=ttyd");
-		if (*kgdb_ttyd != '1' && *kgdb_ttyd != '2')
-			printk(KERN_INFO "KGDB: Uknown serial line /dev/ttyd%c"
-			       ", falling back to /dev/ttyd1\n", *kgdb_ttyd);
-		line = *kgdb_ttyd == '2' ? 0 : 1;
-		printk(KERN_INFO "KGDB: Using serial line /dev/ttyd%d for "
-		       "session\n", line ? 1 : 2);
-		rs_kgdb_hook(line);
-
-		printk(KERN_INFO "KGDB: Using serial line /dev/ttyd%d for "
-		       "session, please connect your debugger\n", line ? 1:2);
-
-		kgdb_enabled = 1;
-		/* Breakpoints and stuff are in sgi_irq_setup() */
-	}
-	}
-#endif
-
 #if defined(CONFIG_VT) && defined(CONFIG_SGI_NEWPORT_CONSOLE)
 	{
 		ULONG *gfxinfo;
diff --git a/arch/mips/sgi-ip27/Makefile b/arch/mips/sgi-ip27/Makefile
index e0a6871..31f4931 100644
--- a/arch/mips/sgi-ip27/Makefile
+++ b/arch/mips/sgi-ip27/Makefile
@@ -7,7 +7,6 @@ obj-y	:= ip27-berr.o ip27-irq.o ip27-init.o ip27-klconfig.o ip27-klnuma.o \
 	   ip27-xtalk.o
 
 obj-$(CONFIG_EARLY_PRINTK)	+= ip27-console.o
-obj-$(CONFIG_KGDB)		+= ip27-dbgio.o
 obj-$(CONFIG_SMP)		+= ip27-smp.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/sgi-ip27/ip27-dbgio.c b/arch/mips/sgi-ip27/ip27-dbgio.c
deleted file mode 100644
index 08fd88b..0000000
--- a/arch/mips/sgi-ip27/ip27-dbgio.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Copyright 2004 Ralf Baechle <ralf@linux-mips.org>
- */
-#include <asm/sn/addrs.h>
-#include <asm/sn/sn0/hub.h>
-#include <asm/sn/klconfig.h>
-#include <asm/sn/ioc3.h>
-#include <asm/sn/sn_private.h>
-
-#include <linux/serial.h>
-#include <linux/serial_core.h>
-#include <linux/serial_reg.h>
-
-#define IOC3_CLK        (22000000 / 3)
-#define IOC3_FLAGS      (0)
-
-static inline struct ioc3_uartregs *console_uart(void)
-{
-	struct ioc3 *ioc3;
-
-	ioc3 = (struct ioc3 *)KL_CONFIG_CH_CONS_INFO(get_nasid())->memory_base;
-
-	return &ioc3->sregs.uarta;
-}
-
-unsigned char getDebugChar(void)
-{
-	struct ioc3_uartregs *uart = console_uart();
-
-	while ((uart->iu_lsr & UART_LSR_DR) == 0);
-	return uart->iu_rbr;
-}
-
-void putDebugChar(unsigned char c)
-{
-	struct ioc3_uartregs *uart = console_uart();
-
-	while ((uart->iu_lsr & UART_LSR_THRE) == 0);
-	uart->iu_thr = c;
-}
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index db372a0..a35818e 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -57,30 +57,6 @@ static void bcm1480_set_affinity(unsigned int irq, cpumask_t mask);
 extern unsigned long ht_eoi_space;
 #endif
 
-#ifdef CONFIG_KGDB
-#include <asm/gdb-stub.h>
-extern void breakpoint(void);
-static int kgdb_irq;
-#ifdef CONFIG_GDB_CONSOLE
-extern void register_gdb_console(void);
-#endif
-
-/* kgdb is on when configured.  Pass "nokgdb" kernel arg to turn it off */
-static int kgdb_flag = 1;
-static int __init nokgdb(char *str)
-{
-	kgdb_flag = 0;
-	return 1;
-}
-__setup("nokgdb", nokgdb);
-
-/* Default to UART1 */
-int kgdb_port = 1;
-#ifdef CONFIG_SERIAL_SB1250_DUART
-extern char sb1250_duart_present[];
-#endif
-#endif
-
 static struct irq_chip bcm1480_irq_type = {
 	.name = "BCM1480-IMR",
 	.ack = ack_bcm1480_irq,
@@ -355,61 +331,10 @@ void __init arch_init_irq(void)
 	 * does its own management of IP7.
 	 */
 
-#ifdef CONFIG_KGDB
-	imask |= STATUSF_IP6;
-#endif
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
-
-#ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		kgdb_irq = K_BCM1480_INT_UART_0 + kgdb_port;
-
-#ifdef CONFIG_SERIAL_SB1250_DUART
-		sb1250_duart_present[kgdb_port] = 0;
-#endif
-		/* Setup uart 1 settings, mapper */
-		/* QQQ FIXME */
-		__raw_writeq(M_DUART_IMR_BRK, IOADDR(A_DUART_IMRREG(kgdb_port)));
-
-		__raw_writeq(IMR_IP6_VAL,
-			     IOADDR(A_BCM1480_IMR_REGISTER(0, R_BCM1480_IMR_INTERRUPT_MAP_BASE_H) +
-			     (kgdb_irq << 3)));
-		bcm1480_unmask_irq(0, kgdb_irq);
-
-#ifdef CONFIG_GDB_CONSOLE
-		register_gdb_console();
-#endif
-		printk("Waiting for GDB on UART port %d\n", kgdb_port);
-		set_debug_traps();
-		breakpoint();
-	}
-#endif
-}
-
-#ifdef CONFIG_KGDB
-
-#include <linux/delay.h>
-
-#define duart_out(reg, val)     csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)           csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-static void bcm1480_kgdb_interrupt(void)
-{
-	/*
-	 * Clear break-change status (allow some time for the remote
-	 * host to stop the break, since we would see another
-	 * interrupt on the end-of-break too)
-	 */
-	kstat.irqs[smp_processor_id()][kgdb_irq]++;
-	mdelay(500);
-	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
-				M_DUART_RX_EN | M_DUART_TX_EN);
-	set_async_breakpoint(&get_irq_regs()->cp0_epc);
 }
 
-#endif 	/* CONFIG_KGDB */
-
 extern void bcm1480_mailbox_interrupt(void);
 
 static inline void dispatch_ip2(void)
@@ -462,11 +387,6 @@ asmlinkage void plat_irq_dispatch(void)
 		bcm1480_mailbox_interrupt();
 #endif
 
-#ifdef CONFIG_KGDB
-	else if (pending & CAUSEF_IP6)
-		bcm1480_kgdb_interrupt();		/* KGDB (uart 1) */
-#endif
-
 	else if (pending & CAUSEF_IP2)
 		dispatch_ip2();
 }
diff --git a/arch/mips/sibyte/cfe/setup.c b/arch/mips/sibyte/cfe/setup.c
index fd9604d..3de30f7 100644
--- a/arch/mips/sibyte/cfe/setup.c
+++ b/arch/mips/sibyte/cfe/setup.c
@@ -59,10 +59,6 @@ int cfe_cons_handle;
 extern unsigned long initrd_start, initrd_end;
 #endif
 
-#ifdef CONFIG_KGDB
-extern int kgdb_port;
-#endif
-
 static void __noreturn cfe_linux_exit(void *arg)
 {
 	int warm = *(int *)arg;
@@ -246,9 +242,6 @@ void __init prom_init(void)
 	int argc = fw_arg0;
 	char **envp = (char **) fw_arg2;
 	int *prom_vec = (int *) fw_arg3;
-#ifdef CONFIG_KGDB
-	char *arg;
-#endif
 
 	_machine_restart   = cfe_linux_restart;
 	_machine_halt      = cfe_linux_halt;
@@ -309,13 +302,6 @@ void __init prom_init(void)
 		}
 	}
 
-#ifdef CONFIG_KGDB
-	if ((arg = strstr(arcs_cmdline, "kgdb=duart")) != NULL)
-		kgdb_port = (arg[10] == '0') ? 0 : 1;
-	else
-		kgdb_port = 1;
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	{
 		char *ptr;
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index eac9065..a515848 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -57,16 +57,6 @@ static void sb1250_set_affinity(unsigned int irq, cpumask_t mask);
 extern unsigned long ldt_eoi_space;
 #endif
 
-#ifdef CONFIG_KGDB
-static int kgdb_irq;
-
-/* Default to UART1 */
-int kgdb_port = 1;
-#ifdef CONFIG_SERIAL_SB1250_DUART
-extern char sb1250_duart_present[];
-#endif
-#endif
-
 static struct irq_chip sb1250_irq_type = {
 	.name = "SB1250-IMR",
 	.ack = ack_sb1250_irq,
@@ -313,55 +303,10 @@ void __init arch_init_irq(void)
 	 * does its own management of IP7.
 	 */
 
-#ifdef CONFIG_KGDB
-	imask |= STATUSF_IP6;
-#endif
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
-
-#ifdef CONFIG_KGDB
-	if (kgdb_flag) {
-		kgdb_irq = K_INT_UART_0 + kgdb_port;
-
-#ifdef CONFIG_SERIAL_SB1250_DUART
-		sb1250_duart_present[kgdb_port] = 0;
-#endif
-		/* Setup uart 1 settings, mapper */
-		__raw_writeq(M_DUART_IMR_BRK,
-			     IOADDR(A_DUART_IMRREG(kgdb_port)));
-
-		__raw_writeq(IMR_IP6_VAL,
-			     IOADDR(A_IMR_REGISTER(0,
-						   R_IMR_INTERRUPT_MAP_BASE) +
-				    (kgdb_irq << 3)));
-		sb1250_unmask_irq(0, kgdb_irq);
-	}
-#endif
-}
-
-#ifdef CONFIG_KGDB
-
-#include <linux/delay.h>
-
-#define duart_out(reg, val)     csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)           csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-static void sb1250_kgdb_interrupt(void)
-{
-	/*
-	 * Clear break-change status (allow some time for the remote
-	 * host to stop the break, since we would see another
-	 * interrupt on the end-of-break too)
-	 */
-	kstat_this_cpu.irqs[kgdb_irq]++;
-	mdelay(500);
-	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
-				M_DUART_RX_EN | M_DUART_TX_EN);
-	set_async_breakpoint(&get_irq_regs()->cp0_epc);
 }
 
-#endif 	/* CONFIG_KGDB */
-
 extern void sb1250_mailbox_interrupt(void);
 
 static inline void dispatch_ip2(void)
@@ -407,11 +352,6 @@ asmlinkage void plat_irq_dispatch(void)
 		sb1250_mailbox_interrupt();
 #endif
 
-#ifdef CONFIG_KGDB
-	else if (pending & CAUSEF_IP6)			/* KGDB (uart 1) */
-		sb1250_kgdb_interrupt();
-#endif
-
 	else if (pending & CAUSEF_IP2)
 		dispatch_ip2();
 	else
diff --git a/arch/mips/sibyte/swarm/Makefile b/arch/mips/sibyte/swarm/Makefile
index 255d692..f18ba92 100644
--- a/arch/mips/sibyte/swarm/Makefile
+++ b/arch/mips/sibyte/swarm/Makefile
@@ -1,4 +1,3 @@
 obj-y				:= setup.o rtc_xicor1241.o rtc_m41t81.o
 
 obj-$(CONFIG_I2C_BOARDINFO)	+= swarm-i2c.o
-obj-$(CONFIG_KGDB)		+= dbg_io.o
diff --git a/arch/mips/sibyte/swarm/dbg_io.c b/arch/mips/sibyte/swarm/dbg_io.c
deleted file mode 100644
index b97ae30..0000000
--- a/arch/mips/sibyte/swarm/dbg_io.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * kgdb debug routines for SiByte boards.
- *
- * Copyright (C) 2001 MontaVista Software Inc.
- * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-/* -------------------- BEGINNING OF CONFIG --------------------- */
-
-#include <linux/delay.h>
-#include <asm/io.h>
-#include <asm/sibyte/sb1250.h>
-#include <asm/sibyte/sb1250_regs.h>
-#include <asm/sibyte/sb1250_uart.h>
-#include <asm/sibyte/sb1250_int.h>
-#include <asm/addrspace.h>
-
-/*
- * We use the second serial port for kgdb traffic.
- * 	115200, 8, N, 1.
- */
-
-#define	BAUD_RATE		115200
-#define	CLK_DIVISOR		V_DUART_BAUD_RATE(BAUD_RATE)
-#define	DATA_BITS		V_DUART_BITS_PER_CHAR_8		/* or 7    */
-#define	PARITY			V_DUART_PARITY_MODE_NONE	/* or even */
-#define	STOP_BITS		M_DUART_STOP_BIT_LEN_1		/* or 2    */
-
-static int duart_initialized = 0;	/* 0: need to be init'ed by kgdb */
-
-/* -------------------- END OF CONFIG --------------------- */
-extern int kgdb_port;
-
-#define	duart_out(reg, val)	csr_out32(val, IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-#define duart_in(reg)		csr_in32(IOADDR(A_DUART_CHANREG(kgdb_port, reg)))
-
-void putDebugChar(unsigned char c);
-unsigned char getDebugChar(void);
-static void
-duart_init(int clk_divisor, int data, int parity, int stop)
-{
-	duart_out(R_DUART_MODE_REG_1, data | parity);
-	duart_out(R_DUART_MODE_REG_2, stop);
-	duart_out(R_DUART_CLK_SEL, clk_divisor);
-
-	duart_out(R_DUART_CMD, M_DUART_RX_EN | M_DUART_TX_EN);	/* enable rx and tx */
-}
-
-void
-putDebugChar(unsigned char c)
-{
-	if (!duart_initialized) {
-		duart_initialized = 1;
-		duart_init(CLK_DIVISOR, DATA_BITS, PARITY, STOP_BITS);
-	}
-	while ((duart_in(R_DUART_STATUS) & M_DUART_TX_RDY) == 0);
-	duart_out(R_DUART_TX_HOLD, c);
-}
-
-unsigned char
-getDebugChar(void)
-{
-	if (!duart_initialized) {
-		duart_initialized = 1;
-		duart_init(CLK_DIVISOR, DATA_BITS, PARITY, STOP_BITS);
-	}
-	while ((duart_in(R_DUART_STATUS) & M_DUART_RX_RDY) == 0) ;
-	return duart_in(R_DUART_RX_HOLD);
-}
-
diff --git a/arch/mips/txx9/Kconfig b/arch/mips/txx9/Kconfig
index b92a134..b69901d 100644
--- a/arch/mips/txx9/Kconfig
+++ b/arch/mips/txx9/Kconfig
@@ -51,7 +51,6 @@ config SOC_TX4927
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	select GPIO_TXX9
 
@@ -72,7 +71,6 @@ config SOC_TX4938
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
-	select SYS_SUPPORTS_KGDB
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	select GPIO_TXX9
 
diff --git a/arch/mips/txx9/generic/Makefile b/arch/mips/txx9/generic/Makefile
index 668fdaa..c48ad01 100644
--- a/arch/mips/txx9/generic/Makefile
+++ b/arch/mips/txx9/generic/Makefile
@@ -7,6 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o
 obj-$(CONFIG_SOC_TX4927)	+= mem_tx4927.o irq_tx4927.o
 obj-$(CONFIG_SOC_TX4938)	+= mem_tx4938.o irq_tx4938.o
 obj-$(CONFIG_TOSHIBA_FPCIB0)	+= smsc_fdc37m81x.o
-obj-$(CONFIG_KGDB)	+= dbgio.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/txx9/generic/dbgio.c b/arch/mips/txx9/generic/dbgio.c
deleted file mode 100644
index 33b9c67..0000000
--- a/arch/mips/txx9/generic/dbgio.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * linux/arch/mips/tx4938/common/dbgio.c
- *
- * kgdb interface for gdb
- *
- * Author: MontaVista Software, Inc.
- *         source@mvista.com
- *
- * Copyright 2005 MontaVista Software Inc.
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under the terms of the GNU General Public License as published by the
- *  Free Software Foundation; either version 2 of the License, or (at your
- *  option) any later version.
- *
- *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
- *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
- *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
- *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
- *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
- *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Support for TX4938 in 2.6 - Hiroshi DOYU <Hiroshi_DOYU@montavista.co.jp>
- */
-
-#include <linux/types>
-
-extern u8 txx9_sio_kdbg_rd(void);
-extern int txx9_sio_kdbg_wr( u8 ch );
-
-u8 getDebugChar(void)
-{
-	return (txx9_sio_kdbg_rd());
-}
-
-int putDebugChar(u8 byte)
-{
-	return (txx9_sio_kdbg_wr(byte));
-}
-
diff --git a/arch/mips/txx9/jmr3927/Makefile b/arch/mips/txx9/jmr3927/Makefile
index ba292c9..20d61ac 100644
--- a/arch/mips/txx9/jmr3927/Makefile
+++ b/arch/mips/txx9/jmr3927/Makefile
@@ -3,6 +3,5 @@
 #
 
 obj-y	+= prom.o irq.o setup.o
-obj-$(CONFIG_KGDB)	+= kgdb_io.o
 
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/txx9/jmr3927/kgdb_io.c b/arch/mips/txx9/jmr3927/kgdb_io.c
deleted file mode 100644
index 5bd757e..0000000
--- a/arch/mips/txx9/jmr3927/kgdb_io.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	Low level uart routines to directly access a TX[34]927 SIO.
- *
- * Copyright 2001 MontaVista Software Inc.
- * Author: MontaVista Software, Inc.
- *         	ahennessy@mvista.com or source@mvista.com
- *
- * Based on arch/mips/ddb5xxx/ddb5477/kgdb_io.c
- *
- * Copyright (C) 2000-2001 Toshiba Corporation
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <asm/txx9/jmr3927.h>
-
-#define TIMEOUT       0xffffff
-
-static int remoteDebugInitialized = 0;
-static void debugInit(int baud);
-
-int putDebugChar(unsigned char c)
-{
-        int i = 0;
-
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(38400);
-	}
-
-        do {
-            slow_down();
-            i++;
-            if (i>TIMEOUT) {
-                break;
-            }
-        } while (!(tx3927_sioptr(0)->cisr & TXx927_SICISR_TXALS));
-	tx3927_sioptr(0)->tfifo = c;
-
-	return 1;
-}
-
-unsigned char getDebugChar(void)
-{
-        int i = 0;
-	int dicr;
-	char c;
-
-	if (!remoteDebugInitialized) {
-		remoteDebugInitialized = 1;
-		debugInit(38400);
-	}
-
-	/* diable RX int. */
-	dicr = tx3927_sioptr(0)->dicr;
-	tx3927_sioptr(0)->dicr = 0;
-
-        do {
-            slow_down();
-            i++;
-            if (i>TIMEOUT) {
-                break;
-            }
-        } while (tx3927_sioptr(0)->disr & TXx927_SIDISR_UVALID)
-		;
-	c = tx3927_sioptr(0)->rfifo;
-
-	/* clear RX int. status */
-	tx3927_sioptr(0)->disr &= ~TXx927_SIDISR_RDIS;
-	/* enable RX int. */
-	tx3927_sioptr(0)->dicr = dicr;
-
-	return c;
-}
-
-static void debugInit(int baud)
-{
-	tx3927_sioptr(0)->lcr = 0x020;
-	tx3927_sioptr(0)->dicr = 0;
-	tx3927_sioptr(0)->disr = 0x4100;
-	tx3927_sioptr(0)->cisr = 0x014;
-	tx3927_sioptr(0)->fcr = 0;
-	tx3927_sioptr(0)->flcr = 0x02;
-	tx3927_sioptr(0)->bgr = ((JMR3927_BASE_BAUD + baud / 2) / baud) |
-		TXx927_SIBGR_BCLK_T0;
-}
-- 
1.5.5.1


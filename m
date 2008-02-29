Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYB2Eg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYB2Eg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYB2Egr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:36:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:53102 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYB2Egn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=V8O5XCFwtbZkGbbvQ0O88XLNdx05TofTcmHkv+8um3YCEwlthogtrynBnuh/QmnsNgKQyq1RPz4MhTBH6PhAgNrBCR4nleN1NvzXG9UdvCPTwZpRz6UaGDo2CRh/l5XH6Bb863YWy1DUd2T3UZU0iK0CizL/ca00bgR4MfDNfsw=
Message-ID: <386072610802282036r616616cem20682e75680d0931@mail.gmail.com>
Date: Fri, 29 Feb 2008 12:36:40 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch and serial driver fixing for 2.6.25-rc4
Cc: uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       "Bryan Wu" <bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b08a929caf915283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 - Blackfin arch bug fixing
 - Blackfin serial driver bug fixing, which sent out for LKML before.

 MAINTAINERS                                       |    4 +-
 arch/blackfin/Makefile                            |    5 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |   18 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    6 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    6 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    6 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    1 +
 arch/blackfin/kernel/bfin_dma_5xx.c               |   15 +-
 arch/blackfin/kernel/gptimers.c                   |    8 +-
 arch/blackfin/kernel/setup.c                      |    5 +-
 arch/blackfin/kernel/vmlinux.lds.S                |   34 ++-
 arch/blackfin/mach-bf527/boards/ezkit.c           |   60 +++---
 arch/blackfin/mach-bf533/boards/ezkit.c           |   21 ++-
 arch/blackfin/mach-bf533/boards/stamp.c           |   43 ++--
 arch/blackfin/mach-bf537/boards/generic_board.c   |   18 --
 arch/blackfin/mach-bf537/boards/stamp.c           |   45 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c           |   25 ++-
 arch/blackfin/mach-bf548/dma.c                    |    2 +
 arch/blackfin/mach-bf548/head.S                   |    9 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |   16 ++-
 arch/blackfin/mach-common/dpmc.S                  |  137 +----------
 arch/blackfin/mach-common/ints-priority.c         |  174 +++++--------
 arch/blackfin/mm/init.c                           |    4 +-
 drivers/serial/Kconfig                            |    6 +-
 drivers/serial/bfin_5xx.c                         |  281 ++++++++++-----------
 include/asm-blackfin/gptimers.h                   |    7 +-
 include/asm-blackfin/irq.h                        |    2 +
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |   22 ++-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   24 ++-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   22 ++-
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    7 +-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   24 ++-
 include/asm-blackfin/mach-bf561/blackfin.h        |    3 +-
 include/asm-blackfin/mach-bf561/cdefBF561.h       |    2 +
 35 files changed, 504 insertions(+), 560 deletions(-)

Bryan Wu (2):
      [MAINTAINERS] use new kernel.org email for kernel development.
      [Blackfin] arch: kill section mismatch warnings

Michael Hennerich (6):
      [Blackfin] arch: fix bug - Move IWR Enable All to the end of
init_arch_irq otherwise it fails
      [Blackfin] arch: fix bug - linux-2.6.24 (delayed) disable IRQ
feature not functional for handle_simple_irq
      [Blackfin] arch: Cleanup abd Simplify:
      [Blackfin] arch: Remove DPMC char driver option
      [Blackfin] arch: Fix CONFIG_PM support for BF561
      [Blackfin] serial driver: ADSP-BF52x arch/mach support

Mike Frysinger (15):
      [Blackfin] arch: fix bug add missing header file
      [Blackfin] arch: respect `make -s` when creating the asm/mach symlink
      [Blackfin] arch: add handling for the mach symlink in the `make V=1` case
      [Blackfin] arch: add fixed code to the memory map output
      [Blackfin] arch: fix bug - set right partition size in the board files
      [Blackfin] arch: add board resources for new simple-gpio char driver
      [Blackfin] arch: grab mac address from OTP on BF527-EZKIT
      [Blackfin] arch: punt the simple ad5304 spi driver now that the
generic spidev driver lets you do it from userspace
      [Blackfin] arch: make sure we export the _bfin_swrst symbol as
modules (like the watchdog) need it
      [Blackfin] arch: make sure we have proper
description/copyright/license lines
      [Blackfin] arch: add bfin_clear_PPIx_STATUS() helper funcs like
we have for other parts
      [Blackfin] arch: handle the most common L1 shrinkage case (L1
does not exist for a part) so that any parts labeled for L1 instead
get placed into external memory sections
      [Blackfin] serial driver: fix bug - cache the bits of the LSR on
systems where the LSR is read-to-clear
      [Blackfin] serial driver: rework break flood anomaly handling to
be more robust/realistic about what we can actually work around
      [Blackfin] serial driver: use simpler comment headers and strip
out information that is maintained in the scm's log

Sonic Zhang (12):
      [Blackfin] arch: Update default config
      [Blackfin] arch: Fix bug - Setting peripheral_map only when dma
channel is UART2/3.
      Blackfin Serial driver: Fix bug - serial driver in PIO mode cant
handle input very quickly
      [Blackfin] serial driver: Clean up UART DMA code.
      [Blackfin] serial driver: Fix bug Free rx dma buffer in shutdown.
      [Blackfin] serial driver: Fix bug serial driver in DMA mode
spams history to console on shell restart
      [Blackfin] serial driver: fix bug - should not wait for the TFI
bit, just clear it when tx stop.
      [Blackfin] serial driver: Fix bug Poll RTS/CTS status in DMA mode as well
      [Blackfin] serial driver: Add flow control support to bf54x
      Blackfin Serial Driver: Fix bug - Increase buffer tail
immediately before starting tx dma.
      Blackfin Serial Driver: Fix bug - update tx dma buffer tail
before wake up processes.
      Blackfin Serial Driver: Fix bug - Only insert UART rx char in timer task.

diff --git a/MAINTAINERS b/MAINTAINERS
index 36c7bc6..8ef8c01 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -767,14 +767,14 @@ S:	Maintained

 BLACKFIN ARCHITECTURE
 P:	Bryan Wu
-M:	bryan.wu@analog.com
+M:	cooloney@kernel.org
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported

 BLACKFIN EMAC DRIVER
 P:	Bryan Wu
-M:	bryan.wu@analog.com
+M:	cooloney@kernel.org
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
diff --git a/arch/blackfin/Makefile b/arch/blackfin/Makefile
index fe254f8..75eba2c 100644
--- a/arch/blackfin/Makefile
+++ b/arch/blackfin/Makefile
@@ -98,8 +98,11 @@ drivers-$(CONFIG_OPROFILE) += arch/$(ARCH)/oprofile/
 #	them changed.  We use .mach to indicate when they were updated
 #	last, otherwise make uses the target directory mtime.

+       show_mach_symlink = :
+ quiet_show_mach_symlink = echo '  SYMLINK
include/asm-$(ARCH)/mach-$(MACHINE) -> include/asm-$(ARCH)/mach'
+silent_show_mach_symlink = :
 include/asm-blackfin/.mach: $(wildcard include/config/arch/*.h)
include/config/auto.conf
-	@echo '  SYMLINK include/asm-$(ARCH)/mach-$(MACHINE) ->
include/asm-$(ARCH)/mach'
+	@$($(quiet)show_mach_symlink)
 ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p include/asm-$(ARCH)
 	$(Q)ln -fsn $(srctree)/include/asm-$(ARCH)/mach-$(MACHINE)
include/asm-$(ARCH)/mach
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig
b/arch/blackfin/configs/BF527-EZKIT_defconfig
index d59ee15..ae320dc 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,7 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.14
-# Thu Nov 29 17:32:47 2007
+# Linux kernel version: 2.6.22.16
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -116,7 +115,10 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # Processor and Board Settings
 #
 # CONFIG_BF522 is not set
+# CONFIG_BF523 is not set
+# CONFIG_BF524 is not set
 # CONFIG_BF525 is not set
+# CONFIG_BF526 is not set
 CONFIG_BF527=y
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
@@ -306,6 +308,7 @@ CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_WB is not set
 CONFIG_BFIN_WT=y
 CONFIG_L1_MAX_PIECE=16
+# CONFIG_MPU is not set

 #
 # Asynchonous Memory Configuration
@@ -354,6 +357,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+# CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
 # Networking
@@ -496,7 +500,6 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_CFI_INTELEXT is not set
 # CONFIG_MTD_CFI_AMDSTD is not set
 # CONFIG_MTD_CFI_STAA is not set
-CONFIG_MTD_MW320D=m
 CONFIG_MTD_RAM=y
 CONFIG_MTD_ROM=m
 # CONFIG_MTD_ABSENT is not set
@@ -506,9 +509,6 @@ CONFIG_MTD_ROM=m
 #
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 # CONFIG_MTD_PHYSMAP is not set
-CONFIG_MTD_BF5xx=m
-CONFIG_BFIN_FLASH_SIZE=0x400000
-CONFIG_EBIU_FLASH_BASE=0x20000000
 # CONFIG_MTD_UCLINUX is not set
 # CONFIG_MTD_PLATRAM is not set

@@ -684,7 +684,6 @@ CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_POWERMATE is not set
 # CONFIG_INPUT_YEALINK is not set
 # CONFIG_INPUT_UINPUT is not set
-# CONFIG_BF53X_PFBUTTONS is not set
 # CONFIG_TWI_KEYPAD is not set

 #
@@ -702,12 +701,12 @@ CONFIG_INPUT_MISC=y
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
+CONFIG_BFIN_OTP=y
+# CONFIG_BFIN_OTP_WRITE_ENABLE is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
 # CONFIG_AD5304 is not set
-# CONFIG_BF5xx_TEA5764 is not set
-# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set

@@ -772,7 +771,6 @@ CONFIG_I2C_CHARDEV=m
 #
 # I2C Hardware Bus support
 #
-# CONFIG_I2C_BLACKFIN_GPIO is not set
 CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 # CONFIG_I2C_GPIO is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig
b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 811711f..9621caa 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -322,10 +322,9 @@ CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
-CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
+CONFIG_PM_BFIN_SLEEP_DEEPER=y
+# CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
-# CONFIG_PM_WAKEUP_GPIO_API is not set
-CONFIG_PM_WAKEUP_SIC_IWR=0x80

 #
 # CPU Frequency scaling
@@ -697,7 +696,6 @@ CONFIG_SERIAL_BFIN_DMA=y
 # CONFIG_SERIAL_BFIN_PIO is not set
 CONFIG_SERIAL_BFIN_UART0=y
 # CONFIG_BFIN_UART0_CTSRTS is not set
-# CONFIG_SERIAL_BFIN_UART1 is not set
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig
b/arch/blackfin/configs/BF533-STAMP_defconfig
index 198f412..b51e76c 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -323,10 +323,9 @@ CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
-CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
+CONFIG_PM_BFIN_SLEEP_DEEPER=y
+# CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
-# CONFIG_PM_WAKEUP_GPIO_API is not set
-CONFIG_PM_WAKEUP_SIC_IWR=0x80

 #
 # CPU Frequency scaling
@@ -714,7 +713,6 @@ CONFIG_SERIAL_BFIN_DMA=y
 # CONFIG_SERIAL_BFIN_PIO is not set
 CONFIG_SERIAL_BFIN_UART0=y
 # CONFIG_BFIN_UART0_CTSRTS is not set
-# CONFIG_SERIAL_BFIN_UART1 is not set
 CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_BFIN_SPORT is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig
b/arch/blackfin/configs/BF537-STAMP_defconfig
index b37ccc6..d45fa53 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -330,10 +330,9 @@ CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
-CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
+CONFIG_PM_BFIN_SLEEP_DEEPER=y
+# CONFIG_PM_BFIN_SLEEP is not set
 # CONFIG_PM_WAKEUP_BY_GPIO is not set
-# CONFIG_PM_WAKEUP_GPIO_API is not set
-CONFIG_PM_WAKEUP_SIC_IWR=0x8

 #
 # CPU Frequency scaling
@@ -1013,6 +1012,7 @@ CONFIG_SND_BFIN_AD73311_SE=4
 CONFIG_SND_SOC_AC97_BUS=y
 CONFIG_SND_SOC=m
 CONFIG_SND_BF5XX_SOC=m
+CONFIG_SND_MMAP_SUPPORT=y
 CONFIG_SND_BF5XX_SOC_AC97=m
 # CONFIG_SND_BF5XX_SOC_WM8750 is not set
 # CONFIG_SND_BF5XX_SOC_WM8731 is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig
b/arch/blackfin/configs/BF548-EZKIT_defconfig
index fd70216..c9707f7 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -396,6 +396,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+# CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
 # CPU Frequency scaling
@@ -1075,6 +1076,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 CONFIG_SND_SOC_AC97_BUS=y
 CONFIG_SND_SOC=y
 CONFIG_SND_BF5XX_SOC=y
+CONFIG_SND_MMAP_SUPPORT=y
 CONFIG_SND_BF5XX_SOC_AC97=y
 CONFIG_SND_BF5XX_SOC_BF548_EZKIT=y
 # CONFIG_SND_BF5XX_SOC_WM8750 is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig
b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 8546994..4d8a633 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -367,6 +367,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 # CONFIG_PM is not set
+# CONFIG_PM_WAKEUP_BY_GPIO is not set

 #
 # Networking
diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c
b/arch/blackfin/kernel/bfin_dma_5xx.c
index 5453bc3..8fd5d22 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -105,13 +105,14 @@ int request_dma(unsigned int channel, char *device_id)
 	mutex_unlock(&(dma_ch[channel].dmalock));

 #ifdef CONFIG_BF54x
-	if (channel >= CH_UART2_RX && channel <= CH_UART3_TX &&
-		strncmp(device_id, "BFIN_UART", 9) == 0)
-		dma_ch[channel].regs->peripheral_map |=
-			(channel - CH_UART2_RX + 0xC);
-	else
-		dma_ch[channel].regs->peripheral_map |=
-			(channel - CH_UART2_RX + 0x6);
+	if (channel >= CH_UART2_RX && channel <= CH_UART3_TX) {
+		if (strncmp(device_id, "BFIN_UART", 9) == 0)
+			dma_ch[channel].regs->peripheral_map |=
+				(channel - CH_UART2_RX + 0xC);
+		else
+			dma_ch[channel].regs->peripheral_map |=
+				(channel - CH_UART2_RX + 0x6);
+	}
 #endif

 	dma_ch[channel].device_id = device_id;
diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
index 5cf4bdb..1904d8b 100644
--- a/arch/blackfin/kernel/gptimers.c
+++ b/arch/blackfin/kernel/gptimers.c
@@ -1,9 +1,9 @@
 /*
- * bfin_gptimers.c - derived from bf53x_timers.c
- *  Driver for General Purpose Timer functions on the Blackfin processor
+ * gptimers.c - Blackfin General Purpose Timer core API
  *
- *  Copyright (C) 2005 John DeHority
- *  Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
+ * Copyright (c) 2005-2008 Analog Devices Inc.
+ * Copyright (C) 2005 John DeHority
+ * Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
  *
  * Licensed under the GPLv2.
  */
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 8229b10..2255c28 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -32,6 +32,7 @@
 static DEFINE_PER_CPU(struct cpu, cpu_devices);

 u16 _bfin_swrst;
+EXPORT_SYMBOL(_bfin_swrst);

 unsigned long memory_start, memory_end, physical_mem_end;
 unsigned long reserved_mem_dcache_on;
@@ -514,6 +515,7 @@ static __init void  memory_setup(void)
 	printk(KERN_INFO "Kernel Managed Memory: %ldMB\n", _ramend >> 20);

 	printk(KERN_INFO "Memory map:\n"
+		KERN_INFO "  fixedcode = 0x%p-0x%p\n"
 		KERN_INFO "  text      = 0x%p-0x%p\n"
 		KERN_INFO "  rodata    = 0x%p-0x%p\n"
 		KERN_INFO "  bss       = 0x%p-0x%p\n"
@@ -527,7 +529,8 @@ static __init void  memory_setup(void)
 #if DMA_UNCACHED_REGION > 0
 		KERN_INFO "  DMA Zone  = 0x%p-0x%p\n"
 #endif
-		, _stext, _etext,
+		, (void *)FIXED_CODE_START, (void *)FIXED_CODE_END,
+		_stext, _etext,
 		__start_rodata, __end_rodata,
 		__bss_start, __bss_stop,
 		_sdata, _edata,
diff --git a/arch/blackfin/kernel/vmlinux.lds.S
b/arch/blackfin/kernel/vmlinux.lds.S
index aed8325..cb01a9d 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -147,44 +147,64 @@ SECTIONS

 	__l1_lma_start = .;

+#if L1_CODE_LENGTH
+# define LDS_L1_CODE *(.l1.text)
+#else
+# define LDS_L1_CODE
+#endif
 	.text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
 	{
 		. = ALIGN(4);
 		__stext_l1 = .;
-		*(.l1.text)
-
+		LDS_L1_CODE
 		. = ALIGN(4);
 		__etext_l1 = .;
 	}

+#if L1_DATA_A_LENGTH
+# define LDS_L1_A_DATA  *(.l1.data)
+# define LDS_L1_A_BSS   *(.l1.bss)
+# define LDS_L1_A_CACHE *(.data_l1.cacheline_aligned)
+#else
+# define LDS_L1_A_DATA
+# define LDS_L1_A_BSS
+# define LDS_L1_A_CACHE
+#endif
 	.data_l1 L1_DATA_A_START : AT(LOADADDR(.text_l1) + SIZEOF(.text_l1))
 	{
 		. = ALIGN(4);
 		__sdata_l1 = .;
-		*(.l1.data)
+		LDS_L1_A_DATA
 		__edata_l1 = .;

 		. = ALIGN(4);
 		__sbss_l1 = .;
-		*(.l1.bss)
+		LDS_L1_A_BSS

 		. = ALIGN(32);
-		*(.data_l1.cacheline_aligned)
+		LDS_L1_A_CACHE

 		. = ALIGN(4);
 		__ebss_l1 = .;
 	}

+#if L1_DATA_B_LENGTH
+# define LDS_L1_B_DATA  *(.l1.data.B)
+# define LDS_L1_B_BSS   *(.l1.bss.B)
+#else
+# define LDS_L1_B_DATA
+# define LDS_L1_B_BSS
+#endif
 	.data_b_l1 L1_DATA_B_START : AT(LOADADDR(.data_l1) + SIZEOF(.data_l1))
 	{
 		. = ALIGN(4);
 		__sdata_b_l1 = .;
-		*(.l1.data.B)
+		LDS_L1_B_DATA
 		__edata_b_l1 = .;

 		. = ALIGN(4);
 		__sbss_b_l1 = .;
-		*(.l1.bss.B)
+		LDS_L1_B_BSS

 		. = ALIGN(4);
 		__ebss_b_l1 = .;
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c
b/arch/blackfin/mach-bf527/boards/ezkit.c
index 337515f..cf4bc0d 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -180,8 +180,8 @@ static struct mtd_partition partition_info[] = {
 	},
 	{
 		.name = "File System",
-		.offset = 4 * SIZE_1M,
-		.size = (256 - 4) * SIZE_1M,
+		.offset = MTDPART_OFS_APPEND,
+		.size = MTDPART_SIZ_FULL,
 	},
 };

@@ -422,11 +422,11 @@ static struct mtd_partition
bfin_spi_flash_partitions[] = {
 	}, {
 		.name = "kernel",
 		.size = 0xe0000,
-		.offset = 0x20000
+		.offset = MTDPART_OFS_APPEND,
 	}, {
 		.name = "file system",
-		.size = 0x700000,
-		.offset = 0x00100000,
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
 	}
 };

@@ -484,13 +484,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 };
 #endif

-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -611,17 +604,6 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-	{
-		.modalias = "ad5304_spi",
-		.max_speed_hz = 1250000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 2,
-		.platform_data = NULL,
-		.controller_data = &ad5304_chip_info,
-		.mode = SPI_MODE_2,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
@@ -818,6 +800,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 	&bf5xx_nand_device,
@@ -895,6 +890,8 @@ static struct platform_device *stamp_devices[]
__initdata = {
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
+
+	&bfin_gpios_device,
 };

 static int __init stamp_init(void)
@@ -921,13 +918,18 @@ void native_machine_restart(char *cmd)
 		bfin_gpio_reset_spi0_ssel1();
 }

-/*
- * Currently the MAC address is saved in Flash by U-Boot
- */
-#define FLASH_MAC	0x203f0000
 void bfin_get_ether_addr(char *addr)
 {
-	*(u32 *)(&(addr[0])) = bfin_read32(FLASH_MAC);
-	*(u16 *)(&(addr[4])) = bfin_read16(FLASH_MAC + 4);
+	/* the MAC is stored in OTP memory page 0xDF */
+	u32 ret;
+	u64 otp_mac;
+	u32 (*otp_read)(u32 page, u32 flags, u64 *page_content) = (void *)0xEF00001A;
+
+	ret = otp_read(0xDF, 0x00, &otp_mac);
+	if (!(ret & 0x1)) {
+		char *otp_mac_p = (char *)&otp_mac;
+		for (ret = 0; ret < 6; ++ret)
+			addr[ret] = otp_mac_p[5 - ret];
+	}
 }
 EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c
b/arch/blackfin/mach-bf533/boards/ezkit.c
index 2b09aa3..241b5a2 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -99,11 +99,11 @@ static struct mtd_partition bfin_spi_flash_partitions[] = {
 	}, {
 		.name = "kernel",
 		.size = 0xe0000,
-		.offset = 0x20000
+		.offset = MTDPART_OFS_APPEND,
 	}, {
 		.name = "file system",
-		.size = 0x700000,
-		.offset = 0x00100000,
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
 	}
 };

@@ -298,6 +298,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>

@@ -350,6 +363,8 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 	&i2c_gpio_device,
 #endif
+
+	&bfin_gpios_device,
 };

 static int __init ezkit_init(void)
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c
b/arch/blackfin/mach-bf533/boards/stamp.c
index a645f6f..b2ac481 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -112,7 +112,7 @@ static struct platform_device net2272_bfin_device = {
 static struct mtd_partition stamp_partitions[] = {
 	{
 		.name   = "Bootloader",
-		.size   = 0x20000,
+		.size   = 0x40000,
 		.offset = 0,
 	}, {
 		.name   = "Kernel",
@@ -160,17 +160,17 @@ static struct platform_device stamp_flash_device = {
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
 		.name = "bootloader",
-		.size = 0x00020000,
+		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
 		.name = "kernel",
 		.size = 0xe0000,
-		.offset = 0x20000
+		.offset = MTDPART_OFS_APPEND,
 	}, {
 		.name = "file system",
-		.size = 0x700000,
-		.offset = 0x00100000,
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
 	}
 };

@@ -212,13 +212,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 };
 #endif

-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 static struct bfin5xx_spi_chip spi_mmc_chip_info = {
 	.enable_dma = 1,
@@ -308,17 +301,6 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-	{
-		.modalias = "ad5304_spi",
-		.max_speed_hz = 1000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 2,
-		.platform_data = NULL,
-		.controller_data = &ad5304_chip_info,
-		.mode = SPI_MODE_2,
-	},
-#endif
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
@@ -457,6 +439,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>

@@ -518,6 +513,8 @@ static struct platform_device *stamp_devices[]
__initdata = {
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 	&i2c_gpio_device,
 #endif
+
+	&bfin_gpios_device,
 	&stamp_flash_device,
 };

diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c
b/arch/blackfin/mach-bf537/boards/generic_board.c
index 8a3397d..c95395b 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -371,13 +371,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 };
 #endif

-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -483,17 +476,6 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-	{
-		.modalias = "ad5304_spi",
-		.max_speed_hz = 1250000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 2,
-		.platform_data = NULL,
-		.controller_data = &ad5304_chip_info,
-		.mode = SPI_MODE_2,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index 9e2277e..ea83148 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -128,6 +128,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 static struct resource bfin_pcmcia_cf_resources[] = {
 	{
@@ -343,7 +356,7 @@ static struct platform_device net2272_bfin_device = {
 static struct mtd_partition stamp_partitions[] = {
 	{
 		.name       = "Bootloader",
-		.size       = 0x20000,
+		.size       = 0x40000,
 		.offset     = 0,
 	}, {
 		.name       = "Kernel",
@@ -351,7 +364,7 @@ static struct mtd_partition stamp_partitions[] = {
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
 		.name       = "RootFS",
-		.size       = 0x400000 - 0x20000 - 0xE0000 - 0x10000,
+		.size       = 0x400000 - 0x40000 - 0xE0000 - 0x10000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
 		.name       = "MAC Address",
@@ -391,17 +404,17 @@ static struct platform_device stamp_flash_device = {
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
 		.name = "bootloader",
-		.size = 0x00020000,
+		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
 		.name = "kernel",
 		.size = 0xe0000,
-		.offset = 0x20000
+		.offset = MTDPART_OFS_APPEND,
 	}, {
 		.name = "file system",
-		.size = 0x700000,
-		.offset = 0x00100000,
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
 	}
 };

@@ -459,13 +472,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 };
 #endif

-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -578,17 +584,6 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
-	{
-		.modalias = "ad5304_spi",
-		.max_speed_hz = 1250000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 2,
-		.platform_data = NULL,
-		.controller_data = &ad5304_chip_info,
-		.mode = SPI_MODE_2,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
@@ -821,6 +816,8 @@ static struct platform_device *stamp_devices[]
__initdata = {
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
+
+	&bfin_gpios_device,
 	&stamp_flash_device,
 };

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
b/arch/blackfin/mach-bf548/boards/ezkit.c
index 916e963..a0950c1 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -285,8 +285,8 @@ static struct mtd_partition partition_info[] = {
 	},
 	{
 		.name = "File System",
-		.offset = 4 * SIZE_1M,
-		.size = (256 - 4) * SIZE_1M,
+		.offset = MTDPART_OFS_APPEND,
+		.size = MTDPART_SIZ_FULL,
 	},
 };

@@ -333,7 +333,7 @@ static struct platform_device bf54x_sdh_device = {
 static struct mtd_partition ezkit_partitions[] = {
 	{
 		.name       = "Bootloader",
-		.size       = 0x20000,
+		.size       = 0x40000,
 		.offset     = 0,
 	}, {
 		.name       = "Kernel",
@@ -381,8 +381,8 @@ static struct mtd_partition bfin_spi_flash_partitions[] = {
 		.mask_flags = MTD_CAP_ROM
 	}, {
 		.name = "linux kernel",
-		.size = 0x1c0000,
-		.offset = 0x40000
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
 	}
 };

@@ -594,6 +594,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 static struct platform_device *ezkit_devices[] __initdata = {
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
@@ -646,6 +659,8 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
+
+	&bfin_gpios_device,
 	&ezkit_flash_device,
 };

diff --git a/arch/blackfin/mach-bf548/dma.c b/arch/blackfin/mach-bf548/dma.c
index 374803a..f547929 100644
--- a/arch/blackfin/mach-bf548/dma.c
+++ b/arch/blackfin/mach-bf548/dma.c
@@ -27,6 +27,8 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */

+#include <linux/module.h>
+
 #include <asm/blackfin.h>
 #include <asm/dma.h>

diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 74fe258..46222a7 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -28,6 +28,7 @@
  */

 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/blackfin.h>
 #include <asm/trace.h>
 #if CONFIG_BFIN_KERNEL_CLOCK
@@ -44,10 +45,9 @@

 #define INITIAL_STACK   0xFFB01000

-.text
+__INIT

 ENTRY(__start)
-ENTRY(__stext)
 	/* R0: argument of command line string, passed from uboot, save it */
 	R7 = R0;
 	/* Enable Cycle Counter and Nesting Of Interrupts */
@@ -213,6 +213,7 @@ ENTRY(__stext)

 .LWAIT_HERE:
 	jump .LWAIT_HERE;
+ENDPROC(__start)

 ENTRY(_real_start)
 	[ -- sp ] = reti;
@@ -285,6 +286,9 @@ ENTRY(_real_start)
 	call _start_kernel;
 .L_exit:
 	jump.s	.L_exit;
+ENDPROC(_real_start)
+
+__FINIT

 .section .l1.text
 #if CONFIG_BFIN_KERNEL_CLOCK
@@ -450,6 +454,7 @@ ENTRY(_start_dma_code)
 	SSYNC;

 	RTS;
+ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */

 .data
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c
b/arch/blackfin/mach-bf561/boards/ezkit.c
index 43c1b09..d357f64 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -223,7 +223,7 @@ static struct platform_device bfin_uart_device = {
 static struct mtd_partition ezkit_partitions[] = {
 	{
 		.name       = "Bootloader",
-		.size       = 0x20000,
+		.size       = 0x40000,
 		.offset     = 0,
 	}, {
 		.name       = "Kernel",
@@ -389,6 +389,19 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
 #if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
 #include <linux/i2c-gpio.h>

@@ -446,6 +459,7 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 	&isp1362_hcd_device,
 #endif

+	&bfin_gpios_device,
 	&ezkit_flash_device,
 };

diff --git a/arch/blackfin/mach-common/dpmc.S b/arch/blackfin/mach-common/dpmc.S
index b80ddd8..9d45aa3 100644
--- a/arch/blackfin/mach-common/dpmc.S
+++ b/arch/blackfin/mach-common/dpmc.S
@@ -31,140 +31,6 @@
 #include <asm/blackfin.h>
 #include <asm/mach/irq.h>

-.text
-
-ENTRY(_unmask_wdog_wakeup_evt)
-	[--SP] = ( R7:0, P5:0 );
-#if defined(CONFIG_BF561)
-	P0.H = hi(SICA_IWR1);
-	P0.L = lo(SICA_IWR1);
-#elif defined(CONFIG_BF54x) || defined(CONFIG_BF52x)
-	P0.h = HI(SIC_IWR0);
-	P0.l = LO(SIC_IWR0);
-#else
-	P0.h = HI(SIC_IWR);
-	P0.l = LO(SIC_IWR);
-#endif
-	R7 = [P0];
-#if defined(CONFIG_BF561)
-	BITSET(R7, 27);
-#else
-	BITSET(R7,(IRQ_WATCH - IVG7));
-#endif
-	[P0] = R7;
-	SSYNC;
-
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-.LWRITE_TO_STAT:
-	/* When watch dog timer is enabled, a write to STAT will load the
-	 * contents of CNT to STAT
-	 */
-	R7 = 0x0000(z);
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_STAT);
-	P0.l = LO(WDOGA_STAT);
-#else
-	P0.h = HI(WDOG_STAT);
-	P0.l = LO(WDOG_STAT);
-#endif
-	[P0] = R7;
-	SSYNC;
-	JUMP .LSKIP_WRITE_TO_STAT;
-
-ENTRY(_program_wdog_timer)
-	[--SP] = ( R7:0, P5:0 );
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_CNT);
-	P0.l = LO(WDOGA_CNT);
-#else
-	P0.h = HI(WDOG_CNT);
-	P0.l = LO(WDOG_CNT);
-#endif
-	[P0] = R0;
-	SSYNC;
-
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_CTL);
-	P0.l = LO(WDOGA_CTL);
-#else
-	P0.h = HI(WDOG_CTL);
-	P0.l = LO(WDOG_CTL);
-#endif
-	R7 = W[P0](Z);
-	CC = BITTST(R7,1);
-	if !CC JUMP .LWRITE_TO_STAT;
-	CC = BITTST(R7,2);
-	if !CC JUMP .LWRITE_TO_STAT;
-
-.LSKIP_WRITE_TO_STAT:
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_CTL);
-	P0.l = LO(WDOGA_CTL);
-#else
-	P0.h = HI(WDOG_CTL);
-	P0.l = LO(WDOG_CTL);
-#endif
-	R7 = W[P0](Z);
-	BITCLR(R7,1);   /* Enable GP event */
-	BITSET(R7,2);
-	W[P0] = R7.L;
-	SSYNC;
-	NOP;
-
-	R7 = W[P0](Z);
-	BITCLR(R7,4);   /* Enable the wdog counter */
-	W[P0] = R7.L;
-	SSYNC;
-
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-ENTRY(_clear_wdog_wakeup_evt)
-	[--SP] = ( R7:0, P5:0 );
-
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_CTL);
-	P0.l = LO(WDOGA_CTL);
-#else
-	P0.h = HI(WDOG_CTL);
-	P0.l = LO(WDOG_CTL);
-#endif
-	R7 = 0x0AD6(Z);
-	W[P0] = R7.L;
-	SSYNC;
-
-	R7 = W[P0](Z);
-	BITSET(R7,15);
-	W[P0] = R7.L;
-	SSYNC;
-
-	R7 = W[P0](Z);
-	BITSET(R7,1);
-	BITSET(R7,2);
-	W[P0] = R7.L;
-	SSYNC;
-
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-ENTRY(_disable_wdog_timer)
-	[--SP] = ( R7:0, P5:0 );
-#if defined(CONFIG_BF561)
-	P0.h = HI(WDOGA_CTL);
-	P0.l = LO(WDOGA_CTL);
-#else
-	P0.h = HI(WDOG_CTL);
-	P0.l = LO(WDOG_CTL);
-#endif
-	R7 = 0xAD6(Z);
-	W[P0] = R7.L;
-	SSYNC;
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-#if !defined(CONFIG_BF561)

 .section .l1.text

@@ -459,10 +325,12 @@ ENTRY(_set_sic_iwr)
 	RTS;

 ENTRY(_set_rtc_istat)
+#ifndef CONFIG_BF561
 	P0.H = hi(RTC_ISTAT);
 	P0.L = lo(RTC_ISTAT);
 	w[P0] = R0.L;
 	SSYNC;
+#endif
 	RTS;

 ENTRY(_test_pll_locked)
@@ -473,4 +341,3 @@ ENTRY(_test_pll_locked)
 	CC = BITTST(R0,5);
 	IF !CC JUMP 1b;
 	RTS;
-#endif
diff --git a/arch/blackfin/mach-common/ints-priority.c
b/arch/blackfin/mach-common/ints-priority.c
index 880595a..225ef14 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -74,7 +74,7 @@ unsigned long bfin_sic_iwr[3];	/* Up to 3 SIC_IWRx
registers */
 #endif

 struct ivgx {
-	/* irq number for request_irq, available in mach-bf533/irq.h */
+	/* irq number for request_irq, available in mach-bf5xx/irq.h */
 	unsigned int irqno;
 	/* corresponding bit in the SIC_ISR register */
 	unsigned int isrflag;
@@ -86,7 +86,6 @@ struct ivg_slice {
 	struct ivgx *istop;
 } ivg7_13[IVG13 - IVG7 + 1];

-static void search_IAR(void);

 /*
  * Search SIC_IAR and fill tables with the irqvalues
@@ -120,10 +119,10 @@ static void __init search_IAR(void)
 }

 /*
- * This is for BF533 internal IRQs
+ * This is for core internal IRQs
  */

-static void ack_noop(unsigned int irq)
+static void bfin_ack_noop(unsigned int irq)
 {
 	/* Dummy function.  */
 }
@@ -156,11 +155,11 @@ static void bfin_internal_mask_irq(unsigned int irq)
 {
 #ifdef CONFIG_BF53x
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() &
-			     ~(1 << (irq - (IRQ_CORETMR + 1))));
+			     ~(1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
-	mask_bank = (irq - (IRQ_CORETMR + 1)) / 32;
-	mask_bit = (irq - (IRQ_CORETMR + 1)) % 32;
+	mask_bank = SIC_SYSIRQ(irq) / 32;
+	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) &
 			     ~(1 << mask_bit));
 #endif
@@ -171,11 +170,11 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 {
 #ifdef CONFIG_BF53x
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() |
-			     (1 << (irq - (IRQ_CORETMR + 1))));
+			     (1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
-	mask_bank = (irq - (IRQ_CORETMR + 1)) / 32;
-	mask_bit = (irq - (IRQ_CORETMR + 1)) % 32;
+	mask_bank = SIC_SYSIRQ(irq) / 32;
+	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) |
 			     (1 << mask_bit));
 #endif
@@ -187,8 +186,8 @@ int bfin_internal_set_wake(unsigned int irq,
unsigned int state)
 {
 	unsigned bank, bit;
 	unsigned long flags;
-	bank = (irq - (IRQ_CORETMR + 1)) / 32;
-	bit = (irq - (IRQ_CORETMR + 1)) % 32;
+	bank = SIC_SYSIRQ(irq) / 32;
+	bit = SIC_SYSIRQ(irq) % 32;

 	local_irq_save(flags);

@@ -204,15 +203,18 @@ int bfin_internal_set_wake(unsigned int irq,
unsigned int state)
 #endif

 static struct irq_chip bfin_core_irqchip = {
-	.ack = ack_noop,
+	.ack = bfin_ack_noop,
 	.mask = bfin_core_mask_irq,
 	.unmask = bfin_core_unmask_irq,
 };

 static struct irq_chip bfin_internal_irqchip = {
-	.ack = ack_noop,
+	.ack = bfin_ack_noop,
 	.mask = bfin_internal_mask_irq,
 	.unmask = bfin_internal_unmask_irq,
+	.mask_ack = bfin_internal_mask_irq,
+	.disable = bfin_internal_mask_irq,
+	.enable = bfin_internal_unmask_irq,
 #ifdef CONFIG_PM
 	.set_wake = bfin_internal_set_wake,
 #endif
@@ -221,38 +223,23 @@ static struct irq_chip bfin_internal_irqchip = {
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
 static int error_int_mask;

-static void bfin_generic_error_ack_irq(unsigned int irq)
-{
-
-}
-
 static void bfin_generic_error_mask_irq(unsigned int irq)
 {
 	error_int_mask &= ~(1L << (irq - IRQ_PPI_ERROR));

-	if (!error_int_mask) {
-		local_irq_disable();
-		bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() &
-				     ~(1 << (IRQ_GENERIC_ERROR -
-					(IRQ_CORETMR + 1))));
-		SSYNC();
-		local_irq_enable();
-	}
+	if (!error_int_mask)
+		bfin_internal_mask_irq(IRQ_GENERIC_ERROR);
 }

 static void bfin_generic_error_unmask_irq(unsigned int irq)
 {
-	local_irq_disable();
-	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() | 1 <<
-			     (IRQ_GENERIC_ERROR - (IRQ_CORETMR + 1)));
-	SSYNC();
-	local_irq_enable();
-
+	bfin_internal_unmask_irq(IRQ_GENERIC_ERROR);
 	error_int_mask |= 1L << (irq - IRQ_PPI_ERROR);
 }

 static struct irq_chip bfin_generic_error_irqchip = {
-	.ack = bfin_generic_error_ack_irq,
+	.ack = bfin_ack_noop,
+	.mask_ack = bfin_generic_error_mask_irq,
 	.mask = bfin_generic_error_mask_irq,
 	.unmask = bfin_generic_error_unmask_irq,
 };
@@ -608,7 +595,7 @@ static struct pin_int_t *pint[NR_PINT_SYS_IRQS] = {
 	(struct pin_int_t *)PINT3_MASK_SET,
 };

-unsigned short get_irq_base(u8 bank, u8 bmap)
+inline unsigned short get_irq_base(u8 bank, u8 bmap)
 {

 	u16 irq_base;
@@ -969,17 +956,12 @@ int __init init_arch_irq(void)
 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
 	bfin_write_SIC_IMASK0(SIC_UNMASK_ALL);
 	bfin_write_SIC_IMASK1(SIC_UNMASK_ALL);
-	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
-	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
 # ifdef CONFIG_BF54x
 	bfin_write_SIC_IMASK2(SIC_UNMASK_ALL);
-	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
 # endif
 #else
 	bfin_write_SIC_IMASK(SIC_UNMASK_ALL);
-	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
 #endif
-	SSYNC();

 	local_irq_disable();

@@ -1001,90 +983,53 @@ int __init init_arch_irq(void)
 			set_irq_chip(irq, &bfin_core_irqchip);
 		else
 			set_irq_chip(irq, &bfin_internal_irqchip);
-#ifdef BF537_GENERIC_ERROR_INT_DEMUX
-		if (irq != IRQ_GENERIC_ERROR) {
-#endif

-			switch (irq) {
+		switch (irq) {
 #if defined(CONFIG_BF53x)
-			case IRQ_PROG_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
+		case IRQ_PROG_INTA:
 # if defined(BF537_FAMILY) && !(defined(CONFIG_BFIN_MAC) ||
defined(CONFIG_BFIN_MAC_MODULE))
-			case IRQ_MAC_RX:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
+		case IRQ_MAC_RX:
 # endif
 #elif defined(CONFIG_BF54x)
-			case IRQ_PINT0:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PINT1:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PINT2:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PINT3:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
+		case IRQ_PINT0:
+		case IRQ_PINT1:
+		case IRQ_PINT2:
+		case IRQ_PINT3:
 #elif defined(CONFIG_BF52x)
-			case IRQ_PORTF_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PORTG_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PORTH_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
+		case IRQ_PORTF_INTA:
+		case IRQ_PORTG_INTA:
+		case IRQ_PORTH_INTA:
 #elif defined(CONFIG_BF561)
-			case IRQ_PROG0_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PROG1_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
-			case IRQ_PROG2_INTA:
-				set_irq_chained_handler(irq,
-							bfin_demux_gpio_irq);
-				break;
+		case IRQ_PROG0_INTA:
+		case IRQ_PROG1_INTA:
+		case IRQ_PROG2_INTA:
 #endif
-			default:
-				set_irq_handler(irq, handle_simple_irq);
-				break;
-			}
-
+			set_irq_chained_handler(irq,
+						bfin_demux_gpio_irq);
+			break;
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
-		} else {
+		case IRQ_GENERIC_ERROR:
 			set_irq_handler(irq, bfin_demux_error_irq);
-		}
+
+			break;
 #endif
+		default:
+			set_irq_handler(irq, handle_simple_irq);
+			break;
+		}
 	}
+
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
-	for (irq = IRQ_PPI_ERROR; irq <= IRQ_UART1_ERROR; irq++) {
-		set_irq_chip(irq, &bfin_generic_error_irqchip);
-		set_irq_handler(irq, handle_level_irq);
-	}
+	for (irq = IRQ_PPI_ERROR; irq <= IRQ_UART1_ERROR; irq++)
+		set_irq_chip_and_handler(irq, &bfin_generic_error_irqchip,
+					 handle_level_irq);
 #endif

-	for (irq = GPIO_IRQ_BASE; irq < NR_IRQS; irq++) {
+	/* if configured as edge, then will be changed to do_edge_IRQ */
+	for (irq = GPIO_IRQ_BASE; irq < NR_IRQS; irq++)
+		set_irq_chip_and_handler(irq, &bfin_gpio_irqchip,
+					 handle_level_irq);

-		set_irq_chip(irq, &bfin_gpio_irqchip);
-		/* if configured as edge, then will be changed to do_edge_IRQ */
-		set_irq_handler(irq, handle_level_irq);
-	}

 	bfin_write_IMASK(0);
 	CSYNC();
@@ -1106,6 +1051,16 @@ int __init init_arch_irq(void)
 	    IMASK_IVG14 | IMASK_IVG13 | IMASK_IVG12 | IMASK_IVG11 |
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;

+#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
+	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
+# ifdef CONFIG_BF54x
+	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
+# endif
+#else
+	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
+#endif
+
 	return 0;
 }

@@ -1122,7 +1077,6 @@ void do_irq(int vec, struct pt_regs *fp)
 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
 		unsigned long sic_status[3];

-		SSYNC();
 		sic_status[0] = bfin_read_SIC_ISR0() & bfin_read_SIC_IMASK0();
 		sic_status[1] = bfin_read_SIC_ISR1() & bfin_read_SIC_IMASK1();
 #ifdef CONFIG_BF54x
@@ -1138,7 +1092,7 @@ void do_irq(int vec, struct pt_regs *fp)
 		}
 #else
 		unsigned long sic_status;
-		SSYNC();
+
 		sic_status = bfin_read_SIC_IMASK() & bfin_read_SIC_ISR();

 		for (;; ivg++) {
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 1f516c5..ec3141f 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -181,7 +181,7 @@ void __init mem_init(void)
 	}
 }

-static __init void free_init_pages(const char *what, unsigned long
begin, unsigned long end)
+static void __init free_init_pages(const char *what, unsigned long
begin, unsigned long end)
 {
 	unsigned long addr;
 	/* next to check that the page we free is not a partial page */
@@ -203,7 +203,7 @@ void __init free_initrd_mem(unsigned long start,
unsigned long end)
 }
 #endif

-void __init free_initmem(void)
+void __init_refok free_initmem(void)
 {
 #if defined CONFIG_RAMKERNEL && !defined CONFIG_MPU
 	free_init_pages("unused kernel memory",
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index b82595c..cf627cd 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -686,7 +686,7 @@ config UART0_RTS_PIN

 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
-	depends on SERIAL_BFIN && (BF534 || BF536 || BF537 || BF54x)
+	depends on SERIAL_BFIN && (!BF531 && !BF532 && !BF533 && !BF561)
 	help
 	  Enable UART1

@@ -699,14 +699,14 @@ config BFIN_UART1_CTSRTS

 config UART1_CTS_PIN
 	int "UART1 CTS pin"
-	depends on BFIN_UART1_CTSRTS && (BF53x || BF561)
+	depends on BFIN_UART1_CTSRTS && !BF54x
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.

 config UART1_RTS_PIN
 	int "UART1 RTS pin"
-	depends on BFIN_UART1_CTSRTS && (BF53x || BF561)
+	depends on BFIN_UART1_CTSRTS && !BF54x
 	default -1
 	help
 	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index ac2a3ef..0aa345b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1,30 +1,11 @@
 /*
- * File:         drivers/serial/bfin_5xx.c
- * Based on:     Based on drivers/serial/sa1100.c
- * Author:       Aubrey Li <aubrey.li@analog.com>
+ * Blackfin On-Chip Serial Driver
  *
- * Created:
- * Description:  Driver for blackfin 5xx serial ports
+ * Copyright 2006-2007 Analog Devices Inc.
  *
- * Modified:
- *               Copyright 2006 Analog Devices Inc.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ * Licensed under the GPL-2 or later.
  */

 #if defined(CONFIG_SERIAL_BFIN_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -67,14 +48,12 @@
 #define DMA_RX_XCOUNT		512
 #define DMA_RX_YCOUNT		(PAGE_SIZE / DMA_RX_XCOUNT)

-#define DMA_RX_FLUSH_JIFFIES	5
+#define DMA_RX_FLUSH_JIFFIES	(HZ / 50)

 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
 #else
-static void bfin_serial_do_work(struct work_struct *work);
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
-static void local_put_char(struct bfin_serial_port *uart, char ch);
 #endif

 static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
@@ -85,23 +64,26 @@ static void bfin_serial_mctrl_check(struct
bfin_serial_port *uart);
 static void bfin_serial_stop_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	struct circ_buf *xmit = &uart->port.info->xmit;
+#if !defined(CONFIG_BF54x) && !defined(CONFIG_SERIAL_BFIN_DMA)
+	unsigned short ier;
+#endif

 	while (!(UART_GET_LSR(uart) & TEMT))
-		continue;
+		cpu_relax();

 #ifdef CONFIG_SERIAL_BFIN_DMA
 	disable_dma(uart->tx_dma_channel);
+	xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
+	uart->port.icount.tx += uart->tx_count;
+	uart->tx_count = 0;
+	uart->tx_done = 1;
 #else
 #ifdef CONFIG_BF54x
-	/* Waiting for Transmission Finished */
-	while (!(UART_GET_LSR(uart) & TFI))
-		continue;
 	/* Clear TFI bit */
 	UART_PUT_LSR(uart, TFI);
 	UART_CLEAR_IER(uart, ETBEI);
 #else
-	unsigned short ier;
-
 	ier = UART_GET_IER(uart);
 	ier &= ~ETBEI;
 	UART_PUT_IER(uart, ier);
@@ -117,7 +99,8 @@ static void bfin_serial_start_tx(struct uart_port *port)
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;

 #ifdef CONFIG_SERIAL_BFIN_DMA
-	bfin_serial_dma_tx_chars(uart);
+	if (uart->tx_done)
+		bfin_serial_dma_tx_chars(uart);
 #else
 #ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ETBEI);
@@ -209,34 +192,27 @@ int kgdb_get_debug_char(void)
 }
 #endif

-#ifdef CONFIG_SERIAL_BFIN_PIO
-static void local_put_char(struct bfin_serial_port *uart, char ch)
-{
-	unsigned short status;
-	int flags = 0;
-
-	spin_lock_irqsave(&uart->port.lock, flags);
-
-	do {
-		status = UART_GET_LSR(uart);
-	} while (!(status & THRE));
-
-	UART_PUT_CHAR(uart, ch);
-	SSYNC();
-
-	spin_unlock_irqrestore(&uart->port.lock, flags);
-}
+#if ANOMALY_05000230 && defined(CONFIG_SERIAL_BFIN_PIO)
+# define UART_GET_ANOMALY_THRESHOLD(uart)    ((uart)->anomaly_threshold)
+# define UART_SET_ANOMALY_THRESHOLD(uart, v) ((uart)->anomaly_threshold = (v))
+#else
+# define UART_GET_ANOMALY_THRESHOLD(uart)    0
+# define UART_SET_ANOMALY_THRESHOLD(uart, v)
+#endif

+#ifdef CONFIG_SERIAL_BFIN_PIO
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
 	struct tty_struct *tty = uart->port.info->tty;
 	unsigned int status, ch, flg;
-	static int in_break = 0;
+	static struct timeval anomaly_start = { .tv_sec = 0 };
 #ifdef CONFIG_KGDB_UART
 	struct pt_regs *regs = get_irq_regs();
 #endif

 	status = UART_GET_LSR(uart);
+	UART_CLEAR_LSR(uart);
+
  	ch = UART_GET_CHAR(uart);
  	uart->port.icount.rx++;

@@ -262,28 +238,56 @@ static void bfin_serial_rx_chars(struct
bfin_serial_port *uart)
 #endif

 	if (ANOMALY_05000230) {
-		/* The BF533 family of processors have a nice misbehavior where
-		 * they continuously generate characters for a "single" break.
+		/* The BF533 (and BF561) family of processors have a nice anomaly
+		 * where they continuously generate characters for a "single" break.
 		 * We have to basically ignore this flood until the "next" valid
-		 * character comes across.  All other Blackfin families operate
-		 * properly though.
+		 * character comes across.  Due to the nature of the flood, it is
+		 * not possible to reliably catch bytes that are sent too quickly
+		 * after this break.  So application code talking to the Blackfin
+		 * which sends a break signal must allow at least 1.5 character
+		 * times after the end of the break for things to stabilize.  This
+		 * timeout was picked as it must absolutely be larger than 1
+		 * character time +/- some percent.  So 1.5 sounds good.  All other
+		 * Blackfin families operate properly.  Woo.
 		 * Note: While Anomaly 05000230 does not directly address this,
 		 *       the changes that went in for it also fixed this issue.
+		 *       That anomaly was fixed in 0.5+ silicon.  I like bunnies.
 		 */
-		if (in_break) {
-			if (ch != 0) {
-				in_break = 0;
-				ch = UART_GET_CHAR(uart);
-				if (bfin_revid() < 5)
-					return;
-			} else
-				return;
+		if (anomaly_start.tv_sec) {
+			struct timeval curr;
+			suseconds_t usecs;
+
+			if ((~ch & (~ch + 1)) & 0xff)
+				goto known_good_char;
+
+			do_gettimeofday(&curr);
+			if (curr.tv_sec - anomaly_start.tv_sec > 1)
+				goto known_good_char;
+
+			usecs = 0;
+			if (curr.tv_sec != anomaly_start.tv_sec)
+				usecs += USEC_PER_SEC;
+			usecs += curr.tv_usec - anomaly_start.tv_usec;
+
+			if (usecs > UART_GET_ANOMALY_THRESHOLD(uart))
+				goto known_good_char;
+
+			if (ch)
+				anomaly_start.tv_sec = 0;
+			else
+				anomaly_start = curr;
+
+			return;
+
+ known_good_char:
+			anomaly_start.tv_sec = 0;
 		}
 	}

 	if (status & BI) {
 		if (ANOMALY_05000230)
-			in_break = 1;
+			if (bfin_revid() < 5)
+				do_gettimeofday(&anomaly_start);
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto ignore_char;
@@ -324,7 +328,6 @@ static void bfin_serial_tx_chars(struct
bfin_serial_port *uart)
 		UART_PUT_CHAR(uart, uart->port.x_char);
 		uart->port.icount.tx++;
 		uart->port.x_char = 0;
-		return;
 	}
 	/*
 	 * Check the modem control lines before
@@ -337,9 +340,12 @@ static void bfin_serial_tx_chars(struct
bfin_serial_port *uart)
 		return;
 	}

-	local_put_char(uart, xmit->buf[xmit->tail]);
-	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-	uart->port.icount.tx++;
+	while ((UART_GET_LSR(uart) & THRE) && xmit->tail != xmit->head) {
+		UART_PUT_CHAR(uart, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		uart->port.icount.tx++;
+		SSYNC();
+	}

 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&uart->port);
@@ -352,21 +358,11 @@ static irqreturn_t bfin_serial_rx_int(int irq,
void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;

-#ifdef CONFIG_BF54x
-	unsigned short status;
-	spin_lock(&uart->port.lock);
-	status = UART_GET_LSR(uart);
-	while ((UART_GET_IER(uart) & ERBFI) && (status & DR)) {
-		bfin_serial_rx_chars(uart);
-		status = UART_GET_LSR(uart);
-	}
-	spin_unlock(&uart->port.lock);
-#else
 	spin_lock(&uart->port.lock);
-	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_RX_READY)
+	while (UART_GET_LSR(uart) & DR)
 		bfin_serial_rx_chars(uart);
 	spin_unlock(&uart->port.lock);
-#endif
+
 	return IRQ_HANDLED;
 }

@@ -374,25 +370,16 @@ static irqreturn_t bfin_serial_tx_int(int irq,
void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;

-#ifdef CONFIG_BF54x
-	unsigned short status;
 	spin_lock(&uart->port.lock);
-	status = UART_GET_LSR(uart);
-	while ((UART_GET_IER(uart) & ETBEI) && (status & THRE)) {
+	if (UART_GET_LSR(uart) & THRE)
 		bfin_serial_tx_chars(uart);
-		status = UART_GET_LSR(uart);
-	}
 	spin_unlock(&uart->port.lock);
-#else
-	spin_lock(&uart->port.lock);
-	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_TX_READY)
-		bfin_serial_tx_chars(uart);
-	spin_unlock(&uart->port.lock);
-#endif
+
 	return IRQ_HANDLED;
 }
+#endif

-
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 static void bfin_serial_do_work(struct work_struct *work)
 {
 	struct bfin_serial_port *uart = container_of(work, struct
bfin_serial_port, cts_workqueue);
@@ -406,33 +393,27 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)
 {
 	struct circ_buf *xmit = &uart->port.info->xmit;
 	unsigned short ier;
-	int flags = 0;
-
-	if (!uart->tx_done)
-		return;

 	uart->tx_done = 0;

+	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
+		uart->tx_count = 0;
+		uart->tx_done = 1;
+		return;
+	}
+
 	if (uart->port.x_char) {
 		UART_PUT_CHAR(uart, uart->port.x_char);
 		uart->port.icount.tx++;
 		uart->port.x_char = 0;
-		uart->tx_done = 1;
-		return;
 	}
+
 	/*
 	 * Check the modem control lines before
 	 * transmitting anything.
 	 */
 	bfin_serial_mctrl_check(uart);

-	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
-		bfin_serial_stop_tx(&uart->port);
-		uart->tx_done = 1;
-		return;
-	}
-
-	spin_lock_irqsave(&uart->port.lock, flags);
 	uart->tx_count = CIRC_CNT(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (uart->tx_count > (UART_XMIT_SIZE - xmit->tail))
 		uart->tx_count = UART_XMIT_SIZE - xmit->tail;
@@ -448,6 +429,7 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)
 	set_dma_x_count(uart->tx_dma_channel, uart->tx_count);
 	set_dma_x_modify(uart->tx_dma_channel, 1);
 	enable_dma(uart->tx_dma_channel);
+
 #ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ETBEI);
 #else
@@ -455,7 +437,6 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)
 	ier |= ETBEI;
 	UART_PUT_IER(uart, ier);
 #endif
-	spin_unlock_irqrestore(&uart->port.lock, flags);
 }

 static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
@@ -464,7 +445,11 @@ static void bfin_serial_dma_rx_chars(struct
bfin_serial_port *uart)
 	int i, flg, status;

 	status = UART_GET_LSR(uart);
-	uart->port.icount.rx += CIRC_CNT(uart->rx_dma_buf.head,
uart->rx_dma_buf.tail, UART_XMIT_SIZE);;
+	UART_CLEAR_LSR(uart);
+
+	uart->port.icount.rx +=
+		CIRC_CNT(uart->rx_dma_buf.head, uart->rx_dma_buf.tail,
+		UART_XMIT_SIZE);

 	if (status & BI) {
 		uart->port.icount.brk++;
@@ -490,10 +475,12 @@ static void bfin_serial_dma_rx_chars(struct
bfin_serial_port *uart)
 	else
 		flg = TTY_NORMAL;

-	for (i = uart->rx_dma_buf.head; i < uart->rx_dma_buf.tail; i++) {
-		if (uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
-			goto dma_ignore_char;
-		uart_insert_char(&uart->port, status, OE, uart->rx_dma_buf.buf[i], flg);
+	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
+		if (i >= UART_XMIT_SIZE)
+			i = 0;
+		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
+			uart_insert_char(&uart->port, status, OE,
+				uart->rx_dma_buf.buf[i], flg);
 	}

  dma_ignore_char:
@@ -503,23 +490,23 @@ static void bfin_serial_dma_rx_chars(struct
bfin_serial_port *uart)
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
 	int x_pos, pos;
-	int flags = 0;
-
-	bfin_serial_dma_tx_chars(uart);

-	spin_lock_irqsave(&uart->port.lock, flags);
-	x_pos = DMA_RX_XCOUNT - get_dma_curr_xcount(uart->rx_dma_channel);
+	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
+	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
+	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
+	if (uart->rx_dma_nrows == DMA_RX_YCOUNT)
+		uart->rx_dma_nrows = 0;
+	x_pos = DMA_RX_XCOUNT - x_pos;
 	if (x_pos == DMA_RX_XCOUNT)
 		x_pos = 0;

 	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT + x_pos;
-
-	if (pos>uart->rx_dma_buf.tail) {
-		uart->rx_dma_buf.tail = pos;
+	if (pos != uart->rx_dma_buf.tail) {
+		uart->rx_dma_buf.head = pos;
 		bfin_serial_dma_rx_chars(uart);
-		uart->rx_dma_buf.head = uart->rx_dma_buf.tail;
+		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
 	}
-	spin_unlock_irqrestore(&uart->port.lock, flags);
+
 	uart->rx_dma_timer.expires = jiffies + DMA_RX_FLUSH_JIFFIES;
 	add_timer(&(uart->rx_dma_timer));
 }
@@ -532,8 +519,8 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq,
void *dev_id)

 	spin_lock(&uart->port.lock);
 	if (!(get_dma_curr_irqstat(uart->tx_dma_channel)&DMA_RUN)) {
-		clear_dma_irqstat(uart->tx_dma_channel);
 		disable_dma(uart->tx_dma_channel);
+		clear_dma_irqstat(uart->tx_dma_channel);
 #ifdef CONFIG_BF54x
 		UART_CLEAR_IER(uart, ETBEI);
 #else
@@ -541,15 +528,13 @@ static irqreturn_t bfin_serial_dma_tx_int(int
irq, void *dev_id)
 		ier &= ~ETBEI;
 		UART_PUT_IER(uart, ier);
 #endif
-		xmit->tail = (xmit->tail+uart->tx_count) &(UART_XMIT_SIZE -1);
-		uart->port.icount.tx+=uart->tx_count;
+		xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
+		uart->port.icount.tx += uart->tx_count;

 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(&uart->port);

-		if (uart_circ_empty(xmit))
-			bfin_serial_stop_tx(&uart->port);
-		uart->tx_done = 1;
+		bfin_serial_dma_tx_chars(uart);
 	}

 	spin_unlock(&uart->port.lock);
@@ -561,18 +546,15 @@ static irqreturn_t bfin_serial_dma_rx_int(int
irq, void *dev_id)
 	struct bfin_serial_port *uart = dev_id;
 	unsigned short irqstat;

-	uart->rx_dma_nrows++;
-	if (uart->rx_dma_nrows == DMA_RX_YCOUNT) {
-		uart->rx_dma_nrows = 0;
-		uart->rx_dma_buf.tail = DMA_RX_XCOUNT*DMA_RX_YCOUNT;
-		bfin_serial_dma_rx_chars(uart);
-		uart->rx_dma_buf.head = uart->rx_dma_buf.tail = 0;
-	}
 	spin_lock(&uart->port.lock);
 	irqstat = get_dma_curr_irqstat(uart->rx_dma_channel);
 	clear_dma_irqstat(uart->rx_dma_channel);
-
 	spin_unlock(&uart->port.lock);
+
+	del_timer(&(uart->rx_dma_timer));
+	uart->rx_dma_timer.expires = jiffies;
+	add_timer(&(uart->rx_dma_timer));
+
 	return IRQ_HANDLED;
 }
 #endif
@@ -599,7 +581,11 @@ static unsigned int bfin_serial_get_mctrl(struct
uart_port *port)
 	if (uart->cts_pin < 0)
 		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;

+# ifdef BF54x
+	if (UART_GET_MSR(uart) & CTS)
+# else
 	if (gpio_get_value(uart->cts_pin))
+# endif
 		return TIOCM_DSR | TIOCM_CAR;
 	else
 #endif
@@ -614,9 +600,17 @@ static void bfin_serial_set_mctrl(struct
uart_port *port, unsigned int mctrl)
 		return;

 	if (mctrl & TIOCM_RTS)
+# ifdef BF54x
+		UART_PUT_MCR(uart, UART_GET_MCR(uart) & ~MRTS);
+# else
 		gpio_set_value(uart->rts_pin, 0);
+# endif
 	else
+# ifdef BF54x
+		UART_PUT_MCR(uart, UART_GET_MCR(uart) | MRTS);
+# else
 		gpio_set_value(uart->rts_pin, 1);
+# endif
 #endif
 }

@@ -627,22 +621,17 @@ static void bfin_serial_mctrl_check(struct
bfin_serial_port *uart)
 {
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	unsigned int status;
-# ifdef CONFIG_SERIAL_BFIN_DMA
 	struct uart_info *info = uart->port.info;
 	struct tty_struct *tty = info->tty;

 	status = bfin_serial_get_mctrl(&uart->port);
+	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
 	if (!(status & TIOCM_CTS)) {
 		tty->hw_stopped = 1;
+		schedule_work(&uart->cts_workqueue);
 	} else {
 		tty->hw_stopped = 0;
 	}
-# else
-	status = bfin_serial_get_mctrl(&uart->port);
-	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-	if (!(status & TIOCM_CTS))
-		schedule_work(&uart->cts_workqueue);
-# endif
 #endif
 }

@@ -743,6 +732,7 @@ static void bfin_serial_shutdown(struct uart_port *port)
 	disable_dma(uart->rx_dma_channel);
 	free_dma(uart->rx_dma_channel);
 	del_timer(&(uart->rx_dma_timer));
+	dma_free_coherent(NULL, PAGE_SIZE, uart->rx_dma_buf.buf, 0);
 #else
 #ifdef	CONFIG_KGDB_UART
 	if (uart->port.line != CONFIG_KGDB_UART_PORT)
@@ -814,6 +804,8 @@ bfin_serial_set_termios(struct uart_port *port,
struct ktermios *termios,
 	quot = uart_get_divisor(port, baud);
 	spin_lock_irqsave(&uart->port.lock, flags);

+	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
+
 	do {
 		lsr = UART_GET_LSR(uart);
 	} while (!(lsr & TEMT));
@@ -956,10 +948,9 @@ static void __init bfin_serial_init_ports(void)
 		bfin_serial_ports[i].rx_dma_channel =
 			bfin_serial_resource[i].uart_rx_dma_channel;
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
-#else
-		INIT_WORK(&bfin_serial_ports[i].cts_workqueue, bfin_serial_do_work);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+		INIT_WORK(&bfin_serial_ports[i].cts_workqueue, bfin_serial_do_work);
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
diff --git a/include/asm-blackfin/gptimers.h b/include/asm-blackfin/gptimers.h
index 8265ea4..4f318f1 100644
--- a/include/asm-blackfin/gptimers.h
+++ b/include/asm-blackfin/gptimers.h
@@ -1,12 +1,11 @@
 /*
- * include/asm/bf5xx_timers.h
- *
- * This file contains the major Data structures and constants
- * used for General Purpose Timer Implementation in BF5xx
+ * gptimers.h - Blackfin General Purpose Timer structs/defines/prototypes
  *
+ * Copyright (c) 2005-2008 Analog Devices Inc.
  * Copyright (C) 2005 John DeHority
  * Copyright (C) 2006 Hella Aglaia GmbH (awe@aglaia-gmbh.de)
  *
+ * Licensed under the GPL-2.
  */

 #ifndef _BLACKFIN_TIMERS_H_
diff --git a/include/asm-blackfin/irq.h b/include/asm-blackfin/irq.h
index 65480da..86b6783 100644
--- a/include/asm-blackfin/irq.h
+++ b/include/asm-blackfin/irq.h
@@ -67,4 +67,6 @@ static __inline__ int irq_canonicalize(int irq)
 #define NO_IRQ ((unsigned int)(-1))
 #endif

+#define SIC_SYSIRQ(irq)	(irq - (IRQ_CORETMR + 1))
+
 #endif				/* _BFIN_IRQ_H_ */
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 15dbc21..c0694ec 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase +
OFFSET_GCTL))

 #define UART_PUT_CHAR(uart, v)   bfin_write16(((uart)->port.membase +
OFFSET_THR), v)
@@ -58,6 +57,7 @@
 struct bfin_serial_port {
 	struct uart_port port;
 	unsigned int old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int tx_done;
 	int tx_count;
@@ -67,15 +67,31 @@ struct bfin_serial_port {
 	unsigned int tx_dma_channel;
 	unsigned int rx_dma_channel;
 	struct work_struct tx_dma_workqueue;
-#else
-	struct work_struct cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct cts_workqueue;
 	int cts_pin;
 	int rts_pin;
 #endif
 };

+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index 7871d43..b6f513b 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase +
OFFSET_GCTL))

 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
@@ -46,6 +45,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -56,14 +56,34 @@ struct bfin_serial_port {
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
 #else
-	struct work_struct 	cts_workqueue;
+# if ANOMALY_05000230
+	unsigned int anomaly_threshold;
+# endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int			cts_pin;
 	int			rts_pin;
 #endif
 };

+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 86e45c3..8fc672d 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase +
OFFSET_GCTL))

 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
@@ -58,6 +57,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -67,15 +67,31 @@ struct bfin_serial_port {
 	unsigned int		tx_dma_channel;
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
-#else
-	struct work_struct 	cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
 };

+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 3770aa3..7e6339f 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -24,6 +24,8 @@
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LCR))
 #define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase +
OFFSET_GCTL))
+#define UART_GET_MSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_MSR))
+#define UART_GET_MCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_MCR))

 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
 #define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLL),v)
@@ -32,7 +34,9 @@
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLH),v)
 #define UART_PUT_LSR(uart,v)	bfin_write16(((uart)->port.membase +
OFFSET_LSR),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_LCR),v)
+#define UART_CLEAR_LSR(uart)    bfin_write16(((uart)->port.membase +
OFFSET_LSR), -1)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL),v)
+#define UART_PUT_MCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_MCR),v)

 #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
 # define CONFIG_SERIAL_BFIN_CTSRTS
@@ -68,10 +72,9 @@ struct bfin_serial_port {
 	unsigned int		tx_dma_channel;
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
-#else
-	struct work_struct 	cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 7871d43..b6f513b 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -23,7 +23,6 @@
 #define UART_GET_DLH(uart)	bfin_read16(((uart)->port.membase + OFFSET_DLH))
 #define UART_GET_IIR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_IIR))
 #define UART_GET_LCR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LCR))
-#define UART_GET_LSR(uart)      bfin_read16(((uart)->port.membase +
OFFSET_LSR))
 #define UART_GET_GCTL(uart)     bfin_read16(((uart)->port.membase +
OFFSET_GCTL))

 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
@@ -46,6 +45,7 @@
 struct bfin_serial_port {
         struct uart_port        port;
         unsigned int            old_status;
+	unsigned int lsr;
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	int			tx_done;
 	int			tx_count;
@@ -56,14 +56,34 @@ struct bfin_serial_port {
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
 #else
-	struct work_struct 	cts_workqueue;
+# if ANOMALY_05000230
+	unsigned int anomaly_threshold;
+# endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int			cts_pin;
 	int			rts_pin;
 #endif
 };

+/* The hardware clears the LSR bits upon read, so we need to cache
+ * some of the more fun bits in software so they don't get lost
+ * when checking the LSR in other code paths (TX).
+ */
+static inline unsigned int UART_GET_LSR(struct bfin_serial_port *uart)
+{
+	unsigned int lsr = bfin_read16(uart->port.membase + OFFSET_LSR);
+	uart->lsr |= (lsr & (BI|FE|PE|OE));
+	return lsr | uart->lsr;
+}
+
+static inline void UART_CLEAR_LSR(struct bfin_serial_port *uart)
+{
+	uart->lsr = 0;
+	bfin_write16(uart->port.membase + OFFSET_LSR, -1);
+}
+
 struct bfin_serial_port bfin_serial_ports[NR_PORTS];
 struct bfin_serial_res {
 	unsigned long	uart_base_addr;
diff --git a/include/asm-blackfin/mach-bf561/blackfin.h
b/include/asm-blackfin/mach-bf561/blackfin.h
index 362617f..3a16df2 100644
--- a/include/asm-blackfin/mach-bf561/blackfin.h
+++ b/include/asm-blackfin/mach-bf561/blackfin.h
@@ -49,7 +49,8 @@
 #define bfin_read_FIO_INEN() bfin_read_FIO0_INEN()
 #define bfin_write_FIO_INEN(val) bfin_write_FIO0_INEN(val)

-
+#define SIC_IWR0 SICA_IWR0
+#define SIC_IWR1 SICA_IWR1
 #define SIC_IAR0 SICA_IAR0
 #define bfin_write_SIC_IMASK0 bfin_write_SICA_IMASK0
 #define bfin_write_SIC_IMASK1 bfin_write_SICA_IMASK1
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h
b/include/asm-blackfin/mach-bf561/cdefBF561.h
index d667816..1bc8d2f 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -559,6 +559,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_write_PPI0_CONTROL(val)         bfin_write16(PPI0_CONTROL,val)
 #define bfin_read_PPI0_STATUS()              bfin_read16(PPI0_STATUS)
 #define bfin_write_PPI0_STATUS(val)          bfin_write16(PPI0_STATUS,val)
+#define bfin_clear_PPI0_STATUS()             bfin_read_PPI0_STATUS()
 #define bfin_read_PPI0_COUNT()               bfin_read16(PPI0_COUNT)
 #define bfin_write_PPI0_COUNT(val)           bfin_write16(PPI0_COUNT,val)
 #define bfin_read_PPI0_DELAY()               bfin_read16(PPI0_DELAY)
@@ -570,6 +571,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 #define bfin_write_PPI1_CONTROL(val)         bfin_write16(PPI1_CONTROL,val)
 #define bfin_read_PPI1_STATUS()              bfin_read16(PPI1_STATUS)
 #define bfin_write_PPI1_STATUS(val)          bfin_write16(PPI1_STATUS,val)
+#define bfin_clear_PPI1_STATUS()             bfin_read_PPI1_STATUS()
 #define bfin_read_PPI1_COUNT()               bfin_read16(PPI1_COUNT)
 #define bfin_write_PPI1_COUNT(val)           bfin_write16(PPI1_COUNT,val)
 #define bfin_read_PPI1_DELAY()               bfin_read16(PPI1_DELAY)

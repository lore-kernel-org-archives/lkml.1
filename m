Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXJ3IyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXJ3IyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXJ3IyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:54:07 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7065 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXJ3IyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:54:00 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42687959:sNHT109864230"
Subject: [GIT PULL] Blackfin arch bug fixing
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 30 Oct 2007 16:53:48 +0800
Message-Id: <1193734428.6690.1.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 30 Oct 2007 08:53:57.0279 (UTC) FILETIME=[682552F0:01C81AD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                           |   15 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig     |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig     |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig     |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig     |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig     |  279 ++++++++++++++++---
 arch/blackfin/configs/BF561-EZKIT_defconfig     |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig         |    2 +-
 arch/blackfin/kernel/entry.S                    |    6 +-
 arch/blackfin/kernel/fixed_code.S               |   14 +
 arch/blackfin/kernel/gptimers.c                 |   47 +++-
 arch/blackfin/kernel/setup.c                    |   13 +-
 arch/blackfin/kernel/traps.c                    |  340 +++++++++++++----------
 arch/blackfin/kernel/vmlinux.lds.S              |   11 +-
 arch/blackfin/mach-bf527/boards/ezkit.c         |   53 ++++
 arch/blackfin/mach-bf533/boards/H8606.c         |  345 +++++++++++++++++++++++
 arch/blackfin/mach-bf533/boards/Makefile        |    1 +
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |   42 +++-
 arch/blackfin/mach-bf533/boards/stamp.c         |    4 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    4 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    6 +-
 arch/blackfin/mach-common/entry.S               |    2 +-
 include/asm-blackfin/bfin-global.h              |    1 +
 include/asm-blackfin/fixed_code.h               |    4 +-
 include/asm-blackfin/gptimers.h                 |    2 +
 include/asm-blackfin/mach-bf527/defBF52x_base.h |   86 +++---
 include/asm-blackfin/mach-bf527/dma.h           |    7 +-
 include/asm-blackfin/mach-bf548/defBF549.h      |    2 +-
 include/asm-blackfin/mach-bf548/defBF54x_base.h |    7 +
 include/asm-blackfin/mach-bf548/portmux.h       |   14 +
 include/asm-blackfin/mach-bf561/defBF561.h      |    3 +
 31 files changed, 1052 insertions(+), 268 deletions(-)
 create mode 100644 arch/blackfin/mach-bf533/boards/H8606.c

Bryan Wu (1):
      Blackfin arch: update board defconfig files according to latest information from ADI datasheet

Javier Herrero (1):
      Blackfin arch: Added support for HV Sistemas H8606 board

Michael Hennerich (4):
      Blackfin arch: add NFC driver support in BF527-EZKIT board
      Blackfin arch: fix bug BlueTechnix CM-BF537 board config uses wrong IRQ for net2272 driver
      Blackfin arch: Apply Bluetchnix vendor patch provided by Harald Krapfenbauer
      Blackfin arch: Do not pollute name space used in linux-2.6.x/sound

Mike Frysinger (5):
      Blackfin arch: add support for checking/clearing overruns in generic purpose Timer API
      Blackfin arch: fix libata data struct member from irq_type to irq_flags
      Blackfin arch: reclaim a few bytes from the end of our init section
      Blackfin arch: Add missing definitions for BF561
      Blackfin arch: use a less common define name in BF549

Robin Getz (6):
      Blackfin arch: fix bug: kernel prints out error message twice
      Blackfin arch: cleanup arch/blackfin/kernel/traps.c handling code.
      Blackfin arch: fix bug: tell users if the kernel is recovering from a fault condition
      Blackfin arch: Fix random crash issue found by Michael.
      Blackfin arch: Add missing definitions of BF54x
      Blackfin arch: ensure that speculative loads of bad pointers don't cause us to do bad things.

Sonic Zhang (1):
      Blackfin arch: Fix bug set correct baud for spi mmc and enable SPI after DMA.

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 7888551..9f9de3e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -295,6 +295,12 @@ config PNAV10
 	help
 	  PNAV 1.0 board Support.
 
+config H8606_HVSISTEMAS
+        bool "HV Sistemas H8606"
+        depends on (BF532)
+        help
+          HV Sistemas H8606 board support.
+
 config GENERIC_BOARD
 	bool "Custom"
 	depends on (BF537 || BF536 \
@@ -317,7 +323,8 @@ config MEM_MT48LC64M4A2FB_7E
 config MEM_MT48LC16M16A2TG_75
 	bool
 	depends on (BFIN533_EZKIT || BFIN561_EZKIT \
-		|| BFIN533_BLUETECHNIX_CM || BFIN537_BLUETECHNIX_CM)
+		|| BFIN533_BLUETECHNIX_CM || BFIN537_BLUETECHNIX_CM \
+		|| H8606_HVSISTEMAS)
 	default y
 
 config MEM_MT48LC32M8A2_75
@@ -366,7 +373,7 @@ config CLKIN_HZ
 	int "Crystal Frequency in Hz"
 	default "11059200" if BFIN533_STAMP
 	default "27000000" if BFIN533_EZKIT
-	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT)
+	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT || H8606_HVSISTEMAS)
 	default "30000000" if BFIN561_EZKIT
 	default "24576000" if PNAV10
 	help
@@ -404,6 +411,7 @@ config VCO_MULT
 	default "20" if BFIN537_BLUETECHNIX_CM
 	default "20" if BFIN561_BLUETECHNIX_CM
 	default "20" if BFIN561_EZKIT
+	default "16" if H8606_HVSISTEMAS
 	help
 	  This controls the frequency of the on-chip PLL. This can be between 1 and 64.
 	  PLL Frequency = (Crystal Frequency) * (this setting)
@@ -440,6 +448,7 @@ config SCLK_DIV
 	default 4 if BFIN537_BLUETECHNIX_CM
 	default 4 if BFIN561_BLUETECHNIX_CM
 	default 5 if BFIN561_EZKIT
+	default 3 if H8606_HVSISTEMAS
 	help
 	  This sets the frequency of the system clock (including SDRAM or DDR).
 	  This can be between 1 and 15
@@ -492,11 +501,13 @@ config MEM_SIZE
 	default  64 if BFIN561_EZKIT
 	default 128 if BFIN533_STAMP
 	default  64 if PNAV10
+	default  32 if H8606_HVSISTEMAS
 
 config MEM_ADD_WIDTH
 	int "SDRAM Memory Address Width"
 	default  9 if BFIN533_EZKIT
 	default  9 if BFIN561_EZKIT
+	default  9 if H8606_HVSISTEMAS
 	default 10 if BFIN527_EZKIT
 	default 10 if BFIN537_STAMP
 	default 11 if BFIN533_STAMP
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index df974e7..1f6a93d 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -244,7 +244,7 @@ CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 57f58d5..9e9b420 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -198,7 +198,7 @@ CONFIG_CLKIN_HZ=27000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 306302b..f59ade9 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -199,7 +199,7 @@ CONFIG_CLKIN_HZ=11059200
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=750000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 828b604..07eb63d 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -206,7 +206,7 @@ CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index d856988..0dd3d22 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,6 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22.6
+# Linux kernel version: 2.6.22.10
+# Sat Oct 27 02:34:07 2007
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -64,7 +65,6 @@ CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
@@ -117,6 +117,9 @@ CONFIG_PREEMPT_VOLUNTARY=y
 #
 # Processor and Board Settings
 #
+# CONFIG_BF522 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF527 is not set
 # CONFIG_BF531 is not set
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
@@ -129,6 +132,7 @@ CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_BF549=y
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_0_0=y
+# CONFIG_BF_REV_0_1 is not set
 # CONFIG_BF_REV_0_2 is not set
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
@@ -137,6 +141,7 @@ CONFIG_BF_REV_0_0=y
 # CONFIG_BF_REV_NONE is not set
 CONFIG_BF54x=y
 CONFIG_BFIN_SINGLE_CORE=y
+# CONFIG_BFIN527_EZKIT is not set
 # CONFIG_BFIN533_EZKIT is not set
 # CONFIG_BFIN533_STAMP is not set
 # CONFIG_BFIN537_STAMP is not set
@@ -147,8 +152,23 @@ CONFIG_BFIN548_EZKIT=y
 # CONFIG_BFIN561_EZKIT is not set
 # CONFIG_BFIN561_TEPLA is not set
 # CONFIG_PNAV10 is not set
+# CONFIG_H8606_HVSISTEMAS is not set
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_IRQ_PLL_WAKEUP=7
+CONFIG_IRQ_RTC=8
+CONFIG_IRQ_SPORT0_RX=9
+CONFIG_IRQ_SPORT0_TX=9
+CONFIG_IRQ_SPORT1_RX=9
+CONFIG_IRQ_SPORT1_TX=9
+CONFIG_IRQ_UART0_RX=10
+CONFIG_IRQ_UART0_TX=10
+CONFIG_IRQ_UART1_RX=10
+CONFIG_IRQ_UART1_TX=10
+CONFIG_IRQ_CNT=8
+CONFIG_IRQ_USB_INT0=11
+CONFIG_IRQ_USB_INT1=11
+CONFIG_IRQ_USB_INT2=11
+CONFIG_IRQ_USB_DMA=11
 CONFIG_IRQ_TIMER0=11
 CONFIG_IRQ_TIMER1=11
 CONFIG_IRQ_TIMER2=11
@@ -160,15 +180,6 @@ CONFIG_IRQ_TIMER7=11
 CONFIG_IRQ_TIMER8=11
 CONFIG_IRQ_TIMER9=11
 CONFIG_IRQ_TIMER10=11
-CONFIG_IRQ_RTC=8
-CONFIG_IRQ_SPORT0_RX=9
-CONFIG_IRQ_SPORT0_TX=9
-CONFIG_IRQ_SPORT1_RX=9
-CONFIG_IRQ_SPORT1_TX=9
-CONFIG_IRQ_UART0_RX=10
-CONFIG_IRQ_UART0_TX=10
-CONFIG_IRQ_UART1_RX=10
-CONFIG_IRQ_UART1_TX=10
 
 #
 # BF548 Specific Configuration
@@ -236,16 +247,11 @@ CONFIG_IRQ_PIXC_IN0=8
 CONFIG_IRQ_PIXC_IN1=8
 CONFIG_IRQ_PIXC_OUT=8
 CONFIG_IRQ_SDH=8
-CONFIG_IRQ_CNT=8
 CONFIG_IRQ_KEY=8
 CONFIG_IRQ_CAN1_RX=11
 CONFIG_IRQ_CAN1_TX=11
 CONFIG_IRQ_SDH_MASK0=11
 CONFIG_IRQ_SDH_MASK1=11
-CONFIG_IRQ_USB_INT0=11
-CONFIG_IRQ_USB_INT1=11
-CONFIG_IRQ_USB_INT2=11
-CONFIG_IRQ_USB_DMA=11
 CONFIG_IRQ_OTPSEC=11
 CONFIG_IRQ_PINT2=11
 CONFIG_IRQ_PINT3=11
@@ -273,9 +279,9 @@ CONFIG_PINT3_ASSIGN=0x02020303
 #
 CONFIG_CLKIN_HZ=25000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
-CONFIG_MAX_VCO_HZ=533000000
+CONFIG_MAX_VCO_HZ=533333333
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
@@ -332,9 +338,10 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
+# CONFIG_BFIN_GPTIMERS is not set
 CONFIG_BFIN_DMA_5XX=y
-# CONFIG_DMA_UNCACHED_2M is not set
-CONFIG_DMA_UNCACHED_1M=y
+CONFIG_DMA_UNCACHED_2M=y
+# CONFIG_DMA_UNCACHED_1M is not set
 # CONFIG_DMA_UNCACHED_NONE is not set
 
 #
@@ -353,7 +360,7 @@ CONFIG_L1_MAX_PIECE=16
 #
 
 #
-# EBIU_AMBCTL Global Control
+# EBIU_AMGCTL Global Control
 #
 CONFIG_C_AMCKEN=y
 # CONFIG_C_AMBEN is not set
@@ -722,7 +729,7 @@ CONFIG_NETDEV_10000=y
 #
 # Input device support
 #
-CONFIG_INPUT=y
+CONFIG_INPUT=m
 # CONFIG_INPUT_FF_MEMLESS is not set
 # CONFIG_INPUT_POLLDEV is not set
 
@@ -731,18 +738,39 @@ CONFIG_INPUT=y
 #
 # CONFIG_INPUT_MOUSEDEV is not set
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
-# CONFIG_INPUT_EVDEV is not set
-# CONFIG_INPUT_EVBUG is not set
+CONFIG_INPUT_TSDEV=m
+CONFIG_INPUT_TSDEV_SCREEN_X=240
+CONFIG_INPUT_TSDEV_SCREEN_Y=320
+CONFIG_INPUT_EVDEV=m
+CONFIG_INPUT_EVBUG=m
 
 #
 # Input Device Drivers
 #
-# CONFIG_INPUT_KEYBOARD is not set
+CONFIG_INPUT_KEYBOARD=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_KEYBOARD_SUNKBD is not set
+# CONFIG_KEYBOARD_LKKBD is not set
+# CONFIG_KEYBOARD_XTKBD is not set
+# CONFIG_KEYBOARD_NEWTON is not set
+# CONFIG_KEYBOARD_STOWAWAY is not set
+# CONFIG_KEYBOARD_GPIO is not set
+CONFIG_KEYBOARD_BFIN=m
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_INPUT_JOYSTICK is not set
 # CONFIG_INPUT_TABLET is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
+CONFIG_INPUT_TOUCHSCREEN=y
+# CONFIG_TOUCHSCREEN_ADS7846 is not set
+CONFIG_TOUCHSCREEN_AD7877=m
+# CONFIG_TOUCHSCREEN_GUNZE is not set
+# CONFIG_TOUCHSCREEN_ELO is not set
+# CONFIG_TOUCHSCREEN_MTOUCH is not set
+# CONFIG_TOUCHSCREEN_MK712 is not set
+# CONFIG_TOUCHSCREEN_PENMOUNT is not set
+# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
+# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
+# CONFIG_TOUCHSCREEN_UCB1400 is not set
+# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
 CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_ATI_REMOTE is not set
 # CONFIG_INPUT_ATI_REMOTE2 is not set
@@ -764,9 +792,9 @@ CONFIG_INPUT_MISC=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BFIN_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
-# CONFIG_BF5xx_TIMERS is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
 # CONFIG_BF5xx_PPI is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
@@ -958,17 +986,92 @@ CONFIG_DAB=y
 #
 # CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
-# CONFIG_FB is not set
+CONFIG_FB=m
+CONFIG_FIRMWARE_EDID=y
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=m
+CONFIG_FB_CFB_COPYAREA=m
+CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_SYS_FOPS is not set
+CONFIG_FB_DEFERRED_IO=y
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_BFIN_7171 is not set
+# CONFIG_FB_BFIN_7393 is not set
+CONFIG_FB_BF54X_LQ043=m
+# CONFIG_FB_BFIN_T350MCQB is not set
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_VIRTUAL is not set
+# CONFIG_LOGO is not set
 
 #
 # Sound
 #
-# CONFIG_SOUND is not set
+CONFIG_SOUND=y
+
+#
+# Advanced Linux Sound Architecture
+#
+CONFIG_SND=y
+CONFIG_SND_TIMER=y
+CONFIG_SND_PCM=y
+# CONFIG_SND_SEQUENCER is not set
+CONFIG_SND_OSSEMUL=y
+CONFIG_SND_MIXER_OSS=y
+CONFIG_SND_PCM_OSS=y
+CONFIG_SND_PCM_OSS_PLUGINS=y
+# CONFIG_SND_DYNAMIC_MINORS is not set
+CONFIG_SND_SUPPORT_OLD_API=y
+CONFIG_SND_VERBOSE_PROCFS=y
+# CONFIG_SND_VERBOSE_PRINTK is not set
+# CONFIG_SND_DEBUG is not set
+
+#
+# Generic devices
+#
+# CONFIG_SND_DUMMY is not set
+# CONFIG_SND_MTPAV is not set
+# CONFIG_SND_SERIAL_U16550 is not set
+# CONFIG_SND_MPU401 is not set
+
+#
+# ALSA Blackfin devices
+#
+# CONFIG_SND_BLACKFIN_AD1836 is not set
+# CONFIG_SND_BFIN_AD73311 is not set
+
+#
+# System on Chip audio support
+#
+CONFIG_SND_SOC_AC97_BUS=y
+CONFIG_SND_SOC=y
+CONFIG_SND_BF5XX_SOC=y
+CONFIG_SND_BF5XX_SOC_AC97=y
+CONFIG_SND_BF5XX_SOC_BF548_EZKIT=y
+CONFIG_SND_BF5XX_SPORT_NUM=0
+# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
+CONFIG_SND_SOC_AD1980=y
+
+#
+# Open Sound System
+#
+# CONFIG_SOUND_PRIME is not set
+CONFIG_AC97_BUS=y
 
 #
 # HID Devices
 #
-CONFIG_HID=y
+CONFIG_HID=m
 # CONFIG_HID_DEBUG is not set
 
 #
@@ -1101,8 +1204,13 @@ CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 # CONFIG_EXT2_FS_POSIX_ACL is not set
 # CONFIG_EXT2_FS_SECURITY is not set
-# CONFIG_EXT3_FS is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
 # CONFIG_EXT4DEV_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
@@ -1123,15 +1231,22 @@ CONFIG_DNOTIFY=y
 #
 # CD-ROM/DVD Filesystems
 #
-# CONFIG_ISO9660_FS is not set
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_ZISOFS=y
 # CONFIG_UDF_FS is not set
 
 #
 # DOS/FAT/NT Filesystems
 #
-# CONFIG_MSDOS_FS is not set
-# CONFIG_VFAT_FS is not set
-# CONFIG_NTFS_FS is not set
+CONFIG_FAT_FS=m
+CONFIG_MSDOS_FS=m
+CONFIG_VFAT_FS=m
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+CONFIG_NTFS_FS=m
+# CONFIG_NTFS_DEBUG is not set
+CONFIG_NTFS_RW=y
 
 #
 # Pseudo filesystems
@@ -1183,10 +1298,33 @@ CONFIG_JFFS2_RTIME=y
 #
 # Network File Systems
 #
-# CONFIG_NFS_FS is not set
-# CONFIG_NFSD is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
+CONFIG_NFS_FS=m
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+CONFIG_NFSD=m
+CONFIG_NFSD_V3=y
+# CONFIG_NFSD_V3_ACL is not set
+# CONFIG_NFSD_V4 is not set
+CONFIG_NFSD_TCP=y
+CONFIG_LOCKD=m
+CONFIG_LOCKD_V4=y
+CONFIG_EXPORTFS=m
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=m
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+CONFIG_SMB_FS=m
+CONFIG_SMB_NLS_DEFAULT=y
+CONFIG_SMB_NLS_REMOTE="cp437"
+CONFIG_CIFS=y
+# CONFIG_CIFS_STATS is not set
+# CONFIG_CIFS_WEAK_PW_HASH is not set
+# CONFIG_CIFS_XATTR is not set
+# CONFIG_CIFS_DEBUG2 is not set
+# CONFIG_CIFS_EXPERIMENTAL is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
@@ -1195,13 +1333,68 @@ CONFIG_JFFS2_RTIME=y
 #
 # Partition Types
 #
-# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_ACORN_PARTITION is not set
+# CONFIG_OSF_PARTITION is not set
+# CONFIG_AMIGA_PARTITION is not set
+# CONFIG_ATARI_PARTITION is not set
+# CONFIG_MAC_PARTITION is not set
 CONFIG_MSDOS_PARTITION=y
+# CONFIG_BSD_DISKLABEL is not set
+# CONFIG_MINIX_SUBPARTITION is not set
+# CONFIG_SOLARIS_X86_PARTITION is not set
+# CONFIG_UNIXWARE_DISKLABEL is not set
+# CONFIG_LDM_PARTITION is not set
+# CONFIG_SGI_PARTITION is not set
+# CONFIG_ULTRIX_PARTITION is not set
+# CONFIG_SUN_PARTITION is not set
+# CONFIG_KARMA_PARTITION is not set
+# CONFIG_EFI_PARTITION is not set
+# CONFIG_SYSV68_PARTITION is not set
 
 #
 # Native Language Support
 #
-# CONFIG_NLS is not set
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_737=m
+CONFIG_NLS_CODEPAGE_775=m
+CONFIG_NLS_CODEPAGE_850=m
+CONFIG_NLS_CODEPAGE_852=m
+CONFIG_NLS_CODEPAGE_855=m
+CONFIG_NLS_CODEPAGE_857=m
+CONFIG_NLS_CODEPAGE_860=m
+CONFIG_NLS_CODEPAGE_861=m
+CONFIG_NLS_CODEPAGE_862=m
+CONFIG_NLS_CODEPAGE_863=m
+CONFIG_NLS_CODEPAGE_864=m
+CONFIG_NLS_CODEPAGE_865=m
+CONFIG_NLS_CODEPAGE_866=m
+CONFIG_NLS_CODEPAGE_869=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_CODEPAGE_950=m
+CONFIG_NLS_CODEPAGE_932=m
+CONFIG_NLS_CODEPAGE_949=m
+CONFIG_NLS_CODEPAGE_874=m
+CONFIG_NLS_ISO8859_8=m
+CONFIG_NLS_CODEPAGE_1250=m
+CONFIG_NLS_CODEPAGE_1251=m
+CONFIG_NLS_ASCII=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_ISO8859_2=m
+CONFIG_NLS_ISO8859_3=m
+CONFIG_NLS_ISO8859_4=m
+CONFIG_NLS_ISO8859_5=m
+CONFIG_NLS_ISO8859_6=m
+CONFIG_NLS_ISO8859_7=m
+CONFIG_NLS_ISO8859_9=m
+CONFIG_NLS_ISO8859_13=m
+CONFIG_NLS_ISO8859_14=m
+CONFIG_NLS_ISO8859_15=m
+CONFIG_NLS_KOI8_R=m
+CONFIG_NLS_KOI8_U=m
+CONFIG_NLS_UTF8=m
 
 #
 # Distributed Lock Manager
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 85e647f..277d72d 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -243,7 +243,7 @@ CONFIG_CLKIN_HZ=30000000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 15e36aa..3d403e0 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -204,7 +204,7 @@ CONFIG_CLKIN_HZ=24576000
 # CONFIG_BFIN_KERNEL_CLOCK is not set
 CONFIG_MAX_VCO_HZ=600000000
 CONFIG_MIN_VCO_HZ=50000000
-CONFIG_MAX_SCLK_HZ=133000000
+CONFIG_MAX_SCLK_HZ=133333333
 CONFIG_MIN_SCLK_HZ=27000000
 
 #
diff --git a/arch/blackfin/kernel/entry.S b/arch/blackfin/kernel/entry.S
index 65c5ba4..65f4e67 100644
--- a/arch/blackfin/kernel/entry.S
+++ b/arch/blackfin/kernel/entry.S
@@ -54,9 +54,11 @@ ENTRY(_ret_from_fork)
 	[sp + PT_IPEND] = r0;
 	/* do a 'fake' RTI by jumping to [RETI]
 	 * to avoid clearing supervisor mode in child
-	*/
+	 */
+	r0 = [sp + PT_PC];
+	[sp + PT_P0] = r0;
+
 	RESTORE_ALL_SYS
-	p0 = reti;
 	jump (p0);
 ENDPROC(_ret_from_fork)
 
diff --git a/arch/blackfin/kernel/fixed_code.S b/arch/blackfin/kernel/fixed_code.S
index d8b1ebc..9026269 100644
--- a/arch/blackfin/kernel/fixed_code.S
+++ b/arch/blackfin/kernel/fixed_code.S
@@ -129,4 +129,18 @@ ENTRY(_atomic_xor32)
 	rts;
 ENDPROC (_atomic_ior32)
 
+.align 16
+	/*
+	 * safe_user_instruction
+	 * Four NOPS are enough to allow the pipeline to speculativily load
+	 * execute anything it wants. After that, things have gone bad, and
+	 * we are stuck - so panic. Since we might be in user space, we can't
+	 * call panic, so just cause a unhandled exception, this should cause
+	 * a dump of the trace buffer so we can tell were we are, and a reboot
+	 */
+ENTRY(_safe_user_instruction)
+	NOP; NOP; NOP; NOP;
+	EXCPT 0x4;
+ENDPROC(_safe_user_instruction)
+
 ENTRY(_fixed_code_end)
diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
index cb7ba9b..5cf4bdb 100644
--- a/arch/blackfin/kernel/gptimers.c
+++ b/arch/blackfin/kernel/gptimers.c
@@ -20,8 +20,7 @@
 #else
 # define tassert(expr) \
 	if (!(expr)) \
-		printk(KERN_DEBUG "%s:%s:%i: Assertion failed: " #expr "\n", \
-			__FILE__, __func__, __LINE__);
+		printk(KERN_DEBUG "%s:%s:%i: Assertion failed: " #expr "\n", __FILE__, __func__, __LINE__);
 #endif
 
 #define BFIN_TIMER_NUM_GROUP  (BFIN_TIMER_OCTET(MAX_BLACKFIN_GPTIMERS - 1) + 1)
@@ -70,7 +69,7 @@ static volatile GPTIMER_group_regs *const group_regs[BFIN_TIMER_NUM_GROUP] =
 #endif
 };
 
-static uint32_t const dis_mask[MAX_BLACKFIN_GPTIMERS] =
+static uint32_t const trun_mask[MAX_BLACKFIN_GPTIMERS] =
 {
 	TIMER_STATUS_TRUN0,
 	TIMER_STATUS_TRUN1,
@@ -90,7 +89,27 @@ static uint32_t const dis_mask[MAX_BLACKFIN_GPTIMERS] =
 #endif
 };
 
-static uint32_t const irq_mask[MAX_BLACKFIN_GPTIMERS] =
+static uint32_t const tovf_mask[MAX_BLACKFIN_GPTIMERS] =
+{
+	TIMER_STATUS_TOVF0,
+	TIMER_STATUS_TOVF1,
+	TIMER_STATUS_TOVF2,
+#if (MAX_BLACKFIN_GPTIMERS > 3)
+	TIMER_STATUS_TOVF3,
+	TIMER_STATUS_TOVF4,
+	TIMER_STATUS_TOVF5,
+	TIMER_STATUS_TOVF6,
+	TIMER_STATUS_TOVF7,
+#endif
+#if (MAX_BLACKFIN_GPTIMERS > 8)
+	TIMER_STATUS_TOVF8,
+	TIMER_STATUS_TOVF9,
+	TIMER_STATUS_TOVF10,
+	TIMER_STATUS_TOVF11,
+#endif
+};
+
+static uint32_t const timil_mask[MAX_BLACKFIN_GPTIMERS] =
 {
 	TIMER_STATUS_TIMIL0,
 	TIMER_STATUS_TIMIL1,
@@ -165,17 +184,31 @@ EXPORT_SYMBOL(set_gptimer_status);
 uint16_t get_gptimer_intr(int timer_id)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
-	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & irq_mask[timer_id]) ? 1 : 0;
+	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & timil_mask[timer_id]) ? 1 : 0;
 }
 EXPORT_SYMBOL(get_gptimer_intr);
 
 void clear_gptimer_intr(int timer_id)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
-	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = irq_mask[timer_id];
+	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = timil_mask[timer_id];
 }
 EXPORT_SYMBOL(clear_gptimer_intr);
 
+uint16_t get_gptimer_over(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & tovf_mask[timer_id]) ? 1 : 0;
+}
+EXPORT_SYMBOL(get_gptimer_over);
+
+void clear_gptimer_over(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = tovf_mask[timer_id];
+}
+EXPORT_SYMBOL(clear_gptimer_over);
+
 void set_gptimer_config(int timer_id, uint16_t config)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
@@ -214,7 +247,7 @@ void disable_gptimers(uint16_t mask)
 	}
 	for (i = 0; i < MAX_BLACKFIN_GPTIMERS; ++i)
 		if (mask & (1 << i))
-			group_regs[BFIN_TIMER_OCTET(i)]->status |= dis_mask[i];
+			group_regs[BFIN_TIMER_OCTET(i)]->status |= trun_mask[i];
 	SSYNC();
 }
 EXPORT_SYMBOL(disable_gptimers);
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index f1b059e..934234f 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -316,6 +316,15 @@ void __init setup_arch(char **cmdline_p)
 
 	init_leds();
 
+	_bfin_swrst = bfin_read_SWRST();
+
+	if (_bfin_swrst & RESET_DOUBLE)
+		printk(KERN_INFO "Recovering from Double Fault event\n");
+	else if (_bfin_swrst & RESET_WDOG)
+		printk(KERN_INFO "Recovering from Watchdog event\n");
+	else if (_bfin_swrst & RESET_SOFTWARE)
+		printk(KERN_NOTICE "Reset caused by Software reset\n");
+
 	printk(KERN_INFO "Blackfin support (C) 2004-2007 Analog Devices, Inc.\n");
 	if (bfin_compiled_revid() == 0xffff)
 		printk(KERN_INFO "Compiled for ADSP-%s Rev any\n", CPU);
@@ -402,8 +411,6 @@ void __init setup_arch(char **cmdline_p)
 	if (l1_length > L1_DATA_A_LENGTH)
 		panic("L1 data memory overflow\n");
 
-	_bfin_swrst = bfin_read_SWRST();
-
 	/* Copy atomic sequences to their fixed location, and sanity check that
 	   these locations are the ones that we advertise to userspace.  */
 	memcpy((void *)FIXED_CODE_START, &fixed_code_start,
@@ -424,6 +431,8 @@ void __init setup_arch(char **cmdline_p)
 	       != ATOMIC_AND32 - FIXED_CODE_START);
 	BUG_ON((char *)&atomic_xor32 - (char *)&fixed_code_start
 	       != ATOMIC_XOR32 - FIXED_CODE_START);
+	BUG_ON((char *)&safe_user_instruction - (char *)&fixed_code_start
+		!= SAFE_USER_INSTRUCTION - FIXED_CODE_START);
 
 	init_exception_vectors();
 	bf53x_cache_init();
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index afd044e..cfa0543 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -37,10 +37,24 @@
 #include <asm/blackfin.h>
 #include <asm/irq_handler.h>
 #include <asm/trace.h>
+#include <asm/fixed_code.h>
 
 #ifdef CONFIG_KGDB
 # include <linux/debugger.h>
 # include <linux/kgdb.h>
+
+# define CHK_DEBUGGER_TRAP() \
+	do { \
+		CHK_DEBUGGER(trapnr, sig, info.si_code, fp, ); \
+	} while (0)
+# define CHK_DEBUGGER_TRAP_MAYBE() \
+	do { \
+		if (kgdb_connected) \
+			CHK_DEBUGGER_TRAP(); \
+	} while (0)
+#else
+# define CHK_DEBUGGER_TRAP() do { } while (0)
+# define CHK_DEBUGGER_TRAP_MAYBE() do { } while (0)
 #endif
 
 /* Initiate the event table handler */
@@ -53,13 +67,13 @@ void __init trap_init(void)
 
 int kstack_depth_to_print = 48;
 
-#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
-static int printk_address(unsigned long address)
+static void decode_address(char *buf, unsigned long address)
 {
 	struct vm_list_struct *vml;
 	struct task_struct *p;
 	struct mm_struct *mm;
-	unsigned long offset;
+	unsigned long flags, offset;
+	unsigned int in_exception = bfin_read_IPEND() & 0x10;
 
 #ifdef CONFIG_KALLSYMS
 	unsigned long symsize;
@@ -75,20 +89,33 @@ static int printk_address(unsigned long address)
 		/* yeah! kernel space! */
 		if (!modname)
 			modname = delim = "";
-		return printk("<0x%p> { %s%s%s%s + 0x%lx }",
+		sprintf(buf, "<0x%p> { %s%s%s%s + 0x%lx }",
 		              (void *)address, delim, modname, delim, symname,
 		              (unsigned long)offset);
+		return;
 
 	}
 #endif
 
+	/* Problem in fixed code section? */
+	if (address >= FIXED_CODE_START && address < FIXED_CODE_END) {
+		sprintf(buf, "<0x%p> /* Maybe fixed code section */", (void *)address);
+		return;
+	}
+
+	/* Problem somewhere before the kernel start address */
+	if (address < CONFIG_BOOT_LOAD) {
+		sprintf(buf, "<0x%p> /* Maybe null pointer? */", (void *)address);
+		return;
+	}
+
 	/* looks like we're off in user-land, so let's walk all the
 	 * mappings of all our processes and see if we can't be a whee
 	 * bit more specific
 	 */
-	write_lock_irq(&tasklist_lock);
+	write_lock_irqsave(&tasklist_lock, flags);
 	for_each_process(p) {
-		mm = get_task_mm(p);
+		mm = (in_exception ? p->mm : get_task_mm(p));
 		if (!mm)
 			continue;
 
@@ -117,25 +144,30 @@ static int printk_address(unsigned long address)
 				else
 					offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
 
-				write_unlock_irq(&tasklist_lock);
-				mmput(mm);
-				return printk("<0x%p> [ %s + 0x%lx ]",
-				              (void *)address, name, offset);
+				sprintf(buf, "<0x%p> [ %s + 0x%lx ]",
+					(void *)address, name, offset);
+				if (!in_exception)
+					mmput(mm);
+				goto done;
 			}
 
 			vml = vml->next;
 		}
-		mmput(mm);
+		if (!in_exception)
+			mmput(mm);
 	}
-	write_unlock_irq(&tasklist_lock);
 
 	/* we were unable to find this address anywhere */
-	return printk("[<0x%p>]", (void *)address);
+	sprintf(buf, "[<0x%p>]", (void *)address);
+
+done:
+	write_unlock_irqrestore(&tasklist_lock, flags);
 }
-#endif
 
 asmlinkage void double_fault_c(struct pt_regs *fp)
 {
+	console_verbose();
+	oops_in_progress = 1;
 	printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
 	dump_bfin_regs(fp, (void *)fp->retx);
 	panic("Double Fault - unrecoverable event\n");
@@ -151,22 +183,29 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	siginfo_t info;
 	unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
 
+	trace_buffer_save(j);
+
+	/* Important - be very careful dereferncing pointers - will lead to
+	 * double faults if the stack has become corrupt
+	 */
+
+	/* If the fault was caused by a kernel thread, or interrupt handler
+	 * we will kernel panic, so the system reboots.
+	 * If KGDB is enabled, don't set this for kernel breakpoints
+	*/
+	if ((bfin_read_IPEND() & 0xFFC0)
 #ifdef CONFIG_KGDB
-# define CHK_DEBUGGER_TRAP() \
-	do { \
-		CHK_DEBUGGER(trapnr, sig, info.si_code, fp, ); \
-	} while (0)
-# define CHK_DEBUGGER_TRAP_MAYBE() \
-	do { \
-		if (kgdb_connected) \
-			CHK_DEBUGGER_TRAP(); \
-	} while (0)
-#else
-# define CHK_DEBUGGER_TRAP() do { } while (0)
-# define CHK_DEBUGGER_TRAP_MAYBE() do { } while (0)
+		&& trapnr != VEC_EXCPT02
 #endif
-
-	trace_buffer_save(j);
+	){
+		console_verbose();
+		oops_in_progress = 1;
+	} else if (current) {
+		if (current->mm == NULL) {
+			console_verbose();
+			oops_in_progress = 1;
+		}
+	}
 
 	/* trap_c() will be called for exceptions. During exceptions
 	 * processing, the pc value should be set with retx value.
@@ -211,7 +250,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_EXCPT03:
 		info.si_code = SEGV_STACKFLOW;
 		sig = SIGSEGV;
-		printk(KERN_EMERG EXC_0x03);
+		printk(KERN_NOTICE EXC_0x03);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x04 - User Defined, Caught by default */
@@ -240,7 +279,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_OVFLOW:
 		info.si_code = TRAP_TRACEFLOW;
 		sig = SIGTRAP;
-		printk(KERN_EMERG EXC_0x11);
+		printk(KERN_NOTICE EXC_0x11);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x12 - Reserved, Caught by default */
@@ -262,14 +301,14 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_UNDEF_I:
 		info.si_code = ILL_ILLOPC;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x21);
+		printk(KERN_NOTICE EXC_0x21);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x22 - Illegal Instruction Combination, handled here */
 	case VEC_ILGAL_I:
 		info.si_code = ILL_ILLPARAOP;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x22);
+		printk(KERN_NOTICE EXC_0x22);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x23 - Data CPLB Protection Violation,
@@ -277,21 +316,21 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_CPLB_VL:
 		info.si_code = ILL_CPLB_VI;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x23);
+		printk(KERN_NOTICE EXC_0x23);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x24 - Data access misaligned, handled here */
 	case VEC_MISALI_D:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_EMERG EXC_0x24);
+		printk(KERN_NOTICE EXC_0x24);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x25 - Unrecoverable Event, handled here */
 	case VEC_UNCOV:
 		info.si_code = ILL_ILLEXCPT;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x25);
+		printk(KERN_NOTICE EXC_0x25);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x26 - Data CPLB Miss, normal case is handled in _cplb_hdr,
@@ -299,7 +338,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_CPLB_M:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_EMERG EXC_0x26);
+		printk(KERN_NOTICE EXC_0x26);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero, handled here */
@@ -307,11 +346,10 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		info.si_code = ILL_CPLB_MULHIT;
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		sig = SIGSEGV;
-		printk(KERN_EMERG "\n"
-			KERN_EMERG "NULL pointer access (probably)\n");
+		printk(KERN_NOTICE "NULL pointer access (probably)\n");
 #else
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x27);
+		printk(KERN_NOTICE EXC_0x27);
 #endif
 		CHK_DEBUGGER_TRAP();
 		break;
@@ -331,7 +369,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_ISTRU_VL:      /* ADSP-BF535 only (MH) */
 		info.si_code = BUS_OPFETCH;
 		sig = SIGBUS;
-		printk(KERN_EMERG "BF535: VEC_ISTRU_VL\n");
+		printk(KERN_NOTICE "BF535: VEC_ISTRU_VL\n");
 		CHK_DEBUGGER_TRAP();
 		break;
 #else
@@ -341,7 +379,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_MISALI_I:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		printk(KERN_EMERG EXC_0x2A);
+		printk(KERN_NOTICE EXC_0x2A);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2B - Instruction CPLB protection Violation,
@@ -349,14 +387,14 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_CPLB_I_VL:
 		info.si_code = ILL_CPLB_VI;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x2B);
+		printk(KERN_NOTICE EXC_0x2B);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2C - Instruction CPLB miss, handled in _cplb_hdr */
 	case VEC_CPLB_I_M:
 		info.si_code = ILL_CPLB_MISS;
 		sig = SIGBUS;
-		printk(KERN_EMERG EXC_0x2C);
+		printk(KERN_NOTICE EXC_0x2C);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2D - Instruction CPLB Multiple Hits, handled here */
@@ -364,10 +402,10 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		info.si_code = ILL_CPLB_MULHIT;
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		sig = SIGSEGV;
-		printk(KERN_EMERG "\n\nJump to address 0 - 0x0fff\n");
+		printk(KERN_NOTICE "Jump to address 0 - 0x0fff\n");
 #else
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x2D);
+		printk(KERN_NOTICE EXC_0x2D);
 #endif
 		CHK_DEBUGGER_TRAP();
 		break;
@@ -375,7 +413,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_ILL_RES:
 		info.si_code = ILL_PRVOPC;
 		sig = SIGILL;
-		printk(KERN_EMERG EXC_0x2E);
+		printk(KERN_NOTICE EXC_0x2E);
 		CHK_DEBUGGER_TRAP();
 		break;
 	/* 0x2F - Reserved, Caught by default */
@@ -404,38 +442,40 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		break;
 	}
 
-	if (sig != 0 && sig != SIGTRAP) {
+	BUG_ON(sig == 0);
+
+	if (sig != SIGTRAP) {
 		unsigned long stack;
 		dump_bfin_regs(fp, (void *)fp->retx);
-		dump_bfin_trace_buffer();
+
+		/* Print out the trace buffer if it makes sense */
+#ifndef CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE
+		if (trapnr == VEC_CPLB_I_M || trapnr == VEC_CPLB_M)
+			printk(KERN_NOTICE "No trace since you do not have "
+				"CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE enabled\n"
+				KERN_NOTICE "\n");
+		else
+#endif
+			dump_bfin_trace_buffer();
 		show_stack(current, &stack);
-		if (current->mm == NULL)
+		if (oops_in_progress) {
+#ifndef CONFIG_ACCESS_CHECK
+			printk(KERN_EMERG "Hey - dork - please turn on "
+				"CONFIG_ACCESS_CHECK\n");
+#endif
 			panic("Kernel exception");
+		}
+
+		/* Ensure that bad return addresses don't end up in an infinite
+		 * loop, due to speculative loads/reads
+		 */
+		fp->pc = SAFE_USER_INSTRUCTION;
 	}
 	info.si_signo = sig;
 	info.si_errno = 0;
 	info.si_addr = (void *)fp->pc;
 	force_sig_info(sig, &info, current);
 
-	/* if the address that we are about to return to is not valid, set it
-	 * to a valid address, if we have a current application or panic
-	 */
-	if (!(fp->pc <= physical_mem_end
-#if L1_CODE_LENGTH != 0
-	    || (fp->pc >= L1_CODE_START &&
-	        fp->pc <= (L1_CODE_START + L1_CODE_LENGTH))
-#endif
-	)) {
-		if (current->mm) {
-			fp->pc = current->mm->start_code;
-		} else {
-			printk(KERN_EMERG
-				"I can't return to memory that doesn't exist"
-				" - bad things happen\n");
-			panic("Help - I've fallen and can't get up\n");
-		}
-	}
-
 	trace_buffer_restore(j);
 	return;
 }
@@ -448,21 +488,21 @@ void dump_bfin_trace_buffer(void)
 {
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 	int tflags, i = 0;
+	char buf[150];
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
 	int j, index;
 #endif
 
 	trace_buffer_save(tflags);
 
-	printk(KERN_EMERG "Hardware Trace:\n");
+	printk(KERN_NOTICE "Hardware Trace:\n");
 
 	if (likely(bfin_read_TBUFSTAT() & TBUFCNT)) {
 		for (; bfin_read_TBUFSTAT() & TBUFCNT; i++) {
-			printk(KERN_EMERG "%4i Target : ", i);
-			printk_address((unsigned long)bfin_read_TBUF());
-			printk("\n" KERN_EMERG "     Source : ");
-			printk_address((unsigned long)bfin_read_TBUF());
-			printk("\n");
+			decode_address(buf, (unsigned long)bfin_read_TBUF());
+			printk(KERN_NOTICE "%4i Target : %s\n", i, buf);
+			decode_address(buf, (unsigned long)bfin_read_TBUF());
+			printk(KERN_NOTICE "     Source : %s\n", buf);
 		}
 	}
 
@@ -474,17 +514,16 @@ void dump_bfin_trace_buffer(void)
 
 	j = (1 << CONFIG_DEBUG_BFIN_HWTRACE_EXPAND_LEN) * 128;
 	while (j) {
-		printk(KERN_EMERG "%4i Target : ", i);
-		printk_address(software_trace_buff[index]);
+		decode_address(buf, software_trace_buff[index]);
+		printk(KERN_NOTICE "%4i Target : %s\n", i, buf);
 		index -= 1;
 		if (index < 0 )
 			index = EXPAND_LEN;
-		printk("\n" KERN_EMERG "     Source : ");
-		printk_address(software_trace_buff[index]);
+		decode_address(buf, software_trace_buff[index]);
+		printk(KERN_NOTICE "     Source : %s\n", buf);
 		index -= 1;
 		if (index < 0)
 			index = EXPAND_LEN;
-		printk("\n");
 		j--;
 		i++;
 	}
@@ -499,10 +538,7 @@ static void show_trace(struct task_struct *tsk, unsigned long *sp)
 {
 	unsigned long addr;
 
-	printk("\nCall Trace:");
-#ifdef CONFIG_KALLSYMS
-	printk("\n");
-#endif
+	printk(KERN_NOTICE "\n" KERN_NOTICE "Call Trace:\n");
 
 	while (!kstack_end(sp)) {
 		addr = *sp++;
@@ -518,7 +554,7 @@ static void show_trace(struct task_struct *tsk, unsigned long *sp)
 			print_ip_sym(addr);
 	}
 
-	printk("\n");
+	printk(KERN_NOTICE "\n");
 }
 
 void show_stack(struct task_struct *task, unsigned long *stack)
@@ -540,14 +576,15 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	addr = (unsigned long)stack;
 	endstack = (unsigned long *)PAGE_ALIGN(addr);
 
-	printk(KERN_EMERG "Stack from %08lx:", (unsigned long)stack);
+	printk(KERN_NOTICE "Stack from %08lx:", (unsigned long)stack);
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (stack + 1 > endstack)
 			break;
 		if (i % 8 == 0)
-			printk("\n" KERN_EMERG "       ");
+			printk("\n" KERN_NOTICE "       ");
 		printk(" %08lx", *stack++);
 	}
+	printk("\n");
 
 	show_trace(task, stack);
 }
@@ -568,33 +605,34 @@ EXPORT_SYMBOL(dump_stack);
 
 void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 {
-	if (current->pid) {
-		printk(KERN_EMERG "\n" KERN_EMERG "CURRENT PROCESS:\n"
-			KERN_EMERG "\n");
-		printk(KERN_EMERG "COMM=%s PID=%d\n",
-			current->comm, current->pid);
+	char buf [150];
+
+	if (!oops_in_progress) {
+		if (current->pid && current->mm) {
+			printk(KERN_NOTICE "\n" KERN_NOTICE "CURRENT PROCESS:\n");
+			printk(KERN_NOTICE "COMM=%s PID=%d\n",
+				current->comm, current->pid);
+
+			printk(KERN_NOTICE "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
+				KERN_NOTICE "BSS = 0x%p-0x%p   USER-STACK = 0x%p\n"
+				KERN_NOTICE "\n",
+				(void *)current->mm->start_code,
+				(void *)current->mm->end_code,
+				(void *)current->mm->start_data,
+				(void *)current->mm->end_data,
+				(void *)current->mm->end_data,
+				(void *)current->mm->brk,
+				(void *)current->mm->start_stack);
+		} else {
+			printk (KERN_NOTICE "\n" KERN_NOTICE
+			     "No Valid pid - Either things are really messed up,"
+			     " or you are in the kernel\n");
+		}
 	} else {
-		printk
-		    (KERN_EMERG "\n" KERN_EMERG
-		     "No Valid pid - Either things are really messed up,"
-		     " or you are in the kernel\n");
-	}
-
-	if (current->mm) {
-		printk(KERN_EMERG "TEXT = 0x%p-0x%p  DATA = 0x%p-0x%p\n"
-		       KERN_EMERG "BSS = 0x%p-0x%p   USER-STACK = 0x%p\n"
-		       KERN_EMERG "\n",
-		       (void *)current->mm->start_code,
-		       (void *)current->mm->end_code,
-		       (void *)current->mm->start_data,
-		       (void *)current->mm->end_data,
-		       (void *)current->mm->end_data,
-		       (void *)current->mm->brk,
-		       (void *)current->mm->start_stack);
+		printk(KERN_NOTICE "Kernel or interrupt exception\n");
 	}
 
-	printk(KERN_EMERG "return address: [0x%p]; contents of:", retaddr);
-	if (retaddr != 0 && retaddr <= (void *)physical_mem_end
+	if (retaddr >= (void *)FIXED_CODE_START  && retaddr < (void *)physical_mem_end
 #if L1_CODE_LENGTH != 0
 	    /* FIXME: Copy the code out of L1 Instruction SRAM through dma
 	       memcpy.  */
@@ -604,18 +642,20 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 	) {
 		int i = ((unsigned int)retaddr & 0xFFFFFFF0) - 32;
 		unsigned short x = 0;
+		printk(KERN_NOTICE "return address: [0x%p]; contents of:", retaddr);
 		for (; i < ((unsigned int)retaddr & 0xFFFFFFF0) + 32; i += 2) {
 			if (!(i & 0xF))
-				printk("\n" KERN_EMERG "0x%08x: ", i);
+				printk("\n" KERN_NOTICE "0x%08x: ", i);
 
 			if (get_user(x, (unsigned short *)i))
 				break;
 #ifndef CONFIG_DEBUG_HWERR
 			/* If one of the last few instructions was a STI
 			 * it is likely that the error occured awhile ago
-			 * and we just noticed
+			 * and we just noticed. This only happens in kernel
+			 * context, which should mean an oops is happening
 			 */
-			if (x >= 0x0040 && x <= 0x0047 && i <= 0)
+			if (oops_in_progress && x >= 0x0040 && x <= 0x0047 && i <= 0)
 				panic("\n\nWARNING : You should reconfigure"
 					" the kernel to turn on\n"
 					" 'Hardware error interrupt"
@@ -628,56 +668,60 @@ void dump_bfin_regs(struct pt_regs *fp, void *retaddr)
 			else
 				printk(" %04x ", x);
 		}
-		printk("\n" KERN_EMERG "\n");
+		printk("\n");
 	} else
-		printk(KERN_EMERG
+		printk("\n" KERN_NOTICE
 			"Cannot look at the [PC] for it is"
-			"in unreadable L1 SRAM - sorry\n");
+			" in unreadable memory - sorry\n");
+
+	printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\n");
+	printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
+		(long)fp->seqstat, fp->ipend, fp->syscfg);
 
+	decode_address(buf, fp->rete);
+	printk(KERN_NOTICE " RETE: %s\n", buf);
+	decode_address(buf, fp->retn);
+	printk(KERN_NOTICE " RETN: %s\n", buf);
+	decode_address(buf, fp->retx);
+	printk(KERN_NOTICE " RETX: %s\n", buf);
+	decode_address(buf, fp->rets);
+	printk(KERN_NOTICE " RETS: %s\n", buf);
 
-	printk(KERN_EMERG
-		"RETE:  %08lx  RETN: %08lx  RETX: %08lx  RETS: %08lx\n",
-		fp->rete, fp->retn, fp->retx, fp->rets);
-	printk(KERN_EMERG "IPEND: %04lx  SYSCFG: %04lx\n",
-		fp->ipend, fp->syscfg);
-	printk(KERN_EMERG "SEQSTAT: %08lx    SP: %08lx\n",
-		(long)fp->seqstat, (long)fp);
-	printk(KERN_EMERG "R0: %08lx    R1: %08lx    R2: %08lx    R3: %08lx\n",
+	if ((long)fp->seqstat & SEQSTAT_EXCAUSE) {
+		decode_address(buf, bfin_read_DCPLB_FAULT_ADDR());
+		printk(KERN_NOTICE "DCPLB_FAULT_ADDR: %s\n", buf);
+		decode_address(buf, bfin_read_ICPLB_FAULT_ADDR());
+		printk(KERN_NOTICE "ICPLB_FAULT_ADDR: %s\n", buf);
+	}
+
+	printk(KERN_NOTICE "\n" KERN_NOTICE "PROCESSOR STATE:\n");
+	printk(KERN_NOTICE " R0 : %08lx    R1 : %08lx    R2 : %08lx    R3 : %08lx\n",
 		fp->r0, fp->r1, fp->r2, fp->r3);
-	printk(KERN_EMERG "R4: %08lx    R5: %08lx    R6: %08lx    R7: %08lx\n",
+	printk(KERN_NOTICE " R4 : %08lx    R5 : %08lx    R6 : %08lx    R7 : %08lx\n",
 		fp->r4, fp->r5, fp->r6, fp->r7);
-	printk(KERN_EMERG "P0: %08lx    P1: %08lx    P2: %08lx    P3: %08lx\n",
+	printk(KERN_NOTICE " P0 : %08lx    P1 : %08lx    P2 : %08lx    P3 : %08lx\n",
 		fp->p0, fp->p1, fp->p2, fp->p3);
-	printk(KERN_EMERG
-		"P4: %08lx    P5: %08lx    FP: %08lx\n",
-		fp->p4, fp->p5, fp->fp);
-	printk(KERN_EMERG
-		"A0.w: %08lx    A0.x: %08lx    A1.w: %08lx    A1.x: %08lx\n",
-		fp->a0w, fp->a0x, fp->a1w, fp->a1x);
-
-	printk(KERN_EMERG "LB0: %08lx  LT0: %08lx  LC0: %08lx\n",
+	printk(KERN_NOTICE " P4 : %08lx    P5 : %08lx    FP : %08lx    SP : %08lx\n",
+		fp->p4, fp->p5, fp->fp, (long)fp);
+	printk(KERN_NOTICE " LB0: %08lx    LT0: %08lx    LC0: %08lx\n",
 		fp->lb0, fp->lt0, fp->lc0);
-	printk(KERN_EMERG "LB1: %08lx  LT1: %08lx  LC1: %08lx\n",
+	printk(KERN_NOTICE " LB1: %08lx    LT1: %08lx    LC1: %08lx\n",
 		fp->lb1, fp->lt1, fp->lc1);
-	printk(KERN_EMERG "B0: %08lx  L0: %08lx  M0: %08lx  I0: %08lx\n",
+	printk(KERN_NOTICE " B0 : %08lx    L0 : %08lx    M0 : %08lx    I0 : %08lx\n",
 		fp->b0, fp->l0, fp->m0, fp->i0);
-	printk(KERN_EMERG "B1: %08lx  L1: %08lx  M1: %08lx  I1: %08lx\n",
+	printk(KERN_NOTICE " B1 : %08lx    L1 : %08lx    M1 : %08lx    I1 : %08lx\n",
 		fp->b1, fp->l1, fp->m1, fp->i1);
-	printk(KERN_EMERG "B2: %08lx  L2: %08lx  M2: %08lx  I2: %08lx\n",
+	printk(KERN_NOTICE " B2 : %08lx    L2 : %08lx    M2 : %08lx    I2 : %08lx\n",
 		fp->b2, fp->l2, fp->m2, fp->i2);
-	printk(KERN_EMERG "B3: %08lx  L3: %08lx  M3: %08lx  I3: %08lx\n",
+	printk(KERN_NOTICE " B3 : %08lx    L3 : %08lx    M3 : %08lx    I3 : %08lx\n",
 		fp->b3, fp->l3, fp->m3, fp->i3);
+	printk(KERN_NOTICE "A0.w: %08lx   A0.x: %08lx   A1.w: %08lx   A1.x: %08lx\n",
+		fp->a0w, fp->a0x, fp->a1w, fp->a1x);
 
-	printk(KERN_EMERG "\n" KERN_EMERG "USP: %08lx   ASTAT: %08lx\n",
+	printk(KERN_NOTICE "USP : %08lx  ASTAT: %08lx\n",
 		rdusp(), fp->astat);
-	if ((long)fp->seqstat & SEQSTAT_EXCAUSE) {
-		printk(KERN_EMERG "DCPLB_FAULT_ADDR=%p\n",
-			(void *)bfin_read_DCPLB_FAULT_ADDR());
-		printk(KERN_EMERG "ICPLB_FAULT_ADDR=%p\n",
-			(void *)bfin_read_ICPLB_FAULT_ADDR());
-	}
 
-	printk("\n\n");
+	printk(KERN_NOTICE "\n");
 }
 
 #ifdef CONFIG_SYS_BFIN_SPINLOCK_L1
@@ -752,6 +796,8 @@ void panic_cplb_error(int cplb_panic, struct pt_regs *fp)
 		break;
 	}
 
+	oops_in_progress = 1;
+
 	printk(KERN_EMERG "DCPLB_FAULT_ADDR=%p\n", (void *)bfin_read_DCPLB_FAULT_ADDR());
 	printk(KERN_EMERG "ICPLB_FAULT_ADDR=%p\n", (void *)bfin_read_ICPLB_FAULT_ADDR());
 	dump_bfin_regs(fp, (void *)fp->retx);
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index eec4367..9b75bc8 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -172,9 +172,14 @@ SECTIONS
 		__ebss_b_l1 = .;
 	}
 
-	___init_end = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
-
-	.bss LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1) :
+	/* Force trailing alignment of our init section so that when we
+	 * free our init memory, we don't leave behind a partial page.
+	 */
+	. = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
+	. = ALIGN(PAGE_SIZE);
+	___init_end = .;
+
+	.bss :
 	{
 		. = ALIGN(4);
 		___bss_start = .;
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 3e884f3..bf1bedc 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -41,9 +41,11 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb_sl811.h>
+#include <asm/cplb.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
+#include <asm/nand.h>
 #include <linux/spi/ad7877.h>
 
 /*
@@ -102,6 +104,53 @@ void __exit bfin_isp1761_exit(void)
 arch_initcall(bfin_isp1761_init);
 #endif
 
+#if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
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
+static struct bf5xx_nand_platform bf5xx_nand_platform = {
+	.page_size = NFC_PG_SIZE_256,
+	.data_width = NFC_NWIDTH_8,
+	.partitions = partition_info,
+	.nr_partitions = ARRAY_SIZE(partition_info),
+	.rd_dly = 3,
+	.wr_dly = 3,
+};
+
+static struct resource bf5xx_nand_resources[] = {
+	{
+		.start = NFC_CTL,
+		.end = NFC_DATA_RD + 2,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = CH_NFC,
+		.end = CH_NFC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bf5xx_nand_device = {
+	.name = "bf5xx-nand",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bf5xx_nand_resources),
+	.resource = bf5xx_nand_resources,
+	.dev = {
+		.platform_data = &bf5xx_nand_platform,
+	},
+};
+#endif
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 static struct resource bfin_pcmcia_cf_resources[] = {
 	{
@@ -650,6 +699,10 @@ static struct platform_device bfin_pata_device = {
 #endif
 
 static struct platform_device *stamp_devices[] __initdata = {
+#if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
+	&bf5xx_nand_device,
+#endif
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 	&bfin_pcmcia_cf_device,
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
new file mode 100644
index 0000000..b941550
--- /dev/null
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -0,0 +1,345 @@
+/*
+ * File:         arch/blackfin/mach-bf533/H8606.c
+ * Based on:     arch/blackfin/mach-bf533/stamp.c
+ * Author:       Javier Herrero <jherrero@hvsistemas.es>
+ *
+ * Created:      2007
+ * Description:  Board Info File for the HV Sistemas H8606 board
+ *
+ * Modified:
+ *               Copyright 2005 National ICT Australia (NICTA)
+ *               Copyright 2004-2006 Analog Devices Inc
+ *		 Copyright 2007 HV Sistemas S.L.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
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
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+#include <linux/usb_isp1362.h>
+#endif
+#include <linux/pata_platform.h>
+#include <linux/irq.h>
+#include <asm/dma.h>
+#include <asm/bfin5xx_spi.h>
+#include <asm/reboot.h>
+
+/*
+ * Name the Board for the /proc/cpuinfo
+ */
+const char bfin_board_name[] = "HV Sistemas H8606";
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_BFIN_MODULE)
+static struct platform_device rtc_device = {
+	.name = "rtc-bfin",
+	.id   = -1,
+};
+#endif
+
+/*
+*  Driver needs to know address, irq and flag pin.
+ */
+ #if	defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+static struct resource dm9000_resources[] = {
+	[0] = {
+		.start	= 0x20300000,
+		.end	= 0x20300000 + 8,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= IRQ_PF10,
+		.end	= IRQ_PF10,
+		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
+	},
+};
+
+static struct platform_device dm9000_device = {
+    .id			= 0,
+    .name		= "dm9000",
+    .resource		= dm9000_resources,
+    .num_resources	= ARRAY_SIZE(dm9000_resources),
+};
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+static struct resource smc91x_resources[] = {
+	{
+		.name = "smc91x-regs",
+		.start = 0x20300300,
+		.end = 0x20300300 + 16,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PROG_INTB,
+		.end = IRQ_PROG_INTB,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	}, {
+		/*
+		 *  denotes the flag pin and is used directly if
+		 *  CONFIG_IRQCHIP_DEMUX_GPIO is defined.
+		 */
+		.start = IRQ_PF7,
+		.end = IRQ_PF7,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x20300000,
+		.end = 0x20300000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF10,
+		.end = IRQ_PF10,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x00060000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "kernel",
+		.size = 0x100000,
+		.offset = 0x60000
+	}, {
+		.name = "file system",
+		.size = 0x6a0000,
+		.offset = 0x00160000,
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p64",
+};
+
+/* SPI flash chip (m25p64) */
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+/* SPI ADC chip */
+static struct bfin5xx_spi_chip spi_adc_chip_info = {
+	.ctl_reg = 0x1000,
+	.enable_dma = 1,         /* use dma transfer with this chip*/
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
+	.ctl_reg = 0x1000,
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_PBX)
+static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
+	.ctl_reg	= 0x1c04,
+	.enable_dma	= 0,
+	.bits_per_word	= 8,
+	.cs_change_per_word = 1,
+};
+#endif
+
+/* Notice: for blackfin, the speed_hz is the value of register
+ * SPI_BAUD, not the real baudrate */
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		/* this value is the baudrate divisor */
+		.max_speed_hz = 50000000, /* actual baudrate is SCLK/(2xspeed_hz) */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL2*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+	{
+		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
+		.max_speed_hz = 4,     /* actual baudrate is SCLK/(2xspeed_hz) */
+		.bus_num = 1, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. */
+		.platform_data = NULL, /* No spi_driver specific config */
+		.controller_data = &spi_adc_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+	{
+		.modalias = "ad1836-spi",
+		.max_speed_hz = 16,
+		.bus_num = 1,
+		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
+		.controller_data = &ad1836_spi_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_PBX)
+	{
+		.modalias	 = "fxs-spi",
+		.max_speed_hz	 = 4,
+		.bus_num	 = 1,
+		.chip_select	 = 3,
+		.controller_data = &spi_si3xxx_chip_info,
+	},
+
+	{
+		.modalias	 = "fxo-spi",
+		.max_speed_hz	 = 4,
+		.bus_num	 = 1,
+		.chip_select	 = 2,
+		.controller_data = &spi_si3xxx_chip_info,
+	},
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
+		.start = CH_SPI,
+		.end   = CH_SPI,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bfin_spi0_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+};
+
+static struct platform_device bfin_spi0_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_spi0_info, /* Passed to driver */
+	},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
+static struct platform_device bfin_fb_device = {
+	.name = "bf537-fb",
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+static struct resource bfin_uart_resources[] = {
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bfin_uart_device = {
+	.name = "bfin-uart",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(bfin_uart_resources),
+	.resource = bfin_uart_resources,
+};
+#endif
+
+static struct platform_device *stamp_devices[] __initdata = {
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+	&rtc_device,
+#endif
+
+#if	defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
+	&dm9000_device,
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	&smc91x_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bfin_spi0_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+	&bfin_uart_device,
+#endif
+};
+
+static int __init H8606_init(void)
+{
+	printk(KERN_INFO "HV Sistemas H8606 board support by http://www.hvsistemas.com\n");
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+#endif
+	return 0;
+}
+
+arch_initcall(H8606_init);
\ No newline at end of file
diff --git a/arch/blackfin/mach-bf533/boards/Makefile b/arch/blackfin/mach-bf533/boards/Makefile
index 12a631a..2452b45 100644
--- a/arch/blackfin/mach-bf533/boards/Makefile
+++ b/arch/blackfin/mach-bf533/boards/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_BOARD)            += generic_board.o
 obj-$(CONFIG_BFIN533_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN533_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN533_BLUETECHNIX_CM)   += cm_bf533.o
+obj-$(CONFIG_H8606_HVSISTEMAS)         += H8606.o
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 1c5a86a..a863522 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -46,7 +46,7 @@ const char bfin_board_name[] = "Bluetechnix CM BF533";
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* all SPI peripherals info goes here */
-
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
 		.name = "bootloader",
@@ -76,12 +76,15 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
+#endif
 
 /* SPI ADC chip */
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
+#endif
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
@@ -90,7 +93,15 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
 		/* the modalias must be the same as spi device driver name */
 		.modalias = "m25p80",       /* Name of spi_driver for this device */
@@ -100,7 +111,11 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
 		.mode = SPI_MODE_3,
-	}, {
+	},
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+	{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,               /* Framework bus number */
@@ -108,6 +123,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.platform_data = NULL,      /* No spi_driver specific config */
 		.controller_data = &spi_adc_chip_info,
 	},
+#endif
+
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
@@ -117,6 +134,27 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 0,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
 };
 
 /* SPI (0) */
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index f84be4e..62ffa50 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -218,7 +218,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 	{
 		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 0,
 		.platform_data = NULL,
@@ -227,7 +227,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 	{
 		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 52e2320..2915931 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -281,8 +281,8 @@ static struct resource net2272_bfin_resources[] = {
 		.end = 0x20200000 + 0x100,
 		.flags = IORESOURCE_MEM,
 	}, {
-		.start = IRQ_PF7,
-		.end = IRQ_PF7,
+		.start = IRQ_PH14,
+		.end = IRQ_PH14,
 		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
 	},
 };
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index cc41f6c..5f7b91f 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -450,7 +450,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 	{
 		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 0,
 		.platform_data = NULL,
@@ -459,7 +459,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 	{
 		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
@@ -612,7 +612,7 @@ static struct platform_device bfin_sport1_uart_device = {
 
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
 };
 
 static struct resource bfin_pata_resources[] = {
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index e3ad580..1b13fa4 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -917,7 +917,7 @@ ENTRY(_ex_table)
 	.long _ex_soft_bp       /* 0x01 - User Defined - Software breakpoint */
 	.long _ex_replaceable   /* 0x02 - User Defined */
 	.long _ex_trap_c        /* 0x03 - User Defined - userspace stack overflow */
-	.long _ex_replaceable   /* 0x04 - User Defined */
+	.long _ex_trap_c        /* 0x04 - User Defined - dump trace buffer */
 	.long _ex_replaceable   /* 0x05 - User Defined */
 	.long _ex_replaceable   /* 0x06 - User Defined */
 	.long _ex_replaceable   /* 0x07 - User Defined */
diff --git a/include/asm-blackfin/bfin-global.h b/include/asm-blackfin/bfin-global.h
index 14cb8d3..0212e18 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -80,6 +80,7 @@ extern int atomic_sub32(void);
 extern int atomic_ior32(void);
 extern int atomic_and32(void);
 extern int atomic_xor32(void);
+extern void safe_user_instruction(void);
 extern void sigreturn_stub(void);
 
 extern void *l1_data_A_sram_alloc(size_t);
diff --git a/include/asm-blackfin/fixed_code.h b/include/asm-blackfin/fixed_code.h
index e6df84e..37db66c 100644
--- a/include/asm-blackfin/fixed_code.h
+++ b/include/asm-blackfin/fixed_code.h
@@ -17,4 +17,6 @@
 
 #define ATOMIC_SEQS_END		0x480
 
-#define FIXED_CODE_END		0x480
+#define SAFE_USER_INSTRUCTION   0x480
+
+#define FIXED_CODE_END		0x490
diff --git a/include/asm-blackfin/gptimers.h b/include/asm-blackfin/gptimers.h
index c97ab03..8265ea4 100644
--- a/include/asm-blackfin/gptimers.h
+++ b/include/asm-blackfin/gptimers.h
@@ -197,6 +197,8 @@ uint32_t get_gptimer_period    (int timer_id);
 uint32_t get_gptimer_count     (int timer_id);
 uint16_t get_gptimer_intr      (int timer_id);
 void     clear_gptimer_intr    (int timer_id);
+uint16_t get_gptimer_over      (int timer_id);
+void     clear_gptimer_over    (int timer_id);
 void     set_gptimer_config    (int timer_id, uint16_t config);
 uint16_t get_gptimer_config    (int timer_id);
 void     set_gptimer_pulse_hi  (int timer_id);
diff --git a/include/asm-blackfin/mach-bf527/defBF52x_base.h b/include/asm-blackfin/mach-bf527/defBF52x_base.h
index d6c24c5..fc69cf9 100644
--- a/include/asm-blackfin/mach-bf527/defBF52x_base.h
+++ b/include/asm-blackfin/mach-bf527/defBF52x_base.h
@@ -1718,55 +1718,55 @@
 
 /* Bit masks for HOST_CONTROL */
 
-#define                   HOST_EN  0x1        /* Host Enable */
-#define                  nHOST_EN  0x0       
-#define                  HOST_END  0x2        /* Host Endianess */
-#define                 nHOST_END  0x0       
-#define                 DATA_SIZE  0x4        /* Data Size */
-#define                nDATA_SIZE  0x0       
-#define                  HOST_RST  0x8        /* Host Reset */
-#define                 nHOST_RST  0x0       
-#define                  HRDY_OVR  0x20       /* Host Ready Override */
-#define                 nHRDY_OVR  0x0       
-#define                  INT_MODE  0x40       /* Interrupt Mode */
-#define                 nINT_MODE  0x0       
-#define                     BT_EN  0x80       /* Bus Timeout Enable */
-#define                    nBT_EN  0x0       
-#define                       EHW  0x100      /* Enable Host Write */
-#define                      nEHW  0x0       
-#define                       EHR  0x200      /* Enable Host Read */
-#define                      nEHR  0x0       
-#define                       BDR  0x400      /* Burst DMA Requests */
-#define                      nBDR  0x0       
+#define                   HOST_CNTR_HOST_EN  0x1        /* Host Enable */
+#define                  HOST_CNTR_nHOST_EN  0x0
+#define                  HOST_CNTR_HOST_END  0x2        /* Host Endianess */
+#define                 HOST_CNTR_nHOST_END  0x0
+#define                 HOST_CNTR_DATA_SIZE  0x4        /* Data Size */
+#define                HOST_CNTR_nDATA_SIZE  0x0
+#define                  HOST_CNTR_HOST_RST  0x8        /* Host Reset */
+#define                 HOST_CNTR_nHOST_RST  0x0
+#define                  HOST_CNTR_HRDY_OVR  0x20       /* Host Ready Override */
+#define                 HOST_CNTR_nHRDY_OVR  0x0
+#define                  HOST_CNTR_INT_MODE  0x40       /* Interrupt Mode */
+#define                 HOST_CNTR_nINT_MODE  0x0
+#define                     HOST_CNTR_BT_EN  0x80       /* Bus Timeout Enable */
+#define                   HOST_CNTR_ nBT_EN  0x0
+#define                       HOST_CNTR_EHW  0x100      /* Enable Host Write */
+#define                      HOST_CNTR_nEHW  0x0
+#define                       HOST_CNTR_EHR  0x200      /* Enable Host Read */
+#define                      HOST_CNTR_nEHR  0x0
+#define                       HOST_CNTR_BDR  0x400      /* Burst DMA Requests */
+#define                      HOST_CNTR_nBDR  0x0
 
 /* Bit masks for HOST_STATUS */
 
-#define                     READY  0x1        /* DMA Ready */
-#define                    nREADY  0x0       
-#define                  FIFOFULL  0x2        /* FIFO Full */
-#define                 nFIFOFULL  0x0       
-#define                 FIFOEMPTY  0x4        /* FIFO Empty */
-#define                nFIFOEMPTY  0x0       
-#define                  COMPLETE  0x8        /* DMA Complete */
-#define                 nCOMPLETE  0x0       
-#define                      HSHK  0x10       /* Host Handshake */
-#define                     nHSHK  0x0       
-#define                   TIMEOUT  0x20       /* Host Timeout */
-#define                  nTIMEOUT  0x0       
-#define                      HIRQ  0x40       /* Host Interrupt Request */
-#define                     nHIRQ  0x0       
-#define                ALLOW_CNFG  0x80       /* Allow New Configuration */
-#define               nALLOW_CNFG  0x0       
-#define                   DMA_DIR  0x100      /* DMA Direction */
-#define                  nDMA_DIR  0x0       
-#define                       BTE  0x200      /* Bus Timeout Enabled */
-#define                      nBTE  0x0       
-#define               HOSTRD_DONE  0x8000     /* Host Read Completion Interrupt */
-#define              nHOSTRD_DONE  0x0
+#define                     HOST_STAT_READY  0x1        /* DMA Ready */
+#define                    HOST_STAT_nREADY  0x0
+#define                  HOST_STAT_FIFOFULL  0x2        /* FIFO Full */
+#define                 HOST_STAT_nFIFOFULL  0x0
+#define                 HOST_STAT_FIFOEMPTY  0x4        /* FIFO Empty */
+#define                HOST_STAT_nFIFOEMPTY  0x0
+#define                  HOST_STAT_COMPLETE  0x8        /* DMA Complete */
+#define                 HOST_STAT_nCOMPLETE  0x0
+#define                      HOST_STAT_HSHK  0x10       /* Host Handshake */
+#define                     HOST_STAT_nHSHK  0x0
+#define                   HOST_STAT_TIMEOUT  0x20       /* Host Timeout */
+#define                  HOST_STAT_nTIMEOUT  0x0
+#define                      HOST_STAT_HIRQ  0x40       /* Host Interrupt Request */
+#define                     HOST_STAT_nHIRQ  0x0
+#define                HOST_STAT_ALLOW_CNFG  0x80       /* Allow New Configuration */
+#define               HOST_STAT_nALLOW_CNFG  0x0
+#define                   HOST_STAT_DMA_DIR  0x100      /* DMA Direction */
+#define                  HOST_STAT_nDMA_DIR  0x0
+#define                       HOST_STAT_BTE  0x200      /* Bus Timeout Enabled */
+#define                      HOST_STAT_nBTE  0x0
+#define               HOST_STAT_HOSTRD_DONE  0x8000     /* Host Read Completion Interrupt */
+#define              HOST_STAT_nHOSTRD_DONE  0x0
 
 /* Bit masks for HOST_TIMEOUT */
 
-#define             COUNT_TIMEOUT  0x7ff      /* Host Timeout count */
+#define             HOST_COUNT_TIMEOUT  0x7ff      /* Host Timeout count */
 
 /* Bit masks for CNT_CONFIG */
 
diff --git a/include/asm-blackfin/mach-bf527/dma.h b/include/asm-blackfin/mach-bf527/dma.h
index a41627a..2dfee12 100644
--- a/include/asm-blackfin/mach-bf527/dma.h
+++ b/include/asm-blackfin/mach-bf527/dma.h
@@ -35,7 +35,6 @@
 #define MAX_BLACKFIN_DMA_CHANNEL 16
 
 #define CH_PPI 			0	/* PPI receive/transmit or NFC */
-#define CH_NFC			0	/* PPI receive/transmit or NFC */
 #define CH_EMAC_RX 		1	/* Ethernet MAC receive or HOSTDP */
 #define CH_EMAC_HOSTDP 		1	/* Ethernet MAC receive or HOSTDP */
 #define CH_EMAC_TX 		2	/* Ethernet MAC transmit or NFC */
@@ -54,6 +53,12 @@
 #define CH_MEM_STREAM1_DEST	14	/* TX */
 #define CH_MEM_STREAM1_SRC 	15	/* RX */
 
+#if defined(CONFIG_BF527_NAND_D_PORTF)
+#define CH_NFC			CH_PPI	/* PPI receive/transmit or NFC */
+#elif defined(CONFIG_BF527_NAND_D_PORTH)
+#define CH_NFC			CH_EMAC_TX /* PPI receive/transmit or NFC */
+#endif
+
 extern int channel2irq(unsigned int channel);
 extern struct dma_register *base_addr[];
 
diff --git a/include/asm-blackfin/mach-bf548/defBF549.h b/include/asm-blackfin/mach-bf548/defBF549.h
index 4e46d65..fcb72b4 100644
--- a/include/asm-blackfin/mach-bf548/defBF549.h
+++ b/include/asm-blackfin/mach-bf548/defBF549.h
@@ -1671,7 +1671,7 @@
 /* Bit masks for MXVR_DMAx_CONFIG */
 
 #define                    MDMAEN  0x1        /* DMA Channel Enable */
-#define                        DD  0x2        /* DMA Channel Direction */
+#define                     DMADD  0x2        /* DMA Channel Direction */
 #define                 BY4SWAPEN  0x20       /* DMA Channel Four Byte Swap Enable */
 #define                     LCHAN  0x3c0      /* DMA Channel Logical Channel */
 #define                 BITSWAPEN  0x400      /* DMA Channel Bit Swap Enable */
diff --git a/include/asm-blackfin/mach-bf548/defBF54x_base.h b/include/asm-blackfin/mach-bf548/defBF54x_base.h
index 1d365c8..da979cb 100644
--- a/include/asm-blackfin/mach-bf548/defBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/defBF54x_base.h
@@ -2252,6 +2252,13 @@
 #define                   PLL_OFF  0x2        /* Disable PLL */
 #define                        DF  0x1        /* Divide Frequency */
 
+/* SWRST Masks */
+#define              SYSTEM_RESET 0x0007       /* Initiates A System Software Reset */
+#define              DOUBLE_FAULT 0x0008       /* Core Double Fault Causes Reset */
+#define              RESET_DOUBLE 0x2000       /* SW Reset Generated By Core Double-Fault */
+#define                RESET_WDOG 0x4000       /* SW Reset Generated By Watchdog Timer */
+#define            RESET_SOFTWARE 0x8000       /* SW Reset Occurred Since Last Read Of SWRST */
+
 /* Bit masks for PLL_STAT */
 
 #define                PLL_LOCKED  0x20       /* PLL Locked Status */
diff --git a/include/asm-blackfin/mach-bf548/portmux.h b/include/asm-blackfin/mach-bf548/portmux.h
index b382deb..6b48512 100644
--- a/include/asm-blackfin/mach-bf548/portmux.h
+++ b/include/asm-blackfin/mach-bf548/portmux.h
@@ -267,4 +267,18 @@
 #define P_AMC_BG	(P_DEFINED | P_IDENT(GPIO_PJ12) | P_FUNCT(0))
 #define P_AMC_BGH	(P_DEFINED | P_IDENT(GPIO_PJ13) | P_FUNCT(0))
 
+
+#define P_NAND_D0	(P_DONTCARE)
+#define P_NAND_D1	(P_DONTCARE)
+#define P_NAND_D2	(P_DONTCARE)
+#define P_NAND_D3	(P_DONTCARE)
+#define P_NAND_D4	(P_DONTCARE)
+#define P_NAND_D5	(P_DONTCARE)
+#define P_NAND_D6	(P_DONTCARE)
+#define P_NAND_D7	(P_DONTCARE)
+#define P_NAND_WE	(P_DONTCARE)
+#define P_NAND_RE	(P_DONTCARE)
+#define P_NAND_CLE	(P_DONTCARE)
+#define P_NAND_ALE	(P_DONTCARE)
+
 #endif /* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h b/include/asm-blackfin/mach-bf561/defBF561.h
index bf7dc4e..7945e8a 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -55,6 +55,9 @@
 /* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
 #define SWRST                   SICA_SWRST
 #define SYSCR                   SICA_SYSCR
+#define RESET_DOUBLE            (SWRST_DBL_FAULT_B|SWRST_DBL_FAULT_A)
+#define RESET_WDOG              (SWRST_WDT_B|SWRST_WDT_A)
+#define RESET_SOFTWARE          (SWRST_OCCURRED)
 
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define SICA_SWRST              0xFFC00100	/* Software Reset register */

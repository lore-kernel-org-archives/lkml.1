Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZC1SWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZC1SWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 14:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZC1SWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 14:22:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:35216 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZC1SWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 14:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DRmGZ9To2C70ZlqlP5D7uJ++VM/e999itHi6S0jTBfRIlMSdBIjO2InBSbPL1F9NAR
         zzl2TkpEnwDQ1rwFYeHXJplH8WR6dmqJ0IH4eiXLtk5CSYjUbU2uBtqr4iGScWwqwDMn
         zLu0WRUXNJKe4ruC5C6tHOSnPZAeZcsatVSxU=
Message-ID: <49CE6AD9.1080603@kernel.org>
Date: Sun, 29 Mar 2009 02:22:17 +0800
From: Bryan Wu <cooloney@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin fixing and updates for 2.6.30 merge window
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin.git/ for-linus

to receive the following updates:

 arch/blackfin/configs/BF518F-EZBRD_defconfig      |   42 +++-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |  140 +++++++------
 arch/blackfin/configs/BF527-EZKIT_defconfig       |  150 +++++++------
 arch/blackfin/configs/BF533-EZKIT_defconfig       |   54 +++--
 arch/blackfin/configs/BF533-STAMP_defconfig       |  100 +++------
 arch/blackfin/configs/BF537-STAMP_defconfig       |   97 +++------
 arch/blackfin/configs/BF538-EZKIT_defconfig       |  101 +++------
 arch/blackfin/configs/BF548-EZKIT_defconfig       |  163 ++++++++-------
 arch/blackfin/configs/BF561-EZKIT_defconfig       |   54 +++---
 arch/blackfin/configs/BlackStamp_defconfig        |    4 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    6 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    4 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    4 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    4 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    4 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    4 +-
 arch/blackfin/configs/H8606_defconfig             |    4 +-
 arch/blackfin/configs/IP0X_defconfig              |    4 +-
 arch/blackfin/configs/PNAV-10_defconfig           |   39 +++-
 arch/blackfin/configs/SRV1_defconfig              |    4 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    6 +-
 arch/blackfin/include/asm/bfin5xx_spi.h           |    2 +-
 arch/blackfin/include/asm/bfin_sport.h            |    9 +-
 arch/blackfin/include/asm/gpio.h                  |    7 +-
 arch/blackfin/include/asm/gptimers.h              |    6 +-
 arch/blackfin/kernel/bfin_gpio.c                  |   78 ++++---
 arch/blackfin/kernel/vmlinux.lds.S                |    4 +
 arch/blackfin/mach-bf518/include/mach/blackfin.h  |    2 -
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h |   67 ++++++
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h |   67 ++++++
 arch/blackfin/mach-bf518/include/mach/defBF514.h  |  135 ++++++++++++
 arch/blackfin/mach-bf518/include/mach/defBF516.h  |  135 ++++++++++++
 arch/blackfin/mach-bf527/include/mach/blackfin.h  |    2 -
 arch/blackfin/mach-bf537/boards/stamp.c           |  235 ++++++++++++++++++++-
 arch/blackfin/mach-bf548/include/mach/blackfin.h  |    2 -
 arch/blackfin/mach-common/pm.c                    |    2 +-
 36 files changed, 1204 insertions(+), 537 deletions(-)

Cliff Cai (3):
      Blackfin arch: add sport-spi related resource stuff to board file
      Blackfin arch: sport spi needs 6 gpio pins
      Blackfin arch: add RSI's definitions to bf514 and bf516

Michael Hennerich (4):
      Blackfin arch: add a check to make sure only Blackfin GPIOs may generate IRQs
      Blackfin arch: enable the platfrom PATA driver with CF Cards
      Blackfin arch: Privide BF537-STAMP platform data of ADP5520 Multifunction driver
      Blackfin arch: Blacklist Hibernate (PM_SUSPEND_MEM) on BF561 as well

Mike Frysinger (5):
      Blackfin arch: include linux headers that this one uses definitions from fro sport drivers
      Blackfin arch: bf51x processors also have 8 timers
      Blackfin arch: convert BF5{18,27,48}_FAMILY to CONFIG_BF{51,52,54}x
      Blackfin arch: clean up sports header file
      Blackfin arch: add link-time asserts to make sure on-chip regions dont overflow

Robin Getz (1):
      Blackfin arch: be less noisy when gets a gpio conflict after kernel has booted

Sonic Zhang (1):
      Blackfin arch: update default kernel configuration

diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 281f4b6..c121d6e 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -1,7 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28
-# Fri Feb 20 10:01:44 2009
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -43,7 +42,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -314,7 +313,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -375,7 +374,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -634,6 +632,7 @@ CONFIG_BFIN_RX_DESC_NUM=20
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
 
@@ -793,6 +792,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -816,6 +816,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -865,7 +871,26 @@ CONFIG_DUMMY_CONSOLE=y
 # CONFIG_SOUND is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
-# CONFIG_MMC is not set
+CONFIG_MMC=y
+# CONFIG_MMC_DEBUG is not set
+# CONFIG_MMC_UNSAFE_RESUME is not set
+
+#
+# MMC/SD/SDIO Card Drivers
+#
+CONFIG_MMC_BLOCK=y
+CONFIG_MMC_BLOCK_BOUNCE=y
+# CONFIG_SDIO_UART is not set
+# CONFIG_MMC_TEST is not set
+
+#
+# MMC/SD/SDIO Host Controller Drivers
+#
+# CONFIG_MMC_SDHCI is not set
+CONFIG_SDH_BFIN=m
+CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND=y
+CONFIG_SDH_BFIN_ENABLE_SDIO_IRQ=y
+# CONFIG_MMC_SPI is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 # CONFIG_ACCESSIBILITY is not set
@@ -1121,7 +1146,6 @@ CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
-# CONFIG_KGDB_TESTCASE is not set
 CONFIG_DEBUG_VERBOSE=y
 CONFIG_DEBUG_MMRS=y
 # CONFIG_DEBUG_HWERR is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 8e2b855..3e562b2 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -42,7 +42,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -55,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -132,15 +132,20 @@ CONFIG_BF526=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=0
 CONFIG_BF_REV_MAX=2
-CONFIG_BF_REV_0_0=y
-# CONFIG_BF_REV_0_1 is not set
+# CONFIG_BF_REV_0_0 is not set
+CONFIG_BF_REV_0_1=y
 # CONFIG_BF_REV_0_2 is not set
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
@@ -313,7 +318,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -374,7 +379,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -583,7 +587,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -637,6 +643,7 @@ CONFIG_BFIN_MAC_RMII=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -815,6 +822,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -838,6 +846,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7462 is not set
 # CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ADT7473 is not set
 # CONFIG_SENSORS_ATXP1 is not set
@@ -896,6 +905,12 @@ CONFIG_BFIN_WDT=y
 # USB-based Watchdog Cards
 #
 # CONFIG_USBPCWATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -904,8 +919,10 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -940,55 +957,7 @@ CONFIG_BFIN_WDT=y
 # Console display driver support
 #
 CONFIG_DUMMY_CONSOLE=y
-CONFIG_SOUND=m
-CONFIG_SOUND_OSS_CORE=y
-CONFIG_SND=m
-CONFIG_SND_TIMER=m
-CONFIG_SND_PCM=m
-# CONFIG_SND_SEQUENCER is not set
-CONFIG_SND_OSSEMUL=y
-CONFIG_SND_MIXER_OSS=m
-CONFIG_SND_PCM_OSS=m
-CONFIG_SND_PCM_OSS_PLUGINS=y
-# CONFIG_SND_DYNAMIC_MINORS is not set
-CONFIG_SND_SUPPORT_OLD_API=y
-CONFIG_SND_VERBOSE_PROCFS=y
-# CONFIG_SND_VERBOSE_PRINTK is not set
-# CONFIG_SND_DEBUG is not set
-CONFIG_SND_DRIVERS=y
-# CONFIG_SND_DUMMY is not set
-# CONFIG_SND_MTPAV is not set
-# CONFIG_SND_SERIAL_U16550 is not set
-# CONFIG_SND_MPU401 is not set
-CONFIG_SND_SPI=y
-
-#
-# ALSA Blackfin devices
-#
-# CONFIG_SND_BLACKFIN_AD1836 is not set
-# CONFIG_SND_BFIN_AD73322 is not set
-CONFIG_SND_USB=y
-# CONFIG_SND_USB_AUDIO is not set
-# CONFIG_SND_USB_CAIAQ is not set
-CONFIG_SND_SOC=m
-CONFIG_SND_SOC_AC97_BUS=y
-CONFIG_SND_BF5XX_I2S=m
-CONFIG_SND_BF5XX_SOC_SSM2602=m
-# CONFIG_SND_BF5XX_SOC_AD73311 is not set
-CONFIG_SND_BF5XX_AC97=m
-CONFIG_SND_BF5XX_MMAP_SUPPORT=y
-# CONFIG_SND_BF5XX_MULTICHAN_SUPPORT is not set
-CONFIG_SND_BF5XX_SOC_SPORT=m
-CONFIG_SND_BF5XX_SOC_I2S=m
-CONFIG_SND_BF5XX_SOC_AC97=m
-CONFIG_SND_BF5XX_SOC_AD1980=m
-CONFIG_SND_BF5XX_SPORT_NUM=0
-# CONFIG_SND_BF5XX_HAVE_COLD_RESET is not set
-# CONFIG_SND_SOC_ALL_CODECS is not set
-CONFIG_SND_SOC_AD1980=m
-CONFIG_SND_SOC_SSM2602=m
-# CONFIG_SOUND_PRIME is not set
-CONFIG_AC97_BUS=m
+# CONFIG_SOUND is not set
 CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
@@ -1063,13 +1032,15 @@ CONFIG_USB_MUSB_HDRC=y
 CONFIG_USB_MUSB_SOC=y
 
 #
-# Blackfin high speed USB support
+# Blackfin high speed USB Support
 #
 CONFIG_USB_MUSB_HOST=y
 # CONFIG_USB_MUSB_PERIPHERAL is not set
 # CONFIG_USB_MUSB_OTG is not set
+# CONFIG_USB_GADGET_MUSB_HDRC is not set
 CONFIG_USB_MUSB_HDRC_HCD=y
 CONFIG_MUSB_PIO_ONLY=y
+CONFIG_MUSB_DMA_POLL=y
 # CONFIG_USB_MUSB_DEBUG is not set
 
 #
@@ -1081,18 +1052,33 @@ CONFIG_MUSB_PIO_ONLY=y
 # CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 
 #
-# may also be needed; see USB_STORAGE Help for more information
+# see USB_STORAGE Help for more information
 #
+CONFIG_USB_STORAGE=m
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_DPCM is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 # CONFIG_USB_LIBUSUAL is not set
 
 #
 # USB Imaging devices
 #
 # CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
 
 #
 # USB port drivers
@@ -1124,6 +1110,30 @@ CONFIG_MUSB_PIO_ONLY=y
 # CONFIG_USB_ISIGHTFW is not set
 # CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
+# CONFIG_USB_GADGET_AT91 is not set
+# CONFIG_USB_GADGET_ATMEL_USBA is not set
+# CONFIG_USB_GADGET_FSL_USB2 is not set
+# CONFIG_USB_GADGET_LH7A40X is not set
+# CONFIG_USB_GADGET_OMAP is not set
+# CONFIG_USB_GADGET_PXA25X is not set
+# CONFIG_USB_GADGET_PXA27X is not set
+# CONFIG_USB_GADGET_S3C2410 is not set
+# CONFIG_USB_GADGET_M66592 is not set
+# CONFIG_USB_GADGET_AMD5536UDC is not set
+# CONFIG_USB_GADGET_FSL_QE is not set
+# CONFIG_USB_GADGET_NET2272 is not set
+# CONFIG_USB_GADGET_NET2280 is not set
+# CONFIG_USB_GADGET_GOKU is not set
+# CONFIG_USB_GADGET_DUMMY_HCD is not set
+# CONFIG_USB_ZERO is not set
+# CONFIG_USB_AUDIO is not set
+# CONFIG_USB_ETH is not set
+# CONFIG_USB_GADGETFS is not set
+# CONFIG_USB_FILE_STORAGE is not set
+# CONFIG_USB_G_SERIAL is not set
+# CONFIG_USB_MIDI_GADGET is not set
+# CONFIG_USB_G_PRINTER is not set
+# CONFIG_USB_CDC_COMPOSITE is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
@@ -1158,12 +1168,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1384,6 +1396,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1423,6 +1442,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index a50050f..911b5db 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -36,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -133,15 +132,20 @@ CONFIG_BF527=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=0
 CONFIG_BF_REV_MAX=2
-CONFIG_BF_REV_0_0=y
-# CONFIG_BF_REV_0_1 is not set
+# CONFIG_BF_REV_0_0 is not set
+CONFIG_BF_REV_0_1=y
 # CONFIG_BF_REV_0_2 is not set
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
@@ -314,7 +318,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -375,7 +379,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -626,7 +629,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -681,6 +686,7 @@ CONFIG_BFIN_MAC_RMII=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -755,8 +761,8 @@ CONFIG_INPUT_MISC=y
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
-# CONFIG_BF5xx_PPI is not set
-# CONFIG_BFIN_SPORT is not set
+CONFIG_BF5xx_PPI=m
+CONFIG_BFIN_SPORT=m
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
 CONFIG_BFIN_DMA_INTERFACE=m
@@ -859,6 +865,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -871,60 +878,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -940,6 +894,12 @@ CONFIG_BFIN_WDT=y
 # USB-based Watchdog Cards
 #
 # CONFIG_USBPCWATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -948,8 +908,10 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -1000,6 +962,7 @@ CONFIG_FB_BFIN_T350MCQB=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=m
 CONFIG_LCD_LTV350QV=m
@@ -1152,13 +1115,15 @@ CONFIG_USB_MUSB_HDRC=y
 CONFIG_USB_MUSB_SOC=y
 
 #
-# Blackfin high speed USB support
+# Blackfin high speed USB Support
 #
 CONFIG_USB_MUSB_HOST=y
 # CONFIG_USB_MUSB_PERIPHERAL is not set
 # CONFIG_USB_MUSB_OTG is not set
+# CONFIG_USB_GADGET_MUSB_HDRC is not set
 CONFIG_USB_MUSB_HDRC_HCD=y
 CONFIG_MUSB_PIO_ONLY=y
+CONFIG_MUSB_DMA_POLL=y
 # CONFIG_USB_MUSB_DEBUG is not set
 
 #
@@ -1170,18 +1135,33 @@ CONFIG_MUSB_PIO_ONLY=y
 # CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 
 #
-# may also be needed; see USB_STORAGE Help for more information
+# see USB_STORAGE Help for more information
 #
+CONFIG_USB_STORAGE=m
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_DPCM is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 # CONFIG_USB_LIBUSUAL is not set
 
 #
 # USB Imaging devices
 #
 # CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
 
 #
 # USB port drivers
@@ -1213,6 +1193,30 @@ CONFIG_MUSB_PIO_ONLY=y
 # CONFIG_USB_ISIGHTFW is not set
 # CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
+# CONFIG_USB_GADGET_AT91 is not set
+# CONFIG_USB_GADGET_ATMEL_USBA is not set
+# CONFIG_USB_GADGET_FSL_USB2 is not set
+# CONFIG_USB_GADGET_LH7A40X is not set
+# CONFIG_USB_GADGET_OMAP is not set
+# CONFIG_USB_GADGET_PXA25X is not set
+# CONFIG_USB_GADGET_PXA27X is not set
+# CONFIG_USB_GADGET_S3C2410 is not set
+# CONFIG_USB_GADGET_M66592 is not set
+# CONFIG_USB_GADGET_AMD5536UDC is not set
+# CONFIG_USB_GADGET_FSL_QE is not set
+# CONFIG_USB_GADGET_NET2272 is not set
+# CONFIG_USB_GADGET_NET2280 is not set
+# CONFIG_USB_GADGET_GOKU is not set
+# CONFIG_USB_GADGET_DUMMY_HCD is not set
+# CONFIG_USB_ZERO is not set
+# CONFIG_USB_AUDIO is not set
+# CONFIG_USB_ETH is not set
+# CONFIG_USB_GADGETFS is not set
+# CONFIG_USB_FILE_STORAGE is not set
+# CONFIG_USB_G_SERIAL is not set
+# CONFIG_USB_MIDI_GADGET is not set
+# CONFIG_USB_G_PRINTER is not set
+# CONFIG_USB_CDC_COMPOSITE is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
@@ -1247,12 +1251,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1473,6 +1479,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1512,6 +1525,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 0a2a00d..4c41e03 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -36,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -133,10 +132,15 @@ CONFIG_BF533=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=3
 CONFIG_BF_REV_MAX=6
@@ -157,7 +161,6 @@ CONFIG_BFIN533_EZKIT=y
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
 # CONFIG_H8606_HVSISTEMAS is not set
 # CONFIG_BFIN532_IP0X is not set
-# CONFIG_GENERIC_BF533_BOARD is not set
 
 #
 # BF533/2/1 Specific Configuration
@@ -277,7 +280,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -575,6 +578,7 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -608,6 +612,7 @@ CONFIG_SMC91X=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -714,6 +719,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -726,22 +732,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -752,6 +743,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -760,7 +757,7 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
-# CONFIG_MFD_WM8400 is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -826,6 +823,7 @@ CONFIG_RTC_INTF_DEV=y
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1046,6 +1044,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1084,6 +1089,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index eb02758..9c482cd 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -36,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -133,10 +132,15 @@ CONFIG_BF533=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=3
 CONFIG_BF_REV_MAX=6
@@ -157,7 +161,6 @@ CONFIG_BFIN533_STAMP=y
 # CONFIG_BFIN533_BLUETECHNIX_CM is not set
 # CONFIG_H8606_HVSISTEMAS is not set
 # CONFIG_BFIN532_IP0X is not set
-# CONFIG_GENERIC_BF533_BOARD is not set
 
 #
 # BF533/2/1 Specific Configuration
@@ -277,7 +280,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -578,7 +581,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -612,6 +617,7 @@ CONFIG_SMC91X=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -671,10 +677,10 @@ CONFIG_CONFIG_INPUT_PCF8574=m
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
-# CONFIG_BF5xx_PPI is not set
-CONFIG_BFIN_SPORT=y
+CONFIG_BF5xx_PPI=m
+CONFIG_BFIN_SPORT=m
 # CONFIG_BFIN_TIMER_LATENCY is not set
-CONFIG_TWI_LCD=m
+# CONFIG_TWI_LCD is not set
 CONFIG_BFIN_DMA_INTERFACE=m
 CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
@@ -765,6 +771,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -777,60 +784,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -841,6 +795,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -851,6 +811,7 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_TMIO is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -909,6 +870,7 @@ CONFIG_ADV7393_1XMEM=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -1018,12 +980,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1244,6 +1208,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1282,6 +1253,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 9e62b9f..591f6ed 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,7 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
-# Tue Dec 30 17:24:37 2008
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -37,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -134,10 +132,15 @@ CONFIG_BF537=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=2
 CONFIG_BF_REV_MAX=3
@@ -184,7 +187,6 @@ CONFIG_BFIN537_STAMP=y
 # CONFIG_BFIN537_BLUETECHNIX_TCM is not set
 # CONFIG_PNAV10 is not set
 # CONFIG_CAMSIG_MINOTAUR is not set
-# CONFIG_GENERIC_BF537_BOARD is not set
 
 #
 # BF537 Specific Configuration
@@ -589,7 +591,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -644,6 +648,7 @@ CONFIG_BFIN_RX_DESC_NUM=20
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -706,10 +711,10 @@ CONFIG_SERIO_LIBPS2=y
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
-# CONFIG_BF5xx_PPI is not set
+CONFIG_BF5xx_PPI=m
 CONFIG_BFIN_SPORT=m
 # CONFIG_BFIN_TIMER_LATENCY is not set
-CONFIG_TWI_LCD=m
+# CONFIG_TWI_LCD is not set
 CONFIG_BFIN_DMA_INTERFACE=m
 CONFIG_SIMPLE_GPIO=m
 # CONFIG_VT is not set
@@ -808,6 +813,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -820,60 +826,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -884,6 +837,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -894,6 +853,7 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_TMIO is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -957,6 +917,7 @@ CONFIG_ADV7393_1XMEM=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=m
 # CONFIG_LCD_LTV350QV is not set
@@ -1074,12 +1035,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1300,6 +1263,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1338,6 +1308,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index dd6ad6b..1a8e8c3 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -42,7 +42,7 @@ CONFIG_LOG_BUF_SHIFT=14
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -55,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -132,10 +132,15 @@ CONFIG_PREEMPT_VOLUNTARY=y
 CONFIG_BF538=y
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=4
 CONFIG_BF_REV_MAX=5
@@ -293,7 +298,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -354,7 +359,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -645,6 +649,7 @@ CONFIG_SMC91X=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
 
@@ -690,7 +695,7 @@ CONFIG_INPUT_TOUCHSCREEN=y
 # CONFIG_TOUCHSCREEN_AD7877 is not set
 # CONFIG_TOUCHSCREEN_AD7879_I2C is not set
 CONFIG_TOUCHSCREEN_AD7879_SPI=y
-CONFIG_TOUCHSCREEN_AD7879=m
+CONFIG_TOUCHSCREEN_AD7879=y
 # CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
@@ -718,8 +723,8 @@ CONFIG_INPUT_MISC=y
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
-# CONFIG_BF5xx_PPI is not set
-CONFIG_BFIN_SPORT=y
+CONFIG_BF5xx_PPI=m
+CONFIG_BFIN_SPORT=m
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
 CONFIG_BFIN_DMA_INTERFACE=m
@@ -762,7 +767,7 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
-CONFIG_I2C=y
+CONFIG_I2C=m
 CONFIG_I2C_BOARDINFO=y
 # CONFIG_I2C_CHARDEV is not set
 CONFIG_I2C_HELPER_AUTO=y
@@ -774,7 +779,7 @@ CONFIG_I2C_HELPER_AUTO=y
 #
 # I2C system bus drivers (mostly embedded / system-on-chip)
 #
-CONFIG_I2C_BLACKFIN_TWI=y
+CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 # CONFIG_I2C_GPIO is not set
 # CONFIG_I2C_OCORES is not set
@@ -818,6 +823,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -830,60 +836,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -894,6 +847,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -904,6 +863,7 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_TMIO is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -954,6 +914,7 @@ CONFIG_FB_BFIN_LQ035Q1=m
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -1007,12 +968,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1233,6 +1196,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1271,6 +1241,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 6bc2fb1..2cd1c2b 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -36,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -133,16 +132,21 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 CONFIG_BF548=y
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=0
 CONFIG_BF_REV_MAX=2
-CONFIG_BF_REV_0_0=y
+# CONFIG_BF_REV_0_0 is not set
 # CONFIG_BF_REV_0_1 is not set
-# CONFIG_BF_REV_0_2 is not set
+CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
 # CONFIG_BF_REV_0_5 is not set
@@ -348,7 +352,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 CONFIG_DMA_UNCACHED_2M=y
 # CONFIG_DMA_UNCACHED_1M is not set
@@ -413,7 +417,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -512,9 +515,9 @@ CONFIG_IRCOMM=m
 #
 CONFIG_IRTTY_SIR=m
 CONFIG_BFIN_SIR=m
-CONFIG_BFIN_SIR3=y
 # CONFIG_BFIN_SIR0 is not set
 # CONFIG_BFIN_SIR2 is not set
+CONFIG_BFIN_SIR3=y
 CONFIG_SIR_BFIN_DMA=y
 # CONFIG_SIR_BFIN_PIO is not set
 
@@ -538,7 +541,8 @@ CONFIG_SIR_BFIN_DMA=y
 CONFIG_WIRELESS=y
 # CONFIG_CFG80211 is not set
 CONFIG_WIRELESS_OLD_REGULATORY=y
-# CONFIG_WIRELESS_EXT is not set
+CONFIG_WIRELESS_EXT=y
+CONFIG_WIRELESS_EXT_SYSFS=y
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
@@ -554,7 +558,9 @@ CONFIG_WIRELESS_OLD_REGULATORY=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
+CONFIG_FW_LOADER=m
+CONFIG_FIRMWARE_IN_KERNEL=y
+CONFIG_EXTRA_FIRMWARE=""
 # CONFIG_DEBUG_DRIVER is not set
 # CONFIG_DEBUG_DEVRES is not set
 # CONFIG_SYS_HYPERVISOR is not set
@@ -668,7 +674,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -743,6 +751,7 @@ CONFIG_SMSC911X=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -751,8 +760,16 @@ CONFIG_NETDEV_10000=y
 # Wireless LAN
 #
 # CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
+CONFIG_WLAN_80211=y
+CONFIG_LIBERTAS=m
+# CONFIG_LIBERTAS_USB is not set
+CONFIG_LIBERTAS_SDIO=m
+CONFIG_POWEROF2_BLOCKSIZE_ONLY=y
+# CONFIG_LIBERTAS_DEBUG is not set
+# CONFIG_USB_ZD1201 is not set
+# CONFIG_USB_NET_RNDIS_WLAN is not set
 # CONFIG_IWLWIFI_LEDS is not set
+# CONFIG_HOSTAP is not set
 
 #
 # USB Network Adapters
@@ -844,8 +861,8 @@ CONFIG_INPUT_MISC=y
 # CONFIG_SPI_ADC_BF533 is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BFIN_SIMPLE_TIMER is not set
-# CONFIG_BF5xx_PPI is not set
-# CONFIG_BFIN_SPORT is not set
+CONFIG_BF5xx_PPI=m
+CONFIG_BFIN_SPORT=m
 # CONFIG_BFIN_TIMER_LATENCY is not set
 # CONFIG_TWI_LCD is not set
 CONFIG_BFIN_DMA_INTERFACE=m
@@ -950,6 +967,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -962,60 +980,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_AD7414 is not set
-# CONFIG_SENSORS_AD7418 is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_ADM1021 is not set
-# CONFIG_SENSORS_ADM1025 is not set
-# CONFIG_SENSORS_ADM1026 is not set
-# CONFIG_SENSORS_ADM1029 is not set
-# CONFIG_SENSORS_ADM1031 is not set
-# CONFIG_SENSORS_ADM9240 is not set
-# CONFIG_SENSORS_ADT7470 is not set
-# CONFIG_SENSORS_ADT7473 is not set
-# CONFIG_SENSORS_ATXP1 is not set
-# CONFIG_SENSORS_DS1621 is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_F75375S is not set
-# CONFIG_SENSORS_GL518SM is not set
-# CONFIG_SENSORS_GL520SM is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM63 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_LM75 is not set
-# CONFIG_SENSORS_LM77 is not set
-# CONFIG_SENSORS_LM78 is not set
-# CONFIG_SENSORS_LM80 is not set
-# CONFIG_SENSORS_LM83 is not set
-# CONFIG_SENSORS_LM85 is not set
-# CONFIG_SENSORS_LM87 is not set
-# CONFIG_SENSORS_LM90 is not set
-# CONFIG_SENSORS_LM92 is not set
-# CONFIG_SENSORS_LM93 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_MAX1619 is not set
-# CONFIG_SENSORS_MAX6650 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_DME1737 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47M192 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_ADS7828 is not set
-# CONFIG_SENSORS_THMC50 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83781D is not set
-# CONFIG_SENSORS_W83791D is not set
-# CONFIG_SENSORS_W83792D is not set
-# CONFIG_SENSORS_W83793 is not set
-# CONFIG_SENSORS_W83L785TS is not set
-# CONFIG_SENSORS_W83L786NG is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -1031,6 +996,12 @@ CONFIG_BFIN_WDT=y
 # USB-based Watchdog Cards
 #
 # CONFIG_USBPCWATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -1039,8 +1010,10 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -1092,6 +1065,7 @@ CONFIG_FB_BF54X_LQ043=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -1243,15 +1217,15 @@ CONFIG_USB_MUSB_HDRC=y
 CONFIG_USB_MUSB_SOC=y
 
 #
-# Blackfin high speed USB support
+# Blackfin high speed USB Support
 #
 CONFIG_USB_MUSB_HOST=y
 # CONFIG_USB_MUSB_PERIPHERAL is not set
 # CONFIG_USB_MUSB_OTG is not set
+# CONFIG_USB_GADGET_MUSB_HDRC is not set
 CONFIG_USB_MUSB_HDRC_HCD=y
-# CONFIG_MUSB_PIO_ONLY is not set
-CONFIG_USB_INVENTRA_DMA=y
-# CONFIG_USB_TI_CPPI_DMA is not set
+CONFIG_MUSB_PIO_ONLY=y
+CONFIG_MUSB_DMA_POLL=y
 # CONFIG_USB_MUSB_DEBUG is not set
 
 #
@@ -1263,11 +1237,11 @@ CONFIG_USB_INVENTRA_DMA=y
 # CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 
 #
-# may also be needed; see USB_STORAGE Help for more information
+# see USB_STORAGE Help for more information
 #
 CONFIG_USB_STORAGE=m
 # CONFIG_USB_STORAGE_DEBUG is not set
@@ -1321,7 +1295,31 @@ CONFIG_USB_STORAGE=m
 # CONFIG_USB_ISIGHTFW is not set
 # CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
-CONFIG_MMC=m
+# CONFIG_USB_GADGET_AT91 is not set
+# CONFIG_USB_GADGET_ATMEL_USBA is not set
+# CONFIG_USB_GADGET_FSL_USB2 is not set
+# CONFIG_USB_GADGET_LH7A40X is not set
+# CONFIG_USB_GADGET_OMAP is not set
+# CONFIG_USB_GADGET_PXA25X is not set
+# CONFIG_USB_GADGET_PXA27X is not set
+# CONFIG_USB_GADGET_S3C2410 is not set
+# CONFIG_USB_GADGET_M66592 is not set
+# CONFIG_USB_GADGET_AMD5536UDC is not set
+# CONFIG_USB_GADGET_FSL_QE is not set
+# CONFIG_USB_GADGET_NET2272 is not set
+# CONFIG_USB_GADGET_NET2280 is not set
+# CONFIG_USB_GADGET_GOKU is not set
+# CONFIG_USB_GADGET_DUMMY_HCD is not set
+# CONFIG_USB_ZERO is not set
+# CONFIG_USB_AUDIO is not set
+# CONFIG_USB_ETH is not set
+# CONFIG_USB_GADGETFS is not set
+# CONFIG_USB_FILE_STORAGE is not set
+# CONFIG_USB_G_SERIAL is not set
+# CONFIG_USB_MIDI_GADGET is not set
+# CONFIG_USB_G_PRINTER is not set
+# CONFIG_USB_CDC_COMPOSITE is not set
+CONFIG_MMC=y
 # CONFIG_MMC_DEBUG is not set
 # CONFIG_MMC_UNSAFE_RESUME is not set
 
@@ -1337,8 +1335,9 @@ CONFIG_MMC_BLOCK_BOUNCE=y
 # MMC/SD/SDIO Host Controller Drivers
 #
 # CONFIG_MMC_SDHCI is not set
-CONFIG_SDH_BFIN=m
+CONFIG_SDH_BFIN=y
 # CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND is not set
+# CONFIG_SDH_BFIN_ENABLE_SDIO_IRQ is not set
 # CONFIG_MMC_SPI is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
@@ -1373,12 +1372,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1641,6 +1642,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1680,6 +1688,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 69714fb..4a6ea8e 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -36,14 +36,13 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +55,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -133,10 +132,15 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 CONFIG_BF561=y
 # CONFIG_SMP is not set
 CONFIG_BF_REV_MIN=3
@@ -166,7 +170,6 @@ CONFIG_IRQ_SPI_ERROR=7
 CONFIG_BFIN561_EZKIT=y
 # CONFIG_BFIN561_TEPLA is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
-# CONFIG_GENERIC_BF561_BOARD is not set
 
 #
 # BF561 Specific Configuration
@@ -316,7 +319,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_GPTIMERS=m
 # CONFIG_DMA_UNCACHED_4M is not set
 # CONFIG_DMA_UNCACHED_2M is not set
 CONFIG_DMA_UNCACHED_1M=y
@@ -382,7 +385,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -612,6 +614,7 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -645,6 +648,7 @@ CONFIG_SMC91X=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -751,6 +755,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -763,22 +768,7 @@ CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
 # CONFIG_POWER_SUPPLY is not set
-CONFIG_HWMON=y
-# CONFIG_HWMON_VID is not set
-# CONFIG_SENSORS_ADCXX is not set
-# CONFIG_SENSORS_F71805F is not set
-# CONFIG_SENSORS_F71882FG is not set
-# CONFIG_SENSORS_IT87 is not set
-# CONFIG_SENSORS_LM70 is not set
-# CONFIG_SENSORS_MAX1111 is not set
-# CONFIG_SENSORS_PC87360 is not set
-# CONFIG_SENSORS_PC87427 is not set
-# CONFIG_SENSORS_SMSC47M1 is not set
-# CONFIG_SENSORS_SMSC47B397 is not set
-# CONFIG_SENSORS_VT1211 is not set
-# CONFIG_SENSORS_W83627HF is not set
-# CONFIG_SENSORS_W83627EHF is not set
-# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_HWMON is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
@@ -789,6 +779,12 @@ CONFIG_WATCHDOG=y
 #
 # CONFIG_SOFT_WATCHDOG is not set
 CONFIG_BFIN_WDT=y
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -797,7 +793,7 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
-# CONFIG_MFD_WM8400 is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -1041,6 +1037,13 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1079,6 +1082,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 017c6ea..ef1a2c8 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -43,7 +43,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,7 +56,7 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index d880ef7..e2fc588 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -43,7 +43,7 @@ CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,13 +56,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index 085211b..65a8bbb 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -46,7 +46,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_RELAY is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 750203e..9b7e9d7 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -46,7 +46,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_RELAY is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index dec8a7d..569523c 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -46,7 +46,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_RELAY is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index f410430..035b635 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -46,7 +46,7 @@ CONFIG_FAIR_USER_SCHED=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 346bc7a..7015e42 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -46,7 +46,7 @@ CONFIG_FAIR_USER_SCHED=y
 # CONFIG_RELAY is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index bd553da..dfc8e1d 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -45,7 +45,7 @@ CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -56,7 +56,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index 7db9387..95a5f91 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -46,7 +46,7 @@ CONFIG_SYSFS_DEPRECATED=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -57,7 +57,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index ad09670..78e2408 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -1,6 +1,6 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
+# Linux kernel version: 2.6.28.7
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -35,13 +35,12 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CGROUPS is not set
 # CONFIG_GROUP_SCHED is not set
-# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
 # CONFIG_RELAY is not set
 # CONFIG_NAMESPACES is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -53,13 +52,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -130,10 +129,15 @@ CONFIG_BF537=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=2
 CONFIG_BF_REV_MAX=3
@@ -180,7 +184,6 @@ CONFIG_IRQ_SPI=10
 # CONFIG_BFIN537_BLUETECHNIX_TCM is not set
 CONFIG_PNAV10=y
 # CONFIG_CAMSIG_MINOTAUR is not set
-# CONFIG_GENERIC_BF537_BOARD is not set
 
 #
 # BF537 Specific Configuration
@@ -341,7 +344,6 @@ CONFIG_BINFMT_ZFLAT=y
 #
 # CONFIG_PM is not set
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
-# CONFIG_PM_WAKEUP_BY_GPIO is not set
 
 #
 # CPU Frequency scaling
@@ -538,7 +540,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -593,6 +597,7 @@ CONFIG_BFIN_MAC_RMII=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_B44 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_AX88180 is not set
 CONFIG_NETDEV_10000=y
@@ -776,6 +781,7 @@ CONFIG_SPI_MASTER=y
 #
 CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BFIN_SPORT is not set
 # CONFIG_SPI_BITBANG is not set
 
 #
@@ -799,6 +805,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7462 is not set
 # CONFIG_SENSORS_ADT7470 is not set
 # CONFIG_SENSORS_ADT7473 is not set
 # CONFIG_SENSORS_ATXP1 is not set
@@ -845,6 +852,12 @@ CONFIG_HWMON=y
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 # CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
 
 #
 # Multifunction device drivers
@@ -853,8 +866,10 @@ CONFIG_HWMON=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -910,6 +925,7 @@ CONFIG_FB_BFIN_LANDSCAPE=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 # CONFIG_LCD_LTV350QV is not set
@@ -966,7 +982,7 @@ CONFIG_USB_ARCH_HAS_HCD=y
 #
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 # CONFIG_USB_GADGET is not set
 # CONFIG_MMC is not set
@@ -1003,12 +1019,14 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
 #
 # CONFIG_RTC_DRV_M41T94 is not set
 # CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
 # CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_R9701 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
@@ -1196,6 +1214,10 @@ CONFIG_FRAME_WARN=1024
 # CONFIG_DEBUG_MEMORY_INIT is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -1230,6 +1252,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index a46529c..2bc0779 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -49,7 +49,7 @@ CONFIG_SYSFS_DEPRECATED=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
@@ -61,7 +61,7 @@ CONFIG_PRINTK=y
 CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index 97a1f1d..e65b3a4 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -39,7 +39,7 @@ CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_NAMESPACES is not set
 # CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
+# CONFIG_SYSCTL is not set
 CONFIG_EMBEDDED=y
 # CONFIG_UID16 is not set
 CONFIG_SYSCTL_SYSCALL=y
@@ -51,13 +51,13 @@ CONFIG_BUG=y
 # CONFIG_ELF_CORE is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
+# CONFIG_FUTEX is not set
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
-CONFIG_AIO=y
+# CONFIG_AIO is not set
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
index 1306e6b..0292d58 100644
--- a/arch/blackfin/include/asm/bfin5xx_spi.h
+++ b/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -110,7 +110,7 @@
 struct bfin5xx_spi_master {
 	u16 num_chipselect;
 	u8 enable_dma;
-	u16 pin_req[4];
+	u16 pin_req[7];
 };
 
 /* spi_board_info.controller_data for SPI slave devices,
diff --git a/arch/blackfin/include/asm/bfin_sport.h b/arch/blackfin/include/asm/bfin_sport.h
index 65a651d..b558908 100644
--- a/arch/blackfin/include/asm/bfin_sport.h
+++ b/arch/blackfin/include/asm/bfin_sport.h
@@ -9,6 +9,13 @@
 #ifndef __BFIN_SPORT_H__
 #define __BFIN_SPORT_H__
 
+#ifdef __KERNEL__
+#include <linux/cdev.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#endif
+
 #define SPORT_MAJOR	237
 #define SPORT_NR_DEVS	2
 
@@ -119,7 +126,7 @@ struct sport_dev {
 	int tx_len;
 	int tx_sent;
 
-	int sport_err_irq;
+	int err_irq;
 
 	struct mutex mutex;	/* mutual exclusion semaphore */
 	struct task_struct *task;
diff --git a/arch/blackfin/include/asm/gpio.h b/arch/blackfin/include/asm/gpio.h
index d4a082e..fe13961 100644
--- a/arch/blackfin/include/asm/gpio.h
+++ b/arch/blackfin/include/asm/gpio.h
@@ -110,7 +110,7 @@
 * MODIFICATION HISTORY :
 **************************************************************/
 
-#ifndef BF548_FAMILY
+#ifndef CONFIG_BF54x
 void set_gpio_dir(unsigned, unsigned short);
 void set_gpio_inen(unsigned, unsigned short);
 void set_gpio_polar(unsigned, unsigned short);
@@ -303,7 +303,10 @@ static inline void gpio_set_value(unsigned gpio, int value)
 
 static inline int gpio_to_irq(unsigned gpio)
 {
-	return (gpio + GPIO_IRQ_BASE);
+	if (likely(gpio < MAX_BLACKFIN_GPIOS))
+		return gpio + GPIO_IRQ_BASE;
+
+	return -EINVAL;
 }
 
 static inline int irq_to_gpio(unsigned irq)
diff --git a/arch/blackfin/include/asm/gptimers.h b/arch/blackfin/include/asm/gptimers.h
index 0520d2a..b0f847a 100644
--- a/arch/blackfin/include/asm/gptimers.h
+++ b/arch/blackfin/include/asm/gptimers.h
@@ -15,16 +15,16 @@
 #include <asm/blackfin.h>
 
 /*
- * BF537/BF527: 8 timers:
+ * BF51x/BF52x/BF537: 8 timers:
  */
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY)
+#if defined(CONFIG_BF51x) || defined(CONFIG_BF52x) || defined(BF537_FAMILY)
 # define MAX_BLACKFIN_GPTIMERS 8
 # define TIMER0_GROUP_REG      TIMER_ENABLE
 #endif
 /*
  * BF54x: 11 timers (BF542: 8 timers):
  */
-#if defined(BF548_FAMILY)
+#if defined(CONFIG_BF54x)
 # ifdef CONFIG_BF542
 #  define MAX_BLACKFIN_GPTIMERS 8
 # else
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 51dac55..a0678da 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -69,7 +69,7 @@ enum {
 static struct gpio_port_t * const gpio_array[] = {
 #if defined(BF533_FAMILY) || defined(BF538_FAMILY)
 	(struct gpio_port_t *) FIO_FLAG_D,
-#elif defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#elif defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 	(struct gpio_port_t *) PORTFIO,
 	(struct gpio_port_t *) PORTGIO,
 	(struct gpio_port_t *) PORTHIO,
@@ -77,7 +77,7 @@ static struct gpio_port_t * const gpio_array[] = {
 	(struct gpio_port_t *) FIO0_FLAG_D,
 	(struct gpio_port_t *) FIO1_FLAG_D,
 	(struct gpio_port_t *) FIO2_FLAG_D,
-#elif defined(BF548_FAMILY)
+#elif defined(CONFIG_BF54x)
 	(struct gpio_port_t *)PORTA_FER,
 	(struct gpio_port_t *)PORTB_FER,
 	(struct gpio_port_t *)PORTC_FER,
@@ -93,7 +93,7 @@ static struct gpio_port_t * const gpio_array[] = {
 #endif
 };
 
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 static unsigned short * const port_fer[] = {
 	(unsigned short *) PORTF_FER,
 	(unsigned short *) PORTG_FER,
@@ -109,11 +109,11 @@ static unsigned short * const port_mux[] = {
 
 static const
 u8 pmux_offset[][16] = {
-#  if defined(BF527_FAMILY)
+#  if defined(CONFIG_BF52x)
 	{ 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 4, 6, 8, 8, 10, 10 }, /* PORTF */
 	{ 0, 0, 0, 0, 0, 2, 2, 4, 4, 6, 8, 10, 10, 10, 12, 12 }, /* PORTG */
 	{ 0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 4, 4, 4, 4, 4, 4 }, /* PORTH */
-#  elif defined(BF518_FAMILY)
+#  elif defined(CONFIG_BF51x)
 	{ 0, 2, 2, 2, 2, 2, 2, 4, 6, 6, 6, 8, 8, 8, 8, 10 }, /* PORTF */
 	{ 0, 0, 0, 2, 4, 6, 6, 6, 8, 10, 10, 12, 14, 14, 14, 14 }, /* PORTG */
 	{ 0, 0, 0, 0, 2, 2, 4, 6, 10, 10, 10, 10, 10, 10, 10, 10 }, /* PORTH */
@@ -139,7 +139,7 @@ static struct gpio_port_s gpio_bank_saved[GPIO_BANK_NUM];
 
 inline int check_gpio(unsigned gpio)
 {
-#if defined(BF548_FAMILY)
+#if defined(CONFIG_BF54x)
 	if (gpio == GPIO_PB15 || gpio == GPIO_PC14 || gpio == GPIO_PC15
 	    || gpio == GPIO_PH14 || gpio == GPIO_PH15
 	    || gpio == GPIO_PJ14 || gpio == GPIO_PJ15)
@@ -187,13 +187,13 @@ static void port_setup(unsigned gpio, unsigned short usage)
 	if (check_gpio(gpio))
 		return;
 
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 	if (usage == GPIO_USAGE)
 		*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
 	else
 		*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
 	SSYNC();
-#elif defined(BF548_FAMILY)
+#elif defined(CONFIG_BF54x)
 	if (usage == GPIO_USAGE)
 		gpio_array[gpio_bank(gpio)]->port_fer &= ~gpio_bit(gpio);
 	else
@@ -273,7 +273,7 @@ static void portmux_setup(unsigned short per)
 		}
 	}
 }
-#elif defined(BF548_FAMILY)
+#elif defined(CONFIG_BF54x)
 inline void portmux_setup(unsigned short per)
 {
 	u32 pmux;
@@ -297,7 +297,7 @@ inline u16 get_portmux(unsigned short per)
 
 	return (pmux >> (2 * gpio_sub_n(ident)) & 0x3);
 }
-#elif defined(BF527_FAMILY) || defined(BF518_FAMILY)
+#elif defined(CONFIG_BF52x) || defined(CONFIG_BF51x)
 inline void portmux_setup(unsigned short per)
 {
 	u16 pmux, ident = P_IDENT(per), function = P_FUNCT2MUX(per);
@@ -322,7 +322,7 @@ static int __init bfin_gpio_init(void)
 arch_initcall(bfin_gpio_init);
 
 
-#ifndef BF548_FAMILY
+#ifndef CONFIG_BF54x
 /***********************************************************
 *
 * FUNCTIONS: Blackfin General Purpose Ports Access Functions
@@ -489,7 +489,7 @@ static const unsigned int sic_iwr_irqs[] = {
 	IRQ_PROG_INTB, IRQ_PORTG_INTB, IRQ_MAC_TX
 #elif defined(BF538_FAMILY)
 	IRQ_PORTF_INTB
-#elif defined(BF527_FAMILY) || defined(BF518_FAMILY)
+#elif defined(CONFIG_BF52x) || defined(CONFIG_BF51x)
 	IRQ_PORTF_INTB, IRQ_PORTG_INTB, IRQ_PORTH_INTB
 #elif defined(BF561_FAMILY)
 	IRQ_PROG0_INTB, IRQ_PROG1_INTB, IRQ_PROG2_INTB
@@ -586,7 +586,7 @@ u32 bfin_pm_standby_setup(void)
 		gpio_array[bank]->maskb = 0;
 
 		if (mask) {
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 			gpio_bank_saved[bank].fer   = *port_fer[bank];
 #endif
 			gpio_bank_saved[bank].inen  = gpio_array[bank]->inen;
@@ -631,7 +631,7 @@ void bfin_pm_standby_restore(void)
 		bank = gpio_bank(i);
 
 		if (mask) {
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 			*port_fer[bank]   	= gpio_bank_saved[bank].fer;
 #endif
 			gpio_array[bank]->inen  = gpio_bank_saved[bank].inen;
@@ -657,9 +657,9 @@ void bfin_gpio_pm_hibernate_suspend(void)
 	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
 		bank = gpio_bank(i);
 
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
 		gpio_bank_saved[bank].fer = *port_fer[bank];
-#if defined(BF527_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(CONFIG_BF51x)
 		gpio_bank_saved[bank].mux = *port_mux[bank];
 #else
 		if (bank == 0)
@@ -685,8 +685,8 @@ void bfin_gpio_pm_hibernate_restore(void)
 	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE) {
 		bank = gpio_bank(i);
 
-#if defined(BF527_FAMILY) || defined(BF537_FAMILY) || defined(BF518_FAMILY)
-#if defined(BF527_FAMILY) || defined(BF518_FAMILY)
+#if defined(CONFIG_BF52x) || defined(BF537_FAMILY) || defined(CONFIG_BF51x)
+#if defined(CONFIG_BF52x) || defined(CONFIG_BF51x)
 		*port_mux[bank] = gpio_bank_saved[bank].mux;
 #else
 		if (bank == 0)
@@ -710,7 +710,7 @@ void bfin_gpio_pm_hibernate_restore(void)
 
 
 #endif
-#else /* BF548_FAMILY */
+#else /* CONFIG_BF54x */
 #ifdef CONFIG_PM
 
 u32 bfin_pm_standby_setup(void)
@@ -762,7 +762,7 @@ unsigned short get_gpio_dir(unsigned gpio)
 }
 EXPORT_SYMBOL(get_gpio_dir);
 
-#endif /* BF548_FAMILY */
+#endif /* CONFIG_BF54x */
 
 /***********************************************************
 *
@@ -802,7 +802,8 @@ int peripheral_request(unsigned short per, const char *label)
 	 */
 	if (unlikely(!check_gpio(ident) &&
 	    reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		printk(KERN_ERR
 		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
 		       __func__, ident, get_label(ident));
@@ -817,7 +818,7 @@ int peripheral_request(unsigned short per, const char *label)
 		 * be requested and used by several drivers
 		 */
 
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 		if (!((per & P_MAYSHARE) && get_portmux(per) == P_FUNCT2MUX(per))) {
 #else
 		if (!(per & P_MAYSHARE)) {
@@ -830,7 +831,8 @@ int peripheral_request(unsigned short per, const char *label)
 			if (cmp_label(ident, label) == 0)
 				goto anyway;
 
-			dump_stack();
+			if (system_state == SYSTEM_BOOTING)
+				dump_stack();
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already reserved by %s !\n",
 			       __func__, ident, P_FUNCT2MUX(per), get_label(ident));
@@ -946,14 +948,16 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 	}
 
 	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved by %s !\n",
 		       gpio, get_label(gpio));
 		local_irq_restore_hw(flags);
 		return -EBUSY;
 	}
 	if (unlikely(reserved_peri_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
 		       gpio, get_label(gpio));
@@ -964,7 +968,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 		printk(KERN_NOTICE "bfin-gpio: GPIO %d is already reserved as gpio-irq!"
 		       " (Documentation/blackfin/bfin-gpio-notes.txt)\n", gpio);
 	}
-#ifndef BF548_FAMILY
+#ifndef CONFIG_BF54x
 	else {	/* Reset POLAR setting when acquiring a gpio for the first time */
 		set_gpio_polar(gpio, 0);
 	}
@@ -993,7 +997,8 @@ void bfin_gpio_free(unsigned gpio)
 	local_irq_save_hw(flags);
 
 	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		gpio_error(gpio);
 		local_irq_restore_hw(flags);
 		return;
@@ -1017,7 +1022,8 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 	local_irq_save_hw(flags);
 
 	if (unlikely(reserved_gpio_irq_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as gpio-irq !\n",
 		       gpio);
@@ -1025,7 +1031,8 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 		return -EBUSY;
 	}
 	if (unlikely(reserved_peri_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
 		       gpio, get_label(gpio));
@@ -1057,7 +1064,8 @@ void bfin_gpio_irq_free(unsigned gpio)
 	local_irq_save_hw(flags);
 
 	if (unlikely(!(reserved_gpio_irq_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
-		dump_stack();
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
 		gpio_error(gpio);
 		local_irq_restore_hw(flags);
 		return;
@@ -1072,7 +1080,7 @@ void bfin_gpio_irq_free(unsigned gpio)
 
 static inline void __bfin_gpio_direction_input(unsigned gpio)
 {
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 	gpio_array[gpio_bank(gpio)]->dir_clear = gpio_bit(gpio);
 #else
 	gpio_array[gpio_bank(gpio)]->dir &= ~gpio_bit(gpio);
@@ -1100,13 +1108,13 @@ EXPORT_SYMBOL(bfin_gpio_direction_input);
 
 void bfin_gpio_irq_prepare(unsigned gpio)
 {
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 	unsigned long flags;
 #endif
 
 	port_setup(gpio, GPIO_USAGE);
 
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 	local_irq_save_hw(flags);
 	__bfin_gpio_direction_input(gpio);
 	local_irq_restore_hw(flags);
@@ -1135,7 +1143,7 @@ int bfin_gpio_direction_output(unsigned gpio, int value)
 
 	gpio_array[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
 	gpio_set_value(gpio, value);
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 	gpio_array[gpio_bank(gpio)]->dir_set = gpio_bit(gpio);
 #else
 	gpio_array[gpio_bank(gpio)]->dir |= gpio_bit(gpio);
@@ -1150,7 +1158,7 @@ EXPORT_SYMBOL(bfin_gpio_direction_output);
 
 int bfin_gpio_get_value(unsigned gpio)
 {
-#ifdef BF548_FAMILY
+#ifdef CONFIG_BF54x
 	return (1 & (gpio_array[gpio_bank(gpio)]->data >> gpio_sub_n(gpio)));
 #else
 	unsigned long flags;
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 4b4341d..27952ae 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -183,6 +183,7 @@ SECTIONS
 		. = ALIGN(4);
 		__etext_l1 = .;
 	}
+	ASSERT (SIZEOF(.text_l1) <= L1_CODE_LENGTH, "L1 text overflow!")
 
 	.data_l1 L1_DATA_A_START : AT(LOADADDR(.text_l1) + SIZEOF(.text_l1))
 	{
@@ -200,6 +201,7 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_l1 = .;
 	}
+	ASSERT (SIZEOF(.data_a_l1) <= L1_DATA_A_LENGTH, "L1 data A overflow!")
 
 	.data_b_l1 L1_DATA_B_START : AT(LOADADDR(.data_l1) + SIZEOF(.data_l1))
 	{
@@ -214,6 +216,7 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_b_l1 = .;
 	}
+	ASSERT (SIZEOF(.data_b_l1) <= L1_DATA_B_LENGTH, "L1 data B overflow!")
 
 	__l2_lma_start = LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1);
 
@@ -239,6 +242,7 @@ SECTIONS
 		. = ALIGN(4);
 		__ebss_l2 = .;
 	}
+	ASSERT (SIZEOF(.text_data_l1) <= L2_LENGTH, "L2 overflow!")
 
 	/* Force trailing alignment of our init section so that when we
 	 * free our init memory, we don't leave behind a partial page.
diff --git a/arch/blackfin/mach-bf518/include/mach/blackfin.h b/arch/blackfin/mach-bf518/include/mach/blackfin.h
index d1a2b9c..267bb7c 100644
--- a/arch/blackfin/mach-bf518/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf518/include/mach/blackfin.h
@@ -32,8 +32,6 @@
 #ifndef _MACH_BLACKFIN_H_
 #define _MACH_BLACKFIN_H_
 
-#define BF518_FAMILY
-
 #include "bf518.h"
 #include "mem_map.h"
 #include "defBF512.h"
diff --git a/arch/blackfin/mach-bf518/include/mach/cdefBF514.h b/arch/blackfin/mach-bf518/include/mach/cdefBF514.h
index 9521e17..dfe492d 100644
--- a/arch/blackfin/mach-bf518/include/mach/cdefBF514.h
+++ b/arch/blackfin/mach-bf518/include/mach/cdefBF514.h
@@ -45,4 +45,71 @@
 
 /* The following are the #defines needed by ADSP-BF514 that are not in the common header */
 
+/* Removable Storage Interface Registers */
+
+#define bfin_read_RSI_PWR_CTL()        bfin_read16(RSI_PWR_CONTROL)
+#define bfin_write_RSI_PWR_CTL(val)    bfin_write16(RSI_PWR_CONTROL, val)
+#define bfin_read_RSI_CLK_CTL()	       bfin_read16(RSI_CLK_CONTROL)
+#define bfin_write_RSI_CLK_CTL(val)    bfin_write16(RSI_CLK_CONTROL, val)
+#define bfin_read_RSI_ARGUMENT()       bfin_read32(RSI_ARGUMENT)
+#define bfin_write_RSI_ARGUMENT(val)   bfin_write32(RSI_ARGUMENT, val)
+#define bfin_read_RSI_COMMAND()        bfin_read16(RSI_COMMAND)
+#define bfin_write_RSI_COMMAND(val)    bfin_write16(RSI_COMMAND, val)
+#define bfin_read_RSI_RESP_CMD()       bfin_read16(RSI_RESP_CMD)
+#define bfin_write_RSI_RESP_CMD(val)   bfin_write16(RSI_RESP_CMD, val)
+#define bfin_read_RSI_RESPONSE0()      bfin_read32(RSI_RESPONSE0)
+#define bfin_write_RSI_RESPONSE0(val)  bfin_write32(RSI_RESPONSE0, val)
+#define bfin_read_RSI_RESPONSE1()      bfin_read32(RSI_RESPONSE1)
+#define bfin_write_RSI_RESPONSE1(val)  bfin_write32(RSI_RESPONSE1, val)
+#define bfin_read_RSI_RESPONSE2()      bfin_read32(RSI_RESPONSE2)
+#define bfin_write_RSI_RESPONSE2(val)  bfin_write32(RSI_RESPONSE2, val)
+#define bfin_read_RSI_RESPONSE3()      bfin_read32(RSI_RESPONSE3)
+#define bfin_write_RSI_RESPONSE3(val)  bfin_write32(RSI_RESPONSE3, val)
+#define bfin_read_RSI_DATA_TIMER()     bfin_read32(RSI_DATA_TIMER)
+#define bfin_write_RSI_DATA_TIMER(val) bfin_write32(RSI_DATA_TIMER, val)
+#define bfin_read_RSI_DATA_LGTH()      bfin_read16(RSI_DATA_LGTH)
+#define bfin_write_RSI_DATA_LGTH(val)  bfin_write16(RSI_DATA_LGTH, val)
+#define bfin_read_RSI_DATA_CTL()       bfin_read16(RSI_DATA_CONTROL)
+#define bfin_write_RSI_DATA_CTL(val)   bfin_write16(RSI_DATA_CONTROL, val)
+#define bfin_read_RSI_DATA_CNT()       bfin_read16(RSI_DATA_CNT)
+#define bfin_write_RSI_DATA_CNT(val)   bfin_write16(RSI_DATA_CNT, val)
+#define bfin_read_RSI_STATUS()         bfin_read32(RSI_STATUS)
+#define bfin_write_RSI_STATUS(val)     bfin_write32(RSI_STATUS, val)
+#define bfin_read_RSI_STATUS_CLR()     bfin_read16(RSI_STATUSCL)
+#define bfin_write_RSI_STATUS_CLR(val) bfin_write16(RSI_STATUSCL, val)
+#define bfin_read_RSI_MASK0()          bfin_read32(RSI_MASK0)
+#define bfin_write_RSI_MASK0(val)      bfin_write32(RSI_MASK0, val)
+#define bfin_read_RSI_MASK1()          bfin_read32(RSI_MASK1)
+#define bfin_write_RSI_MASK1(val)      bfin_write32(RSI_MASK1, val)
+#define bfin_read_RSI_FIFO_CNT()       bfin_read16(RSI_FIFO_CNT)
+#define bfin_write_RSI_FIFO_CNT(val)   bfin_write16(RSI_FIFO_CNT, val)
+#define bfin_read_RSI_CEATA_CTL()      bfin_read16(RSI_CEATA_CONTROL)
+#define bfin_write_RSI_CEATA_CTL(val)  bfin_write16(RSI_CEATA_CONTROL, val)
+#define bfin_read_RSI_FIFO()           bfin_read32(RSI_FIFO)
+#define bfin_write_RSI_FIFO(val)       bfin_write32(RSI_FIFO, val)
+#define bfin_read_RSI_E_STATUS()       bfin_read16(RSI_ESTAT)
+#define bfin_write_RSI_E_STATUS(val)   bfin_write16(RSI_ESTAT, val)
+#define bfin_read_RSI_E_MASK()         bfin_read16(RSI_EMASK)
+#define bfin_write_RSI_E_MASK(val)     bfin_write16(RSI_EMASK, val)
+#define bfin_read_RSI_CFG()            bfin_read16(RSI_CONFIG)
+#define bfin_write_RSI_CFG(val)        bfin_write16(RSI_CONFIG, val)
+#define bfin_read_RSI_RD_WAIT_EN()     bfin_read16(RSI_RD_WAIT_EN)
+#define bfin_write_RSI_RD_WAIT_EN(val) bfin_write16(RSI_RD_WAIT_EN, val)
+#define bfin_read_RSI_PID0()           bfin_read16(RSI_PID0)
+#define bfin_write_RSI_PID0(val)       bfin_write16(RSI_PID0, val)
+#define bfin_read_RSI_PID1()           bfin_read16(RSI_PID1)
+#define bfin_write_RSI_PID1(val)       bfin_write16(RSI_PID1, val)
+#define bfin_read_RSI_PID2()           bfin_read16(RSI_PID2)
+#define bfin_write_RSI_PID2(val)       bfin_write16(RSI_PID2, val)
+#define bfin_read_RSI_PID3()           bfin_read16(RSI_PID3)
+#define bfin_write_RSI_PID3(val)       bfin_write16(RSI_PID3, val)
+#define bfin_read_RSI_PID4()           bfin_read16(RSI_PID4)
+#define bfin_write_RSI_PID4(val)       bfin_write16(RSI_PID4, val)
+#define bfin_read_RSI_PID5()           bfin_read16(RSI_PID5)
+#define bfin_write_RSI_PID5(val)       bfin_write16(RSI_PID5, val)
+#define bfin_read_RSI_PID6()           bfin_read16(RSI_PID6)
+#define bfin_write_RSI_PID6(val)       bfin_write16(RSI_PID6, val)
+#define bfin_read_RSI_PID7()           bfin_read16(RSI_PID7)
+#define bfin_write_RSI_PID7(val)       bfin_write16(RSI_PID7, val)
+
 #endif /* _CDEF_BF514_H */
diff --git a/arch/blackfin/mach-bf518/include/mach/cdefBF516.h b/arch/blackfin/mach-bf518/include/mach/cdefBF516.h
index 4e26ccf..14df43d 100644
--- a/arch/blackfin/mach-bf518/include/mach/cdefBF516.h
+++ b/arch/blackfin/mach-bf518/include/mach/cdefBF516.h
@@ -210,4 +210,71 @@
 #define bfin_read_EMAC_TXC_ABORT()		bfin_read32(EMAC_TXC_ABORT)
 #define bfin_write_EMAC_TXC_ABORT(val)		bfin_write32(EMAC_TXC_ABORT, val)
 
+/* Removable Storage Interface Registers */
+
+#define bfin_read_RSI_PWR_CTL()        bfin_read16(RSI_PWR_CONTROL)
+#define bfin_write_RSI_PWR_CTL(val)    bfin_write16(RSI_PWR_CONTROL, val)
+#define bfin_read_RSI_CLK_CTL()	       bfin_read16(RSI_CLK_CONTROL)
+#define bfin_write_RSI_CLK_CTL(val)    bfin_write16(RSI_CLK_CONTROL, val)
+#define bfin_read_RSI_ARGUMENT()       bfin_read32(RSI_ARGUMENT)
+#define bfin_write_RSI_ARGUMENT(val)   bfin_write32(RSI_ARGUMENT, val)
+#define bfin_read_RSI_COMMAND()        bfin_read16(RSI_COMMAND)
+#define bfin_write_RSI_COMMAND(val)    bfin_write16(RSI_COMMAND, val)
+#define bfin_read_RSI_RESP_CMD()       bfin_read16(RSI_RESP_CMD)
+#define bfin_write_RSI_RESP_CMD(val)   bfin_write16(RSI_RESP_CMD, val)
+#define bfin_read_RSI_RESPONSE0()      bfin_read32(RSI_RESPONSE0)
+#define bfin_write_RSI_RESPONSE0(val)  bfin_write32(RSI_RESPONSE0, val)
+#define bfin_read_RSI_RESPONSE1()      bfin_read32(RSI_RESPONSE1)
+#define bfin_write_RSI_RESPONSE1(val)  bfin_write32(RSI_RESPONSE1, val)
+#define bfin_read_RSI_RESPONSE2()      bfin_read32(RSI_RESPONSE2)
+#define bfin_write_RSI_RESPONSE2(val)  bfin_write32(RSI_RESPONSE2, val)
+#define bfin_read_RSI_RESPONSE3()      bfin_read32(RSI_RESPONSE3)
+#define bfin_write_RSI_RESPONSE3(val)  bfin_write32(RSI_RESPONSE3, val)
+#define bfin_read_RSI_DATA_TIMER()     bfin_read32(RSI_DATA_TIMER)
+#define bfin_write_RSI_DATA_TIMER(val) bfin_write32(RSI_DATA_TIMER, val)
+#define bfin_read_RSI_DATA_LGTH()      bfin_read16(RSI_DATA_LGTH)
+#define bfin_write_RSI_DATA_LGTH(val)  bfin_write16(RSI_DATA_LGTH, val)
+#define bfin_read_RSI_DATA_CTL()       bfin_read16(RSI_DATA_CONTROL)
+#define bfin_write_RSI_DATA_CTL(val)   bfin_write16(RSI_DATA_CONTROL, val)
+#define bfin_read_RSI_DATA_CNT()       bfin_read16(RSI_DATA_CNT)
+#define bfin_write_RSI_DATA_CNT(val)   bfin_write16(RSI_DATA_CNT, val)
+#define bfin_read_RSI_STATUS()         bfin_read32(RSI_STATUS)
+#define bfin_write_RSI_STATUS(val)     bfin_write32(RSI_STATUS, val)
+#define bfin_read_RSI_STATUS_CLR()     bfin_read16(RSI_STATUSCL)
+#define bfin_write_RSI_STATUS_CLR(val) bfin_write16(RSI_STATUSCL, val)
+#define bfin_read_RSI_MASK0()          bfin_read32(RSI_MASK0)
+#define bfin_write_RSI_MASK0(val)      bfin_write32(RSI_MASK0, val)
+#define bfin_read_RSI_MASK1()          bfin_read32(RSI_MASK1)
+#define bfin_write_RSI_MASK1(val)      bfin_write32(RSI_MASK1, val)
+#define bfin_read_RSI_FIFO_CNT()       bfin_read16(RSI_FIFO_CNT)
+#define bfin_write_RSI_FIFO_CNT(val)   bfin_write16(RSI_FIFO_CNT, val)
+#define bfin_read_RSI_CEATA_CTL()      bfin_read16(RSI_CEATA_CONTROL)
+#define bfin_write_RSI_CEATA_CTL(val)  bfin_write16(RSI_CEATA_CONTROL, val)
+#define bfin_read_RSI_FIFO()           bfin_read32(RSI_FIFO)
+#define bfin_write_RSI_FIFO(val)       bfin_write32(RSI_FIFO, val)
+#define bfin_read_RSI_E_STATUS()       bfin_read16(RSI_ESTAT)
+#define bfin_write_RSI_E_STATUS(val)   bfin_write16(RSI_ESTAT, val)
+#define bfin_read_RSI_E_MASK()         bfin_read16(RSI_EMASK)
+#define bfin_write_RSI_E_MASK(val)     bfin_write16(RSI_EMASK, val)
+#define bfin_read_RSI_CFG()            bfin_read16(RSI_CONFIG)
+#define bfin_write_RSI_CFG(val)        bfin_write16(RSI_CONFIG, val)
+#define bfin_read_RSI_RD_WAIT_EN()     bfin_read16(RSI_RD_WAIT_EN)
+#define bfin_write_RSI_RD_WAIT_EN(val) bfin_write16(RSI_RD_WAIT_EN, val)
+#define bfin_read_RSI_PID0()           bfin_read16(RSI_PID0)
+#define bfin_write_RSI_PID0(val)       bfin_write16(RSI_PID0, val)
+#define bfin_read_RSI_PID1()           bfin_read16(RSI_PID1)
+#define bfin_write_RSI_PID1(val)       bfin_write16(RSI_PID1, val)
+#define bfin_read_RSI_PID2()           bfin_read16(RSI_PID2)
+#define bfin_write_RSI_PID2(val)       bfin_write16(RSI_PID2, val)
+#define bfin_read_RSI_PID3()           bfin_read16(RSI_PID3)
+#define bfin_write_RSI_PID3(val)       bfin_write16(RSI_PID3, val)
+#define bfin_read_RSI_PID4()           bfin_read16(RSI_PID4)
+#define bfin_write_RSI_PID4(val)       bfin_write16(RSI_PID4, val)
+#define bfin_read_RSI_PID5()           bfin_read16(RSI_PID5)
+#define bfin_write_RSI_PID5(val)       bfin_write16(RSI_PID5, val)
+#define bfin_read_RSI_PID6()           bfin_read16(RSI_PID6)
+#define bfin_write_RSI_PID6(val)       bfin_write16(RSI_PID6, val)
+#define bfin_read_RSI_PID7()           bfin_read16(RSI_PID7)
+#define bfin_write_RSI_PID7(val)       bfin_write16(RSI_PID7, val)
+
 #endif /* _CDEF_BF516_H */
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF514.h b/arch/blackfin/mach-bf518/include/mach/defBF514.h
index 543f291..56ee5a7 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF514.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF514.h
@@ -110,4 +110,139 @@
 #define RSI_PID6                       0xFFC03FF8 /* RSI Peripheral ID Register 6 */
 #define RSI_PID7                       0xFFC03FFC /* RSI Peripheral ID Register 7 */
 
+/* ********************************************************** */
+/*     SINGLE BIT MACRO PAIRS (bit mask and negated one)      */
+/*     and MULTI BIT READ MACROS                              */
+/* ********************************************************** */
+
+/* Bit masks for SDH_COMMAND */
+
+#define                   CMD_IDX  0x3f       /* Command Index */
+#define                   CMD_RSP  0x40       /* Response */
+#define                 CMD_L_RSP  0x80       /* Long Response */
+#define                 CMD_INT_E  0x100      /* Command Interrupt */
+#define                CMD_PEND_E  0x200      /* Command Pending */
+#define                     CMD_E  0x400      /* Command Enable */
+
+/* Bit masks for SDH_PWR_CTL */
+
+#define                    PWR_ON  0x3        /* Power On */
+#if 0
+#define                       TBD  0x3c       /* TBD */
+#endif
+#define                 SD_CMD_OD  0x40       /* Open Drain Output */
+#define                   ROD_CTL  0x80       /* Rod Control */
+
+/* Bit masks for SDH_CLK_CTL */
+
+#define                    CLKDIV  0xff       /* MC_CLK Divisor */
+#define                     CLK_E  0x100      /* MC_CLK Bus Clock Enable */
+#define                  PWR_SV_E  0x200      /* Power Save Enable */
+#define             CLKDIV_BYPASS  0x400      /* Bypass Divisor */
+#define                  WIDE_BUS  0x800      /* Wide Bus Mode Enable */
+
+/* Bit masks for SDH_RESP_CMD */
+
+#define                  RESP_CMD  0x3f       /* Response Command */
+
+/* Bit masks for SDH_DATA_CTL */
+
+#define                     DTX_E  0x1        /* Data Transfer Enable */
+#define                   DTX_DIR  0x2        /* Data Transfer Direction */
+#define                  DTX_MODE  0x4        /* Data Transfer Mode */
+#define                 DTX_DMA_E  0x8        /* Data Transfer DMA Enable */
+#define              DTX_BLK_LGTH  0xf0       /* Data Transfer Block Length */
+
+/* Bit masks for SDH_STATUS */
+
+#define              CMD_CRC_FAIL  0x1        /* CMD CRC Fail */
+#define              DAT_CRC_FAIL  0x2        /* Data CRC Fail */
+#define               CMD_TIME_OUT  0x4        /* CMD Time Out */
+#define               DAT_TIME_OUT  0x8        /* Data Time Out */
+#define               TX_UNDERRUN  0x10       /* Transmit Underrun */
+#define                RX_OVERRUN  0x20       /* Receive Overrun */
+#define              CMD_RESP_END  0x40       /* CMD Response End */
+#define                  CMD_SENT  0x80       /* CMD Sent */
+#define                   DAT_END  0x100      /* Data End */
+#define             START_BIT_ERR  0x200      /* Start Bit Error */
+#define               DAT_BLK_END  0x400      /* Data Block End */
+#define                   CMD_ACT  0x800      /* CMD Active */
+#define                    TX_ACT  0x1000     /* Transmit Active */
+#define                    RX_ACT  0x2000     /* Receive Active */
+#define              TX_FIFO_STAT  0x4000     /* Transmit FIFO Status */
+#define              RX_FIFO_STAT  0x8000     /* Receive FIFO Status */
+#define              TX_FIFO_FULL  0x10000    /* Transmit FIFO Full */
+#define              RX_FIFO_FULL  0x20000    /* Receive FIFO Full */
+#define              TX_FIFO_ZERO  0x40000    /* Transmit FIFO Empty */
+#define               RX_DAT_ZERO  0x80000    /* Receive FIFO Empty */
+#define                TX_DAT_RDY  0x100000   /* Transmit Data Available */
+#define               RX_FIFO_RDY  0x200000   /* Receive Data Available */
+
+/* Bit masks for SDH_STATUS_CLR */
+
+#define         CMD_CRC_FAIL_STAT  0x1        /* CMD CRC Fail Status */
+#define         DAT_CRC_FAIL_STAT  0x2        /* Data CRC Fail Status */
+#define          CMD_TIMEOUT_STAT  0x4        /* CMD Time Out Status */
+#define          DAT_TIMEOUT_STAT  0x8        /* Data Time Out status */
+#define          TX_UNDERRUN_STAT  0x10       /* Transmit Underrun Status */
+#define           RX_OVERRUN_STAT  0x20       /* Receive Overrun Status */
+#define         CMD_RESP_END_STAT  0x40       /* CMD Response End Status */
+#define             CMD_SENT_STAT  0x80       /* CMD Sent Status */
+#define              DAT_END_STAT  0x100      /* Data End Status */
+#define        START_BIT_ERR_STAT  0x200      /* Start Bit Error Status */
+#define          DAT_BLK_END_STAT  0x400      /* Data Block End Status */
+
+/* Bit masks for SDH_MASK0 */
+
+#define         CMD_CRC_FAIL_MASK  0x1        /* CMD CRC Fail Mask */
+#define         DAT_CRC_FAIL_MASK  0x2        /* Data CRC Fail Mask */
+#define          CMD_TIMEOUT_MASK  0x4        /* CMD Time Out Mask */
+#define          DAT_TIMEOUT_MASK  0x8        /* Data Time Out Mask */
+#define          TX_UNDERRUN_MASK  0x10       /* Transmit Underrun Mask */
+#define           RX_OVERRUN_MASK  0x20       /* Receive Overrun Mask */
+#define         CMD_RESP_END_MASK  0x40       /* CMD Response End Mask */
+#define             CMD_SENT_MASK  0x80       /* CMD Sent Mask */
+#define              DAT_END_MASK  0x100      /* Data End Mask */
+#define        START_BIT_ERR_MASK  0x200      /* Start Bit Error Mask */
+#define          DAT_BLK_END_MASK  0x400      /* Data Block End Mask */
+#define              CMD_ACT_MASK  0x800      /* CMD Active Mask */
+#define               TX_ACT_MASK  0x1000     /* Transmit Active Mask */
+#define               RX_ACT_MASK  0x2000     /* Receive Active Mask */
+#define         TX_FIFO_STAT_MASK  0x4000     /* Transmit FIFO Status Mask */
+#define         RX_FIFO_STAT_MASK  0x8000     /* Receive FIFO Status Mask */
+#define         TX_FIFO_FULL_MASK  0x10000    /* Transmit FIFO Full Mask */
+#define         RX_FIFO_FULL_MASK  0x20000    /* Receive FIFO Full Mask */
+#define         TX_FIFO_ZERO_MASK  0x40000    /* Transmit FIFO Empty Mask */
+#define          RX_DAT_ZERO_MASK  0x80000    /* Receive FIFO Empty Mask */
+#define           TX_DAT_RDY_MASK  0x100000   /* Transmit Data Available Mask */
+#define          RX_FIFO_RDY_MASK  0x200000   /* Receive Data Available Mask */
+
+/* Bit masks for SDH_FIFO_CNT */
+
+#define                FIFO_COUNT  0x7fff     /* FIFO Count */
+
+/* Bit masks for SDH_E_STATUS */
+
+#define              SDIO_INT_DET  0x2        /* SDIO Int Detected */
+#define               SD_CARD_DET  0x10       /* SD Card Detect */
+
+/* Bit masks for SDH_E_MASK */
+
+#define                  SDIO_MSK  0x2        /* Mask SDIO Int Detected */
+#define                   SCD_MSK  0x40       /* Mask Card Detect */
+
+/* Bit masks for SDH_CFG */
+
+#define                   CLKS_EN  0x1        /* Clocks Enable */
+#define                      SD4E  0x4        /* SDIO 4-Bit Enable */
+#define                       MWE  0x8        /* Moving Window Enable */
+#define                    SD_RST  0x10       /* SDMMC Reset */
+#define                 PUP_SDDAT  0x20       /* Pull-up SD_DAT */
+#define                PUP_SDDAT3  0x40       /* Pull-up SD_DAT3 */
+#define                 PD_SDDAT3  0x80       /* Pull-down SD_DAT3 */
+
+/* Bit masks for SDH_RD_WAIT_EN */
+
+#define                       RWR  0x1        /* Read Wait Request */
+
 #endif /* _DEF_BF514_H */
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF516.h b/arch/blackfin/mach-bf518/include/mach/defBF516.h
index 149a269..dfc9384 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF516.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF516.h
@@ -487,4 +487,139 @@
 #define RSI_PID6                       0xFFC03FF8 /* RSI Peripheral ID Register 6 */
 #define RSI_PID7                       0xFFC03FFC /* RSI Peripheral ID Register 7 */
 
+/* ********************************************************** */
+/*     SINGLE BIT MACRO PAIRS (bit mask and negated one)      */
+/*     and MULTI BIT READ MACROS                              */
+/* ********************************************************** */
+
+/* Bit masks for SDH_COMMAND */
+
+#define                   CMD_IDX  0x3f       /* Command Index */
+#define                   CMD_RSP  0x40       /* Response */
+#define                 CMD_L_RSP  0x80       /* Long Response */
+#define                 CMD_INT_E  0x100      /* Command Interrupt */
+#define                CMD_PEND_E  0x200      /* Command Pending */
+#define                     CMD_E  0x400      /* Command Enable */
+
+/* Bit masks for SDH_PWR_CTL */
+
+#define                    PWR_ON  0x3        /* Power On */
+#if 0
+#define                       TBD  0x3c       /* TBD */
+#endif
+#define                 SD_CMD_OD  0x40       /* Open Drain Output */
+#define                   ROD_CTL  0x80       /* Rod Control */
+
+/* Bit masks for SDH_CLK_CTL */
+
+#define                    CLKDIV  0xff       /* MC_CLK Divisor */
+#define                     CLK_E  0x100      /* MC_CLK Bus Clock Enable */
+#define                  PWR_SV_E  0x200      /* Power Save Enable */
+#define             CLKDIV_BYPASS  0x400      /* Bypass Divisor */
+#define                  WIDE_BUS  0x800      /* Wide Bus Mode Enable */
+
+/* Bit masks for SDH_RESP_CMD */
+
+#define                  RESP_CMD  0x3f       /* Response Command */
+
+/* Bit masks for SDH_DATA_CTL */
+
+#define                     DTX_E  0x1        /* Data Transfer Enable */
+#define                   DTX_DIR  0x2        /* Data Transfer Direction */
+#define                  DTX_MODE  0x4        /* Data Transfer Mode */
+#define                 DTX_DMA_E  0x8        /* Data Transfer DMA Enable */
+#define              DTX_BLK_LGTH  0xf0       /* Data Transfer Block Length */
+
+/* Bit masks for SDH_STATUS */
+
+#define              CMD_CRC_FAIL  0x1        /* CMD CRC Fail */
+#define              DAT_CRC_FAIL  0x2        /* Data CRC Fail */
+#define               CMD_TIME_OUT  0x4        /* CMD Time Out */
+#define               DAT_TIME_OUT  0x8        /* Data Time Out */
+#define               TX_UNDERRUN  0x10       /* Transmit Underrun */
+#define                RX_OVERRUN  0x20       /* Receive Overrun */
+#define              CMD_RESP_END  0x40       /* CMD Response End */
+#define                  CMD_SENT  0x80       /* CMD Sent */
+#define                   DAT_END  0x100      /* Data End */
+#define             START_BIT_ERR  0x200      /* Start Bit Error */
+#define               DAT_BLK_END  0x400      /* Data Block End */
+#define                   CMD_ACT  0x800      /* CMD Active */
+#define                    TX_ACT  0x1000     /* Transmit Active */
+#define                    RX_ACT  0x2000     /* Receive Active */
+#define              TX_FIFO_STAT  0x4000     /* Transmit FIFO Status */
+#define              RX_FIFO_STAT  0x8000     /* Receive FIFO Status */
+#define              TX_FIFO_FULL  0x10000    /* Transmit FIFO Full */
+#define              RX_FIFO_FULL  0x20000    /* Receive FIFO Full */
+#define              TX_FIFO_ZERO  0x40000    /* Transmit FIFO Empty */
+#define               RX_DAT_ZERO  0x80000    /* Receive FIFO Empty */
+#define                TX_DAT_RDY  0x100000   /* Transmit Data Available */
+#define               RX_FIFO_RDY  0x200000   /* Receive Data Available */
+
+/* Bit masks for SDH_STATUS_CLR */
+
+#define         CMD_CRC_FAIL_STAT  0x1        /* CMD CRC Fail Status */
+#define         DAT_CRC_FAIL_STAT  0x2        /* Data CRC Fail Status */
+#define          CMD_TIMEOUT_STAT  0x4        /* CMD Time Out Status */
+#define          DAT_TIMEOUT_STAT  0x8        /* Data Time Out status */
+#define          TX_UNDERRUN_STAT  0x10       /* Transmit Underrun Status */
+#define           RX_OVERRUN_STAT  0x20       /* Receive Overrun Status */
+#define         CMD_RESP_END_STAT  0x40       /* CMD Response End Status */
+#define             CMD_SENT_STAT  0x80       /* CMD Sent Status */
+#define              DAT_END_STAT  0x100      /* Data End Status */
+#define        START_BIT_ERR_STAT  0x200      /* Start Bit Error Status */
+#define          DAT_BLK_END_STAT  0x400      /* Data Block End Status */
+
+/* Bit masks for SDH_MASK0 */
+
+#define         CMD_CRC_FAIL_MASK  0x1        /* CMD CRC Fail Mask */
+#define         DAT_CRC_FAIL_MASK  0x2        /* Data CRC Fail Mask */
+#define          CMD_TIMEOUT_MASK  0x4        /* CMD Time Out Mask */
+#define          DAT_TIMEOUT_MASK  0x8        /* Data Time Out Mask */
+#define          TX_UNDERRUN_MASK  0x10       /* Transmit Underrun Mask */
+#define           RX_OVERRUN_MASK  0x20       /* Receive Overrun Mask */
+#define         CMD_RESP_END_MASK  0x40       /* CMD Response End Mask */
+#define             CMD_SENT_MASK  0x80       /* CMD Sent Mask */
+#define              DAT_END_MASK  0x100      /* Data End Mask */
+#define        START_BIT_ERR_MASK  0x200      /* Start Bit Error Mask */
+#define          DAT_BLK_END_MASK  0x400      /* Data Block End Mask */
+#define              CMD_ACT_MASK  0x800      /* CMD Active Mask */
+#define               TX_ACT_MASK  0x1000     /* Transmit Active Mask */
+#define               RX_ACT_MASK  0x2000     /* Receive Active Mask */
+#define         TX_FIFO_STAT_MASK  0x4000     /* Transmit FIFO Status Mask */
+#define         RX_FIFO_STAT_MASK  0x8000     /* Receive FIFO Status Mask */
+#define         TX_FIFO_FULL_MASK  0x10000    /* Transmit FIFO Full Mask */
+#define         RX_FIFO_FULL_MASK  0x20000    /* Receive FIFO Full Mask */
+#define         TX_FIFO_ZERO_MASK  0x40000    /* Transmit FIFO Empty Mask */
+#define          RX_DAT_ZERO_MASK  0x80000    /* Receive FIFO Empty Mask */
+#define           TX_DAT_RDY_MASK  0x100000   /* Transmit Data Available Mask */
+#define          RX_FIFO_RDY_MASK  0x200000   /* Receive Data Available Mask */
+
+/* Bit masks for SDH_FIFO_CNT */
+
+#define                FIFO_COUNT  0x7fff     /* FIFO Count */
+
+/* Bit masks for SDH_E_STATUS */
+
+#define              SDIO_INT_DET  0x2        /* SDIO Int Detected */
+#define               SD_CARD_DET  0x10       /* SD Card Detect */
+
+/* Bit masks for SDH_E_MASK */
+
+#define                  SDIO_MSK  0x2        /* Mask SDIO Int Detected */
+#define                   SCD_MSK  0x40       /* Mask Card Detect */
+
+/* Bit masks for SDH_CFG */
+
+#define                   CLKS_EN  0x1        /* Clocks Enable */
+#define                      SD4E  0x4        /* SDIO 4-Bit Enable */
+#define                       MWE  0x8        /* Moving Window Enable */
+#define                    SD_RST  0x10       /* SDMMC Reset */
+#define                 PUP_SDDAT  0x20       /* Pull-up SD_DAT */
+#define                PUP_SDDAT3  0x40       /* Pull-up SD_DAT3 */
+#define                 PD_SDDAT3  0x80       /* Pull-down SD_DAT3 */
+
+/* Bit masks for SDH_RD_WAIT_EN */
+
+#define                       RWR  0x1        /* Read Wait Request */
+
 #endif /* _DEF_BF516_H */
diff --git a/arch/blackfin/mach-bf527/include/mach/blackfin.h b/arch/blackfin/mach-bf527/include/mach/blackfin.h
index 297821e..417abcd 100644
--- a/arch/blackfin/mach-bf527/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf527/include/mach/blackfin.h
@@ -32,8 +32,6 @@
 #ifndef _MACH_BLACKFIN_H_
 #define _MACH_BLACKFIN_H_
 
-#define BF527_FAMILY
-
 #include "bf527.h"
 #include "mem_map.h"
 #include "defBF522.h"
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index cd04c5e..0572926 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -843,6 +843,71 @@ static struct platform_device bfin_spi0_device = {
 };
 #endif  /* spi master and devices */
 
+#if defined(CONFIG_SPI_BFIN_SPORT) || defined(CONFIG_SPI_BFIN_SPORT_MODULE)
+
+/* SPORT SPI controller data */
+static struct bfin5xx_spi_master bfin_sport_spi0_info = {
+	.num_chipselect = 1, /* master only supports one device */
+	.enable_dma = 0,  /* master don't support DMA */
+	.pin_req = {P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_DRPRI,
+		P_SPORT0_RSCLK, P_SPORT0_TFS, P_SPORT0_RFS, 0},
+};
+
+static struct resource bfin_sport_spi0_resource[] = {
+	[0] = {
+		.start = SPORT0_TCR1,
+		.end   = SPORT0_TCR1 + 0xFF,
+		.flags = IORESOURCE_MEM,
+		},
+	[1] = {
+		.start = IRQ_SPORT0_ERROR,
+		.end   = IRQ_SPORT0_ERROR,
+		.flags = IORESOURCE_IRQ,
+		},
+};
+
+static struct platform_device bfin_sport_spi0_device = {
+	.name = "bfin-sport-spi",
+	.id = 1, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_sport_spi0_resource),
+	.resource = bfin_sport_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_sport_spi0_info, /* Passed to driver */
+	},
+};
+
+static struct bfin5xx_spi_master bfin_sport_spi1_info = {
+	.num_chipselect = 1, /* master only supports one device */
+	.enable_dma = 0,  /* master don't support DMA */
+	.pin_req = {P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_DRPRI,
+		P_SPORT1_RSCLK, P_SPORT1_TFS, P_SPORT1_RFS, 0},
+};
+
+static struct resource bfin_sport_spi1_resource[] = {
+	[0] = {
+		.start = SPORT1_TCR1,
+		.end   = SPORT1_TCR1 + 0xFF,
+		.flags = IORESOURCE_MEM,
+		},
+	[1] = {
+		.start = IRQ_SPORT1_ERROR,
+		.end   = IRQ_SPORT1_ERROR,
+		.flags = IORESOURCE_IRQ,
+		},
+};
+
+static struct platform_device bfin_sport_spi1_device = {
+	.name = "bfin-sport-spi",
+	.id = 2, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_sport_spi1_resource),
+	.resource = bfin_sport_spi1_resource,
+	.dev = {
+		.platform_data = &bfin_sport_spi1_info, /* Passed to driver */
+	},
+};
+
+#endif  /* sport spi master and devices */
+
 #if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
 static struct platform_device bfin_fb_device = {
 	.name = "bf537-lq035",
@@ -1073,6 +1138,141 @@ static struct adp5588_kpad_platform_data adp5588_kpad_data = {
 };
 #endif
 
+#if defined(CONFIG_PMIC_ADP5520) || defined(CONFIG_PMIC_ADP5520_MODULE)
+#include <linux/mfd/adp5520.h>
+
+	/*
+	 *  ADP5520/5501 Backlight Data
+	 */
+
+static struct adp5520_backlight_platfrom_data adp5520_backlight_data = {
+	.fade_in 		= FADE_T_1200ms,
+	.fade_out 		= FADE_T_1200ms,
+	.fade_led_law 		= BL_LAW_LINEAR,
+	.en_ambl_sens 		= 1,
+	.abml_filt 		= BL_AMBL_FILT_640ms,
+	.l1_daylight_max 	= BL_CUR_mA(15),
+	.l1_daylight_dim 	= BL_CUR_mA(0),
+	.l2_office_max 		= BL_CUR_mA(7),
+	.l2_office_dim 		= BL_CUR_mA(0),
+	.l3_dark_max 		= BL_CUR_mA(3),
+	.l3_dark_dim 		= BL_CUR_mA(0),
+	.l2_trip 		= L2_COMP_CURR_uA(700),
+	.l2_hyst 		= L2_COMP_CURR_uA(50),
+	.l3_trip 		= L3_COMP_CURR_uA(80),
+	.l3_hyst 		= L3_COMP_CURR_uA(20),
+};
+
+	/*
+	 *  ADP5520/5501 LEDs Data
+	 */
+
+#include <linux/leds.h>
+
+static struct led_info adp5520_leds[] = {
+	{
+		.name = "adp5520-led1",
+		.default_trigger = "none",
+		.flags = FLAG_ID_ADP5520_LED1_ADP5501_LED0 | LED_OFFT_600ms,
+	},
+#ifdef ADP5520_EN_ALL_LEDS
+	{
+		.name = "adp5520-led2",
+		.default_trigger = "none",
+		.flags = FLAG_ID_ADP5520_LED2_ADP5501_LED1,
+	},
+	{
+		.name = "adp5520-led3",
+		.default_trigger = "none",
+		.flags = FLAG_ID_ADP5520_LED3_ADP5501_LED2,
+	},
+#endif
+};
+
+static struct adp5520_leds_platfrom_data adp5520_leds_data = {
+	.num_leds = ARRAY_SIZE(adp5520_leds),
+	.leds = adp5520_leds,
+	.fade_in = FADE_T_600ms,
+	.fade_out = FADE_T_600ms,
+	.led_on_time = LED_ONT_600ms,
+};
+
+	/*
+	 *  ADP5520 GPIO Data
+	 */
+
+static struct adp5520_gpio_platfrom_data adp5520_gpio_data = {
+	.gpio_start = 50,
+	.gpio_en_mask = GPIO_C1 | GPIO_C2 | GPIO_R2,
+	.gpio_pullup_mask = GPIO_C1 | GPIO_C2 | GPIO_R2,
+};
+
+	/*
+	 *  ADP5520 Keypad Data
+	 */
+
+#include <linux/input.h>
+static const unsigned short adp5520_keymap[ADP5520_KEYMAPSIZE] = {
+	[KEY(0, 0)]	= KEY_GRAVE,
+	[KEY(0, 1)]	= KEY_1,
+	[KEY(0, 2)]	= KEY_2,
+	[KEY(0, 3)]	= KEY_3,
+	[KEY(1, 0)]	= KEY_4,
+	[KEY(1, 1)]	= KEY_5,
+	[KEY(1, 2)]	= KEY_6,
+	[KEY(1, 3)]	= KEY_7,
+	[KEY(2, 0)]	= KEY_8,
+	[KEY(2, 1)]	= KEY_9,
+	[KEY(2, 2)]	= KEY_0,
+	[KEY(2, 3)]	= KEY_MINUS,
+	[KEY(3, 0)]	= KEY_EQUAL,
+	[KEY(3, 1)]	= KEY_BACKSLASH,
+	[KEY(3, 2)]	= KEY_BACKSPACE,
+	[KEY(3, 3)]	= KEY_ENTER,
+};
+
+static struct adp5520_keys_platfrom_data adp5520_keys_data = {
+	.rows_en_mask	= ROW_R3 | ROW_R2 | ROW_R1 | ROW_R0,
+	.cols_en_mask	= COL_C3 | COL_C2 | COL_C1 | COL_C0,
+	.keymap		= adp5520_keymap,
+	.keymapsize	= ARRAY_SIZE(adp5520_keymap),
+	.repeat		= 0,
+};
+
+	/*
+	 *  ADP5520/5501 Multifuction Device Init Data
+	 */
+
+static struct adp5520_subdev_info adp5520_subdevs[] = {
+	{
+		.name = "adp5520-backlight",
+		.id = ID_ADP5520,
+		.platform_data = &adp5520_backlight_data,
+	},
+	{
+		.name = "adp5520-led",
+		.id = ID_ADP5520,
+		.platform_data = &adp5520_leds_data,
+	},
+	{
+		.name = "adp5520-gpio",
+		.id = ID_ADP5520,
+		.platform_data = &adp5520_gpio_data,
+	},
+	{
+		.name = "adp5520-keys",
+		.id = ID_ADP5520,
+		.platform_data = &adp5520_keys_data,
+	},
+};
+
+static struct adp5520_platform_data adp5520_pdev_data = {
+	.num_subdevs = ARRAY_SIZE(adp5520_subdevs),
+	.subdevs = adp5520_subdevs,
+};
+
+#endif
+
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 #if defined(CONFIG_JOYSTICK_AD7142) || defined(CONFIG_JOYSTICK_AD7142_MODULE)
 	{
@@ -1105,6 +1305,13 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.platform_data = (void *)&adp5588_kpad_data,
 	},
 #endif
+#if defined(CONFIG_PMIC_ADP5520) || defined(CONFIG_PMIC_ADP5520_MODULE)
+	{
+		I2C_BOARD_INFO("pmic-adp5520", 0x32),
+		.irq = IRQ_PF7,
+		.platform_data = (void *)&adp5520_pdev_data,
+	},
+#endif
 };
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
@@ -1120,8 +1327,11 @@ static struct platform_device bfin_sport1_uart_device = {
 #endif
 
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	IRQ_PF5
+#define CF_IDE_NAND_CARD_USE_HDD_INTERFACE
+/* #define CF_IDE_NAND_CARD_USE_CF_IN_COMMON_MEMORY_MODE */
 
+#ifdef CF_IDE_NAND_CARD_USE_HDD_INTERFACE
+#define PATA_INT	IRQ_PF5
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 1,
 	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
@@ -1144,6 +1354,24 @@ static struct resource bfin_pata_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 };
+#elif defined(CF_IDE_NAND_CARD_USE_CF_IN_COMMON_MEMORY_MODE)
+static struct pata_platform_info bfin_pata_platform_data = {
+	.ioport_shift = 0,
+};
+
+static struct resource bfin_pata_resources[] = {
+	{
+		.start = 0x20211820,
+		.end = 0x2021183F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0x2021181C,
+		.end = 0x2021181F,
+		.flags = IORESOURCE_MEM,
+	},
+};
+#endif
 
 static struct platform_device bfin_pata_device = {
 	.name = "pata_platform",
@@ -1232,6 +1460,11 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_spi0_device,
 #endif
 
+#if defined(CONFIG_SPI_BFIN_SPORT) || defined(CONFIG_SPI_BFIN_SPORT_MODULE)
+	&bfin_sport_spi0_device,
+	&bfin_sport_spi1_device,
+#endif
+
 #if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
 	&bfin_fb_device,
 #endif
diff --git a/arch/blackfin/mach-bf548/include/mach/blackfin.h b/arch/blackfin/mach-bf548/include/mach/blackfin.h
index 0c0e3e2..cf6c150 100644
--- a/arch/blackfin/mach-bf548/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf548/include/mach/blackfin.h
@@ -32,8 +32,6 @@
 #ifndef _MACH_BLACKFIN_H_
 #define _MACH_BLACKFIN_H_
 
-#define BF548_FAMILY
-
 #include "bf548.h"
 #include "mem_map.h"
 #include "anomaly.h"
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index f48a6ae..bce5a84 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -287,7 +287,7 @@ int bfin_pm_suspend_mem_enter(void)
 static int bfin_pm_valid(suspend_state_t state)
 {
 	return (state == PM_SUSPEND_STANDBY
-#ifndef BF533_FAMILY
+#if !(defined(BF533_FAMILY) || defined(CONFIG_BF561))
 	/*
 	 * On BF533/2/1:
 	 * If we enter Hibernate the SCKE Pin is driven Low,

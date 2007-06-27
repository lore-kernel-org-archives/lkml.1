Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbXF0U7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbXF0U7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbXF0U7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:59:46 -0400
Received: from mail.trixing.net ([87.230.125.58]:54248 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbXF0U7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:59:45 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 16:59:44 EDT
Message-ID: <4682CA8A.7070906@l4x.org>
Date: Wed, 27 Jun 2007 22:37:30 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: paulus@samba.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706262359.l5QNxAri010968@hera.kernel.org>
In-Reply-To: <200706262359.l5QNxAri010968@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [POWERPC] Update defconfigs
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ca74c013441200b162f6a384b23b833d1865a9e8
> Commit:     ca74c013441200b162f6a384b23b833d1865a9e8
> Parent:     d30d6badd1769a00bc5a800b8af4e8b3f169c633
> Author:     Paul Mackerras <paulus@samba.org>
> AuthorDate: Tue Jun 26 14:19:35 2007 +1000
> Committer:  Paul Mackerras <paulus@samba.org>
> CommitDate: Tue Jun 26 14:38:47 2007 +1000
> 
>     [POWERPC] Update defconfigs
>     
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/configs/cell_defconfig        |  243 +++++++---------

Regression from -rc6, cell_defconfig does not build anymore:

  Building modules, stage 2.
  MODPOST 135 modules
ERROR: ".pmi_send_message" [arch/powerpc/platforms/cell/cbe_cpufreq.ko]
undefined!
ERROR: ".pmi_unregister_handler"
[arch/powerpc/platforms/cell/cbe_cpufreq.ko] undefined!
ERROR: ".pmi_register_handler"
[arch/powerpc/platforms/cell/cbe_cpufreq.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [_all] Error 2

I've left the relevant diff attached.

Jan

> diff --git a/arch/powerpc/configs/cell_defconfig b/arch/powerpc/configs/cell_defconfig
> index 02c428a..74f83f4 100644
> --- a/arch/powerpc/configs/cell_defconfig
> +++ b/arch/powerpc/configs/cell_defconfig
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
> -# Linux kernel version: 2.6.21-rc6
> -# Mon Apr 23 20:46:48 2007
> +# Linux kernel version: 2.6.22-rc6
> +# Tue Jun 26 12:32:34 2007
>  #
>  CONFIG_PPC64=y
>  CONFIG_64BIT=y
> @@ -41,6 +41,7 @@ CONFIG_PPC_DCR=y
>  CONFIG_PPC_OF_PLATFORM_PCI=y
>  CONFIG_ALTIVEC=y
>  CONFIG_PPC_STD_MMU=y
> +CONFIG_PPC_MM_SLICES=y
>  CONFIG_VIRT_CPU_ACCOUNTING=y
>  CONFIG_SMP=y
>  CONFIG_NR_CPUS=4
> @@ -69,6 +70,7 @@ CONFIG_SYSVIPC_SYSCTL=y
>  # CONFIG_AUDIT is not set
>  CONFIG_IKCONFIG=y
>  CONFIG_IKCONFIG_PROC=y
> +CONFIG_LOG_BUF_SHIFT=15
>  CONFIG_CPUSETS=y
>  CONFIG_SYSFS_DEPRECATED=y
>  # CONFIG_RELAY is not set
> @@ -87,14 +89,19 @@ CONFIG_BUG=y
>  CONFIG_ELF_CORE=y
>  CONFIG_BASE_FULL=y
>  CONFIG_FUTEX=y
> +CONFIG_ANON_INODES=y
>  CONFIG_EPOLL=y
> +CONFIG_SIGNALFD=y
> +CONFIG_TIMERFD=y
> +CONFIG_EVENTFD=y
>  CONFIG_SHMEM=y
> -CONFIG_SLAB=y
>  CONFIG_VM_EVENT_COUNTERS=y
> +CONFIG_SLAB=y
> +# CONFIG_SLUB is not set
> +# CONFIG_SLOB is not set
>  CONFIG_RT_MUTEXES=y
>  # CONFIG_TINY_SHMEM is not set
>  CONFIG_BASE_SMALL=0
> -# CONFIG_SLOB is not set
>  
>  #
>  # Loadable module support
> @@ -163,9 +170,14 @@ CONFIG_SPU_FS=m
>  CONFIG_SPU_BASE=y
>  CONFIG_CBE_RAS=y
>  CONFIG_CBE_THERM=m
> +CONFIG_CBE_CPUFREQ=m
> +# CONFIG_PQ2ADS is not set
>  CONFIG_PPC_NATIVE=y
>  CONFIG_UDBG_RTAS_CONSOLE=y
>  CONFIG_PPC_UDBG_BEAT=y
> +CONFIG_MPIC=y
> +# CONFIG_MPIC_WEIRD is not set
> +# CONFIG_PPC_I8259 is not set
>  # CONFIG_U3_DART is not set
>  CONFIG_PPC_RTAS=y
>  # CONFIG_RTAS_ERROR_LOGGING is not set
> @@ -177,9 +189,23 @@ CONFIG_MMIO_NVRAM=y
>  # CONFIG_PPC_970_NAP is not set
>  CONFIG_PPC_INDIRECT_IO=y
>  CONFIG_GENERIC_IOMAP=y
> -# CONFIG_CPU_FREQ_PMAC64 is not set
> -# CONFIG_WANT_EARLY_SERIAL is not set
> -CONFIG_MPIC=y
> +CONFIG_CPU_FREQ=y
> +CONFIG_CPU_FREQ_TABLE=y
> +# CONFIG_CPU_FREQ_DEBUG is not set
> +CONFIG_CPU_FREQ_STAT=y
> +# CONFIG_CPU_FREQ_STAT_DETAILS is not set
> +CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> +# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> +CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> +CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> +CONFIG_CPU_FREQ_GOV_USERSPACE=y
> +CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> +CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> +
> +#
> +# CPU Frequency drivers
> +#
> +# CONFIG_CPM2 is not set
>  
>  #
>  # Kernel options
> @@ -224,12 +250,14 @@ CONFIG_RESOURCES_64BIT=y
>  CONFIG_ZONE_DMA_FLAG=1
>  CONFIG_ARCH_MEMORY_PROBE=y
>  CONFIG_NODES_SPAN_OTHER_NODES=y
> +CONFIG_PPC_HAS_HASH_64K=y
>  CONFIG_PPC_64K_PAGES=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_PROC_DEVICETREE=y
>  # CONFIG_CMDLINE_BOOL is not set
>  # CONFIG_PM is not set
>  CONFIG_SECCOMP=y
> +# CONFIG_WANT_DEVICE_TREE is not set
>  CONFIG_ISA_DMA_API=y
>  
>  #
> @@ -237,22 +265,18 @@ CONFIG_ISA_DMA_API=y
>  #
>  CONFIG_ZONE_DMA=y
>  CONFIG_GENERIC_ISA_DMA=y
> -# CONFIG_MPIC_WEIRD is not set
> -# CONFIG_PPC_I8259 is not set
>  # CONFIG_PPC_INDIRECT_PCI is not set
>  CONFIG_PCI=y
>  CONFIG_PCI_DOMAINS=y
>  CONFIG_PCIEPORTBUS=y
> +CONFIG_ARCH_SUPPORTS_MSI=y
> +# CONFIG_PCI_MSI is not set
>  # CONFIG_PCI_DEBUG is not set
>  
>  #
>  # PCCARD (PCMCIA/CardBus) support
>  #
>  # CONFIG_PCCARD is not set
> -
> -#
> -# PCI Hotplug Support
> -#
>  # CONFIG_HOTPLUG_PCI is not set
>  CONFIG_KERNEL_START=0xc000000000000000
>  
> @@ -264,7 +288,6 @@ CONFIG_NET=y
>  #
>  # Networking options
>  #
> -# CONFIG_NETDEBUG is not set
>  CONFIG_PACKET=y
>  # CONFIG_PACKET_MMAP is not set
>  CONFIG_UNIX=y
> @@ -300,14 +323,11 @@ CONFIG_INET_TCP_DIAG=y
>  CONFIG_TCP_CONG_CUBIC=y
>  CONFIG_DEFAULT_TCP_CONG="cubic"
>  # CONFIG_TCP_MD5SIG is not set
> -
> -#
> -# IP: Virtual Server Configuration
> -#
>  # CONFIG_IP_VS is not set
>  CONFIG_IPV6=y
>  # CONFIG_IPV6_PRIVACY is not set
>  # CONFIG_IPV6_ROUTER_PREF is not set
> +# CONFIG_IPV6_OPTIMISTIC_DAD is not set
>  CONFIG_INET6_AH=m
>  CONFIG_INET6_ESP=m
>  CONFIG_INET6_IPCOMP=m
> @@ -332,6 +352,7 @@ CONFIG_NETFILTER_NETLINK=m
>  CONFIG_NETFILTER_NETLINK_QUEUE=m
>  CONFIG_NETFILTER_NETLINK_LOG=m
>  # CONFIG_NF_CONNTRACK_ENABLED is not set
> +# CONFIG_NF_CONNTRACK is not set
>  CONFIG_NETFILTER_XTABLES=m
>  CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
>  CONFIG_NETFILTER_XT_TARGET_DSCP=m
> @@ -389,20 +410,8 @@ CONFIG_IP_NF_ARP_MANGLE=m
>  #
>  # CONFIG_IP6_NF_QUEUE is not set
>  # CONFIG_IP6_NF_IPTABLES is not set
> -
> -#
> -# DCCP Configuration (EXPERIMENTAL)
> -#
>  # CONFIG_IP_DCCP is not set
> -
> -#
> -# SCTP Configuration (EXPERIMENTAL)
> -#
>  # CONFIG_IP_SCTP is not set
> -
> -#
> -# TIPC Configuration (EXPERIMENTAL)
> -#
>  # CONFIG_TIPC is not set
>  # CONFIG_ATM is not set
>  # CONFIG_BRIDGE is not set
> @@ -429,7 +438,16 @@ CONFIG_NET_CLS_ROUTE=y
>  # CONFIG_HAMRADIO is not set
>  # CONFIG_IRDA is not set
>  # CONFIG_BT is not set
> +# CONFIG_AF_RXRPC is not set
> +
> +#
> +# Wireless
> +#
> +# CONFIG_CFG80211 is not set
> +# CONFIG_WIRELESS_EXT is not set
> +# CONFIG_MAC80211 is not set
>  # CONFIG_IEEE80211 is not set
> +# CONFIG_RFKILL is not set
>  
>  #
>  # Device Drivers
> @@ -449,10 +467,6 @@ CONFIG_FW_LOADER=y
>  # Connector - unified userspace <-> kernelspace linker
>  #
>  # CONFIG_CONNECTOR is not set
> -
> -#
> -# Memory Technology Devices (MTD)
> -#
>  # CONFIG_MTD is not set
>  
>  #
> @@ -489,12 +503,10 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
>  #
>  # Misc devices
>  #
> +# CONFIG_PHANTOM is not set
>  # CONFIG_SGI_IOC4 is not set
>  # CONFIG_TIFM_CORE is not set
> -
> -#
> -# ATA/ATAPI/MFM/RLL support
> -#
> +# CONFIG_BLINK is not set
>  CONFIG_IDE=y
>  CONFIG_BLK_DEV_IDE=y
>  
> @@ -509,6 +521,7 @@ CONFIG_IDEDISK_MULTI_MODE=y
>  # CONFIG_BLK_DEV_IDEFLOPPY is not set
>  # CONFIG_BLK_DEV_IDESCSI is not set
>  # CONFIG_IDE_TASK_IOCTL is not set
> +CONFIG_IDE_PROC_FS=y
>  
>  #
>  # IDE chipset support/bugfixes
> @@ -516,6 +529,7 @@ CONFIG_IDEDISK_MULTI_MODE=y
>  CONFIG_IDE_GENERIC=y
>  CONFIG_BLK_DEV_IDEPCI=y
>  CONFIG_IDEPCI_SHARE_IRQ=y
> +CONFIG_IDEPCI_PCIBUS_ORDER=y
>  # CONFIG_BLK_DEV_OFFBOARD is not set
>  CONFIG_BLK_DEV_GENERIC=y
>  # CONFIG_BLK_DEV_OPTI621 is not set
> @@ -580,6 +594,7 @@ CONFIG_CHR_DEV_SG=y
>  # CONFIG_SCSI_CONSTANTS is not set
>  # CONFIG_SCSI_LOGGING is not set
>  # CONFIG_SCSI_SCAN_ASYNC is not set
> +CONFIG_SCSI_WAIT_SCAN=m
>  
>  #
>  # SCSI Transports
> @@ -626,10 +641,6 @@ CONFIG_SCSI_SAS_ATTRS=y
>  # CONFIG_SCSI_DC390T is not set
>  # CONFIG_SCSI_DEBUG is not set
>  # CONFIG_SCSI_SRP is not set
> -
> -#
> -# Serial ATA (prod) and Parallel ATA (experimental) drivers
> -#
>  CONFIG_ATA=y
>  # CONFIG_ATA_NONSTANDARD is not set
>  # CONFIG_SATA_AHCI is not set
> @@ -652,6 +663,7 @@ CONFIG_SATA_PROMISE=y
>  # CONFIG_PATA_AMD is not set
>  # CONFIG_PATA_ARTOP is not set
>  # CONFIG_PATA_ATIIXP is not set
> +# CONFIG_PATA_CMD640_PCI is not set
>  # CONFIG_PATA_CMD64X is not set
>  # CONFIG_PATA_CS5520 is not set
>  # CONFIG_PATA_CS5530 is not set
> @@ -705,6 +717,7 @@ CONFIG_DM_MIRROR=m
>  CONFIG_DM_ZERO=m
>  CONFIG_DM_MULTIPATH=m
>  # CONFIG_DM_MULTIPATH_EMC is not set
> +# CONFIG_DM_DELAY is not set
>  
>  #
>  # Fusion MPT device support
> @@ -719,18 +732,14 @@ CONFIG_FUSION_MAX_SGE=128
>  #
>  # IEEE 1394 (FireWire) support
>  #
> +# CONFIG_FIREWIRE is not set
>  # CONFIG_IEEE1394 is not set
>  
>  #
>  # I2O device support
>  #
>  # CONFIG_I2O is not set
> -
> -#
> -# Macintosh device drivers
> -#
> -# CONFIG_MAC_EMUMOUSEBTN is not set
> -# CONFIG_WINDFARM is not set
> +# CONFIG_MACINTOSH_DRIVERS is not set
>  
>  #
>  # Network device support
> @@ -740,15 +749,7 @@ CONFIG_NETDEVICES=y
>  CONFIG_BONDING=m
>  # CONFIG_EQUALIZER is not set
>  CONFIG_TUN=y
> -
> -#
> -# ARCnet devices
> -#
>  # CONFIG_ARCNET is not set
> -
> -#
> -# PHY device support
> -#
>  # CONFIG_PHYLIB is not set
>  
>  #
> @@ -767,10 +768,7 @@ CONFIG_MII=y
>  # CONFIG_NET_TULIP is not set
>  # CONFIG_HP100 is not set
>  # CONFIG_NET_PCI is not set
> -
> -#
> -# Ethernet (1000 Mbit)
> -#
> +CONFIG_NETDEV_1000=y
>  # CONFIG_ACENIC is not set
>  # CONFIG_DL2K is not set
>  CONFIG_E1000=m
> @@ -784,15 +782,13 @@ CONFIG_E1000_NAPI=y
>  CONFIG_SKGE=m
>  CONFIG_SKY2=m
>  # CONFIG_SK98LIN is not set
> +# CONFIG_VIA_VELOCITY is not set
>  CONFIG_TIGON3=y
>  # CONFIG_BNX2 is not set
>  CONFIG_SPIDER_NET=y
>  # CONFIG_QLA3XXX is not set
>  # CONFIG_ATL1 is not set
> -
> -#
> -# Ethernet (10000 Mbit)
> -#
> +CONFIG_NETDEV_10000=y
>  # CONFIG_CHELSIO_T1 is not set
>  # CONFIG_CHELSIO_T3 is not set
>  # CONFIG_IXGB is not set
> @@ -800,20 +796,24 @@ CONFIG_SPIDER_NET=y
>  # CONFIG_MYRI10GE is not set
>  # CONFIG_NETXEN_NIC is not set
>  # CONFIG_PASEMI_MAC is not set
> -
> -#
> -# Token Ring devices
> -#
> +# CONFIG_MLX4_CORE is not set
>  # CONFIG_TR is not set
>  
>  #
> -# Wireless LAN (non-hamradio)
> +# Wireless LAN
>  #
> -# CONFIG_NET_RADIO is not set
> +# CONFIG_WLAN_PRE80211 is not set
> +# CONFIG_WLAN_80211 is not set
>  
>  #
> -# Wan interfaces
> +# USB Network Adapters
>  #
> +# CONFIG_USB_CATC is not set
> +# CONFIG_USB_KAWETH is not set
> +# CONFIG_USB_PEGASUS is not set
> +# CONFIG_USB_RTL8150 is not set
> +# CONFIG_USB_USBNET_MII is not set
> +# CONFIG_USB_USBNET is not set
>  # CONFIG_WAN is not set
>  # CONFIG_FDDI is not set
>  # CONFIG_HIPPI is not set
> @@ -840,6 +840,7 @@ CONFIG_SPIDER_NET=y
>  #
>  CONFIG_INPUT=y
>  # CONFIG_INPUT_FF_MEMLESS is not set
> +# CONFIG_INPUT_POLLDEV is not set
>  
>  #
>  # Userland interfaces
> @@ -859,6 +860,7 @@ CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
>  # CONFIG_INPUT_KEYBOARD is not set
>  # CONFIG_INPUT_MOUSE is not set
>  # CONFIG_INPUT_JOYSTICK is not set
> +# CONFIG_INPUT_TABLET is not set
>  # CONFIG_INPUT_TOUCHSCREEN is not set
>  # CONFIG_INPUT_MISC is not set
>  
> @@ -933,10 +935,6 @@ CONFIG_IPMI_DEVICE_INTERFACE=m
>  CONFIG_IPMI_SI=m
>  CONFIG_IPMI_WATCHDOG=m
>  CONFIG_IPMI_POWEROFF=m
> -
> -#
> -# Watchdog Cards
> -#
>  CONFIG_WATCHDOG=y
>  # CONFIG_WATCHDOG_NOWAYOUT is not set
>  
> @@ -959,7 +957,6 @@ CONFIG_WATCHDOG=y
>  # CONFIG_HW_RANDOM is not set
>  CONFIG_GEN_RTC=y
>  # CONFIG_GEN_RTC_X is not set
> -# CONFIG_DTLK is not set
>  # CONFIG_R3964 is not set
>  # CONFIG_APPLICOM is not set
>  # CONFIG_AGP is not set
> @@ -971,11 +968,9 @@ CONFIG_GEN_RTC=y
>  # TPM devices
>  #
>  # CONFIG_TCG_TPM is not set
> -
> -#
> -# I2C support
> -#
> +CONFIG_DEVPORT=y
>  CONFIG_I2C=y
> +CONFIG_I2C_BOARDINFO=y
>  # CONFIG_I2C_CHARDEV is not set
>  
>  #
> @@ -999,17 +994,17 @@ CONFIG_I2C_ALGOBIT=y
>  # CONFIG_I2C_NFORCE2 is not set
>  # CONFIG_I2C_OCORES is not set
>  # CONFIG_I2C_PARPORT_LIGHT is not set
> -# CONFIG_I2C_PASEMI is not set
>  # CONFIG_I2C_PROSAVAGE is not set
>  # CONFIG_I2C_SAVAGE4 is not set
> +# CONFIG_I2C_SIMTEC is not set
>  # CONFIG_I2C_SIS5595 is not set
>  # CONFIG_I2C_SIS630 is not set
>  # CONFIG_I2C_SIS96X is not set
>  # CONFIG_I2C_STUB is not set
> +# CONFIG_I2C_TINY_USB is not set
>  # CONFIG_I2C_VIA is not set
>  # CONFIG_I2C_VIAPRO is not set
>  # CONFIG_I2C_VOODOO3 is not set
> -# CONFIG_I2C_PCA_ISA is not set
>  
>  #
>  # Miscellaneous I2C Chip support
> @@ -1036,12 +1031,7 @@ CONFIG_I2C_ALGOBIT=y
>  # Dallas's 1-wire bus
>  #
>  # CONFIG_W1 is not set
> -
> -#
> -# Hardware Monitoring support
> -#
>  # CONFIG_HWMON is not set
> -# CONFIG_HWMON_VID is not set
>  
>  #
>  # Multifunction device drivers
> @@ -1052,17 +1042,19 @@ CONFIG_I2C_ALGOBIT=y
>  # Multimedia devices
>  #
>  # CONFIG_VIDEO_DEV is not set
> +# CONFIG_DVB_CORE is not set
> +# CONFIG_DAB is not set
>  
>  #
> -# Digital Video Broadcasting Devices
> +# Graphics support
>  #
> -# CONFIG_DVB is not set
> -# CONFIG_USB_DABUSB is not set
> +# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>  
>  #
> -# Graphics support
> +# Display device support
>  #
> -# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> +# CONFIG_DISPLAY_SUPPORT is not set
> +# CONFIG_VGASTATE is not set
>  # CONFIG_FB is not set
>  # CONFIG_FB_IBM_GXT4500 is not set
>  
> @@ -1084,6 +1076,17 @@ CONFIG_HID=m
>  # CONFIG_HID_DEBUG is not set
>  
>  #
> +# USB Input Devices
> +#
> +# CONFIG_USB_HID is not set
> +
> +#
> +# USB HID Boot Protocol drivers
> +#
> +# CONFIG_USB_KBD is not set
> +# CONFIG_USB_MOUSE is not set
> +
> +#
>  # USB support
>  #
>  CONFIG_USB_ARCH_HAS_HCD=y
> @@ -1096,6 +1099,7 @@ CONFIG_USB=m
>  # Miscellaneous USB options
>  #
>  CONFIG_USB_DEVICEFS=y
> +CONFIG_USB_DEVICE_CLASS=y
>  # CONFIG_USB_DYNAMIC_MINORS is not set
>  # CONFIG_USB_OTG is not set
>  
> @@ -1147,44 +1151,10 @@ CONFIG_USB_STORAGE=m
>  # CONFIG_USB_LIBUSUAL is not set
>  
>  #
> -# USB Input Devices
> -#
> -# CONFIG_USB_HID is not set
> -
> -#
> -# USB HID Boot Protocol drivers
> -#
> -# CONFIG_USB_KBD is not set
> -# CONFIG_USB_MOUSE is not set
> -# CONFIG_USB_AIPTEK is not set
> -# CONFIG_USB_WACOM is not set
> -# CONFIG_USB_ACECAD is not set
> -# CONFIG_USB_KBTAB is not set
> -# CONFIG_USB_POWERMATE is not set
> -# CONFIG_USB_TOUCHSCREEN is not set
> -# CONFIG_USB_YEALINK is not set
> -# CONFIG_USB_XPAD is not set
> -# CONFIG_USB_ATI_REMOTE is not set
> -# CONFIG_USB_ATI_REMOTE2 is not set
> -# CONFIG_USB_KEYSPAN_REMOTE is not set
> -# CONFIG_USB_APPLETOUCH is not set
> -# CONFIG_USB_GTCO is not set
> -
> -#
>  # USB Imaging devices
>  #
>  # CONFIG_USB_MDC800 is not set
>  # CONFIG_USB_MICROTEK is not set
> -
> -#
> -# USB Network Adapters
> -#
> -# CONFIG_USB_CATC is not set
> -# CONFIG_USB_KAWETH is not set
> -# CONFIG_USB_PEGASUS is not set
> -# CONFIG_USB_RTL8150 is not set
> -# CONFIG_USB_USBNET_MII is not set
> -# CONFIG_USB_USBNET is not set
>  CONFIG_USB_MON=y
>  
>  #
> @@ -1228,10 +1198,6 @@ CONFIG_USB_MON=y
>  # USB Gadget Support
>  #
>  # CONFIG_USB_GADGET is not set
> -
> -#
> -# MMC/SD Card support
> -#
>  # CONFIG_MMC is not set
>  
>  #
> @@ -1253,10 +1219,12 @@ CONFIG_USB_MON=y
>  CONFIG_INFINIBAND=m
>  CONFIG_INFINIBAND_USER_MAD=m
>  CONFIG_INFINIBAND_USER_ACCESS=m
> +CONFIG_INFINIBAND_USER_MEM=y
>  CONFIG_INFINIBAND_ADDR_TRANS=y
>  CONFIG_INFINIBAND_MTHCA=m
>  CONFIG_INFINIBAND_MTHCA_DEBUG=y
>  # CONFIG_INFINIBAND_AMSO1100 is not set
> +# CONFIG_MLX4_INFINIBAND is not set
>  CONFIG_INFINIBAND_IPOIB=m
>  # CONFIG_INFINIBAND_IPOIB_CM is not set
>  CONFIG_INFINIBAND_IPOIB_DEBUG=y
> @@ -1287,14 +1255,6 @@ CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
>  #
>  
>  #
> -# Auxiliary Display support
> -#
> -
> -#
> -# Virtualization
> -#
> -
> -#
>  # File systems
>  #
>  CONFIG_EXT2_FS=y
> @@ -1389,6 +1349,7 @@ CONFIG_LOCKD_V4=y
>  CONFIG_NFS_ACL_SUPPORT=y
>  CONFIG_NFS_COMMON=y
>  CONFIG_SUNRPC=y
> +# CONFIG_SUNRPC_BIND34 is not set
>  # CONFIG_RPCSEC_GSS_KRB5 is not set
>  # CONFIG_RPCSEC_GSS_SPKM3 is not set
>  # CONFIG_SMB_FS is not set
> @@ -1418,6 +1379,7 @@ CONFIG_MSDOS_PARTITION=y
>  # CONFIG_SUN_PARTITION is not set
>  # CONFIG_KARMA_PARTITION is not set
>  CONFIG_EFI_PARTITION=y
> +# CONFIG_SYSV68_PARTITION is not set
>  
>  #
>  # Native Language Support
> @@ -1468,7 +1430,6 @@ CONFIG_NLS_ISO8859_15=m
>  #
>  # CONFIG_DLM is not set
>  # CONFIG_UCC_SLOW is not set
> -# CONFIG_UCC_FAST is not set
>  
>  #
>  # Library routines
> @@ -1476,6 +1437,7 @@ CONFIG_NLS_ISO8859_15=m
>  CONFIG_BITREVERSE=y
>  # CONFIG_CRC_CCITT is not set
>  # CONFIG_CRC16 is not set
> +# CONFIG_CRC_ITU_T is not set
>  CONFIG_CRC32=y
>  # CONFIG_LIBCRC32C is not set
>  CONFIG_ZLIB_INFLATE=m
> @@ -1487,6 +1449,7 @@ CONFIG_TEXTSEARCH_FSM=m
>  CONFIG_PLIST=y
>  CONFIG_HAS_IOMEM=y
>  CONFIG_HAS_IOPORT=y
> +CONFIG_HAS_DMA=y
>  
>  #
>  # Instrumentation Support
> @@ -1506,7 +1469,6 @@ CONFIG_DEBUG_FS=y
>  # CONFIG_HEADERS_CHECK is not set
>  CONFIG_DEBUG_KERNEL=y
>  # CONFIG_DEBUG_SHIRQ is not set
> -CONFIG_LOG_BUF_SHIFT=15
>  # CONFIG_DETECT_SOFTLOCKUP is not set
>  # CONFIG_SCHEDSTATS is not set
>  # CONFIG_TIMER_STATS is not set
> @@ -1565,6 +1527,7 @@ CONFIG_CRYPTO_ECB=m
>  CONFIG_CRYPTO_CBC=m
>  CONFIG_CRYPTO_PCBC=m
>  # CONFIG_CRYPTO_LRW is not set
> +# CONFIG_CRYPTO_CRYPTD is not set
>  CONFIG_CRYPTO_DES=m
>  # CONFIG_CRYPTO_FCRYPT is not set
>  # CONFIG_CRYPTO_BLOWFISH is not set


-- 
Jan

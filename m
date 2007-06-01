Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXFAU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXFAU1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbXFAU1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:27:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762026AbXFAU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:27:04 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Date: Fri, 01 Jun 2007 22:27:49 +0200
Message-ID: <878xb35sje.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Provags-ID: V01U2FsdGVkX192JCKrHbhUgGoDR6KfClHyJcSuNTs8iT0zrPe
 hK+WR6ecTRs4/agP/ilAwcBOHW7PH+mqdIyhTfdfCWvkr0I/eT
 zt6LZeAZ3BQEoP+ioKNPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi,

resume from suspend to ram doesn't work for my laptop and never
has. So, this is not a regression.

Hibernate (aka suspend to disk) works, however.

When I resume, everything seems to come up (fan becomes busy, disk and
dvd spin up for a short time), but the machine is not responding to
anything - neither keyboard, mouse nor ping from another machine. The
laptop is effectively dead and only a power cycle helps.

I've tried a minimal config and init=/bin/bash as well, but the result
is the same.

When I skip acpi_enter_sleep_state():

diff -urN -X b/Documentation/dontdiff a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c	2007-05-27 23:47:25.000000000 +0200
+++ b/drivers/acpi/hardware/hwsleep.c	2007-06-01 10:45:46.000000000 +0200
@@ -268,6 +268,7 @@
 	u32 in_value;
 	acpi_status status;
 
+	return_ACPI_STATUS(AE_OK);
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
 
 	if ((acpi_gbl_sleep_type_a > ACPI_SLEEP_TYPE_MAX) ||

my laptop suspends and immediately resumes without problems. So it
seems, that the drivers suspend and resume correctly.

Attached is my minimal config, /proc/cpuinfo, lspci -vvv and dmesg
output.  How can I go on from here? Anything I can test, patch or
debug?

Regards, Olaf.


--=-=-=
Content-Disposition: inline; filename=minimal-2.6.22-rc3
Content-Description: Minimal .config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc3
# Fri Jun  1 10:39:11 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_UTS_NS is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0

#
# Loadable module support
#
# CONFIG_MODULES is not set

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
# CONFIG_HPET_TIMER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
# CONFIG_HZ_20 is not set
# CONFIG_HZ_50 is not set
CONFIG_HZ=100
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
CONFIG_PM_DEBUG=y
# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
CONFIG_PM_TRACE=y
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
# CONFIG_NET is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_BLINK is not set
CONFIG_IDE=y
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# ISDN subsystem
#

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set

#
# HID Devices
#
# CONFIG_HID is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
# CONFIG_USB is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_DNOTIFY is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
# CONFIG_NLS is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
# CONFIG_DOUBLEFAULT is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set

#
# Hardware crypto devices
#
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y

--=-=-=
Content-Disposition: inline; filename=cpuinfo
Content-Description: /proc/cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Pentium(R) M processor 1.73GHz
stepping	: 8
cpu MHz		: 800.000
cache size	: 2048 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe est tm2
bogomips	: 1598.01
clflush size	: 64


--=-=-=
Content-Disposition: inline; filename=lspci-vvv
Content-Description: lspci -vvv

0000:00:00.0 Host bridge: Intel Corp. Mobile Memory Controller Hub (rev 03)
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] #09 [2109]

0000:00:01.0 PCI bridge: Intel Corp. Mobile Memory Controller Hub PCI Express Port (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: c1000000-c7ffffff
	Prefetchable memory behind bridge: d0000000-d7ffffff
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [88] #0d [0000]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [a0] #10 [0141]

0000:00:1b.0 0403: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) High Definition Audio Controller (rev 04)
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c0000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] #10 [0091]

0000:00:1c.0 PCI bridge: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 1 (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] #10 [0141]
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:1c.1 PCI bridge: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 2 (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] #10 [0141]
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:1c.2 PCI bridge: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express Port 3 (rev 04) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] #10 [0141]
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:1d.0 USB Controller: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 04) (prog-if 00 [UHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1800 [size=32]

0000:00:1d.1 USB Controller: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 04) (prog-if 00 [UHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 1820 [size=32]

0000:00:1d.2 USB Controller: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 04) (prog-if 00 [UHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1840 [size=32]

0000:00:1d.3 USB Controller: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 04) (prog-if 00 [UHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at 1860 [size=32]

0000:00:1d.7 USB Controller: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 04) (prog-if 20 [EHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c0004000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] #0a [20a0]

0000:00:1e.0 PCI bridge: Intel Corp. 82801 PCI Bridge (rev d4) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=06, subordinate=07, sec-latency=216
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c8000000-c80fffff
	Prefetchable memory behind bridge: 0000000050000000-0000000055f00000
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] #0d [0000]

0000:00:1f.0 ISA bridge: Intel Corp. 82801FBM (ICH6M) LPC Interface Bridge (rev 04)
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

0000:00:1f.1 IDE interface: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE Controller (rev 04) (prog-if 8a [Master SecP PriP])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 1880 [size=16]

0000:00:1f.3 SMBus: Intel Corp. 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 04)
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 18e0 [size=32]

0000:01:00.0 VGA compatible controller: nVidia Corporation: Unknown device 0148 (rev a2) (prog-if 00 [VGA])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c4000000 (32-bit, non-prefetchable) [size=64M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=128M]
	Region 3: Memory at c1000000 (64-bit, non-prefetchable) [size=16M]
	Expansion ROM at c2000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] #10 [0001]

0000:06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 2000 [size=256]
	Region 1: Memory at c8006000 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 54000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:06:04.0 Network controller: Intel Corp.: Unknown device 4223 (rev 05)
	Subsystem: Intel Corp.: Unknown device 1001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (750ns min, 6000ns max), Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c8007000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

0000:06:09.0 CardBus bridge: Texas Instruments: Unknown device 8031
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 49, Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c8008000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=06, secondary=07, subordinate=08, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 58000000-5bfff000 (prefetchable)
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002800-000028ff
	BridgeCtl: Parity- SERR- ISA+ VGA- MAbort- >Reset+ 16bInt- PostWrite-
	16-bit legacy interface ports at 0001

0000:06:09.2 FireWire (IEEE 1394): Texas Instruments: Unknown device 8032 (prog-if 10 [OHCI])
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (750ns min, 1000ns max), Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at c8006800 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at c8000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:06:09.3 Unknown mass storage controller: Texas Instruments: Unknown device 8033
	Subsystem: QUANTA Computer Inc: Unknown device 0729
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 57 (1750ns min, 1000ns max), Cache Line Size: 0x08 (32 bytes)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at c8004000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


--=-=-=
Content-Disposition: inline; filename=dmesg.txt
Content-Description: dmesg

 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: After all inits, caps: afe9fbff 00000000 00000000 00002040 00000180 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 876 Objects with 63 Devices 216 Methods 28 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 8 Objects with 2 Devices 4 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 5 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 1 Objects with 0 Devices 1 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 10 Objects with 0 Devices 2 Methods 0 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
PM: Adding info for No Bus:platform
Time:  8:52:57  Date: 05/01/107
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 1 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:............................................................................
Initialized 28/28 Regions 4/4 Fields 30/30 Buffers 14/26 Packages (909 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 2 _STA executions (examined 70 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0A05:00
PM: Adding info for acpi:SMCF010:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:SYN1003:00
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:pnp0c14:00
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:thermal:01
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #07 (-#08) is hidden behind transparent bridge #06 (-#07) (try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1c.2
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:06:00.0
PM: Adding info for pci:0000:06:04.0
PM: Adding info for pci:0000:06:09.0
PM: Adding info for pci:0000:06:09.2
PM: Adding info for pci:0000:06:09.3
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.0
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.1
PCI: Cannot allocate resource region 7 of bridge 0000:00:1c.2
PCI: Cannot allocate resource region 8 of bridge 0000:00:1c.2
PCI: Cannot allocate resource region 9 of bridge 0000:00:1c.2
[ACPI Debug]  String: [0x15] "_Q80 : Temperature Up"
pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
pnp: 00:01: iomem range 0xf0000000-0xf0003fff could not be reserved
pnp: 00:01: iomem range 0xf0004000-0xf0004fff could not be reserved
pnp: 00:01: iomem range 0xf0005000-0xf0005fff could not be reserved
PM: Adding info for No Bus:mem
[ACPI Debug]  String: [0x15] "_Q80 : Temperature Up"
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: c1000000-c7ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bus 7, cardbus bridge: 0000:06:09.0
  IO window: 00002400-000024ff
  IO window: 00002800-000028ff
  PREFETCH window: 50000000-53ffffff
  MEM window: 58000000-5bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 2000-2fff
  MEM window: c8000000-c80fffff
  PREFETCH window: 50000000-55ffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:06:09.0[A] -> GSI 16 (level, low) -> IRQ 16
Simple Boot Flag at 0x36 set to 0x1
PM: Adding info for platform:pcspkr
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PM: Adding info for pci_express:0000:00:01.0:pcie00
Allocate Port Service[0000:00:01.0:pcie03]
PM: Adding info for pci_express:0000:00:01.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
PM: Adding info for pci_express:0000:00:1c.0:pcie00
Allocate Port Service[0000:00:1c.0:pcie02]
PM: Adding info for pci_express:0000:00:1c.0:pcie02
Allocate Port Service[0000:00:1c.0:pcie03]
PM: Adding info for pci_express:0000:00:1c.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
PM: Adding info for pci_express:0000:00:1c.1:pcie00
Allocate Port Service[0000:00:1c.1:pcie02]
PM: Adding info for pci_express:0000:00:1c.1:pcie02
Allocate Port Service[0000:00:1c.1:pcie03]
PM: Adding info for pci_express:0000:00:1c.1:pcie03
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
PM: Adding info for pci_express:0000:00:1c.2:pcie00
Allocate Port Service[0000:00:1c.2:pcie02]
PM: Adding info for pci_express:0000:00:1c.2:pcie02
Allocate Port Service[0000:00:1c.2:pcie03]
PM: Adding info for pci_express:0000:00:1c.2:pcie03
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (65 C)
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH6: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH6: chipset revision 4
ICH6: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1880-0x1887, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
hda: HTS548080M9AT00, ATA DISK drive
PM: Adding info for No Bus:ide0
Clocksource tsc unstable (delta = -498875160 ns)
hdb: MATSHITAUJ-831D, ATAPI CD/DVD-ROM drive
hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
hda: selected mode 0x42
hdb: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
PM: Adding info for ide:0.0
PM: Adding info for ide:0.1
Probing IDE interface ide1...
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/7877KiB Cache, CHS=16383/255/63, UDMA(33)
hda: cache flushes supported
 hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
Using IPI Shortcut mode
  Magic number: 11:259:876
input: AT Translated Set 2 keyboard as /class/input/input0
PM: Adding info for serio:serio1
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 144k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
[ACPI Debug]  String: [0x15] "_Q80 : Temperature Up"

--=-=-=--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYDBRlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYDBRlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYDBRll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:41:41 -0400
Received: from srv2.rent-a-guru.de ([212.86.204.162]:19036 "EHLO
	mx02.rent-a-guru.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYDBRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:41:38 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 13:41:38 EDT
Date: Wed, 2 Apr 2008 19:34:30 +0200
From: Michael Stapelberg <michael+lkml@stapelberg.de>
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: WD SATA disk works on nv but not on ahci
Message-ID: <20080402173429.GS11237@mx01>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rJ8inJ6ig7iY3YX9"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJ8inJ6ig7iY3YX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I recently bought an MSI 945GT Speedster-A4V which got an Intel 82801GR/GH
(ICH7 Family) SATA AHCI Controller onboard. The complete lspci-Output follows
below.

I also have a WD 250 GB SATA disk since about a year, it's an WDC
WD2500YD-01N. This disk ran on an ASUS A8N-SLI flawlessly for over a year. It
also works on an MSI K9N (also nvidia-chipset) flawlessy right now, I just
tested it.

When I use this disk on my MSI 945GT it throws SATA Exceptions like this on
nearly every access to the disk (reading via dd for example):
Apr  2 18:11:45 w ata5.00: exception Emask 0x52 SAct 0x1 SErr 0x1480c01 action 0x6 frozen
Apr  2 18:11:45 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 18:11:45 w ata5: SError: { RecovData Proto HostInt 10B8B Handshk TrStaTrns }
Apr  2 18:11:45 w ata5.00: cmd 60/00:00:10:90:0d/02:00:00:00:00/40 tag 0 ncq 262144 in
Apr  2 18:11:45 w res 40/00:04:10:90:0d/00:00:00:00:00/40 Emask 0x52 (ATA bus error)
Apr  2 18:11:45 w ata5.00: status: { DRDY }
Apr  2 18:11:45 w ata5: hard resetting link
Apr  2 18:11:51 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 18:11:56 w ata5: COMRESET failed (errno=-16)
Apr  2 18:11:56 w ata5: hard resetting link
Apr  2 18:11:56 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 18:11:56 w ata5.00: configured for UDMA/133
Apr  2 18:11:56 w ata5: EH complete
Apr  2 18:11:56 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
Apr  2 18:11:56 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 18:11:56 w ata5: SError: { UnrecovData Handshk }
Apr  2 18:11:56 w ata5.00: cmd 61/08:00:20:28:00/00:00:00:00:00/40 tag 0 ncq 4096 out
Apr  2 18:11:56 w res 40/00:04:20:28:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 18:11:56 w ata5.00: status: { DRDY }
Apr  2 18:11:56 w ata5: soft resetting link
Apr  2 18:11:57 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 18:11:57 w ata5.00: configured for UDMA/133
Apr  2 18:11:57 w ata5: EH complete
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

This is really annoying and so I tried debugging the problem... When attaching
my WD Raptor 74 GB (WDC WD740GD-00FL), there are no problems at all. I can
read the whole disk without a single error. This rules out problems with SATA
cables and power supply, I think. The cable is the same which I used the year
before.

I also tried switching between IDE/AHCI-mode in the BIOS, but neither works
correctly. IDE-mode just spits out error messages and doesn't work at all,
AHCI produces the errors I talked about above.

I'm using kernel 2.6.24.3 at the moment.

This is a really strange problem in my opinion, could it be an incompatibility
in the SATA protocol of this drive? Just to stress it, the drive works on an
nvidia chipset and another drive works on the ICH7R, just this very combination
got problems.

Please CC me as I'm not subscribed to the list.

Best regards,
Michael

dmesg and kernel configuration is attached

lspci:
00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 01) (prog-if 01 [AHCI 1.0])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 6320
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 217
	I/O ports at fa00 [size=8]
	I/O ports at f900 [size=4]
	I/O ports at f800 [size=8]
	I/O ports at f700 [size=4]
	I/O ports at f600 [size=16]
	Memory at fdffe000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [70] Power Management version 2
	Kernel driver in use: ahci
	Kernel modules: ahci

--rJ8inJ6ig7iY3YX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cfg

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-w"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_BLOCK=y

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
CONFIG_DEFAULT_IOSCHED="anticipatory"

CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_X86_PC=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_MPENTIUM4=y
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_VM86=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

CONFIG_PM=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_SUSPEND=y
CONFIG_HIBERNATION_UP_POSSIBLE=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m

CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_P4_CLOCKMOD=y

CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y

CONFIG_BINFMT_ELF=y

CONFIG_NET=y

CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_IPV6_SIT=y




CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PNP=y

CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_MISC_DEVICES=y

CONFIG_SCSI=y
CONFIG_SCSI_DMA=y

CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_SG=y

CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=m
CONFIG_ATA_PIIX=m
CONFIG_ATA_GENERIC=m
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y

CONFIG_IEEE1394=y


CONFIG_IEEE1394_OHCI1394=y

CONFIG_IEEE1394_RAWIO=y
CONFIG_NETDEVICES=y
CONFIG_TUN=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_TULIP=y
CONFIG_TULIP=y
CONFIG_NET_PCI=y
CONFIG_E100=y
CONFIG_NETDEV_1000=y
CONFIG_E1000=y
CONFIG_E1000E=y


CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y

CONFIG_INPUT=y

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=y

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y

CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y

CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_RTC=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

CONFIG_I2C_ALGOBIT=y

CONFIG_I2C_I801=y
CONFIG_I2C_I810=y

CONFIG_SENSORS_EEPROM=y

CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

CONFIG_SSB_POSSIBLE=y



CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_VGASTATE=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y

CONFIG_FB_I810=y


CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

CONFIG_SOUND=y

CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y

CONFIG_SND_AC97_CODEC=y

CONFIG_SND_EMU10K1=y

CONFIG_SND_USB_AUDIO=y



CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

CONFIG_USB_HID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y

CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y

CONFIG_USB_EHCI_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y

CONFIG_USB_PRINTER=y


CONFIG_USB_STORAGE=y






CONFIG_VIRTUALIZATION=y


CONFIG_DMIID=y

CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_DNOTIFY=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y

CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m

CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

CONFIG_UFS_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V4=y
CONFIG_NFSD=y
CONFIG_NFSD_TCP=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_SMB_FS=y
CONFIG_CIFS=y

CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_UTF8=y
CONFIG_INSTRUMENTATION=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_HW=y

CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--rJ8inJ6ig7iY3YX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dm

Apr  2 16:50:21 w Linux version 2.6.24.3-w (root@w) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #16 Wed Apr 2 15:05:48 CEST 2008
Apr  2 16:50:21 w BIOS-provided physical RAM map:
Apr  2 16:50:21 w BIOS-e820: 0000000000000000 - 0000000000090001 (usable)
Apr  2 16:50:21 w BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
Apr  2 16:50:21 w BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Apr  2 16:50:21 w BIOS-e820: 0000000000100000 - 00000000cfedf800 (usable)
Apr  2 16:50:21 w BIOS-e820: 00000000cfedf800 - 00000000cfee0000 (reserved)
Apr  2 16:50:21 w BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
Apr  2 16:50:21 w BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
Apr  2 16:50:21 w BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
Apr  2 16:50:21 w BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Apr  2 16:50:21 w BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Apr  2 16:50:21 w 2430MB HIGHMEM available.
Apr  2 16:50:21 w 896MB LOWMEM available.
Apr  2 16:50:21 w Entering add_active_range(0, 0, 851679) 0 entries of 256 used
Apr  2 16:50:21 w Zone PFN ranges:
Apr  2 16:50:21 w DMA             0 ->     4096
Apr  2 16:50:21 w Normal       4096 ->   229376
Apr  2 16:50:21 w HighMem    229376 ->   851679
Apr  2 16:50:21 w Movable zone start PFN for each node
Apr  2 16:50:21 w early_node_map[1] active PFN ranges
Apr  2 16:50:21 w 0:        0 ->   851679
Apr  2 16:50:21 w On node 0 totalpages: 851679
Apr  2 16:50:21 w DMA zone: 32 pages used for memmap
Apr  2 16:50:21 w DMA zone: 0 pages reserved
Apr  2 16:50:21 w DMA zone: 4064 pages, LIFO batch:0
Apr  2 16:50:21 w Normal zone: 1760 pages used for memmap
Apr  2 16:50:21 w Normal zone: 223520 pages, LIFO batch:31
Apr  2 16:50:21 w HighMem zone: 4861 pages used for memmap
Apr  2 16:50:21 w HighMem zone: 617442 pages, LIFO batch:31
Apr  2 16:50:21 w Movable zone: 0 pages used for memmap
Apr  2 16:50:21 w DMI 2.4 present.
Apr  2 16:50:21 w ACPI: RSDP 000F93A0, 0014 (r0 IntelR)
Apr  2 16:50:21 w ACPI: RSDT CFEE3040, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Apr  2 16:50:21 w ACPI: FACP CFEE30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Apr  2 16:50:21 w ACPI: DSDT CFEE3180, 4950 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
Apr  2 16:50:21 w ACPI: FACS CFEE0000, 0040
Apr  2 16:50:21 w ACPI: HPET CFEE7C00, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD       98)
Apr  2 16:50:21 w ACPI: MCFG CFEE7C80, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
Apr  2 16:50:21 w ACPI: SSDT CFEE7D00, 019E (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
Apr  2 16:50:21 w ACPI: SSDT CFEE8190, 01E3 (r1  PmRef    CpuPm     3000 INTL 20050624)
Apr  2 16:50:21 w ACPI: PM-Timer IO Port: 0x408
Apr  2 16:50:21 w ACPI: HPET id: 0x8086a201 base: 0xfed00000
Apr  2 16:50:21 w Allocating PCI resources starting at d0000000 (gap: cff00000:10100000)
Apr  2 16:50:21 w Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 845026
Apr  2 16:50:21 w Kernel command line: ip=dhcp root=/dev/nfs rw nfsroot=192.168.1.222:/diskless/w combined_mode=libata libata.atapi_enabled=1 BOOT_IMAGE=/bzImage 
Apr  2 16:50:21 w Found and enabled local APIC!
Apr  2 16:50:21 w mapped APIC to ffffb000 (fee00000)
Apr  2 16:50:21 w Enabling fast FPU save and restore... done.
Apr  2 16:50:21 w Enabling unmasked SIMD FPU exception support... done.
Apr  2 16:50:21 w Initializing CPU#0
Apr  2 16:50:21 w PID hash table entries: 4096 (order: 12, 16384 bytes)
Apr  2 16:50:21 w Detected 1825.884 MHz processor.
Apr  2 16:50:21 w Console: colour VGA+ 80x25
Apr  2 16:50:21 w console [tty0] enabled
Apr  2 16:50:21 w Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Apr  2 16:50:21 w Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Apr  2 16:50:21 w Memory: 3372500k/3406716k available (3073k kernel code, 33052k reserved, 1523k data, 228k init, 2489212k highmem)
Apr  2 16:50:21 w virtual kernel memory layout:
Apr  2 16:50:21 w fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
Apr  2 16:50:21 w pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Apr  2 16:50:21 w vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
Apr  2 16:50:21 w lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
Apr  2 16:50:21 w .init : 0xc0580000 - 0xc05b9000   ( 228 kB)
Apr  2 16:50:21 w .data : 0xc040053b - 0xc057d374   (1523 kB)
Apr  2 16:50:21 w .text : 0xc0100000 - 0xc040053b   (3073 kB)
Apr  2 16:50:21 w Checking if this processor honours the WP bit even in supervisor mode... Ok.
Apr  2 16:50:21 w hpet clockevent registered
Apr  2 16:50:21 w Calibrating delay using timer specific routine.. 3654.43 BogoMIPS (lpj=7308871)
Apr  2 16:50:21 w Mount-cache hash table entries: 512
Apr  2 16:50:21 w CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
Apr  2 16:50:21 w monitor/mwait feature present.
Apr  2 16:50:21 w using mwait in idle threads.
Apr  2 16:50:21 w CPU: L1 I cache: 32K, L1 D cache: 32K
Apr  2 16:50:21 w CPU: L2 cache: 2048K
Apr  2 16:50:21 w CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Apr  2 16:50:21 w Intel machine check architecture supported.
Apr  2 16:50:21 w Intel machine check reporting enabled on CPU#0.
Apr  2 16:50:21 w Compat vDSO mapped to ffffe000.
Apr  2 16:50:21 w CPU: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Apr  2 16:50:21 w Checking 'hlt' instruction... OK.
Apr  2 16:50:21 w Freeing SMP alternatives: 0k freed
Apr  2 16:50:21 w ACPI: Core revision 20070126
Apr  2 16:50:21 w ACPI: setting ELCR to 0200 (from 8e28)
Apr  2 16:50:21 w net_namespace: 64 bytes
Apr  2 16:50:21 w NET: Registered protocol family 16
Apr  2 16:50:21 w ACPI: bus type pci registered
Apr  2 16:50:21 w PCI: Using MMCONFIG
Apr  2 16:50:21 w Setting up standard PCI resources
Apr  2 16:50:21 w ACPI: EC: Look up EC in DSDT
Apr  2 16:50:21 w ACPI: Interpreter enabled
Apr  2 16:50:21 w ACPI: (supports S0 S3 S5)
Apr  2 16:50:21 w ACPI: Using PIC for interrupt routing
Apr  2 16:50:21 w ACPI: PCI Root Bridge [PCI0] (0000:00)
Apr  2 16:50:21 w PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Apr  2 16:50:21 w PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Apr  2 16:50:21 w PCI: Transparent bridge - 0000:00:1e.0
Apr  2 16:50:21 w ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Apr  2 16:50:21 w ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
Apr  2 16:50:21 w ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
Apr  2 16:50:21 w ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
Apr  2 16:50:21 w ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 *15)
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 7 9 10 11 12 14 15)
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 15)
Apr  2 16:50:21 w Linux Plug and Play Support v0.97 (c) Adam Belay
Apr  2 16:50:21 w pnp: PnP ACPI init
Apr  2 16:50:21 w ACPI: bus type pnp registered
Apr  2 16:50:21 w pnpacpi: exceeded the max number of mem resources: 12
Apr  2 16:50:21 w pnp: PnP ACPI: found 14 devices
Apr  2 16:50:21 w ACPI: ACPI bus type pnp unregistered
Apr  2 16:50:21 w SCSI subsystem initialized
Apr  2 16:50:21 w libata version 3.00 loaded.
Apr  2 16:50:21 w usbcore: registered new interface driver usbfs
Apr  2 16:50:21 w usbcore: registered new interface driver hub
Apr  2 16:50:21 w usbcore: registered new device driver usb
Apr  2 16:50:21 w PCI: Using ACPI for IRQ routing
Apr  2 16:50:21 w PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Apr  2 16:50:21 w hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Apr  2 16:50:21 w hpet0: 3 64-bit timers, 14318180 Hz
Apr  2 16:50:21 w Time: tsc clocksource has been installed.
Apr  2 16:50:21 w system 00:01: ioport range 0x4d0-0x4d1 has been reserved
Apr  2 16:50:21 w system 00:01: ioport range 0x290-0x297 has been reserved
Apr  2 16:50:21 w system 00:01: ioport range 0x880-0x88f has been reserved
Apr  2 16:50:21 w system 00:0a: ioport range 0x400-0x4bf could not be reserved
Apr  2 16:50:21 w system 00:0c: iomem range 0xe0000000-0xefffffff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xfed00000-0xfed000ff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xcfee0000-0xcfefffff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0x0-0x9ffff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0x100000-0xcfedffff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0x0-0x0 could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xfed13000-0xfed1dfff could not be reserved
Apr  2 16:50:21 w system 00:0d: iomem range 0xfed20000-0xfed8ffff could not be reserved
Apr  2 16:50:21 w PCI: Bridge: 0000:00:01.0
Apr  2 16:50:21 w IO window: b000-bfff
Apr  2 16:50:21 w MEM window: fa000000-fcffffff
Apr  2 16:50:21 w PREFETCH window: d0000000-dfffffff
Apr  2 16:50:21 w PCI: Bridge: 0000:00:1c.0
Apr  2 16:50:21 w IO window: a000-afff
Apr  2 16:50:21 w MEM window: fda00000-fdafffff
Apr  2 16:50:21 w PREFETCH window: fd700000-fd7fffff
Apr  2 16:50:21 w PCI: Bridge: 0000:00:1c.4
Apr  2 16:50:21 w IO window: e000-efff
Apr  2 16:50:21 w MEM window: fde00000-fdefffff
Apr  2 16:50:21 w PREFETCH window: fdd00000-fddfffff
Apr  2 16:50:21 w PCI: Bridge: 0000:00:1c.5
Apr  2 16:50:21 w IO window: d000-dfff
Apr  2 16:50:21 w MEM window: fdc00000-fdcfffff
Apr  2 16:50:21 w PREFETCH window: fdb00000-fdbfffff
Apr  2 16:50:21 w PCI: Bridge: 0000:00:1e.0
Apr  2 16:50:21 w IO window: c000-cfff
Apr  2 16:50:21 w MEM window: fd900000-fd9fffff
Apr  2 16:50:21 w PREFETCH window: fd800000-fd8fffff
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
Apr  2 16:50:21 w PCI: setting IRQ 11 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:01.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:01.0 to 64
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1c.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.0 to 64
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
Apr  2 16:50:21 w PCI: setting IRQ 5 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1c.4[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.4 to 64
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 15
Apr  2 16:50:21 w PCI: setting IRQ 15 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1c.5[D] -> Link [LNKD] -> GSI 15 (level, low) -> IRQ 15
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.5 to 64
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1e.0 to 64
Apr  2 16:50:21 w NET: Registered protocol family 2
Apr  2 16:50:21 w IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Apr  2 16:50:21 w TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Apr  2 16:50:21 w TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
Apr  2 16:50:21 w TCP: Hash tables configured (established 131072 bind 65536)
Apr  2 16:50:21 w TCP reno registered
Apr  2 16:50:21 w highmem bounce pool size: 64 pages
Apr  2 16:50:21 w Total HugeTLB memory allocated, 0
Apr  2 16:50:21 w Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Apr  2 16:50:21 w fuse init (API version 7.9)
Apr  2 16:50:21 w io scheduler noop registered
Apr  2 16:50:21 w io scheduler anticipatory registered (default)
Apr  2 16:50:21 w io scheduler deadline registered
Apr  2 16:50:21 w io scheduler cfq registered
Apr  2 16:50:21 w Boot video device is 0000:01:00.0
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:01.0 to 64
Apr  2 16:50:21 w assign_interrupt_mode Found MSI capability
Apr  2 16:50:21 w Allocate Port Service[0000:00:01.0:pcie00]
Apr  2 16:50:21 w Allocate Port Service[0000:00:01.0:pcie03]
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.0 to 64
Apr  2 16:50:21 w assign_interrupt_mode Found MSI capability
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.0:pcie00]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.0:pcie02]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.0:pcie03]
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.4 to 64
Apr  2 16:50:21 w assign_interrupt_mode Found MSI capability
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.4:pcie00]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.4:pcie02]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.4:pcie03]
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1c.5 to 64
Apr  2 16:50:21 w assign_interrupt_mode Found MSI capability
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.5:pcie00]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.5:pcie02]
Apr  2 16:50:21 w Allocate Port Service[0000:00:1c.5:pcie03]
Apr  2 16:50:21 w ACPI: Fan [FAN] (on)
Apr  2 16:50:21 w ACPI: Thermal Zone [THRM] (40 C)
Apr  2 16:50:21 w Real Time Clock Driver v1.12ac
Apr  2 16:50:21 w hpet_resources: 0xfed00000 is busy
Apr  2 16:50:21 w intel_rng: FWH not detected
Apr  2 16:50:21 w Linux agpgart interface v0.102
Apr  2 16:50:21 w Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Apr  2 16:50:21 w Hangcheck: Using get_cycles().
Apr  2 16:50:21 w Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Apr  2 16:50:21 w serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Apr  2 16:50:21 w 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Apr  2 16:50:21 w floppy0: no floppy controllers found
Apr  2 16:50:21 w RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
Apr  2 16:50:21 w loop: module loaded
Apr  2 16:50:21 w Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Apr  2 16:50:21 w Copyright (c) 1999-2006 Intel Corporation.
Apr  2 16:50:21 w e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
Apr  2 16:50:21 w e1000e: Copyright (c) 1999-2007 Intel Corporation.
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:03:00.0[A] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:03:00.0 to 64
Apr  2 16:50:21 w 0000:03:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:92:6f:fe:f6
Apr  2 16:50:21 w 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
Apr  2 16:50:21 w 0000:03:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNKD] -> GSI 15 (level, low) -> IRQ 15
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:04:00.0 to 64
Apr  2 16:50:21 w 0000:04:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1d:92:6f:fe:f7
Apr  2 16:50:21 w 0000:04:00.0: eth1: Intel(R) PRO/1000 Network Connection
Apr  2 16:50:21 w 0000:04:00.0: eth1: MAC: 2, PHY: 2, PBA No: ffffff-0ff
Apr  2 16:50:21 w e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
Apr  2 16:50:21 w e100: Copyright(c) 1999-2006 Intel Corporation
Apr  2 16:50:21 w tun: Universal TUN/TAP device driver, 1.6
Apr  2 16:50:21 w tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Apr  2 16:50:21 w console [netcon0] enabled
Apr  2 16:50:21 w netconsole: network logging started
Apr  2 16:50:21 w Driver 'sd' needs updating - please use bus_type methods
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Apr  2 16:50:21 w PCI: setting IRQ 10 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:05:00.2[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:05:00.2 to 64
Apr  2 16:50:21 w ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[fd9ff000-fd9ff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 3
Apr  2 16:50:21 w PCI: setting IRQ 3 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:05:04.0[A] -> Link [LNKE] -> GSI 3 (level, low) -> IRQ 3
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:05:04.0 to 64
Apr  2 16:50:21 w ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[3]  MMIO=[fd9fe000-fd9fe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Apr  2 16:50:21 w ieee1394: raw1394: /dev/raw1394 device initialized
Apr  2 16:50:21 w ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 9
Apr  2 16:50:21 w PCI: setting IRQ 9 as level-triggered
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1d.7[A] -> Link [LNK1] -> GSI 9 (level, low) -> IRQ 9
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1d.7 to 64
Apr  2 16:50:21 w ehci_hcd 0000:00:1d.7: EHCI Host Controller
Apr  2 16:50:21 w ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Apr  2 16:50:21 w PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Apr  2 16:50:21 w ehci_hcd 0000:00:1d.7: irq 9, io mem 0xfdfff000
Apr  2 16:50:21 w ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Apr  2 16:50:21 w usb usb1: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 1-0:1.0: USB hub found
Apr  2 16:50:21 w hub 1-0:1.0: 8 ports detected
Apr  2 16:50:21 w ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Apr  2 16:50:21 w USB Universal Host Controller Interface driver v3.0
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNK1] -> GSI 9 (level, low) -> IRQ 9
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1d.0 to 64
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.0: UHCI Host Controller
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.0: irq 9, io base 0x0000ff00
Apr  2 16:50:21 w usb usb2: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 2-0:1.0: USB hub found
Apr  2 16:50:21 w hub 2-0:1.0: 2 ports detected
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 15 (level, low) -> IRQ 15
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1d.1 to 64
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.1: UHCI Host Controller
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.1: irq 15, io base 0x0000fe00
Apr  2 16:50:21 w usb usb3: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 3-0:1.0: USB hub found
Apr  2 16:50:21 w hub 3-0:1.0: 2 ports detected
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1d.2 to 64
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.2: UHCI Host Controller
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.2: irq 5, io base 0x0000fd00
Apr  2 16:50:21 w usb usb4: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 4-0:1.0: USB hub found
Apr  2 16:50:21 w hub 4-0:1.0: 2 ports detected
Apr  2 16:50:21 w usb 1-1: new high speed USB device using ehci_hcd and address 2
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1d.3[D] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1d.3 to 64
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.3: UHCI Host Controller
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Apr  2 16:50:21 w uhci_hcd 0000:00:1d.3: irq 11, io base 0x0000fc00
Apr  2 16:50:21 w usb usb5: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 5-0:1.0: USB hub found
Apr  2 16:50:21 w hub 5-0:1.0: 2 ports detected
Apr  2 16:50:21 w usb 1-1: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w usb 1-4: new high speed USB device using ehci_hcd and address 3
Apr  2 16:50:21 w usb 1-4: configuration #1 chosen from 1 choice
Apr  2 16:50:21 w hub 1-4:1.0: USB hub found
Apr  2 16:50:21 w hub 1-4:1.0: 4 ports detected
Apr  2 16:50:21 w usbcore: registered new interface driver usblp
Apr  2 16:50:21 w Initializing USB Mass Storage driver...
Apr  2 16:50:21 w scsi0 : SCSI emulation for USB Mass Storage devices
Apr  2 16:50:21 w usbcore: registered new interface driver usb-storage
Apr  2 16:50:21 w USB Mass Storage support registered.
Apr  2 16:50:21 w usb-storage: device found at 2
Apr  2 16:50:21 w usb-storage: waiting for device to settle before scanning
Apr  2 16:50:21 w PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Apr  2 16:50:21 w serio: i8042 KBD port at 0x60,0x64 irq 1
Apr  2 16:50:21 w serio: i8042 AUX port at 0x60,0x64 irq 12
Apr  2 16:50:21 w mice: PS/2 mouse device common for all mice
Apr  2 16:50:21 w input: AT Translated Set 2 keyboard as /class/input/input0
Apr  2 16:50:21 w ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c0151033b6b]
Apr  2 16:50:21 w ieee1394: Host added: ID:BUS[1-00:1023]  GUID[0010dc56013f3d9e]
Apr  2 16:50:21 w i2c /dev entries driver
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKD] -> GSI 15 (level, low) -> IRQ 15
Apr  2 16:50:21 w input: ImExPS/2 Logitech Wheel Mouse as /class/input/input1
Apr  2 16:50:21 w w83627ehf: Found W83627EHG chip at 0x290
Apr  2 16:50:21 w device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
Apr  2 16:50:21 w cpuidle: using governor ladder
Apr  2 16:50:21 w usbcore: registered new interface driver usbhid
Apr  2 16:50:21 w drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Apr  2 16:50:21 w Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:05:00.0 to 64
Apr  2 16:50:21 w Installing spdif_bug patch: Audigy 2 ZS [SB0350]
Apr  2 16:50:21 w usbcore: registered new interface driver snd-usb-audio
Apr  2 16:50:21 w ALSA device list:
Apr  2 16:50:21 w #0: Audigy 2 ZS [SB0350] (rev.4, serial:0x20021102) at 0xcf00, irq 11
Apr  2 16:50:21 w oprofile: using NMI interrupt.
Apr  2 16:50:21 w TCP cubic registered
Apr  2 16:50:21 w NET: Registered protocol family 1
Apr  2 16:50:21 w NET: Registered protocol family 10
Apr  2 16:50:21 w IPv6 over IPv4 tunneling driver
Apr  2 16:50:21 w NET: Registered protocol family 17
Apr  2 16:50:21 w RPC: Registered udp transport module.
Apr  2 16:50:21 w RPC: Registered tcp transport module.
Apr  2 16:50:21 w Using IPI Shortcut mode
Apr  2 16:50:21 w ADDRCONF(NETDEV_UP): eth0: link is not ready
Apr  2 16:50:21 w ADDRCONF(NETDEV_UP): eth1: link is not ready
Apr  2 16:50:21 w Sending DHCP requests .<6>0000:03:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Apr  2 16:50:21 w ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Apr  2 16:50:21 w scsi 0:0:0:0: Direct-Access     USB      DISK 2.0         1219 PQ: 0 ANSI: 0 CCS
Apr  2 16:50:21 w sd 0:0:0:0: [sda] 3915776 512-byte hardware sectors (2005 MB)
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Write Protect is off
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Assuming drive cache: write through
Apr  2 16:50:21 w sd 0:0:0:0: [sda] 3915776 512-byte hardware sectors (2005 MB)
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Write Protect is off
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Assuming drive cache: write through
Apr  2 16:50:21 w sda: sda1
Apr  2 16:50:21 w sd 0:0:0:0: [sda] Attached SCSI removable disk
Apr  2 16:50:21 w sd 0:0:0:0: Attached scsi generic sg0 type 0
Apr  2 16:50:21 w usb-storage: device scan complete
Apr  2 16:50:21 w ., OK
Apr  2 16:50:21 w IP-Config: Got DHCP answer from 192.168.1.223, my address is 192.168.1.24
Apr  2 16:50:21 w IP-Config: Complete:
Apr  2 16:50:21 w device=eth0, addr=192.168.1.24, mask=255.255.255.0, gw=192.168.1.1,
Apr  2 16:50:21 w host=192.168.1.24, domain=rag.lan, nis-domain=(none),
Apr  2 16:50:21 w bootserver=192.168.1.223, rootserver=192.168.1.222, rootpath=
Apr  2 16:50:21 w Looking up port of RPC 100003/2 on 192.168.1.222
Apr  2 16:50:21 w Looking up port of RPC 100005/1 on 192.168.1.222
Apr  2 16:50:21 w VFS: Mounted root (nfs filesystem).
Apr  2 16:50:21 w Freeing unused kernel memory: 228k freed
Apr  2 16:50:21 w nvidia: module license 'NVIDIA' taints kernel.
Apr  2 16:50:21 w ata_piix 0000:00:1f.1: version 2.12
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1f.1 to 64
Apr  2 16:50:21 w scsi1 : ata_piix
Apr  2 16:50:21 w scsi2 : ata_piix
Apr  2 16:50:21 w ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfb00 irq 14
Apr  2 16:50:21 w ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfb08 irq 15
Apr  2 16:50:21 w ata1.00: ATAPI: _NEC DVD_RW ND-3520A, 1.04, max UDMA/33
Apr  2 16:50:21 w ata1.00: configured for UDMA/33
Apr  2 16:50:21 w ata2: port disabled. ignoring.
Apr  2 16:50:21 w scsi 1:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5
Apr  2 16:50:21 w scsi 1:0:0:0: Attached scsi generic sg1 type 5
Apr  2 16:50:21 w ahci 0000:00:1f.2: version 3.0
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:00:1f.2[B] -> Link [LNKD] -> GSI 15 (level, low) -> IRQ 15
Apr  2 16:50:21 w ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Apr  2 16:50:21 w ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:00:1f.2 to 64
Apr  2 16:50:21 w scsi3 : ahci
Apr  2 16:50:21 w scsi4 : ahci
Apr  2 16:50:21 w scsi5 : ahci
Apr  2 16:50:21 w scsi6 : ahci
Apr  2 16:50:21 w ata3: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe100 irq 217
Apr  2 16:50:21 w ata4: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe180 irq 217
Apr  2 16:50:21 w ata5: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe200 irq 217
Apr  2 16:50:21 w ata6: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe280 irq 217
Apr  2 16:50:21 w ata3: SATA link down (SStatus 0 SControl 300)
Apr  2 16:50:21 w ata4: SATA link down (SStatus 0 SControl 300)
Apr  2 16:50:21 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 16:50:21 w ata5.00: ATA-7: WDC WD2500YD-01NVB1, 10.02E01, max UDMA/133
Apr  2 16:50:21 w ata5.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 1)
Apr  2 16:50:21 w ata5.00: configured for UDMA/133
Apr  2 16:50:21 w ata6: SATA link down (SStatus 0 SControl 300)
Apr  2 16:50:21 w scsi 5:0:0:0: Direct-Access     ATA      WDC WD2500YD-01N 10.0 PQ: 0 ANSI: 5
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:50:21 w sdb: unknown partition table
Apr  2 16:50:21 w sd 5:0:0:0: [sdb] Attached SCSI disk
Apr  2 16:50:21 w sd 5:0:0:0: Attached scsi generic sg2 type 0
Apr  2 16:50:21 w ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Apr  2 16:50:21 w PCI: Setting latency timer of device 0000:01:00.0 to 64
Apr  2 16:50:21 w NVRM: loading NVIDIA UNIX x86 Kernel Module  169.09  Fri Jan 11 14:38:28 PST 2008
Apr  2 16:50:22 w sshd[4563]: Server listening on :: port 22.
Apr  2 16:50:22 w sshd[4563]: error: Bind to port 22 on 0.0.0.0 failed: Address already in use.
Apr  2 16:50:23 w spurious 8259A interrupt: IRQ7.
Apr  2 16:50:27 w rpc.statd[4854]: Version 1.1.0 Starting
Apr  2 16:50:27 w rpc.statd[4854]: Flags: 
Apr  2 16:50:28 w ntpd[4961]: ntpd 4.2.4p4@1.1520-o Wed Mar 19 19:05:10 UTC 2008 (1)
Apr  2 16:50:28 w ntpd[4962]: precision = 1.000 usec
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #1 wildcard, ::#123 Disabled
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #2 eth0, fdf7:f6c0:e270:2342:21d:92ff:fe6f:fef6#123 Enabled
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #3 eth0, fe80::21d:92ff:fe6f:fef6#123 Enabled
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #4 lo, 127.0.0.1#123 Enabled
Apr  2 16:50:28 w ntpd[4962]: Listening on interface #5 eth0, 192.168.1.24#123 Enabled
Apr  2 16:50:28 w ntpd[4962]: kernel time sync status 0040
Apr  2 16:50:28 w ntpd[4962]: frequency initialized -50.259 PPM from /var/lib/ntp/ntp.drift
Apr  2 16:50:28 w cron[5017]: (CRON) STARTUP (V5.0)
Apr  2 16:50:29 w ntpd[4962]: bind() fd 22, family 10, port 123, scope 2, addr fdf7:f6c0:e270:2342::23, in6_is_addr_multicast=0 flags=0x11 fails: Cannot assign requested address
Apr  2 16:50:29 w ntpd[4962]: unable to create socket on eth0 (6) for fdf7:f6c0:e270:2342::23#123
Apr  2 16:50:29 w ntpd[4962]: failed to initialize interface for address fdf7:f6c0:e270:2342::23
Apr  2 16:50:32 w xdm(pam_unix)[4513]: session opened for user michael by (uid=0)
Apr  2 16:50:35 w icmpv6_send: no reply to icmp error
Apr  2 16:51:38 w icmpv6_send: no reply to icmp error
Apr  2 16:52:41 w icmpv6_send: no reply to icmp error
Apr  2 16:52:45 w sudo:  michael : TTY=pts/0 ; PWD=/home/michael ; USER=root ; COMMAND=/bin/cryptsetup luksOpen /dev/sdb local
Apr  2 16:52:51 w sudo:  michael : TTY=pts/1 ; PWD=/home/michael ; USER=root ; COMMAND=/usr/bin/tail -f /var/log/messages
Apr  2 16:53:43 w ntpd[4962]: synchronized to 134.34.3.19, stratum 1
Apr  2 16:53:43 w ntpd[4962]: kernel time sync status change 0001
Apr  2 16:54:12 w ata5.00: exception Emask 0x50 SAct 0x1 SErr 0x480901 action 0x6 frozen
Apr  2 16:54:12 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:12 w ata5: SError: { RecovData UnrecovData HostInt 10B8B Handshk }
Apr  2 16:54:12 w ata5.00: cmd 61/08:00:18:08:a4/00:00:18:00:00/40 tag 0 ncq 4096 out
Apr  2 16:54:12 w res 40/00:04:18:08:a4/00:00:18:00:00/40 Emask 0x50 (ATA bus error)
Apr  2 16:54:12 w ata5.00: status: { DRDY }
Apr  2 16:54:12 w ata5: hard resetting link
Apr  2 16:54:18 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 16:54:22 w ata5: COMRESET failed (errno=-16)
Apr  2 16:54:22 w ata5: hard resetting link
Apr  2 16:54:23 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 16:54:23 w ata5.00: configured for UDMA/133
Apr  2 16:54:23 w ata5: EH complete
Apr  2 16:54:23 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:23 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x480100 action 0x2 frozen
Apr  2 16:54:23 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:23 w ata5: SError: { UnrecovData 10B8B Handshk }
Apr  2 16:54:23 w ata5.00: cmd 61/20:00:18:08:d4/00:00:1b:00:00/40 tag 0 ncq 16384 out
Apr  2 16:54:23 w res 40/00:04:18:08:d4/00:00:1b:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:23 w ata5.00: status: { DRDY }
Apr  2 16:54:23 w ata5: soft resetting link
Apr  2 16:54:23 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 16:54:23 w ata5.00: configured for UDMA/133
Apr  2 16:54:23 w ata5: EH complete
Apr  2 16:54:23 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x480100 action 0x2 frozen
Apr  2 16:54:23 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:23 w ata5: SError: { UnrecovData 10B8B Handshk }
Apr  2 16:54:23 w ata5.00: cmd 61/20:00:18:08:d4/00:00:1b:00:00/40 tag 0 ncq 16384 out
Apr  2 16:54:23 w res 40/00:04:18:08:d4/00:00:1b:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:23 w ata5.00: status: { DRDY }
Apr  2 16:54:23 w ata5: soft resetting link
Apr  2 16:54:24 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  2 16:54:24 w ata5.00: configured for UDMA/133
Apr  2 16:54:24 w ata5: EH complete
Apr  2 16:54:24 w ata5: limiting SATA link speed to 1.5 Gbps
Apr  2 16:54:24 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x6 frozen
Apr  2 16:54:24 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:24 w ata5: SError: { UnrecovData Handshk }
Apr  2 16:54:24 w ata5.00: cmd 61/20:00:18:08:d4/00:00:1b:00:00/40 tag 0 ncq 16384 out
Apr  2 16:54:24 w res 40/00:04:18:08:d4/00:00:1b:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:24 w ata5.00: status: { DRDY }
Apr  2 16:54:24 w ata5: hard resetting link
Apr  2 16:54:29 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 16:54:34 w ata5: COMRESET failed (errno=-16)
Apr  2 16:54:34 w ata5: hard resetting link
Apr  2 16:54:34 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:34 w ata5.00: configured for UDMA/133
Apr  2 16:54:34 w ata5: EH complete
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:34 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:34 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
Apr  2 16:54:34 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:34 w ata5: SError: { UnrecovData Handshk }
Apr  2 16:54:34 w ata5.00: cmd 61/08:00:50:38:00/00:00:00:00:00/40 tag 0 ncq 4096 out
Apr  2 16:54:34 w res 40/00:04:50:38:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:34 w ata5.00: status: { DRDY }
Apr  2 16:54:35 w ata5: soft resetting link
Apr  2 16:54:35 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:35 w ata5.00: configured for UDMA/133
Apr  2 16:54:35 w ata5: EH complete
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:35 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x480100 action 0x2 frozen
Apr  2 16:54:35 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:35 w ata5: SError: { UnrecovData 10B8B Handshk }
Apr  2 16:54:35 w ata5.00: cmd 61/20:00:68:08:24/00:00:00:00:00/40 tag 0 ncq 16384 out
Apr  2 16:54:35 w res 40/00:04:68:08:24/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:35 w ata5.00: status: { DRDY }
Apr  2 16:54:35 w ata5: soft resetting link
Apr  2 16:54:35 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:35 w ata5.00: configured for UDMA/133
Apr  2 16:54:35 w ata5: EH complete
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:35 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:35 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
Apr  2 16:54:35 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:35 w ata5: SError: { UnrecovData Handshk }
Apr  2 16:54:35 w ata5.00: cmd 61/80:00:08:08:f4/00:00:01:00:00/40 tag 0 ncq 65536 out
Apr  2 16:54:35 w res 40/00:04:08:08:f4/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:35 w ata5.00: status: { DRDY }
Apr  2 16:54:36 w ata5: soft resetting link
Apr  2 16:54:36 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:36 w ata5.00: configured for UDMA/133
Apr  2 16:54:36 w ata5: EH complete
Apr  2 16:54:36 w ata5.00: limiting speed to UDMA/100:PIO4
Apr  2 16:54:36 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
Apr  2 16:54:36 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:36 w ata5: SError: { UnrecovData Handshk }
Apr  2 16:54:36 w ata5.00: cmd 61/80:00:08:08:f4/00:00:01:00:00/40 tag 0 ncq 65536 out
Apr  2 16:54:36 w res 40/00:04:08:08:f4/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:36 w ata5.00: status: { DRDY }
Apr  2 16:54:36 w ata5: soft resetting link
Apr  2 16:54:36 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:36 w ata5.00: configured for UDMA/100
Apr  2 16:54:36 w ata5: EH complete
Apr  2 16:54:36 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x480100 action 0x2 frozen
Apr  2 16:54:36 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:36 w ata5: SError: { UnrecovData 10B8B Handshk }
Apr  2 16:54:36 w ata5.00: cmd 61/80:00:08:08:f4/00:00:01:00:00/40 tag 0 ncq 65536 out
Apr  2 16:54:36 w res 40/00:04:08:08:f4/00:00:01:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:36 w ata5.00: status: { DRDY }
Apr  2 16:54:37 w ata5: soft resetting link
Apr  2 16:54:37 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:37 w ata5.00: configured for UDMA/100
Apr  2 16:54:37 w ata5: EH complete
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:37 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
Apr  2 16:54:37 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:37 w ata5: SError: { UnrecovData Handshk }
Apr  2 16:54:37 w ata5.00: cmd 61/80:00:08:08:5c/00:00:05:00:00/40 tag 0 ncq 65536 out
Apr  2 16:54:37 w res 40/00:04:08:08:5c/00:00:05:00:00/40 Emask 0x10 (ATA bus error)
Apr  2 16:54:37 w ata5.00: status: { DRDY }
Apr  2 16:54:37 w ata5: soft resetting link
Apr  2 16:54:37 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:37 w ata5.00: configured for UDMA/100
Apr  2 16:54:37 w ata5: EH complete
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:37 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:43 w ata5.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
Apr  2 16:54:43 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:43 w ata5: SError: { UnrecovData HostInt 10B8B BadCRC }
Apr  2 16:54:43 w ata5.00: cmd 60/08:00:50:74:9c/00:00:00:00:00/40 tag 0 ncq 4096 in
Apr  2 16:54:43 w res 40/00:04:50:74:9c/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
Apr  2 16:54:43 w ata5.00: status: { DRDY }
Apr  2 16:54:43 w ata5: hard resetting link
Apr  2 16:54:49 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 16:54:52 w icmpv6_send: no reply to icmp error
Apr  2 16:54:53 w ata5: COMRESET failed (errno=-16)
Apr  2 16:54:53 w ata5: hard resetting link
Apr  2 16:54:54 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:54:54 w ata5.00: configured for UDMA/100
Apr  2 16:54:54 w ata5: EH complete
Apr  2 16:54:54 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:54:54 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:54:54 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:54:54 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:54:58 w ata5.00: limiting speed to UDMA/33:PIO4
Apr  2 16:54:58 w ata5.00: exception Emask 0x50 SAct 0x1 SErr 0x880800 action 0x6 frozen
Apr  2 16:54:58 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:54:58 w ata5: SError: { HostInt 10B8B LinkSeq }
Apr  2 16:54:58 w ata5.00: cmd 60/08:00:88:03:f1/00:00:04:00:00/40 tag 0 ncq 4096 in
Apr  2 16:54:58 w res 40/00:04:80:e3:f0/00:00:04:00:00/40 Emask 0x50 (ATA bus error)
Apr  2 16:54:58 w ata5.00: status: { DRDY }
Apr  2 16:54:58 w ata5: hard resetting link
Apr  2 16:55:03 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 16:55:08 w ata5: COMRESET failed (errno=-16)
Apr  2 16:55:08 w ata5: hard resetting link
Apr  2 16:55:08 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:55:08 w ata5.00: configured for UDMA/33
Apr  2 16:55:08 w ata5: EH complete
Apr  2 16:55:08 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:55:08 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:55:08 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:55:08 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  2 16:55:14 w ata5.00: exception Emask 0x50 SAct 0x1 SErr 0xc80801 action 0x6 frozen
Apr  2 16:55:14 w ata5.00: irq_stat 0x08000000, interface fatal error
Apr  2 16:55:14 w ata5: SError: { RecovData HostInt 10B8B Handshk LinkSeq }
Apr  2 16:55:14 w ata5.00: cmd 60/08:00:d0:2e:39/00:00:09:00:00/40 tag 0 ncq 4096 in
Apr  2 16:55:14 w res 40/00:04:c8:0e:39/00:00:09:00:00/40 Emask 0x50 (ATA bus error)
Apr  2 16:55:14 w ata5.00: status: { DRDY }
Apr  2 16:55:14 w ata5: hard resetting link
Apr  2 16:55:20 w ata5: port is slow to respond, please be patient (Status 0x80)
Apr  2 16:55:25 w ata5: COMRESET failed (errno=-16)
Apr  2 16:55:25 w ata5: hard resetting link
Apr  2 16:55:25 w ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Apr  2 16:55:25 w ata5.00: configured for UDMA/33
Apr  2 16:55:25 w ata5: EH complete
Apr  2 16:55:25 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
Apr  2 16:55:25 w sd 5:0:0:0: [sdb] Write Protect is off
Apr  2 16:55:25 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  2 16:55:25 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--rJ8inJ6ig7iY3YX9--

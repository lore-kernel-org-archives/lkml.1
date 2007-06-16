Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXFPVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXFPVft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 17:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbXFPVfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 17:35:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:16082 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbXFPVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 17:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pIENAGz/ckBzuS803wRDh6a9Z6UTr7HPdi7nBf5UAc1gaDJtgFLZkG8RAZcAwjMVKbNPtNnJYNGPvvJwHj6XLLo+6uVl0oZDfBezuoGBlYwnrzWEurk0Jvl3X4Bf3tgrO5XdJo3aXf2otbtfMRZ6QVVgDOPUgfA7MMRT8RX4tmM=
Message-ID: <4bacf17f0706161435g1bb7c08bpd427901f64d57fa@mail.gmail.com>
Date: Sat, 16 Jun 2007 23:35:28 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: 2.6.20->2.6.21 - networking dies after random time
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi
after upgrading kernel from 2.6.20 to 2.6.21.3 i'm experiencing really
strange problem - my _both_ network cards dies after random uptime -
sometimes it's a few minutes, sometimes hours, sometimes it does not
happen for a couple of days...
today it happened for the first time without nvidia module and almost
immediately after system start

here is the output of some commands which might help debug this:

joi ~ # uname -a
Linux joi 2.6.21.3 #1 PREEMPT Thu Jun 7 15:50:27 CEST 2007 x86_64 AMD
Athlon(tm) 64 Processor 3200+ AuthenticAMD GNU/Linux

joi ~ # lsmod
Module                  Size  Used by
af_packet              15956  0
8250_pnp               12544  0
8250                   46568  1 8250_pnp
serial_core            21400  1 8250
tuner                  66600  0
tda9875                 9552  0
bttv                  247220  1
video_buf              24012  1 bttv
firmware_class         10048  1 bttv
ir_common              32708  1 bttv
compat_ioctl32          9920  1 bttv
i2c_algo_bit            8264  1 bttv
btcx_risc               5128  1 bttv
tveeprom               17808  1 bttv
videodev               28896  2 bttv
v4l2_common            18496  4 tuner,bttv,compat_ioctl32,videodev
v4l1_compat            14404  2 bttv,videodev
i2c_viapro             11288  0
ne2k_pci               11488  0
8390                    9928  1 ne2k_pci
i2c_core               22288  6
tuner,tda9875,bttv,i2c_algo_bit,tveeprom,i2c_viapro
skge                   40736  0

joi ~ # lspci -v
00:00.0 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Subsystem: ASUSTeK Computer Inc. A8V Deluxe
	Flags: bus master, 66MHz, medium devsel, latency 64
	Memory at e8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [80] AGP version 3.0
	Capabilities: [50] Power Management version 2
	Capabilities: [60] HyperTransport: Slave or Primary Interface
	Capabilities: [58] HyperTransport: Interrupt Discovery and Configuration

00:00.1 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Flags: bus master, medium devsel, latency 0

00:00.2 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Flags: bus master, medium devsel, latency 0

00:00.3 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Flags: bus master, medium devsel, latency 0

00:00.4 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Flags: bus master, medium devsel, latency 0

00:00.7 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
	Flags: bus master, medium devsel, latency 0

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
[K8T800/K8T890 South] (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: faf00000-fbffffff
	Prefetchable memory behind bridge: f0000000-f9ffffff
	Capabilities: [80] Power Management version 2

00:0a.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001
Gigabit Ethernet Controller (rev 13)
	Subsystem: ASUSTeK Computer Inc. Marvell 88E8001 Gigabit Ethernet
Controller (Asus)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
	Memory at fab00000 (32-bit, non-prefetchable) [size=16K]
	I/O ports at a800 [size=256]
	Expansion ROM at faa00000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data

00:0c.0 Ethernet controller: Compex ReadyLink 2000 (rev 0a)
	Flags: medium devsel, IRQ 17
	I/O ports at b000 [size=32]
	Expansion ROM at fac00000 [disabled] [size=32K]

00:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 18
	Memory at efe00000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

00:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 5
	Memory at eff00000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA
RAID Controller (rev 80)
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V Deluxe/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 20
	I/O ports at d000 [size=8]
	I/O ports at c800 [size=4]
	I/O ports at c400 [size=8]
	I/O ports at c000 [size=4]
	I/O ports at b800 [size=16]
	I/O ports at b400 [size=256]
	Capabilities: [c0] Power Management version 2

00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 20
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at fc00 [size=16]
	Capabilities: [c0] Power Management version 2

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at d400 [size=32]
	Capabilities: [80] Power Management version 2

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at d800 [size=32]
	Capabilities: [80] Power Management version 2

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 10
	I/O ports at e000 [size=32]
	Capabilities: [80] Power Management version 2

00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 10
	I/O ports at e400 [size=32]
	Capabilities: [80] Power Management version 2

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
(prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at fae00000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
	Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
	Subsystem: ASUSTeK Computer Inc. A8V Deluxe motherboard (Realtek ALC850 codec)
	Flags: medium devsel, IRQ 22
	I/O ports at e800 [size=256]
	Capabilities: [c0] Power Management version 2

00:11.6 Communication controller: VIA Technologies, Inc. AC'97 Modem
Controller (rev 80)
	Flags: medium devsel
	I/O ports at 1000 [disabled] [size=256]
	Capabilities: [d0] Power Management version 2

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel

01:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX
5200] (rev a1) (prog-if 00 [VGA])
	Subsystem: PROLINK Microsystems Corp Unknown device 1152
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Expansion ROM at faf00000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [44] AGP version 3.0

joi ~ # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:80:48:DE:5E:89
          inet addr:10.1.1.11  Bcast:10.1.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6 errors:37 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:956 (956.0 b)  TX bytes:5444 (5.3 Kb)
          Interrupt:17 Base address:0xb000

eth1      Link encap:Ethernet  HWaddr 00:11:D8:60:74:55
          inet addr:10.2.2.11  Bcast:10.2.2.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:17

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:310 errors:0 dropped:0 overruns:0 frame:0
          TX packets:310 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:34210 (33.4 Kb)  TX bytes:34210 (33.4 Kb)

joi ~ # route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.2.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth1
10.1.1.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0
127.0.0.0       0.0.0.0         255.0.0.0       U     0      0        0 lo
0.0.0.0         10.1.1.1        0.0.0.0         UG    0      0        0 eth0

joi ~ # zcat /proc/config.gz
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.21.3
# Thu Jun  7 15:40:35 2007
#
CONFIG_X86_64=y
CONFIG_64BIT=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ZONE_DMA32=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_DMI=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# Processor type and features
#
CONFIG_X86_PC=y
# CONFIG_X86_VSMP is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
# CONFIG_SMP is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_REORDER=y
CONFIG_K8_NB=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_PM_STD_PARTITION=""

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_ACPI_CPUFREQ=y

#
# shared options
#
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=m
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set

#
# IP: Virtual Server Configuration
#
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK_SUPPORT=y
# CONFIG_IP_NF_CONNTRACK_SUPPORT is not set
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=y
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
CONFIG_IP_NF_TARGET_REDIRECT=y
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_IP_NF_TARGET_SAME is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
# CONFIG_IP_NF_TARGET_ECN is not set
CONFIG_IP_NF_TARGET_TTL=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_IEEE80211 is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
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
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=m
# CONFIG_BLK_DEV_IDE is not set
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACPI=y
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
# CONFIG_MD is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Macintosh device drivers
#
# CONFIG_MAC_EMUMOUSEBTN is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_NET_SB1000 is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#
# CONFIG_PHYLIB is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set

#
# Tulip family network device support
#
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
CONFIG_SKGE=m
CONFIG_SKY2=m
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
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
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
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
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_STUB=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y

#
# Video Capture Adapters
#

#
# Video Capture Adapters
#
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_SAA6588 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set

#
# V4L USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set

#
# Radio Adapters
#
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_BUF=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

#
# Logo configuration
#
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=y

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=m
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set

#
# SoC audio support
#
# CONFIG_SND_SOC is not set

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID Devices
#
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set
# CONFIG_USB_GTCO is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
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
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_POLL=y

#
# Real Time Clock
#
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set

#
# RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_TEST is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set

#
# Auxiliary Display support
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-2"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=y

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
# Network File Systems
#
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_DIRECTIO is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
# CONFIG_NFSD_V4 is not set
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
CONFIG_FRAME_POINTER=y
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_DEBUG_RODATA=y
CONFIG_IOMMU_DEBUG=y
# CONFIG_IOMMU_LEAK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

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
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y

joi ~ # cat /proc/interrupts ; sleep 5; cat /proc/interrupts
           CPU0
  0:     891160   IO-APIC-edge      timer
  1:       2218   IO-APIC-edge      i8042
  8:          2   IO-APIC-edge      rtc
  9:          1   IO-APIC-fasteoi   acpi
 12:       9110   IO-APIC-edge      i8042
 14:          0   IO-APIC-edge      libata
 15:        122   IO-APIC-edge      libata
 17:         12   IO-APIC-fasteoi   eth1, eth0
 18:      57275   IO-APIC-fasteoi   bttv0
 20:      18810   IO-APIC-fasteoi   libata
 21:          0   IO-APIC-fasteoi   ehci_hcd:usb1
 22:      77945   IO-APIC-fasteoi   VIA8237
NMI:          0
LOC:     890924
ERR:          0
           CPU0
  0:     896221   IO-APIC-edge      timer
  1:       2219   IO-APIC-edge      i8042
  8:          2   IO-APIC-edge      rtc
  9:          1   IO-APIC-fasteoi   acpi
 12:       9110   IO-APIC-edge      i8042
 14:          0   IO-APIC-edge      libata
 15:        122   IO-APIC-edge      libata
 17:         12   IO-APIC-fasteoi   eth1, eth0
 18:      57654   IO-APIC-fasteoi   bttv0
 20:      18813   IO-APIC-fasteoi   libata
 21:          0   IO-APIC-fasteoi   ehci_hcd:usb1
 22:      78421   IO-APIC-fasteoi   VIA8237
NMI:          0
LOC:     895984
ERR:          0

joi ~ # cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0f.1
  0170-0177 : libata
01f0-01f7 : 0000:00:0f.1
  01f0-01f7 : libata
0290-0297 : pnp 00:09
02f8-02ff : serial
0376-0376 : 0000:00:0f.1
  0376-0376 : libata
03c0-03df : vesafb
03f6-03f6 : 0000:00:0f.1
  03f6-03f6 : libata
03f8-03ff : serial
0400-0407 : vt596_smbus
0680-06ff : pnp 00:09
0800-0803 : ACPI PM1a_EVT_BLK
0804-0805 : ACPI PM1a_CNT_BLK
0808-080b : ACPI PM_TMR
0810-0815 : ACPI CPU throttle
0820-0823 : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
1000-10ff : 0000:00:11.6
a800-a8ff : 0000:00:0a.0
  a800-a8ff : skge
b000-b01f : 0000:00:0c.0
  b000-b01f : ne2k-pci
b400-b4ff : 0000:00:0f.0
  b400-b4ff : sata_via
b800-b80f : 0000:00:0f.0
  b800-b80f : sata_via
c000-c003 : 0000:00:0f.0
  c000-c003 : sata_via
c400-c407 : 0000:00:0f.0
  c400-c407 : sata_via
c800-c803 : 0000:00:0f.0
  c800-c803 : sata_via
d000-d007 : 0000:00:0f.0
  d000-d007 : sata_via
d400-d41f : 0000:00:10.0
d800-d81f : 0000:00:10.1
e000-e01f : 0000:00:10.2
e400-e41f : 0000:00:10.3
e800-e8ff : 0000:00:11.5
  e800-e8ff : VIA8237
fc00-fc0f : 0000:00:0f.1
  fc00-fc0f : libata

joi ~ # cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000c0000-000dffff : pnp 00:0e
000e4000-000fffff : reserved
00100000-3ffaffff : System RAM
  00200000-0059ebc7 : Kernel code
  0059ebc8-0077248f : Kernel data
3ffb0000-3ffbffff : ACPI Tables
3ffc0000-3ffeffff : ACPI Non-volatile Storage
3fff0000-3fffffff : reserved
e8000000-ebffffff : 0000:00:00.0
  e8000000-ebffffff : aperture
efe00000-efe00fff : 0000:00:0d.0
  efe00000-efe00fff : bttv0
eff00000-eff00fff : 0000:00:0d.1
f0000000-f9ffffff : PCI Bus #01
  f0000000-f7ffffff : 0000:01:00.0
    f0000000-f7ffffff : vesafb
faa00000-faa1ffff : 0000:00:0a.0
fab00000-fab03fff : 0000:00:0a.0
  fab00000-fab03fff : skge
fac00000-fac07fff : 0000:00:0c.0
fae00000-fae000ff : 0000:00:10.4
  fae00000-fae000ff : ehci_hcd
faf00000-fbffffff : PCI Bus #01
  faf00000-faf1ffff : 0000:01:00.0
  fb000000-fbffffff : 0000:01:00.0
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0b
fee00000-fee00fff : Local APIC
ff780000-ffffffff : reserved

joi ~ # cat /proc/sys/kernel/tainted
0

joi ~ # dmesg
[    0.000000] Linux version 2.6.21.3 (root@joi) (gcc version 4.1.2
(Gentoo 4.1.2)) #1 PREEMPT Thu Jun 7 15:50:27 CEST 2007
[    0.000000] Command line: root=/dev/sda5 video=vesafb vga=794
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA810, 0021 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FFB0100, 003C (r1 A M I  OEMXSDT  10000427
MSFT       97)
[    0.000000] ACPI: FACP 3FFB0290, 00F4 (r3 A M I  OEMFACP  10000427
MSFT       97)
[    0.000000] ACPI: DSDT 3FFB03E0, 38A1 (r1  A0036 A0036001        1
MSFT  100000D)
[    0.000000] ACPI: FACS 3FFC0000, 0040
[    0.000000] ACPI: APIC 3FFB0390, 004A (r1 A M I  OEMAPIC  10000427
MSFT       97)
[    0.000000] ACPI: OEMB 3FFC0040, 003F (r1 A M I  OEMBIOS  10000427
MSFT       97)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262064
[    0.000000] On node 0 totalpages: 261967
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2545 pages reserved
[    0.000000]   DMA zone: 1398 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3526 pages used for memmap
[    0.000000]   DMA32 zone: 254442 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] Looks like a VIA chipset. Disabling IOMMU. Override
with iommu=allowed
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e4000
[    0.000000] Nosave address range: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:bf780000)
[    0.000000] Built 1 zonelists.  Total pages: 255840
[    0.000000] Kernel command line: root=/dev/sda5 video=vesafb vga=794
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[   17.511197] time.c: Detected 2002.657 MHz processor.
[   17.511257] Console: colour dummy device 80x25
[   17.511313] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[   17.511317] ... MAX_LOCKDEP_SUBCLASSES:    8
[   17.511320] ... MAX_LOCK_DEPTH:          30
[   17.511322] ... MAX_LOCKDEP_KEYS:        2048
[   17.511325] ... CLASSHASH_SIZE:           1024
[   17.511328] ... MAX_LOCKDEP_ENTRIES:     8192
[   17.511330] ... MAX_LOCKDEP_CHAINS:      16384
[   17.511333] ... CHAINHASH_SIZE:          8192
[   17.511336]  memory used by lock dependency info: 1648 kB
[   17.511338]  per task-struct memory footprint: 1680 bytes
[   17.512001] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   17.513096] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   17.525239] Memory: 1021364k/1048256k available (3706k kernel code,
26200k reserved, 1870k data, 224k init)
[   17.585125] Calibrating delay using timer specific routine..
4008.66 BogoMIPS (lpj=2004332)
[   17.585289] Mount-cache hash table entries: 256
[   17.585946] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   17.585950] CPU: L2 Cache: 512K (64 bytes/line)
[   17.585962] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
[   17.585973] ACPI: Core revision 20070126
[   17.593678] Parsing all Control Methods:
[   17.593786] Table [DSDT](id 0001) - 543 Objects with 51 Devices 146
Methods 25 Regions
[   17.593792]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables
successfully acquired
[   17.594016] evxfevnt-0091 [02] enable                : Transition
to ACPI mode successful
[   17.605121] Using local APIC timer interrupts.
[   17.655028] result 12516626
[   17.655030] Detected 12.516 MHz APIC timer.
[   17.655725] NET: Registered protocol family 16
[   17.656298] ACPI: bus type pci registered
[   17.656322] PCI: Using configuration type 1
[   17.663369] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 0F
[_GPE] 2 regs on int 0x9
[   17.668443] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 7
Wake, Enabled 0 Runtime GPEs in this block
[   17.668873] Completing Region/Field/Buffer/Package
initialization:..........................................................................................................................
[   17.678560] Initialized 24/25 Regions 44/44 Fields 41/41 Buffers
13/14 Packages (552 nodes)
[   17.678565] Initializing Device/Processor/Thermal objects by
executing _INI methods:
[   17.678613] Executed 0 _INI methods requiring 0 _STA executions
(examined 54 objects)
[   17.678693] ACPI: Interpreter enabled
[   17.678697] ACPI: (supports S0 S1 S3 S4 S5)
[   17.678783] ACPI: Using IOAPIC for interrupt routing
[   17.707465] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   17.707514] PCI: Probing PCI hardware (bus 00)
[   17.709002] PCI: enabled onboard AC97/MC97 devices
[   17.709548] Boot video device is 0000:01:00.0
[   17.709610] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   17.738092] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
[   17.738383] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
[   17.738628] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
[   17.738871] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 14
15) *0, disabled.
[   17.739131] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14
15) *0, disabled.
[   17.739377] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14
15) *0, disabled.
[   17.739632] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14
15) *0, disabled.
[   17.739878] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14
15) *0, disabled.
[   17.740118] Linux Plug and Play Support v0.97 (c) Adam Belay
[   17.740159] pnp: PnP ACPI init
[   17.753273] pnp: PnP ACPI: found 15 devices
[   17.754625] SCSI subsystem initialized
[   17.754719] libata version 2.20 loaded.
[   17.754970] usbcore: registered new interface driver usbfs
[   17.755123] usbcore: registered new interface driver hub
[   17.755273] usbcore: registered new device driver usb
[   17.755485] PCI: Using ACPI for IRQ routing
[   17.755490] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   17.755864] agpgart: Detected AGP bridge 0
[   17.758985] agpgart: AGP aperture is 64M @ 0xe8000000
[   17.759247] pnp: 00:09: ioport range 0x680-0x6ff has been reserved
[   17.759253] pnp: 00:09: ioport range 0x290-0x297 has been reserved
[   17.759274] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   17.759280] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not
be reserved
[   17.759287] pnp: 00:0b: iomem range 0xfff80000-0xffffffff could not
be reserved
[   17.759301] pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
[   17.759306] pnp: 00:0e: iomem range 0xc0000-0xdffff has been reserved
[   17.759311] pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[   17.759317] pnp: 00:0e: iomem range 0x100000-0x3ffeffff could not be reserved
[   17.759971] Time: tsc clocksource has been installed.
[   17.760625] PCI: Bridge: 0000:00:01.0
[   17.760628]   IO window: disabled.
[   17.760635]   MEM window: faf00000-fbffffff
[   17.760640]   PREFETCH window: f0000000-f9ffffff
[   17.760661] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   17.760719] NET: Registered protocol family 2
[   17.770070] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   17.770513] TCP established hash table entries: 32768 (order: 9,
2621440 bytes)
[   17.773296] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[   17.776992] TCP: Hash tables configured (established 32768 bind 32768)
[   17.777026] TCP reno registered
[   17.782888] Total HugeTLB memory allocated, 0
[   17.783972] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.785404] NTFS driver 2.1.28 [Flags: R/W].
[   17.785453] fuse init (API version 7.8)
[   17.785983] io scheduler noop registered
[   17.786002] io scheduler cfq registered (default)
[   17.786788] vesafb: framebuffer at 0xf0000000, mapped to
0xffffc20000080000, using 5120k, total 131072k
[   17.786794] vesafb: mode is 1280x1024x16, linelength=2560, pages=1
[   17.786797] vesafb: scrolling: redraw
[   17.786801] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   17.847503] Console: switching to colour frame buffer device 160x64
[   17.903185] fb0: VESA VGA frame buffer device
[   17.903983] input: Power Button (FF) as /class/input/input0
[   17.904368] ACPI: Power Button (FF) [PWRF]
[   17.904879] input: Power Button (CM) as /class/input/input1
[   17.905258] ACPI: Power Button (CM) [PWRB]
[   17.905730] input: Sleep Button (CM) as /class/input/input2
[   17.906119] ACPI: Sleep Button (CM) [SLPB]
[   18.004911] Real Time Clock Driver v1.12ac
[   18.005504] Linux agpgart interface v0.102 (c) Dave Jones
[   18.005921] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[   18.006523] Hangcheck: Using get_cycles().
[   18.009294] RAMDISK driver initialized: 16 RAM disks of 4096K size
1024 blocksize
[   18.011097] loop: loaded (max 8 devices)
[   18.012275] sata_via 0000:00:0f.0: version 2.1
[   18.012299] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level,
low) -> IRQ 20
[   18.012880] sata_via 0000:00:0f.0: routed to hard irq line 10
[   18.013465] ata1: SATA max UDMA/133 cmd 0x000000000001d000 ctl
0x000000000001c802 bmdma 0x000000000001b800 irq 20
[   18.014269] ata2: SATA max UDMA/133 cmd 0x000000000001c400 ctl
0x000000000001c002 bmdma 0x000000000001b808 irq 20
[   18.015015] scsi0 : sata_via
[   18.215597] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   18.377226] ATA: abnormal status 0x7F on port 0x000000000001d007
[   18.388373] ATA: abnormal status 0x7F on port 0x000000000001d007
[   18.407612] ata1.00: ATA-6: WDC WD1600JD-00HBB0, 08.02D08, max UDMA/133
[   18.408057] ata1.00: 312581808 sectors, multi 16: LBA48
[   18.428592] ata1.00: configured for UDMA/133
[   18.428884] scsi1 : sata_via
[   18.629253] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[   18.640401] ATA: abnormal status 0x7F on port 0x000000000001c407
[   18.641197] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD1600JD-00H 08.0 PQ: 0 ANSI: 5
[   18.642312] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   18.642783] sda: Write Protect is off
[   18.643029] sda: Mode Sense: 00 3a 00 00
[   18.643068] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   18.644082] SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
[   18.644562] sda: Write Protect is off
[   18.644808] sda: Mode Sense: 00 3a 00 00
[   18.644848] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   18.657587]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   18.739693] sd 0:0:0:0: Attached scsi disk sda
[   18.753236] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.766788] pata_via 0000:00:0f.1: version 0.2.1
[   18.766825] ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level,
low) -> IRQ 20
[   18.780893] ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x000000000001fc00 irq 14
[   18.795638] ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x000000000001fc08 irq 15
[   18.810392] scsi2 : pata_via
[   18.987153] ATA: abnormal status 0x8 on port 0x00000000000101f7
[   19.002426] scsi3 : pata_via
[   19.338867] ata4.00: ATAPI, max UDMA/33
[   19.526702] ata4.00: configured for UDMA/33
[   19.546278] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM
GSA-4163B A102 PQ: 0 ANSI: 5
[   19.581395] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw
xa/form2 cdda tray
[   19.598259] Uniform CD-ROM driver Revision: 3.20
[   19.615547] sr 3:0:0:0: Attached scsi CD-ROM sr0
[   19.615797] sr 3:0:0:0: Attached scsi generic sg1 type 5
[   19.633197] usbmon: debugfs is not available
[   19.650873] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level,
low) -> IRQ 21
[   19.669010] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   19.688035] ehci_hcd 0000:00:10.4: new USB bus registered, assigned
bus number 1
[   19.706878] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfae00000
[   19.725790] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   19.745737] usb usb1: configuration #1 chosen from 1 choice
[   19.765495] hub 1-0:1.0: USB hub found
[   19.785228] hub 1-0:1.0: 8 ports detected
[   19.906099] Initializing USB Mass Storage driver...
[   19.925631] usbcore: registered new interface driver usb-storage
[   19.945142] USB Mass Storage support registered.
[   19.964717] usbcore: registered new interface driver usbhid
[   19.984207] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   20.004010] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[   20.024360] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.044336] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.064429] mice: PS/2 mouse device common for all mice
[   20.115006] input: AT Translated Set 2 keyboard as /class/input/input3
[   20.138797] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   20.158793] rtc_cmos: probe of 00:02 failed with error -16
[   20.178448] EDAC MC: Ver: 2.0.1 Jun  7 2007
[   20.198116] Advanced Linux Sound Architecture Driver Version
1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[   20.777234] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
[   20.799815] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level,
low) -> IRQ 22
[   20.819596] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   21.335049] ALSA device list:
[   21.354477]   #0: VIA 8237 with ALC850 at 0xe800, irq 22
[   21.373876] oprofile: using NMI interrupt.
[   21.393083] Netfilter messages via NETLINK v0.30.
[   21.412153] nf_conntrack version 0.5.0 (4094 buckets, 32752 max)
[   21.432062] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.451553] TCP cubic registered
[   21.470706] Initializing XFRM netlink socket
[   21.489957] NET: Registered protocol family 1
[   21.509414] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+
processors (version 2.00.00)
[   21.529336] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
[   21.548913] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[   21.568149] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   21.587571] powernow-k8: ph2 null fid transition 0xc
[   21.606488] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   21.651906] kjournald starting.  Commit interval 5 seconds
[   21.670685] EXT3-fs: mounted filesystem with ordered data mode.
[   21.689468] VFS: Mounted root (ext3 filesystem) readonly.
[   21.707977] Freeing unused kernel memory: 224k freed
[   21.726533] Write protecting the kernel read-only data: 1457k
[   25.734316] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   25.734367] skge 1.10 addr 0xfab00000 irq 17 chip Yukon-Lite rev 9
[   25.734763] skge eth0: addr 00:11:d8:60:74:55
[   25.971279] ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
[   25.971282]   http://www.scyld.com/network/ne2k-pci.html
[   25.971364] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   25.971691] eth1: Compex RL2000 found at 0xb000, IRQ 17, 00:80:48:DE:5E:89.
[   26.888372] Linux video capture interface: v2.00
[   26.906732] bttv: driver version 0.9.17 loaded
[   26.906736] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   26.906849] bttv: Bt8xx card found (0).
[   26.906879] ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 18 (level,
low) -> IRQ 18
[   26.906893] bttv0: Bt878 (rev 17) at 0000:00:0d.0, irq: 18,
latency: 64, mmio: 0xefe00000
[   26.906904] bttv0: using: Lifeview FlyVideo 2000 /FlyVideo A2/
Lifetec LT 9415 TV [LR90] [card=54,insmod option]
[   26.906940] bttv0: gpio: en=00000000, out=00000000 in=00d4dfe0 [init]
[   26.908154] bttv0: FlyVideo Radio=yes RemoteControl=yes Tuner=5 gpio=0xd4dfe0
[   26.908156] bttv0: FlyVideo  LR90=yes tda9821/tda9820=no  capture_only=no
[   26.908159] bttv0: using tuner=5
[   26.908163] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[   26.908937] bttv0: i2c: checking for TDA9875 @ 0xb0... found
[   26.947748] tda9875: no such chip at 0xb0 (dic=0x7 rev=0x7)
[   26.947754] i2c_adapter i2c-1: Client creation failed at 0x58 (1)
[   26.947985] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   26.948737] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   27.018263] tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
[   27.018793] tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and
compatibles))
[   27.018798] tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216 and
compatibles))
[   27.029818] bttv0: registered device video0
[   27.029879] bttv0: registered device vbi0
[   27.029936] bttv0: registered device radio0
[   27.029956] bttv0: PLL: 28636363 => 35468950 .. ok
[   28.653502] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing disabled
[   28.654090] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   28.654849] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   28.657697] 00:0c: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   28.658065] 00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   30.614971] EXT3 FS on sda5, internal journal
[   31.462040] kjournald starting.  Commit interval 5 seconds
[   31.462417] EXT3 FS on sda6, internal journal
[   31.462426] EXT3-fs: mounted filesystem with ordered data mode.
[   31.481603] kjournald starting.  Commit interval 5 seconds
[   31.481897] EXT3 FS on sda8, internal journal
[   31.481905] EXT3-fs: mounted filesystem with ordered data mode.
[   31.498576] kjournald starting.  Commit interval 5 seconds
[   31.498958] EXT3 FS on sda10, internal journal
[   31.498965] EXT3-fs: mounted filesystem with ordered data mode.
[   31.522075] kjournald starting.  Commit interval 5 seconds
[   31.522447] EXT3 FS on sda7, internal journal
[   31.522455] EXT3-fs: mounted filesystem with ordered data mode.
[   31.659572] Adding 1020112k swap on /dev/sda2.  Priority:-1
extents:1 across:1020112k
[   42.681974] skge eth1: enabling interface
[   43.228729] NET: Registered protocol family 17
[   46.429756] Time: acpi_pm clocksource has been installed.
[   50.743512] NETDEV WATCHDOG: eth0: transmit timed out
[   50.743521] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=574.
[   51.742678] NETDEV WATCHDOG: eth0: transmit timed out
[   51.742687] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=968.
[   55.474190] NETDEV WATCHDOG: eth0: transmit timed out
[   55.474200] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3544.
[   74.198613] NETDEV WATCHDOG: eth0: transmit timed out
[   74.198623] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=13048.
[   80.193566] NETDEV WATCHDOG: eth0: transmit timed out
[   80.193576] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1120.
[   83.151680]
[   83.151682] =======================================================
[   83.151688] [ INFO: possible circular locking dependency detected ]
[   83.151691] 2.6.21.3 #1
[   83.151693] -------------------------------------------------------
[   83.151695] tvtime/6682 is trying to acquire lock:
[   83.151697]  (&mm->mmap_sem){----}, at: [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[   83.151710]
[   83.151711] but task is already holding lock:
[   83.151713]  (&q->lock#2){--..}, at: [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.151723]
[   83.151724] which lock already depends on the new lock.
[   83.151725]
[   83.151726]
[   83.151727] the existing dependency chain (in reverse order) is:
[   83.151729]
[   83.151730] -> #1 (&q->lock#2){--..}:
[   83.151733]        [<ffffffff802a6922>] __lock_acquire+0xc82/0xf30
[   83.151742]        [<ffffffff8805e86f>] bttv_do_ioctl+0x152f/0x2460 [bttv]
[   83.151763]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.151770]        [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[   83.151776]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.151782]        [<ffffffff802671dc>] __mutex_lock_slowpath+0xec/0x2a0
[   83.151789]        [<ffffffff80207131>] check_poison_obj+0x31/0x1f0
[   83.151796]        [<ffffffff802c979b>] kmem_cache_zalloc+0x8b/0xe0
[   83.151803]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.151810]        [<ffffffff880528bc>]
videobuf_mmap_mapper+0x1c/0x290 [video_buf]
[   83.151819]        [<ffffffff8805bfcb>] bttv_mmap+0x5b/0x60 [bttv]
[   83.151830]        [<ffffffff8020dc83>] do_mmap_pgoff+0x4e3/0x800
[   83.151837]        [<ffffffff8026921b>] _spin_unlock_irq+0x2b/0x60
[   83.151843]        [<ffffffff8022455b>] sys_mmap+0x9b/0x130
[   83.151849]        [<ffffffff8025f71e>] system_call+0x7e/0x83
[   83.151856]        [<ffffffffffffffff>] 0xffffffffffffffff
[   83.151886]
[   83.151886] -> #0 (&mm->mmap_sem){----}:
[   83.151889]        [<ffffffff802a67de>] __lock_acquire+0xb3e/0xf30
[   83.151896]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[   83.151905]        [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[   83.151911]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[   83.151920]        [<ffffffff802a1098>] down_read+0x28/0x40
[   83.151926]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[   83.151934]        [<ffffffff802a572b>] trace_hardirqs_on+0x14b/0x180
[   83.151940]        [<ffffffff880540bc>] videobuf_iolock+0x9c/0x100
[video_buf]
[   83.151949]        [<ffffffff8805bece>]
bttv_prepare_buffer+0x2ae/0x310 [bttv]
[   83.151961]        [<ffffffff8805bf62>] buffer_prepare+0x32/0x40 [bttv]
[   83.151973]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.151979]        [<ffffffff880548ca>] videobuf_qbuf+0x2ea/0x3a0 [video_buf]
[   83.151988]        [<ffffffff8805e8ab>] bttv_do_ioctl+0x156b/0x2460 [bttv]
[   83.152000]        [<ffffffff802a6b39>] __lock_acquire+0xe99/0xf30
[   83.152006]        [<ffffffff80209225>] __handle_mm_fault+0xb45/0xb80
[   83.152012]        [<ffffffff80222b4a>] __up_read+0x2a/0xa0
[   83.152019]        [<ffffffff8802ec09>] video_usercopy+0x189/0x250 [videodev]
[   83.152029]        [<ffffffff8805d340>] bttv_do_ioctl+0x0/0x2460 [bttv]
[   83.152041]        [<ffffffff8026b8cb>] do_page_fault+0x4bb/0x8f0
[   83.152047]        [<ffffffff8023136a>] __up_write+0xfa/0x110
[   83.152054]        [<ffffffff802691b5>] _spin_unlock_irqrestore+0x45/0x80
[   83.152060]        [<ffffffff8805c0af>] bttv_ioctl+0x6f/0x80 [bttv]
[   83.152072]        [<ffffffff80242ebb>] do_ioctl+0x6b/0xa0
[   83.152079]        [<ffffffff8023124b>] vfs_ioctl+0x2ab/0x2d0
[   83.152085]        [<ffffffff8024de1a>] sys_ioctl+0x4a/0x80
[   83.152091]        [<ffffffff8025f71e>] system_call+0x7e/0x83
[   83.152097]        [<ffffffffffffffff>] 0xffffffffffffffff
[   83.152104]
[   83.152105] other info that might help us debug this:
[   83.152106]
[   83.152108] 1 lock held by tvtime/6682:
[   83.152110]  #0:  (&q->lock#2){--..}, at: [<ffffffff80267399>]
mutex_lock+0x9/0x10
[   83.152117]
[   83.152117] stack backtrace:
[   83.152119]
[   83.152120] Call Trace:
[   83.152124]  [<ffffffff802a47a6>] print_circular_bug_tail+0x76/0x90
[   83.152130]  [<ffffffff802a67de>] __lock_acquire+0xb3e/0xf30
[   83.152137]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[   83.152141]  [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[   83.152147]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[   83.152151]  [<ffffffff802a1098>] down_read+0x28/0x40
[   83.152157]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[   83.152161]  [<ffffffff802a572b>] trace_hardirqs_on+0x14b/0x180
[   83.152168]  [<ffffffff880540bc>] :video_buf:videobuf_iolock+0x9c/0x100
[   83.152177]  [<ffffffff8805bece>] :bttv:bttv_prepare_buffer+0x2ae/0x310
[   83.152188]  [<ffffffff8805bf62>] :bttv:buffer_prepare+0x32/0x40
[   83.152192]  [<ffffffff80267399>] mutex_lock+0x9/0x10
[   83.152198]  [<ffffffff880548ca>] :video_buf:videobuf_qbuf+0x2ea/0x3a0
[   83.152208]  [<ffffffff8805e8ab>] :bttv:bttv_do_ioctl+0x156b/0x2460
[   83.152213]  [<ffffffff802a6b39>] __lock_acquire+0xe99/0xf30
[   83.152216]  [<ffffffff80209225>] __handle_mm_fault+0xb45/0xb80
[   83.152221]  [<ffffffff80222b4a>] __up_read+0x2a/0xa0
[   83.152228]  [<ffffffff8802ec09>] :videodev:video_usercopy+0x189/0x250
[   83.152237]  [<ffffffff8805d340>] :bttv:bttv_do_ioctl+0x0/0x2460
[   83.152243]  [<ffffffff8026b8cb>] do_page_fault+0x4bb/0x8f0
[   83.152247]  [<ffffffff8023136a>] __up_write+0xfa/0x110
[   83.152251]  [<ffffffff802691b5>] _spin_unlock_irqrestore+0x45/0x80
[   83.152261]  [<ffffffff8805c0af>] :bttv:bttv_ioctl+0x6f/0x80
[   83.152265]  [<ffffffff80242ebb>] do_ioctl+0x6b/0xa0
[   83.152269]  [<ffffffff8023124b>] vfs_ioctl+0x2ab/0x2d0
[   83.152274]  [<ffffffff8024de1a>] sys_ioctl+0x4a/0x80
[   83.152278]  [<ffffffff8025f71e>] system_call+0x7e/0x83
[   83.152282]
[   99.976561] NETDEV WATCHDOG: eth0: transmit timed out
[   99.976571] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=18920.
[  101.974844] NETDEV WATCHDOG: eth0: transmit timed out
[  101.974854] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1063.
[  114.963920] NETDEV WATCHDOG: eth0: transmit timed out
[  114.963929] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  118.960509] NETDEV WATCHDOG: eth0: transmit timed out
[  118.960519] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3677.
[  120.958807] NETDEV WATCHDOG: eth0: transmit timed out
[  120.958817] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  124.955449] NETDEV WATCHDOG: eth0: transmit timed out
[  124.955459] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  128.952086] NETDEV WATCHDOG: eth0: transmit timed out
[  128.952097] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3677.
[  130.950413] NETDEV WATCHDOG: eth0: transmit timed out
[  130.950424] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  134.947052] NETDEV WATCHDOG: eth0: transmit timed out
[  134.947063] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  138.943655] NETDEV WATCHDOG: eth0: transmit timed out
[  138.943664] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3677.
[  140.941916] NETDEV WATCHDOG: eth0: transmit timed out
[  140.941930] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1677.
[  142.940200] NETDEV WATCHDOG: eth0: transmit timed out
[  142.940210] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1315.
[  146.936806] NETDEV WATCHDOG: eth0: transmit timed out
[  146.936816] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3315.
[  148.935129] NETDEV WATCHDOG: eth0: transmit timed out
[  148.935139] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1315.
[  152.931784] NETDEV WATCHDOG: eth0: transmit timed out
[  152.931793] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1148.
[  157.128279] NETDEV WATCHDOG: eth0: transmit timed out
[  157.128289] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3348.
[  159.126602] NETDEV WATCHDOG: eth0: transmit timed out
[  159.126612] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1098.
[  163.123252] NETDEV WATCHDOG: eth0: transmit timed out
[  163.123261] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1081.
[  167.119904] NETDEV WATCHDOG: eth0: transmit timed out
[  167.119914] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3081.
[  169.118229] NETDEV WATCHDOG: eth0: transmit timed out
[  169.118238] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1070.
[  173.114889] NETDEV WATCHDOG: eth0: transmit timed out
[  173.114899] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1068.
[  177.111541] NETDEV WATCHDOG: eth0: transmit timed out
[  177.111550] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3068.
[  179.109876] NETDEV WATCHDOG: eth0: transmit timed out
[  179.109886] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1050.
[  181.907535] NETDEV WATCHDOG: eth0: transmit timed out
[  181.907545] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1749.
[  185.904172] NETDEV WATCHDOG: eth0: transmit timed out
[  185.904181] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3749.
[  187.902486] NETDEV WATCHDOG: eth0: transmit timed out
[  187.902495] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1716.
[  190.117822] NETDEV WATCHDOG: eth0: transmit timed out
[  190.117829] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1716.
[  193.216177] NETDEV WATCHDOG: eth0: transmit timed out
[  193.216186] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=3716.
[  194.875859] NETDEV WATCHDOG: eth0: transmit timed out
[  194.875867] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1716.
[  196.501453] NETDEV WATCHDOG: eth0: transmit timed out
[  196.501463] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1284.
[  202.139166] NETDEV WATCHDOG: eth0: transmit timed out
[  202.139177] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=5284.
[  204.137408] NETDEV WATCHDOG: eth0: transmit timed out
[  204.137418] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1716.
[ 1082.361982] NETDEV WATCHDOG: eth0: transmit timed out
[ 1082.361992] eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=1595.
[ 1728.265787] SysRq : HELP : loglevel0-8 reBoot show-all-locks(D)
tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q)
unRaw Sync showTasks Unmount shoW-blocked-tasks
[ 1735.031451] SysRq : Show Locks Held
[ 1735.034661] INFO: lockdep is turned off.
[ 1744.147377] SysRq : Show Blocked State
[ 1744.150495]
[ 1744.150496]                                  free
     sibling
[ 1744.156651]   task                 PC        stack   pid father
child younger older
[ 1748.875823] SysRq : Show Pending Timers
[ 1748.878848] Timer List Version: v0.3
[ 1748.881915] HRTIMER_MAX_CLOCK_BASES: 2
[ 1748.885010] now at 1760032463351 nsecs
[ 1748.888118]
[ 1748.888119] cpu: 0
[ 1748.894271]  clock 0:
[ 1748.897346]   .index:      0
[ 1748.900437]   .resolution: 999848 nsecs
[ 1748.903564]   .get_time:   ktime_get_real
[ 1748.906745] active timers:
[ 1748.909912]  clock 1:
[ 1748.913070]   .index:      1
[ 1748.916215]   .resolution: 999848 nsecs
[ 1748.919378]   .get_time:   ktime_get
[ 1748.922554] active timers:
[ 1748.925714]  #0: boot_cpu_stack, hrtimer_wakeup, S:01
[ 1748.928965]  # expires at 1760119651898 nsecs [in 87188547 nsecs]
[ 1748.932263]  #1: boot_cpu_stack, hrtimer_wakeup, S:01
[ 1748.935622]  # expires at 1760219870837 nsecs [in 187407486 nsecs]
[ 1748.939053]  #2: boot_cpu_stack, it_real_fn, S:01
[ 1748.942535]  # expires at 1760800565617 nsecs [in 768102266 nsecs]
[ 1748.946096]  #3: boot_cpu_stack, hrtimer_wakeup, S:01
[ 1748.949718]  # expires at 1773728730197 nsecs [in 13696266846 nsecs]
[ 1748.953418]  #4: boot_cpu_stack, hrtimer_wakeup, S:01
[ 1748.957176]  # expires at 1796984578892 nsecs [in 36952115541 nsecs]
[ 1748.961006]
[ 1751.914626] SysRq : Show Regs
[ 1751.918450] CPU 0:
[ 1751.922232] Modules linked in: af_packet 8250_pnp 8250 serial_core
tuner tda9875 bttv video_buf firmware_class ir_common compat_ioctl32
i2c_algo_bit btcx_risc tveeprom videodev v4l2_common v4l1_compat
i2c_viapro ne2k_pci 8390 i2c_core skge
[ 1751.930863] Pid: 0, comm: swapper Not tainted 2.6.21.3 #1
[ 1751.935266] RIP: 0010:[<ffffffff80270294>]  [<ffffffff80270294>]
default_idle+0x34/0x60
[ 1751.939830] RSP: 0018:ffffffff80789f58  EFLAGS: 00000246
[ 1751.944415] RAX: 0000000000000000 RBX: ffffffff80789f58 RCX: 0000000000000000
[ 1751.949110] RDX: ffffffff8071d520 RSI: 0000000000000001 RDI: ffffffff807216e8
[ 1751.953862] RBP: ffffffff8071d520 R08: 0000000000000002 R09: 0000000000000001
[ 1751.958657] R10: 000000000000000a R11: 0000000000000246 R12: 0000000000000000
[ 1751.963493] R13: ffffffff8071d520 R14: ffffffff80788000 R15: 0000000000000001
[ 1751.968369] FS:  00002b4c40667330(0000) GS:ffffffff80773000(0000)
knlGS:0000000000000000
[ 1751.973348] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1751.978380] CR2: 00002b0c97a74000 CR3: 00000000349a2000 CR4: 00000000000006e0
[ 1751.983506]
[ 1751.983507] Call Trace:
[ 1751.993715]  [<ffffffff80270292>] default_idle+0x32/0x60
[ 1751.998871]  [<ffffffff8024a99f>] cpu_idle+0x4f/0x90
[ 1752.003842]  [<ffffffff8026f884>] rest_init+0x44/0x50
[ 1752.008623]  [<ffffffff8078ba0f>] start_kernel+0x29f/0x2b0
[ 1752.013421]  [<ffffffff8078b143>] _sinittext+0x143/0x150
[ 1752.018263]

i already reported this "possible circular locking dependency detected
" problem: http://lkml.org/lkml/2007/6/7/185 but nobody responded so
far...

if you want some additional informations just ask

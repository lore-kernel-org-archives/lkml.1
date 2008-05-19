Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYESLeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYESLeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 07:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYESLdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 07:33:54 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:58393 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbYESLdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 07:33:52 -0400
Message-ID: <4831658F.2020306@linux.vnet.ibm.com>
Date: Mon, 19 May 2008 17:03:35 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: 2.6.26-rc2-mm1 - machine stuck while booting up with CONFIG_FTRACE_STARTUP_TEST
 enabled
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.26-rc2-mm1 kernel gets stuck, while booting up on x86_64 machine,
with the CONFIG_FTRACE_STARTUP_TEST enabled. The following .config
options related to FTRACE are enabled. 

CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_FTRACE=y
CONFIG_HAVE_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000d7fcca00 (usable)
 BIOS-e820: 00000000d7fcca00 - 00000000d7fd0000 (ACPI data)
 BIOS-e820: 00000000d7fd0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001e8000000 (usable)
max_pfn_mapped = 1998848
init_memory_mapping
DMI 2.3 present.
ACPI: RSDP 000FDFB0, 0024 (r2 IBM   )
ACPI: XSDT D7FCFF00, 0044 (r1 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: FACP D7FCFE40, 0084 (r2 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: DSDT D7FCCA00, 2AA0 (r2 IBM    SERTURQU     1000 INTL 20041203)
ACPI: FACS D7FCFD00, 0040
ACPI: APIC D7FCFD80, 00B4 (r1 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: MCFG D7FCFD40, 003C (r1 IBM    SERONYXP     1001 IBM  45444F43)
ACPI: SSDT D7FCFA40, 02BD (r2 IBM    YETA0        1000 INTL 20041203)
No NUMA configuration found
Faking a node at 0000000000000000-00000001e8000000
Bootmem setup node 0 0000000000000000-00000001e8000000
  NODE_DATA [0000000000011000 - 0000000000016fff]
  bootmap [0000000000017000 -  0000000000053fff] pages 3d
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-b4e40b] TEXT DATA BSS
  early res: 3 [37e81000-37fefaa0] RAMDISK
  early res: 4 [9dc00-fffff] BIOS reserved
  early res: 5 [8000-10fff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1998848
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      157
    0:      256 ->   884684
    0:  1048576 ->  1998848
ACPI: PM-Timer IO Port: 0x588
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec84000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 0, address 0xfec84000, GSI 24-47
ACPI: IOAPIC (id[0x0c] address[0xfec84400] gsi_base[48])
IOAPIC[2]: apic_id 12, version 0, address 0xfec84400, GSI 48-71
ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
IOAPIC[3]: apic_id 11, version 0, address 0xfec80000, GSI 72-95
ACPI: IOAPIC (id[0x0a] address[0xfec80400] gsi_base[96])
IOAPIC[4]: apic_id 10, version 0, address 0xfec80400, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at dc000000 (gap: d8000000:26c00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 68784 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1805035
Policy zone: Normal
Kernel command line: root=/dev/sda1 ro console=tty0 console=ttyS0,38400n1 noapci IDENT=1211176695
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 3600.172 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x4000000 - 0x8000000
Memory: 7159284k/7995392k available (3736k kernel code, 180144k reserved, 1578k data, 328k init)
Calibrating delay using timer specific routine.. 7204.92 BogoMIPS (lpj=3602463)
Security Framework initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
ACPI: Core revision 20080321
CPU0:                   Intel(R) Xeon(TM) CPU 3.60GHz stepping 03
Using local APIC timer interrupts.
Detected 12.500 MHz APIC timer.
Booting processor 1/6 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 7200.17 BogoMIPS (lpj=3600089)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 1/6 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
CPU1:                   Intel(R) Xeon(TM) CPU 3.60GHz stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 7200.18 BogoMIPS (lpj=3600090)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
CPU2:                   Intel(R) Xeon(TM) CPU 3.60GHz stepping 03
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/7 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 7200.18 BogoMIPS (lpj=3600094)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 3/7 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM2)
CPU3:                   Intel(R) Xeon(TM) CPU 3.60GHz stepping 03
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (28805.47 BogoMIPS).
net_namespace: 1224 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG support.
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0580-05ff claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0400-043f claimed by ICH4 GPIO
pci 0000:02:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:02:00.2: PXH quirk detected; SHPC device MSI disabled
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LP00] (IRQs *3)
ACPI: PCI Interrupt Link [LP01] (IRQs *11)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP02] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP03] (IRQs *5)
ACPI: PCI Interrupt Link [LP04] (IRQs *11)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP06] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP07] (IRQs *7)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Cannot allocate resource region 1 of device 0000:00:00.0
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 898 pages allocated for 65536<6> entries of 56 bytes
   actual entries 65554
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x540-0x547 has been reserved
system 00:0d: ioport range 0x400-0x43f has been reserved
system 00:0d: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x540-0x55f could not be reserved
system 00:0d: ioport range 0x580-0x5ff has been reserved
system 00:0d: ioport range 0x800-0x80f has been reserved
system 00:0d: ioport range 0xca8-0xcaf has been reserved
system 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0d: iomem range 0xfed20800-0xfed208ff could not be reserved
system 00:0d: iomem range 0xfed30800-0xfed308ff could not be reserved
system 00:0d: iomem range 0xff000000-0xff000fff could not be reserved
system 00:0d: iomem range 0xfff00000-0xffffffff could not be reserved
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: 0xdd000000-0xdeffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: 0xdb000000-0xdcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:07:00.0
  IO window: 4000-4fff
  MEM window: 0xd9000000-0xdaffffff
  PREFETCH window: 0x00000000df000000-0x00000000df0fffff
PCI: Bridge: 0000:07:00.2
  IO window: 5000-ffff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: 4000-ffff
  MEM window: 0xd9000000-0xdaffffff
  PREFETCH window: 0x00000000df000000-0x00000000df0fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: 0xf8000000-0xf8ffffff
  PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 1466k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1211176950.517:1): initialized
Testing tracer sched_switch: PASSED
Testing tracer sysprof: PASSED
Testing tracer ftrace: 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYC3QNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYC3QNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 12:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYC3QNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 12:13:11 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1865 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYC3QNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 12:13:08 -0400
Date: Sun, 30 Mar 2008 18:13:39 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080330161339.GC28821@deprecation.cyrius.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <47EF757F.9080501@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Stefan Richter <stefanr@s5r6.in-berlin.de> [2008-03-30 13:11]:
> Martin, please check whether the same happens if you disable firewire-ohci 
> in the kernel config (or blacklist it in the modprobe config) and use the 
> ohci1394 driver instead.

Yes, I get essentially the same message with the ohci1394 driver:

[  895.455783] irq 19: nobody cared (try booting with the "irqpoll" option)
[  895.455783] Pid: 0, comm: swapper Not tainted 2.6.25-rc7-amd64 #1
[  895.455783]
[  895.455783] Call Trace:
[  895.455783]  <IRQ>  [<ffffffff88078155>] :ohci1394:ohci_irq_handler+0x4b/0x76e
[  895.455783]  [<ffffffff8026c883>] __report_bad_irq+0x30/0x72
[  895.455783]  [<ffffffff8026cac2>] note_interrupt+0x1fd/0x23f
[  895.455783]  [<ffffffff8026d34f>] handle_fasteoi_irq+0xa5/0xc8
[  895.455783]  [<ffffffff8020f53c>] do_IRQ+0x6d/0xd9
[  895.455783]  [<ffffffff8020c46d>] ret_from_intr+0x0/0x19
[  895.455783]  <EOI>  [<ffffffff803a25a4>] menu_reflect+0x0/0x75
[  895.455783]  [<ffffffff8800642b>] :processor:acpi_idle_enter_simple+0x18d/0x1fe
[  895.455783]  [<ffffffff803a1b2b>] cpuidle_idle_call+0x7a/0xb3
[  895.455783]  [<ffffffff803a1ab1>] cpuidle_idle_call+0x0/0xb3
[  895.455783]  [<ffffffff8020b06c>] cpu_idle+0xa9/0xd3
[  895.455783]
[  895.455783] handlers:
[  895.455783] [<ffffffff8807810a>] (ohci_irq_handler+0x0/0x76e [ohci1394])
[  895.455783] Disabling IRQ #19

dmesg is attached.
-- 
Martin Michlmayr
http://www.cyrius.com/

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-rc7-ohci

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.25-rc7-amd64 (Debian 2.6.25~rc7-1~experimental.1~snapshot.11011) (waldi@debian.org) (gcc version 4.1.3 20080114 (prerelease) (Debian 4.1.2-19)) #1 SMP Sun Mar 30 17:36:02 CEST 2008
[    0.000000] Command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F77A0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7F7C81C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: FACP 7F7C8084, 00F4 (r4 HP     30C9            3 HP          1)
[    0.000000] ACPI: DSDT 7F7C84C0, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
[    0.000000] ACPI: FACS 7F7E7D80, 0040
[    0.000000] ACPI: SLIC 7F7C8238, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
[    0.000000] ACPI: HPET 7F7C83B0, 0038 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: APIC 7F7C83E8, 0068 (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: MCFG 7F7C8450, 003C (r1 HP     30C9            1 HP          1)
[    0.000000] ACPI: TCPA 7F7C848C, 0032 (r2 HP     30C9            1 HP          1)
[    0.000000] ACPI: SSDT 7F7DB944, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
[    0.000000] ACPI: SSDT 7F7DC586, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC7E5, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
[    0.000000] ACPI: SSDT 7F7DC88B, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f7b0000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007f7b0000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000022ef7] pages 10
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-6464a7] TEXT DATA BSS
[    0.000000] early res: 3 [37909000-37fef295] RAMDISK
[    0.000000] early res: 4 [9fc00-a0bff] EBDA
[    0.000000] early res: 5 [8000-bfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   522160
[    0.000000] On node 0 totalpages: 522063
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1102 pages reserved
[    0.000000]   DMA zone: 2841 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7082 pages used for memmap
[    0.000000]   DMA32 zone: 510982 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35224 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513823
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/lucky-root ro vga=791
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000002] time.c: Detected 1196.997 MHz processor.
[    0.000032] Console: colour dummy device 80x25
[    0.000037] console [tty0] enabled
[    0.000312] Checking aperture...
[    0.000331] Calgary: detecting Calgary via BIOS EBDA area
[    0.000334] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2047828k/2088640k available (2205k kernel code, 40424k reserved, 1027k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080009] Calibrating delay using timer specific routine.. 2397.31 BogoMIPS (lpj=4794630)
[    0.080086] Security Framework initialized
[    0.080096] SELinux:  Disabled at boot.
[    0.080103] Capability LSM initialized
[    0.080473] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.082280] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.083202] Mount-cache hash table entries: 256
[    0.083437] Initializing cgroup subsys ns
[    0.083446] Initializing cgroup subsys cpuacct
[    0.083480] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083486] CPU: L2 cache: 2048K
[    0.083493] CPU 0/0 -> Node 0
[    0.083497] CPU: Physical Processor ID: 0
[    0.083502] CPU: Processor Core ID: 0
[    0.083515] CPU0: Thermal monitoring handled by SMI
[    0.083518] using mwait in idle threads.
[    0.084015] ACPI: Core revision 20070126
[    0.159876] Using local APIC timer interrupts.
[    0.160012] APIC timer calibration result 8312479
[    0.160015] Detected 8.312 MHz APIC timer.
[    0.160258] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 2394.00 BogoMIPS (lpj=4788003)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
[    0.248606] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.252052] Brought up 2 CPUs
[    0.252178] CPU0 attaching sched-domain:
[    0.252182]  domain 0: span 00000003
[    0.252185]   groups: 00000001 00000002
[    0.252190]   domain 1: span 00000003
[    0.252192]    groups: 00000003
[    0.252197] CPU1 attaching sched-domain:
[    0.252199]  domain 0: span 00000003
[    0.252202]   groups: 00000002 00000001
[    0.252206]   domain 1: span 00000003
[    0.252209]    groups: 00000003
[    0.252620] net_namespace: 1016 bytes
[    0.252631] Booting paravirtualized kernel on bare hardware
[    0.252956] NET: Registered protocol family 16
[    0.253264] ACPI: bus type pci registered
[    0.253399] PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
[    0.253406] PCI: Not using MMCONFIG.
[    0.253411] PCI: Using configuration type 1
[    0.256974] ACPI: EC: Look up EC in DSDT
[    0.007168] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.353529] ACPI: Interpreter enabled
[    0.353537] ACPI: (supports S0 S3 S4 S5)
[    0.353563] ACPI: Using IOAPIC for interrupt routing
[    0.373665] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.373674] ACPI: EC: driver started in interrupt mode
[    0.373769] ACPI: PCI Root Bridge [C003] (0000:00)
[    0.375074] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.375086] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
[    0.375967] PCI: Transparent bridge - 0000:00:1e.0
[    0.376052] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.377033] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
[    0.377371] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
[    0.377671] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
[    0.458107] ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
[    0.458548] ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
[    0.458983] ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
[    0.459419] ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
[    0.459858] ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
[    0.460285] ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
[    0.460721] ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
[    0.460927] ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
[    0.461281] ACPI: Power Resource [C29F] (on)
[    0.461390] ACPI: Power Resource [C1C7] (off)
[    0.461605] ACPI: Power Resource [C3AD] (off)
[    0.461811] ACPI: Power Resource [C3B0] (off)
[    0.462016] ACPI: Power Resource [C3C3] (off)
[    0.462226] ACPI: Power Resource [C3C4] (off)
[    0.462431] ACPI: Power Resource [C3C5] (off)
[    0.462634] ACPI: Power Resource [C3C6] (off)
[    0.462837] ACPI: Power Resource [C3C7] (off)
[    0.463101] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.463152] pnp: PnP ACPI init
[    0.463166] ACPI: bus type pnp registered
[    0.463473]  00:00: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.463550] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.470899] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.472215] pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.472303] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.472387] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.472463] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.472545] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.472933] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.473020] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.473111] pnp 00:09: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
[    0.474032]  00:0a: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.474113] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.478436] pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.478561]  00:0c: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.478656] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.481318]  00:0d: calling quirk 0xffffffff8035b6ca: quirk_system_pci_resources+0x0/0x173()
[    0.481428] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.481457] pnp: PnP ACPI: found 14 devices
[    0.481463] ACPI: ACPI bus type pnp unregistered
[    0.481751] usbcore: registered new interface driver usbfs
[    0.481841] usbcore: registered new interface driver hub
[    0.481910] usbcore: registered new device driver usb
[    0.482120] PCI: Using ACPI for IRQ routing
[    0.482126] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.500051] NET: Registered protocol family 8
[    0.500057] NET: Registered protocol family 20
[    0.500124] PCI-GART: No AMD northbridge found.
[    0.500138] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.500148] hpet0: 3 64-bit timers, 14318180 Hz
[    0.501210] ACPI: RTC can wake from S4
[    0.504044] Switched to high resolution mode on CPU 0
[    0.252027] Switched to high resolution mode on CPU 1
[    0.516050] pnp: the driver 'system' has been registered
[    0.516066] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.516074] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    0.516082] system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
[    0.516090] system 00:00: driver attached
[    0.516104] system 00:0a: ioport range 0x500-0x55f has been reserved
[    0.516112] system 00:0a: ioport range 0x800-0x80f has been reserved
[    0.516121] system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.516130] system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.516137] system 00:0a: driver attached
[    0.516146] system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
[    0.516153] system 00:0c: ioport range 0x2f8-0x2ff has been reserved
[    0.516161] system 00:0c: ioport range 0x3f8-0x3ff has been reserved
[    0.516168] system 00:0c: ioport range 0x1000-0x107f has been reserved
[    0.516177] system 00:0c: ioport range 0x1100-0x113f has been reserved
[    0.516185] system 00:0c: ioport range 0x1200-0x121f has been reserved
[    0.516193] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.516201] system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
[    0.516210] system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
[    0.516219] system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
[    0.516228] system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
[    0.516235] system 00:0c: driver attached
[    0.516244] system 00:0d: iomem range 0xcee00-0xcffff has been reserved
[    0.516252] system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
[    0.516260] system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
[    0.516269] system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.516277] system 00:0d: driver attached
[    0.516934] PCI: Bridge: 0000:00:1c.0
[    0.516940]   IO window: disabled.
[    0.516949]   MEM window: disabled.
[    0.516957]   PREFETCH window: disabled.
[    0.516969] PCI: Bridge: 0000:00:1c.1
[    0.516973]   IO window: disabled.
[    0.516983]   MEM window: 0xe0000000-0xe00fffff
[    0.516992]   PREFETCH window: disabled.
[    0.517007] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.517013]   IO window: 0x00003000-0x000030ff
[    0.517022]   IO window: 0x00003400-0x000034ff
[    0.517032]   PREFETCH window: 0x88000000-0x8bffffff
[    0.517042]   MEM window: 0x8c000000-0x8fffffff
[    0.517051] PCI: Bridge: 0000:00:1e.0
[    0.517058]   IO window: 3000-3fff
[    0.517068]   MEM window: 0xe0100000-0xe03fffff
[    0.517077]   PREFETCH window: 0x0000000088000000-0x000000008bffffff
[    0.517121] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.517135] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.517166] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.517179] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.517197] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.517221] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
[    0.517287] NET: Registered protocol family 2
[    0.552216] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.553439] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.556763] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.557659] TCP: Hash tables configured (established 262144 bind 65536)
[    0.557667] TCP reno registered
[    0.568332] checking if image is initramfs... it is
[    1.536099] Freeing initrd memory: 7064k freed
[    1.294389] audit: initializing netlink socket (disabled)
[    1.294425] type=2000 audit(1206892467.541:1): initialized
[    1.294734] Total HugeTLB memory allocated, 0
[    1.294889] VFS: Disk quotas dquot_6.5.1
[    1.294935] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.295081] io scheduler noop registered
[    1.295087] io scheduler anticipatory registered
[    1.295092] io scheduler deadline registered
[    1.295115] io scheduler cfq registered (default)
[    1.295132] pci 0000:00:02.0: Boot video device
[    1.295432] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.295487] assign_interrupt_mode Found MSI capability
[    1.295553] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.295699] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.295753] assign_interrupt_mode Found MSI capability
[    1.295814] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.296510] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000900000, using 3072k, total 7616k
[    1.296521] vesafb: mode is 1024x768x16, linelength=2048, pages=3
[    1.296527] vesafb: scrolling: redraw
[    1.296533] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.316629] Console: switching to colour frame buffer device 128x48
[    1.336816] fb0: VESA VGA frame buffer device
[    1.340506] Real Time Clock Driver v1.12ac
[    1.341047] hpet_resources: 0xfed00000 is busy
[    1.341164] Linux agpgart interface v0.103
[    1.341325] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.342027] pnp: the driver 'serial' has been registered
[    1.342372] isa bounce pool size: 16 pages
[    1.343772] brd: module loaded
[    1.343989] input: Macintosh mouse button emulation as /class/input/input0
[    1.344232] pnp: the driver 'i8042 kbd' has been registered
[    1.344250] i8042 kbd 00:08: driver attached
[    1.344298] pnp: the driver 'i8042 aux' has been registered
[    1.344325] i8042 aux 00:09: driver attached
[    1.344375] PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
[    1.346601] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.347624] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.347820] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.348096] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.348295] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.348494] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.376204] mice: PS/2 mouse device common for all mice
[    1.376449] cpuidle: using governor ladder
[    1.376597] cpuidle: using governor menu
[    1.377309] TCP bic registered
[    1.377442] NET: Registered protocol family 1
[    1.377628] NET: Registered protocol family 17
[    1.378001] registered taskstats version 1
[    1.378295] Freeing unused kernel memory: 372k freed
[    1.399989] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.659605] ACPI: Transitioning device [C3B1] to D3
[    1.660179] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.664119] ACPI: Fan [C3B1] (off)
[    1.668528] ACPI: Transitioning device [C3B2] to D3
[    1.672174] ACPI: PNP0C0B:01 is registered as cooling_device1
[    1.676120] ACPI: Fan [C3B2] (off)
[    1.684489] ACPI: Transitioning device [C3C8] to D3
[    1.688170] ACPI: PNP0C0B:02 is registered as cooling_device2
[    1.692123] ACPI: Fan [C3C8] (off)
[    1.700401] ACPI: Transitioning device [C3C9] to D3
[    1.704170] ACPI: PNP0C0B:03 is registered as cooling_device3
[    1.708123] ACPI: Fan [C3C9] (off)
[    1.712504] ACPI: Transitioning device [C3CA] to D3
[    1.716168] ACPI: PNP0C0B:04 is registered as cooling_device4
[    1.720122] ACPI: Fan [C3CA] (off)
[    1.724507] ACPI: Transitioning device [C3CB] to D3
[    1.728169] ACPI: PNP0C0B:05 is registered as cooling_device5
[    1.732123] ACPI: Fan [C3CB] (off)
[    1.736503] ACPI: Transitioning device [C3CC] to D3
[    1.740172] ACPI: PNP0C0B:06 is registered as cooling_device6
[    1.744124] ACPI: Fan [C3CC] (off)
[    2.036874] ACPI: SSDT 7F7DBCCA, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
[    2.044353] ACPI: SSDT 7F7DBF8C, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
[    2.063554] Monitor-Mwait will be used to enter C-1 state
[    2.063559] Monitor-Mwait will be used to enter C-2 state
[    2.063747] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    2.064195] ACPI: ACPI0007:00 is registered as cooling_device7
[    2.068141] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.072645] ACPI: SSDT 7F7DBC02, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
[    2.080594] ACPI: SSDT 7F7DBF07, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
[    1.818884] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    2.088136] Marking TSC unstable due to TSC halts in idle
[    1.820183] ACPI: ACPI0007:01 is registered as cooling_device8
[    1.820189] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.844627] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.848462] ACPI: Thermal Zone [TZ6] (25 C)
[    2.133204] ACPI: LNXTHERM:02 is registered as thermal_zone1
[    1.895555] ACPI: Thermal Zone [TZ0] (69 C)
[    1.904035] ACPI: LNXTHERM:03 is registered as thermal_zone2
[    1.912215] ACPI: Thermal Zone [TZ1] (73 C)
[    1.924119] ACPI: LNXTHERM:04 is registered as thermal_zone3
[    1.932424] ACPI: Thermal Zone [TZ3] (61 C)
[    1.945357] ACPI: LNXTHERM:05 is registered as thermal_zone4
[    2.230054] ACPI: Thermal Zone [TZ4] (35 C)
[    1.967135] ACPI: LNXTHERM:06 is registered as thermal_zone5
[    2.246884] ACPI: Thermal Zone [TZ5] (63 C)
[    2.727107] USB Universal Host Controller Interface driver v3.0
[    2.730996] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    2.734941] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    2.734948] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.739154] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.742973] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
[    2.747136] usb usb1: configuration #1 chosen from 1 choice
[    2.750983] hub 1-0:1.0: USB hub found
[    2.754945] hub 1-0:1.0: 2 ports detected
[    2.831253] Uniform Multi-Platform E-IDE driver
[    2.834939] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.859089] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.862958] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.866938] usb usb1: Product: UHCI Host Controller
[    2.870937] usb usb1: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    2.874938] usb usb1: SerialNumber: 0000:00:1a.0
[    2.878987] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[    2.882951] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    2.882957] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.887042] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    2.887088] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
[    2.891130] usb usb2: configuration #1 chosen from 1 choice
[    2.891168] hub 2-0:1.0: USB hub found
[    2.894959] hub 2-0:1.0: 2 ports detected
[    2.999077] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.002958] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.006959] usb usb2: Product: UHCI Host Controller
[    3.010971] usb usb2: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.014959] usb usb2: SerialNumber: 0000:00:1a.1
[    2.849465] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    2.853398] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    2.853403] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.857463] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
[    2.867014] ehci_hcd 0000:00:1a.7: debug port 1
[    2.869385] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    2.869403] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
[    3.063182] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    2.996145] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.000261] usb usb3: configuration #1 chosen from 1 choice
[    3.004169] hub 3-0:1.0: USB hub found
[    3.008142] hub 3-0:1.0: 4 ports detected
[    3.119998] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.123906] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.127907] usb usb3: Product: EHCI Host Controller
[    3.131906] usb usb3: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    3.135907] usb usb3: SerialNumber: 0000:00:1a.7
[    3.139953] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    3.143921] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.143928] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.397131] Clocksource tsc unstable (delta = -251353446 ns)
[    3.147985] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    3.157105] ehci_hcd 0000:00:1d.7: debug port 1
[    3.159914] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    3.159927] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
[    3.178892] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    3.183005] usb usb4: configuration #1 chosen from 1 choice
[    3.186920] hub 4-0:1.0: USB hub found
[    3.190892] hub 4-0:1.0: 6 ports detected
[    3.297767] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.301683] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.305682] usb usb4: Product: EHCI Host Controller
[    3.309682] usb usb4: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    3.313682] usb usb4: SerialNumber: 0000:00:1d.7
[    3.637689] usb 1-1: device not accepting address 2, error -71
[    3.656617] ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 19 (level, low) -> IRQ 19
[    3.362226] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    3.365695] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    3.365701] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.369785] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    3.715333] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    3.373736] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
[    3.377850] usb usb5: configuration #1 chosen from 1 choice
[    3.381722] hub 5-0:1.0: USB hub found
[    3.385696] hub 5-0:1.0: 2 ports detected
[    3.492732] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.496609] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.500607] usb usb5: Product: UHCI Host Controller
[    3.504607] usb usb5: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.508626] usb usb5: SerialNumber: 0000:00:1d.0
[    3.512660] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
[    3.516619] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.516625] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.520681] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    3.524650] uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
[    3.528768] usb usb6: configuration #1 chosen from 1 choice
[    3.532648] hub 6-0:1.0: USB hub found
[    3.536616] hub 6-0:1.0: 2 ports detected
[    3.643538] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.647442] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.651440] usb usb6: Product: UHCI Host Controller
[    3.655440] usb usb6: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.659440] usb usb6: SerialNumber: 0000:00:1d.1
[    3.663476] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.667447] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.667452] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.671505] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    3.675477] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
[    3.679609] usb usb7: configuration #1 chosen from 1 choice
[    3.683478] hub 7-0:1.0: USB hub found
[    3.687448] hub 7-0:1.0: 2 ports detected
[    3.794386] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.798293] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.802294] usb usb7: Product: UHCI Host Controller
[    3.806293] usb usb7: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    3.810294] usb usb7: SerialNumber: 0000:00:1d.2
[    4.369232] ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
[    4.373213] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    4.377221] ICH8M: not 100% native mode: will probe irqs later
[    4.381215] ICH8M: IDE port disabled
[    4.385210]     ide0: BM-DMA at 0x20e0-0x20e7, BIOS settings: hda:DMA, hdb:DMA
[    4.389213] Probing IDE interface ide0...
[    4.517239] usb 5-2: new full speed USB device using uhci_hcd and address 2
[    4.685053] usb 5-2: configuration #1 chosen from 1 choice
[    4.689430] usb 5-2: New USB device found, idVendor=08ff, idProduct=2580
[    4.693073] usb 5-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.697060] usb 5-2: Product: Fingerprint Sensor
[    4.845355] hdb: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
[    4.935607] usb 1-1: new full speed USB device using uhci_hcd and address 4
[    4.547224] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929010210]
[    5.110456] usb 1-1: configuration #1 chosen from 1 choice
[    5.116251] usb 1-1: New USB device found, idVendor=03f0, idProduct=171d
[    5.118472] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.122467] usb 1-1: Product: HP Integrated Module
[    5.126467] usb 1-1: Manufacturer: Broadcom Corp
[    5.154925] hda: TOSHIBA MK8009GAH, ATA DISK drive
[    5.158515] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.158583] hda: UDMA/100 mode selected
[    5.162574] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.162864] hdb: MWDMA2 mode selected
[    5.166784] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.205075] No dock devices found.
[    5.217401] SCSI subsystem initialized
[    5.230075] libata version 3.00 loaded.
[    5.261441] hda: max request size: 128KiB
[    5.262499] hda: 156301488 sectors (80026 MB), CHS=65535/16/63
[    4.837806] hda: cache flushes supported
[    4.841723]  hda: hda1 hda2 hda3
[    4.869295] hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
[    4.871706] Uniform CD-ROM driver Revision: 3.20
[    5.834326] device-mapper: uevent: version 1.0.3
[    5.837313] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    9.448581] PM: Starting manual resume from disk
[   10.024594] kjournald starting.  Commit interval 5 seconds
[    9.587812] EXT3-fs: mounted filesystem with ordered data mode.
[   13.877449] input: Power Button (FF) as /class/input/input2
[   13.932865] ACPI: Power Button (FF) [PWRF]
[   13.936949] input: Sleep Button (CM) as /class/input/input3
[   13.996903] ACPI: Sleep Button (CM) [C2BF]
[   14.000901] input: Lid Switch as /class/input/input4
[   14.034130] ACPI: Lid Switch [C155]
[   14.037456] ACPI: AC Adapter [C23B] (on-line)
[   14.529020] agpgart: Detected an Intel 965GM Chipset.
[   14.531741] agpgart: Detected 7676K stolen memory.
[   14.552269] agpgart: AGP aperture is 256M @ 0xd0000000
[   14.332884] ACPI: Battery Slot [C23D] (battery present)
[   14.723619] ACPI: WMI: Mapper loaded
[   14.769333] ACPI: device:02 is registered as cooling_device9
[   14.772235] input: Video Bus as /class/input/input5
[   14.822936] ACPI: Video Device [C09A] (multi-head: yes  rom: no  post: no)
[   14.985624] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   14.986888] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   14.990966] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
[   14.994901] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   15.145424] eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:06:12:ee
[   15.147010] eth0: Intel(R) PRO/1000 Network Connection
[   15.150935] eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[   15.280806] Bluetooth: Core ver 2.11
[   15.343723] ricoh-mmc: Ricoh MMC Controller disabling driver
[   15.346911] ricoh-mmc: Copyright(c) Philip Langdale
[   15.015704] NET: Registered protocol family 31
[   15.015708] Bluetooth: HCI device and connection manager initialized
[   15.015715] Bluetooth: HCI socket layer initialized
[   15.350955] ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
[   15.354932] ricoh-mmc: Controller is now disabled.
[   15.163604] Bluetooth: HCI USB driver ver 2.9
[   15.169669] usbcore: registered new interface driver hci_usb
[   15.192659] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   15.192994] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   15.196925] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   15.302792] input: PC Speaker as /class/input/input6
[   15.608570] sdhci: Secure Digital Host Controller Interface driver
[   15.610702] sdhci: Copyright(c) Pierre Ossman
[   15.614728] sdhci: SDHCI controller found at 0000:02:06.2 [1180:0822] (rev 21)
[   15.618721] ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 20 (level, low) -> IRQ 20
[   15.622714] sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
[   15.626748] mmc0: SDHCI at 0xe0102000 irq 20 DMA
[   16.253707] pnp: the driver 'tpm_inf_pnp' has been registered
[   16.255095] tpm_inf_pnp 00:02: Found C284 with ID IFX0102
[   16.259146] tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   16.263442] tpm_inf_pnp 00:02: driver attached
[   15.963006] Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
[   16.394350] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[   16.397187] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   16.090278] input: PS/2 Generic Mouse as /class/input/input7
[   16.425826] Yenta: ISA IRQ mask 0x04b8, PCI irq 18
[   16.428809] Socket status: 30000006
[   16.432779] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   16.436774] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
[   16.440794] pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
[   16.444784] pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
[   16.470454] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   16.472812] PCI: Setting latency timer of device 0000:10:00.0 to 64
[   16.476799] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   16.529555] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   16.537188] phy0: Selected rate control algorithm 'iwl-4965-rs'
[   16.294817] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
[   16.295965] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   16.400616] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   16.868692] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
[   16.908830] input: SynPS/2 Synaptics TouchPad as /class/input/input8
[   18.454284] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x006ba000
[   19.882348] EXT3 FS on dm-1, internal journal
[   21.291919] loop: module loaded
[   21.106679] tun: Universal TUN/TAP device driver, 1.6
[   21.107653] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   23.520274] kjournald starting.  Commit interval 5 seconds
[   23.217691] EXT3 FS on hda1, internal journal
[   23.221385] EXT3-fs: mounted filesystem with ordered data mode.
[   23.584565] kjournald starting.  Commit interval 5 seconds
[   23.264959] EXT3 FS on dm-3, internal journal
[   23.264964] EXT3-fs: mounted filesystem with ordered data mode.
[   23.337571] Adding 1048568k swap on /dev/mapper/lucky-swap.  Priority:-1 extents:1 across:1048568k
[   24.929768] Bridge firewalling registered
[   24.931887] br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[   24.942253] device eth0 entered promiscuous mode
[   26.905730] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   26.909306] eth0: 10/100 speed: disabling TSO
[   26.913842] br0: port 1(eth0) entering learning state
[   35.889487] br0: topology change detected, propagating
[   35.893480] br0: port 1(eth0) entering forwarding state
[   37.648095] NET: Registered protocol family 10
[   37.649458] lo: Disabled Privacy Extensions
[   45.122808] pnp: the driver 'parport_pc' has been registered
[   44.888753] lp: driver loaded but no devices found
[   44.998186] ppdev: user-space parallel port driver
[   47.815704] br0: no IPv6 routers present
[   48.150923] eth0: no IPv6 routers present
[   50.699445] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   53.780266] Bluetooth: L2CAP ver 2.9
[   53.780796] Bluetooth: L2CAP socket layer initialized
[   53.784394] Bluetooth: RFCOMM socket layer initialized
[   53.784886] Bluetooth: RFCOMM TTY layer initialized
[   53.788909] Bluetooth: RFCOMM ver 1.8
[   54.139106] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   54.140587] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[   54.355094] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[   54.357637] iwl4965: Could not read microcode: -2
[   54.361727] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   57.567349] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   57.575109] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[   57.587756] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[   57.591080] iwl4965: Could not read microcode: -2
[   57.595168] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[   58.260886] hdb: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
[   58.262502] hdb: task_no_data_intr: error=0x04 { AbortedCommand }
[   58.262502] ide: failed opcode was: 0xef
[   62.410686] [drm] Initialized drm 1.1.0 20060810
[   62.435748] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   62.435768] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   62.436019] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   71.634881] eth0: no IPv6 routers present
[   79.545124] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   79.545247] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[   79.553765] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[   79.553778] iwl4965: Could not read microcode: -2
[   79.553862] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  101.471941] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  101.472056] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  101.480593] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  101.480604] iwl4965: Could not read microcode: -2
[  101.480689] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  123.396260] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  123.397988] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  123.408407] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  123.410141] iwl4965: Could not read microcode: -2
[  123.412117] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  145.351857] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  145.355243] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  145.366199] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  145.367590] iwl4965: Could not read microcode: -2
[  145.371657] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  167.313265] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  167.317069] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  167.329391] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  167.332981] iwl4965: Could not read microcode: -2
[  167.337053] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  189.276942] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  189.280762] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  189.293392] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  189.296665] iwl4965: Could not read microcode: -2
[  189.300750] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  310.719289] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  310.723113] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  310.735538] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  310.739063] iwl4965: Could not read microcode: -2
[  310.743095] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  432.148269] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  432.152137] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  432.164698] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  432.168023] iwl4965: Could not read microcode: -2
[  432.172103] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  553.578398] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  553.581812] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  553.594944] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  553.598044] iwl4965: Could not read microcode: -2
[  553.602126] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  675.019326] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  675.022850] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  675.033922] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  675.035057] iwl4965: Could not read microcode: -2
[  675.039158] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  796.455782] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  796.459614] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  796.472347] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  796.475569] iwl4965: Could not read microcode: -2
[  796.479596] ACPI: PCI interrupt for device 0000:10:00.0 disabled
[  895.455783] irq 19: nobody cared (try booting with the "irqpoll" option)
[  895.455783] Pid: 0, comm: swapper Not tainted 2.6.25-rc7-amd64 #1
[  895.455783] 
[  895.455783] Call Trace:
[  895.455783]  <IRQ>  [<ffffffff88078155>] :ohci1394:ohci_irq_handler+0x4b/0x76e
[  895.455783]  [<ffffffff8026c883>] __report_bad_irq+0x30/0x72
[  895.455783]  [<ffffffff8026cac2>] note_interrupt+0x1fd/0x23f
[  895.455783]  [<ffffffff8026d34f>] handle_fasteoi_irq+0xa5/0xc8
[  895.455783]  [<ffffffff8020f53c>] do_IRQ+0x6d/0xd9
[  895.455783]  [<ffffffff8020c46d>] ret_from_intr+0x0/0x19
[  895.455783]  <EOI>  [<ffffffff803a25a4>] menu_reflect+0x0/0x75
[  895.455783]  [<ffffffff8800642b>] :processor:acpi_idle_enter_simple+0x18d/0x1fe
[  895.455783]  [<ffffffff803a1b2b>] cpuidle_idle_call+0x7a/0xb3
[  895.455783]  [<ffffffff803a1ab1>] cpuidle_idle_call+0x0/0xb3
[  895.455783]  [<ffffffff8020b06c>] cpu_idle+0xa9/0xd3
[  895.455783] 
[  895.455783] handlers:
[  895.455783] [<ffffffff8807810a>] (ohci_irq_handler+0x0/0x76e [ohci1394])
[  895.455783] Disabling IRQ #19
[  917.880795] ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  917.884259] PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
[  917.892669] iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
[  917.896083] iwl4965: Could not read microcode: -2
[  917.896641] ACPI: PCI interrupt for device 0000:10:00.0 disabled

--/04w6evG8XlLl3ft--

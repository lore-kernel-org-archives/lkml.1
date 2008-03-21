Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYCUPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYCUPjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYCUPjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:39:42 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4668 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYCUPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:39:39 -0400
Date: Fri, 21 Mar 2008 16:39:52 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080321153952.GA26354@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I just got the following in dmesg a few minutes after booting my
notebook which was idle at the time this occurred.  This was with
2.6.25-rc6 but I've seen the same with 2.6.22 (see the attached
dmesg from 2.6.22).

irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.25-rc6-amd64 #1

Call Trace:
 <IRQ>  [<ffffffff80271c0b>] __report_bad_irq+0x38/0x7c
 [<ffffffff80271e51>] note_interrupt+0x202/0x249
 [<ffffffff8027274e>] handle_fasteoi_irq+0xab/0xd0
 [<ffffffff8020f82c>] do_IRQ+0x6e/0xda
 [<ffffffff8020c65d>] ret_from_intr+0x0/0x19
 <EOI>  [<ffffffff80221831>] ? native_irq_enable+0x6/0x7
 [<ffffffff88006330>] ? :processor:acpi_idle_enter_bm+0x2ab/0x325
 [<ffffffff803b5ef3>] ? menu_select+0x70/0x99
 [<ffffffff803b52e1>] ? cpuidle_idle_call+0x77/0xa6
 [<ffffffff803b526a>] ? cpuidle_idle_call+0x0/0xa6
 [<ffffffff8020b187>] ? cpu_idle+0xb1/0xdb
 [<ffffffff8042ea16>] ? rest_init+0x5a/0x5c

handlers:
[<ffffffff8806f0f5>] (irq_handler+0x0/0x207 [firewire_ohci])
Disabling IRQ #19


tbm@loric-alpo:~$ lspci
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
02:06.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
02:06.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
02:06.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 11)
10:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)

-- 
Martin Michlmayr
http://www.cyrius.com/

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.22-3-amd64 (Debian 2.6.22-6) (maks@debian.org) (gcc version 4.1.3 20071019 (prerelease) (Debian 4.1.2-17)) #1 SMP Sun Nov 4 18:18:09 UTC 2007
Command line: root=/dev/mapper/lucky-root ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
 BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
 BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F77A0, 0024 (r2 HP    )
ACPI: XSDT 7F7C81C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 7F7C8084, 00F4 (r4 HP     30C9            3 HP          1)
ACPI: DSDT 7F7C84C0, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
ACPI: FACS 7F7E7D80, 0040
ACPI: SLIC 7F7C8238, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 7F7C83B0, 0038 (r1 HP     30C9            1 HP          1)
ACPI: APIC 7F7C83E8, 0068 (r1 HP     30C9            1 HP          1)
ACPI: MCFG 7F7C8450, 003C (r1 HP     30C9            1 HP          1)
ACPI: TCPA 7F7C848C, 0032 (r2 HP     30C9            1 HP          1)
ACPI: SSDT 7F7DB944, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
ACPI: SSDT 7F7DC586, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 7F7DC7E5, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 7F7DC88B, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
No NUMA configuration found
Faking a node at 0000000000000000-000000007f7b0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007f7b0000
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   522160
On node 0 totalpages: 522063
  DMA zone: 56 pages used for memmap
  DMA zone: 1018 pages reserved
  DMA zone: 2925 pages, LIFO batch:0
  DMA32 zone: 7082 pages used for memmap
  DMA32 zone: 510982 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37896 bytes of per cpu data
Built 1 zonelists.  Total pages: 513907
Kernel command line: root=/dev/mapper/lucky-root ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1196.999 MHz processor.
Console: colour VGA+ 80x25
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2048584k/2088640k available (2008k kernel code, 39668k reserved, 945k data, 296k init)
Calibrating delay using timer specific routine.. 2397.08 BogoMIPS (lpj=4794173)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 8312493
Detected 8.312 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2394.06 BogoMIPS (lpj=4788138)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=19
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [C003] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid IFX0102
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0103
pnp: ACPI device : hid PNP0303
pnp: ACPI device : hid SYN0130
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid HPQ0004
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:00' and the driver 'system'
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: match found with the PnP device '00:0c' and the driver 'system'
pnp: 00:0c: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0c: ioport range 0x2f8-0x2ff has been reserved
pnp: 00:0c: ioport range 0x3f8-0x3ff has been reserved
pnp: 00:0c: ioport range 0x1000-0x107f has been reserved
pnp: 00:0c: ioport range 0x1100-0x113f has been reserved
pnp: 00:0c: ioport range 0x1200-0x121f has been reserved
pnp: 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
pnp: 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
pnp: match found with the PnP device '00:0d' and the driver 'system'
pnp: 00:0d: iomem range 0xcee00-0xcffff has been reserved
pnp: 00:0d: iomem range 0xd2000-0xd3fff has been reserved
pnp: 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
pnp: 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: e0000000-e00fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 8c000000-8fffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: e0100000-e03fffff
  PREFETCH window: 88000000-8bffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6829k freed
audit: initializing netlink socket (disabled)
audit(1206112792.588:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
pnp: the driver 'serial' has been registered
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:08' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:09' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 296k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Transitioning device [C3B1] to D3
ACPI: Transitioning device [C3B1] to D3
ACPI: Fan [C3B1] (off)
ACPI: Transitioning device [C3B2] to D3
ACPI: Transitioning device [C3B2] to D3
ACPI: Fan [C3B2] (off)
ACPI: Transitioning device [C3C8] to D3
ACPI: Transitioning device [C3C8] to D3
ACPI: Fan [C3C8] (off)
ACPI: Transitioning device [C3C9] to D3
ACPI: Transitioning device [C3C9] to D3
ACPI: Fan [C3C9] (off)
ACPI: Transitioning device [C3CA] to D3
ACPI: Transitioning device [C3CA] to D3
ACPI: Fan [C3CA] (off)
ACPI: Transitioning device [C3CB] to D3
ACPI: Transitioning device [C3CB] to D3
ACPI: Fan [C3CB] (off)
ACPI: Transitioning device [C3CC] to D3
ACPI: Transitioning device [C3CC] to D3
ACPI: Fan [C3CC] (off)
ACPI: SSDT 7F7DBCCA, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 7F7DBF8C, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F7DBC02, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 7F7DBF07, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [TZ6] (25 C)
Marking TSC unstable due to possible TSC halt in C2
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [TZ0] (50 C)
ACPI: Thermal Zone [TZ1] (53 C)
ACPI: Thermal Zone [TZ3] (41 C)
ACPI: Thermal Zone [TZ4] (31 C)
ACPI: Thermal Zone [TZ5] (26 C)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
pnp: the driver 'ide' has been registered
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:1e:68:06:12:ee
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
firewire_ohci: Added fw-ohci device 0000:02:06.1, OHCI version 1.10
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ICH8M: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH8M: chipset revision 3
ICH8M: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x20e0-0x20e7, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
firewire_core: created new fw device fw0 (0 config rom retries)
hda: TOSHIBA MK8009GAH, ATA DISK drive
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usb 1-1: new full speed USB device using uhci_hcd and address 3
hdb: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
hda: selected mode 0x45
hdb: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
SCSI subsystem initialized
libata version 2.21 loaded.
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB), CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3
hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
usb 1-1: configuration #1 chosen from 1 choice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
Bluetooth: HCI USB driver ver 2.9
input: PC Speaker as /class/input/input1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
usbcore: registered new interface driver hci_usb
Yenta: ISA IRQ mask 0x0cb8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
sdhci: SDHCI controller found at 0000:02:06.2 [1180:0822] (rev 21)
ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI at 0xe0102000 irq 20 DMA
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
input: PS/2 Generic Mouse as /class/input/input2
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input3
EXT3 FS on dm-1, internal journal
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1048568k swap on /dev/mapper/lucky-swap.  Priority:-1 extents:1 across:1048568k
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ACPI: Battery Slot [C23D] (battery present)
ACPI: AC Adapter [C23B] (off-line)
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [C2BF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [C155]
pnp: the driver 'parport_pc' has been registered
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
hdb: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hdb: drive_cmd: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xef
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
eth0: no IPv6 routers present
irq 19: nobody cared (try booting with the "irqpoll" option)

Call Trace:
 <IRQ>  [<ffffffff8025dfe7>] __report_bad_irq+0x30/0x72
 [<ffffffff8025e20c>] note_interrupt+0x1e3/0x227
 [<ffffffff8025ead9>] handle_fasteoi_irq+0xa9/0xd0
 [<ffffffff8020ca0d>] do_IRQ+0x6c/0xd3
 [<ffffffff8020a2a1>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff88005ad1>] :processor:acpi_processor_idle+0x263/0x45a
 [<ffffffff88005ac7>] :processor:acpi_processor_idle+0x259/0x45a
 [<ffffffff8800586e>] :processor:acpi_processor_idle+0x0/0x45a
 [<ffffffff80209125>] cpu_idle+0x8b/0xae

handlers:
[<ffffffff88062b52>] (irq_handler+0x0/0x1c1 [firewire_ohci])
Disabling IRQ #19

--pWyiEgJYm5f9v55/--

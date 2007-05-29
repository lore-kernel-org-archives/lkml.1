Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXE2QgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXE2QgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXE2QgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:36:06 -0400
Received: from rtr.ca ([64.26.128.89]:4294 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbXE2QgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:36:02 -0400
Message-ID: <465C566E.4030009@rtr.ca>
Date: Tue, 29 May 2007 12:35:58 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Subject: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel chipset
Content-Type: multipart/mixed;
 boundary="------------090009050709070009060102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090009050709070009060102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I just "upgraded" from 2.6.21.3 to 2.6.22-rc3,
but will be rebooting back into 2.6.21.xx shortly.

Suspend/Resume (RAM) works perfectly on this Dell i9400 dual-core notebook.
Except with 2.6.22-rc3, all USB devices are non-functional on resume.
Most of the time.
Once in five reboots, my mouse worked after the first suspend/resume cycle,
but not thereafter.  'lsusb' also hangs after resume.

I'm attaching a full syslog with USB_DEBUG=y.
I cannot use PM_DEBUG=y due to an unresolved race condition
in the HRTIMER stuff (previously reported/discussed with no attempt at resolution).

This notebook uses very mainstream Intel chips for most stuff:

0000:00:00.0 Host bridge: Intel Corporation Mobile Memory Controller Hub (rev 03)
0000:00:01.0 PCI bridge: Intel Corporation Mobile PCI Express Graphics Port (rev 03)
0000:00:1b.0 0403: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
0000:00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
0000:00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
0000:00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01)
0000:00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01)
0000:00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01)
0000:00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01)
0000:00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01)
0000:00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
0000:00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
0000:00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controllers cc=IDE (rev 01)
0000:00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
0000:01:00.0 VGA compatible controller: ATI Technologies Inc: Unknown device 7145
0000:03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
0000:03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd: Unknown device 0832
0000:03:01.1 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
0000:03:01.2 System peripheral: Ricoh Co Ltd: Unknown device 0843 (rev 01)
0000:03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
0000:03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222 (rev 02)

There are a zillion USB patches in 2.6.22-rc*.
Greg: got any good suggestions on which one to revert first?

Thanks
Mark Lord

--------------090009050709070009060102
Content-Type: text/x-log;
 name="usb_toa.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb_toa.log"

May 29 12:25:05 corey syslogd 1.4.1#17ubuntu7: restart.
May 29 12:25:05 corey kernel: Inspecting /boot/System.map-2.6.22-rc3
May 29 12:25:05 corey kernel: Loaded 24249 symbols from /boot/System.map-2.6.22-rc3.
May 29 12:25:05 corey kernel: Symbols match kernel version 2.6.22.
May 29 12:25:05 corey kernel: No module symbols loaded - kernel modules not enabled. 
May 29 12:25:05 corey kernel: Linux version 2.6.22-rc3 (root@corey) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #6 SMP PREEMPT Tue May 29 12:23:07 EDT 2007
May 29 12:25:05 corey kernel: BIOS-provided physical RAM map:
May 29 12:25:05 corey kernel:  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
May 29 12:25:05 corey kernel:  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 0000000000100000 - 000000007fed3400 (usable)
May 29 12:25:05 corey kernel:  BIOS-e820: 000000007fed3400 - 0000000080000000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
May 29 12:25:05 corey kernel:  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
May 29 12:25:05 corey kernel: 1150MB HIGHMEM available.
May 29 12:25:05 corey kernel: 896MB LOWMEM available.
May 29 12:25:05 corey kernel: Entering add_active_range(0, 0, 523987) 0 entries of 256 used
May 29 12:25:05 corey kernel: Zone PFN ranges:
May 29 12:25:05 corey kernel:   DMA             0 ->     4096
May 29 12:25:05 corey kernel:   Normal       4096 ->   229376
May 29 12:25:05 corey kernel:   HighMem    229376 ->   523987
May 29 12:25:05 corey kernel: early_node_map[1] active PFN ranges
May 29 12:25:05 corey kernel:     0:        0 ->   523987
May 29 12:25:05 corey kernel: On node 0 totalpages: 523987
May 29 12:25:05 corey kernel:   DMA zone: 32 pages used for memmap
May 29 12:25:05 corey kernel:   DMA zone: 0 pages reserved
May 29 12:25:05 corey kernel:   DMA zone: 4064 pages, LIFO batch:0
May 29 12:25:05 corey kernel:   Normal zone: 1760 pages used for memmap
May 29 12:25:05 corey kernel:   Normal zone: 223520 pages, LIFO batch:31
May 29 12:25:05 corey kernel:   HighMem zone: 2301 pages used for memmap
May 29 12:25:05 corey kernel:   HighMem zone: 292310 pages, LIFO batch:31
May 29 12:25:05 corey kernel: DMI 2.4 present.
May 29 12:25:05 corey kernel: ACPI: RSDP 000FC1B0, 0014 (r0 DELL  )
May 29 12:25:05 corey kernel: ACPI: RSDT 7FED39CD, 0040 (r1 DELL    M07     27D70402 ASL        61)
May 29 12:25:05 corey kernel: ACPI: FACP 7FED4800, 0074 (r1 DELL    M07     27D70402 ASL        61)
May 29 12:25:05 corey kernel: ACPI: DSDT 7FED5400, 4841 (r1 INT430 SYSFexxx     1001 INTL 20050624)
May 29 12:25:05 corey kernel: ACPI: FACS 7FEE3C00, 0040
May 29 12:25:05 corey kernel: ACPI: HPET 7FED4F00, 0038 (r1 DELL    M07            1 ASL        61)
May 29 12:25:05 corey kernel: ACPI: APIC 7FED5000, 0068 (r1 DELL    M07     27D70402 ASL        47)
May 29 12:25:05 corey kernel: ACPI: MCFG 7FED4FC0, 003E (r16 DELL    M07     27D70402 ASL        61)
May 29 12:25:05 corey kernel: ACPI: SLIC 7FED509C, 0176 (r1 DELL    M07     27D70402 ASL        61)
May 29 12:25:05 corey kernel: ACPI: BOOT 7FED4BC0, 0028 (r1 DELL    M07     27D70402 ASL        61)
May 29 12:25:05 corey kernel: ACPI: SSDT 7FED3A0D, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
May 29 12:25:05 corey kernel: ACPI: PM-Timer IO Port: 0x1008
May 29 12:25:05 corey kernel: ACPI: Local APIC address 0xfee00000
May 29 12:25:05 corey kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
May 29 12:25:05 corey kernel: Processor #0 6:15 APIC version 20
May 29 12:25:05 corey kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
May 29 12:25:05 corey kernel: Processor #1 6:15 APIC version 20
May 29 12:25:05 corey kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
May 29 12:25:05 corey kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
May 29 12:25:05 corey kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
May 29 12:25:05 corey kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
May 29 12:25:05 corey kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
May 29 12:25:05 corey kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
May 29 12:25:05 corey kernel: ACPI: IRQ0 used by override.
May 29 12:25:05 corey kernel: ACPI: IRQ2 used by override.
May 29 12:25:05 corey kernel: ACPI: IRQ9 used by override.
May 29 12:25:05 corey kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
May 29 12:25:05 corey kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
May 29 12:25:05 corey kernel: Using ACPI (MADT) for SMP configuration information
May 29 12:25:05 corey kernel: Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
May 29 12:25:05 corey kernel: Built 1 zonelists.  Total pages: 519894
May 29 12:25:05 corey kernel: Kernel command line: root=/dev/sda1 ro resume=/dev/sda3
May 29 12:25:05 corey kernel: mapped APIC to ffffd000 (fee00000)
May 29 12:25:05 corey kernel: mapped IOAPIC to ffffc000 (fec00000)
May 29 12:25:05 corey kernel: Enabling fast FPU save and restore... done.
May 29 12:25:05 corey kernel: Enabling unmasked SIMD FPU exception support... done.
May 29 12:25:05 corey kernel: Initializing CPU#0
May 29 12:25:05 corey kernel: CPU 0 irqstacks, hard=c0376000 soft=c0378000
May 29 12:25:05 corey kernel: PID hash table entries: 4096 (order: 12, 16384 bytes)
May 29 12:25:05 corey kernel: Detected 2161.450 MHz processor.
May 29 12:25:05 corey kernel: Console: colour VGA+ 80x25
May 29 12:25:05 corey kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
May 29 12:25:05 corey kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
May 29 12:25:05 corey kernel: Memory: 2074664k/2095948k available (1619k kernel code, 20096k reserved, 673k data, 188k init, 1178444k highmem)
May 29 12:25:05 corey kernel: virtual kernel memory layout:
May 29 12:25:05 corey kernel:     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
May 29 12:25:05 corey kernel:     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
May 29 12:25:05 corey kernel:     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
May 29 12:25:05 corey kernel:     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
May 29 12:25:05 corey kernel:       .init : 0xc0342000 - 0xc0371000   ( 188 kB)
May 29 12:25:05 corey kernel:       .data : 0xc0294e87 - 0xc033d2ec   ( 673 kB)
May 29 12:25:05 corey kernel:       .text : 0xc0100000 - 0xc0294e87   (1619 kB)
May 29 12:25:05 corey kernel: Checking if this processor honours the WP bit even in supervisor mode... Ok.
May 29 12:25:05 corey kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
May 29 12:25:05 corey kernel: hpet0: 3 64-bit timers, 14318180 Hz
May 29 12:25:05 corey kernel: Calibrating delay using timer specific routine.. 4326.04 BogoMIPS (lpj=2163021)
May 29 12:25:05 corey kernel: Mount-cache hash table entries: 512
May 29 12:25:05 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
May 29 12:25:05 corey kernel: monitor/mwait feature present.
May 29 12:25:05 corey kernel: using mwait in idle threads.
May 29 12:25:05 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May 29 12:25:05 corey kernel: CPU: L2 cache: 4096K
May 29 12:25:05 corey kernel: CPU: Physical Processor ID: 0
May 29 12:25:05 corey kernel: CPU: Processor Core ID: 0
May 29 12:25:05 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
May 29 12:25:05 corey kernel: Intel machine check architecture supported.
May 29 12:25:05 corey kernel: Intel machine check reporting enabled on CPU#0.
May 29 12:25:05 corey kernel: Compat vDSO mapped to ffffe000.
May 29 12:25:05 corey kernel: Checking 'hlt' instruction... OK.
May 29 12:25:05 corey kernel: SMP alternatives: switching to UP code
May 29 12:25:05 corey kernel: ACPI: Core revision 20070126
May 29 12:25:05 corey kernel: CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
May 29 12:25:05 corey kernel: SMP alternatives: switching to SMP code
May 29 12:25:05 corey kernel: Booting processor 1/1 eip 3000
May 29 12:25:05 corey kernel: CPU 1 irqstacks, hard=c0377000 soft=c0379000
May 29 12:25:05 corey kernel: Initializing CPU#1
May 29 12:25:05 corey kernel: Calibrating delay using timer specific routine.. 4322.49 BogoMIPS (lpj=2161248)
May 29 12:25:05 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
May 29 12:25:05 corey kernel: monitor/mwait feature present.
May 29 12:25:05 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May 29 12:25:05 corey kernel: CPU: L2 cache: 4096K
May 29 12:25:05 corey kernel: CPU: Physical Processor ID: 0
May 29 12:25:05 corey kernel: CPU: Processor Core ID: 1
May 29 12:25:05 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
May 29 12:25:05 corey kernel: Intel machine check architecture supported.
May 29 12:25:05 corey kernel: Intel machine check reporting enabled on CPU#1.
May 29 12:25:05 corey kernel: CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
May 29 12:25:05 corey kernel: Total of 2 processors activated (8648.53 BogoMIPS).
May 29 12:25:05 corey kernel: ENABLING IO-APIC IRQs
May 29 12:25:05 corey kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
May 29 12:25:05 corey kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
May 29 12:25:05 corey kernel: Measured 4009077488 cycles TSC warp between CPUs, turning off TSC clock.
May 29 12:25:05 corey kernel: Marking TSC unstable due to: check_tsc_sync_source failed.
May 29 12:25:05 corey kernel: Brought up 2 CPUs
May 29 12:25:05 corey kernel: NET: Registered protocol family 16
May 29 12:25:05 corey kernel: ACPI: bus type pci registered
May 29 12:25:05 corey kernel: PCI: Using MMCONFIG
May 29 12:25:05 corey kernel: Setting up standard PCI resources
May 29 12:25:05 corey kernel: ACPI: Interpreter enabled
May 29 12:25:05 corey kernel: ACPI: (supports S0 S3 S4 S5)
May 29 12:25:05 corey kernel: ACPI: Using IOAPIC for interrupt routing
May 29 12:25:05 corey kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
May 29 12:25:05 corey kernel: PCI: Probing PCI hardware (bus 00)
May 29 12:25:05 corey kernel: PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
May 29 12:25:05 corey kernel: PCI quirk: region 1080-10bf claimed by ICH6 GPIO
May 29 12:25:05 corey kernel: PCI: Transparent bridge - 0000:00:1e.0
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *4
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs *9 10 11)
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
May 29 12:25:05 corey kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
May 29 12:25:05 corey kernel: pnp: PnP ACPI init
May 29 12:25:05 corey kernel: ACPI: bus type pnp registered
May 29 12:25:05 corey kernel: pnp: PnP ACPI: found 12 devices
May 29 12:25:05 corey kernel: ACPI: ACPI bus type pnp unregistered
May 29 12:25:05 corey kernel: SCSI subsystem initialized
May 29 12:25:05 corey kernel: libata version 2.21 loaded.
May 29 12:25:05 corey kernel: PCI: Using ACPI for IRQ routing
May 29 12:25:05 corey kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
May 29 12:25:05 corey kernel: ACPI: RTC can wake from S4
May 29 12:25:05 corey kernel: pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
May 29 12:25:05 corey kernel: pnp: 00:02: ioport range 0x1000-0x1005 has been reserved
May 29 12:25:05 corey kernel: pnp: 00:02: ioport range 0x1008-0x100f has been reserved
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0xf400-0xf4fe has been reserved
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0x1006-0x1007 has been reserved
May 29 12:25:05 corey kernel: Time: hpet clocksource has been installed.
May 29 12:25:05 corey kernel: Switched to high resolution mode on CPU 0
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0x100a-0x1059 could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0x1060-0x107f has been reserved
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0x1080-0x10bf has been reserved
May 29 12:25:05 corey kernel: Switched to high resolution mode on CPU 1
May 29 12:25:05 corey kernel: pnp: 00:03: ioport range 0x10c0-0x10df has been reserved
May 29 12:25:05 corey kernel: pnp: 00:08: ioport range 0xc80-0xcff could not be reserved
May 29 12:25:05 corey kernel: pnp: 00:08: ioport range 0x910-0x91f has been reserved
May 29 12:25:05 corey kernel: pnp: 00:08: ioport range 0x920-0x92f has been reserved
May 29 12:25:05 corey kernel: pnp: 00:08: ioport range 0xcb0-0xcbf has been reserved
May 29 12:25:05 corey kernel: pnp: 00:08: ioport range 0x930-0x97f has been reserved
May 29 12:25:05 corey kernel: pnp: 00:0b: iomem range 0xfed00000-0xfed003ff could not be reserved
May 29 12:25:05 corey kernel: PCI: Bridge: 0000:00:01.0
May 29 12:25:05 corey kernel:   IO window: e000-efff
May 29 12:25:05 corey kernel:   MEM window: efd00000-efefffff
May 29 12:25:05 corey kernel:   PREFETCH window: d0000000-dfffffff
May 29 12:25:05 corey kernel: PCI: Bridge: 0000:00:1c.0
May 29 12:25:05 corey kernel:   IO window: disabled.
May 29 12:25:05 corey kernel:   MEM window: disabled.
May 29 12:25:05 corey kernel:   PREFETCH window: disabled.
May 29 12:25:05 corey kernel: PCI: Bridge: 0000:00:1c.1
May 29 12:25:05 corey kernel:   IO window: disabled.
May 29 12:25:05 corey kernel:   MEM window: efc00000-efcfffff
May 29 12:25:05 corey kernel:   PREFETCH window: disabled.
May 29 12:25:05 corey kernel: PCI: Bridge: 0000:00:1c.3
May 29 12:25:05 corey kernel:   IO window: d000-dfff
May 29 12:25:05 corey kernel:   MEM window: efa00000-efbfffff
May 29 12:25:05 corey kernel:   PREFETCH window: e0000000-e01fffff
May 29 12:25:05 corey kernel: PCI: Bridge: 0000:00:1e.0
May 29 12:25:05 corey kernel:   IO window: disabled.
May 29 12:25:05 corey kernel:   MEM window: ef900000-ef9fffff
May 29 12:25:05 corey kernel:   PREFETCH window: disabled.
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 29 12:25:05 corey kernel: ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 29 12:25:05 corey kernel: NET: Registered protocol family 2
May 29 12:25:05 corey kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
May 29 12:25:05 corey kernel: TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
May 29 12:25:05 corey kernel: TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
May 29 12:25:05 corey kernel: TCP: Hash tables configured (established 131072 bind 65536)
May 29 12:25:05 corey kernel: TCP reno registered
May 29 12:25:05 corey kernel: Simple Boot Flag at 0x79 set to 0x1
May 29 12:25:05 corey kernel: Machine check exception polling timer started.
May 29 12:25:05 corey kernel: highmem bounce pool size: 64 pages
May 29 12:25:05 corey kernel: io scheduler noop registered
May 29 12:25:05 corey kernel: io scheduler anticipatory registered
May 29 12:25:05 corey kernel: io scheduler deadline registered (default)
May 29 12:25:05 corey kernel: pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
May 29 12:25:05 corey kernel: pci 0000:00:1d.0: Performing full reset
May 29 12:25:05 corey kernel: pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
May 29 12:25:05 corey kernel: pci 0000:00:1d.1: Performing full reset
May 29 12:25:05 corey kernel: pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
May 29 12:25:05 corey kernel: pci 0000:00:1d.2: Performing full reset
May 29 12:25:05 corey kernel: pci 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0080
May 29 12:25:05 corey kernel: pci 0000:00:1d.3: Performing full reset
May 29 12:25:05 corey kernel: Boot video device is 0000:01:00.0
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
May 29 12:25:05 corey kernel: assign_interrupt_mode Found MSI capability
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:01.0:pcie00]
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:01.0:pcie03]
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 29 12:25:05 corey kernel: assign_interrupt_mode Found MSI capability
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:1c.0:pcie00]
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:1c.0:pcie02]
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:1c.0:pcie03]
May 29 12:25:05 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 29 12:25:05 corey kernel: assign_interrupt_mode Found MSI capability
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:1c.1:pcie00]
May 29 12:25:05 corey kernel: Allocate Port Service[0000:00:1c.1:pcie02]
May 29 12:25:06 corey kernel: Allocate Port Service[0000:00:1c.1:pcie03]
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 29 12:25:06 corey kernel: assign_interrupt_mode Found MSI capability
May 29 12:25:06 corey kernel: Allocate Port Service[0000:00:1c.3:pcie00]
May 29 12:25:06 corey kernel: Allocate Port Service[0000:00:1c.3:pcie02]
May 29 12:25:06 corey kernel: Allocate Port Service[0000:00:1c.3:pcie03]
May 29 12:25:06 corey kernel: hpet_resources: 0xfed00000 is busy
May 29 12:25:06 corey kernel: Generic RTC Driver v1.07
May 29 12:25:06 corey kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
May 29 12:25:06 corey kernel: RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
May 29 12:25:06 corey kernel: ata_piix 0000:00:1f.2: version 2.11
May 29 12:25:06 corey kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 29 12:25:06 corey kernel: scsi0 : ata_piix
May 29 12:25:06 corey kernel: scsi1 : ata_piix
May 29 12:25:06 corey kernel: ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
May 29 12:25:06 corey kernel: ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001bfa8 irq 15
May 29 12:25:06 corey kernel: ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
May 29 12:25:06 corey kernel: ata1.00: ATA-7: ST9160821AS, 3.ALC, max UDMA/133
May 29 12:25:06 corey kernel: ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
May 29 12:25:06 corey kernel: ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
May 29 12:25:06 corey kernel: ata1.00: configured for UDMA/133
May 29 12:25:06 corey kernel: ata2.00: ATAPI, max UDMA/33
May 29 12:25:06 corey kernel: ata2.00: configured for UDMA/33
May 29 12:25:06 corey kernel: scsi 0:0:0:0: Direct-Access     ATA      ST9160821AS      3.AL PQ: 0 ANSI: 5
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 29 12:25:06 corey kernel:  sda: sda1 sda2 sda3
May 29 12:25:06 corey kernel: sd 0:0:0:0: [sda] Attached SCSI disk
May 29 12:25:06 corey kernel: scsi 1:0:0:0: CD-ROM            SONY     DVD+-RW DW-Q58A  UDS2 PQ: 0 ANSI: 5
May 29 12:25:06 corey kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
May 29 12:25:06 corey kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
May 29 12:25:06 corey kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
May 29 12:25:06 corey kernel: rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
May 29 12:25:06 corey kernel: rtc0: alarms up to one month, y3k
May 29 12:25:06 corey kernel: TCP cubic registered
May 29 12:25:06 corey kernel: Starting balanced_irq
May 29 12:25:06 corey kernel: Using IPI No-Shortcut mode
May 29 12:25:06 corey kernel: input: AT Translated Set 2 keyboard as /class/input/input0
May 29 12:25:06 corey kernel: rtc_cmos 00:06: setting the system clock to 2007-05-29 16:24:47 (1180455887)
May 29 12:25:06 corey kernel: kjournald starting.  Commit interval 5 seconds
May 29 12:25:06 corey kernel: EXT3-fs: mounted filesystem with ordered data mode.
May 29 12:25:06 corey kernel: VFS: Mounted root (ext3 filesystem) readonly.
May 29 12:25:06 corey kernel: Freeing unused kernel memory: 188k freed
May 29 12:25:06 corey kernel: NET: Registered protocol family 1
May 29 12:25:06 corey kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
May 29 12:25:06 corey kernel: scsi 1:0:0:0: Attached scsi generic sg1 type 5
May 29 12:25:06 corey kernel: sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
May 29 12:25:06 corey kernel: Uniform CD-ROM driver Revision: 3.20
May 29 12:25:06 corey kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
May 29 12:25:06 corey kernel: Linux agpgart interface v0.102 (c) Dave Jones
May 29 12:25:06 corey kernel: agpgart: Detected an Intel 945GM Chipset.
May 29 12:25:06 corey kernel: agpgart: AGP aperture is 256M @ 0x0
May 29 12:25:06 corey kernel: intel_rng: FWH not detected
May 29 12:25:06 corey kernel: usbcore: registered new interface driver usbfs
May 29 12:25:06 corey kernel: usbcore: registered new interface driver hub
May 29 12:25:06 corey kernel: usbcore: registered new device driver usb
May 29 12:25:06 corey kernel: USB Universal Host Controller Interface driver v3.0
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file 'devices'
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: detected 2 ports
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: Performing full reset
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000bf80
May 29 12:25:06 corey kernel: usb usb1: default language 0x0409
May 29 12:25:06 corey kernel: usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
May 29 12:25:06 corey kernel: usb usb1: Product: UHCI Host Controller
May 29 12:25:06 corey kernel: usb usb1: Manufacturer: Linux 2.6.22-rc3 uhci_hcd
May 29 12:25:06 corey kernel: usb usb1: SerialNumber: 0000:00:1d.0
May 29 12:25:06 corey kernel: usb usb1: uevent
May 29 12:25:06 corey kernel: usb usb1: usb_probe_device
May 29 12:25:06 corey kernel: usb usb1: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb usb1: adding 1-0:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 1-0:1.0: uevent
May 29 12:25:06 corey kernel: usb 1-0:1.0: uevent
May 29 12:25:06 corey kernel: hub 1-0:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 1-0:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 1-0:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 1-0:1.0: 2 ports detected
May 29 12:25:06 corey kernel: hub 1-0:1.0: standalone hub
May 29 12:25:06 corey kernel: hub 1-0:1.0: no power switching (usb 1.0)
May 29 12:25:06 corey kernel: hub 1-0:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 1-0:1.0: power on to power good time: 2ms
May 29 12:25:06 corey kernel: hub 1-0:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 1-0:1.0: trying to enable port power on non-switchable hub
May 29 12:25:06 corey kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
May 29 12:25:06 corey kernel: hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 20
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '002'
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: detected 2 ports
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: Performing full reset
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000bf60
May 29 12:25:06 corey kernel: usb usb2: default language 0x0409
May 29 12:25:06 corey kernel: usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
May 29 12:25:06 corey kernel: usb usb2: Product: UHCI Host Controller
May 29 12:25:06 corey kernel: usb usb2: Manufacturer: Linux 2.6.22-rc3 uhci_hcd
May 29 12:25:06 corey kernel: usb usb2: SerialNumber: 0000:00:1d.1
May 29 12:25:06 corey kernel: usb usb2: uevent
May 29 12:25:06 corey kernel: usb usb2: usb_probe_device
May 29 12:25:06 corey kernel: usb usb2: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb usb2: adding 2-0:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 2-0:1.0: uevent
May 29 12:25:06 corey kernel: usb 2-0:1.0: uevent
May 29 12:25:06 corey kernel: hub 2-0:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 2-0:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 2-0:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 2-0:1.0: 2 ports detected
May 29 12:25:06 corey kernel: hub 2-0:1.0: standalone hub
May 29 12:25:06 corey kernel: hub 2-0:1.0: no power switching (usb 1.0)
May 29 12:25:06 corey kernel: hub 2-0:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 2-0:1.0: power on to power good time: 2ms
May 29 12:25:06 corey kernel: hub 2-0:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 2-0:1.0: trying to enable port power on non-switchable hub
May 29 12:25:06 corey kernel: ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
May 29 12:25:06 corey kernel: input: PC Speaker as /class/input/input1
May 29 12:25:06 corey kernel: sdhci: Secure Digital Host Controller Interface driver
May 29 12:25:06 corey kernel: sdhci: Copyright(c) Pierre Ossman
May 29 12:25:06 corey kernel: ieee80211_crypt: registered algorithm 'NULL'
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 21
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '003'
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: detected 2 ports
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: Performing full reset
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000bf40
May 29 12:25:06 corey kernel: usb usb3: default language 0x0409
May 29 12:25:06 corey kernel: usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
May 29 12:25:06 corey kernel: usb usb3: Product: UHCI Host Controller
May 29 12:25:06 corey kernel: usb usb3: Manufacturer: Linux 2.6.22-rc3 uhci_hcd
May 29 12:25:06 corey kernel: usb usb3: SerialNumber: 0000:00:1d.2
May 29 12:25:06 corey kernel: usb usb3: uevent
May 29 12:25:06 corey kernel: usb usb3: usb_probe_device
May 29 12:25:06 corey kernel: usb usb3: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb usb3: adding 3-0:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 3-0:1.0: uevent
May 29 12:25:06 corey kernel: usb 3-0:1.0: uevent
May 29 12:25:06 corey kernel: hub 3-0:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 3-0:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 3-0:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 3-0:1.0: 2 ports detected
May 29 12:25:06 corey kernel: hub 3-0:1.0: standalone hub
May 29 12:25:06 corey kernel: hub 3-0:1.0: no power switching (usb 1.0)
May 29 12:25:06 corey kernel: hub 3-0:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 3-0:1.0: power on to power good time: 2ms
May 29 12:25:06 corey kernel: hub 3-0:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 3-0:1.0: trying to enable port power on non-switchable hub
May 29 12:25:06 corey kernel: hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
May 29 12:25:06 corey kernel: ieee80211: 802.11 data/management/control stack, git-1.1.13
May 29 12:25:06 corey kernel: ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 22
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '004'
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: detected 2 ports
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: Performing full reset
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.3: irq 22, io base 0x0000bf20
May 29 12:25:06 corey kernel: usb usb4: default language 0x0409
May 29 12:25:06 corey kernel: usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
May 29 12:25:06 corey kernel: usb usb4: Product: UHCI Host Controller
May 29 12:25:06 corey kernel: usb usb4: Manufacturer: Linux 2.6.22-rc3 uhci_hcd
May 29 12:25:06 corey kernel: usb usb4: SerialNumber: 0000:00:1d.3
May 29 12:25:06 corey kernel: usb usb4: uevent
May 29 12:25:06 corey kernel: usb usb4: usb_probe_device
May 29 12:25:06 corey kernel: usb usb4: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb usb4: adding 4-0:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 4-0:1.0: uevent
May 29 12:25:06 corey kernel: usb 4-0:1.0: uevent
May 29 12:25:06 corey kernel: hub 4-0:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 4-0:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 4-0:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 4-0:1.0: 2 ports detected
May 29 12:25:06 corey kernel: hub 4-0:1.0: standalone hub
May 29 12:25:06 corey kernel: hub 4-0:1.0: no power switching (usb 1.0)
May 29 12:25:06 corey kernel: hub 4-0:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 4-0:1.0: power on to power good time: 2ms
May 29 12:25:06 corey kernel: hub 4-0:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 4-0:1.0: trying to enable port power on non-switchable hub
May 29 12:25:06 corey kernel: usb 1-1: new full speed USB device using uhci_hcd and address 2
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '005'
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: debug port 1
May 29 12:25:06 corey kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: supports USB remote wakeup
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffa80000
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0 period=1024 Reset HALT
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 29 12:25:06 corey kernel: usb usb5: default language 0x0409
May 29 12:25:06 corey kernel: usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
May 29 12:25:06 corey kernel: usb usb5: Product: EHCI Host Controller
May 29 12:25:06 corey kernel: usb usb5: Manufacturer: Linux 2.6.22-rc3 ehci_hcd
May 29 12:25:06 corey kernel: usb usb5: SerialNumber: 0000:00:1d.7
May 29 12:25:06 corey kernel: usb usb5: uevent
May 29 12:25:06 corey kernel: usb usb5: usb_probe_device
May 29 12:25:06 corey kernel: usb usb5: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb usb5: adding 5-0:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 5-0:1.0: uevent
May 29 12:25:06 corey kernel: usb 5-0:1.0: uevent
May 29 12:25:06 corey kernel: hub 5-0:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 5-0:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 5-0:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 5-0:1.0: 8 ports detected
May 29 12:25:06 corey kernel: hub 5-0:1.0: standalone hub
May 29 12:25:06 corey kernel: hub 5-0:1.0: no power switching (usb 1.0)
May 29 12:25:06 corey kernel: hub 5-0:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 5-0:1.0: Single TT
May 29 12:25:06 corey kernel: hub 5-0:1.0: TT requires at most 8 FS bit times (666 ns)
May 29 12:25:06 corey kernel: hub 5-0:1.0: power on to power good time: 20ms
May 29 12:25:06 corey kernel: hub 5-0:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 5-0:1.0: trying to enable port power on non-switchable hub
May 29 12:25:06 corey kernel: ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.1d
May 29 12:25:06 corey kernel: ipw3945: Copyright(c) 2003-2006 Intel Corporation
May 29 12:25:06 corey kernel: usb 1-1: uhci_result_common: failed with status 440000
May 29 12:25:06 corey kernel: Synaptics Touchpad, model: 1, fw: 6.2, id: 0xfa0b1, caps: 0xa04713/0x200000
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '001'
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 18
May 29 12:25:06 corey kernel: input: SynPS/2 Synaptics TouchPad as /class/input/input2
May 29 12:25:06 corey kernel: mice: PS/2 mouse device common for all mice
May 29 12:25:06 corey kernel: fw_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
May 29 12:25:06 corey kernel: sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 19)
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 23
May 29 12:25:06 corey kernel: mmc0: SDHCI at 0xef9fd400 irq 23 DMA
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 20
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 29 12:25:06 corey kernel: usb 1-1: uhci_result_common: failed with status 440000
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
May 29 12:25:06 corey kernel: PCI: Setting latency timer of device 0000:0c:00.0 to 64
May 29 12:25:06 corey kernel: ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
May 29 12:25:06 corey kernel: usb 1-1: device not accepting address 2, error -71
May 29 12:25:06 corey kernel: b44.c:v1.01 (Jun 16, 2006)
May 29 12:25:06 corey kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
May 29 12:25:06 corey kernel: eth0: Broadcom 4400 10/100BaseT Ethernet 00:18:8b:a7:bf:42
May 29 12:25:06 corey kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
May 29 12:25:06 corey kernel: hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
May 29 12:25:06 corey kernel: Adding 2064344k swap on /dev/sda3.  Priority:-1 extents:1 across:2064344k
May 29 12:25:06 corey kernel: hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
May 29 12:25:06 corey kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:06 corey kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
May 29 12:25:06 corey kernel: hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:06 corey kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
May 29 12:25:06 corey kernel: hub 5-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
May 29 12:25:06 corey kernel: EXT3 FS on sda1, internal journal
May 29 12:25:06 corey kernel: fw_core: created new fw device fw0 (0 config rom retries)
May 29 12:25:06 corey kernel: hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: port 1 high speed
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
May 29 12:25:06 corey kernel: usb 5-1: new high speed USB device using ehci_hcd and address 2
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: port 1 high speed
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
May 29 12:25:06 corey kernel: usb 5-1: new device strings: Mfr=0, Product=0, SerialNumber=0
May 29 12:25:06 corey kernel: usb 5-1: uevent
May 29 12:25:06 corey kernel: usb 5-1: usb_probe_device
May 29 12:25:06 corey kernel: usb 5-1: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb 5-1: adding 5-1:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 5-1:1.0: uevent
May 29 12:25:06 corey kernel: usb 5-1:1.0: uevent
May 29 12:25:06 corey kernel: hub 5-1:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: hub 5-1:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: hub 5-1:1.0: USB hub found
May 29 12:25:06 corey kernel: hub 5-1:1.0: 4 ports detected
May 29 12:25:06 corey kernel: hub 5-1:1.0: compound device; port removable status: FFRF
May 29 12:25:06 corey kernel: hub 5-1:1.0: individual port power switching
May 29 12:25:06 corey kernel: hub 5-1:1.0: individual port over-current protection
May 29 12:25:06 corey kernel: hub 5-1:1.0: TT per port
May 29 12:25:06 corey kernel: hub 5-1:1.0: TT requires at most 8 FS bit times (666 ns)
May 29 12:25:06 corey kernel: hub 5-1:1.0: power on to power good time: 100ms
May 29 12:25:06 corey kernel: hub 5-1:1.0: local power source is good
May 29 12:25:06 corey kernel: hub 5-1:1.0: enabling power on all ports
May 29 12:25:06 corey kernel: usb usb3: suspend_rh (auto-stop)
May 29 12:25:06 corey kernel: usb 5-1: link qh256-0001/f77c6100 start 255 [1/0 us]
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '002'
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
May 29 12:25:06 corey kernel: hub 5-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
May 29 12:25:06 corey kernel: usb usb4: suspend_rh (auto-stop)
May 29 12:25:06 corey kernel: kjournald starting.  Commit interval 5 seconds
May 29 12:25:06 corey kernel: EXT3 FS on sda2, internal journal
May 29 12:25:06 corey kernel: EXT3-fs: mounted filesystem with ordered data mode.
May 29 12:25:06 corey kernel: hub 5-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
May 29 12:25:06 corey kernel: hub 5-1:1.0: state 7 ports 4 chg 0000 evt 0000
May 29 12:25:06 corey kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0008
May 29 12:25:06 corey kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 01a3,00
May 29 12:25:06 corey kernel: hub 2-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
May 29 12:25:06 corey kernel: hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
May 29 12:25:06 corey kernel: NET: Registered protocol family 15
May 29 12:25:06 corey kernel: usb 2-1: new low speed USB device using uhci_hcd and address 2
May 29 12:25:06 corey kernel: NET: Registered protocol family 17
May 29 12:25:06 corey kernel: usb 2-1: skipped 1 descriptor after interface
May 29 12:25:06 corey kernel: usb 2-1: default language 0x0409
May 29 12:25:06 corey kernel: usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
May 29 12:25:06 corey kernel: usb 2-1: Product: Optical USB Mouse
May 29 12:25:06 corey kernel: usb 2-1: Manufacturer: Logitech
May 29 12:25:06 corey kernel: usb 2-1: uevent
May 29 12:25:06 corey kernel: usb 2-1: usb_probe_device
May 29 12:25:06 corey kernel: usb 2-1: configuration #1 chosen from 1 choice
May 29 12:25:06 corey kernel: usb 2-1: adding 2-1:1.0 (config #1, interface 0)
May 29 12:25:06 corey kernel: usb 2-1:1.0: uevent
May 29 12:25:06 corey kernel: usb 2-1:1.0: uevent
May 29 12:25:06 corey kernel: drivers/usb/core/inode.c: creating file '002'
May 29 12:25:06 corey kernel: hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
May 29 12:25:06 corey kernel: usb usb1: suspend_rh (auto-stop)
May 29 12:25:06 corey kernel: usbcore: registered new interface driver hiddev
May 29 12:25:06 corey kernel: usbhid 2-1:1.0: usb_probe_interface
May 29 12:25:06 corey kernel: usbhid 2-1:1.0: usb_probe_interface - got id
May 29 12:25:06 corey kernel: input: Logitech Optical USB Mouse as /class/input/input3
May 29 12:25:06 corey kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1
May 29 12:25:06 corey kernel: usbcore: registered new interface driver usbhid
May 29 12:25:06 corey kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
May 29 12:25:06 corey kernel: hub 3-0:1.0: hub_suspend
May 29 12:25:06 corey kernel: usb usb3: suspend_rh
May 29 12:25:06 corey kernel: usb usb3: usb auto-suspend
May 29 12:25:06 corey kernel: hub 1-0:1.0: hub_suspend
May 29 12:25:06 corey kernel: usb usb1: suspend_rh
May 29 12:25:06 corey kernel: usb usb1: usb auto-suspend
May 29 12:25:06 corey kernel: hub 4-0:1.0: hub_suspend
May 29 12:25:06 corey kernel: usb usb4: suspend_rh
May 29 12:25:06 corey kernel: usb usb4: usb auto-suspend
May 29 12:25:06 corey kernel: hub 5-1:1.0: hub_suspend
May 29 12:25:06 corey kernel: usb 5-1: unlink qh256-0001/f77c6100 start 255 [1/0 us]
May 29 12:25:06 corey kernel: usb 5-1: usb auto-suspend
May 29 12:25:06 corey kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
May 29 12:25:06 corey kernel: b44: eth0: Flow control is off for TX and off for RX.
May 29 12:25:06 corey kernel: hub 5-0:1.0: hub_suspend
May 29 12:25:06 corey kernel: ehci_hcd 0000:00:1d.7: suspend root hub
May 29 12:25:06 corey kernel: usb usb5: usb auto-suspend
May 29 12:25:06 corey kernel: io scheduler cfq registered
May 29 12:25:06 corey kernel: Bluetooth: Core ver 2.11
May 29 12:25:06 corey kernel: NET: Registered protocol family 31
May 29 12:25:06 corey kernel: Bluetooth: HCI device and connection manager initialized
May 29 12:25:06 corey kernel: Bluetooth: HCI socket layer initialized
May 29 12:25:06 corey kernel: Bluetooth: L2CAP ver 2.8
May 29 12:25:06 corey kernel: Bluetooth: L2CAP socket layer initialized
May 29 12:25:06 corey kernel: Bluetooth: RFCOMM socket layer initialized
May 29 12:25:06 corey kernel: Bluetooth: RFCOMM TTY layer initialized
May 29 12:25:06 corey kernel: Bluetooth: RFCOMM ver 1.8
May 29 12:25:06 corey kernel: fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
May 29 12:25:06 corey kernel: [fglrx] Maximum main memory to use for locked dma buffers: 1899 MBytes.
May 29 12:25:06 corey kernel: [fglrx] module loaded - fglrx 8.36.5 [Apr 17 2007] on minor 0
May 29 12:25:06 corey kernel: ACPI: AC Adapter [AC] (on-line)
May 29 12:25:06 corey kernel: set_level status: 0
May 29 12:25:06 corey kernel: ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
May 29 12:25:06 corey kernel: set_level status: 0
May 29 12:25:06 corey kernel: ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
May 29 12:25:06 corey kernel: ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
May 29 12:25:06 corey kernel: input: Lid Switch as /class/input/input4
May 29 12:25:06 corey kernel: ACPI: Lid Switch [LID]
May 29 12:25:06 corey kernel: input: Power Button (CM) as /class/input/input5
May 29 12:25:06 corey kernel: ACPI: Power Button (CM) [PBTN]
May 29 12:25:06 corey kernel: input: Sleep Button (CM) as /class/input/input6
May 29 12:25:06 corey kernel: ACPI: Sleep Button (CM) [SBTN]
May 29 12:25:06 corey kernel: ACPI: Battery Slot [BAT0] (battery present)
May 29 12:25:06 corey kernel: ACPI: SSDT 7FED4134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
May 29 12:25:06 corey kernel: ACPI: SSDT 7FED3EE9, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
May 29 12:25:06 corey kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
May 29 12:25:06 corey kernel: ACPI: Processor [CPU0] (supports 8 throttling states)
May 29 12:25:06 corey kernel: ACPI: SSDT 7FED4378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
May 29 12:25:06 corey kernel: ACPI: SSDT 7FED40AF, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
May 29 12:25:06 corey kernel: ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
May 29 12:25:06 corey kernel: ACPI: Processor [CPU1] (supports 8 throttling states)
May 29 12:25:06 corey kernel: ACPI: Thermal Zone [THM] (74 C)
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:06 corey kernel: uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:07 corey dhcdbd: Started up.
May 29 12:25:07 corey NetworkManager: <information>^Istarting... 
May 29 12:25:07 corey NetworkManager: <WARNING>^I main (): nm_data_new: Setting up dbus filter 
May 29 12:25:07 corey NetworkManager: <information>^Ieth0: Device is fully-supported using driver 'b44'. 
May 29 12:25:07 corey NetworkManager: <information>^Inm_device_init(): waiting for device's worker thread to start 
May 29 12:25:07 corey NetworkManager: <information>^Inm_device_init(): device's worker thread started, continuing. 
May 29 12:25:07 corey NetworkManager: <information>^INow managing wired Ethernet (802.3) device 'eth0'. 
May 29 12:25:07 corey hpiod: 0.9.7 accepting connections at 55014... 
May 29 12:25:07 corey dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
May 29 12:25:07 corey NetworkManager: <information>^IWill activate wired connection 'eth0' because it now has a link. 
May 29 12:25:07 corey NetworkManager: <information>^ISWITCH: no current connection, found better connection 'eth0'. 
May 29 12:25:07 corey dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
May 29 12:25:07 corey NetworkManager: <information>^IWill activate connection 'eth0'. 
May 29 12:25:07 corey NetworkManager: <information>^IDevice eth0 activation scheduled... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) started... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) scheduled... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) started... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) scheduled... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) complete. 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) starting... 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) successful. 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) scheduled. 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) complete. 
May 29 12:25:07 corey NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) started... 
May 29 12:25:07 corey NetworkManager: <information>^Imatch 
May 29 12:25:08 corey atieventsd[3877]: ATI External Events Daemon started... 
May 29 12:25:08 corey atieventsd[3877]: Event daemon control socket created 
May 29 12:25:08 corey atieventsd[3877]: acpid connection established 
May 29 12:25:08 corey kernel: uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:08 corey kernel: uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:08 corey kernel: uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:25:08 corey NetworkManager: <information>^IActivation (eth0) Beginning DHCP transaction. 
May 29 12:25:08 corey kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
May 29 12:25:08 corey NetworkManager: <information>^IDHCP daemon state is now 12 (successfully started) for interface eth0 
May 29 12:25:08 corey NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) complete. 
May 29 12:25:08 corey kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 29 12:25:08 corey kernel: NFSD: starting 90-second grace period
May 29 12:25:08 corey sshd[4140]: Server listening on 0.0.0.0 port 22.
May 29 12:25:09 corey rpc.statd[4186]: Version 1.0.7 Starting
May 29 12:25:09 corey rpc.statd[4186]: statd running as root. chown /var/lib/nfs/sm to choose different user 
May 29 12:25:09 corey rpc.statd[4186]: gethostbyname error for corey
May 29 12:25:09 corey hcid[4202]: Bluetooth HCI daemon
May 29 12:25:09 corey hcid[4202]: Can't get system message bus name: Connection ":1.4" is not allowed to own the service "org.bluez" due to security policies in the configuration file
May 29 12:25:09 corey sdpd[4205]: Bluetooth SDP daemon 
May 29 12:25:09 corey kernel: usb usb5: usb auto-resume
May 29 12:25:09 corey kernel: usb usb5: finish resume
May 29 12:25:09 corey kernel: hub 5-0:1.0: hub_resume
May 29 12:25:09 corey kernel: ehci_hcd 0000:00:1d.7: resume root hub
May 29 12:25:09 corey kernel: usb 5-1: usb auto-resume
May 29 12:25:09 corey kernel: hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
May 29 12:25:09 corey kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
May 29 12:25:09 corey kernel: usb 5-1: finish resume
May 29 12:25:09 corey kernel: hub 5-1:1.0: hub_resume
May 29 12:25:09 corey kernel: ehci_hcd 0000:00:1d.7: reused qh f77c6100 schedule
May 29 12:25:09 corey kernel: usb 5-1: link qh256-0001/f77c6100 start 255 [1/0 us]
May 29 12:25:09 corey kernel: hub 5-1:1.0: state 7 ports 4 chg 0000 evt 0000
May 29 12:25:09 corey kernel: usb usb3: usb auto-resume
May 29 12:25:09 corey kernel: usb usb3: finish resume
May 29 12:25:09 corey kernel: hub 3-0:1.0: hub_resume
May 29 12:25:09 corey kernel: usb usb3: wakeup_rh
May 29 12:25:09 corey kernel: hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:09 corey kernel: usb usb1: usb auto-resume
May 29 12:25:09 corey kernel: usb usb1: finish resume
May 29 12:25:09 corey kernel: hub 1-0:1.0: hub_resume
May 29 12:25:09 corey kernel: usb usb1: wakeup_rh
May 29 12:25:09 corey kernel: hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:09 corey kernel: usb usb4: usb auto-resume
May 29 12:25:09 corey kernel: usb usb4: finish resume
May 29 12:25:09 corey kernel: hub 4-0:1.0: hub_resume
May 29 12:25:09 corey kernel: usb usb4: wakeup_rh
May 29 12:25:09 corey kernel: hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:25:09 corey NetworkManager: <information>^IDHCP daemon state is now 1 (starting) for interface eth0 
May 29 12:25:10 corey kernel: usb usb3: suspend_rh (auto-stop)
May 29 12:25:10 corey kernel: usb usb1: suspend_rh (auto-stop)
May 29 12:25:10 corey kernel: usb usb4: suspend_rh (auto-stop)
May 29 12:25:11 corey dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
May 29 12:25:11 corey dhclient: DHCPACK from 10.0.0.2
May 29 12:25:11 corey dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
May 29 12:25:11 corey dhcdbd: dhco_input_option: Value corey cannot be converted to type X 
May 29 12:25:11 corey dhcdbd: dhco_parse_option_settings: bad option setting: new_host_name = corey 
May 29 12:25:11 corey NetworkManager: <information>^IDHCP daemon state is now 4 (reboot) for interface eth0 
May 29 12:25:11 corey NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) scheduled... 
May 29 12:25:11 corey NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) started... 
May 29 12:25:11 corey dhclient: bound to 10.0.0.6 -- renewal in 32750 seconds.
May 29 12:25:11 corey kernel: hub 5-1:1.0: hub_suspend
May 29 12:25:11 corey kernel: usb 5-1: unlink qh256-0001/f77c6100 start 255 [1/0 us]
May 29 12:25:11 corey kernel: usb 5-1: usb auto-suspend
May 29 12:25:11 corey kernel: hub 3-0:1.0: hub_suspend
May 29 12:25:11 corey kernel: usb usb3: suspend_rh
May 29 12:25:11 corey kernel: usb usb3: usb auto-suspend
May 29 12:25:11 corey kernel: hub 1-0:1.0: hub_suspend
May 29 12:25:11 corey kernel: usb usb1: suspend_rh
May 29 12:25:11 corey kernel: usb usb1: usb auto-suspend
May 29 12:25:11 corey kernel: hub 4-0:1.0: hub_suspend
May 29 12:25:11 corey kernel: usb usb4: suspend_rh
May 29 12:25:11 corey kernel: usb usb4: usb auto-suspend
May 29 12:25:11 corey kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 29 12:25:13 corey kernel: hub 5-0:1.0: hub_suspend
May 29 12:25:13 corey kernel: ehci_hcd 0000:00:1d.7: suspend root hub
May 29 12:25:13 corey kernel: usb usb5: usb auto-suspend
May 29 12:25:14 corey kernel: [fglrx] total      GART = 130023424
May 29 12:25:14 corey kernel: [fglrx] free       GART = 114032640
May 29 12:25:14 corey kernel: [fglrx] max single GART = 114032640
May 29 12:25:14 corey kernel: [fglrx] total      LFB  = 134086656
May 29 12:25:14 corey kernel: [fglrx] free       LFB  = 104214528
May 29 12:25:14 corey kernel: [fglrx] max single LFB  = 104214528
May 29 12:25:14 corey kernel: [fglrx] total      Inv  = 0
May 29 12:25:14 corey kernel: [fglrx] free       Inv  = 0
May 29 12:25:14 corey kernel: [fglrx] max single Inv  = 0
May 29 12:25:14 corey kernel: [fglrx] total      TIM  = 0
May 29 12:25:15 corey kernel: Clocksource tsc unstable (delta = -241350051 ns)
May 29 12:25:25 corey kdm_greet[4350]: Internal error: memory corruption detected
May 29 12:25:25 corey kdm: :0[4313]: (pam_unix) session opened for user root by (uid=0)
May 29 12:25:32 corey dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.host_name
May 29 12:25:32 corey dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
May 29 12:25:32 corey dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
May 29 12:25:32 corey NetworkManager: <information>^IRetrieved the following IP4 configuration from the DHCP daemon: 
May 29 12:25:32 corey NetworkManager: <information>^I  address 10.0.0.6 
May 29 12:25:32 corey NetworkManager: <information>^I  netmask 255.255.255.0 
May 29 12:25:32 corey NetworkManager: <information>^I  broadcast 10.0.0.255 
May 29 12:25:32 corey NetworkManager: <information>^I  gateway 10.0.0.2 
May 29 12:25:32 corey NetworkManager: <information>^I  nameserver 10.0.0.2 
May 29 12:25:32 corey NetworkManager: <information>^I  nameserver 206.191.0.140 
May 29 12:25:32 corey NetworkManager: <information>^I  nameserver 206.191.0.210 
May 29 12:25:32 corey NetworkManager: <information>^I  domain name 'localnet.' 
May 29 12:25:32 corey NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) scheduled... 
May 29 12:25:32 corey NetworkManager: <information>^IActivation (eth0) Stage 4 of 5 (IP Configure Get) complete. 
May 29 12:25:32 corey NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) started... 
May 29 12:25:33 corey NetworkManager: <information>^IDHCP returned name servers but system has disabled dynamic modification! 
May 29 12:25:33 corey NetworkManager: <information>^IActivation (eth0) successful, device activated. 
May 29 12:25:33 corey NetworkManager: <information>^IActivation (eth0) Finish handler scheduled. 
May 29 12:25:33 corey NetworkManager: <information>^IActivation (eth0) Stage 5 of 5 (IP Configure Commit) complete. 
May 29 12:25:33 corey NetworkManager: <information>^Imatch 
May 29 12:25:50 corey logger: kde up and running after boot
May 29 12:25:58 corey logger: doing suspend
May 29 12:25:59 corey logger: /ulb/suspend.sh 
May 29 12:25:59 corey kernel: uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period 8, phase 4, 93 us
May 29 12:26:18 corey NetworkManager: <information>^ISWITCH: terminating current connection 'eth0' because it's no longer valid. 
May 29 12:26:18 corey NetworkManager: <information>^IDeactivating device eth0. 
May 29 12:26:18 corey kernel: Stopping tasks ... done.
May 29 12:26:18 corey kernel: Suspending console(s)
May 29 12:26:18 corey kernel: usb 2-1: usb suspend
May 29 12:26:18 corey kernel: usb_device usbdev5.2: PM: suspend 0->2, parent 5-1 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.2_ep81: PM: suspend 0->2, parent 5-1:1.0 already 2
May 29 12:26:18 corey kernel: hub 5-1:1.0: PM: suspend 2->2, parent 5-1 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.2_ep00: PM: suspend 0->2, parent 5-1 already 2
May 29 12:26:18 corey kernel: usb 5-1: PM: suspend 2->2, parent usb5 already 2
May 29 12:26:18 corey kernel: usb_device usbdev5.1: PM: suspend 0->2, parent usb5 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.1_ep81: PM: suspend 0->2, parent 5-0:1.0 already 2
May 29 12:26:18 corey kernel: hub 5-0:1.0: PM: suspend 2->2, parent usb5 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.1_ep00: PM: suspend 0->2, parent usb5 already 2
May 29 12:26:18 corey kernel: usb_device usbdev4.1: PM: suspend 0->2, parent usb4 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev4.1_ep81: PM: suspend 0->2, parent 4-0:1.0 already 2
May 29 12:26:18 corey kernel: hub 4-0:1.0: PM: suspend 2->2, parent usb4 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev4.1_ep00: PM: suspend 0->2, parent usb4 already 2
May 29 12:26:18 corey kernel: usb_device usbdev3.1: PM: suspend 0->2, parent usb3 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev3.1_ep81: PM: suspend 0->2, parent 3-0:1.0 already 2
May 29 12:26:18 corey kernel: hub 3-0:1.0: PM: suspend 2->2, parent usb3 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev3.1_ep00: PM: suspend 0->2, parent usb3 already 2
May 29 12:26:18 corey kernel: hub 2-0:1.0: hub_suspend
May 29 12:26:18 corey kernel: usb usb2: suspend_rh
May 29 12:26:18 corey kernel: usb usb2: usb suspend
May 29 12:26:18 corey kernel: usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
May 29 12:26:18 corey kernel: hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Stopping disk
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:03:01.1 disabled
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
May 29 12:26:18 corey kernel: eth%%d: Going into suspend...
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:0c:00.0 disabled
May 29 12:26:18 corey kernel: [fglrx] firegl_gps_setpowerdown .
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:01:00.0 disabled
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 29 12:26:18 corey kernel: ehci_hcd 0000:00:1d.7: --> PCI D3/wakeup
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: uhci_suspend
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: --> PCI D0/legacy
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: uhci_suspend
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: --> PCI D0/legacy
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: uhci_suspend
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: --> PCI D0/legacy
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: uhci_suspend
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: --> PCI D0/legacy
May 29 12:26:18 corey kernel: ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 29 12:26:18 corey kernel: Disabling non-boot CPUs ...
May 29 12:26:18 corey kernel: CPU 1 is now offline
May 29 12:26:18 corey kernel: SMP alternatives: switching to UP code
May 29 12:26:18 corey kernel: CPU1 is down
May 29 12:26:18 corey kernel: Intel machine check architecture supported.
May 29 12:26:18 corey kernel: Intel machine check reporting enabled on CPU#0.
May 29 12:26:18 corey kernel: Back to C!
May 29 12:26:18 corey kernel: Enabling non-boot CPUs ...
May 29 12:26:18 corey kernel: SMP alternatives: switching to SMP code
May 29 12:26:18 corey kernel: Booting processor 1/1 eip 3000
May 29 12:26:18 corey kernel: CPU 1 irqstacks, hard=c0377000 soft=c0379000
May 29 12:26:18 corey kernel: Initializing CPU#1
May 29 12:26:18 corey kernel: Calibrating delay using timer specific routine.. 4323.29 BogoMIPS (lpj=2161646)
May 29 12:26:18 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
May 29 12:26:18 corey kernel: monitor/mwait feature present.
May 29 12:26:18 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
May 29 12:26:18 corey kernel: CPU: L2 cache: 4096K
May 29 12:26:18 corey kernel: CPU: Physical Processor ID: 0
May 29 12:26:18 corey kernel: CPU: Processor Core ID: 1
May 29 12:26:18 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
May 29 12:26:18 corey kernel: Intel machine check architecture supported.
May 29 12:26:18 corey kernel: Intel machine check reporting enabled on CPU#1.
May 29 12:26:18 corey kernel: CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
May 29 12:26:18 corey kernel: CPU1 is up
May 29 12:26:18 corey kernel: Switched to high resolution mode on CPU 1
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:01.0 at offset a (was f, writing 0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset f (was 100, writing 10b)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 4 (was ffa7c004, writing efffc004)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 3 (was 0, writing 10)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100000, writing 100102)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 20
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset f (was 100, writing 20100)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 9 (was 10001, writing 1fff1)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 8 (was 0, writing fff0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was 0, writing 200000f0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 6 (was 0, writing b0b00)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was 810000, writing 810010)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100000, writing 100007)
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset f (was 200, writing 20200)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 9 (was 10001, writing 1fff1)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 8 (was 0, writing efc0efc0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 7 (was 20000000, writing 200000f0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 6 (was 0, writing c0c00)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 3 (was 810000, writing 810010)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100000, writing 100107)
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset f (was 400, writing 20400)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e011e001)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing efb0efa0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 0, writing d0d0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 6 (was 0, writing e0d00)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100007)
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: PCI legacy resume
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: uhci_resume
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0008
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.0: Performing full reset
May 29 12:26:18 corey kernel: usb usb1: root hub lost power or was reset
May 29 12:26:18 corey kernel: usb usb1: suspend_rh
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: PCI legacy resume
May 29 12:26:18 corey kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 20
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: uhci_resume
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: Performing full reset
May 29 12:26:18 corey kernel: usb usb2: root hub lost power or was reset
May 29 12:26:18 corey kernel: usb usb2: suspend_rh
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: PCI legacy resume
May 29 12:26:18 corey kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 21
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: uhci_resume
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.2: Performing full reset
May 29 12:26:18 corey kernel: usb usb3: root hub lost power or was reset
May 29 12:26:18 corey kernel: usb usb3: suspend_rh
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: PCI legacy resume
May 29 12:26:18 corey kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 22
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: uhci_resume
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.3: Performing full reset
May 29 12:26:18 corey kernel: usb usb4: root hub lost power or was reset
May 29 12:26:18 corey kernel: usb usb4: suspend_rh
May 29 12:26:18 corey kernel: ehci_hcd 0000:00:1d.7: PCI D0, from previous PCI D3
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 100f1, writing 1fff1)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 90, writing ef90ef90)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 228000f0)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100007, writing 100107)
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2100007, writing 2100107)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 205)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 205)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 29 12:26:18 corey kernel: PCI: Setting latency timer of device 0000:01:00.0 to 64
May 29 12:26:18 corey kernel: [fglrx] firegl_gps_setpowerup .
May 29 12:26:18 corey kernel: eth%%d: Coming out of suspend...
May 29 12:26:18 corey kernel: PCI: Enabling device 0000:0c:00.0 (0000 -> 0002)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset f (was 100, writing 105)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 4 (was 0, writing efcff000)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 3 (was 0, writing 10)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 1 (was 100002, writing 100106)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 105)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing ef9fe000)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 4020100, writing 4020103)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing ef9fd800)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 800000, writing 804000)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 1 (was 2100000, writing 2100106)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 18
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset f (was 200, writing 209)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing ef9fd400)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
May 29 12:26:18 corey kernel: ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 23
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset f (was 200, writing 209)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing ef9fd500)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset f (was 200, writing 209)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset 4 (was 0, writing ef9fd600)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset 1 (was 2100000, writing 2100102)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset f (was 200, writing 209)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset 4 (was 0, writing ef9fd700)
May 29 12:26:18 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset 1 (was 2100000, writing 2100102)
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Starting disk
May 29 12:26:18 corey kernel: ata2.00: configured for UDMA/33
May 29 12:26:18 corey kernel: ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
May 29 12:26:18 corey kernel: ata1.00: ata_hpa_resize 1: sectors = 312581808, hpa_sectors = 312581808
May 29 12:26:18 corey kernel: ata1.00: configured for UDMA/133
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 29 12:26:18 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 29 12:26:18 corey kernel: usb usb1: usb resume
May 29 12:26:18 corey kernel: usb usb1: finish resume
May 29 12:26:18 corey kernel: hub 1-0:1.0: hub_resume
May 29 12:26:18 corey kernel: usb usb1: wakeup_rh
May 29 12:26:18 corey kernel: usb usb2: usb resume
May 29 12:26:18 corey kernel: usb usb2: finish resume
May 29 12:26:18 corey kernel: hub 2-0:1.0: hub_resume
May 29 12:26:18 corey kernel: usb usb2: wakeup_rh
May 29 12:26:18 corey kernel: usb usb3: usb resume
May 29 12:26:18 corey kernel: usb usb3: finish resume
May 29 12:26:18 corey kernel: hub 3-0:1.0: hub_resume
May 29 12:26:18 corey kernel: usb usb3: wakeup_rh
May 29 12:26:18 corey kernel: usb usb4: usb resume
May 29 12:26:18 corey kernel: usb usb4: finish resume
May 29 12:26:18 corey kernel: hub 4-0:1.0: hub_resume
May 29 12:26:18 corey kernel: usb usb4: wakeup_rh
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.1_ep00: PM: resume from 0, parent usb5 still 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.1_ep81: PM: resume from 0, parent 5-0:1.0 still 2
May 29 12:26:18 corey kernel: usb_device usbdev5.1: PM: resume from 0, parent usb5 still 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.2_ep00: PM: resume from 0, parent 5-1 still 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev5.2_ep81: PM: resume from 0, parent 5-1:1.0 still 2
May 29 12:26:18 corey kernel: usb_device usbdev5.2: PM: resume from 0, parent 5-1 still 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev2.2_ep00: PM: resume from 0, parent 2-1 still 2
May 29 12:26:18 corey kernel: usbhid 2-1:1.0: PM: resume from 2, parent 2-1 still 2
May 29 12:26:18 corey kernel: usb_endpoint usbdev2.2_ep81: PM: resume from 0, parent 2-1:1.0 still 2
May 29 12:26:18 corey kernel: usb_device usbdev2.2: PM: resume from 0, parent 2-1 still 2
May 29 12:26:18 corey kernel: Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
May 29 12:26:18 corey kernel: hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0002
May 29 12:26:18 corey kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
May 29 12:26:18 corey kernel: hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
May 29 12:26:18 corey kernel: usb 2-1: USB disconnect, address 2
May 29 12:26:18 corey kernel: usb 2-1: unregistering device
May 29 12:26:18 corey kernel: usb 2-1: usb_disable_device nuking all URBs
May 29 12:26:18 corey kernel: usb 2-1: unregistering interface 2-1:1.0
May 29 12:26:18 corey kernel: usb_endpoint usbdev2.2_ep81: ep_device_release called for usbdev2.2_ep81
May 29 12:26:18 corey kernel: usb 2-1:1.0: uevent
May 29 12:26:18 corey kernel: usb 2-1:1.0: uevent
May 29 12:26:18 corey kernel: usb_endpoint usbdev2.2_ep00: ep_device_release called for usbdev2.2_ep00
May 29 12:26:18 corey kernel: usb 2-1: uevent
May 29 12:26:18 corey kernel: done.
May 29 12:26:18 corey dhclient: DHCPRELEASE on eth0 to 10.0.0.2 port 67
May 29 12:26:18 corey dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
May 29 12:26:18 corey dhcdbd: dhco_input_option: Value corey cannot be converted to type X 
May 29 12:26:18 corey dhcdbd: dhco_parse_option_settings: bad option setting: old_host_name = corey 
May 29 12:26:19 corey kernel: usb usb1: suspend_rh (auto-stop)
May 29 12:26:19 corey kernel: usb usb3: suspend_rh (auto-stop)
May 29 12:26:19 corey kernel: usb usb4: suspend_rh (auto-stop)
May 29 12:26:19 corey NetworkManager: nm_device_is_802_3_ethernet: assertion `dev != NULL' failed
May 29 12:26:19 corey NetworkManager: nm_device_is_802_11_wireless: assertion `dev != NULL' failed
May 29 12:26:19 corey NetworkManager: <information>^Imatch 
May 29 12:26:19 corey NetworkManager: <information>^Imatch 
May 29 12:26:19 corey kernel: usb usb2: suspend_rh (auto-stop)
May 29 12:26:36 corey logger: resume completed but no usb

--------------090009050709070009060102--

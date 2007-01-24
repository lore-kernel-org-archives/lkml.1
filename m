Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXAXXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXAXXIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbXAXXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:08:19 -0500
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:49517 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869AbXAXXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:08:17 -0500
Message-ID: <45B7E06C.8000901@wolfmountaingroup.com>
Date: Wed, 24 Jan 2007 15:40:44 -0700
From: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20050921 Red Hat/1.7.12-1.4.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Roger Heflin <rheflin@atipa.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
Subject: Re: Nvidia MCP55 Machine reboots on ixgb driver load
References: <45B7CA3D.9020601@atipa.com>
In-Reply-To: <45B7CA3D.9020601@atipa.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Heflin wrote:

I have seen something similiar with the ixgb.   make certain there are 
**NO** other adapters sharing the PCI bus with the
ixgb.   There are some serious hardware compatibility issues with the 
ixgb mixing it with other cards on the same PCI-X bus,
and I have seen power loading problems, performance slowdowns, reboots, 
and other issues when an ixgb is installed in a
system.

Bottom line, the ixgb adapters were not ready for prime time.  If you 
can obtain a PCI-E version of the card, I am using intel
PCI-E based cards with the MCP55 chipset and they seem to work ok, but I 
have not yet tried an ixgb with this chipset.

The ixgb does prefecthing of addresses to improve perfomance over their 
problematic ring buffer design with NCMF
performance issues, and they seem to use this prefecting architecture to 
get around these performance issues.  The net result
is the cards have problems with non-standard hardware and chipsets.

Jeff


> Hello,
>
> I have a machine (actually 2 machines) that upon loading
> the intel 10GBe driver (ixgb) the machine reboots, I am
> using a RHAS4.4 based distribution with Vanilla 2.6.19.2
> (the RHAS 4.4.03 kernel also reboots with the ixgb load),
> I don't see any messages on the machine before it reboots,
> loading the driver with debug does not appear to produce
> any extra messages.   The basic steps are the I load
> the driver, the machine locks up, and then in a second
> or 2 it starts to post.
>
> I have tried the default ixgb driver in 2.6.19.2, and I
> have tried the open source intel driver on RH4.4, both cause
> the same reboot.    I also tried the linux firmware
> development kit, and booting fc6 causes the same reboot
> upon the network driver load.
>
> I have tried pci=nomsi, noacpi, noapic, acpi=off, and a
> few others with the results staying the same.   I have also
> tried various bios settings with no changes, the bios
> in the machine is the latest, a beta bios has similar results,
> I am talking to the MB vendor about the issue.
>
> I have 2 of the intel boards and they both appear to produce
> this behavior with this type of motherboard, with a different
> motherboard (different chipset) they appear to at least
> load the driver without killing the machine work correctly.
>
> dmesg and lspci, and lspci -vv, interrupts, and iomem follow.
>
> I suspect that it is a bios issue, and that there may not
> be a way around it, except for fixing the bios.
>
> The machine is a dual-dual core opteron, with an nvidia
> MCP55 chipset.   The intel card is pci-x.   I have tried
> it with only the intel card and the lsi megaraid card required
> for it to boot and the same reboot happens.
>
> What sort of bad behavior would cause this sort of reboot?
>
> Also note that the linux.nics@intel.com address is apparently
> unused and returns an email telling you to use a web page,
> and so far after using the web page I have not got any response
> indicating that anything got to anyone.
>
>                                 Roger
>
>
> 00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a3)
> 00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a3)
> 00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a3)
> 00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
> 00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
> 00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
> 00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
> 00:0a.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Miscellaneous Control
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Address Map
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] DRAM Controller
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Miscellaneous Control
> 01:05.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
> 02:00.0 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X 
> Bridge (rev 07)
> 02:00.1 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X 
> Bridge (rev 07)
> 03:04.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID (rev 01)
> 03:06.0 Fibre Channel: LSI Logic / Symbios Logic FC949X Fibre Channel 
> Adapter (rev 01)
> 03:06.1 Fibre Channel: LSI Logic / Symbios Logic FC949X Fibre Channel 
> Adapter (rev 01)
> 04:07.0 Ethernet controller: Intel Corporation 82597EX 10GbE Ethernet 
> Controller (rev 02)
> 08:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI 
> Express-to-PCI Bridge (rev 03)
> 09:02.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b 
> Link Layer Controller (rev 01)
>
>
>
> Linux version 2.6.19.2 (root@lab116.lab.atipa.com) (gcc version 3.4.6 
> 20060404 (Red Hat 3.4.6-3)) #2 SMP Wed Jan 24 09:31:05 EST 2007
> Command line: ro root=/dev/BootDisk/root elevator=deadline pci=routeirq
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000dfff0000 (usable)
>  BIOS-e820: 00000000dfff0000 - 00000000dfffe000 (ACPI data)
>  BIOS-e820: 00000000dfffe000 - 00000000e0000000 (ACPI NVS)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
>  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> Entering add_active_range(0, 256, 917488) 1 entries of 3200 used
> Entering add_active_range(0, 1048576, 1179648) 2 entries of 3200 used
> end_pfn_map = 1179648
> DMI present.
> ACPI: RSDP (v002 ACPIAM                                ) @ 
> 0x00000000000f8540
> ACPI: XSDT (v001 A M I  OEMXSDT  0x11000628 MSFT 0x00000097) @ 
> 0x00000000dfff0100
> ACPI: FADT (v003 A M I  OEMFACP  0x11000628 MSFT 0x00000097) @ 
> 0x00000000dfff0290
> ACPI: MADT (v001 A M I  OEMAPIC  0x11000628 MSFT 0x00000097) @ 
> 0x00000000dfff0390
> ACPI: OEMB (v001 A M I  AMI_OEM  0x11000628 MSFT 0x00000097) @ 
> 0x00000000dfffe040
> ACPI: HPET (v001 A M I  OEMHPET0 0x11000628 MSFT 0x00000097) @ 
> 0x00000000dfff53d0
> ACPI: SRAT (v001 AMD    HAMMER   0x00000001 AMD  0x00000001) @ 
> 0x00000000dfff5410
> ACPI: SSDT (v001 A M I  POWERNOW 0x00000001 AMD  0x00000001) @ 
> 0x00000000dfff5520
> ACPI: DSDT (v001  H8DM8 H8DM8000 0x00000000 INTL 0x20051117) @ 
> 0x0000000000000000
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> SRAT: Node 0 PXM 0 0-a0000
> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
> SRAT: Node 0 PXM 0 0-80000000
> Entering add_active_range(0, 0, 159) 1 entries of 3200 used
> Entering add_active_range(0, 256, 524288) 1 entries of 3200 used
> SRAT: Node 1 PXM 1 80000000-e0000000
> Entering add_active_range(1, 524288, 917488) 2 entries of 3200 used
> SRAT: Node 1 PXM 1 80000000-120000000
> Entering add_active_range(1, 524288, 917488) 3 entries of 3200 used
> Entering add_active_range(1, 1048576, 1179648) 3 entries of 3200 used
> NUMA: Using 31 for the hash shift.
> Bootmem setup node 0 0000000000000000-0000000080000000
> Bootmem setup node 1 0000000080000000-0000000120000000
> Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1179648
> early_node_map[4] active PFN ranges
>     0:        0 ->      159
>     0:      256 ->   524288
>     1:   524288 ->   917488
>     1:  1048576 ->  1179648
> On node 0 totalpages: 524191
>   DMA zone: 64 pages used for memmap
>   DMA zone: 1079 pages reserved
>   DMA zone: 2856 pages, LIFO batch:0
>   DMA32 zone: 8128 pages used for memmap
>   DMA32 zone: 512064 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
> On node 1 totalpages: 524272
>   DMA zone: 0 pages used for memmap
>   DMA32 zone: 8192 pages used for memmap
>   DMA32 zone: 385008 pages, LIFO batch:31
>   Normal zone: 2048 pages used for memmap
>   Normal zone: 129024 pages, LIFO batch:31
> ACPI: PM-Timer IO Port: 0x2008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Processor #0 (Bootup-CPU)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> Processor #1
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> Processor #2
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> Processor #3
> ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> ACPI: IRQ14 used by override.
> ACPI: IRQ15 used by override.
> Setting APIC routing to flat
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> Using ACPI (MADT) for SMP configuration information
> Nosave address range: 000000000009f000 - 00000000000a0000
> Nosave address range: 00000000000a0000 - 00000000000e0000
> Nosave address range: 00000000000e0000 - 0000000000100000
> Nosave address range: 00000000dfff0000 - 00000000dfffe000
> Nosave address range: 00000000dfffe000 - 00000000e0000000
> Nosave address range: 00000000e0000000 - 00000000fec00000
> Nosave address range: 00000000fec00000 - 00000000fec01000
> Nosave address range: 00000000fec01000 - 00000000fee00000
> Nosave address range: 00000000fee00000 - 00000000fef00000
> Nosave address range: 00000000fef00000 - 00000000ff700000
> Nosave address range: 00000000ff700000 - 0000000100000000
> Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
> PERCPU: Allocating 34048 bytes of per cpu data
> Built 2 zonelists.  Total pages: 1028952
> Kernel command line: ro root=/dev/BootDisk/root elevator=deadline 
> pci=routeirq
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> CPU 0: aperture @ 4000000 size 32 MB
> Aperture too small (32 MB)
> No AGP bridge found
> Your BIOS doesn't leave a aperture memory hole
> Please enable the IOMMU option in the BIOS setup
> This costs you 64 MB of RAM
> Mapping aperture over 65536 KB of RAM @ 4000000
> Memory: 4042040k/4718592k available (2264k kernel code, 151812k 
> reserved, 989k data, 324k init)
> Calibrating delay using timer specific routine.. 4427.57 BogoMIPS 
> (lpj=8855158)
> Security Framework v1.0.0 initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> selinux_register_security:  Registering secondary module capability
> Capability LSM initialized as secondary
> Mount-cache hash table entries: 256
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 0/0 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> Freeing SMP alternatives: 24k freed
> ACPI: Core revision 20060707
> Using local APIC timer interrupts.
> result 12566127
> Detected 12.566 MHz APIC timer.
> Booting processor 1/4 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4422.74 BogoMIPS 
> (lpj=8845495)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 1/1 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 2214 stepping 02
> CPU 1: Syncing TSC to CPU 0.
> CPU 1: synchronized TSC with CPU 0 (last diff -5 cycles, maxerr 622 
> cycles)
> Booting processor 2/4 APIC 0x2
> Initializing CPU#2
> Calibrating delay using timer specific routine.. 4422.75 BogoMIPS 
> (lpj=8845518)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 2/2 -> Node 1
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 0
> Dual-Core AMD Opteron(tm) Processor 2214 stepping 02
> CPU 2: Syncing TSC to CPU 0.
> CPU 2: synchronized TSC with CPU 0 (last diff 113 cycles, maxerr 1138 
> cycles)
> Booting processor 3/4 APIC 0x3
> Initializing CPU#3
> Calibrating delay using timer specific routine.. 4422.75 BogoMIPS 
> (lpj=8845518)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 1024K (64 bytes/line)
> CPU 3/3 -> Node 1
> CPU: Physical Processor ID: 1
> CPU: Processor Core ID: 1
> Dual-Core AMD Opteron(tm) Processor 2214 stepping 02
> CPU 3: Syncing TSC to CPU 0.
> CPU 3: synchronized TSC with CPU 0 (last diff -8 cycles, maxerr 1140 
> cycles)
> Brought up 4 CPUs
> testing NMI watchdog ... OK.
> time.c: Using 25.000000 MHz WALL HPET GTOD HPET timer.
> time.c: Detected 2211.638 MHz processor.
> migration_cost=305,385
> checking if image is initramfs... it is
> Freeing initrd memory: 1702k freed
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: Using configuration type 1
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> Boot video device is 0000:01:05.0
> PCI: Transparent bridge - 0000:00:06.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15.BR30._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15.BR31._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
> ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *14
> ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
> ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *5
> ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
> ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *14
> ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
> ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
> ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
> ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
> ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [LSA2] (IRQs 20 21 22 23) *0, disabled.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: Routing PCI interrupts for all devices because "pci=routeirq" 
> specified
> ACPI: PCI Interrupt Link [LSMB] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:01.1[A] -> Link [LSMB] -> GSI 23 (level, 
> low) -> IRQ 23
> ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level, 
> low) -> IRQ 22
> ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 21
> ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 21 (level, 
> low) -> IRQ 21
> ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
> ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 20 (level, 
> low) -> IRQ 20
> ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 23 (level, 
> low) -> IRQ 23
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
> ACPI: PCI Interrupt 0000:01:05.0[A] -> Link [LNKA] -> GSI 19 (level, 
> low) -> IRQ 19
> ACPI: PCI Interrupt Link [LNEC] enabled at IRQ 18
> ACPI: PCI Interrupt 0000:03:04.0[A] -> Link [LNEC] -> GSI 18 (level, 
> low) -> IRQ 18
> ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 17
> ACPI: PCI Interrupt 0000:03:06.0[A] -> Link [LNEA] -> GSI 17 (level, 
> low) -> IRQ 17
> ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 16
> ACPI: PCI Interrupt 0000:03:06.1[B] -> Link [LNEB] -> GSI 16 (level, 
> low) -> IRQ 16
> ACPI: PCI Interrupt 0000:04:07.0[A] -> Link [LNEB] -> GSI 16 (level, 
> low) -> IRQ 16
> ACPI: PCI Interrupt 0000:09:02.0[A] -> Link [LNEA] -> GSI 17 (level, 
> low) -> IRQ 17
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ 4000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> PCI: Bridge: 0000:00:06.0
>   IO window: b000-bfff
>   MEM window: fe600000-fe6fffff
>   PREFETCH window: f0000000-f7ffffff
> PCI: Bridge: 0000:02:00.0
>   IO window: c000-dfff
>   MEM window: fe700000-fe9fffff
>   PREFETCH window: fdf00000-fdffffff
> PCI: Bridge: 0000:02:00.1
>   IO window: e000-efff
>   MEM window: fea00000-feafffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0a.0
>   IO window: c000-efff
>   MEM window: fe700000-feafffff
>   PREFETCH window: fdf00000-fdffffff
> PCI: Bridge: 0000:00:0b.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0d.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:08:00.0
>   IO window: disabled.
>   MEM window: feb00000-febfffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0e.0
>   IO window: disabled.
>   MEM window: feb00000-febfffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:0f.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> PCI: Setting latency timer of device 0000:00:0a.0 to 64
> PCI: Setting latency timer of device 0000:02:00.0 to 64
> PCI: Setting latency timer of device 0000:02:00.1 to 64
> PCI: Setting latency timer of device 0000:00:0b.0 to 64
> PCI: Setting latency timer of device 0000:00:0c.0 to 64
> PCI: Setting latency timer of device 0000:00:0d.0 to 64
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> PCI: Setting latency timer of device 0000:08:00.0 to 64
> PCI: Setting latency timer of device 0000:00:0f.0 to 64
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
> TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> audit: initializing netlink socket (disabled)
> audit(1169640729.984:1): initialized
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered (default)
> io scheduler cfq registered
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> Real Time Clock Driver v1.12ac
> Linux agpgart interface v0.101 (c) Dave Jones
> [drm] Initialized drm 1.0.1 20051102
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with 
> idebus=xx
> Probing IDE interface ide0...
> Probing IDE interface ide1...
> ide-floppy driver 0.99.newide
> usbmon: debugfs is not available
> usbcore: registered new interface driver hiddev
> usbcore: registered new interface driver usbhid
> drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> powernow-k8: Found 4 Dual-Core AMD Opteron(tm) Processor 2214 
> processors (version 2.00.00)
> powernow-k8:    0 : fid 0xe (2200 MHz), vid 0xa
> powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xc
> powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xe
> powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
> powernow-k8:    0 : fid 0xe (2200 MHz), vid 0xa
> powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xc
> powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xe
> powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
> Freeing unused kernel memory: 324k freed
> SCSI subsystem initialized
> Fusion MPT base driver 3.04.02
> Copyright (c) 1999-2005 LSI Logic Corporation
> Fusion MPT FC Host driver 3.04.02
> ACPI: PCI Interrupt 0000:03:06.0[A] -> Link [LNEA] -> GSI 17 (level, 
> low) -> IRQ 17
> mptbase: Initiating ioc0 bringup
> input: AT Translated Set 2 keyboard as /class/input/input0
> logips2pp: Detected unknown logitech mouse model 1
> ioc0: FC949X: Capabilities={Initiator,Target,LAN}
> input: PS/2 Logitech Mouse as /class/input/input1
> scsi0 : ioc0: LSIFC949X, FwRev=01030200h, Ports=1, MaxQ=1023, IRQ=17
> ACPI: PCI Interrupt 0000:03:06.1[B] -> Link [LNEB] -> GSI 16 (level, 
> low) -> IRQ 16
> mptbase: Initiating ioc1 bringup
> ioc1: FC949X: Capabilities={Initiator,Target,LAN}
> scsi 0:0:0:0: Direct-Access     RaidCtrl In Band Device   R001 PQ: 1 
> ANSI: 5
> scsi1 : ioc1: LSIFC949X, FwRev=01030200h, Ports=1, MaxQ=1023, IRQ=16
> scsi 0:0:0:11: Direct-Access     YI-16SA2 array1-top       R001 PQ: 0 
> ANSI: 5
> sda : very big device. try to use READ CAPACITY(16).
> SCSI device sda: 8789059584 512-byte hdwr sectors (4499999 MB)
> sda: Write Protect is off
> sda: Mode Sense: bf 00 00 08
> SCSI device sda: drive cache: write back
> sda : very big device. try to use READ CAPACITY(16).
> SCSI device sda: 8789059584 512-byte hdwr sectors (4499999 MB)
> sda: Write Protect is off
> sda: Mode Sense: bf 00 00 08
> scsi 1:0:0:0: Direct-Access     RaidCtrl In Band Device   R001 PQ: 1 
> ANSI: 5
> SCSI device sda: drive cache: write back
>  sda: unknown partition table
> scsi 1:0:0:11: Direct-Access     YI-16SA2 array1-top       R001 PQ: 0 
> ANSI: 5
> sdb : very big device. try to use READ CAPACITY(16).
> SCSI device sdb: 8789059584 512-byte hdwr sectors (4499999 MB)
> sd 0:0:0:11: Attached scsi disk sda
> sdb: Write Protect is off
> sdb: Mode Sense: bf 00 00 08
> SCSI device sdb: drive cache: write back
> sdb : very big device. try to use READ CAPACITY(16).
> SCSI device sdb: 8789059584 512-byte hdwr sectors (4499999 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: bf 00 00 08
> SCSI device sdb: drive cache: write back
>  sdb:<5>scsi 0:0:1:0: Direct-Access     RaidCtrl In Band Device   R001 
> PQ: 1 ANSI: 5
>  unknown partition table
> sd 1:0:0:11: Attached scsi disk sdb
> scsi 0:0:1:12: Direct-Access     YI-16SA2 array1-bottom    R001 PQ: 0 
> ANSI: 5
> scsi 1:0:1:0: Direct-Access     RaidCtrl In Band Device   R001 PQ: 1 
> ANSI: 5
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 8789059584 512-byte hdwr sectors (4499999 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: bf 00 00 08
> SCSI device sdc: drive cache: write back
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 8789059584 512-byte hdwr sectors (4499999 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: bf 00 00 08
> SCSI device sdc: drive cache: write back
>  sdc: unknown partition table
> sd 0:0:1:12: Attached scsi disk sdc
> scsi 1:0:1:12: Direct-Access     YI-16SA2 array1-bottom    R001 PQ: 0 
> ANSI: 5
> Fusion MPT SPI Host driver 3.04.02
> sdd : very big device. try to use READ CAPACITY(16).
> SCSI device sdd: 8789059584 512-byte hdwr sectors (4499999 MB)
> sdd: Write Protect is off
> sdd: Mode Sense: bf 00 00 08
> SCSI device sdd: drive cache: write back
> sdd : very big device. try to use READ CAPACITY(16).
> SCSI device sdd: 8789059584 512-byte hdwr sectors (4499999 MB)
> sdd: Write Protect is off
> sdd: Mode Sense: bf 00 00 08
> SCSI device sdd: drive cache: write back
>  sdd: unknown partition table
> sd 1:0:1:12: Attached scsi disk sdd
> Fusion MPT SAS Host driver 3.04.02
> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
> megaraid: probe new device 0x1000:0x1960:0x1000:0x0520: bus 3:slot 
> 4:func 0
> ACPI: PCI Interrupt 0000:03:04.0[A] -> Link [LNEC] -> GSI 18 (level, 
> low) -> IRQ 18
> megaraid: fw version:[1L45] bios version:[G121]
> scsi2 : LSI Logic MegaRAID driver
> scsi[2]: scanning scsi channel 0 [Phy 0] for non-raid devices
> scsi 2:0:8:0: Processor         SUPER    GEM359 REV001    1.09 PQ: 0 
> ANSI: 2
> scsi[2]: scanning scsi channel 1 [virtual] for logical drives
> scsi 2:1:0:0: Direct-Access     MegaRAID LD 0 RAID1   69G 1L45 PQ: 0 
> ANSI: 2
> SCSI device sde: 142577664 512-byte hdwr sectors (73000 MB)
> sde: Write Protect is off
> sde: Mode Sense: 00 00 00 00
> sde: asking for cache data failed
> sde: assuming drive cache: write through
> SCSI device sde: 142577664 512-byte hdwr sectors (73000 MB)
> sde: Write Protect is off
> sde: Mode Sense: 00 00 00 00
> sde: asking for cache data failed
> sde: assuming drive cache: write through
>  sde: sde1 sde2
> sd 2:1:0:0: Attached scsi disk sde
> device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised: 
> dm-devel@redhat.com
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux:  Disabled at runtime.
> SELinux:  Unregistering netfilter hooks
> audit(1169640738.476:2): selinux=0 auid=4294967295
> scsi 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 1:0:0:0: Attached scsi generic sg1 type 0
> sd 0:0:0:11: Attached scsi generic sg2 type 0
> scsi 0:0:1:0: Attached scsi generic sg3 type 0
> sd 1:0:0:11: Attached scsi generic sg4 type 0
> scsi 1:0:1:0: Attached scsi generic sg5 type 0
> sd 0:0:1:12: Attached scsi generic sg6 type 0
> sd 1:0:1:12: Attached scsi generic sg7 type 0
> scsi 2:0:8:0: Attached scsi generic sg8 type 3
> sd 2:1:0:0: Attached scsi generic sg9 type 0
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.57.
> ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 20 (level, 
> low) -> IRQ 20
> PCI: Setting latency timer of device 0000:00:08.0 to 64
> forcedeth: using HIGHDMA
> eth0: forcedeth.c: subsystem: 015d9:1611 bound to 0000:00:08.0
> ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 23 (level, 
> low) -> IRQ 23
> PCI: Setting latency timer of device 0000:00:09.0 to 64
> forcedeth: using HIGHDMA
> eth1: forcedeth.c: subsystem: 015d9:1611 bound to 0000:00:09.0
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> i2c_adapter i2c-0: nForce2 SMBus adapter at 0x2d00
> i2c_adapter i2c-1: nForce2 SMBus adapter at 0x2e00
> ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 21 (level, 
> low) -> IRQ 21
> PCI: Setting latency timer of device 0000:00:02.1 to 64
> ehci_hcd 0000:00:02.1: EHCI Host Controller
> ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.1: debug port 1
> PCI: cache line size of 64 is not supported by device 0000:00:02.1
> ehci_hcd 0000:00:02.1: irq 21, io mem 0xfe5fac00
> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 10 ports detected
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver 
> (PCI)
> ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level, 
> low) -> IRQ 22
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe5fb000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 10 ports detected
> usb 1-10: new high speed USB device using ehci_hcd and address 2
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> usb 1-10: configuration #1 chosen from 1 choice
> input: Peppercon AG Multidevice as /class/input/input2
> input: USB HID v1.01 Mouse [Peppercon AG Multidevice] on 
> usb-0000:00:02.1-10
> input: Peppercon AG Multidevice as /class/input/input3
> input: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on 
> usb-0000:00:02.1-10
> Initializing USB Mass Storage driver...
> scsi3 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> ACPI: Power Button (FF) [PWRF]
> ACPI: Power Button (CM) [PWRB]
> scsi 3:0:0:0: Direct-Access     PepperC  Virtual Disc 1   0.01 PQ: 0 
> ANSI: 3
> sd 3:0:0:0: Attached scsi removable disk sdf
> sd 3:0:0:0: Attached scsi generic sg10 type 0
> usb-storage: device scan complete
> EXT3 FS on dm-0, internal journal
> device-mapper: multipath: version 1.0.5 loaded
> device-mapper: multipath round-robin: version 1.0.0 loaded
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sde1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-1, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-3, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on dm-4, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> SGI XFS with ACLs, security attributes, large block/inode numbers, no 
> debug enabled
> SGI XFS Quota Management subsystem
> Filesystem "dm-8": Disabling barriers, not supported by the underlying 
> device
> XFS mounting filesystem dm-8
> Ending clean XFS mount for filesystem: dm-8
> Adding 8388600k swap on /dev/BootDisk/swap.  Priority:-1 extents:1 
> across:8388600k
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> hald[4193]: segfault at 00007fffcec0b000 rip 00000038d34708fa rsp 
> 00007fffcec096f8 error 6
> eth0: no IPv6 routers present
> mtrr: type mismatch for f0000000,1000000 old: write-back new: 
> write-combining
>
>
>
> 00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Capabilities: [44] HyperTransport: Slave or Primary Interface
>         Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
>         Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- 
> <CRCErr=3 IsocEn- LSEn+ ExtCTL- 64b-
>         Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- 
> LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
>         Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ 
> <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>         Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit 
> DwFcInEn- LWO=8bit DwFcOutEn-
>         Revision ID: 1.03
>         Link Frequency 0: 1.0GHz
>         Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
>         Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 
> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>         Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
>         Link Frequency 1: 200MHz
>         Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
>         Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 
> 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>         Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- 
> SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>         Prefetchable memory behind bridge Upper: 00-00
>         Bus Number: 00
>     Capabilities: [dc] HyperTransport: MSI Mapping
>
> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a3)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>
> 00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a3)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Interrupt: pin A routed to IRQ 23
>     Region 0: I/O ports at ac00 [size=64]
>     Region 4: I/O ports at 2d00 [size=64]
>     Region 5: I/O ports at 2e00 [size=64]
>     Capabilities: [44] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a3)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>
> 00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev 
> a1) (prog-if 10 [OHCI])
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0 (750ns min, 250ns max)
>     Interrupt: pin A routed to IRQ 22
>     Region 0: Memory at fe5fb000 (32-bit, non-prefetchable) [size=4K]
>     Capabilities: [44] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev 
> a2) (prog-if 20 [EHCI])
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0 (750ns min, 250ns max)
>     Interrupt: pin B routed to IRQ 21
>     Region 0: Memory at fe5fac00 (32-bit, non-prefetchable) [size=256]
>     Capabilities: [44] Debug port
>     Capabilities: [80] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2) 
> (prog-if 01 [Subtractive decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0
>     Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>     I/O behind bridge: 0000b000-0000bfff
>     Memory behind bridge: fe600000-fe6fffff
>     Prefetchable memory behind bridge: f0000000-f7ffffff
>     Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>     Capabilities: [b8] #0d [0000]
>     Capabilities: [8c] HyperTransport: MSI Mapping
>
> 00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0 (250ns min, 5000ns max)
>     Interrupt: pin A routed to IRQ 20
>     Region 0: Memory at fe5f9000 (32-bit, non-prefetchable) [size=4K]
>     Region 1: I/O ports at a480 [size=8]
>     Region 2: Memory at fe5fa800 (32-bit, non-prefetchable) [size=256]
>     Region 3: Memory at fe5fa400 (32-bit, non-prefetchable) [size=16]
>     Capabilities: [44] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
>     Capabilities: [70] MSI-X: Enable+ Mask- TabSize=8
>         Vector table: BAR=2 offset=00000000
>         PBA: BAR=3 offset=00000000
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/3 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [6c] HyperTransport: MSI Mapping
>
> 00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0 (250ns min, 5000ns max)
>     Interrupt: pin A routed to IRQ 23
>     Region 0: Memory at fe5f8000 (32-bit, non-prefetchable) [size=4K]
>     Region 1: I/O ports at a400 [size=8]
>     Region 2: Memory at fe5fa000 (32-bit, non-prefetchable) [size=256]
>     Region 3: Memory at fe5f7c00 (32-bit, non-prefetchable) [size=16]
>     Capabilities: [44] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
>         Vector table: BAR=2 offset=00000000
>         PBA: BAR=3 offset=00000000
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/3 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [6c] HyperTransport: MSI Mapping
>
> 00:0a.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
>     I/O behind bridge: 0000c000-0000efff
>     Memory behind bridge: fe700000-feafffff
>     Prefetchable memory behind bridge: 00000000fdf00000-00000000fdf00000
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 5
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x8
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x0, ASPM L0s L1, Port 4
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x0
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x0, ASPM L0s L1, Port 3
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x0
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 2
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x4
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=08, subordinate=09, sec-latency=0
>     Memory behind bridge: feb00000-febfffff
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 1
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x8
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev 
> a3) (prog-if 00 [Normal decode])
>     Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
>     Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] #0d [0000]
>     Capabilities: [48] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/1 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [60] HyperTransport: MSI Mapping
>     Capabilities: [80] Express Root Port (Slot+) IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
>         Link: Latency L0s <512ns, L1 <4us
>         Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x8
>         Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
>         Slot: Number 0, PowerLimit 0.000000
>         Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>         Slot: AttnInd Off, PwrInd On, Power-
>         Root: Correctable- Non-Fatal- Fatal- PME-
>
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] HyperTransport Technology Configuration
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Capabilities: [80] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>         Revision ID: 1.02
>     Capabilities: [a0] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>         Revision ID: 1.02
>     Capabilities: [c0] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>         Revision ID: 1.02
>
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Address Map
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] DRAM Controller
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Miscellaneous Control
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Capabilities: [f0] #0f [0010]
>
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] HyperTransport Technology Configuration
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Capabilities: [80] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>         Revision ID: 1.02
>     Capabilities: [a0] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
>         Revision ID: 1.02
>     Capabilities: [c0] HyperTransport: Host or Secondary Interface
>     !!! Possibly incomplete decoding
>         Command: WarmRst+ DblEnd-
>         Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
>         Link Config: MLWI=16bit MLWO=16bit LWI=N/C LWO=N/C
>         Revision ID: 1.02
>
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Address Map
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] DRAM Controller
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 
> [Athlon64/Opteron] Miscellaneous Control
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Capabilities: [f0] #0f [0010]
>
> 01:05.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 
> 02) (prog-if 00 [VGA])
>     Subsystem: Super Micro Computer Inc: Unknown device 1611
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping+ SERR- FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 64 (2000ns min), Cache Line Size 10
>     Interrupt: pin A routed to IRQ 19
>     Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
>     Region 1: I/O ports at b000 [size=256]
>     Region 2: Memory at fe6f0000 (32-bit, non-prefetchable) [size=64K]
>     Expansion ROM at fe600000 [disabled] [size=128K]
>     Capabilities: [50] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 02:00.0 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X 
> Bridge (rev 07) (prog-if 00 [Normal decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
>     I/O behind bridge: 0000c000-0000dfff
>     Memory behind bridge: fe700000-fe9fffff
>     Prefetchable memory behind bridge: 00000000fdf00000-00000000fdf00000
>     Secondary status: 66Mhz+ FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] Express PCI/PCI-X Bridge IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: AtnBtn- AtnInd- PwrInd-
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
>         Link: Latency L0s <4us, L1 <16us
>         Link: ASPM Disabled CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x8
>     Capabilities: [54] PCI-X bridge device.
>         Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=0
>         Status: Bus=2 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, SCO-, SRD-
>         : Upstream: Capacity=32, Commitment Limit=32
>         : Downstream: Capacity=16, Commitment Limit=16
>     Capabilities: [64] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2- AuxCurrent=55mA 
> PME(D0+,D1+,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Bridge: PM- B3+
>
> 02:00.1 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X 
> Bridge (rev 07) (prog-if 00 [Normal decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=02, secondary=04, subordinate=04, sec-latency=64
>     I/O behind bridge: 0000e000-0000efff
>     Memory behind bridge: fea00000-feafffff
>     Secondary status: 66Mhz+ FastB2B- ParErr- DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>     BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [40] Express PCI/PCI-X Bridge IRQ 0
>         Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: AtnBtn- AtnInd- PwrInd-
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s L1, Port 0
>         Link: Latency L0s <4us, L1 <16us
>         Link: ASPM Disabled CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x8
>     Capabilities: [54] PCI-X bridge device.
>         Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=3
>         Status: Bus=2 Dev=0 Func=1 64bit- 133MHz- SCD- USC-, SCO-, SRD-
>         : Upstream: Capacity=32, Commitment Limit=32
>         : Downstream: Capacity=16, Commitment Limit=16
>     Capabilities: [64] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2- AuxCurrent=55mA 
> PME(D0+,D1+,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Bridge: PM- B3+
>
> 03:04.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID (rev 01)
>     Subsystem: LSI Logic / Symbios Logic MegaRAID 520 SCSI 320-1 
> Controller
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 64, Cache Line Size 10
>     Interrupt: pin A routed to IRQ 18
>     Region 0: Memory at fdff0000 (32-bit, prefetchable) [size=64K]
>     Expansion ROM at fe9f0000 [disabled] [size=64K]
>     Capabilities: [80] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 03:06.0 Fibre Channel: LSI Logic / Symbios Logic FC949X Fibre Channel 
> Adapter (rev 01)
>     Subsystem: LSI Logic / Symbios Logic: Unknown device 1100
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 72 (16000ns min, 2500ns max), Cache Line Size 10
>     Interrupt: pin A routed to IRQ 17
>     Region 0: I/O ports at d000 [disabled] [size=256]
>     Region 1: Memory at fe9ec000 (64-bit, non-prefetchable) [size=16K]
>     Region 3: Memory at fe9d0000 (64-bit, non-prefetchable) [size=64K]
>     Expansion ROM at fe800000 [disabled] [size=1M]
>     Capabilities: [50] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [98] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [68] PCI-X non-bridge device.
>         Command: DPERE- ERO- RBC=0 OST=6
>         Status: Bus=255 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, 
> DC=simple, DMMRBC=2, DMOST=6, DMCRS=3, RSCEM-
>     Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
>         Vector table: BAR=1 offset=00002000
>         PBA: BAR=1 offset=00003000
>
> 03:06.1 Fibre Channel: LSI Logic / Symbios Logic FC949X Fibre Channel 
> Adapter (rev 01)
>     Subsystem: LSI Logic / Symbios Logic: Unknown device 1100
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 72 (16000ns min, 2500ns max), Cache Line Size 10
>     Interrupt: pin B routed to IRQ 16
>     Region 0: I/O ports at c000 [disabled] [size=256]
>     Region 1: Memory at fe9e8000 (64-bit, non-prefetchable) [size=16K]
>     Region 3: Memory at fe9c0000 (64-bit, non-prefetchable) [size=64K]
>     Expansion ROM at fe700000 [disabled] [size=1M]
>     Capabilities: [50] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [98] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [68] PCI-X non-bridge device.
>         Command: DPERE- ERO- RBC=0 OST=6
>         Status: Bus=255 Dev=31 Func=1 64bit+ 133MHz+ SCD- USC-, 
> DC=simple, DMMRBC=2, DMOST=6, DMCRS=3, RSCEM-
>     Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
>         Vector table: BAR=1 offset=00002000
>         PBA: BAR=1 offset=00003000
>
> 04:07.0 Ethernet controller: Intel Corporation 82597EX 10GbE Ethernet 
> Controller (rev 02)
>     Subsystem: Intel Corporation: Unknown device a00c
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 64 (63750ns min), Cache Line Size 10
>     Interrupt: pin A routed to IRQ 16
>     Region 0: Memory at feaf8000 (64-bit, non-prefetchable) [size=32K]
>     Region 2: Memory at fea80000 (64-bit, non-prefetchable) [size=256K]
>     Region 4: I/O ports at ec00 [size=32]
>     Expansion ROM at fea40000 [disabled] [size=256K]
>     Capabilities: [dc] Power Management version 2
>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>     Capabilities: [e4] PCI-X non-bridge device.
>         Command: DPERE- ERO+ RBC=0 OST=2
>         Status: Bus=4 Dev=7 Func=0 64bit+ 133MHz+ SCD- USC-, 
> DC=simple, DMMRBC=3, DMOST=2, DMCRS=4, RSCEM-
>     Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0 
> Enable-
>         Address: 0000000000000000  Data: 0000
>
> 08:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI 
> Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 0, Cache Line Size 10
>     Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
>     Memory behind bridge: feb00000-febfffff
>     Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>     BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>     Capabilities: [50] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Bridge: PM- B3+
>     Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/4 
> Enable-
>         Address: 0000000000000000  Data: 0000
>     Capabilities: [80] #0d [0000]
>     Capabilities: [90] Express PCI/PCI-X Bridge IRQ 0
>         Device: Supported: MaxPayload 512 bytes, PhantFunc 0, ExtTag-
>         Device: Latency L0s <64ns, L1 <1us
>         Device: AtnBtn- AtnInd- PwrInd-
>         Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>         Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>         Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>         Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>         Link: Latency L0s <64ns, L1 <1us
>         Link: ASPM Disabled CommClk- ExtSynch-
>         Link: Speed 2.5Gb/s, Width x1
>
> 09:02.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b 
> Link Layer Controller (rev 01) (prog-if 10 [OHCI])
>     Subsystem: Timedia Technology Co Ltd: Unknown device 3110
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> ParErr- Stepping- SERR+ FastB2B-
>     Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>     Latency: 64 (750ns min, 1000ns max), Cache Line Size 10
>     Interrupt: pin A routed to IRQ 17
>     Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
>     Region 1: Memory at febf8000 (32-bit, non-prefetchable) [size=16K]
>     Capabilities: [44] Power Management version 2
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
>            CPU0       CPU1       CPU2       CPU3
>   0:        128          4        137     687908   IO-APIC-edge      
> timer
>   1:          0          0          0         10   IO-APIC-edge      
> i8042
>   6:          0          0          0          3   IO-APIC-edge      
> floppy
>   8:          0          0          0          1   IO-APIC-edge      rtc
>   9:          0          0          0          0   IO-APIC-fasteoi   acpi
>  12:          0          0          0        105   IO-APIC-edge      
> i8042
>  16:          0          0          0        460   IO-APIC-fasteoi   ioc1
>  17:          0          0          3        645   IO-APIC-fasteoi   ioc0
>  18:          0          3          5      10079   IO-APIC-fasteoi 
> megaraid
>  21:          0          0          0        106   IO-APIC-fasteoi 
> ehci_hcd:usb1
>  22:          0          0          0          0   IO-APIC-fasteoi 
> ohci_hcd:usb2
> 509:          0          0        111     274008   PCI-MSI-edge      eth0
> 510:          0          0          3        478   PCI-MSI-edge      eth0
> 511:          0          0          5       6223   PCI-MSI-edge      eth0
> NMI:        109         37         38         49
> LOC:     688031     688008     687984     687960
> ERR:          0
>
> 00000000-0009f7ff : System RAM
> 0009f800-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000cafff : Video ROM
> 000cb000-000cc7ff : Adapter ROM
> 000cc800-000ccfff : Adapter ROM
> 000cd000-000cf5ff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-dffeffff : System RAM
>   00200000-00436078 : Kernel code
>   00436079-0052d76f : Kernel data
>   04000000-07ffffff : GART
> dfff0000-dfffdfff : ACPI Tables
> dfffe000-dfffffff : ACPI Non-volatile Storage
> f0000000-f7ffffff : PCI Bus #01
>   f0000000-f7ffffff : 0000:01:05.0
> fdf00000-fdffffff : PCI Bus #02
>   fdf00000-fdffffff : PCI Bus #03
>     fdff0000-fdffffff : 0000:03:04.0
>       fdff0000-fdffffff : MegaRAID: LSI Logic Corporation
> fe5f7c00-fe5f7c0f : 0000:00:09.0
>   fe5f7c00-fe5f7c0f : forcedeth
> fe5f8000-fe5f8fff : 0000:00:09.0
>   fe5f8000-fe5f8fff : forcedeth
> fe5f9000-fe5f9fff : 0000:00:08.0
>   fe5f9000-fe5f9fff : forcedeth
> fe5fa000-fe5fa0ff : 0000:00:09.0
>   fe5fa000-fe5fa0ff : forcedeth
> fe5fa400-fe5fa40f : 0000:00:08.0
>   fe5fa400-fe5fa40f : forcedeth
> fe5fa800-fe5fa8ff : 0000:00:08.0
>   fe5fa800-fe5fa8ff : forcedeth
> fe5fac00-fe5facff : 0000:00:02.1
>   fe5fac00-fe5facff : ehci_hcd
> fe5fb000-fe5fbfff : 0000:00:02.0
>   fe5fb000-fe5fbfff : ohci_hcd
> fe600000-fe6fffff : PCI Bus #01
>   fe600000-fe61ffff : 0000:01:05.0
>   fe6f0000-fe6fffff : 0000:01:05.0
> fe700000-feafffff : PCI Bus #02
>   fe700000-fe9fffff : PCI Bus #03
>     fe700000-fe7fffff : 0000:03:06.1
>     fe800000-fe8fffff : 0000:03:06.0
>     fe9c0000-fe9cffff : 0000:03:06.1
>     fe9d0000-fe9dffff : 0000:03:06.0
>     fe9e8000-fe9ebfff : 0000:03:06.1
>     fe9ec000-fe9effff : 0000:03:06.0
>     fe9f0000-fe9fffff : 0000:03:04.0
>   fea00000-feafffff : PCI Bus #04
>     fea40000-fea7ffff : 0000:04:07.0
>     fea80000-feabffff : 0000:04:07.0
>     feaf8000-feafffff : 0000:04:07.0
> feb00000-febfffff : PCI Bus #08
>   feb00000-febfffff : PCI Bus #09
>     febf8000-febfbfff : 0000:09:02.0
>     febff800-febfffff : 0000:09:02.0
> fec00000-fec00fff : reserved
> fed00000-fed003ff : HPET 0
> fee00000-feefffff : reserved
> ff700000-ffffffff : reserved
> 100000000-11fffffff : System RAM
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


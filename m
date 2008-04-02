Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYDBRKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYDBRKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbYDBRJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:09:53 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:51979 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbYDBRJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:09:46 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Wed, 2 Apr 2008 19:09:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191455.14380.volker.armin.hemmann@tu-clausthal.de> <47F30438.40506@gmail.com>
In-Reply-To: <47F30438.40506@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200804021909.41609.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 2. April 2008, Tejun Heo wrote:
> Volker Armin Hemmann wrote:
> >On Mittwoch, 19. März 2008, Tejun Heo wrote:
> >> Volker Armin Hemmann wrote:
> >>> On Mittwoch, 19. März 2008, Tejun Heo wrote:
> >>>> x UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200
> >>>>
> >>>>> irq 315
> >>>>> [   38.125479] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port
> >>>>> 0xf9dfc280 irq 315
> >>>>> [   38.597035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >>>>> [   38.597732] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max
> >>>>> UDMA/133 [   38.597775] ata1.00: 312581808 sectors, multi 16: LBA48
> >>>>> [   38.598405] ata1.00: configured for UDMA/133
> >>>>> [   39.069342] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >>>>> [   39.084225] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
> >>>>> [   39.084264] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth
> >>>>> 0/32) [   39.086268] ata2.00: configured for UDMA/133
> >>>>
> >>>> So, just to confirm.  With the updated patch, you don't see any
> >>>> problem, right?
> >>>
> >>> Correct. With the updated patch I don't see problems in 'non-raid'
> >>> mode. AHCI mode still has problems without nosmi. But that is an
> >>> entirely different problem, right?
> >>
> >> Yeap, can you please post the result of "lspci -nn"?
> >
> > with AHCI+nosmi, 2.6.24.3:
> > 00:0a.0 SATA controller [0106]: nVidia Corporation MCP65 AHCI Controller
> > [10de:044d] (rev a1)
>
> Sorry about the long delay.  Can you please test the attached patch in
> both ahci and non-ahci modes w/o pci=nomsi and post resulting boot logs?

patch -p1 < /home/energyman/mcp65-ahci-debug.patch
patching file drivers/ata/libata-core.c
Hunk #1 succeeded at 7136 (offset 2 lines).
patching file drivers/ata/libata-eh.c
Hunk #1 succeeded at 2083 (offset -107 lines).
patching file drivers/pci/quirks.c
Hunk #1 succeeded at 1733 with fuzz 1 (offset -122 lines).

saved config, removed linux-2.6.24.3, unpacked 2.6.24.3 from tarball, reiser4 
and your patch, make oldconfig, make menuconfig, make all modules_install 
install.

dmesgs are below. 

>
> > I booted into systemrescuecd (which is the easiest way to get the error
> > and be able to safe the stuff) - lspci is of course identical, but
> > /proc/interrupts is not.
> >
> > 2.6.24.3:
> > cat /proc/interrupts
> >            CPU0       CPU1
> >   0:         57          1   IO-APIC-edge      timer
> >   1:          1        544   IO-APIC-edge      i8042
> >   8:          0          1   IO-APIC-edge      rtc
> >   9:          0          1   IO-APIC-fasteoi   acpi
> >  12:          0          3   IO-APIC-edge      i8042
> >  17:         22      21598   IO-APIC-fasteoi   nvidia
> >  18:          0          0   IO-APIC-fasteoi   EMU10K1
> >  19:          5       1132   IO-APIC-fasteoi   eth0
> >  22:         30      21627   IO-APIC-fasteoi   ehci_hcd:usb1
> >  23:         29      23078   IO-APIC-fasteoi   ahci
> > NMI:          0          0   Non-maskable interrupts
> > LOC:      41299      60204   Local timer interrupts
> > RES:      14872      22506   Rescheduling interrupts
> > CAL:       1783        173   function call interrupts
> > TLB:       2668       2406   TLB shootdowns
> > TRM:          0          0   Thermal event interrupts
> > THR:          0          0   Threshold APIC interrupts
> > SPU:          0          0   Spurious interrupts
> > ERR:          0
>
> Does the 2.6.24.3 kernel have MSI turned on?

I think so:

[*] PCI support                                                                                    
[*]   Support mmconfig PCI config space access                                                     
[ ] Support for DMA Remapping Devices (EXPERIMENTAL)                                               
[*] PCI Express support                                                                            
[*]   Root Port Advanced Error Reporting support                                                   
[*] Message Signaled Interrupts (MSI and MSI-X)                                                    
[*] Enable deprecated pci_find_* API                                                               
[*] Interrupts on hypertransport devices    

but to make sure,


non-raid, coldboot, pci=nomsi:
cat /proc/interrupts
           CPU0       CPU1
  0:         57          1   IO-APIC-edge      timer
  1:          2       3300   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:         17      43662   IO-APIC-fasteoi   nvidia
 18:          0          0   IO-APIC-fasteoi   EMU10K1
 19:         12       4188   IO-APIC-fasteoi   eth0
 22:         26      13832   IO-APIC-fasteoi   ehci_hcd:usb1
 23:         24      30517   IO-APIC-fasteoi   ahci
NMI:          0          0   Non-maskable interrupts
LOC:      86361     120679   Local timer interrupts
RES:      25603      12907   Rescheduling interrupts
CAL:       7294        260   function call interrupts
TLB:       4641       4579   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

non-raid, coldboot without pci=nomsi:
cat /proc/interrupts
           CPU0       CPU1
  0:         57          1   IO-APIC-edge      timer
  1:          0        208   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:          2       5029   IO-APIC-fasteoi   nvidia
 18:          0          0   IO-APIC-fasteoi   EMU10K1
 22:          2       1439   IO-APIC-fasteoi   ehci_hcd:usb1
314:          4        594   PCI-MSI-edge      eth0
315:         15      15953   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:      16704      18679   Local timer interrupts
RES:       5158       3043   Rescheduling interrupts
CAL:        672         86   function call interrupts
TLB:        508        572   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0


about the boots with your patch:

AHCI + nomsi:

[    0.000000] Linux version 2.6.24.3reiser4mcp65patch (root@energy) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Apr 2 07:31:52 CEST 2008
[    0.000000] Command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030522
[    0.000000] Kernel command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   32.744190] Marking TSC unstable due to TSCs unsynchronized
[   32.744192] time.c: Detected 3013.888 MHz processor.
[   32.748009] Console: colour VGA+ 80x25
[   32.748011] console [tty6] enabled
[   32.752634] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   32.754864] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   32.755634] Checking aperture...
[   32.755672] CPU 0: aperture @ 8000000 size 32 MB
[   32.755709] Aperture too small (32 MB)
[   32.761552] No AGP bridge found
[   32.761588] Your BIOS doesn't leave a aperture memory hole
[   32.761625] Please enable the IOMMU option in the BIOS setup
[   32.761663] This costs you 64 MB of RAM
[   32.786893] Mapping aperture over 65536 KB of RAM @ 8000000
[   32.811013] Memory: 4049948k/4980736k available (2192k kernel code, 143428k 
reserved, 681k data, 176k init)
[   32.811081] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[   32.893841] Calibrating delay using timer specific routine.. 6034.68 
BogoMIPS (lpj=10053897)
[   32.893933] Mount-cache hash table entries: 256
[   32.894040] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   32.894080] CPU: L2 Cache: 1024K (64 bytes/line)
[   32.894118] CPU: Physical Processor ID: 0
[   32.894154] CPU: Processor Core ID: 0
[   32.894207] SMP alternatives: switching to UP code
[   32.894570] ACPI: Core revision 20070126
[   32.929746] Using local APIC timer interrupts.
[   32.962890] APIC timer calibration result 12557872
[   32.962891] Detected 12.557 MHz APIC timer.
[   32.962975] SMP alternatives: switching to SMP code
[   32.963204] Booting processor 1/2 APIC 0x1
[   32.973324] Initializing CPU#1
[   33.056090] Calibrating delay using timer specific routine.. 6030.92 
BogoMIPS (lpj=10046278)
[   33.056094] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   33.056096] CPU: L2 Cache: 1024K (64 bytes/line)
[   33.056097] CPU: Physical Processor ID: 0
[   33.056098] CPU: Processor Core ID: 1
[   33.056178] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   33.056232] Brought up 2 CPUs
[   33.056689] net_namespace: 120 bytes
[   33.056921] NET: Registered protocol family 16
[   33.057033] ACPI: bus type pci registered
[   33.057114] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   33.057153] PCI: Not using MMCONFIG.
[   33.057189] PCI: Using configuration type 1
[   33.059432] ACPI: EC: Look up EC in DSDT
[   33.062880] ACPI: Interpreter enabled
[   33.062917] ACPI: (supports S0 S1 S3 S4 S5)
[   33.063087] ACPI: Using IOAPIC for interrupt routing
[   33.063295] Error attaching device data
[   33.063334] Error attaching device data
[   33.063372] Error attaching device data
[   33.063411] Error attaching device data
[   33.068322] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   33.068857] PCI: Transparent bridge - 0000:00:08.0
[   33.069157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   33.069289] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   33.069386] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   33.069441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   33.069496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   33.069551] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   33.073491] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   33.073826] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   33.074160] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   33.074520] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[   33.074880] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   33.075238] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   33.075571] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   33.075931] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   33.076267] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   33.076601] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   33.076961] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   33.077294] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   33.077654] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   33.078014] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   33.078348] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   33.078708] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   33.079041] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   33.079439] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   33.079799] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   33.080159] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   33.080477] Linux Plug and Play Support v0.97 (c) Adam Belay
[   33.080530] pnp: PnP ACPI init
[   33.080569] ACPI: bus type pnp registered
[   33.083109] pnp: PnP ACPI: found 13 devices
[   33.083146] ACPI: ACPI bus type pnp unregistered
[   33.083268] SCSI subsystem initialized
[   33.083325] libata version 3.00 loaded.
[   33.083375] usbcore: registered new interface driver usbfs
[   33.083431] usbcore: registered new interface driver hub
[   33.083488] usbcore: registered new device driver usb
[   33.083572] PCI: Using ACPI for IRQ routing
[   33.083609] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   33.092684] PCI-DMA: Disabling AGP.
[   33.093419] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   33.093460] PCI-DMA: using GART IOMMU.
[   33.093500] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   33.093658] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   33.093797] hpet0: 3 32-bit timers, 25000000 Hz
[   33.095969] Time: hpet clocksource has been installed.
[   33.096017] Switched to high resolution mode on CPU 0
[   33.096108] Switched to high resolution mode on CPU 1
[   33.102701] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   33.106092] system 00:05: ioport range 0x800-0x80f has been reserved
[   33.106132] system 00:05: ioport range 0x2000-0x207f has been reserved
[   33.106171] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   33.106210] system 00:05: ioport range 0x2400-0x247f has been reserved
[   33.106250] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   33.106289] system 00:05: ioport range 0x2800-0x287f has been reserved
[   33.106328] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   33.106367] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   33.106407] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   33.106446] system 00:05: iomem range 0x0-0x0 could not be reserved
[   33.106486] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[   33.106529] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   33.106577] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   33.106627] system 00:0a: ioport range 0x290-0x29f has been reserved
[   33.106670] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[   33.106715] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   33.106754] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   33.106794] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   33.106837] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   33.106884] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   33.107166] PCI: Bridge: 0000:00:08.0
[   33.107203]   IO window: d000-dfff
[   33.107240]   MEM window: f9f00000-f9ffffff
[   33.107278]   PREFETCH window: disabled.
[   33.107315] PCI: Bridge: 0000:00:0b.0
[   33.107352]   IO window: c000-cfff
[   33.107388]   MEM window: f9e00000-f9efffff
[   33.107425]   PREFETCH window: disabled.
[   33.107462] PCI: Bridge: 0000:00:0c.0
[   33.107498]   IO window: disabled.
[   33.107534]   MEM window: disabled.
[   33.107570]   PREFETCH window: disabled.
[   33.107608] PCI: Bridge: 0000:00:0d.0
[   33.107644]   IO window: e000-efff
[   33.107681]   MEM window: fa000000-febfffff
[   33.107717]   PREFETCH window: d0000000-dfffffff
[   33.107755] PCI: Bridge: 0000:00:0e.0
[   33.107791]   IO window: disabled.
[   33.107827]   MEM window: disabled.
[   33.107863]   PREFETCH window: disabled.
[   33.107906] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   33.107915] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   33.107920] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   33.107925] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   33.107930] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   33.107936] NET: Registered protocol family 2
[   33.139267] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   33.139864] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[   33.141290] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   33.141777] TCP: Hash tables configured (established 262144 bind 65536)
[   33.141816] TCP reno registered
[   33.150050] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   33.150154] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[   33.150202] io scheduler noop registered
[   33.150240] io scheduler cfq registered (default)
[   33.150934] Boot video device is 0000:04:00.0
[   33.151038] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   33.151056] assign_interrupt_mode Found MSI capability
[   33.151096] Allocate Port Service[0000:00:0b.0:pcie00]
[   33.151139] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   33.151156] assign_interrupt_mode Found MSI capability
[   33.151194] Allocate Port Service[0000:00:0c.0:pcie00]
[   33.151231] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   33.151248] assign_interrupt_mode Found MSI capability
[   33.151286] Allocate Port Service[0000:00:0d.0:pcie00]
[   33.151325] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   33.151341] assign_interrupt_mode Found MSI capability
[   33.151379] Allocate Port Service[0000:00:0e.0:pcie00]
[   33.151554] input: Power Button (FF) as /class/input/input0
[   33.151592] ACPI: Power Button (FF) [PWRF]
[   33.151677] input: Power Button (CM) as /class/input/input1
[   33.151716] ACPI: Power Button (CM) [PWRB]
[   33.151850] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   33.151955] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   33.175890] Real Time Clock Driver v1.12ac
[   33.176009] hpet_resources: 0xfed00000 is busy
[   33.176026] Linux agpgart interface v0.102
[   33.176111] Driver 'sd' needs updating - please use bus_type methods
[   33.176184] ahci 0000:00:0a.0: version 3.0
[   33.176359] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   33.176403] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   34.179224] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl SATA mode
[   34.179276] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   34.179315] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   34.179517] scsi0 : ahci
[   34.179613] scsi1 : ahci
[   34.179678] scsi2 : ahci
[   34.179744] scsi3 : ahci
[   34.179833] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 23
[   34.179880] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 23
[   34.179927] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 23
[   34.179975] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 23
[   34.180028] ata1: hard resetting link
[   34.808890] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   34.809485] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   34.809527] ata1.00: 312581808 sectors, multi 16: LBA48 
[   34.810165] ata1.00: configured for UDMA/133
[   34.810204] ata1: EH complete
[   34.810212] ata2: hard resetting link
[   35.440852] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   35.461416] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   35.461455] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   35.463445] ata2.00: configured for UDMA/133
[   35.463483] ata2: EH complete
[   35.463491] ata3: hard resetting link
[   35.780114] ata3: SATA link down (SStatus 0 SControl 300)
[   35.780154] ata3: EH complete
[   35.780193] ata4: hard resetting link
[   36.099420] ata4: SATA link down (SStatus 0 SControl 300)
[   36.099459] ata4: EH complete
[   36.099544] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   36.099655] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   36.099699] sd 0:0:0:0: [sda] Write Protect is off
[   36.099737] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   36.099745] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   36.099815] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   36.099858] sd 0:0:0:0: [sda] Write Protect is off
[   36.099896] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   36.099903] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   36.099952]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   36.125407] sd 0:0:0:0: [sda] Attached SCSI disk
[   36.125541] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   36.125650] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   36.125695] sd 1:0:0:0: [sdb] Write Protect is off
[   36.125733] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   36.125742] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   36.125811] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   36.125855] sd 1:0:0:0: [sdb] Write Protect is off
[   36.125892] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   36.125900] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   36.125949]  sdb: sdb1 sdb2
[   36.172294] sd 1:0:0:0: [sdb] Attached SCSI disk
[   36.172431] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   36.175006] serio: i8042 KBD port at 0x60,0x64 irq 1
[   36.175046] serio: i8042 AUX port at 0x60,0x64 irq 12
[   36.200129] usbcore: registered new interface driver usbhid
[   36.200168] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   36.200213] TCP cubic registered
[   36.200252] NET: Registered protocol family 1
[   36.200306] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[   36.200350] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   36.200389] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   36.200427] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   36.200465] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   36.200504] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   36.200542] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   36.200580] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   36.200618] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   36.226935] input: AT Translated Set 2 keyboard as /class/input/input2
[   36.321226] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   36.321269] ReiserFS: sda3: using ordered data mode
[   36.330801] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   36.331689] ReiserFS: sda3: checking transaction log (sda3)
[   36.375107] ReiserFS: sda3: Using r5 hash to sort names
[   36.375158] VFS: Mounted root (reiserfs filesystem) readonly.
[   36.375208] Freeing unused kernel memory: 176k freed
[   36.642927] Clocksource tsc unstable (delta = -121953431 ns)
[   38.097912] ReiserFS: sda3: switching to journaled data mode
[   38.197545] r8169 Gigabit Ethernet driver 2.2LK loaded
[   38.197754] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   38.197759] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   38.197768] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   38.197773] r8169 0000:01:00.0: no MSI. Back to INTx.
[   38.197898] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 19
[   38.212572] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   38.212578] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   38.212739] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   38.212742] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   38.212814] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   38.212836] ehci_hcd 0000:00:02.1: debug port 1
[   38.212838] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   38.212844] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   38.215380] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   38.215451] usb usb1: configuration #1 chosen from 1 choice
[   38.215466] hub 1-0:1.0: USB hub found
[   38.215471] hub 1-0:1.0: 10 ports detected
[   38.324831] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   38.366641] usb 1-3: configuration #1 chosen from 1 choice
[   38.366825] hub 1-3:1.0: USB hub found
[   38.367243] hub 1-3:1.0: 4 ports detected
[   38.373811] reiser4: sdb2: found disk format 4.0.0.
[   38.465745] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[   38.495519] usb 1-3.1: configuration #1 chosen from 1 choice
[   38.499113] input: Logitech USB Receiver as /class/input/input3
[   38.506993] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   38.509283] input: Logitech USB Receiver as /class/input/input4
[   38.524731] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   38.528863] mice: PS/2 mouse device common for all mice
[   46.563647] reiser4: sda6: found disk format 4.0.0.
[   47.004306] reiser4: sdb1: found disk format 4.0.0.
[   47.362569] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   48.769822] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   48.769828] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   48.770924] Audigy2 value: Special config.
[   50.135233] w83627ehf: Found W83627EHG chip at 0x290
[   51.103076] r8169: eth0: link up
[   51.103107] r8169: eth0: link up
[   51.769942] NET: Registered protocol family 17
------------------------------------------------------------------------------------------
AHCI without nomsi:
no dmesg, because disks not found, like always. Kernel Panic at end of kernel 
boot because no root-fs.
-------------------------------------------------------------------------------------------
Non-Raid, coldboot, without nomsi:

[    0.000000] Linux version 2.6.24.3reiser4mcp65patch (root@energy) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Apr 2 07:31:52 CEST 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030522
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   37.102619] Marking TSC unstable due to TSCs unsynchronized
[   37.102621] time.c: Detected 3013.889 MHz processor.
[   37.106452] Console: colour VGA+ 80x25
[   37.106454] console [tty6] enabled
[   37.111062] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   37.113292] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   37.114061] Checking aperture...
[   37.114099] CPU 0: aperture @ ecca000000 size 32 MB
[   37.114137] Aperture too small (32 MB)
[   37.120018] No AGP bridge found
[   37.120054] Your BIOS doesn't leave a aperture memory hole
[   37.120092] Please enable the IOMMU option in the BIOS setup
[   37.120130] This costs you 64 MB of RAM
[   37.145357] Mapping aperture over 65536 KB of RAM @ 8000000
[   37.169480] Memory: 4049948k/4980736k available (2192k kernel code, 143428k 
reserved, 681k data, 176k init)
[   37.169548] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[   37.252270] Calibrating delay using timer specific routine.. 6034.69 
BogoMIPS (lpj=10053909)
[   37.252362] Mount-cache hash table entries: 256
[   37.252468] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   37.252508] CPU: L2 Cache: 1024K (64 bytes/line)
[   37.252546] CPU: Physical Processor ID: 0
[   37.252583] CPU: Processor Core ID: 0
[   37.252636] SMP alternatives: switching to UP code
[   37.252998] ACPI: Core revision 20070126
[   37.288173] Using local APIC timer interrupts.
[   37.321317] APIC timer calibration result 12557880
[   37.321319] Detected 12.557 MHz APIC timer.
[   37.321403] SMP alternatives: switching to SMP code
[   37.321633] Booting processor 1/2 APIC 0x1
[   37.331808] Initializing CPU#1
[   37.414571] Calibrating delay using timer specific routine.. 6030.92 
BogoMIPS (lpj=10046282)
[   37.414576] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   37.414577] CPU: L2 Cache: 1024K (64 bytes/line)
[   37.414579] CPU: Physical Processor ID: 0
[   37.414580] CPU: Processor Core ID: 1
[   37.414660] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   37.414661] Brought up 2 CPUs
[   37.415120] net_namespace: 120 bytes
[   37.415351] NET: Registered protocol family 16
[   37.415464] ACPI: bus type pci registered
[   37.415546] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   37.415585] PCI: Not using MMCONFIG.
[   37.415622] PCI: Using configuration type 1
[   37.417864] ACPI: EC: Look up EC in DSDT
[   37.421312] ACPI: Interpreter enabled
[   37.421349] ACPI: (supports S0 S1 S3 S4 S5)
[   37.421519] ACPI: Using IOAPIC for interrupt routing
[   37.421728] Error attaching device data
[   37.421767] Error attaching device data
[   37.421806] Error attaching device data
[   37.421845] Error attaching device data
[   37.426756] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   37.427293] PCI: Transparent bridge - 0000:00:08.0
[   37.427592] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   37.427724] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   37.427821] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   37.427877] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   37.427932] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   37.427987] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   37.431926] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   37.432262] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   37.432597] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   37.432958] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[   37.433318] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   37.433678] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   37.434012] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   37.434373] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   37.434710] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   37.435044] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   37.435405] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   37.435739] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   37.436100] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   37.436460] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   37.436795] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   37.437156] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   37.437490] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   37.437888] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   37.438249] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   37.438611] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   37.438929] Linux Plug and Play Support v0.97 (c) Adam Belay
[   37.438983] pnp: PnP ACPI init
[   37.439022] ACPI: bus type pnp registered
[   37.441561] pnp: PnP ACPI: found 13 devices
[   37.441598] ACPI: ACPI bus type pnp unregistered
[   37.441720] SCSI subsystem initialized
[   37.441777] libata version 3.00 loaded.
[   37.441828] usbcore: registered new interface driver usbfs
[   37.441884] usbcore: registered new interface driver hub
[   37.441941] usbcore: registered new device driver usb
[   37.442025] PCI: Using ACPI for IRQ routing
[   37.442062] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   37.451111] PCI-DMA: Disabling AGP.
[   37.451847] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   37.451888] PCI-DMA: using GART IOMMU.
[   37.451928] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   37.452087] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   37.452226] hpet0: 3 32-bit timers, 25000000 Hz
[   37.454396] Time: hpet clocksource has been installed.
[   37.454445] Switched to high resolution mode on CPU 0
[   37.454590] Switched to high resolution mode on CPU 1
[   37.461128] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   37.461168] system 00:05: ioport range 0x800-0x80f has been reserved
[   37.461208] system 00:05: ioport range 0x2000-0x207f has been reserved
[   37.461247] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   37.464651] system 00:05: ioport range 0x2400-0x247f has been reserved
[   37.464690] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   37.464729] system 00:05: ioport range 0x2800-0x287f has been reserved
[   37.464769] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   37.464808] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   37.464847] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   37.464887] system 00:05: iomem range 0x0-0x0 could not be reserved
[   37.464927] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[   37.464970] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   37.465018] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   37.465068] system 00:0a: ioport range 0x290-0x29f has been reserved
[   37.465111] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[   37.465156] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   37.465195] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   37.465239] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   37.465279] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   37.465326] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   37.465608] PCI: Bridge: 0000:00:08.0
[   37.465645]   IO window: d000-dfff
[   37.465683]   MEM window: f9f00000-f9ffffff
[   37.465720]   PREFETCH window: disabled.
[   37.465758] PCI: Bridge: 0000:00:0b.0
[   37.465794]   IO window: c000-cfff
[   37.465831]   MEM window: f9e00000-f9efffff
[   37.465867]   PREFETCH window: disabled.
[   37.465905] PCI: Bridge: 0000:00:0c.0
[   37.465941]   IO window: disabled.
[   37.465977]   MEM window: disabled.
[   37.466013]   PREFETCH window: disabled.
[   37.466051] PCI: Bridge: 0000:00:0d.0
[   37.466087]   IO window: e000-efff
[   37.466123]   MEM window: fa000000-febfffff
[   37.466161]   PREFETCH window: d0000000-dfffffff
[   37.466198] PCI: Bridge: 0000:00:0e.0
[   37.466234]   IO window: disabled.
[   37.466271]   MEM window: disabled.
[   37.466307]   PREFETCH window: disabled.
[   37.466350] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   37.466359] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   37.466364] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   37.466369] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   37.466374] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   37.466379] NET: Registered protocol family 2
[   37.497695] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   37.498291] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[   37.499717] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   37.500203] TCP: Hash tables configured (established 262144 bind 65536)
[   37.500243] TCP reno registered
[   37.508476] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   37.508580] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[   37.508628] io scheduler noop registered
[   37.508666] io scheduler cfq registered (default)
[   37.509360] Boot video device is 0000:04:00.0
[   37.509463] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   37.509481] assign_interrupt_mode Found MSI capability
[   37.509536] Allocate Port Service[0000:00:0b.0:pcie00]
[   37.509579] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   37.509596] assign_interrupt_mode Found MSI capability
[   37.509645] Allocate Port Service[0000:00:0c.0:pcie00]
[   37.509683] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   37.509700] assign_interrupt_mode Found MSI capability
[   37.509748] Allocate Port Service[0000:00:0d.0:pcie00]
[   37.509787] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   37.509804] assign_interrupt_mode Found MSI capability
[   37.509853] Allocate Port Service[0000:00:0e.0:pcie00]
[   37.510027] input: Power Button (FF) as /class/input/input0
[   37.510066] ACPI: Power Button (FF) [PWRF]
[   37.510151] input: Power Button (CM) as /class/input/input1
[   37.510189] ACPI: Power Button (CM) [PWRB]
[   37.510323] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   37.510428] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   37.534318] Real Time Clock Driver v1.12ac
[   37.534436] hpet_resources: 0xfed00000 is busy
[   37.534453] Linux agpgart interface v0.102
[   37.534538] Driver 'sd' needs updating - please use bus_type methods
[   37.534611] ahci 0000:00:0a.0: version 3.0
[   37.534786] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   37.534830] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   38.535364] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   38.535416] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   38.535456] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   38.535658] scsi0 : ahci
[   38.535753] scsi1 : ahci
[   38.535819] scsi2 : ahci
[   38.535885] scsi3 : ahci
[   38.535973] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   38.536021] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   38.536068] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   38.536116] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   38.536170] ata1: hard resetting link
[   39.167317] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   69.102247] ata1.00: qc timeout (cmd 0xec)
[   69.102286] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   69.102325] ata1: failed to recover some devices, retrying in 5 secs
[   74.094724] ata1: hard resetting link
[   74.726687] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   74.727355] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   74.727397] ata1.00: 312581808 sectors, multi 16: LBA48 
[   74.728021] ata1.00: configured for UDMA/133
[   74.728065] ata1: EH complete
[   74.728020] ata2: hard resetting link
[   75.358646] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   75.360694] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   75.360734] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   75.362725] ata2.00: configured for UDMA/133
[   75.362763] ata2: EH complete
[   75.362716] ata3: hard resetting link
[   75.681278] ata3: SATA link down (SStatus 0 SControl 300)
[   75.681318] ata3: EH complete
[   75.681356] ata4: hard resetting link
[   76.000584] ata4: SATA link down (SStatus 0 SControl 300)
[   76.000622] ata4: EH complete
[   76.000707] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   76.000817] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   76.000861] sd 0:0:0:0: [sda] Write Protect is off
[   76.000899] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   76.000907] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.000977] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   76.001020] sd 0:0:0:0: [sda] Write Protect is off
[   76.001058] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   76.001065] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.001114]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   76.027136] sd 0:0:0:0: [sda] Attached SCSI disk
[   76.027269] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   76.027383] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   76.027428] sd 1:0:0:0: [sdb] Write Protect is off
[   76.027466] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   76.027475] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.027544] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   76.027588] sd 1:0:0:0: [sdb] Write Protect is off
[   76.027625] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   76.027633] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.027682]  sdb: sdb1 sdb2
[   76.076523] sd 1:0:0:0: [sdb] Attached SCSI disk
[   76.076661] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   76.079553] serio: i8042 KBD port at 0x60,0x64 irq 1
[   76.079593] serio: i8042 AUX port at 0x60,0x64 irq 12
[   76.104671] usbcore: registered new interface driver usbhid
[   76.104710] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   76.104754] TCP cubic registered
[   76.104793] NET: Registered protocol family 1
[   76.104847] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[   76.104838] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   76.104877] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   76.104916] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   76.104954] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   76.104992] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   76.105030] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   76.105068] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   76.105107] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   76.128444] input: AT Translated Set 2 keyboard as /class/input/input2
[   76.215268] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   76.215286] ReiserFS: sda3: using ordered data mode
[   76.218449] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   76.219179] ReiserFS: sda3: checking transaction log (sda3)
[   76.233219] ReiserFS: sda3: Using r5 hash to sort names
[   76.233243] VFS: Mounted root (reiserfs filesystem) readonly.
[   76.233268] Freeing unused kernel memory: 176k freed
[   76.320130] Clocksource tsc unstable (delta = -226409081 ns)
[   77.843642] ReiserFS: sda3: switching to journaled data mode
[   77.937038] r8169 Gigabit Ethernet driver 2.2LK loaded
[   77.937245] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   77.937250] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   77.937259] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   77.937407] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 314
[   77.943778] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   77.943784] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   77.943935] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   77.943939] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   77.944013] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   77.944034] ehci_hcd 0000:00:02.1: debug port 1
[   77.944036] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   77.944043] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   77.946961] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   77.947033] usb usb1: configuration #1 chosen from 1 choice
[   77.947047] hub 1-0:1.0: USB hub found
[   77.947052] hub 1-0:1.0: 10 ports detected
[   78.056358] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   78.098216] usb 1-3: configuration #1 chosen from 1 choice
[   78.098396] hub 1-3:1.0: USB hub found
[   78.100884] hub 1-3:1.0: 4 ports detected
[   78.104406] reiser4: sdb2: found disk format 4.0.0.
[   78.197319] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[   78.227050] usb 1-3.1: configuration #1 chosen from 1 choice
[   78.230650] input: Logitech USB Receiver as /class/input/input3
[   78.238571] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   78.240817] input: Logitech USB Receiver as /class/input/input4
[   78.256310] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   78.260759] mice: PS/2 mouse device common for all mice
[   86.535824] reiser4: sda6: found disk format 4.0.0.
[   86.992785] reiser4: sdb1: found disk format 4.0.0.
[   87.343050] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   89.330471] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   89.330476] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   89.331562] Audigy2 value: Special config.
[   90.787221] w83627ehf: Found W83627EHG chip at 0x290
[   91.679513] r8169: eth0: link up
[   91.679616] r8169: eth0: link up
[   92.349231] NET: Registered protocol family 17
--------------------------------------------------------------------------------------

Non-Raid, coldboot with nomsi:

[    0.000000] Linux version 2.6.24.3reiser4mcp65patch (root@energy) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Apr 2 07:31:52 CEST 2008
[    0.000000] Command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030522
[    0.000000] Kernel command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   27.759462] Marking TSC unstable due to TSCs unsynchronized
[   27.759464] time.c: Detected 3013.887 MHz processor.
[   27.763286] Console: colour VGA+ 80x25
[   27.763288] console [tty6] enabled
[   27.767917] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   27.770146] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   27.770916] Checking aperture...
[   27.770953] CPU 0: aperture @ ec8a000000 size 32 MB
[   27.770991] Aperture too small (32 MB)
[   27.776850] No AGP bridge found
[   27.776886] Your BIOS doesn't leave a aperture memory hole
[   27.776924] Please enable the IOMMU option in the BIOS setup
[   27.776962] This costs you 64 MB of RAM
[   27.802191] Mapping aperture over 65536 KB of RAM @ 8000000
[   27.826316] Memory: 4049948k/4980736k available (2192k kernel code, 143428k 
reserved, 681k data, 176k init)
[   27.826385] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[   27.909114] Calibrating delay using timer specific routine.. 6034.69 
BogoMIPS (lpj=10053917)
[   27.909206] Mount-cache hash table entries: 256
[   27.909312] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   27.909352] CPU: L2 Cache: 1024K (64 bytes/line)
[   27.909390] CPU: Physical Processor ID: 0
[   27.909427] CPU: Processor Core ID: 0
[   27.909480] SMP alternatives: switching to UP code
[   27.909843] ACPI: Core revision 20070126
[   27.945018] Using local APIC timer interrupts.
[   27.978163] APIC timer calibration result 12557871
[   27.978164] Detected 12.557 MHz APIC timer.
[   27.978249] SMP alternatives: switching to SMP code
[   27.978478] Booting processor 1/2 APIC 0x1
[   27.988624] Initializing CPU#1
[   28.071388] Calibrating delay using timer specific routine.. 6030.92 
BogoMIPS (lpj=10046277)
[   28.071392] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   28.071394] CPU: L2 Cache: 1024K (64 bytes/line)
[   28.071395] CPU: Physical Processor ID: 0
[   28.071396] CPU: Processor Core ID: 1
[   28.071476] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   28.071506] Brought up 2 CPUs
[   28.071965] net_namespace: 120 bytes
[   28.072196] NET: Registered protocol family 16
[   28.072308] ACPI: bus type pci registered
[   28.072391] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   28.072430] PCI: Not using MMCONFIG.
[   28.072466] PCI: Using configuration type 1
[   28.074707] ACPI: EC: Look up EC in DSDT
[   28.078159] ACPI: Interpreter enabled
[   28.078197] ACPI: (supports S0 S1 S3 S4 S5)
[   28.078366] ACPI: Using IOAPIC for interrupt routing
[   28.078575] Error attaching device data
[   28.078614] Error attaching device data
[   28.078653] Error attaching device data
[   28.078691] Error attaching device data
[   28.083604] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   28.084141] PCI: Transparent bridge - 0000:00:08.0
[   28.084440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   28.084572] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   28.084669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   28.084724] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   28.084779] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   28.084835] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   28.088773] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   28.089109] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   28.089443] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   28.089804] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[   28.090164] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   28.090524] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   28.090857] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   28.091218] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   28.091554] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   28.091889] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   28.092249] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   28.092583] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   28.092943] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   28.093304] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   28.093639] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   28.093999] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   28.094334] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   28.094731] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   28.095092] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   28.095452] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   28.095770] Linux Plug and Play Support v0.97 (c) Adam Belay
[   28.095824] pnp: PnP ACPI init
[   28.095863] ACPI: bus type pnp registered
[   28.098401] pnp: PnP ACPI: found 13 devices
[   28.098438] ACPI: ACPI bus type pnp unregistered
[   28.098560] SCSI subsystem initialized
[   28.098617] libata version 3.00 loaded.
[   28.098667] usbcore: registered new interface driver usbfs
[   28.098723] usbcore: registered new interface driver hub
[   28.098780] usbcore: registered new device driver usb
[   28.098864] PCI: Using ACPI for IRQ routing
[   28.098902] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   28.107957] PCI-DMA: Disabling AGP.
[   28.108693] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   28.108735] PCI-DMA: using GART IOMMU.
[   28.108775] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   28.108934] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   28.109073] hpet0: 3 32-bit timers, 25000000 Hz
[   28.111241] Time: hpet clocksource has been installed.
[   28.111290] Switched to high resolution mode on CPU 0
[   28.111406] Switched to high resolution mode on CPU 1
[   28.117973] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   28.121365] system 00:05: ioport range 0x800-0x80f has been reserved
[   28.121405] system 00:05: ioport range 0x2000-0x207f has been reserved
[   28.121444] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   28.121483] system 00:05: ioport range 0x2400-0x247f has been reserved
[   28.121523] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   28.121562] system 00:05: ioport range 0x2800-0x287f has been reserved
[   28.121601] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   28.121641] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   28.121680] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   28.121720] system 00:05: iomem range 0x0-0x0 could not be reserved
[   28.121759] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[   28.121803] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   28.121850] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   28.121901] system 00:0a: ioport range 0x290-0x29f has been reserved
[   28.121944] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[   28.121989] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   28.122028] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   28.122068] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   28.122111] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   28.122159] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   28.122441] PCI: Bridge: 0000:00:08.0
[   28.122478]   IO window: d000-dfff
[   28.122515]   MEM window: f9f00000-f9ffffff
[   28.122553]   PREFETCH window: disabled.
[   28.122590] PCI: Bridge: 0000:00:0b.0
[   28.122627]   IO window: c000-cfff
[   28.122663]   MEM window: f9e00000-f9efffff
[   28.122700]   PREFETCH window: disabled.
[   28.122737] PCI: Bridge: 0000:00:0c.0
[   28.122773]   IO window: disabled.
[   28.122809]   MEM window: disabled.
[   28.122846]   PREFETCH window: disabled.
[   28.122883] PCI: Bridge: 0000:00:0d.0
[   28.122919]   IO window: e000-efff
[   28.122956]   MEM window: fa000000-febfffff
[   28.122993]   PREFETCH window: d0000000-dfffffff
[   28.123031] PCI: Bridge: 0000:00:0e.0
[   28.123067]   IO window: disabled.
[   28.123103]   MEM window: disabled.
[   28.123139]   PREFETCH window: disabled.
[   28.123182] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   28.123191] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   28.123196] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   28.123201] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   28.123206] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   28.123212] NET: Registered protocol family 2
[   28.154540] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   28.155137] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[   28.156562] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   28.157048] TCP: Hash tables configured (established 262144 bind 65536)
[   28.157088] TCP reno registered
[   28.165321] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   28.165425] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[   28.165473] io scheduler noop registered
[   28.165511] io scheduler cfq registered (default)
[   28.166207] Boot video device is 0000:04:00.0
[   28.166310] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   28.166329] assign_interrupt_mode Found MSI capability
[   28.166369] Allocate Port Service[0000:00:0b.0:pcie00]
[   28.166412] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   28.166429] assign_interrupt_mode Found MSI capability
[   28.166468] Allocate Port Service[0000:00:0c.0:pcie00]
[   28.166505] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   28.166522] assign_interrupt_mode Found MSI capability
[   28.166560] Allocate Port Service[0000:00:0d.0:pcie00]
[   28.166599] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   28.166615] assign_interrupt_mode Found MSI capability
[   28.166654] Allocate Port Service[0000:00:0e.0:pcie00]
[   28.166828] input: Power Button (FF) as /class/input/input0
[   28.166867] ACPI: Power Button (FF) [PWRF]
[   28.166952] input: Power Button (CM) as /class/input/input1
[   28.166990] ACPI: Power Button (CM) [PWRB]
[   28.167124] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   28.167229] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   28.191163] Real Time Clock Driver v1.12ac
[   28.191282] hpet_resources: 0xfed00000 is busy
[   28.191299] Linux agpgart interface v0.102
[   28.191384] Driver 'sd' needs updating - please use bus_type methods
[   28.191457] ahci 0000:00:0a.0: version 3.0
[   28.191632] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   28.191676] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   29.192210] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   29.192261] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   29.192301] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   29.192503] scsi0 : ahci
[   29.192599] scsi1 : ahci
[   29.192665] scsi2 : ahci
[   29.192731] scsi3 : ahci
[   29.192820] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 23
[   29.192867] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 23
[   29.192914] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 23
[   29.192962] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 23
[   29.193015] ata1: hard resetting link
[   29.824163] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   59.759093] ata1.00: qc timeout (cmd 0xec)
[   59.759131] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   59.759170] ata1: failed to recover some devices, retrying in 5 secs
[   64.751570] ata1: hard resetting link
[   65.383532] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   65.384169] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   65.384212] ata1.00: 312581808 sectors, multi 16: LBA48 
[   65.384862] ata1.00: configured for UDMA/133
[   65.384905] ata1: EH complete
[   65.384889] ata2: hard resetting link
[   66.015492] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   66.036080] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   66.036120] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   66.038117] ata2.00: configured for UDMA/133
[   66.038154] ata2: EH complete
[   66.038136] ata3: hard resetting link
[   66.354754] ata3: SATA link down (SStatus 0 SControl 300)
[   66.354793] ata3: EH complete
[   66.354832] ata4: hard resetting link
[   66.674059] ata4: SATA link down (SStatus 0 SControl 300)
[   66.674098] ata4: EH complete
[   66.674183] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   66.674293] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   66.674338] sd 0:0:0:0: [sda] Write Protect is off
[   66.674375] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   66.674384] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.674453] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   66.674496] sd 0:0:0:0: [sda] Write Protect is off
[   66.674534] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   66.674541] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.674590]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   66.708665] sd 0:0:0:0: [sda] Attached SCSI disk
[   66.708799] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   66.708908] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   66.708953] sd 1:0:0:0: [sdb] Write Protect is off
[   66.708991] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   66.709000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.709069] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   66.709112] sd 1:0:0:0: [sdb] Write Protect is off
[   66.709150] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   66.709157] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.709206]  sdb: sdb1 sdb2
[   66.768403] sd 1:0:0:0: [sdb] Attached SCSI disk
[   66.768541] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   66.771378] serio: i8042 KBD port at 0x60,0x64 irq 1
[   66.771423] serio: i8042 AUX port at 0x60,0x64 irq 12
[   66.798077] usbcore: registered new interface driver usbhid
[   66.798115] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   66.798160] TCP cubic registered
[   66.798199] NET: Registered protocol family 1
[   66.798253] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[   66.798272] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   66.798312] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   66.798350] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   66.798388] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   66.798426] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   66.798465] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   66.798503] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   66.798541] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   66.823197] input: AT Translated Set 2 keyboard as /class/input/input2
[   66.876439] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   66.876457] ReiserFS: sda3: using ordered data mode
[   66.879622] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   66.880353] ReiserFS: sda3: checking transaction log (sda3)
[   66.894391] ReiserFS: sda3: Using r5 hash to sort names
[   66.894415] VFS: Mounted root (reiserfs filesystem) readonly.
[   66.894440] Freeing unused kernel memory: 176k freed
[   66.970322] Clocksource tsc unstable (delta = -233077876 ns)
[   68.489857] ReiserFS: sda3: switching to journaled data mode
[   68.592695] r8169 Gigabit Ethernet driver 2.2LK loaded
[   68.592900] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   68.592905] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   68.592913] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   68.592918] r8169 0000:01:00.0: no MSI. Back to INTx.
[   68.593042] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 19
[   68.604956] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   68.604962] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   68.605120] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   68.605124] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   68.605197] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   68.605218] ehci_hcd 0000:00:02.1: debug port 1
[   68.605221] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   68.605227] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   68.608985] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   68.609055] usb usb1: configuration #1 chosen from 1 choice
[   68.609070] hub 1-0:1.0: USB hub found
[   68.609075] hub 1-0:1.0: 10 ports detected
[   68.718144] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   68.759439] usb 1-3: configuration #1 chosen from 1 choice
[   68.759615] hub 1-3:1.0: USB hub found
[   68.762075] hub 1-3:1.0: 4 ports detected
[   68.765724] reiser4: sdb2: found disk format 4.0.0.
[   68.858877] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[   68.893096] usb 1-3.1: configuration #1 chosen from 1 choice
[   68.896822] input: Logitech USB Receiver as /class/input/input3
[   68.902034] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   68.904024] input: Logitech USB Receiver as /class/input/input4
[   68.919782] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   68.928654] mice: PS/2 mouse device common for all mice
[   77.158319] reiser4: sda6: found disk format 4.0.0.
[   77.610522] reiser4: sdb1: found disk format 4.0.0.
[   77.962781] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   79.353427] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   79.353433] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   79.354520] Audigy2 value: Special config.
[   81.058035] w83627ehf: Found W83627EHG chip at 0x290
[   81.933779] r8169: eth0: link up
[   81.933838] r8169: eth0: link up
[   82.344617] NET: Registered protocol family 17
-------------------------------------------------------------------------------------

Non-Raid, reboot without nomsi:

[    0.000000] Linux version 2.6.24.3reiser4mcp65patch (root@energy) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Apr 2 07:31:52 CEST 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030522
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   35.568901] Marking TSC unstable due to TSCs unsynchronized
[   35.568903] time.c: Detected 3013.888 MHz processor.
[   35.572728] Console: colour VGA+ 80x25
[   35.572730] console [tty6] enabled
[   35.577335] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   35.579563] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   35.580333] Checking aperture...
[   35.580371] CPU 0: aperture @ 8000000 size 32 MB
[   35.580408] Aperture too small (32 MB)
[   35.586252] No AGP bridge found
[   35.586288] Your BIOS doesn't leave a aperture memory hole
[   35.586326] Please enable the IOMMU option in the BIOS setup
[   35.586363] This costs you 64 MB of RAM
[   35.611594] Mapping aperture over 65536 KB of RAM @ 8000000
[   35.635717] Memory: 4049948k/4980736k available (2192k kernel code, 143428k 
reserved, 681k data, 176k init)
[   35.635785] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[   35.718550] Calibrating delay using timer specific routine.. 6034.68 
BogoMIPS (lpj=10053895)
[   35.718643] Mount-cache hash table entries: 256
[   35.718750] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   35.718789] CPU: L2 Cache: 1024K (64 bytes/line)
[   35.718827] CPU: Physical Processor ID: 0
[   35.718863] CPU: Processor Core ID: 0
[   35.718916] SMP alternatives: switching to UP code
[   35.719279] ACPI: Core revision 20070126
[   35.754456] Using local APIC timer interrupts.
[   35.787600] APIC timer calibration result 12557871
[   35.787601] Detected 12.557 MHz APIC timer.
[   35.787685] SMP alternatives: switching to SMP code
[   35.787915] Booting processor 1/2 APIC 0x1
[   35.798074] Initializing CPU#1
[   35.880838] Calibrating delay using timer specific routine.. 6030.92 
BogoMIPS (lpj=10046281)
[   35.880842] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   35.880844] CPU: L2 Cache: 1024K (64 bytes/line)
[   35.880846] CPU: Physical Processor ID: 0
[   35.880846] CPU: Processor Core ID: 1
[   35.880928] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   35.880942] Brought up 2 CPUs
[   35.881401] net_namespace: 120 bytes
[   35.881631] NET: Registered protocol family 16
[   35.881744] ACPI: bus type pci registered
[   35.881826] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   35.881865] PCI: Not using MMCONFIG.
[   35.881901] PCI: Using configuration type 1
[   35.884144] ACPI: EC: Look up EC in DSDT
[   35.887592] ACPI: Interpreter enabled
[   35.887630] ACPI: (supports S0 S1 S3 S4 S5)
[   35.887799] ACPI: Using IOAPIC for interrupt routing
[   35.888007] Error attaching device data
[   35.888047] Error attaching device data
[   35.888085] Error attaching device data
[   35.888124] Error attaching device data
[   35.893036] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   35.893571] PCI: Transparent bridge - 0000:00:08.0
[   35.893871] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   35.894003] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   35.894100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   35.894155] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   35.894210] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   35.894266] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   35.898204] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   35.898541] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   35.898875] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   35.899235] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[   35.899595] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   35.899955] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   35.900288] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   35.900648] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   35.900985] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   35.901319] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   35.901679] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   35.902013] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   35.902373] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   35.902734] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   35.903068] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   35.903429] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   35.903763] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   35.904160] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   35.904521] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   35.904882] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   35.905200] Linux Plug and Play Support v0.97 (c) Adam Belay
[   35.905254] pnp: PnP ACPI init
[   35.905293] ACPI: bus type pnp registered
[   35.907831] pnp: PnP ACPI: found 13 devices
[   35.907869] ACPI: ACPI bus type pnp unregistered
[   35.907990] SCSI subsystem initialized
[   35.908047] libata version 3.00 loaded.
[   35.908098] usbcore: registered new interface driver usbfs
[   35.908153] usbcore: registered new interface driver hub
[   35.908210] usbcore: registered new device driver usb
[   35.908294] PCI: Using ACPI for IRQ routing
[   35.908332] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   35.917394] PCI-DMA: Disabling AGP.
[   35.918130] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   35.918172] PCI-DMA: using GART IOMMU.
[   35.918211] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   35.918370] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   35.918509] hpet0: 3 32-bit timers, 25000000 Hz
[   35.920679] Time: hpet clocksource has been installed.
[   35.920727] Switched to high resolution mode on CPU 0
[   35.920857] Switched to high resolution mode on CPU 1
[   35.927411] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   35.927451] system 00:05: ioport range 0x800-0x80f has been reserved
[   35.927490] system 00:05: ioport range 0x2000-0x207f has been reserved
[   35.927530] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   35.930927] system 00:05: ioport range 0x2400-0x247f has been reserved
[   35.930967] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   35.931006] system 00:05: ioport range 0x2800-0x287f has been reserved
[   35.931045] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   35.931084] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   35.931124] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   35.931163] system 00:05: iomem range 0x0-0x0 could not be reserved
[   35.931203] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[   35.931247] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   35.931294] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   35.931345] system 00:0a: ioport range 0x290-0x29f has been reserved
[   35.931387] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[   35.931433] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   35.931472] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   35.931514] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   35.931554] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   35.931601] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   35.931883] PCI: Bridge: 0000:00:08.0
[   35.931920]   IO window: d000-dfff
[   35.931958]   MEM window: f9f00000-f9ffffff
[   35.931995]   PREFETCH window: disabled.
[   35.932033] PCI: Bridge: 0000:00:0b.0
[   35.932069]   IO window: c000-cfff
[   35.932105]   MEM window: f9e00000-f9efffff
[   35.932142]   PREFETCH window: disabled.
[   35.932179] PCI: Bridge: 0000:00:0c.0
[   35.932215]   IO window: disabled.
[   35.932252]   MEM window: disabled.
[   35.932288]   PREFETCH window: disabled.
[   35.932325] PCI: Bridge: 0000:00:0d.0
[   35.932361]   IO window: e000-efff
[   35.932398]   MEM window: fa000000-febfffff
[   35.932435]   PREFETCH window: d0000000-dfffffff
[   35.932472] PCI: Bridge: 0000:00:0e.0
[   35.932508]   IO window: disabled.
[   35.932545]   MEM window: disabled.
[   35.932581]   PREFETCH window: disabled.
[   35.932624] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   35.932632] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   35.932638] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   35.932643] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   35.932648] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   35.932653] NET: Registered protocol family 2
[   35.963977] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   35.964574] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[   35.965998] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   35.966485] TCP: Hash tables configured (established 262144 bind 65536)
[   35.966524] TCP reno registered
[   35.974759] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   35.974862] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[   35.974910] io scheduler noop registered
[   35.974948] io scheduler cfq registered (default)
[   35.975645] Boot video device is 0000:04:00.0
[   35.975747] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   35.975765] assign_interrupt_mode Found MSI capability
[   35.975819] Allocate Port Service[0000:00:0b.0:pcie00]
[   35.975862] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   35.975879] assign_interrupt_mode Found MSI capability
[   35.975927] Allocate Port Service[0000:00:0c.0:pcie00]
[   35.975965] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   35.975982] assign_interrupt_mode Found MSI capability
[   35.976030] Allocate Port Service[0000:00:0d.0:pcie00]
[   35.976069] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   35.976085] assign_interrupt_mode Found MSI capability
[   35.976134] Allocate Port Service[0000:00:0e.0:pcie00]
[   35.976308] input: Power Button (FF) as /class/input/input0
[   35.976346] ACPI: Power Button (FF) [PWRF]
[   35.976431] input: Power Button (CM) as /class/input/input1
[   35.976470] ACPI: Power Button (CM) [PWRB]
[   35.976604] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   35.976708] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   36.000600] Real Time Clock Driver v1.12ac
[   36.000718] hpet_resources: 0xfed00000 is busy
[   36.000735] Linux agpgart interface v0.102
[   36.000821] Driver 'sd' needs updating - please use bus_type methods
[   36.000894] ahci 0000:00:0a.0: version 3.0
[   36.001069] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   36.001112] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   37.001647] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   37.001698] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   37.001738] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   37.001939] scsi0 : ahci
[   37.002035] scsi1 : ahci
[   37.002101] scsi2 : ahci
[   37.002167] scsi3 : ahci
[   37.002256] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   37.002303] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   37.002351] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   37.002398] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   37.002451] ata1: hard resetting link
[   42.636064] ata1: port is slow to respond, please be patient (Status 0xd0)
[   46.999912] ata1: softreset failed (device not ready)
[   46.999950] ata1: hard resetting link
[   47.631874] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   47.632532] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   47.632575] ata1.00: 312581808 sectors, multi 16: LBA48 
[   47.633195] ata1.00: configured for UDMA/133
[   47.633234] ata1: EH complete
[   47.633204] ata2: hard resetting link
[   48.263834] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   48.284435] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   48.284475] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   48.286461] ata2.00: configured for UDMA/133
[   48.286498] ata2: EH complete
[   48.286467] ata3: hard resetting link
[   48.603096] ata3: SATA link down (SStatus 0 SControl 300)
[   48.603136] ata3: EH complete
[   48.603174] ata4: hard resetting link
[   48.922402] ata4: SATA link down (SStatus 0 SControl 300)
[   48.922441] ata4: EH complete
[   48.922526] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   48.922636] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   48.922681] sd 0:0:0:0: [sda] Write Protect is off
[   48.922718] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   48.922727] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   48.922797] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   48.922840] sd 0:0:0:0: [sda] Write Protect is off
[   48.922877] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   48.922884] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   48.922934]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   48.947679] sd 0:0:0:0: [sda] Attached SCSI disk
[   48.947814] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   48.947923] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   48.947968] sd 1:0:0:0: [sdb] Write Protect is off
[   48.948005] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   48.948014] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   48.948084] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   48.948127] sd 1:0:0:0: [sdb] Write Protect is off
[   48.948165] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   48.948172] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   48.948221]  sdb: sdb1 sdb2
[   48.955675] sd 1:0:0:0: [sdb] Attached SCSI disk
[   48.955824] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   48.958615] serio: i8042 KBD port at 0x60,0x64 irq 1
[   48.958655] serio: i8042 AUX port at 0x60,0x64 irq 12
[   48.989889] usbcore: registered new interface driver usbhid
[   48.989928] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   48.989972] TCP cubic registered
[   48.990011] NET: Registered protocol family 1
[   48.990065] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[   48.990071] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   48.990110] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   48.990149] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   48.990187] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   48.990225] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   48.990263] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   48.990301] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   48.990339] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   49.016392] input: AT Translated Set 2 keyboard as /class/input/input2
[   49.110257] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   49.110300] ReiserFS: sda3: using ordered data mode
[   49.119834] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   49.120720] ReiserFS: sda3: checking transaction log (sda3)
[   49.164140] ReiserFS: sda3: Using r5 hash to sort names
[   49.164190] VFS: Mounted root (reiserfs filesystem) readonly.
[   49.164240] Freeing unused kernel memory: 176k freed
[   49.991435] Clocksource tsc unstable (delta = -75286349 ns)
[   51.294824] ReiserFS: sda3: switching to journaled data mode
[   51.391705] r8169 Gigabit Ethernet driver 2.2LK loaded
[   51.391911] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   51.391916] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   51.391925] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   51.392071] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 314
[   51.398432] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   51.398438] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   51.398587] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   51.398590] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   51.398660] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   51.398681] ehci_hcd 0000:00:02.1: debug port 1
[   51.398683] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   51.398690] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   51.400946] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   51.401020] usb usb1: configuration #1 chosen from 1 choice
[   51.401035] hub 1-0:1.0: USB hub found
[   51.401041] hub 1-0:1.0: 10 ports detected
[   51.511466] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   51.553322] usb 1-3: configuration #1 chosen from 1 choice
[   51.553781] hub 1-3:1.0: USB hub found
[   51.553892] hub 1-3:1.0: 4 ports detected
[   51.553958] reiser4: sdb2: found disk format 4.0.0.
[   51.650220] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[   51.680243] usb 1-3.1: configuration #1 chosen from 1 choice
[   51.683964] input: Logitech USB Receiver as /class/input/input3
[   51.689218] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   51.691381] input: Logitech USB Receiver as /class/input/input4
[   51.706973] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   51.715844] mice: PS/2 mouse device common for all mice
[   59.998812] reiser4: sda6: found disk format 4.0.0.
[   60.447503] reiser4: sdb1: found disk format 4.0.0.
[   60.800499] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   62.060963] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   62.060969] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   62.062060] Audigy2 value: Special config.
[   63.523122] w83627ehf: Found W83627EHG chip at 0x290
[   64.564529] r8169: eth0: link up
[   64.564610] r8169: eth0: link up
[   65.034897] NET: Registered protocol family 17
--------------------------------------------------------------------------------------

Non-Raid, reboot with nomsi:

[    0.000000] Linux version 2.6.24.3reiser4mcp65patch (root@energy) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #1 SMP Wed Apr 2 07:31:52 CEST 2008
[    0.000000] Command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       
97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 
20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       
97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       
97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       
97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       
97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 
used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 853 pages reserved
[    0.000000]   DMA zone: 3090 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 
00000000000e6000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e6000 - 
0000000000100000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffb0000 - 
00000000cffc0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cffc0000 - 
00000000cfff0000
[    0.000000] swsusp: Registered nosave memory region: 00000000cfff0000 - 
00000000d0000000
[    0.000000] swsusp: Registered nosave memory region: 00000000d0000000 - 
00000000fec00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec00000 - 
00000000fec01000
[    0.000000] swsusp: Registered nosave memory region: 00000000fec01000 - 
00000000fee00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fee00000 - 
00000000fef00000
[    0.000000] swsusp: Registered nosave memory region: 00000000fef00000 - 
00000000ff380000
[    0.000000] swsusp: Registered nosave memory region: 00000000ff380000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 31408 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1030522
[    0.000000] Kernel command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 
console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[   30.333692] Marking TSC unstable due to TSCs unsynchronized
[   30.333693] time.c: Detected 3013.886 MHz processor.
[   30.337517] Console: colour VGA+ 80x25
[   30.337519] console [tty6] enabled
[   30.342147] Dentry cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[   30.344375] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[   30.345145] Checking aperture...
[   30.345183] CPU 0: aperture @ 8000000 size 32 MB
[   30.345220] Aperture too small (32 MB)
[   30.351101] No AGP bridge found
[   30.351137] Your BIOS doesn't leave a aperture memory hole
[   30.351175] Please enable the IOMMU option in the BIOS setup
[   30.351213] This costs you 64 MB of RAM
[   30.376449] Mapping aperture over 65536 KB of RAM @ 8000000
[   30.400565] Memory: 4049948k/4980736k available (2192k kernel code, 143428k 
reserved, 681k data, 176k init)
[   30.400634] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
[   30.483342] Calibrating delay using timer specific routine.. 6034.68 
BogoMIPS (lpj=10053900)
[   30.483434] Mount-cache hash table entries: 256
[   30.483541] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   30.483581] CPU: L2 Cache: 1024K (64 bytes/line)
[   30.483619] CPU: Physical Processor ID: 0
[   30.483655] CPU: Processor Core ID: 0
[   30.483708] SMP alternatives: switching to UP code
[   30.484071] ACPI: Core revision 20070126
[   30.519247] Using local APIC timer interrupts.
[   30.552391] APIC timer calibration result 12557863
[   30.552393] Detected 12.557 MHz APIC timer.
[   30.552477] SMP alternatives: switching to SMP code
[   30.552707] Booting processor 1/2 APIC 0x1
[   30.562854] Initializing CPU#1
[   30.645618] Calibrating delay using timer specific routine.. 6030.92 
BogoMIPS (lpj=10046281)
[   30.645622] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[   30.645624] CPU: L2 Cache: 1024K (64 bytes/line)
[   30.645625] CPU: Physical Processor ID: 0
[   30.645626] CPU: Processor Core ID: 1
[   30.645707] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   30.645734] Brought up 2 CPUs
[   30.646193] net_namespace: 120 bytes
[   30.646424] NET: Registered protocol family 16
[   30.646536] ACPI: bus type pci registered
[   30.646618] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   30.646657] PCI: Not using MMCONFIG.
[   30.646693] PCI: Using configuration type 1
[   30.648936] ACPI: EC: Look up EC in DSDT
[   30.652388] ACPI: Interpreter enabled
[   30.652425] ACPI: (supports S0 S1 S3 S4 S5)
[   30.652595] ACPI: Using IOAPIC for interrupt routing
[   30.652803] Error attaching device data
[   30.652842] Error attaching device data
[   30.652881] Error attaching device data
[   30.652920] Error attaching device data
[   30.657832] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   30.658369] PCI: Transparent bridge - 0000:00:08.0
[   30.658669] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   30.658801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   30.658898] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   30.658954] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   30.659009] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   30.659064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   30.663003] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[   30.663339] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[   30.663674] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[   30.664034] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[   30.664394] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
disabled.
[   30.664754] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   30.665088] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
disabled.
[   30.665448] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   30.665785] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   30.666120] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
disabled.
[   30.666480] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   30.666814] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
disabled.
[   30.667174] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
disabled.
[   30.667535] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   30.667869] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
disabled.
[   30.668230] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   30.668564] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
disabled.
[   30.668962] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[   30.669322] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
disabled.
[   30.669683] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
disabled.
[   30.670002] Linux Plug and Play Support v0.97 (c) Adam Belay
[   30.670055] pnp: PnP ACPI init
[   30.670095] ACPI: bus type pnp registered
[   30.672633] pnp: PnP ACPI: found 13 devices
[   30.672670] ACPI: ACPI bus type pnp unregistered
[   30.672792] SCSI subsystem initialized
[   30.672849] libata version 3.00 loaded.
[   30.672899] usbcore: registered new interface driver usbfs
[   30.672955] usbcore: registered new interface driver hub
[   30.673012] usbcore: registered new device driver usb
[   30.673096] PCI: Using ACPI for IRQ routing
[   30.673134] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   30.682185] PCI-DMA: Disabling AGP.
[   30.682921] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   30.682963] PCI-DMA: using GART IOMMU.
[   30.683002] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   30.683161] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   30.683301] hpet0: 3 32-bit timers, 25000000 Hz
[   30.685470] Time: hpet clocksource has been installed.
[   30.685519] Switched to high resolution mode on CPU 0
[   30.685636] Switched to high resolution mode on CPU 1
[   30.692202] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[   30.695597] system 00:05: ioport range 0x800-0x80f has been reserved
[   30.695637] system 00:05: ioport range 0x2000-0x207f has been reserved
[   30.695676] system 00:05: ioport range 0x2080-0x20ff has been reserved
[   30.695715] system 00:05: ioport range 0x2400-0x247f has been reserved
[   30.695755] system 00:05: ioport range 0x2480-0x24ff has been reserved
[   30.695794] system 00:05: ioport range 0x2800-0x287f has been reserved
[   30.695833] system 00:05: ioport range 0x2880-0x28ff has been reserved
[   30.695873] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[   30.695912] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[   30.695952] system 00:05: iomem range 0x0-0x0 could not be reserved
[   30.695991] system 00:05: iomem range 0xfee01000-0xfeefffff has been 
reserved
[   30.696035] system 00:07: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[   30.696082] system 00:07: iomem range 0xfee00000-0xfee00fff could not be 
reserved
[   30.696133] system 00:0a: ioport range 0x290-0x29f has been reserved
[   30.696176] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[   30.696221] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   30.696260] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   30.696300] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   30.696342] system 00:0c: iomem range 0x100000-0xcfffffff could not be 
reserved
[   30.696389] system 00:0c: iomem range 0xff380000-0xffffffff could not be 
reserved
[   30.696671] PCI: Bridge: 0000:00:08.0
[   30.696708]   IO window: d000-dfff
[   30.696746]   MEM window: f9f00000-f9ffffff
[   30.696783]   PREFETCH window: disabled.
[   30.696821] PCI: Bridge: 0000:00:0b.0
[   30.696857]   IO window: c000-cfff
[   30.696894]   MEM window: f9e00000-f9efffff
[   30.696930]   PREFETCH window: disabled.
[   30.696967] PCI: Bridge: 0000:00:0c.0
[   30.697003]   IO window: disabled.
[   30.697040]   MEM window: disabled.
[   30.697076]   PREFETCH window: disabled.
[   30.697113] PCI: Bridge: 0000:00:0d.0
[   30.697150]   IO window: e000-efff
[   30.697186]   MEM window: fa000000-febfffff
[   30.697223]   PREFETCH window: d0000000-dfffffff
[   30.697261] PCI: Bridge: 0000:00:0e.0
[   30.697297]   IO window: disabled.
[   30.697333]   MEM window: disabled.
[   30.697370]   PREFETCH window: disabled.
[   30.697413] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   30.697421] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.697426] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.697431] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.697436] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.697442] NET: Registered protocol family 2
[   30.728769] IP route cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[   30.729365] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[   30.730789] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   30.731276] TCP: Hash tables configured (established 262144 bind 65536)
[   30.731316] TCP reno registered
[   30.739550] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[   30.739654] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
254)
[   30.739702] io scheduler noop registered
[   30.739740] io scheduler cfq registered (default)
[   30.740435] Boot video device is 0000:04:00.0
[   30.740539] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   30.740557] assign_interrupt_mode Found MSI capability
[   30.740598] Allocate Port Service[0000:00:0b.0:pcie00]
[   30.740641] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   30.740658] assign_interrupt_mode Found MSI capability
[   30.740696] Allocate Port Service[0000:00:0c.0:pcie00]
[   30.740734] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   30.740750] assign_interrupt_mode Found MSI capability
[   30.740789] Allocate Port Service[0000:00:0d.0:pcie00]
[   30.740828] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   30.740844] assign_interrupt_mode Found MSI capability
[   30.740883] Allocate Port Service[0000:00:0e.0:pcie00]
[   30.741057] input: Power Button (FF) as /class/input/input0
[   30.741096] ACPI: Power Button (FF) [PWRF]
[   30.741181] input: Power Button (CM) as /class/input/input1
[   30.741219] ACPI: Power Button (CM) [PWRB]
[   30.741353] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   30.741458] ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor 
Device is not present [20070126]
[   30.765391] Real Time Clock Driver v1.12ac
[   30.765510] hpet_resources: 0xfed00000 is busy
[   30.765527] Linux agpgart interface v0.102
[   30.765612] Driver 'sd' needs updating - please use bus_type methods
[   30.765685] ahci 0000:00:0a.0: version 3.0
[   30.765860] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   30.765904] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   31.766438] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   31.766489] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[   31.766529] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   31.766731] scsi0 : ahci
[   31.766827] scsi1 : ahci
[   31.766893] scsi2 : ahci
[   31.766959] scsi3 : ahci
[   31.767048] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 23
[   31.767095] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 23
[   31.767143] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 23
[   31.767190] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 23
[   31.767244] ata1: hard resetting link
[   37.400855] ata1: port is slow to respond, please be patient (Status 0xd0)
[   41.764704] ata1: softreset failed (device not ready)
[   41.764742] ata1: hard resetting link
[   42.396665] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   42.397323] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   42.397366] ata1.00: 312581808 sectors, multi 16: LBA48 
[   42.398017] ata1.00: configured for UDMA/133
[   42.398055] ata1: EH complete
[   42.398038] ata2: hard resetting link
[   43.028625] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   43.030633] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   43.030672] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   43.032670] ata2.00: configured for UDMA/133
[   43.032708] ata2: EH complete
[   43.032689] ata3: hard resetting link
[   43.351257] ata3: SATA link down (SStatus 0 SControl 300)
[   43.351297] ata3: EH complete
[   43.351335] ata4: hard resetting link
[   43.670563] ata4: SATA link down (SStatus 0 SControl 300)
[   43.670602] ata4: EH complete
[   43.670687] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   43.670797] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   43.670841] sd 0:0:0:0: [sda] Write Protect is off
[   43.670879] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   43.670887] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   43.670957] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   43.671000] sd 0:0:0:0: [sda] Write Protect is off
[   43.671038] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   43.671045] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   43.671095]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   43.702464] sd 0:0:0:0: [sda] Attached SCSI disk
[   43.702599] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   43.702708] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   43.702752] sd 1:0:0:0: [sdb] Write Protect is off
[   43.702790] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   43.702799] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   43.702869] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   43.702912] sd 1:0:0:0: [sdb] Write Protect is off
[   43.702949] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   43.702957] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   43.703006]  sdb: sdb1 sdb2
[   43.783458] sd 1:0:0:0: [sdb] Attached SCSI disk
[   43.783595] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
irq 1,12
[   43.786170] serio: i8042 KBD port at 0x60,0x64 irq 1
[   43.786210] serio: i8042 AUX port at 0x60,0x64 irq 12
[   43.811212] usbcore: registered new interface driver usbhid
[   43.811251] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   43.811295] TCP cubic registered
[   43.811334] NET: Registered protocol family 1
[   43.811388] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ processors (2 cpu cores) (version 2.20.00)
[   43.811406] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   43.811445] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   43.811483] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   43.811522] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   43.811560] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   43.811598] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   43.811636] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   43.811674] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   43.838200] input: AT Translated Set 2 keyboard as /class/input/input2
[   43.931524] ReiserFS: sda3: found reiserfs format "3.6" with standard 
journal
[   43.931567] ReiserFS: sda3: using ordered data mode
[   43.941099] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
[   43.941987] ReiserFS: sda3: checking transaction log (sda3)
[   43.993714] ReiserFS: sda3: Using r5 hash to sort names
[   43.993765] VFS: Mounted root (reiserfs filesystem) readonly.
[   43.993815] Freeing unused kernel memory: 176k freed
[   44.971314] Clocksource tsc unstable (delta = -333322752 ns)
[   46.105770] ReiserFS: sda3: switching to journaled data mode
[   46.199182] r8169 Gigabit Ethernet driver 2.2LK loaded
[   46.199389] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   46.199394] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
(level, low) -> IRQ 19
[   46.199403] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   46.199408] r8169 0000:01:00.0: no MSI. Back to INTx.
[   46.199532] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, 
XID 38000000 IRQ 19
[   46.205916] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   46.205922] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
(level, low) -> IRQ 22
[   46.206070] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   46.206073] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   46.206147] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[   46.206168] ehci_hcd 0000:00:02.1: debug port 1
[   46.206171] PCI: cache line size of 64 is not supported by device 
0000:00:02.1
[   46.206177] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   46.209018] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
[   46.209099] usb usb1: configuration #1 chosen from 1 choice
[   46.209115] hub 1-0:1.0: USB hub found
[   46.209121] hub 1-0:1.0: 10 ports detected
[   46.318388] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   46.360226] usb 1-3: configuration #1 chosen from 1 choice
[   46.360310] hub 1-3:1.0: USB hub found
[   46.360421] hub 1-3:1.0: 4 ports detected
[   46.361379] reiser4: sdb2: found disk format 4.0.0.
[   46.457125] usb 1-3.1: new low speed USB device using ehci_hcd and address 
3
[   46.487187] usb 1-3.1: configuration #1 chosen from 1 choice
[   46.490723] input: Logitech USB Receiver as /class/input/input3
[   46.496916] input: USB HID v1.11 Mouse [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   46.498954] input: Logitech USB Receiver as /class/input/input4
[   46.514984] input: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:02.1-3.1
[   46.523874] mice: PS/2 mouse device common for all mice
[   54.781342] reiser4: sda6: found disk format 4.0.0.
[   55.243478] reiser4: sdb1: found disk format 4.0.0.
[   55.613500] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
across:1951888k
[   56.942240] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   56.942246] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 
(level, low) -> IRQ 18
[   56.943338] Audigy2 value: Special config.
[   58.501961] w83627ehf: Found W83627EHG chip at 0x290
[   59.483214] r8169: eth0: link up
[   59.483219] r8169: eth0: link up
[   60.168060] NET: Registered protocol family 17


In short, no changes at all.

If you need more information, please tell me so.

Glück Auf,
Volker

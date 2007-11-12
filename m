Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXKLN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXKLN3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbXKLN3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:29:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:28989 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbXKLN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AmAOh5OFO6H3rQu6hZ/dap1d96BhPkN0Gp0FFlnkEjewlseC+yj2knIWdxxlSiBAJ1kFxfkU2SpUut1mO/3Cih01MYVFaI66RG3xa41MT8oS/RBp+8r6rOnSN4eYfSzrXvyVE1brOriQsGH3fLTgzuFkAkYXtjZlYccAbkShxlg=
Message-ID: <47385513.3020304@gmail.com>
Date: Mon, 12 Nov 2007 22:28:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       hancockr@shaw.ca
Subject: Re: question about sata-error on boot.
References: <200711021934.21123.volker.armin.hemmann@tu-clausthal.de> <20071106221556.55c3cd0b.akpm@linux-foundation.org>
In-Reply-To: <20071106221556.55c3cd0b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Robert Hancock, maybe we need ATA_LFLAG_HRST_TO_RESUME for these
controllers?)
Andrew Morton wrote:
>> On Fri, 2 Nov 2007 19:34:20 +0100 "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de> wrote:
>> Hi,
> 
> (cc linux-ide)
> 
>> for some time (and I can't say for how long, but the board is less than a
>> month old) I get this error on boot:
>>
>> [   42.116273] ahci 0000:00:0a.0: version 2.2
>> [   42.116482] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
>> [   42.116653] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
>> (level, low) -> IRQ 23
>> [   43.119478] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
>> impl IDE mode
>> [   43.119778] ahci 0000:00:0a.0: flags: 64bit led clo pmp pio
>> [   43.119943] PCI: Setting latency timer of device 0000:00:0a.0 to 64
>> [   43.120149] scsi0 : ahci
>> [   43.120365] scsi1 : ahci
>> [   43.120556] scsi2 : ahci
>> [   43.120741] scsi3 : ahci
>> [   43.120927] ata1: SATA max UDMA/133 cmd 0xffffc20000014100 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121227] ata2: SATA max UDMA/133 cmd 0xffffc20000014180 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121526] ata3: SATA max UDMA/133 cmd 0xffffc20000014200 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121826] ata4: SATA max UDMA/133 cmd 0xffffc20000014280 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.934296] ata1: softreset failed (1st FIS failed)
>> [   43.934461] ata1: reset failed (errno=-5), retrying in 10 secs
>> [   53.885194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   53.885890] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
>> [   53.886056] ata1.00: 312581808 sectors, multi 16: LBA48
>> [   53.886804] ata1.00: configured for UDMA/133
>> [   54.201147] ata2: SATA link down (SStatus 0 SControl 300)
>> [   54.517101] ata3: SATA link down (SStatus 0 SControl 300)
>> [   54.833055] ata4: SATA link down (SStatus 0 SControl 300)
>>
>> The board has four ports and I use the first one. After that, the computer 
>> boots and works fine. Harddisk-speed is normal. Kernel is 2.6.22.9 with 
>> cfs&reiser4 patches.
>>
>> Is this something to worry about?
>>
>> Following is lspci -v and dmesg, config is attached. 
>> lspci -v
>> 00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
>>         Subsystem: ASRock Incorporation Unknown device 0444
>>         Flags: bus master, 66MHz, fast devsel, latency 0
>>         Capabilities: [44] HyperTransport: Slave or Primary Interface
>>         Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
>>
>> 00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
>>         Subsystem: ASRock Incorporation Unknown device 0441
>>         Flags: bus master, 66MHz, fast devsel, latency 0
>>         I/O ports at 2f00 [size=256]
>>
>> 00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
>>         Subsystem: ASRock Incorporation Unknown device 0446
>>         Flags: 66MHz, fast devsel, IRQ 11
>>         I/O ports at ac00 [size=64]
>>         I/O ports at 2d00 [size=64]
>>         I/O ports at 2e00 [size=64]
>>         Capabilities: [44] Power Management version 2
>>
>> 00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
>>         Subsystem: ASRock Incorporation Unknown device 0446
>>         Flags: 66MHz, fast devsel
>>
>> 00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) 
>> (prog-if 10 [OHCI])
>>         Subsystem: ASRock Incorporation Unknown device 0454
>>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
>>         Memory at f9dff000 (32-bit, non-prefetchable) [size=4K]
>>         Capabilities: [44] Power Management version 2
>>
>> 00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1) 
>> (prog-if 20 [EHCI])
>>         Subsystem: ASRock Incorporation Unknown device 0455
>>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
>>         Memory at f9dfec00 (32-bit, non-prefetchable) [size=256]
>>         Capabilities: [44] Debug port
>>         Capabilities: [80] Power Management version 2
>>
>> 00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 01 
>> [Subtractive decode])
>>         Flags: bus master, 66MHz, fast devsel, latency 0
>>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=128
>>         I/O behind bridge: 0000c000-0000dfff
>>         Memory behind bridge: f9f00000-f9ffffff
>>         Prefetchable memory behind bridge: 88000000-880fffff
>>         Capabilities: [b8] Subsystem: ASRock Incorporation Unknown device 0449
>>         Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
>>
>> 00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a 
>> [Master SecP PriP])
>>         Subsystem: ASRock Incorporation Unknown device 0448
>>         Flags: bus master, 66MHz, fast devsel, latency 0
>>         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] 
>> [size=8]
>>         [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] 
>> [size=1]
>>         [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] 
>> [size=8]
>>         [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] 
>> [size=1]
>>         I/O ports at ffa0 [size=16]
>>         Capabilities: [44] Power Management version 2
>>
>> 00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1) 
>> (prog-if 85 [Master SecO PriO])
>>         Subsystem: ASRock Incorporation Unknown device 045d
>>         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 315
>>         I/O ports at 0e00 [size=8]
>>         I/O ports at 0e20 [size=4]
>>         I/O ports at 0e40 [size=8]
>>         I/O ports at 0e60 [size=4]
>>         I/O ports at 9800 [size=16]
>>         Memory at f9dfc000 (32-bit, non-prefetchable) [size=8K]
>>         Capabilities: [44] Power Management version 2
>>         Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/3 Enable+
>>         Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
>>
>> 00:0b.0 PCI bridge: nVidia Corporation Unknown device 045b (rev a1) (prog-if 
>> 00 [Normal decode])
>>         Flags: bus master, fast devsel, latency 0
>>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>>         I/O behind bridge: 0000b000-0000bfff
>>         Memory behind bridge: f9e00000-f9efffff
>>         Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 045b
>>         Capabilities: [48] Power Management version 2
>>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/1 Enable+
>>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>>
>> 00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) 
>> (prog-if 00 [Normal decode])
>>         Flags: bus master, fast devsel, latency 0
>>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>>         Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 045a
>>         Capabilities: [48] Power Management version 2
>>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/1 Enable+
>>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>>
>> 00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) 
>> (prog-if 00 [Normal decode])
>>         Flags: bus master, fast devsel, latency 0
>>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>>         I/O behind bridge: 0000e000-0000efff
>>         Memory behind bridge: fa000000-febfffff
>>         Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
>>         Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0458
>>         Capabilities: [48] Power Management version 2
>>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/1 Enable+
>>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>>
>> 00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1) 
>> (prog-if 00 [Normal decode])
>>         Flags: bus master, fast devsel, latency 0
>>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>>         Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0459
>>         Capabilities: [48] Power Management version 2
>>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/1 Enable+
>>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>         Capabilities: [80] Express Root Port (Slot+), MSI 00
>>
>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
>> HyperTransport Technology Configuration
>>         Flags: fast devsel
>>         Capabilities: [80] HyperTransport: Host or Secondary Interface
>>
>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
>> Address Map
>>         Flags: fast devsel
>>
>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
>> Controller
>>         Flags: fast devsel
>>
>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
>> Miscellaneous Control
>>         Flags: fast devsel
>>         Capabilities: [f0] #0f [0010]
>>
>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
>> Express Gigabit Ethernet controller (rev 01)
>>         Subsystem: ASRock Incorporation Unknown device 8168
>>         Flags: bus master, fast devsel, latency 0, IRQ 19
>>         I/O ports at b800 [size=256]
>>         Memory at f9eff000 (64-bit, non-prefetchable) [size=4K]
>>         Expansion ROM at f9ec0000 [disabled] [size=128K]
>>         Capabilities: [40] Power Management version 2
>>         Capabilities: [48] Vital Product Data
>>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/1 Enable-
>>         Capabilities: [60] Express Endpoint, MSI 00
>>         Capabilities: [84] Vendor Specific Information
>>
>> 02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
>> Controller (PHY/Link) (prog-if 10 [OHCI])
>>         Subsystem: ASRock Incorporation Unknown device 8023
>>         Flags: bus master, medium devsel, latency 128, IRQ 11
>>         Memory at f9fff800 (32-bit, non-prefetchable) [size=2K]
>>         Memory at f9ff8000 (32-bit, non-prefetchable) [size=16K]
>>         Capabilities: [44] Power Management version 2
>>
>> 02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
>>         Subsystem: Adaptec Unknown device 7884
>>         Flags: bus master, medium devsel, latency 128, IRQ 5
>>         I/O ports at d800 [size=256]
>>         Memory at f9ffe000 (32-bit, non-prefetchable) [size=4K]
>>         Expansion ROM at 88020000 [disabled] [size=64K]
>>         Capabilities: [dc] Power Management version 1
>>
>> 02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
>>         Subsystem: Creative Labs Unknown device 1001
>>         Flags: bus master, medium devsel, latency 128, IRQ 17
>>         I/O ports at dc00 [size=64]
>>         Capabilities: [dc] Power Management version 2
>>
>> 02:0a.0 Mass storage controller: HighPoint Technologies, Inc. 
>> HPT366/368/370/370A/372/372N (rev 01)
>>         Flags: bus master, medium devsel, latency 120, IRQ 18
>>         I/O ports at d480 [size=8]
>>         I/O ports at d400 [size=4]
>>         I/O ports at d000 [size=256]
>>         Expansion ROM at 88000000 [disabled by cmd] [size=128K]
>>
>> 02:0a.1 Mass storage controller: HighPoint Technologies, Inc. 
>> HPT366/368/370/370A/372/372N (rev 01)
>>         Flags: bus master, medium devsel, latency 120, IRQ 18
>>         I/O ports at cc00 [size=8]
>>         I/O ports at c880 [size=4]
>>         I/O ports at c400 [size=256]
>>
>> 04:00.0 VGA compatible controller: nVidia Corporation GeForce 8600 GT (rev a1) 
>> (prog-if 00 [VGA])
>>         Subsystem: nVidia Corporation Unknown device 0439
>>         Flags: bus master, fast devsel, latency 0, IRQ 16
>>         Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
>>         Memory at d0000000 (64-bit, prefetchable) [size=256M]
>>         Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
>>         I/O ports at ec00 [size=128]
>>         [virtual] Expansion ROM at febe0000 [disabled] [size=128K]
>>         Capabilities: [60] Power Management version 2
>>         Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
>> Queue=0/0 Enable-
>>         Capabilities: [78] Express Endpoint, MSI 0
>>
>> dmesg:
>> [    0.000000] Linux version 2.6.22.9-cfs-v22reiser4 (root@energy) (gcc 
>> version 4.2.2 (Gentoo 4.2.2 p1.0)) #5 SMP Thu Oct 25 14:39:54 CEST 2007
>> [    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
>> [    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
>> [    0.000000]  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
>> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 used
>> [    0.000000] end_pfn_map = 1048576
>> [    0.000000] DMI present.
>> [    0.000000] ACPI: RSDP 000FA530, 0014 (r0 ACPIAM)
>> [    0.000000] ACPI: RSDT 7FFB0000, 003C (r1 A M I  OEMRSDT   9000720 MSFT       
>> 97)
>> [    0.000000] ACPI: FACP 7FFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       
>> 97)
>> [    0.000000] ACPI: DSDT 7FFB0450, 4FFA (r1  ASR19 ASR1915A      15A INTL 
>> 20051117)
>> [    0.000000] ACPI: FACS 7FFC0000, 0040
>> [    0.000000] ACPI: APIC 7FFB0390, 0080 (r1 A M I  OEMAPIC   9000720 MSFT       
>> 97)
>> [    0.000000] ACPI: MCFG 7FFB0410, 003C (r1 A M I  OEMMCFG   9000720 MSFT       
>> 97)
>> [    0.000000] ACPI: OEMB 7FFC0040, 0060 (r1 A M I  AMI_OEM   9000720 MSFT       
>> 97)
>> [    0.000000] ACPI: HPET 7FFB5450, 0038 (r1 A M I  OEMHPET0  9000720 MSFT       
>> 97)
>> [    0.000000] ACPI: SSDT 7FFB5490, 030E (r1 A M I  POWERNOW        1 AMD         
>> 1)
>> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
>> [    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 used
>> [    0.000000] No mptable found.
>> [    0.000000] Zone PFN ranges:
>> [    0.000000]   DMA             0 ->     4096
>> [    0.000000]   DMA32        4096 ->  1048576
>> [    0.000000]   Normal    1048576 ->  1048576
>> [    0.000000] early_node_map[2] active PFN ranges
>> [    0.000000]     0:        0 ->      159
>> [    0.000000]     0:      256 ->   524208
>> [    0.000000] On node 0 totalpages: 524111
>> [    0.000000]   DMA zone: 56 pages used for memmap
>> [    0.000000]   DMA zone: 905 pages reserved
>> [    0.000000]   DMA zone: 3038 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 7110 pages used for memmap
>> [    0.000000]   DMA32 zone: 513002 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 0 pages used for memmap
>> [    0.000000] ACPI: PM-Timer IO Port: 0x2008
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] Processor #0 (Bootup-CPU)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] Processor #1
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
>> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] ACPI: IRQ14 used by override.
>> [    0.000000] ACPI: IRQ15 used by override.
>> [    0.000000] Setting APIC routing to flat
>> [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] Allocating PCI resources starting at 88000000 (gap: 
>> 80000000:7ec00000)
>> [    0.000000] PERCPU: Allocating 29336 bytes of per cpu data
>> [    0.000000] Built 1 zonelists.  Total pages: 516040
>> [    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0
>> [    0.000000] Initializing CPU#0
>> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
>> [    0.000000] Marking TSC unstable due to TSCs unsynchronized
>> [   40.731282] time.c: Detected 3013.892 MHz processor.
>> [   40.735511] Console: colour VGA+ 80x25
>> [   40.745472] Dentry cache hash table entries: 262144 (order: 9, 2097152 
>> bytes)
>> [   40.746781] Inode-cache hash table entries: 131072 (order: 8, 1048576 
>> bytes)
>> [   40.747137] Checking aperture...
>> [   40.747300] CPU 0: aperture @ ecc8000000 size 32 MB
>> [   40.747464] Aperture too small (32 MB)
>> [   40.753296] No AGP bridge found
>> [   40.765569] Memory: 2060372k/2096832k available (2200k kernel code, 35792k 
>> reserved, 669k data, 184k init)
>> [   40.847841] Calibrating delay using timer specific routine.. 6034.57 
>> BogoMIPS (lpj=10053716)
>> [   40.848202] Mount-cache hash table entries: 256
>> [   40.848437] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
>> bytes/line)
>> [   40.848602] CPU: L2 Cache: 1024K (64 bytes/line)
>> [   40.848766] CPU: Physical Processor ID: 0
>> [   40.848928] CPU: Processor Core ID: 0
>> [   40.849103] Freeing SMP alternatives: 26k freed
>> [   40.849613] ACPI: Core revision 20070126
>> [   40.884963] Using local APIC timer interrupts.
>> [   40.918232] result 12557891
>> [   40.918393] Detected 12.557 MHz APIC timer.
>> [   40.921062] Booting processor 1/2 APIC 0x1
>> [   40.931358] Initializing CPU#1
>> [   41.014213] Calibrating delay using timer specific routine.. 6030.95 
>> BogoMIPS (lpj=10046323)
>> [   41.014218] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
>> bytes/line)
>> [   41.014219] CPU: L2 Cache: 1024K (64 bytes/line)
>> [   41.014221] CPU: Physical Processor ID: 0
>> [   41.014222] CPU: Processor Core ID: 1
>> [   41.014303] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
>> [   41.017460] Brought up 2 CPUs
>> [   41.019044] NET: Registered protocol family 16
>> [   41.019258] ACPI: bus type pci registered
>> [   41.019428] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
>> [   41.019592] PCI: Not using MMCONFIG.
>> [   41.019755] PCI: Using configuration type 1
>> [   41.024096] ACPI: Interpreter enabled
>> [   41.024259] ACPI: Using IOAPIC for interrupt routing
>> [   41.024586] Error attaching device data
>> [   41.024751] Error attaching device data
>> [   41.024916] Error attaching device data
>> [   41.025082] Error attaching device data
>> [   41.031242] ACPI: PCI Root Bridge [PCI0] (0000:00)
>> [   41.031413] PCI: Probing PCI hardware (bus 00)
>> [   41.031942] PCI: Transparent bridge - 0000:00:08.0
>> [   41.032367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [   41.032524] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
>> [   41.032638] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
>> [   41.032705] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
>> [   41.032771] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
>> [   41.032836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
>> [   41.037361] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *5
>> [   41.037882] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *10
>> [   41.038385] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
>> [   41.038888] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
>> [   41.039391] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, 
>> disabled.
>> [   41.039923] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
>> [   41.040426] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, 
>> disabled.
>> [   41.040972] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
>> [   41.041475] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
>> [   41.041978] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.042510] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
>> [   41.043012] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.043544] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.044088] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
>> [   41.044593] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.045126] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
>> [   41.045630] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.046189] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.046722] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.047255] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, 
>> disabled.
>> [   41.047708] Linux Plug and Play Support v0.97 (c) Adam Belay
>> [   41.047879] pnp: PnP ACPI init
>> [   41.048045] ACPI: bus type pnp registered
>> [   41.051043] pnp: PnP ACPI: found 13 devices
>> [   41.051205] ACPI: ACPI bus type pnp unregistered
>> [   41.051432] SCSI subsystem initialized
>> [   41.051618] libata version 2.21 loaded.
>> [   41.051654] usbcore: registered new interface driver usbfs
>> [   41.051834] usbcore: registered new interface driver hub
>> [   41.052016] usbcore: registered new device driver usb
>> [   41.052197] PCI: Using ACPI for IRQ routing
>> [   41.052360] PCI: If a device doesn't work, try "pci=routeirq".  If it 
>> helps, post a report
>> [   41.052747] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
>> [   41.053027] hpet0: 3 32-bit timers, 25000000 Hz
>> [   41.054255] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
>> [   41.054421] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
>> [   41.054589] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be 
>> reserved
>> [   41.054886] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be 
>> reserved
>> [   41.055185] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
>> [   41.055351] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
>> [   41.055519] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
>> [   41.055685] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
>> [   41.055850] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
>> [   41.056017] pnp: 00:0c: iomem range 0x100000-0x7fffffff could not be 
>> reserved
>> [   41.056338] PCI: Bridge: 0000:00:08.0
>> [   41.056501]   IO window: c000-dfff
>> [   41.056664]   MEM window: f9f00000-f9ffffff
>> [   41.056829]   PREFETCH window: 88000000-880fffff
>> [   41.056993] PCI: Bridge: 0000:00:0b.0
>> [   41.057156]   IO window: b000-bfff
>> [   41.057319]   MEM window: f9e00000-f9efffff
>> [   41.057451] Time: hpet clocksource has been installed.
>> [   41.057645]   PREFETCH window: disabled.
>> [   41.057808] PCI: Bridge: 0000:00:0c.0
>> [   41.057970]   IO window: disabled.
>> [   41.058132]   MEM window: disabled.
>> [   41.058294]   PREFETCH window: disabled.
>> [   41.058457] PCI: Bridge: 0000:00:0d.0
>> [   41.058619]   IO window: e000-efff
>> [   41.058783]   MEM window: fa000000-febfffff
>> [   41.058946]   PREFETCH window: d0000000-dfffffff
>> [   41.059110] PCI: Bridge: 0000:00:0e.0
>> [   41.059272]   IO window: disabled.
>> [   41.059434]   MEM window: disabled.
>> [   41.059596]   PREFETCH window: disabled.
>> [   41.059765] PCI: Setting latency timer of device 0000:00:08.0 to 64
>> [   41.059770] PCI: Setting latency timer of device 0000:00:0b.0 to 64
>> [   41.059774] PCI: Setting latency timer of device 0000:00:0c.0 to 64
>> [   41.059778] PCI: Setting latency timer of device 0000:00:0d.0 to 64
>> [   41.059783] PCI: Setting latency timer of device 0000:00:0e.0 to 64
>> [   41.059801] NET: Registered protocol family 2
>> [   41.100619] IP route cache hash table entries: 65536 (order: 7, 524288 
>> bytes)
>> [   41.101145] TCP established hash table entries: 131072 (order: 9, 3145728 
>> bytes)
>> [   41.102591] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>> [   41.103136] TCP: Hash tables configured (established 131072 bind 65536)
>> [   41.103302] TCP reno registered
>> [   41.114592] Total HugeTLB memory allocated, 0
>> [   41.114825] Loading Reiser4. See www.namesys.com for a description of 
>> Reiser4.
>> [   41.115182] io scheduler noop registered
>> [   41.115352] io scheduler cfq registered (default)
>> [   41.116320] Boot video device is 0000:04:00.0
>> [   41.116435] PCI: Setting latency timer of device 0000:00:0b.0 to 64
>> [   41.116450] assign_interrupt_mode Found MSI capability
>> [   41.116629] Allocate Port Service[0000:00:0b.0:pcie00]
>> [   41.116670] PCI: Setting latency timer of device 0000:00:0c.0 to 64
>> [   41.116685] assign_interrupt_mode Found MSI capability
>> [   41.116857] Allocate Port Service[0000:00:0c.0:pcie00]
>> [   41.116893] PCI: Setting latency timer of device 0000:00:0d.0 to 64
>> [   41.116908] assign_interrupt_mode Found MSI capability
>> [   41.117080] Allocate Port Service[0000:00:0d.0:pcie00]
>> [   41.117117] PCI: Setting latency timer of device 0000:00:0e.0 to 64
>> [   41.117135] assign_interrupt_mode Found MSI capability
>> [   41.120561] Allocate Port Service[0000:00:0e.0:pcie00]
>> [   41.120731] input: Power Button (FF) as /class/input/input0
>> [   41.120895] ACPI: Power Button (FF) [PWRF]
>> [   41.121116] input: Power Button (CM) as /class/input/input1
>> [   41.121279] ACPI: Power Button (CM) [PWRB]
>> [   41.140593] Real Time Clock Driver v1.12ac
>> [   41.140939] hpet_resources: 0xfed00000 is busy
>> [   41.140970] Linux agpgart interface v0.102 (c) Dave Jones
>> [   41.141204] tun: Universal TUN/TAP device driver, 1.6
>> [   41.141367] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
>> [   41.141551] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
>> [   41.141716] ide: Assuming 33MHz system bus speed for PIO modes; override 
>> with idebus=xx
>> [   41.142031] NFORCE-MCP65: IDE controller at PCI slot 0000:00:09.0
>> [   41.142207] NFORCE-MCP65: chipset revision 161
>> [   41.142371] NFORCE-MCP65: not 100% native mode: will probe irqs later
>> [   41.142539] NFORCE-MCP65: 0000:00:09.0 (rev a1) UDMA133 controller
>> [   41.142706]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, 
>> hdb:pio
>> [   41.143065] Probing IDE interface ide0...
>> [   41.430036] hda: SAMSUNG SP1213N, ATA DISK drive
>> [   42.071954] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>> [   42.074576] hda: max request size: 512KiB
>> [   42.074789] hda: 234493056 sectors (120060 MB) w/8192KiB Cache, 
>> CHS=16383/255/63, UDMA(100)
>> [   42.075551] hda: cache flushes supported
>> [   42.075734]  hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
>> [   42.116273] ahci 0000:00:0a.0: version 2.2
>> [   42.116482] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
>> [   42.116653] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
>> (level, low) -> IRQ 23
>> [   43.119478] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
>> impl IDE mode
>> [   43.119778] ahci 0000:00:0a.0: flags: 64bit led clo pmp pio
>> [   43.119943] PCI: Setting latency timer of device 0000:00:0a.0 to 64
>> [   43.120149] scsi0 : ahci
>> [   43.120365] scsi1 : ahci
>> [   43.120556] scsi2 : ahci
>> [   43.120741] scsi3 : ahci
>> [   43.120927] ata1: SATA max UDMA/133 cmd 0xffffc20000014100 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121227] ata2: SATA max UDMA/133 cmd 0xffffc20000014180 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121526] ata3: SATA max UDMA/133 cmd 0xffffc20000014200 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.121826] ata4: SATA max UDMA/133 cmd 0xffffc20000014280 ctl 
>> 0x0000000000000000 bmdma 0x0000000000000000 irq 315
>> [   43.934296] ata1: softreset failed (1st FIS failed)
>> [   43.934461] ata1: reset failed (errno=-5), retrying in 10 secs
>> [   53.885194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   53.885890] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
>> [   53.886056] ata1.00: 312581808 sectors, multi 16: LBA48
>> [   53.886804] ata1.00: configured for UDMA/133
>> [   54.201147] ata2: SATA link down (SStatus 0 SControl 300)
>> [   54.517101] ata3: SATA link down (SStatus 0 SControl 300)
>> [   54.833055] ata4: SATA link down (SStatus 0 SControl 300)
>> [   54.833271] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
>> PQ: 0 ANSI: 5
>> [   54.833623] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
>> MB)
>> [   54.833793] sd 0:0:0:0: [sda] Write Protect is off
>> [   54.833957] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [   54.833965] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
>> doesn't support DPO or FUA
>> [   54.834287] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
>> MB)
>> [   54.834455] sd 0:0:0:0: [sda] Write Protect is off
>> [   54.834619] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [   54.834626] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
>> doesn't support DPO or FUA
>> [   54.834924]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
>> [   54.869055] sd 0:0:0:0: [sda] Attached SCSI disk
>> [   54.869495] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
>> [   54.869667] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 
>> (level, low) -> IRQ 22
>> [   54.870288] PCI: Setting latency timer of device 0000:00:02.1 to 64
>> [   54.870293] ehci_hcd 0000:00:02.1: EHCI Host Controller
>> [   54.870532] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
>> number 1
>> [   54.870848] ehci_hcd 0000:00:02.1: debug port 1
>> [   54.871013] PCI: cache line size of 64 is not supported by device 
>> 0000:00:02.1
>> [   54.871022] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
>> [   54.871191] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
>> Dec 2004
>> [   54.871572] usb usb1: configuration #1 chosen from 1 choice
>> [   54.871761] hub 1-0:1.0: USB hub found
>> [   54.871927] hub 1-0:1.0: 10 ports detected
>> [   54.976112] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) 
>> Driver
>> [   54.976353] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
>> [   54.976523] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21 
>> (level, low) -> IRQ 21
>> [   54.977020] PCI: Setting latency timer of device 0000:00:02.0 to 64
>> [   54.977025] ohci_hcd 0000:00:02.0: OHCI Host Controller
>> [   54.977260] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
>> number 2
>> [   54.977569] ohci_hcd 0000:00:02.0: irq 21, io mem 0xf9dff000
>> [   55.034680] usb usb2: configuration #1 chosen from 1 choice
>> [   55.034869] hub 2-0:1.0: USB hub found
>> [   55.035037] hub 2-0:1.0: 10 ports detected
>> [   55.139122] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 
>> irq 1,12
>> [   55.142186] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [   55.142352] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [   55.142569] mice: PS/2 mouse device common for all mice
>> [   55.169330] input: AT Translated Set 2 keyboard as /class/input/input2
>> [   55.431622] usb 1-5: new high speed USB device using ehci_hcd and address 3
>> [   55.566822] usb 1-5: configuration #1 chosen from 1 choice
>> [   55.807525] usb 2-4: new full speed USB device using ohci_hcd and address 2
>> [   55.963577] usb 2-4: configuration #1 chosen from 1 choice
>> [   55.969539] hub 2-4:1.0: USB hub found
>> [   55.972507] hub 2-4:1.0: 4 ports detected
>> [   56.314740] usb 2-4.1: new full speed USB device using ohci_hcd and address 
>> 3
>> [   56.449493] usb 2-4.1: configuration #1 chosen from 1 choice
>> [   56.669944] usb 2-4.3: new low speed USB device using ohci_hcd and address 
>> 4
>> [   56.783741] usb 2-4.3: configuration #1 chosen from 1 choice
>> [   56.802767] input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
>> [   56.802968] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on 
>> usb-0000:00:02.0-4.3
>> [   56.803327] usbcore: registered new interface driver usbhid
>> [   56.803492] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
>> [   56.803690] TCP cubic registered
>> [   56.803861] NET: Registered protocol family 1
>> [   56.804026] NET: Registered protocol family 17
>> [   56.804201] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 
>> 6000+ processors (version 2.00.00)
>> [   56.804448] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
>> [   56.804613] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
>> [   56.804778] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
>> [   56.804943] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
>> [   56.805107] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
>> [   56.805272] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
>> [   56.805437] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
>> [   56.805602] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
>> [   56.826551] ReiserFS: sda3: found reiserfs format "3.6" with standard 
>> journal
>> [   56.826720] ReiserFS: sda3: using ordered data mode
>> [   56.836124] ReiserFS: sda3: journal params: device sda3, size 8192, journal 
>> first block 18, max trans len 1024, max batch 900, max commit age 30, max 
>> trans age 30
>> [   56.837467] ReiserFS: sda3: checking transaction log (sda3)
>> [   56.888740] ReiserFS: sda3: Using r5 hash to sort names
>> [   56.888915] VFS: Mounted root (reiserfs filesystem) readonly.
>> [   56.889092] Freeing unused kernel memory: 184k freed
>> [   61.840593] ReiserFS: sda3: switching to journaled data mode
>> [   62.230945] r8169 Gigabit Ethernet driver 2.2LK loaded
>> [   62.231224] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
>> [   62.231232] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 
>> (level, low) -> IRQ 19
>> [   62.231250] PCI: Setting latency timer of device 0000:01:00.0 to 64
>> [   62.231430] eth0: RTL8168b/8111b at 0xffffc2000016c000, 00:19:66:47:f3:cb, 
>> IRQ 19
>> [   62.284221] HPT366: IDE controller at PCI slot 0000:02:0a.0
>> [   62.284491] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 18
>> [   62.284499] ACPI: PCI Interrupt 0000:02:0a.0[A] -> Link [LNKC] -> GSI 18 
>> (level, low) -> IRQ 18
>> [   62.284508] HPT366: chipset revision 1
>> [   62.284514] HPT366: using 33 MHz PCI clock
>> [   62.284516] HPT366: 100% native mode on irq 18
>> [   62.284524]     ide1: BM-DMA at 0xd000-0xd007, BIOS settings: hdc:pio, 
>> hdd:pio
>> [   62.284536] ACPI: PCI Interrupt 0000:02:0a.1[A] -> Link [LNKC] -> GSI 18 
>> (level, low) -> IRQ 18
>> [   62.284544] HPT366: using 33 MHz PCI clock
>> [   62.284546] HPT366: too many IDE interfaces, no room in table
>> [   62.284548] HPT366: neither IDE port enabled (BIOS)
>> [   62.284551] Probing IDE interface ide1...
>> [   62.988343] hdc: _NEC DVD_RW ND-3500AG, ATAPI CD/DVD-ROM drive
>> [   63.630192] ide1 at 0xd480-0xd487,0xd402 on irq 18
>> [   63.632589] hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
>> [   63.632594] Uniform CD-ROM driver Revision: 3.20
>> [   64.048482] reiser4: sda5: found disk format 4.0.0.
>> [   69.431516] reiser4: sda6: found disk format 4.0.0.
>> [   70.722395] reiser4: hda7: found disk format 4.0.0.
>> [   71.428725] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 
>> across:1951888k
>> [   74.227887] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
>> [   74.227897] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 17 
>> (level, low) -> IRQ 17
>> [   74.230613] Audigy2 value: Special config.
>> [   78.048887] r8169: eth0: link up
>> [   78.049039] r8169: eth0: link up
>> [   82.597555] nvidia: module license 'NVIDIA' taints kernel.
>> [   82.767839] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 16
>> [   82.767847] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 16 
>> (level, low) -> IRQ 16
>> [   82.767853] PCI: Setting latency timer of device 0000:04:00.0 to 64
>> [   82.767943] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.23  Thu 
>> Oct  4 10:27:34 PDT 2007
>>
>> Glück Auf,
>> Volker
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
tejun

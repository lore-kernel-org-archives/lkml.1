Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbXFDPmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbXFDPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbXFDPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:42:13 -0400
Received: from spatial.ca ([66.11.172.77]:13046 "EHLO fawkes.spatial.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753908AbXFDPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:42:11 -0400
Message-ID: <46642C60.209@spatial.ca>
Date: Mon, 04 Jun 2007 11:14:40 -0400
From: Tom Moore <tmoore@spatial.ca>
Reply-To: tmoore@spatial.ca
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 4Gb ram not showing up
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Sanitizer: Advosys mail filter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone.

I am having some difficulty trying to get my 4Gb of ram recognized by 
the system.  I have tried googling around to get some information on how 
to do this configuration, but I have come up dry.  I suspect that the 
reason that there is not much info on how to set things up is because 
usually it just works.  However, on my system I don't think it is.

By the way, I am not subscribed to this mailing list, so could you 
please CC me any replies.

The basics are that I have an Athlon 64 X2 Dual core, 4Gb ram, ASUS 
M2N-MX motherboard.  The bios has a configuration item for MTRR mapping, 
with options for CONTINUOUS and DISCRETE.  I have selected CONTINUOUS, 
which explicitly describes the PCI hole as non-cacheable.  The other 
option leaves the PCI hole undescribed.

My config has selected
CONFIG_HIGHMEM4G=y

free -m reports the following....
             total       used       free     shared    buffers     cached
Mem:          2906       2794        112          0        275         31
-/+ buffers/cache:       2487        419
Swap:         4996        366       4630


/proc/mtrr contains the following....

reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1


Relevant bootup messages include these....
Jun  3 13:50:52 fawkes Linux version 2.6.20-gentoo-r8 (root@fawkes) (gcc 
version 4.1.1 (Gentoo 4.1.1-r3)) #6 SMP Tue May 15 10:18:59 EDT 2007
Jun  3 13:50:52 fawkes BIOS-provided physical RAM map:
Jun  3 13:50:52 fawkes sanitize start
Jun  3 13:50:52 fawkes sanitize end
Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000000000000 size: 
000000000009fc00 end: 000000000009fc00 type: 1
Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
Jun  3 13:50:52 fawkes copy_e820_map() start: 000000000009fc00 size: 
0000000000000400 end: 00000000000a0000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000000e0000 size: 
0000000000020000 end: 0000000000100000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000000100000 size: 
00000000b7ec0000 end: 00000000b7fc0000 type: 1
Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7fc0000 size: 
000000000000e000 end: 00000000b7fce000 type: 3
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7fce000 size: 
0000000000022000 end: 00000000b7ff0000 type: 4
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000b7ff0000 size: 
0000000000010000 end: 00000000b8000000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000fec00000 size: 
0000000000001000 end: 00000000fec01000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000fee00000 size: 
0000000000100000 end: 00000000fef00000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 00000000ff780000 size: 
0000000000880000 end: 0000000100000000 type: 2
Jun  3 13:50:52 fawkes copy_e820_map() start: 0000000100000000 size: 
0000000040000000 end: 0000000140000000 type: 1
Jun  3 13:50:52 fawkes copy_e820_map() type is E820_RAM
Jun  3 13:50:52 fawkes BIOS-e820: 0000000000000000 - 000000000009fc00 
(usable)
Jun  3 13:50:52 fawkes BIOS-e820: 000000000009fc00 - 00000000000a0000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000000e0000 - 0000000000100000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 0000000000100000 - 00000000b7fc0000 
(usable)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7fc0000 - 00000000b7fce000 
(ACPI data)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7fce000 - 00000000b7ff0000 
(ACPI NVS)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000b7ff0000 - 00000000b8000000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000fec00000 - 00000000fec01000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000fee00000 - 00000000fef00000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 00000000ff780000 - 0000000100000000 
(reserved)
Jun  3 13:50:52 fawkes BIOS-e820: 0000000100000000 - 0000000140000000 
(usable)
Jun  3 13:50:52 fawkes Warning only 4GB will be used.
Jun  3 13:50:52 fawkes Use a PAE enabled kernel.
Jun  3 13:50:52 fawkes 3200MB HIGHMEM available.
Jun  3 13:50:52 fawkes 896MB LOWMEM available.
Jun  3 13:50:52 fawkes found SMP MP-table at 000ff780
Jun  3 13:50:52 fawkes Entering add_active_range(0, 0, 1048576) 0 
entries of 256 used
Jun  3 13:50:52 fawkes Zone PFN ranges:
Jun  3 13:50:52 fawkes DMA             0 ->     4096
Jun  3 13:50:52 fawkes Normal       4096 ->   229376
Jun  3 13:50:52 fawkes HighMem    229376 ->  1048576
Jun  3 13:50:52 fawkes early_node_map[1] active PFN ranges
Jun  3 13:50:52 fawkes 0:        0 ->  1048576
Jun  3 13:50:52 fawkes On node 0 totalpages: 1048576
Jun  3 13:50:52 fawkes DMA zone: 32 pages used for memmap
Jun  3 13:50:52 fawkes DMA zone: 0 pages reserved
Jun  3 13:50:52 fawkes DMA zone: 4064 pages, LIFO batch:0
Jun  3 13:50:52 fawkes Normal zone: 1760 pages used for memmap
Jun  3 13:50:52 fawkes Normal zone: 223520 pages, LIFO batch:31
Jun  3 13:50:52 fawkes HighMem zone: 6400 pages used for memmap
Jun  3 13:50:52 fawkes HighMem zone: 812800 pages, LIFO batch:31
Jun  3 13:50:52 fawkes DMI 2.3 present.
Jun  3 13:50:52 fawkes Using APIC driver default
Jun  3 13:50:52 fawkes ACPI: RSDP (v002 
ACPIAM                                ) @ 0x000fbab0
Jun  3 13:50:52 fawkes ACPI: XSDT (v001 A M I  OEMXSDT  0x09000606 MSFT 
0x00000097) @ 0xb7fc0100
Jun  3 13:50:52 fawkes ACPI: FADT (v003 A M I  OEMFACP  0x09000606 MSFT 
0x00000097) @ 0xb7fc0290
Jun  3 13:50:52 fawkes ACPI: MADT (v001 A M I  OEMAPIC  0x09000606 MSFT 
0x00000097) @ 0xb7fc0390
Jun  3 13:50:52 fawkes ACPI: MCFG (v001 A M I  OEMMCFG  0x09000606 MSFT 
0x00000097) @ 0xb7fc0400
Jun  3 13:50:52 fawkes ACPI: OEMB (v001 A M I  AMI_OEM  0x09000606 MSFT 
0x00000097) @ 0xb7fce040
Jun  3 13:50:52 fawkes ACPI: SSDT (v001 A M I  POWERNOW 0x00000001 AMD  
0x00000001) @ 0xb7fc5300
Jun  3 13:50:52 fawkes ACPI: DSDT (v001  A0557 A0557000 0x00000000 INTL 
0x02002026) @ 0x00000000
Jun  3 13:50:52 fawkes Nvidia board detected. Ignoring ACPI timer override.
Jun  3 13:50:52 fawkes If you got timer trouble try acpi_use_timer_override
Jun  3 13:50:52 fawkes Nvidia board detected. Ignoring ACPI timer override.
Jun  3 13:50:52 fawkes If you got timer trouble try acpi_use_timer_override
Jun  3 13:50:52 fawkes Nvidia board detected. Ignoring ACPI timer override.
Jun  3 13:50:52 fawkes If you got timer trouble try acpi_use_timer_override
Jun  3 13:50:52 fawkes Nvidia board detected. Ignoring ACPI timer override.
Jun  3 13:50:52 fawkes If you got timer trouble try acpi_use_timer_override
Jun  3 13:50:52 fawkes ACPI: PM-Timer IO Port: 0x508
Jun  3 13:50:52 fawkes ACPI: Local APIC address 0xfee00000
Jun  3 13:50:52 fawkes ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jun  3 13:50:52 fawkes Processor #0 15:11 APIC version 16
Jun  3 13:50:52 fawkes ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jun  3 13:50:52 fawkes Processor #1 15:11 APIC version 16
Jun  3 13:50:52 fawkes ACPI: IOAPIC (id[0x02] address[0xfec00000] 
gsi_base[0])
Jun  3 13:50:52 fawkes IOAPIC[0]: apic_id 2, version 17, address 
0xfec00000, GSI 0-23
Jun  3 13:50:52 fawkes ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 0 
dfl dfl)
Jun  3 13:50:52 fawkes ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 
high level)
Jun  3 13:50:52 fawkes ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 
high edge)
Jun  3 13:50:52 fawkes ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 
high edge)
Jun  3 13:50:52 fawkes ACPI: IRQ0 used by override.
Jun  3 13:50:52 fawkes ACPI: IRQ9 used by override.
Jun  3 13:50:52 fawkes ACPI: IRQ14 used by override.
Jun  3 13:50:52 fawkes ACPI: IRQ15 used by override.
Jun  3 13:50:52 fawkes Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jun  3 13:50:52 fawkes Using ACPI (MADT) for SMP configuration information
Jun  3 13:50:52 fawkes Allocating PCI resources starting at c0000000 
(gap: b8000000:46c00000)
Jun  3 13:50:52 fawkes Detected 2009.188 MHz processor.
Jun  3 13:50:52 fawkes Built 1 zonelists.  Total pages: 1040384
Jun  3 13:50:52 fawkes Kernel command line: root=/dev/sda2
Jun  3 13:50:52 fawkes mapped APIC to ffffd000 (fee00000)
Jun  3 13:50:52 fawkes mapped IOAPIC to ffffc000 (fec00000)
Jun  3 13:50:52 fawkes Enabling fast FPU save and restore... done.
Jun  3 13:50:52 fawkes Enabling unmasked SIMD FPU exception support... done.
Jun  3 13:50:52 fawkes Initializing CPU#0
Jun  3 13:50:52 fawkes PID hash table entries: 4096 (order: 12, 16384 bytes)
Jun  3 13:50:52 fawkes spurious 8259A interrupt: IRQ7.
Jun  3 13:50:52 fawkes Console: colour VGA+ 80x25
Jun  3 13:50:52 fawkes Dentry cache hash table entries: 131072 (order: 
7, 524288 bytes)
Jun  3 13:50:52 fawkes Inode-cache hash table entries: 65536 (order: 6, 
262144 bytes)
Jun  3 13:50:52 fawkes Memory: 2975372k/4194304k available (2686k kernel 
code, 37964k reserved, 935k data, 272k init, 2096896k highmem)
Jun  3 13:50:52 fawkes virtual kernel memory layout:
Jun  3 13:50:52 fawkes fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
Jun  3 13:50:52 fawkes pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jun  3 13:50:52 fawkes vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
Jun  3 13:50:52 fawkes lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
Jun  3 13:50:52 fawkes .init : 0xc0491000 - 0xc04d5000   ( 272 kB)
Jun  3 13:50:52 fawkes .data : 0xc039fa7d - 0xc0489a18   ( 935 kB)
Jun  3 13:50:52 fawkes .text : 0xc0100000 - 0xc039fa7d   (2686 kB)

Any suggestions as to what I can try to get all 4Gb of ram to show up?

Thanks,

Tom


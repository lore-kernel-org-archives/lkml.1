Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYLVSxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYLVSxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYLVSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:52:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:49036 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYLVSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SfT479fJhlo571iOmtdQXh3CWpSi9C+HjgC3BgT0C66EUGVBOjLhdN7MmBOObJDT2y
         Iy6E7R1iLjSedxEfNXXOyadieZBkC9M/hxu04yVodYwlMdD3c/UtvVGDBeIwezyE3GI0
         fWVlvbsThqp3tozV7/p4hQC+BR41J3L7NgxD4=
Message-ID: <f4527be0812221052g1ef31f7eyc4a6e0fd7ef8c176@mail.gmail.com>
Date: Mon, 22 Dec 2008 18:52:43 +0000
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Help interpreting AHCI failure messages
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Robert Hancock" <hancockr@shaw.ca>, "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Gerd Hoffmann" <kraxel@redhat.com>
In-Reply-To: <494F63F1.3020207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4942D651.1050306@goop.org> <4943317C.8000807@shaw.ca>
	 <49434EC9.4070408@goop.org> <49446DD0.3030600@gmail.com>
	 <494BCC08.4070206@goop.org> <494F11FD.1040606@gmail.com>
	 <f4527be0812220117v6fcc72c6v8012247ec443f636@mail.gmail.com>
	 <494F63F1.3020207@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 9:54 AM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Andrew Lyon wrote:
>>>>>> Furthermore, ata2 - which is sharing the same interrupt - seems to have
>>>>>> managed to read the DVD drive's information, so something must be
>>>>>> working.  But why is it failing for the disk?
>>>>> Can you try irqpoll on it?
>>>> Here's a log of a run where everything works initially, but then it
>>>> starts to fail (about half way into the log).  ATA_DEBUG is enabled, so
>>>> its pretty verbose.
>>>>
>>>> http://kraxel.fedorapeople.org/for-jeremy/xeni.log
>>>>
>>>> Does anything stand out?
>>> Can you please exclude pata_acpi from the initrd and see whether
>>> anything changes?
>>
>> I have already tried using a kernel with pata_acpi disabled, it does not help.
>
> There's a BUG messages in the log and several IRQ enable/disable
> messages && once timeout happens on one of the ata port, the other one
> begins to time out too.  I'm out of ideas and think this really needs
> a look from someone who knows xen.  It doesn't seem to be a libata
> problem at this point.
>
> Thanks.
>
> --
> tejun
>

I agree that it is a Xen issue, otherwise I doubt that the kernel
would work correctly on the bare metal (which it does), to help
investigate I decided to try putting the root fs on a usb memory stick
so that I could get to a console and check /proc/interrupts to make
sure they are being delivered, but the kernel does not detect my usb
memory stick,  and like the sata it does work when booted on the bare
metal:

here is dmesg of the kernel on xen:

 __  __            _____  _____  ___
 \ \/ /___ _ __   |___ / |___ / / _ \
  \  // _ \ '_ \    |_ \   |_ \| | | |
  /  \  __/ | | |  ___) | ___) | |_| |
 /_/\_\___|_| |_| |____(_)____(_)___/

(XEN) Xen version 3.3.0 (root@) (gcc version 4.1.2 (Gentoo 4.1.2
p1.0.2)) Thu Dec 11 11:52:12 GMT 2008
(XEN) Latest ChangeSet: unavailable
(XEN) Command line: com1=115200,8n1 console=com1,vga mem=3G dom0_mem=512M
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: V2; EDID transfer time: 1 seconds
(XEN) Disc information:
(XEN)  Found 2 MBR signatures
(XEN)  Found 2 EDD information structures
(XEN) Truncating memory map to 3145728kB
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009ec00 (usable)
(XEN)  00000000000f0000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000c0000000 (usable)
(XEN) System RAM: 3071MB (3145336kB)
(XEN) ACPI: RSDP 000FEC00, 0024 (r2 DELL  )
(XEN) ACPI: XSDT 000FC5B3, 008C (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: FACP 000FC6E3, 00F4 (r3 DELL    B9K           15 ASL        61)
(XEN) ACPI: DSDT FFF76BF6, 4596 (r1   DELL    dt_ex     1000 INTL 20050624)
(XEN) ACPI: FACS CFDFF800, 0040
(XEN) ACPI: SSDT FFF7B2AB, 00AA (r1   DELL    st_ex     1000 INTL 20050624)
(XEN) ACPI: APIC 000FC7D7, 0092 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: BOOT 000FC869, 0028 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: ASF! 000FC891, 0096 (r32 DELL    B9K           15 ASL        61)
(XEN) ACPI: MCFG 000FC927, 003E (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: HPET 000FC965, 0038 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: TCPA 000FCBC1, 0032 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: DMAR 000FCBF3, 00D0 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: SLIC 000FC99D, 0176 (r1 DELL    B9K           15 ASL        61)
(XEN) ACPI: SSDT CFDFF840, 01F9 (r1 DpgPmm  Cpu0Ist       11 INTL 20050624)
(XEN) ACPI: SSDT CFDFFC49, 01F9 (r1 DpgPmm  Cpu1Ist       11 INTL 20050624)
(XEN) ACPI: SSDT CFE00052, 0140 (r1 DpgPmm    CpuPm       10 INTL 20050624)
(XEN) Xen heap: 14MB (14684kB)
(XEN) Domain heap initialised
(XEN) Processor #0 6:15 APIC version 20
(XEN) Processor #1 6:15 APIC version 20
(XEN) IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
(XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2394.041 MHz processor.
(XEN) HVM: VMX enabled
(XEN) CPU0: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
(XEN) Booting processor 1/1 eip 8c000
(XEN) CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
(XEN) Total of 2 processors activated.
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) checking TSC synchronization across 2 CPUs: passed.
(XEN) Platform timer is 14.318MHz HPET
(XEN) Brought up 2 CPUs
(XEN) I/O virtualisation disabled
(XEN) *** LOADING DOMAIN 0 ***
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x200000 -> 0x8a0518
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   00000000ba000000->00000000bb000000 (126976 pages
to be allocated)
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff80200000->ffffffff808a0518
(XEN)  Init. ramdisk: ffffffff808a1000->ffffffff808a1000
(XEN)  Phys-Mach map: ffffffff808a1000->ffffffff809a1000
(XEN)  Start info:    ffffffff809a1000->ffffffff809a14a4
(XEN)  Page tables:   ffffffff809a2000->ffffffff809ab000
(XEN)  Boot stack:    ffffffff809ab000->ffffffff809ac000
(XEN)  TOTAL:         ffffffff80000000->ffffffff80c00000
(XEN)  ENTRY ADDRESS: ffffffff80765200
(XEN) Dom0 has maximum 2 VCPUs
(XEN) Scrubbing Free RAM: .........................done.
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: Errors and warnings
(XEN) Guest Loglevel: Nothing (Rate-limited: Errors and warnings)
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch
input to Xen)
(XEN) Freed 108kB init memory.
mapping kernel into physical memory
Xen: setup ISA identity maps
about to get started...
(XEN) ioapic_guest_write: apic=0, pin=2, old_irq=0, new_irq=-1
(XEN) ioapic_guest_write: old_entry=000009f0, new_entry=00010900
(XEN) ioapic_guest_write: Attempt to remove IO-APIC pin of in-use IRQ!
(XEN) ioapic_guest_write: apic=0, pin=4, old_irq=4, new_irq=-1
(XEN) ioapic_guest_write: old_entry=000009f1, new_entry=00010900
(XEN) ioapic_guest_write: Attempt to remove IO-APIC pin of in-use IRQ!
Linux version 2.6.28-rc8-tip (root@localhost) (gcc version 4.1.2
(Gentoo 4.1.2 p1.0.2)) #2 SMP Sat Dec 20 14:12:15 GMT 2008
Command line: root=/dev/sdb2 console=hvc0 earlyprink=xen pci=nomsi panic=5
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 Xen: 0000000000000000 - 000000000009ec00 (usable)
 Xen: 00000000000a0000 - 0000000000100000 (reserved)
 Xen: 0000000000100000 - 00000000008a1000 (usable)
 Xen: 00000000008a1000 - 00000000009a2000 (reserved)
 Xen: 00000000009a2000 - 0000000020000000 (usable)
DMI 2.5 present.
last_pfn = 0x20000 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-0000000020000000
last_map_addr: 20000000 end: 20000000
ACPI: RSDP 000FEC00, 0024 (r2 DELL  )
ACPI: XSDT 000FC5B3, 008C (r1 DELL    B9K           15 ASL        61)
ACPI: FACP 000FC6E3, 00F4 (r3 DELL    B9K           15 ASL        61)
ACPI: DSDT FFF76BF6, 4596 (r1   DELL    dt_ex     1000 INTL 20050624)
ACPI: FACS CFDFF800, 0040
ACPI: SSDT FFF7B2AB, 00AA (r1   DELL    st_ex     1000 INTL 20050624)
ACPI: APIC 000FC7D7, 0092 (r1 DELL    B9K           15 ASL        61)
ACPI: BOOT 000FC869, 0028 (r1 DELL    B9K           15 ASL        61)
ACPI: ASF! 000FC891, 0096 (r32 DELL    B9K           15 ASL        61)
ACPI: MCFG 000FC927, 003E (r1 DELL    B9K           15 ASL        61)
ACPI: HPET 000FC965, 0038 (r1 DELL    B9K           15 ASL        61)
ACPI: TCPA 000FCBC1, 0032 (r1 DELL    B9K           15 ASL        61)
ACPI: DMAR 000FCBF3, 00D0 (r1 DELL    B9K           15 ASL        61)
ACPI: SLIC 000FC99D, 0176 (r1 DELL    B9K           15 ASL        61)
ACPI: SSDT CFDFF840, 01F9 (r1 DpgPmm  Cpu0Ist       11 INTL 20050624)
ACPI: SSDT CFDFFC49, 01F9 (r1 DpgPmm  Cpu1Ist       11 INTL 20050624)
ACPI: SSDT CFE00052, 0140 (r1 DpgPmm    CpuPm       10 INTL 20050624)
(5 early reservations) ==> bootmem [0000000000 - 0020000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [00009a2000 - 00009ab000]   XEN PAGETABLES ==> [00009a2000 - 00009ab000]
  #2 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #3 [0000200000 - 00008a0518]    TEXT DATA BSS ==> [0000200000 - 00008a0518]
  #4 [00009ab000 - 0000aa1000]          PGTABLE ==> [00009ab000 - 0000aa1000]
found SMP MP-table at [ffff8800000fe710] 000fe710
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009e
    0: 0x00000100 -> 0x000008a1
    0: 0x000009a2 -> 0x00020000
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 57344 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 126969
Kernel command line: root=/dev/sdb2 console=hvc0 earlyprink=xen
pci=nomsi panic=5
Initializing CPU#0
xen: allocated irq 9 for acpi 9
PID hash table entries: 2048 (order: 11, 16384 bytes)
Detected 2394.040 MHz processor.
Console: colour VGA+ 80x25
console [hvc0] enabled
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880001808000 - ffff880005808000
software IO TLB at phys 0x1808000 - 0x5808000
Memory: 440536k/524288k available (3390k kernel code, 1420k absent,
81988k reserved, 1896k data, 452k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
installing Xen timer for CPU 0
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4788.08 BogoMIPS (lpj=2394040)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20080926
cpu 0 spinlock event irq 17
installing Xen timer for CPU 1
cpu 1 spinlock event irq 23
SMP alternatives: switching to SMP code
Initializing CPU#1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Brought up 2 CPUs
khelper used greatest stack depth: 6800 bytes left
net_namespace: 592 bytes
Booting paravirtualized kernel on Xen
Xen version: 3.3.0 (preserve-AD) (dom0)
Grant table initialized
Time: 17:18:35  Date: 12/22/08
NET: Registered protocol family 16
xenbus_probe_init ok
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
khelper used greatest stack depth: 6448 bytes left
khelper used greatest stack depth: 6232 bytes left
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI
motherboard resources
PCI: Not using MMCONFIG.
ACPI: ACPI Dock Station Driver: 1 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:03:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:02.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [TCPA] - 00,
should be 87 [20080926]
xen_balloon: Initialising balloon driver.
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
Xen: Initializing Xen DMA ops
Xen: Enabling DMA fallback to swiotlb
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: io resource (0x800-0x85f) overlaps 0000:00:1f.0 BAR 7
(0x800-0x87f), disabling
pnp 00:01: io resource (0x860-0x8ff) overlaps 0000:00:1f.0 BAR 7
(0x800-0x87f), disabling
xen_set_ioapic_routing: irq 13 gsi 13 vector 120 ioapic 0 pin 13
triggering 1 polarity 0
xen_set_ioapic_routing: irq 8 gsi 8 vector 80 ioapic 0 pin 8
triggering 1 polarity 0
xen_set_ioapic_routing: irq 7 gsi 7 vector 72 ioapic 0 pin 7
triggering 1 polarity 0
xen_set_ioapic_routing: irq 4 gsi 4 vector 241 ioapic 0 pin 4
triggering 1 polarity 0
(XEN) ioapic_guest_write: apic=0, pin=4, old_irq=4, new_irq=4
(XEN) ioapic_guest_write: old_entry=000009f1, new_entry=000189f1
(XEN) ioapic_guest_write: Attempt to modify IO-APIC pin for in-use IRQ!
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0xc00-0xc7f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0xfe900000-0xfeafffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xfe800000-0xfe8fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfe600000-0xfe7fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000030000000-0x000000300fffff
xen_set_ioapic_routing: irq 29 gsi 16 vector 152 ioapic 0 pin 16
triggering 0 polarity 1
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 29
xen: PCI device 0000:00:01.0 pin 1 -> irq 29
xen_allocate_pirq: returning irq 29 for gsi 16
xen_set_ioapic_routing: irq 29 gsi 16 vector 152 ioapic 0 pin 16
triggering 0 polarity 1
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 29
xen: PCI device 0000:00:1c.0 pin 1 -> irq 29
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xfe900000-0xfeafffff]
bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 mmio: [0x0-0x0]
bus: 02 index 1 mmio: [0xfe800000-0xfe8fffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xc000-0xcfff]
bus: 03 index 1 mmio: [0xfe600000-0xfe7fffff]
bus: 03 index 2 mmio: [0x30000000-0x300fffff]
bus: 03 index 3 io port: [0x00-0xffff]
bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1229966316.804:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 1024
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport-driver 0000:00:01.0: found MSI capability
pcieport-driver 0000:00:1c.0: found MSI capability
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [VBTN]
xenbus_probe_backend_init bus registered ok
xenbus_probe_frontend_init bus registered ok
Event-channel device installed.
***blkif_init
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
brd: module loaded
loop: module loaded
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Loading iSCSI transport class v2.0-870.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
xen_set_ioapic_routing: irq 31 gsi 18 vector 160 ioapic 0 pin 18
triggering 0 polarity 1
ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 31
xen: PCI device 0000:00:1f.2 pin 3 -> irq 31
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x27 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970100 irq 31
ata2: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970180 irq 31
ata3: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970200 irq 31
ata4: DUMMY
ata5: DUMMY
ata6: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970380 irq 31
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-H73N, B103, max UDMA/100
ata2.00: configured for UDMA/100
ata3: SATA link down (SStatus 4 SControl 300)
ata6: SATA link down (SStatus 4 SControl 300)
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H73N B103 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi generic sg0 type 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
xen_set_ioapic_routing: irq 32 gsi 22 vector 168 ioapic 0 pin 22
triggering 0 polarity 1
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 32
xen: PCI device 0000:00:1a.7 pin 3 -> irq 32
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: irq 32, io mem 0xfebd9c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc8-tip ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
xen_set_ioapic_routing: irq 33 gsi 23 vector 176 ioapic 0 pin 23
triggering 0 polarity 1
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 33
xen: PCI device 0000:00:1d.7 pin 1 -> irq 33
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 33, io mem 0xff980800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc8-tip ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
xen_allocate_pirq: returning irq 29 for gsi 16
xen_set_ioapic_routing: irq 29 gsi 16 vector 152 ioapic 0 pin 16
triggering 0 polarity 1
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 29
xen: PCI device 0000:00:1a.0 pin 1 -> irq 29
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: irq 29, io base 0x0000ff20
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
xen_set_ioapic_routing: irq 34 gsi 17 vector 184 ioapic 0 pin 17
triggering 0 polarity 1
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 34
xen: PCI device 0000:00:1a.1 pin 2 -> irq 34
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: irq 34, io base 0x0000ff00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
xen_allocate_pirq: returning irq 33 for gsi 23
xen_set_ioapic_routing: irq 33 gsi 23 vector 176 ioapic 0 pin 23
triggering 0 polarity 1
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 33
xen: PCI device 0000:00:1d.0 pin 1 -> irq 33
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: irq 33, io base 0x0000ff80
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
xen_allocate_pirq: returning irq 34 for gsi 17
xen_set_ioapic_routing: irq 34 gsi 17 vector 184 ioapic 0 pin 17
triggering 0 polarity 1
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 34
xen: PCI device 0000:00:1d.1 pin 2 -> irq 34
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: irq 34, io base 0x0000ff60
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
xen_allocate_pirq: returning irq 31 for gsi 18
xen_set_ioapic_routing: irq 31 gsi 18 vector 160 ioapic 0 pin 18
triggering 0 polarity 1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 31
xen: PCI device 0000:00:1d.2 pin 3 -> irq 31
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: irq 31, io base 0x0000ff40
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
i8042: probe of i8042 failed with error -38
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
IO APIC resources could be not be allocated.
registered taskstats version 1
  Magic number: 4:764:340
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
Root-NFS: No NFS server available, giving up.
VFS: Unable to mount root fs via NFS, trying floppy.
VFS: Cannot open root device "sdb2" or unknown-block(2,0)
Please append a correct "root=" boot option; here are the available partitions:
0b00         1048575 sr0 driver: sr
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(2,0)
Pid: 1, comm: swapper Not tainted 2.6.28-rc8-tip #2
Call Trace:
 [<ffffffff8023bf7b>] panic+0xa0/0x162
 [<ffffffff804081a7>] ? class_dev_iter_exit+0x9/0xb
 [<ffffffff802b3561>] ? sys_mount+0xb9/0xce
 [<ffffffff80766177>] mount_block_root+0x1c0/0x1dc
 [<ffffffff8076625c>] mount_root+0xc9/0xea
 [<ffffffff807663f7>] prepare_namespace+0x17a/0x1a7
 [<ffffffff80765988>] kernel_init+0x167/0x175
 [<ffffffff802133fa>] child_rip+0xa/0x20
 [<ffffffff80212ced>] ? retint_restore_args+0x5/0x20
 [<ffffffff802133f0>] ? child_rip+0x0/0x20
Rebooting in 5 seconds..<7>usb usb6: suspend_rh (auto-stop)
(XEN) Domain 0 shutdown: rebooting machine.

and here on the bare metal, notice the usb memory stick is detected as sdb:


Linux version 2.6.28-rc8-tip (root@localhost) (gcc version 4.1.2
(Gentoo 4.1.2 p1.0.2)) #2 SMP Sat Dec 20 14:12:15 GMT 2008
Command line: root=/dev/sda2 panic=5
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfdff800 (usable)
 BIOS-e820: 00000000cfdff800 - 00000000cfe53c00 (ACPI NVS)
 BIOS-e820: 00000000cfe53c00 - 00000000cfe55c00 (ACPI data)
 BIOS-e820: 00000000cfe55c00 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000128000000 (usable)
DMI 2.5 present.
last_pfn = 0x128000 max_arch_pfn = 0x100000000
last_pfn = 0xcfdff max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000cfdff000
 0000000000 - 00cfc00000 page 2M
 00cfc00000 - 00cfdff000 page 4k
kernel direct mapping tables up to cfdff000 @ 8000-e000
last_map_addr: cfdff000 end: cfdff000
init_memory_mapping: 0000000100000000-0000000128000000
 0100000000 - 0128000000 page 2M
kernel direct mapping tables up to 128000000 @ c000-12000
last_map_addr: 128000000 end: 128000000
ACPI: RSDP 000FEC00, 0024 (r2 DELL  )
ACPI: XSDT 000FC5B3, 008C (r1 DELL    B9K           15 ASL        61)
ACPI: FACP 000FC6E3, 00F4 (r3 DELL    B9K           15 ASL        61)
ACPI: DSDT FFF76BF6, 4596 (r1   DELL    dt_ex     1000 INTL 20050624)
ACPI: FACS CFDFF800, 0040
ACPI: SSDT FFF7B2AB, 00AA (r1   DELL    st_ex     1000 INTL 20050624)
ACPI: APIC 000FC7D7, 0092 (r1 DELL    B9K           15 ASL        61)
ACPI: BOOT 000FC869, 0028 (r1 DELL    B9K           15 ASL        61)
ACPI: ASF! 000FC891, 0096 (r32 DELL    B9K           15 ASL        61)
ACPI: MCFG 000FC927, 003E (r1 DELL    B9K           15 ASL        61)
ACPI: HPET 000FC965, 0038 (r1 DELL    B9K           15 ASL        61)
ACPI: TCPA 000FCBC1, 0032 (r1 DELL    B9K           15 ASL        61)
ACPI: DMAR 000FCBF3, 00D0 (r1 DELL    B9K           15 ASL        61)
ACPI: SLIC 000FC99D, 0176 (r1 DELL    B9K           15 ASL        61)
ACPI: SSDT CFDFF840, 01F9 (r1 DpgPmm  Cpu0Ist       11 INTL 20050624)
ACPI: SSDT CFDFFC49, 01F9 (r1 DpgPmm  Cpu1Ist       11 INTL 20050624)
ACPI: SSDT CFE00052, 0140 (r1 DpgPmm    CpuPm       10 INTL 20050624)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 0128000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00008a0518]    TEXT DATA BSS ==> [0000200000 - 00008a0518]
  #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
  #4 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #5 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
found SMP MP-table at [ffff8800000fe710] 000fe710
 [ffffe20000000000-ffffe200041fffff] PMD ->
[ffff880028200000-ffff88002c3fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00128000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009e
    0: 0x00000100 -> 0x000cfdff
    0: 0x00100000 -> 0x00128000
On node 0 totalpages: 1015197
  DMA zone: 56 pages used for memmap
  DMA zone: 1803 pages reserved
  DMA zone: 2139 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833079 pages, LIFO batch:31
  Normal zone: 2240 pages used for memmap
  Normal zone: 161600 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
8 Processors exceeds NR_CPUS limit of 4
SMP: Allowing 4 CPUs, 2 hotplug CPUs
Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Allocating 57344 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 996818
Kernel command line: root=/dev/sda2 panic=5
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2393.735 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 3912900k/4849664k available (3390k kernel code, 788876k
absent, 146992k reserved, 1896k data, 452k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4787.47 BogoMIPS (lpj=2393735)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using core 2 configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Intel Performance Monitoring support detected.
... version:      2
... num_counters: 2
... bit_width:    40
... mask_length:  7
ACPI: Core revision 20080926
Setting APIC routing to flat
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4787.77 BogoMIPS (lpj=2393887)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using core 2 configuration
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9575.24 BogoMIPS).
khelper used greatest stack depth: 6232 bytes left
net_namespace: 592 bytes
Booting paravirtualized kernel on bare hardware
Time: 17:21:10  Date: 12/22/08
NET: Registered protocol family 16
err -19 in xenbus_probe_init
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: ACPI Dock Station Driver: 1 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: reg 10 64bit mmio: [0xfedad000-0xfedad00f]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: reg 10 io port: [0xfe80-0xfe87]
pci 0000:00:03.2: reg 14 io port: [0xfe90-0xfe93]
pci 0000:00:03.2: reg 18 io port: [0xfea0-0xfea7]
pci 0000:00:03.2: reg 1c io port: [0xfeb0-0xfeb3]
pci 0000:00:03.2: reg 20 io port: [0xfef0-0xfeff]
pci 0000:00:03.3: reg 10 io port: [0xec98-0xec9f]
pci 0000:00:03.3: reg 14 32bit mmio: [0xfebda000-0xfebdafff]
pci 0000:00:19.0: reg 10 32bit mmio: [0xfebe0000-0xfebfffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xfebdb000-0xfebdbfff]
pci 0000:00:19.0: reg 18 io port: [0xecc0-0xecdf]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0xff20-0xff3f]
pci 0000:00:1a.1: reg 20 io port: [0xff00-0xff1f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfebd9c00-0xfebd9fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfebdc000-0xfebdffff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xff80-0xff9f]
pci 0000:00:1d.1: reg 20 io port: [0xff60-0xff7f]
pci 0000:00:1d.2: reg 20 io port: [0xff40-0xff5f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xff980800-0xff980bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
pci 0000:00:1f.2: reg 10 io port: [0xfe00-0xfe07]
pci 0000:00:1f.2: reg 14 io port: [0xfe10-0xfe13]
pci 0000:00:1f.2: reg 18 io port: [0xfe20-0xfe27]
pci 0000:00:1f.2: reg 1c io port: [0xfe30-0xfe33]
pci 0000:00:1f.2: reg 20 io port: [0xfec0-0xfedf]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xff970000-0xff9707ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfebd9b00-0xfebd9bff]
pci 0000:00:1f.3: reg 20 io port: [0xece0-0xecff]
pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:01:00.0: reg 18 64bit mmio: [0xfe9e0000-0xfe9effff]
pci 0000:01:00.0: reg 20 io port: [0xdc00-0xdcff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfea00000-0xfea1ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: reg 10 64bit mmio: [0xfe9f0000-0xfe9fffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfe900000-0xfeafffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
pci 0000:03:02.0: reg 10 32bit mmio: [0xfe6fc000-0xfe6fffff]
pci 0000:03:02.0: reg 14 io port: [0xcc00-0xccff]
pci 0000:03:02.0: reg 30 32bit mmio: [0xfe700000-0xfe71ffff]
pci 0000:03:02.0: supports D1 D2
pci 0000:03:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:02.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfe600000-0xfe7fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [TCPA] - 00,
should be 87 [20080926]
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: io resource (0x800-0x85f) overlaps 0000:00:1f.0 BAR 7
(0x800-0x87f), disabling
pnp 00:01: io resource (0x860-0x8ff) overlaps 0000:00:1f.0 BAR 7
(0x800-0x87f), disabling
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0xc00-0xc7f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0xfe900000-0xfeafffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xfe800000-0xfe8fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfe600000-0xfe7fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000f0000000-0x000000f00fffff
  alloc irq_desc for 16 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xfe900000-0xfeafffff]
bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 mmio: [0x0-0x0]
bus: 02 index 1 mmio: [0xfe800000-0xfe8fffff]
bus: 02 index 2 mmio: [0x0-0x0]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xc000-0xcfff]
bus: 03 index 1 mmio: [0xfe600000-0xfe7fffff]
bus: 03 index 2 mmio: [0xf0000000-0xf00fffff]
bus: 03 index 3 io port: [0x00-0xffff]
bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1229966471.916:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7644
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.2: Performing full reset
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
  alloc irq_desc for 24 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
  alloc irq_desc for 25 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [VBTN]
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
xenbus_probe_backend_init bus registered ok
xenbus_probe_frontend_init bus registered ok
***blkif_init
xenfs: not registering filesystem on non-xen platform
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
brd: module loaded
loop: module loaded
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Loading iSCSI transport class v2.0-870.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 18 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
  alloc irq_desc for 26 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x27 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ems
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970100 irq 26
ata2: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970180 irq 26
ata3: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970200 irq 26
ata4: DUMMY
ata5: DUMMY
ata6: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970380 irq 26
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6: WDC WD360GD-00FLA2, 31.08F31, max UDMA/133
ata1.00: 72303840 sectors, multi 0: LBA48
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI: HL-DT-ST DVD+/-RW GSA-H73N, B103, max UDMA/100
ata2.00: configured for UDMA/100
ata3: SATA link down (SStatus 4 SControl 300)
ata6: SATA link down (SStatus 4 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD360GD-00FL 31.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 72303840 512-byte hardware sectors: (37.0 GB/34.4 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 72303840 512-byte hardware sectors: (37.0 GB/34.4 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H73N B103 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
  alloc irq_desc for 22 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2
ordered !ppc ports=6
ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: reset command 000002 (park)=0 ithresh=0
period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfebd9c00
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8
period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc8-tip ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
  alloc irq_desc for 23 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2
ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 000002 (park)=0 ithresh=0
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc8-tip ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: supports USB remote wakeup
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: supports USB remote wakeup
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '006'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
usb usb6: default language 0x0409
usb usb6: uevent
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
usb 6-0:1.0: uevent
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '007'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
usb usb7: default language 0x0409
usb usb7: uevent
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
usb 7-0:1.0: uevent
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.28-rc8-tip uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
registered taskstats version 1
  Magic number: 4:317:391
hub 3-0:1.0: hash matches
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 1: status 0501 change 0001
ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2: status 0501 change 0001
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 2: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 5: status 0501 change 0001
uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
uhci_hcd 0000:00:1a.0: port 2 portsc 008a,00
uhci_hcd 0000:00:1a.1: port 2 portsc 0082,00
uhci_hcd 0000:00:1d.0: port 2 portsc 0082,00
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
uhci_hcd 0000:00:1d.2: port 1 portsc 0082,00
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
hub 1-0:1.0: state 7 ports 6 chg 0016 evt 0000
hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 2 full speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:1a.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 4 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: new high speed USB device using ehci_hcd and address 4
ehci_hcd 0000:00:1a.7: port 4 high speed
ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: default language 0x0409
usb 1-4: uevent
usb 1-4: usb_probe_device
usb 1-4: configuration #1 chosen from 1 choice
usb 1-4: adding 1-4:1.0 (config #1, interface 0)
usb 1-4:1.0: uevent
usb-storage 1-4:1.0: usb_probe_interface
usb-storage 1-4:1.0: usb_probe_interface - got id
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '004'
usb 1-4: New USB device found, idVendor=090c, idProduct=1000
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: USB DISK
usb 1-4: Manufacturer: SMI Corporation
usb 1-4: SerialNumber: AA04012800007613
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
hub 2-0:1.0: state 7 ports 6 chg 0024 evt 0000
hub 2-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 2 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
usb 2-2: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 2 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
usb 2-2: skipped 1 descriptor after endpoint
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb-storage 2-2:1.0: usb_probe_interface
usb-storage 2-2:1.0: usb_probe_interface - got id
scsi7 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '002'
usb 2-2: New USB device found, idVendor=0644, idProduct=0200
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: CA-200
usb 2-2: Manufacturer: TEAC
usb 2-2: SerialNumber: 0000030664A1
hub 2-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 2-5: new high speed USB device using ehci_hcd and address 3
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb usb6: suspend_rh (auto-stop)
usb 2-5: uevent
usb 2-5: usb_probe_device
usb 2-5: configuration #1 chosen from 1 choice
usb 2-5: adding 2-5:1.0 (config #1, interface 0)
usb 2-5:1.0: uevent
hub 2-5:1.0: usb_probe_interface
hub 2-5:1.0: usb_probe_interface - got id
hub 2-5:1.0: USB hub found
hub 2-5:1.0: 4 ports detected
hub 2-5:1.0: standalone hub
hub 2-5:1.0: individual port power switching
hub 2-5:1.0: individual port over-current protection
hub 2-5:1.0: TT per port
hub 2-5:1.0: TT requires at most 8 FS bit times (666 ns)
hub 2-5:1.0: power on to power good time: 100ms
hub 2-5:1.0: local power source is good
hub 2-5:1.0: enabling power on all ports
drivers/usb/core/inode.c: creating file '003'
usb 2-5: New USB device found, idVendor=0424, idProduct=2504
usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
usb 2-5: link qh256-0001/ffff8800cf8041e0 start 255 [1/0 us]
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb usb4: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
usb usb7: suspend_rh (auto-stop)
usb 3-1: skipped 1 descriptor after interface
usb 3-1: default language 0x0409
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
usb 3-1: New USB device found, idVendor=413c, idProduct=3016
usb 3-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
usb 3-1: Product: Dell Premium USB Optical Mouse
uhci_hcd 0000:00:1a.0: port 2 portsc 0093,00
hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: ep0 maxpacket = 8
usb 3-2: default language 0x0409
usb 3-2: uevent
usb 3-2: usb_probe_device
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: adding 3-2:1.0 (config #1, interface 0)
usb 3-2:1.0: uevent
hub 3-2:1.0: usb_probe_interface
hub 3-2:1.0: usb_probe_interface - got id
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 3 ports detected
hub 3-2:1.0: compound device; port removable status: FRR
hub 3-2:1.0: individual port power switching
hub 3-2:1.0: individual port over-current protection
hub 3-2:1.0: power on to power good time: 44ms
hub 3-2:1.0: hub controller current requirement: 100mA
hub 3-2:1.0: 100mA bus power budget for each child
hub 3-2:1.0: enabling power on all ports
drivers/usb/core/inode.c: creating file '003'
usb 3-2: New USB device found, idVendor=413c, idProduct=1003
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: Dell USB Keyboard Hub
usb 3-2: Manufacturer: Dell
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-5:1.0: state 7 ports 4 chg 0000 evt 0000
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
hub 3-2:1.0: port 1: status 0101 change 0001
uhci_hcd 0000:00:1a.0: reserve dev 3 ep81-INT, period 16, phase 8, 12 us
hub 3-2:1.0: state 7 ports 3 chg 0002 evt 0000
hub 3-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
usb 3-2.1: new full speed USB device using uhci_hcd and address 4
usb 3-2.1: ep0 maxpacket = 8
usb 3-2.1: skipped 1 descriptor after interface
usb 3-2.1: skipped 1 descriptor after interface
usb 3-2.1: default language 0x0409
usb 3-2.1: uevent
usb 3-2.1: usb_probe_device
usb 3-2.1: configuration #1 chosen from 1 choice
usb 3-2.1: adding 3-2.1:1.0 (config #1, interface 0)
usb 3-2.1:1.0: uevent
usb 3-2.1: adding 3-2.1:1.1 (config #1, interface 1)
usb 3-2.1:1.1: uevent
drivers/usb/core/inode.c: creating file '004'
usb 3-2.1: New USB device found, idVendor=413c, idProduct=2010
usb 3-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 3-2.1: Product: Dell USB Keyboard
usb 3-2.1: Manufacturer: Dell
hub 3-2:1.0: 350mA power budget left
hub 3-2:1.0: state 7 ports 3 chg 0000 evt 0002
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 7-0:1.0: hub_suspend
usb usb7: bus auto-suspend
usb usb7: suspend_rh
hub 2-5:1.0: hub_suspend
usb 2-5: unlink qh256-0001/ffff8800cf8041e0 start 255 [1/0 us]
usb 2-5: usb auto-suspend
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 452k freed
Write protecting the kernel read-only data: 4912k
khelper used greatest stack depth: 5280 bytes left
stty used greatest stack depth: 4472 bytes left
grep used greatest stack depth: 4232 bytes left
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-1: uevent
usb 3-1:1.0: uevent
usb 3-2: uevent
usb 3-2.1: uevent
usb 3-2.1:1.0: uevent
usb 3-2.1:1.1: uevent
usb 3-2:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-4: uevent
usb 1-4:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb usb6: uevent
usb 6-0:1.0: uevent
usb usb7: uevent
usb 7-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-2: uevent
usb 2-2:1.0: uevent
usb 2-5: uevent
usb 2-5:1.0: uevent
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
  alloc irq_desc for 21 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
  alloc irq_2_pin on cpu 0 node 0
e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 27 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
  alloc irq_cfg on cpu 0 node 0
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:a0:d5:4e:b9
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1041ff-0ff
scsi 6:0:0:0: Direct-Access     Easy     Disk             1100 PQ: 0 ANSI: 0 CCS
sd 6:0:0:0: [sdb] 7831552 512-byte hardware sectors: (4.00 GB/3.73 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 7831552 512-byte hardware sectors: (4.00 GB/3.73 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 sdb2
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
scsi 7:0:0:0: Direct-Access     TEAC     USB   HS-CF Card 4.08 PQ: 0 ANSI: 0
sd 7:0:0:0: [sdc] Attached SCSI removable disk
sd 7:0:0:0: Attached scsi generic sg3 type 0
usb-storage: device scan complete
EXT3 FS on sda2, internal journal
Adding 8000360k swap on /dev/sda3.  Priority:-1 extents:1 across:8000360k
ps used greatest stack depth: 4104 bytes left
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0020
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001002 POWER sig=se0 CSC
hub 2-0:1.0: port 5, status 0100, change 0001, 12 Mb/s
usb 2-5: USB disconnect, address 3
usb 2-5: unregistering device
usb 2-5: usb_disable_device nuking all URBs
usb 2-5: unregistering interface 2-5:1.0
usb 2-5:1.0: uevent
usb 2-5: uevent
hub 2-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x100

I am going to try Xen 3.3.1 rc4

Andy

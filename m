Return-Path: <linux-kernel-owner+w=401wt.eu-S965331AbXBQQsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331AbXBQQsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992453AbXBQQsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:48:05 -0500
Received: from mail.icabo.tv.br ([200.220.202.3]:33327 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965331AbXBQQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:48:01 -0500
Message-ID: <45D731A8.90604@fliagreco.com.ar>
Date: Sat, 17 Feb 2007 13:47:36 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070216)
MIME-Version: 1.0
To: Marcus Haebler <haebler@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <459A674B.3060304@fliagreco.com.ar> <459B9F91.9070908@gmail.com>	 <459BC703.9000207@fliagreco.com.ar> <459C8A5E.5010206@gmail.com>	 <459CFE7B.6090306@fliagreco.com.ar>	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com> <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
In-Reply-To: <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020202030902040308060907"
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020202030902040308060907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Marcus Haebler wrote:
> I opened a bug report (228979) on bugzilla.redhat.com on this one because
> I have the same issue under FC6 2.6.19-1.2895. Here is the link:
>
>    https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228979
>
> Do you have any more updates on this problem? Is there a way I can help
> by providing debug data?
>
> Thanks,
>
> Marcus
>
> On 1/23/07, Tejun Heo <htejun@gmail.com> wrote:
>> Pablo Sebastian Greco wrote:
>> > Well, it took me a few days,  but I think I'm ready to report back. 
>> One
>> > of the drives was failing, and it stopped after rewiring power 
>> supply so
>> > the last problem seems to be corrected.
>> > OTOH, your blacklist seems to be needed too, now I'm running FC6
>> > distribution kernel 2.6.19-1.2895.fc6 (2.6.19.2 + some patches by
>> > fedora) and setting
>> > echo 1 >/sys/block/sdX/device/queue_depth
>> > on all the SAMSUNG drives (sdb, sdc and sdd)
>> > The second I type
>> > echo 31 >/sys/block/sdX/device/queue_depth
>> > on any of the drives I get these messages
>> >
>> > Jan 23 12:36:30 squid kernel: BUG: warning: (ap->ops->error_handler &&
>> > ata_tag_valid(ap->active_tag)) at
>> > drivers/ata/libata-core.c:4602/ata_qc_issue() (Not ta
>> > inted)
>>
>> This is kernel bug that needs fixing.  I'll investigate.
>>
>> -- 
>> tejun
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>
>
On my side, all the problems dissapeared on all the kernels after 
changing all 3 drives to non-NCQ drives, I was going crazy.

New dmesg attached

Pablo.

--------------020202030902040308060907
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.19-1.2895.fc6 (brewbuilder@ls20-bc2-14.build.redhat.com) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Wed Jan 10 18:50:56 EST 2007
Command line: ro root=LABEL=/
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000df938000 (usable)
 BIOS-e820: 00000000df938000 - 00000000df9d2000 (ACPI NVS)
 BIOS-e820: 00000000df9d2000 - 00000000dfa42000 (usable)
 BIOS-e820: 00000000dfa42000 - 00000000dfa9a000 (reserved)
 BIOS-e820: 00000000dfa9a000 - 00000000dfab8000 (usable)
 BIOS-e820: 00000000dfab8000 - 00000000dfb1a000 (ACPI NVS)
 BIOS-e820: 00000000dfb1a000 - 00000000dfb2c000 (usable)
 BIOS-e820: 00000000dfb2c000 - 00000000dfb3a000 (ACPI data)
 BIOS-e820: 00000000dfb3a000 - 00000000dfc00000 (usable)
 BIOS-e820: 00000000ffc00000 - 00000000ffc0c000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 915768) 1 entries of 3200 used
Entering add_active_range(0, 915922, 916034) 2 entries of 3200 used
Entering add_active_range(0, 916122, 916152) 3 entries of 3200 used
Entering add_active_range(0, 916250, 916268) 4 entries of 3200 used
Entering add_active_range(0, 916282, 916480) 5 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 6 entries of 3200 used
end_pfn_map = 1179648
DMI 2.4 present.
ACPI: RSDP (v002 INTEL                                 ) @ 0x00000000000f0350
ACPI: XSDT (v001 INTEL  S5000VSA 0x00000000 INTL 0x01000013) @ 0x00000000dfb39120
ACPI: FADT (v003 INTEL  S5000VSA 0x00000000 INTL 0x01000013) @ 0x00000000dfb36000
ACPI: MADT (v001 INTEL  S5000VSA 0x00000000 INTL 0x01000013) @ 0x00000000dfb35000
ACPI: SPCR (v001 INTEL  S5000VSA 0x00000000 INTL 0x01000013) @ 0x00000000dfb2f000
ACPI: HPET (v001 INTEL  S5000VSA 0x00000001 INTL 0x01000013) @ 0x00000000dfb2e000
ACPI: MCFG (v001 INTEL  S5000VSA 0x00000001 INTL 0x01000013) @ 0x00000000dfb2d000
ACPI: SSDT (v002 INTEL  S5000VSA 0x00004000 INTL 0x01000013) @ 0x00000000dfb2c000
ACPI: DSDT (v002 INTEL  S5000VSA 0x00000008 INTL 0x01000013) @ 0x0000000000000000
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 915768) 1 entries of 3200 used
Entering add_active_range(0, 915922, 916034) 2 entries of 3200 used
Entering add_active_range(0, 916122, 916152) 3 entries of 3200 used
Entering add_active_range(0, 916250, 916268) 4 entries of 3200 used
Entering add_active_range(0, 916282, 916480) 5 entries of 3200 used
Entering add_active_range(0, 1048576, 1179648) 6 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000120000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1179648
early_node_map[7] active PFN ranges
    0:        0 ->      158
    0:      256 ->   915768
    0:   915922 ->   916034
    0:   916122 ->   916152
    0:   916250 ->   916268
    0:   916282 ->   916480
    0:  1048576 ->  1179648
On node 0 totalpages: 1047100
  DMA zone: 64 pages used for memmap
  DMA zone: 1450 pages reserved
  DMA zone: 2484 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 895710 pages, LIFO batch:31
  Normal zone: 2048 pages used for memmap
  Normal zone: 129024 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 000000000009f000
Nosave address range: 000000000009f000 - 0000000000100000
Nosave address range: 00000000df938000 - 00000000df9d2000
Nosave address range: 00000000dfa42000 - 00000000dfa9a000
Nosave address range: 00000000dfab8000 - 00000000dfb1a000
Nosave address range: 00000000dfb2c000 - 00000000dfb3a000
Nosave address range: 00000000dfc00000 - 00000000ffc00000
Nosave address range: 00000000ffc00000 - 00000000ffc0c000
Nosave address range: 00000000ffc0c000 - 0000000100000000
Allocating PCI resources starting at e0000000 (gap: dfc00000:20000000)
SMP: Allowing 8 CPUs, 4 hotplug CPUs
PERCPU: Allocating 43264 bytes of per cpu data
Built 1 zonelists.  Total pages: 1027218
Kernel command line: ro root=LABEL=/
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x5ed3000 - 0x9ed3000
Memory: 4032812k/4718592k available (2468k kernel code, 155588k reserved, 1934k data, 312k init)
Calibrating delay using timer specific routine.. 5324.82 BogoMIPS (lpj=2662412)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 10390972
Detected 10.390 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5320.06 BogoMIPS (lpj=2660030)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.66GHz stepping 04
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5320.20 BogoMIPS (lpj=2660104)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.66GHz stepping 04
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5320.16 BogoMIPS (lpj=2660081)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.66GHz stepping 04
Brought up 4 CPUs
time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
time.c: Detected 2660.103 MHz processor.
sizeof(vma)=176 bytes
sizeof(page)=64 bytes
sizeof(inode)=720 bytes
sizeof(dentry)=224 bytes
sizeof(ext3inode)=968 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=240 bytes
sizeof(task_struct)=1904 bytes
migration_cost=10,684
checking if image is initramfs... it is
Freeing initrd memory: 3111k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:09:0c.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIQ._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
PCI-GART: No AMD northbridge found.
pnp: 00:06: ioport range 0x500-0x53f has been reserved
pnp: 00:06: ioport range 0x400-0x47f could not be reserved
pnp: 00:06: ioport range 0x800-0x87f could not be reserved
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:02.0
  IO window: 2000-2fff
  MEM window: f8000000-f88fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.0
  IO window: 2000-2fff
  MEM window: f8000000-f88fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: 2000-2fff
  MEM window: f8000000-f89fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: f8a00000-f8afffff
  PREFETCH window: f0000000-f7ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:01.0 to 64
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:02:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.3 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:03.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1170381966.095:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 3990ACCD31A7D65A
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:01:00.0 to 64
Allocate Port Service[0000:01:00.0:pcie10]
PCI: Setting latency timer of device 0000:02:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:00.0:pcie20]
PCI: Setting latency timer of device 0000:02:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:01.0:pcie20]
PCI: Setting latency timer of device 0000:02:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:02.0:pcie20]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x4
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x5
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x6
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x7
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ 20
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x30c0-0x30c7, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI: (supports S0 S1 S4 S5)
Freeing unused kernel memory: 312k freed
Write protecting the kernel read-only data: 493k
input: AT Translated Set 2 keyboard as /class/input/input0
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x000030a0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00003080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 23, io base 0x00003060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8b00400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.00 loaded.
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports ? Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit stag led pmp 
ata1: SATA max UDMA/133 cmd 0xFFFFC2000001A100 ctl 0x0 bmdma 0x0 irq 20
ata2: SATA max UDMA/133 cmd 0xFFFFC2000001A180 ctl 0x0 bmdma 0x0 irq 20
ata3: SATA max UDMA/133 cmd 0xFFFFC2000001A200 ctl 0x0 bmdma 0x0 irq 20
ata4: SATA max UDMA/133 cmd 0xFFFFC2000001A280 ctl 0x0 bmdma 0x0 irq 20
ata5: SATA max UDMA/133 cmd 0xFFFFC2000001A300 ctl 0x0 bmdma 0x0 irq 20
ata6: SATA max UDMA/133 cmd 0xFFFFC2000001A380 ctl 0x0 bmdma 0x0 irq 20
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 
ata3.00: ata3: dev 0 multi count 0
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 
ata4.00: ata4: dev 0 multi count 0
ata4.00: configured for UDMA/133
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380211AS       3.AA PQ: 0 ANSI: 5
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6Y250M0   YAR5 PQ: 0 ANSI: 5
SCSI device sdb: 490234752 512-byte hdwr sectors (251000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 490234752 512-byte hdwr sectors (251000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6Y250M0   YAR5 PQ: 0 ANSI: 5
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2
sd 2:0:0:0: Attached scsi disk sdc
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 6Y250M0   YAR5 PQ: 0 ANSI: 5
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
SCSI device sdd: 490234752 512-byte hdwr sectors (251000 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
 sdd: sdd1 sdd2
sd 3:0:0:0: Attached scsi disk sdd
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1170381981.491:2): selinux=0 auid=4294967295
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:05:00.0 to 64
e1000: 0000:05:00.0: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:02:8d:2c
intel_rng: FWH not detected
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:05:00.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:05:00.1 to 64
e1000: 0000:05:00.1: e1000_probe: (PCI Express:2.5Gb/s:32-bit) 00:15:17:02:8d:2d
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input2
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 20 (level, low) -> IRQ 20
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
floppy0: no floppy controllers found
lp: driver loaded but no devices found
ACPI: Power Button (FF) [PWRF]
ACPI: Sleep Button (CM) [SLPB]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
ReiserFS: sdb1: using ordered data mode
ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb1: checking transaction log (sdb1)
ReiserFS: sdb1: Using r5 hash to sort names
ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
ReiserFS: sdb2: using ordered data mode
ReiserFS: sdb2: journal params: device sdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdb2: checking transaction log (sdb2)
ReiserFS: sdb2: Using r5 hash to sort names
ReiserFS: sdc1: found reiserfs format "3.6" with standard journal
ReiserFS: sdc1: using ordered data mode
ReiserFS: sdc1: journal params: device sdc1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdc1: checking transaction log (sdc1)
ReiserFS: sdc1: Using r5 hash to sort names
ReiserFS: sdc2: found reiserfs format "3.6" with standard journal
ReiserFS: sdc2: using ordered data mode
ReiserFS: sdc2: journal params: device sdc2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdc2: checking transaction log (sdc2)
ReiserFS: sdc2: Using r5 hash to sort names
ReiserFS: sdd1: found reiserfs format "3.6" with standard journal
ReiserFS: sdd1: using ordered data mode
ReiserFS: sdd1: journal params: device sdd1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdd1: checking transaction log (sdd1)
ReiserFS: sdd1: Using r5 hash to sort names
ReiserFS: sdd2: found reiserfs format "3.6" with standard journal
ReiserFS: sdd2: using ordered data mode
ReiserFS: sdd2: journal params: device sdd2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sdd2: checking transaction log (sdd2)
ReiserFS: sdd2: Using r5 hash to sort names
Adding 8385920k swap on /dev/sda2.  Priority:-1 extents:1 across:8385920k

--------------020202030902040308060907--

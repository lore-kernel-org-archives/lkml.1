Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZHKOjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZHKOjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZHKOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:39:09 -0400
Received: from ls405.t-com.hr ([195.29.150.135]:45485 "EHLO ls405.t-com.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZHKOjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:39:02 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 10:38:59 EDT
X-Envelope-Sender: hrvoje.habjanic@zg.t-com.hr
Message-ID: <4A817FFB.5080307@zg.t-com.hr>
Date: Tue, 11 Aug 2009 16:28:11 +0200
From: Hrvoje Habjanic <hrvoje.habjanic@zg.t-com.hr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Problems with pcmcia driver
Content-Type: multipart/mixed;
 boundary="------------020604000305040809080005"
X-TM-AS-Product-Ver: IMSS-7.0.0.3216-5.6.0.1016-16818.007
X-TM-AS-Result: No--10.172-5.0-31-1
X-imss-scan-details: No--10.172-5.0-31-1
X-TM-AS-User-Approved-Sender: No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--------------020604000305040809080005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi!

I'm not sure if i'm posting to the right place, so if i'm wrong, please 
forward it to the "right" people. :-)

Now, on the problem. I own laptop, Dell Latitude D630 with 4Gig of ram. 
Installed is Ubuntu, 9.04 Desktop x86_64, with 2.6.28 kernel. I also own 
pcmcia network card, Edimax EP-4203DL (1gb), which is having problems. 
More precisely - it does not work. My first guess was that this is 
driver related and i did try all of them - with no success.

Problem is, that when card is inserted, card is recognized and right 
driver is loaded, BUT, then driver reports unknown eeprom version and 
assigns -1 (ff:ff:ff:ff:ff:ff) as mac address. Of course, any attempt to 
change mac back to right or to initialize card - just fails. As the card 
is not there!? I get those stupid error "unable to assign address" or 
something from ifconfig command.

After a lot of fiddling around, i did notice following line:

pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 
to #07

After investigating a little, i found that this is related to fixup for 
bios bug, which incorrectly assigns bus id to pcmcia chip? This message 
is from code which attempts to reassign bus so card can work. But, in my 
case, it does not.

What is very interesting is that, removing yenta_socket module and 
inserting it again - solves the problem!!!

Here is dmesg for first insert:

[    8.036478] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[    8.036502] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[    8.036503] yenta_cardbus 0000:03:01.0: O2: enabling read 
prefetch/write burst
[    8.165238] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x04b8, PCI irq 19
[    8.165241] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[    8.165244] pci_bus 0000:03: Raising subordinate bus# of parent bus 
(#03) from #04 to #07
[    8.165249] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O 
window: 0x2000 - 0x2fff
[    8.165251] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge 
Memory window: 0xf1d00000 - 0xf1dfffff
[    8.165252] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge 
Memory window: 0x120000000 - 0x123ffffff

And this is on second insert:

[    8.680195] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[    8.680227] yenta_cardbus 0000:03:01.0: Preassigned resource 2 busy 
or not available, reconfiguring...
[    8.680235] yenta_cardbus 0000:03:01.0: Preassigned resource 3 busy 
or not available, reconfiguring...
[    8.680237] yenta_cardbus 0000:03:01.0: CardBus bridge, secondary bus 
0000:04
[    8.680239] yenta_cardbus 0000:03:01.0:   IO window: 0x002000-0x0020ff
[    8.680244] yenta_cardbus 0000:03:01.0:   IO window: 0x002400-0x0024ff
[    8.680249] yenta_cardbus 0000:03:01.0:   PREFETCH window: 
0xf0000000-0xf03fffff
[    8.680254] yenta_cardbus 0000:03:01.0:   MEM window: 
0xf0400000-0xf07fffff
[    8.680263] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[    8.680264] yenta_cardbus 0000:03:01.0: O2: enabling read 
prefetch/write burst
[    8.813294] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    8.813297] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[    8.813337] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O 
window: 0x2000 - 0x2fff
[    8.813339] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge 
Memory window: 0xf1d00000 - 0xf1dfffff
[    8.813341] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge 
Memory window: 0x120000000 - 0x123ffffff

In source, this message about subordinate buses comes from 
yenta_fixup_parent_bridge, and it is called from devinit method 
yenta_probe.

So, as i see it, yenta_fixup_parent_bridge fixes problem with buses, but 
it is called way down after driver initialization, and effectively, 
driver is not aware of changed resources (pci inspecting is done BEFORE 
call to fixup), so - it does not work! Should not fixup be called way 
before, or should not initialization be restarted after something changed??

Attached are two dmesg-s:
- dmesg.2.6.28-14-generic - clean boot
- dmesg.2.6.28-14-generic.2 - at boot, yenta_socked is removed and then 
reinserted
and two /proc/iomem:
- proc.iomem - iomem after clean boot
- proc.iomem.2 - after second boot, where yenta_socket is reinserted
and, finaly two, lspci -vv:
- lspci - clean boot
- lspci - boot with reinserted yenta_socket

Hope this will help ... :-)

H.


--------------020604000305040809080005
Content-Type: text/plain;
 name="dmesg.2.6.28-14-generic"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.2.6.28-14-generic"

[    0.000000] BIOS EBDA/lowmem at: 0009f000/0009f000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-14-generic (buildd@yellow) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #47-Ubuntu SMP Sat Jul 25 01:19:55 UTC 2009 (Ubuntu 2.6.28-14.47-generic)
[    0.000000] Command line: root=UUID=62a69490-6e75-446b-875f-f35c99ba58d6 ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe5a800 (usable)
[    0.000000]  BIOS-e820: 00000000dfe5a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100002000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xdfe5a max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)
[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dfe5a800 (usable)
[    0.000000]  modified: 00000000dfe5a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100002000 - 0000000120000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfe5a000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfe5a000 page 4k
[    0.000000] kernel direct mapping tables up to dfe5a000 @ 10000-16000
[    0.000000] last_map_addr: dfe5a000 end: dfe5a000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 14000-1a000
[    0.000000] last_map_addr: 120000000 end: 120000000
[    0.000000] RAMDISK: 37858000 - 37fef8a9
[    0.000000] ACPI: RSDP 000FBB10, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT DFE5D200, 0064 (r1 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: FACP DFE5D09C, 00F4 (r4 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: DSDT DFE5D800, 6114 (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS DFE6C000, 0040
[    0.000000] ACPI: HPET DFE5D300, 0038 (r1 DELL    M08            1 ASL        61)
[    0.000000] ACPI: APIC DFE5D400, 0068 (r1 DELL    M08     27D9070E ASL        47)
[    0.000000] ACPI: ASF! DFE5D000, 007E (r32 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: MCFG DFE5D3C0, 003E (r16 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: TCPA DFE5D700, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC DFE5D49C, 0176 (r1 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: SSDT DFE5B97E, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b7bbb0]    TEXT DATA BSS ==> [0000200000 - 0000b7bbb0]
[    0.000000]   #3 [0037858000 - 0037fef8a9]          RAMDISK ==> [0037858000 - 0037fef8a9]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #6 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
[    0.000000]  [ffffe20000000000-ffffe20003ffffff] PMD -> [ffff880028200000-ffff88002c1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x00000008
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x000dfe5a
[    0.000000]     0: 0x00100002 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048029
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2532 pages reserved
[    0.000000]   DMA zone: 1385 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898706 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129278 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000008000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfe5a000 - 00000000dfe5b000
[    0.000000] PM: Registered nosave memory: 00000000dfe5b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100002000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:18000000)
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029369
[    0.000000] Kernel command line: root=UUID=62a69490-6e75-446b-875f-f35c99ba58d6 ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2493.427 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 47185920 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 3989360k/4718592k available (4748k kernel code, 526476k absent, 201564k reserved, 2524k data, 532k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4986.85 BogoMIPS (lpj=9973708)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.004292] ACPI: Checking initramfs for custom DSDT
[    0.274724] Setting APIC routing to flat
[    0.275147] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.314849] CPU0: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
[    0.316001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4986.04 BogoMIPS (lpj=9972084)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.400858] CPU1: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
[    0.400878] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.404039] Brought up 2 CPUs
[    0.404042] Total of 2 processors activated (9972.89 BogoMIPS).
[    0.404094] CPU0 attaching sched-domain:
[    0.404096]  domain 0: span 0-1 level MC
[    0.404098]   groups: 0 1
[    0.404102] CPU1 attaching sched-domain:
[    0.404103]  domain 0: span 0-1 level MC
[    0.404104]   groups: 1 0
[    0.404162] net_namespace: 1400 bytes
[    0.404162] Booting paravirtualized kernel on bare hardware
[    0.404230] Time:  8:20:47  Date: 08/08/09
[    0.404230] regulator: core version 0.5
[    0.404230] NET: Registered protocol family 16
[    0.404230] ACPI: bus type pci registered
[    0.404230] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.404230] PCI: MCFG area at f8000000 reserved in E820
[    0.406419] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.406420] PCI: Using configuration type 1 for base access
[    0.408587] ACPI: EC: Look up EC in DSDT
[    0.408762] ACPI: BIOS _OSI(Linux) query ignored
[    0.438798] ACPI: SSDT DFE6C080, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
[    0.454012] ACPI: Interpreter enabled
[    0.454014] ACPI: (supports S0 S3 S4 S5)
[    0.456013] ACPI: Using IOAPIC for interrupt routing
[    0.531302] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.531310] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.531383] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.531386] pci 0000:00:01.0: PME# disabled
[    0.531467] pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]
[    0.531527] pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]
[    0.531592] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.531637] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.531642] pci 0000:00:1a.7: PME# disabled
[    0.531693] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6ffc000-0xf6ffffff]
[    0.531732] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.531736] pci 0000:00:1b.0: PME# disabled
[    0.531799] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.531803] pci 0000:00:1c.0: PME# disabled
[    0.531869] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.531873] pci 0000:00:1c.1: PME# disabled
[    0.531943] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.531947] pci 0000:00:1c.5: PME# disabled
[    0.532014] pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]
[    0.532076] pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]
[    0.532135] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.532199] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.532243] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.532248] pci 0000:00:1d.7: PME# disabled
[    0.532400] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.532403] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
[    0.532438] pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]
[    0.532445] pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]
[    0.532452] pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]
[    0.532459] pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]
[    0.532466] pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]
[    0.532534] pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]
[    0.532541] pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]
[    0.532548] pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]
[    0.532555] pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]
[    0.532562] pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eff]
[    0.532569] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf6ffb800-0xf6ffbfff]
[    0.532588] pci 0000:00:1f.2: PME# supported from D3hot
[    0.532592] pci 0000:00:1f.2: PME# disabled
[    0.532622] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf6ffb700-0xf6ffb7ff]
[    0.532646] pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
[    0.532716] pci 0000:01:00.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
[    0.532731] pci 0000:01:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
[    0.532746] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf2000000-0xf3ffffff]
[    0.532754] pci 0000:01:00.0: reg 24 io port: [0xef00-0xef7f]
[    0.532762] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.532837] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[    0.532840] pci 0000:00:01.0: bridge 32bit mmio: [0xf2000000-0xf6efffff]
[    0.532843] pci 0000:00:01.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.533088] pci 0000:0c:00.0: reg 10 32bit mmio: [0xf1fff000-0xf1ffffff]
[    0.533250] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.533262] pci 0000:0c:00.0: PME# disabled
[    0.533366] pci 0000:00:1c.1: bridge 32bit mmio: [0xf1f00000-0xf1ffffff]
[    0.533457] pci 0000:09:00.0: reg 10 64bit mmio: [0xf1ef0000-0xf1efffff]
[    0.533513] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.533519] pci 0000:09:00.0: PME# disabled
[    0.533588] pci 0000:00:1c.5: bridge 32bit mmio: [0xf1e00000-0xf1efffff]
[    0.533643] pci 0000:03:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.533655] pci 0000:03:01.0: supports D1 D2
[    0.533656] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.533661] pci 0000:03:01.0: PME# disabled
[    0.533706] pci 0000:03:01.4: reg 10 32bit mmio: [0xf1dff000-0xf1dfffff]
[    0.533713] pci 0000:03:01.4: reg 14 32bit mmio: [0xf1dfe800-0xf1dfefff]
[    0.533752] pci 0000:03:01.4: supports D1 D2
[    0.533753] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.533757] pci 0000:03:01.4: PME# disabled
[    0.533821] pci 0000:00:1e.0: transparent bridge
[    0.533827] pci 0000:00:1e.0: bridge 32bit mmio: [0xf1d00000-0xf1dfffff]
[    0.533882] bus 00 -> node 0
[    0.533887] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.534265] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.534412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.534505] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.534617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.534728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.549986] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *5
[    0.550101] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.550214] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.550326] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *9 10 11)
[    0.550439] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.550554] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.550668] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.550771] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.550892] ACPI: WMI: Mapper loaded
[    0.550921] SCSI subsystem initialized
[    0.550921] libata version 3.00 loaded.
[    0.550921] usbcore: registered new interface driver usbfs
[    0.550921] usbcore: registered new interface driver hub
[    0.550921] usbcore: registered new device driver usb
[    0.550921] PCI: Using ACPI for IRQ routing
[    0.560007] Bluetooth: Core ver 2.13
[    0.560017] NET: Registered protocol family 31
[    0.560017] Bluetooth: HCI device and connection manager initialized
[    0.560017] Bluetooth: HCI socket layer initialized
[    0.560017] NET: Registered protocol family 8
[    0.560018] NET: Registered protocol family 20
[    0.560025] NetLabel: Initializing
[    0.560026] NetLabel:  domain hash size = 128
[    0.560027] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.560038] NetLabel:  unlabeled traffic allowed by default
[    0.560061] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.560064] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.564042] AppArmor: AppArmor Filesystem Enabled
[    0.568006] Switched to high resolution mode on CPU 0
[    0.568912] Switched to high resolution mode on CPU 1
[    0.576007] pnp: PnP ACPI init
[    0.576014] ACPI: bus type pnp registered
[    0.623421] pnp 00:0b: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.623423] pnp 00:0b: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.623499] pnp 00:0c: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.623501] pnp 00:0c: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.623503] pnp 00:0c: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.623505] pnp 00:0c: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.643541] pnp 00:0d: mem resource (0xdff00000-0xe06fffff) overlaps 0000:00:01.0 BAR 9 (0xe0000000-0xefffffff), disabling
[    0.643562] pnp 00:0d: mem resource (0xdff00000-0xe06fffff) overlaps 0000:01:00.0 BAR 1 (0xe0000000-0xefffffff), disabling
[    0.643698] pnp: PnP ACPI: found 14 devices
[    0.643699] ACPI: ACPI bus type pnp unregistered
[    0.643707] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.643709] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.643714] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.643718] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.643720] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.643724] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.643725] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.643729] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.643731] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.643733] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.643735] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.643739] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.643741] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.643742] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.643744] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.643746] system 00:0d: iomem range 0x100000-0xdfe5a7ff could not be reserved
[    0.643748] system 00:0d: iomem range 0xdfe5a800-0xdfefffff has been reserved
[    0.643752] system 00:0d: iomem range 0xdff00000-0xdfffffff has been reserved
[    0.643753] system 00:0d: iomem range 0xffe00000-0xffffffff has been reserved
[    0.643755] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.643757] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.643759] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.643760] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.643762] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.643764] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.643766] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.643768] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.643770] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.643771] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.643773] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.648431] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.648434] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    0.648437] pci 0000:00:01.0:   MEM window: 0xf2000000-0xf6efffff
[    0.648439] pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
[    0.648443] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.648444] pci 0000:00:1c.0:   IO window: disabled
[    0.648449] pci 0000:00:1c.0:   MEM window: disabled
[    0.648453] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.648460] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.648461] pci 0000:00:1c.1:   IO window: disabled
[    0.648467] pci 0000:00:1c.1:   MEM window: 0xf1f00000-0xf1ffffff
[    0.648471] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.648478] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:09
[    0.648479] pci 0000:00:1c.5:   IO window: disabled
[    0.648484] pci 0000:00:1c.5:   MEM window: 0xf1e00000-0xf1efffff
[    0.648488] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.648501] pci 0000:03:01.0: CardBus bridge, secondary bus 0000:04
[    0.648502] pci 0000:03:01.0:   IO window: 0x002000-0x0020ff
[    0.648506] pci 0000:03:01.0:   IO window: 0x002400-0x0024ff
[    0.648511] pci 0000:03:01.0:   PREFETCH window: 0x120000000-0x123ffffff
[    0.648516] pci 0000:03:01.0:   MEM window: 0x124000000-0x127ffffff
[    0.648521] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.648524] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.648529] pci 0000:00:1e.0:   MEM window: 0xf1d00000-0xf1dfffff
[    0.648533] pci 0000:00:1e.0:   PREFETCH window: 0x00000120000000-0x00000123ffffff
[    0.648546] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.648549] pci 0000:00:01.0: setting latency timer to 64
[    0.648556] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.648560] pci 0000:00:1c.0: setting latency timer to 64
[    0.648568] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.648572] pci 0000:00:1c.1: setting latency timer to 64
[    0.648580] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.648584] pci 0000:00:1c.5: setting latency timer to 64
[    0.648591] pci 0000:00:1e.0: setting latency timer to 64
[    0.648600] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    0.648604] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.648611] bus: 00 index 0 io port: [0x00-0xffff]
[    0.648613] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.648614] bus: 01 index 0 io port: [0xe000-0xefff]
[    0.648615] bus: 01 index 1 mmio: [0xf2000000-0xf6efffff]
[    0.648617] bus: 01 index 2 mmio: [0xe0000000-0xefffffff]
[    0.648618] bus: 01 index 3 mmio: [0x0-0x0]
[    0.648619] bus: 0b index 0 mmio: [0x0-0x0]
[    0.648620] bus: 0b index 1 mmio: [0x0-0x0]
[    0.648621] bus: 0b index 2 mmio: [0x0-0x0]
[    0.648622] bus: 0b index 3 mmio: [0x0-0x0]
[    0.648623] bus: 0c index 0 mmio: [0x0-0x0]
[    0.648625] bus: 0c index 1 mmio: [0xf1f00000-0xf1ffffff]
[    0.648626] bus: 0c index 2 mmio: [0x0-0x0]
[    0.648627] bus: 0c index 3 mmio: [0x0-0x0]
[    0.648628] bus: 09 index 0 mmio: [0x0-0x0]
[    0.648629] bus: 09 index 1 mmio: [0xf1e00000-0xf1efffff]
[    0.648630] bus: 09 index 2 mmio: [0x0-0x0]
[    0.648631] bus: 09 index 3 mmio: [0x0-0x0]
[    0.648633] bus: 03 index 0 io port: [0x2000-0x2fff]
[    0.648634] bus: 03 index 1 mmio: [0xf1d00000-0xf1dfffff]
[    0.648635] bus: 03 index 2 mmio: [0x120000000-0x123ffffff]
[    0.648637] bus: 03 index 3 io port: [0x00-0xffff]
[    0.648638] bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.648639] bus: 04 index 0 io port: [0x2000-0x20ff]
[    0.648641] bus: 04 index 1 io port: [0x2400-0x24ff]
[    0.648642] bus: 04 index 2 mmio: [0x120000000-0x123ffffff]
[    0.648643] bus: 04 index 3 mmio: [0x124000000-0x127ffffff]
[    0.648649] NET: Registered protocol family 2
[    0.684040] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.684406] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.685611] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.686010] TCP: Hash tables configured (established 262144 bind 65536)
[    0.686013] TCP reno registered
[    0.696074] NET: Registered protocol family 1
[    0.696175] checking if image is initramfs... it is
[    1.236047] Freeing initrd memory: 7774k freed
[    1.239008] audit: initializing netlink socket (disabled)
[    1.239028] type=2000 audit(1249719647.236:1): initialized
[    1.245866] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.246792] VFS: Disk quotas dquot_6.5.1
[    1.246830] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.247252] fuse init (API version 7.10)
[    1.247307] msgmni has been set to 7809
[    1.247439] alg: No test for stdrng (krng)
[    1.247446] io scheduler noop registered
[    1.247448] io scheduler anticipatory registered
[    1.247449] io scheduler deadline registered
[    1.247478] io scheduler cfq registered (default)
[    1.247642] pci 0000:01:00.0: Boot video device
[    1.299747] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.299775] pcieport-driver 0000:00:01.0: found MSI capability
[    1.299795] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    1.299802] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.299812] pci_express 0000:00:01.0:pcie02: allocate port service
[    1.299820] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.299860] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.299906] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.299936] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    1.299951] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.299962] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.299970] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.300036] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.300082] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.300113] pcieport-driver 0000:00:1c.1: irq 2301 for MSI/MSI-X
[    1.300127] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.300136] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.300144] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.300211] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.300257] pcieport-driver 0000:00:1c.5: found MSI capability
[    1.300287] pcieport-driver 0000:00:1c.5: irq 2300 for MSI/MSI-X
[    1.300302] pci_express 0000:00:1c.5:pcie00: allocate port service
[    1.300311] pci_express 0000:00:1c.5:pcie02: allocate port service
[    1.300322] pci_express 0000:00:1c.5:pcie03: allocate port service
[    1.300392] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.300471] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.300589] ACPI: AC Adapter [AC] (on-line)
[    1.328408] ACPI: Battery Slot [BAT0] (battery present)
[    1.328451] ACPI: Battery Slot [BAT1] (battery absent)
[    1.328510] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.328968] ACPI: Lid Switch [LID]
[    1.329011] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.329016] ACPI: Power Button (CM) [PBTN]
[    1.329050] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.329052] ACPI: Sleep Button (CM) [SBTN]
[    1.329551] ACPI: SSDT DFE5C4B4, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    1.329912] ACPI: SSDT DFE5BE4A, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    1.330200] Monitor-Mwait will be used to enter C-1 state
[    1.330202] Monitor-Mwait will be used to enter C-2 state
[    1.330203] Monitor-Mwait will be used to enter C-3 state
[    1.330215] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.330234] processor ACPI_CPU:00: registered as cooling_device0
[    1.330236] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.330515] ACPI: SSDT DFE5C77C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    1.330757] ACPI: SSDT DFE5C42F, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[    1.331077] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.331090] processor ACPI_CPU:01: registered as cooling_device1
[    1.331092] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.364365] thermal LNXTHERM:01: registered as thermal_zone0
[    1.367837] ACPI: Thermal Zone [THM] (60 C)
[    1.393143] Linux agpgart interface v0.103
[    1.393150] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.393266] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.393574] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.394113] brd: module loaded
[    1.394348] loop: module loaded
[    1.394399] Fixed MDIO Bus: probed
[    1.394403] PPP generic driver version 2.4.2
[    1.394445] input: Macintosh mouse button emulation as /devices/virtual/input/input3
[    1.394464] Driver 'sd' needs updating - please use bus_type methods
[    1.394470] Driver 'sr' needs updating - please use bus_type methods
[    1.394499] ahci 0000:00:1f.2: version 3.0
[    1.394512] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.394543] ahci 0000:00:1f.2: irq 2299 for MSI/MSI-X
[    1.394618] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.394620] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
[    1.394625] ahci 0000:00:1f.2: setting latency timer to 64
[    1.394819] scsi0 : ahci
[    1.394874] scsi1 : ahci
[    1.394915] scsi2 : ahci
[    1.395113] ata1: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffb900 irq 2299
[    1.395115] ata2: DUMMY
[    1.395117] ata3: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffba00 irq 2299
[    1.712020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.712932] ata1.00: ATA-8: Hitachi HTS722016K9A300, DCDOCA1H, max UDMA/133
[    1.712934] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.714031] ata1.00: configured for UDMA/133
[    2.048017] ata3: SATA link down (SStatus 0 SControl 300)
[    2.064085] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72201 DCDO PQ: 0 ANSI: 5
[    2.064149] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.064162] sd 0:0:0:0: [sda] Write Protect is off
[    2.064163] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.064182] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.064229] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.064240] sd 0:0:0:0: [sda] Write Protect is off
[    2.064241] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.064259] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.064262]  sda: sda1 sda2 sda3
[    2.083486] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.083517] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.083551] ata_piix 0000:00:1f.1: version 2.12
[    2.083557] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.083588] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.083654] scsi3 : ata_piix
[    2.083694] scsi4 : ata_piix
[    2.085848] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    2.085850] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    2.248487] ata4.00: ATAPI: HL-DT-ST DVD+/-RW GSA-T21N, A102, max UDMA/33
[    2.264394] ata4.00: configured for UDMA/33
[    2.269710] ata5: port disabled. ignoring.
[    2.272822] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-T21N A102 PQ: 0 ANSI: 5
[    2.283745] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.283747] Uniform CD-ROM driver Revision: 3.20
[    2.283802] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.283827] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    2.284241] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.284257] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.284265] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.284268] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.284304] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.288222] ehci_hcd 0000:00:1a.7: debug port 1
[    2.288227] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.288237] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.300008] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.300065] usb usb1: configuration #1 chosen from 1 choice
[    2.300084] hub 1-0:1.0: USB hub found
[    2.300092] hub 1-0:1.0: 4 ports detected
[    2.300179] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.300186] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.300189] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.300220] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.304120] ehci_hcd 0000:00:1d.7: debug port 1
[    2.304125] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.304135] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.316007] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.316041] usb usb2: configuration #1 chosen from 1 choice
[    2.316060] hub 2-0:1.0: USB hub found
[    2.316064] hub 2-0:1.0: 6 ports detected
[    2.316135] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.316144] uhci_hcd: USB Universal Host Controller Interface driver
[    2.316159] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.316164] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.316167] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.316198] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.316224] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    2.316283] usb usb3: configuration #1 chosen from 1 choice
[    2.316299] hub 3-0:1.0: USB hub found
[    2.316304] hub 3-0:1.0: 2 ports detected
[    2.316367] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.316373] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.316376] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.316403] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.316434] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    2.316494] usb usb4: configuration #1 chosen from 1 choice
[    2.316510] hub 4-0:1.0: USB hub found
[    2.316515] hub 4-0:1.0: 2 ports detected
[    2.316577] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.316582] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.316585] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.316614] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.316639] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    2.316693] usb usb5: configuration #1 chosen from 1 choice
[    2.316712] hub 5-0:1.0: USB hub found
[    2.316716] hub 5-0:1.0: 2 ports detected
[    2.316783] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.316788] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.316791] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.316820] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.316846] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    2.316903] usb usb6: configuration #1 chosen from 1 choice
[    2.316919] hub 6-0:1.0: USB hub found
[    2.316923] hub 6-0:1.0: 2 ports detected
[    2.316986] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.316991] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.316994] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.317029] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.317055] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.317111] usb usb7: configuration #1 chosen from 1 choice
[    2.317127] hub 7-0:1.0: USB hub found
[    2.317132] hub 7-0:1.0: 2 ports detected
[    2.317225] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.320480] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.320484] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.332025] mice: PS/2 mouse device common for all mice
[    2.380054] rtc_cmos 00:03: RTC can wake from S4
[    2.380079] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.380109] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.380146] device-mapper: uevent: version 1.0.3
[    2.380204] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.380260] device-mapper: multipath: version 1.0.5 loaded
[    2.380261] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.380375] cpuidle: using governor ladder
[    2.380448] cpuidle: using governor menu
[    2.380734] TCP cubic registered
[    2.380787] NET: Registered protocol family 10
[    2.381072] lo: Disabled Privacy Extensions
[    2.381273] NET: Registered protocol family 17
[    2.381287] Bluetooth: L2CAP ver 2.11
[    2.381288] Bluetooth: L2CAP socket layer initialized
[    2.381290] Bluetooth: SCO (Voice Link) ver 0.6
[    2.381291] Bluetooth: SCO socket layer initialized
[    2.381306] Marking TSC unstable due to TSC halts in idle
[    2.381319] Bluetooth: RFCOMM socket layer initialized
[    2.381323] Bluetooth: RFCOMM TTY layer initialized
[    2.381324] Bluetooth: RFCOMM ver 1.10
[    2.381896] registered taskstats version 1
[    2.381980]   Magic number: 5:729:320
[    2.381989] tty tty45: hash matches
[    2.382055] rtc_cmos 00:03: setting system clock to 2009-08-08 08:20:49 UTC (1249719649)
[    2.382057] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.382058] EDD information not available.
[    2.382090] Freeing unused kernel memory: 532k freed
[    2.382295] Write protecting the kernel read-only data: 6688k
[    2.383993] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.529682] tg3.c:v3.94 (August 14, 2008)
[    2.529703] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.529712] tg3 0000:09:00.0: setting latency timer to 64
[    2.554644] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI Express) 10/100/1000Base-T Ethernet 00:1c:23:52:16:2d
[    2.554647] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    2.554648] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.585754] ohci1394 0000:03:01.4: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.636488] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[f1dff000-f1dff7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    2.826489] PM: Starting manual resume from disk
[    2.826491] PM: Resume from partition 8:1
[    2.826492] PM: Checking hibernation image.
[    2.826666] PM: Resume from disk failed.
[    2.851626] kjournald starting.  Commit interval 5 seconds
[    2.851632] EXT3-fs: mounted filesystem with ordered data mode.
[    3.097063] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    3.258645] usb 4-2: configuration #1 chosen from 1 choice
[    3.505050] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    3.658249] usb 7-1: configuration #1 chosen from 1 choice
[    3.660187] hub 7-1:1.0: USB hub found
[    3.662161] hub 7-1:1.0: 4 ports detected
[    3.909075] usb 7-2: new full speed USB device using uhci_hcd and address 3
[    3.912202] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[484fc0001fb1e070]
[    4.088219] usb 7-2: configuration #1 chosen from 1 choice
[    4.166179] usb 7-1.2: new full speed USB device using uhci_hcd and address 4
[    4.283248] usb 7-1.2: configuration #1 chosen from 1 choice
[    6.833308] udev: starting version 141
[    7.497540] nvidia: module license 'NVIDIA' taints kernel.
[    7.749300] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.749308] nvidia 0000:01:00.0: setting latency timer to 64
[    7.750165] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.44  Tue Mar 24 05:46:32 PST 2009
[    7.845111] cfg80211: Calling CRDA to update world regulatory domain
[    7.904618] usbcore: registered new interface driver usbserial
[    7.904627] USB Serial support registered for generic
[    7.904664] usbcore: registered new interface driver usbserial_generic
[    7.904665] usbserial: USB Serial Driver core
[    8.036478] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[    8.036502] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[    8.036503] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[    8.084860] iTCO_vendor_support: vendor-support=0
[    8.094241] cfg80211: World regulatory domain updated:
[    8.094243] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.094245] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.094246] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.094248] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.094249] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.094250] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.102386] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.102510] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    8.102585] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.165238] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x04b8, PCI irq 19
[    8.165241] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[    8.165244] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[    8.165249] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[    8.165251] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0xf1d00000 - 0xf1dfffff
[    8.165252] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff
[    8.174624] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.207305] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    8.223283] USB Serial support registered for GSM modem (1-port)
[    8.223333] option 4-2:1.0: GSM modem (1-port) converter detected
[    8.223656] usb 4-2: GSM modem (1-port) converter now attached to ttyUSB0
[    8.223673] option 4-2:1.1: GSM modem (1-port) converter detected
[    8.223739] usb 4-2: GSM modem (1-port) converter now attached to ttyUSB1
[    8.223773] usbcore: registered new interface driver option
[    8.223775] option: v0.7.2:USB Driver for GSM modems
[    8.237867] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:31/device:32/input/input6
[    8.273178] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    8.366398] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
[    8.366400] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[    8.366511] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.366525] iwl3945 0000:0c:00.0: setting latency timer to 64
[    8.366598] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
[    8.366914] iwl3945 0000:0c:00.0: irq 2298 for MSI/MSI-X
[    8.414974] synaptics was reset on resume, see synaptics_resume_reset if you have trouble on resume
[    8.422829] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[    8.423350] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    8.468128] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    8.468170] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.321027] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input7
[    9.364835] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input8
[   10.480080] iwl3945: Radio Frequency Kill Switch is On:
[   10.480082] Kill switch must be turned off for wireless networking to work.
[   14.500248] Clocksource tsc unstable (delta = -64870713 ns)
[   16.087509] lp: driver loaded but no devices found
[   16.136034] Adding 2008084k swap on /dev/sda1.  Priority:-1 extents:1 across:2008084k
[   16.662509] EXT3 FS on sda2, internal journal
[   17.545136] type=1505 audit(1249719664.661:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=2147
[   17.570494] type=1505 audit(1249719664.685:3): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2151
[   17.570552] type=1505 audit(1249719664.685:4): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2151
[   17.570580] type=1505 audit(1249719664.685:5): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2151
[   17.570603] type=1505 audit(1249719664.685:6): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2151
[   17.641048] type=1505 audit(1249719664.757:7): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2156
[   17.641165] type=1505 audit(1249719664.757:8): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2156
[   17.657874] type=1505 audit(1249719664.773:9): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2160
[   19.624836] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.624838] Bluetooth: BNEP filters: protocol multicast
[   19.635309] Bridge firewalling registered
[   21.014831] ppdev: user-space parallel port driver
[   25.009614] tg3 0000:09:00.0: irq 2297 for MSI/MSI-X
[   25.070355] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   25.162127] iwl3945 0000:0c:00.0: firmware: requesting iwlwifi-3945-1.ucode
[   25.248881] iwl3945: Radio disabled by HW RF Kill switch
[   28.117037] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   28.117039] tg3: eth0: Flow control is on for TX and on for RX.
[   28.117531] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   38.456052] eth0: no IPv6 routers present
[   55.481342] type=1503 audit(1249719702.598:10): operation="inode_permission" requested_mask="w::" denied_mask="w::" fsuid=0 name="/dev/ttyUSB0" pid=3640 profile="/usr/sbin/cupsd"
[   55.481353] type=1503 audit(1249719702.598:11): operation="inode_permission" requested_mask="w::" denied_mask="w::" fsuid=0 name="/dev/ttyUSB1" pid=3640 profile="/usr/sbin/cupsd"

--------------020604000305040809080005
Content-Type: application/x-troff-man;
 name="dmesg.2.6.28-14-generic.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.2.6.28-14-generic.2"

[    0.000000] BIOS EBDA/lowmem at: 0009f000/0009f000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-14-generic (buildd@yellow) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #47-Ubuntu SMP Sat Jul 25 01:19:55 UTC 2009 (Ubuntu 2.6.28-14.47-generic)
[    0.000000] Command line: root=UUID=62a69490-6e75-446b-875f-f35c99ba58d6 ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe5a800 (usable)
[    0.000000]  BIOS-e820: 00000000dfe5a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100002000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xdfe5a max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)
[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dfe5a800 (usable)
[    0.000000]  modified: 00000000dfe5a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100002000 - 0000000120000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfe5a000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfe5a000 page 4k
[    0.000000] kernel direct mapping tables up to dfe5a000 @ 10000-16000
[    0.000000] last_map_addr: dfe5a000 end: dfe5a000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 14000-1a000
[    0.000000] last_map_addr: 120000000 end: 120000000
[    0.000000] RAMDISK: 37858000 - 37fef8a9
[    0.000000] ACPI: RSDP 000FBB10, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT DFE5D200, 0064 (r1 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: FACP DFE5D09C, 00F4 (r4 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: DSDT DFE5D800, 6114 (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS DFE6C000, 0040
[    0.000000] ACPI: HPET DFE5D300, 0038 (r1 DELL    M08            1 ASL        61)
[    0.000000] ACPI: APIC DFE5D400, 0068 (r1 DELL    M08     27D9070E ASL        47)
[    0.000000] ACPI: ASF! DFE5D000, 007E (r32 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: MCFG DFE5D3C0, 003E (r16 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: TCPA DFE5D700, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SLIC DFE5D49C, 0176 (r1 DELL    M08     27D9070E ASL        61)
[    0.000000] ACPI: SSDT DFE5B97E, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b7bbb0]    TEXT DATA BSS ==> [0000200000 - 0000b7bbb0]
[    0.000000]   #3 [0037858000 - 0037fef8a9]          RAMDISK ==> [0037858000 - 0037fef8a9]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #6 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
[    0.000000]  [ffffe20000000000-ffffe20003ffffff] PMD -> [ffff880028200000-ffff88002c1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x00000008
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x000dfe5a
[    0.000000]     0: 0x00100002 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048029
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2532 pages reserved
[    0.000000]   DMA zone: 1385 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898706 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129278 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000008000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfe5a000 - 00000000dfe5b000
[    0.000000] PM: Registered nosave memory: 00000000dfe5b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100002000
[    0.000000] Allocating PCI resources starting at e2000000 (gap: e0000000:18000000)
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029369
[    0.000000] Kernel command line: root=UUID=62a69490-6e75-446b-875f-f35c99ba58d6 ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2493.304 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 47185920 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 3989360k/4718592k available (4748k kernel code, 526476k absent, 201564k reserved, 2524k data, 532k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4986.60 BogoMIPS (lpj=9973216)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.004295] ACPI: Checking initramfs for custom DSDT
[    0.275074] Setting APIC routing to flat
[    0.275496] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.315195] CPU0: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
[    0.316001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4986.04 BogoMIPS (lpj=9972089)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.400851] CPU1: Intel(R) Core(TM)2 Duo CPU     T9300  @ 2.50GHz stepping 06
[    0.400870] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.404039] Brought up 2 CPUs
[    0.404042] Total of 2 processors activated (9972.65 BogoMIPS).
[    0.404093] CPU0 attaching sched-domain:
[    0.404094]  domain 0: span 0-1 level MC
[    0.404096]   groups: 0 1
[    0.404101] CPU1 attaching sched-domain:
[    0.404102]  domain 0: span 0-1 level MC
[    0.404103]   groups: 1 0
[    0.404160] net_namespace: 1400 bytes
[    0.404160] Booting paravirtualized kernel on bare hardware
[    0.404229] Time: 22:05:47  Date: 08/10/09
[    0.404229] regulator: core version 0.5
[    0.404229] NET: Registered protocol family 16
[    0.404229] ACPI: bus type pci registered
[    0.404229] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.404229] PCI: MCFG area at f8000000 reserved in E820
[    0.406419] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.406420] PCI: Using configuration type 1 for base access
[    0.408586] ACPI: EC: Look up EC in DSDT
[    0.408760] ACPI: BIOS _OSI(Linux) query ignored
[    0.438522] ACPI: SSDT DFE6C080, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
[    0.453589] ACPI: Interpreter enabled
[    0.453591] ACPI: (supports S0 S3 S4 S5)
[    0.454023] ACPI: Using IOAPIC for interrupt routing
[    0.531349] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.531357] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.531430] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.531433] pci 0000:00:01.0: PME# disabled
[    0.531514] pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]
[    0.531574] pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]
[    0.531639] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.531683] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.531688] pci 0000:00:1a.7: PME# disabled
[    0.531739] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6ffc000-0xf6ffffff]
[    0.531778] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.531782] pci 0000:00:1b.0: PME# disabled
[    0.531845] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.531849] pci 0000:00:1c.0: PME# disabled
[    0.531915] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.531919] pci 0000:00:1c.1: PME# disabled
[    0.531989] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.531993] pci 0000:00:1c.5: PME# disabled
[    0.532060] pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]
[    0.532122] pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]
[    0.532181] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.532245] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.532289] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.532294] pci 0000:00:1d.7: PME# disabled
[    0.532446] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.532450] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
[    0.532484] pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]
[    0.532491] pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]
[    0.532498] pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]
[    0.532505] pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]
[    0.532512] pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]
[    0.532580] pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]
[    0.532587] pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]
[    0.532594] pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]
[    0.532601] pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]
[    0.532608] pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eff]
[    0.532615] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf6ffb800-0xf6ffbfff]
[    0.532634] pci 0000:00:1f.2: PME# supported from D3hot
[    0.532638] pci 0000:00:1f.2: PME# disabled
[    0.532669] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf6ffb700-0xf6ffb7ff]
[    0.532693] pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
[    0.532762] pci 0000:01:00.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
[    0.532777] pci 0000:01:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
[    0.532792] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf2000000-0xf3ffffff]
[    0.532800] pci 0000:01:00.0: reg 24 io port: [0xef00-0xef7f]
[    0.532808] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.532883] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[    0.532886] pci 0000:00:01.0: bridge 32bit mmio: [0xf2000000-0xf6efffff]
[    0.532889] pci 0000:00:01.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.533135] pci 0000:0c:00.0: reg 10 32bit mmio: [0xf1fff000-0xf1ffffff]
[    0.533296] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.533308] pci 0000:0c:00.0: PME# disabled
[    0.533412] pci 0000:00:1c.1: bridge 32bit mmio: [0xf1f00000-0xf1ffffff]
[    0.533504] pci 0000:09:00.0: reg 10 64bit mmio: [0xf1ef0000-0xf1efffff]
[    0.533560] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.533565] pci 0000:09:00.0: PME# disabled
[    0.533634] pci 0000:00:1c.5: bridge 32bit mmio: [0xf1e00000-0xf1efffff]
[    0.533689] pci 0000:03:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.533701] pci 0000:03:01.0: supports D1 D2
[    0.533702] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.533707] pci 0000:03:01.0: PME# disabled
[    0.533752] pci 0000:03:01.4: reg 10 32bit mmio: [0xf1dff000-0xf1dfffff]
[    0.533759] pci 0000:03:01.4: reg 14 32bit mmio: [0xf1dfe800-0xf1dfefff]
[    0.533798] pci 0000:03:01.4: supports D1 D2
[    0.533799] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.533803] pci 0000:03:01.4: PME# disabled
[    0.533866] pci 0000:00:1e.0: transparent bridge
[    0.533873] pci 0000:00:1e.0: bridge 32bit mmio: [0xf1d00000-0xf1dfffff]
[    0.533927] bus 00 -> node 0
[    0.533932] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.534311] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.534459] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.534552] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.534664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.534776] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.549973] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *5
[    0.550088] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.550201] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.550313] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *9 10 11)
[    0.550426] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.550541] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.550655] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.550758] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.550878] ACPI: WMI: Mapper loaded
[    0.550906] SCSI subsystem initialized
[    0.550906] libata version 3.00 loaded.
[    0.550906] usbcore: registered new interface driver usbfs
[    0.550906] usbcore: registered new interface driver hub
[    0.550906] usbcore: registered new device driver usb
[    0.550906] PCI: Using ACPI for IRQ routing
[    0.560007] Bluetooth: Core ver 2.13
[    0.560016] NET: Registered protocol family 31
[    0.560016] Bluetooth: HCI device and connection manager initialized
[    0.560016] Bluetooth: HCI socket layer initialized
[    0.560016] NET: Registered protocol family 8
[    0.560017] NET: Registered protocol family 20
[    0.560025] NetLabel: Initializing
[    0.560026] NetLabel:  domain hash size = 128
[    0.560027] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.560037] NetLabel:  unlabeled traffic allowed by default
[    0.560060] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.560063] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.564042] AppArmor: AppArmor Filesystem Enabled
[    0.568007] Switched to high resolution mode on CPU 0
[    0.568904] Switched to high resolution mode on CPU 1
[    0.576006] pnp: PnP ACPI init
[    0.576012] ACPI: bus type pnp registered
[    0.624650] pnp 00:0b: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.624653] pnp 00:0b: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.624728] pnp 00:0c: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.624730] pnp 00:0c: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.624732] pnp 00:0c: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.624734] pnp 00:0c: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.644757] pnp 00:0d: mem resource (0xdff00000-0xe06fffff) overlaps 0000:00:01.0 BAR 9 (0xe0000000-0xefffffff), disabling
[    0.644778] pnp 00:0d: mem resource (0xdff00000-0xe06fffff) overlaps 0000:01:00.0 BAR 1 (0xe0000000-0xefffffff), disabling
[    0.644913] pnp: PnP ACPI: found 14 devices
[    0.644915] ACPI: ACPI bus type pnp unregistered
[    0.644922] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.644924] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.644929] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.644933] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.644935] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.644939] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.644941] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.644945] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.644947] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.644949] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.644950] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.644954] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.644956] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.644958] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.644960] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.644961] system 00:0d: iomem range 0x100000-0xdfe5a7ff could not be reserved
[    0.644963] system 00:0d: iomem range 0xdfe5a800-0xdfefffff has been reserved
[    0.644967] system 00:0d: iomem range 0xdff00000-0xdfffffff has been reserved
[    0.644969] system 00:0d: iomem range 0xffe00000-0xffffffff has been reserved
[    0.644971] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.644973] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.644974] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.644976] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.644978] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.644980] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.644981] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.644983] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.644985] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.644987] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.644989] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.649638] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.649640] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    0.649643] pci 0000:00:01.0:   MEM window: 0xf2000000-0xf6efffff
[    0.649645] pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
[    0.649649] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.649650] pci 0000:00:1c.0:   IO window: disabled
[    0.649655] pci 0000:00:1c.0:   MEM window: disabled
[    0.649659] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.649666] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.649667] pci 0000:00:1c.1:   IO window: disabled
[    0.649673] pci 0000:00:1c.1:   MEM window: 0xf1f00000-0xf1ffffff
[    0.649677] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.649684] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:09
[    0.649685] pci 0000:00:1c.5:   IO window: disabled
[    0.649690] pci 0000:00:1c.5:   MEM window: 0xf1e00000-0xf1efffff
[    0.649694] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.649706] pci 0000:03:01.0: CardBus bridge, secondary bus 0000:04
[    0.649708] pci 0000:03:01.0:   IO window: 0x002000-0x0020ff
[    0.649713] pci 0000:03:01.0:   IO window: 0x002400-0x0024ff
[    0.649717] pci 0000:03:01.0:   PREFETCH window: 0x120000000-0x123ffffff
[    0.649722] pci 0000:03:01.0:   MEM window: 0x124000000-0x127ffffff
[    0.649727] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.649730] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.649735] pci 0000:00:1e.0:   MEM window: 0xf1d00000-0xf1dfffff
[    0.649739] pci 0000:00:1e.0:   PREFETCH window: 0x00000120000000-0x00000123ffffff
[    0.649752] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.649755] pci 0000:00:01.0: setting latency timer to 64
[    0.649762] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.649766] pci 0000:00:1c.0: setting latency timer to 64
[    0.649774] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.649778] pci 0000:00:1c.1: setting latency timer to 64
[    0.649786] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.649790] pci 0000:00:1c.5: setting latency timer to 64
[    0.649797] pci 0000:00:1e.0: setting latency timer to 64
[    0.649806] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    0.649810] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.649817] bus: 00 index 0 io port: [0x00-0xffff]
[    0.649819] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.649820] bus: 01 index 0 io port: [0xe000-0xefff]
[    0.649822] bus: 01 index 1 mmio: [0xf2000000-0xf6efffff]
[    0.649823] bus: 01 index 2 mmio: [0xe0000000-0xefffffff]
[    0.649824] bus: 01 index 3 mmio: [0x0-0x0]
[    0.649825] bus: 0b index 0 mmio: [0x0-0x0]
[    0.649826] bus: 0b index 1 mmio: [0x0-0x0]
[    0.649827] bus: 0b index 2 mmio: [0x0-0x0]
[    0.649828] bus: 0b index 3 mmio: [0x0-0x0]
[    0.649830] bus: 0c index 0 mmio: [0x0-0x0]
[    0.649831] bus: 0c index 1 mmio: [0xf1f00000-0xf1ffffff]
[    0.649832] bus: 0c index 2 mmio: [0x0-0x0]
[    0.649833] bus: 0c index 3 mmio: [0x0-0x0]
[    0.649834] bus: 09 index 0 mmio: [0x0-0x0]
[    0.649835] bus: 09 index 1 mmio: [0xf1e00000-0xf1efffff]
[    0.649837] bus: 09 index 2 mmio: [0x0-0x0]
[    0.649838] bus: 09 index 3 mmio: [0x0-0x0]
[    0.649839] bus: 03 index 0 io port: [0x2000-0x2fff]
[    0.649840] bus: 03 index 1 mmio: [0xf1d00000-0xf1dfffff]
[    0.649841] bus: 03 index 2 mmio: [0x120000000-0x123ffffff]
[    0.649843] bus: 03 index 3 io port: [0x00-0xffff]
[    0.649844] bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.649846] bus: 04 index 0 io port: [0x2000-0x20ff]
[    0.649847] bus: 04 index 1 io port: [0x2400-0x24ff]
[    0.649848] bus: 04 index 2 mmio: [0x120000000-0x123ffffff]
[    0.649849] bus: 04 index 3 mmio: [0x124000000-0x127ffffff]
[    0.649856] NET: Registered protocol family 2
[    0.684041] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.684406] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.685613] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.686008] TCP: Hash tables configured (established 262144 bind 65536)
[    0.686010] TCP reno registered
[    0.696072] NET: Registered protocol family 1
[    0.696174] checking if image is initramfs... it is
[    1.236383] Freeing initrd memory: 7774k freed
[    1.239348] audit: initializing netlink socket (disabled)
[    1.239369] type=2000 audit(1249941947.236:1): initialized
[    1.246208] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.247137] VFS: Disk quotas dquot_6.5.1
[    1.247175] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.247598] fuse init (API version 7.10)
[    1.247653] msgmni has been set to 7809
[    1.247784] alg: No test for stdrng (krng)
[    1.247792] io scheduler noop registered
[    1.247793] io scheduler anticipatory registered
[    1.247794] io scheduler deadline registered
[    1.247823] io scheduler cfq registered (default)
[    1.247987] pci 0000:01:00.0: Boot video device
[    1.300200] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.300228] pcieport-driver 0000:00:01.0: found MSI capability
[    1.300247] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    1.300255] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.300265] pci_express 0000:00:01.0:pcie02: allocate port service
[    1.300273] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.300313] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.300359] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.300390] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    1.300404] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.300415] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.300423] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.300489] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.300535] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.300565] pcieport-driver 0000:00:1c.1: irq 2301 for MSI/MSI-X
[    1.300580] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.300589] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.300597] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.300663] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.300709] pcieport-driver 0000:00:1c.5: found MSI capability
[    1.300739] pcieport-driver 0000:00:1c.5: irq 2300 for MSI/MSI-X
[    1.300754] pci_express 0000:00:1c.5:pcie00: allocate port service
[    1.300763] pci_express 0000:00:1c.5:pcie02: allocate port service
[    1.300774] pci_express 0000:00:1c.5:pcie03: allocate port service
[    1.300844] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.300924] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.301051] ACPI: AC Adapter [AC] (on-line)
[    1.328832] ACPI: Battery Slot [BAT0] (battery present)
[    1.328875] ACPI: Battery Slot [BAT1] (battery absent)
[    1.328933] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.329402] ACPI: Lid Switch [LID]
[    1.329435] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.329440] ACPI: Power Button (CM) [PBTN]
[    1.329473] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.329475] ACPI: Sleep Button (CM) [SBTN]
[    1.329975] ACPI: SSDT DFE5C4B4, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    1.330335] ACPI: SSDT DFE5BE4A, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    1.330622] Monitor-Mwait will be used to enter C-1 state
[    1.330624] Monitor-Mwait will be used to enter C-2 state
[    1.330626] Monitor-Mwait will be used to enter C-3 state
[    1.330637] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.330655] processor ACPI_CPU:00: registered as cooling_device0
[    1.330657] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.330935] ACPI: SSDT DFE5C77C, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    1.331178] ACPI: SSDT DFE5C42F, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[    1.331497] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.331510] processor ACPI_CPU:01: registered as cooling_device1
[    1.331512] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.364613] thermal LNXTHERM:01: registered as thermal_zone0
[    1.368086] ACPI: Thermal Zone [THM] (55 C)
[    1.393141] Linux agpgart interface v0.103
[    1.393147] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.393263] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.393571] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.394111] brd: module loaded
[    1.394345] loop: module loaded
[    1.394396] Fixed MDIO Bus: probed
[    1.394401] PPP generic driver version 2.4.2
[    1.394442] input: Macintosh mouse button emulation as /devices/virtual/input/input3
[    1.394460] Driver 'sd' needs updating - please use bus_type methods
[    1.394466] Driver 'sr' needs updating - please use bus_type methods
[    1.394495] ahci 0000:00:1f.2: version 3.0
[    1.394509] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.394540] ahci 0000:00:1f.2: irq 2299 for MSI/MSI-X
[    1.394614] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.394617] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
[    1.394621] ahci 0000:00:1f.2: setting latency timer to 64
[    1.394815] scsi0 : ahci
[    1.394871] scsi1 : ahci
[    1.394913] scsi2 : ahci
[    1.395110] ata1: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffb900 irq 2299
[    1.395112] ata2: DUMMY
[    1.395114] ata3: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffba00 irq 2299
[    1.712020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.712925] ata1.00: ATA-8: Hitachi HTS722016K9A300, DCDOCA1H, max UDMA/133
[    1.712927] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.714024] ata1.00: configured for UDMA/133
[    2.048018] ata3: SATA link down (SStatus 0 SControl 300)
[    2.064086] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72201 DCDO PQ: 0 ANSI: 5
[    2.064150] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.064162] sd 0:0:0:0: [sda] Write Protect is off
[    2.064164] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.064183] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.064230] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.064240] sd 0:0:0:0: [sda] Write Protect is off
[    2.064242] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.064260] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.064262]  sda: sda1 sda2 sda3
[    2.084315] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.084345] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.084381] ata_piix 0000:00:1f.1: version 2.12
[    2.084386] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.084417] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.084483] scsi3 : ata_piix
[    2.084523] scsi4 : ata_piix
[    2.086778] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    2.086780] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    2.248487] ata4.00: ATAPI: HL-DT-ST DVD+/-RW GSA-T21N, A102, max UDMA/33
[    2.264423] ata4.00: configured for UDMA/33
[    2.269740] ata5: port disabled. ignoring.
[    2.272852] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-T21N A102 PQ: 0 ANSI: 5
[    2.283777] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.283779] Uniform CD-ROM driver Revision: 3.20
[    2.283835] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.283859] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    2.284272] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.284287] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.284296] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.284299] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.284345] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.288266] ehci_hcd 0000:00:1a.7: debug port 1
[    2.288271] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    2.288281] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    2.304007] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.304053] usb usb1: configuration #1 chosen from 1 choice
[    2.304074] hub 1-0:1.0: USB hub found
[    2.304080] hub 1-0:1.0: 4 ports detected
[    2.304164] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.304172] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.304175] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.304203] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.308101] ehci_hcd 0000:00:1d.7: debug port 1
[    2.308107] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.308116] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    2.320008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.320055] usb usb2: configuration #1 chosen from 1 choice
[    2.320072] hub 2-0:1.0: USB hub found
[    2.320077] hub 2-0:1.0: 6 ports detected
[    2.320149] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.320159] uhci_hcd: USB Universal Host Controller Interface driver
[    2.320173] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.320179] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.320181] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.320212] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.320238] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    2.320293] usb usb3: configuration #1 chosen from 1 choice
[    2.320312] hub 3-0:1.0: USB hub found
[    2.320317] hub 3-0:1.0: 2 ports detected
[    2.320380] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.320385] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.320388] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.320421] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.320452] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    2.320511] usb usb4: configuration #1 chosen from 1 choice
[    2.320527] hub 4-0:1.0: USB hub found
[    2.320532] hub 4-0:1.0: 2 ports detected
[    2.320593] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.320598] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.320601] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.320628] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.320654] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    2.320712] usb usb5: configuration #1 chosen from 1 choice
[    2.320728] hub 5-0:1.0: USB hub found
[    2.320733] hub 5-0:1.0: 2 ports detected
[    2.320794] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.320799] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.320802] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.320829] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.320854] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    2.320911] usb usb6: configuration #1 chosen from 1 choice
[    2.320927] hub 6-0:1.0: USB hub found
[    2.320931] hub 6-0:1.0: 2 ports detected
[    2.320992] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.320997] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.321000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.321033] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.321058] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    2.321113] usb usb7: configuration #1 chosen from 1 choice
[    2.321131] hub 7-0:1.0: USB hub found
[    2.321136] hub 7-0:1.0: 2 ports detected
[    2.321231] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.324886] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.324890] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.336033] mice: PS/2 mouse device common for all mice
[    2.384102] rtc_cmos 00:03: RTC can wake from S4
[    2.384127] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.384157] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.384194] device-mapper: uevent: version 1.0.3
[    2.384252] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.384306] device-mapper: multipath: version 1.0.5 loaded
[    2.384308] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.384423] cpuidle: using governor ladder
[    2.384496] cpuidle: using governor menu
[    2.384785] TCP cubic registered
[    2.384830] NET: Registered protocol family 10
[    2.385116] lo: Disabled Privacy Extensions
[    2.385317] NET: Registered protocol family 17
[    2.385330] Bluetooth: L2CAP ver 2.11
[    2.385331] Bluetooth: L2CAP socket layer initialized
[    2.385333] Bluetooth: SCO (Voice Link) ver 0.6
[    2.385341] Bluetooth: SCO socket layer initialized
[    2.385369] Marking TSC unstable due to TSC halts in idle
[    2.385382] Bluetooth: RFCOMM socket layer initialized
[    2.385386] Bluetooth: RFCOMM TTY layer initialized
[    2.385387] Bluetooth: RFCOMM ver 1.10
[    2.385950] registered taskstats version 1
[    2.386034]   Magic number: 5:610:97
[    2.386110] rtc_cmos 00:03: setting system clock to 2009-08-10 22:05:49 UTC (1249941949)
[    2.386112] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.386113] EDD information not available.
[    2.386145] Freeing unused kernel memory: 532k freed
[    2.386351] Write protecting the kernel read-only data: 6688k
[    2.388077] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.539869] tg3.c:v3.94 (August 14, 2008)
[    2.539898] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.539912] tg3 0000:09:00.0: setting latency timer to 64
[    2.561503] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI Express) 10/100/1000Base-T Ethernet 00:1c:23:52:16:2d
[    2.561505] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    2.561507] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.570082] ohci1394 0000:03:01.4: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.662515] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[f1dff000-f1dff7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    2.881598] PM: Starting manual resume from disk
[    2.881600] PM: Resume from partition 8:1
[    2.881601] PM: Checking hibernation image.
[    2.881778] PM: Resume from disk failed.
[    2.902414] kjournald starting.  Commit interval 5 seconds
[    2.902421] EXT3-fs: mounted filesystem with ordered data mode.
[    3.137014] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    3.301077] usb 4-2: configuration #1 chosen from 1 choice
[    3.544048] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    3.694263] usb 7-1: configuration #1 chosen from 1 choice
[    3.696213] hub 7-1:1.0: USB hub found
[    3.698179] hub 7-1:1.0: 4 ports detected
[    3.936204] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[484fc0001fb1e070]
[    3.945055] usb 7-2: new full speed USB device using uhci_hcd and address 3
[    4.120227] usb 7-2: configuration #1 chosen from 1 choice
[    4.198189] usb 7-1.2: new full speed USB device using uhci_hcd and address 4
[    4.314255] usb 7-1.2: configuration #1 chosen from 1 choice
[    7.059011] udev: starting version 141
[    7.873390] nvidia: module license 'NVIDIA' taints kernel.
[    7.942219] usbcore: registered new interface driver usbserial
[    7.942245] USB Serial support registered for generic
[    7.942298] usbcore: registered new interface driver usbserial_generic
[    7.942299] usbserial: USB Serial Driver core
[    7.951694] USB Serial support registered for GSM modem (1-port)
[    7.951733] option 4-2:1.0: GSM modem (1-port) converter detected
[    7.951833] usb 4-2: GSM modem (1-port) converter now attached to ttyUSB0
[    7.951844] option 4-2:1.1: GSM modem (1-port) converter detected
[    7.951914] usb 4-2: GSM modem (1-port) converter now attached to ttyUSB1
[    7.951930] usbcore: registered new interface driver option
[    7.951932] option: v0.7.2:USB Driver for GSM modems
[    7.997702] iTCO_vendor_support: vendor-support=0
[    7.998789] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    7.998960] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
[    7.999029] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.075416] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.124686] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    8.125541] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.125549] nvidia 0000:01:00.0: setting latency timer to 64
[    8.126193] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.44  Tue Mar 24 05:46:32 PST 2009
[    8.141243] cfg80211: Calling CRDA to update world regulatory domain
[    8.222078] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:31/device:32/input/input6
[    8.249077] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    8.303367] cfg80211: World regulatory domain updated:
[    8.303369] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.303371] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.303372] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.303374] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.303375] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.303376] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.304248] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[    8.304273] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[    8.304275] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[    8.377360] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.433286] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    8.433289] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[    8.433292] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[    8.433299] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[    8.433301] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0xf1d00000 - 0xf1dfffff
[    8.433303] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff
[    8.456841] synaptics was reset on resume, see synaptics_resume_reset if you have trouble on resume
[    8.680195] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[    8.680227] yenta_cardbus 0000:03:01.0: Preassigned resource 2 busy or not available, reconfiguring...
[    8.680235] yenta_cardbus 0000:03:01.0: Preassigned resource 3 busy or not available, reconfiguring...
[    8.680237] yenta_cardbus 0000:03:01.0: CardBus bridge, secondary bus 0000:04
[    8.680239] yenta_cardbus 0000:03:01.0:   IO window: 0x002000-0x0020ff
[    8.680244] yenta_cardbus 0000:03:01.0:   IO window: 0x002400-0x0024ff
[    8.680249] yenta_cardbus 0000:03:01.0:   PREFETCH window: 0xf0000000-0xf03fffff
[    8.680254] yenta_cardbus 0000:03:01.0:   MEM window: 0xf0400000-0xf07fffff
[    8.680263] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[    8.680264] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[    8.787121] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
[    8.787124] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[    8.787228] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.787241] iwl3945 0000:0c:00.0: setting latency timer to 64
[    8.787292] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
[    8.787549] iwl3945 0000:0c:00.0: irq 2298 for MSI/MSI-X
[    8.811722] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.811891] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    8.811892] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    8.811893] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.813294] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    8.813297] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[    8.813337] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[    8.813339] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0xf1d00000 - 0xf1dfffff
[    8.813341] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0x120000000 - 0x123ffffff
[    8.843510] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[    8.847739] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    8.984026] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    9.069138] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    9.069188] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.357373] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input7
[    9.402055] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input8
[   10.980909] iwl3945: Radio Frequency Kill Switch is On:
[   10.980911] Kill switch must be turned off for wireless networking to work.
[   14.500164] Clocksource tsc unstable (delta = -297499755 ns)
[   16.113681] lp: driver loaded but no devices found
[   16.176771] Adding 2008084k swap on /dev/sda1.  Priority:-1 extents:1 across:2008084k
[   16.702395] EXT3 FS on sda2, internal journal
[   17.587700] type=1505 audit(1249934764.697:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=2193
[   17.613085] type=1505 audit(1249934764.725:3): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2197
[   17.613142] type=1505 audit(1249934764.725:4): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2197
[   17.613169] type=1505 audit(1249934764.725:5): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2197
[   17.613193] type=1505 audit(1249934764.725:6): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2197
[   17.683727] type=1505 audit(1249934764.793:7): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2202
[   17.683845] type=1505 audit(1249934764.793:8): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2202
[   17.700332] type=1505 audit(1249934764.813:9): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2206
[   19.959038] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.959040] Bluetooth: BNEP filters: protocol multicast
[   19.969498] Bridge firewalling registered
[   21.124006] ppdev: user-space parallel port driver
[   24.901444] tg3 0000:09:00.0: irq 2297 for MSI/MSI-X
[   24.964034] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   25.114220] iwl3945 0000:0c:00.0: firmware: requesting iwlwifi-3945-1.ucode
[   25.166306] iwl3945: Radio disabled by HW RF Kill switch

--------------020604000305040809080005
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 0c)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: f2000000-f6efffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Dell Device 01f9
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4161
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [140] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 6f20 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 6f00 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at f6ffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: f1f00000-f1ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Memory behind bridge: f1e00000-f1efffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 6f80 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 6f60 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 6f40 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f1d00000-f1dfffff
	Prefetchable memory behind bridge: 0000000120000000-0000000123ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 01f9

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 6fa0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02) (prog-if 01)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 2299
	Region 0: I/O ports at 6eb0 [size=8]
	Region 1: I/O ports at 6eb8 [size=4]
	Region 2: I/O ports at 6ec0 [size=8]
	Region 3: I/O ports at 6ec8 [size=4]
	Region 4: I/O ports at 6ee0 [size=32]
	Region 5: Memory at f6ffb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
		Address: fee0300c  Data: 4189
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 3
	Region 0: Memory at f6ffb700 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 10c0 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 135M (rev a1)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f2000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ef00 [size=128]
	[virtual] Expansion ROM at f4000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f1d00000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 24000000-27fff000
	I/O window 0: 00002000-000020ff
	I/O window 1: 00002400-000024ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f1dff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at f1dfe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 2297
	Region 0: Memory at f1ef0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data <?>
	Capabilities: [58] Vendor Specific Information <?>
	Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41b1
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [13c] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 2d-16-52-fe-ff-23-1c-00
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: tg3
	Kernel modules: tg3

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
	Subsystem: Intel Corporation Device 1021
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 2298
	Region 0: Memory at f1fff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41a9
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number 97-9c-75-ff-ff-3c-1f-00
	Kernel driver in use: iwl3945
	Kernel modules: iwl3945


--------------020604000305040809080005
Content-Type: application/x-troff-man;
 name="lspci.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.2"

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 0c)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: f2000000-f6efffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Dell Device 01f9
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4161
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [140] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 6f20 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 6f00 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at f6ffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: f1f00000-f1ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Memory behind bridge: f1e00000-f1efffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  3, PowerLimit 6.500000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Dell Device 01f9
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 6f80 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 6f60 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 6f40 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f1d00000-f1dfffff
	Prefetchable memory behind bridge: 0000000120000000-0000000123ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 01f9

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 6fa0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 02) (prog-if 01)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 2299
	Region 0: I/O ports at 6eb0 [size=8]
	Region 1: I/O ports at 6eb8 [size=4]
	Region 2: I/O ports at 6ec0 [size=8]
	Region 3: I/O ports at 6ec8 [size=4]
	Region 4: I/O ports at 6ee0 [size=32]
	Region 5: Memory at f6ffb800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/2 Enable+
		Address: fee0300c  Data: 4189
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 3
	Region 0: Memory at f6ffb700 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 10c0 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 135M (rev a1)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f2000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ef00 [size=128]
	[virtual] Expansion ROM at f4000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f1d00000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: f0000000-f03ff000 (prefetchable)
	Memory window 1: f0400000-f07ff000
	I/O window 0: 00002000-000020ff
	I/O window 1: 00002400-000024ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10)
	Subsystem: Dell Device 01f9
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f1dff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at f1dfe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
	Subsystem: Dell Device 01f9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 2297
	Region 0: Memory at f1ef0000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data <?>
	Capabilities: [58] Vendor Specific Information <?>
	Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41b1
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [13c] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 2d-16-52-fe-ff-23-1c-00
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: tg3
	Kernel modules: tg3

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
	Subsystem: Intel Corporation Device 1021
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 2298
	Region 0: Memory at f1fff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
		Address: 00000000fee0300c  Data: 41a9
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Device Serial Number 97-9c-75-ff-ff-3c-1f-00
	Kernel driver in use: iwl3945
	Kernel modules: iwl3945


--------------020604000305040809080005
Content-Type: text/plain;
 name="proc.iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proc.iomem"

00000000-00000fff : System RAM
00001000-00005fff : reserved
00006000-00007fff : System RAM
00008000-0000ffff : reserved
00010000-00091fff : System RAM
0009f000-0009ffff : reserved
000c0000-000cffff : pnp 00:0d
000e0000-000fffff : pnp 00:0d
00100000-dfe5a7ff : System RAM
  00200000-006a32fe : Kernel code
  006a32ff-0091a2ff : Kernel data
  00a67000-00b7bbaf : Kernel bss
dfe5a800-dfffffff : reserved
  dfe5a800-dfefffff : pnp 00:0d
  dff00000-dfffffff : pnp 00:0d
e0000000-efffffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
f1d00000-f1dfffff : PCI Bus 0000:03
  f1d00000-f1d00fff : 0000:03:01.0
    f1d00000-f1d00fff : yenta_socket
  f1dfe800-f1dfefff : 0000:03:01.4
  f1dff000-f1dfffff : 0000:03:01.4
    f1dff000-f1dff7ff : ohci1394
f1e00000-f1efffff : PCI Bus 0000:09
  f1ef0000-f1efffff : 0000:09:00.0
    f1ef0000-f1efffff : tg3
f1f00000-f1ffffff : PCI Bus 0000:0c
  f1fff000-f1ffffff : 0000:0c:00.0
    f1fff000-f1ffffff : iwl3945
f2000000-f6efffff : PCI Bus 0000:01
  f2000000-f3ffffff : 0000:01:00.0
  f4000000-f401ffff : 0000:01:00.0
  f5000000-f5ffffff : 0000:01:00.0
    f5000000-f5ffffff : nvidia
f6ffb700-f6ffb7ff : 0000:00:1f.3
f6ffb800-f6ffbfff : 0000:00:1f.2
  f6ffb800-f6ffbfff : ahci
f6ffc000-f6ffffff : 0000:00:1b.0
  f6ffc000-f6ffffff : ICH HD audio
f8000000-fbffffff : PCI MMCONFIG 0
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:0d
fec00000-fec0ffff : reserved
  fec00000-fec0ffff : pnp 00:0d
    fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:08
fed18000-fed1bfff : reserved
  fed18000-fed1bfff : pnp 00:0d
fed1c000-fed1c3ff : 0000:00:1d.7
  fed1c000-fed1c3ff : ehci_hcd
fed1c400-fed1c7ff : 0000:00:1a.7
  fed1c400-fed1c7ff : ehci_hcd
fed20000-fed8ffff : reserved
  fed20000-fed3ffff : pnp 00:0d
  fed40000-fed44fff : pnp 00:0a
  fed45000-fed8ffff : pnp 00:0d
feda0000-feda5fff : reserved
  feda0000-feda3fff : pnp 00:0d
  feda4000-feda4fff : pnp 00:0d
  feda5000-feda5fff : pnp 00:0d
feda6000-feda6fff : pnp 00:0d
fee00000-fee0ffff : reserved
  fee00000-fee0ffff : pnp 00:0d
    fee00000-fee00fff : Local APIC
ffa00000-ffbfffff : pnp 00:0d
ffe00000-ffffffff : reserved
  ffe00000-ffffffff : pnp 00:0d
100002000-11fffffff : System RAM
120000000-123ffffff : PCI Bus 0000:03
  120000000-123ffffff : PCI CardBus 0000:04
124000000-127ffffff : PCI CardBus 0000:04

--------------020604000305040809080005
Content-Type: application/x-troff-man;
 name="proc.iomem.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proc.iomem.2"

00000000-00000fff : System RAM
00001000-00005fff : reserved
00006000-00007fff : System RAM
00008000-0000ffff : reserved
00010000-00091fff : System RAM
0009f000-0009ffff : reserved
000c0000-000cffff : pnp 00:0d
000e0000-000fffff : pnp 00:0d
00100000-dfe5a7ff : System RAM
  00200000-006a32fe : Kernel code
  006a32ff-0091a2ff : Kernel data
  00a67000-00b7bbaf : Kernel bss
dfe5a800-dfffffff : reserved
  dfe5a800-dfefffff : pnp 00:0d
  dff00000-dfffffff : pnp 00:0d
e0000000-efffffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
f0000000-f03fffff : PCI CardBus 0000:04
f0400000-f07fffff : PCI CardBus 0000:04
f1d00000-f1dfffff : PCI Bus 0000:03
  f1d00000-f1d00fff : 0000:03:01.0
    f1d00000-f1d00fff : yenta_socket
  f1dfe800-f1dfefff : 0000:03:01.4
  f1dff000-f1dfffff : 0000:03:01.4
    f1dff000-f1dff7ff : ohci1394
f1e00000-f1efffff : PCI Bus 0000:09
  f1ef0000-f1efffff : 0000:09:00.0
    f1ef0000-f1efffff : tg3
f1f00000-f1ffffff : PCI Bus 0000:0c
  f1fff000-f1ffffff : 0000:0c:00.0
    f1fff000-f1ffffff : iwl3945
f2000000-f6efffff : PCI Bus 0000:01
  f2000000-f3ffffff : 0000:01:00.0
  f4000000-f401ffff : 0000:01:00.0
  f5000000-f5ffffff : 0000:01:00.0
    f5000000-f5ffffff : nvidia
f6ffb700-f6ffb7ff : 0000:00:1f.3
f6ffb800-f6ffbfff : 0000:00:1f.2
  f6ffb800-f6ffbfff : ahci
f6ffc000-f6ffffff : 0000:00:1b.0
  f6ffc000-f6ffffff : ICH HD audio
f8000000-fbffffff : PCI MMCONFIG 0
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:0d
fec00000-fec0ffff : reserved
  fec00000-fec0ffff : pnp 00:0d
    fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:08
fed18000-fed1bfff : reserved
  fed18000-fed1bfff : pnp 00:0d
fed1c000-fed1c3ff : 0000:00:1d.7
  fed1c000-fed1c3ff : ehci_hcd
fed1c400-fed1c7ff : 0000:00:1a.7
  fed1c400-fed1c7ff : ehci_hcd
fed20000-fed8ffff : reserved
  fed20000-fed3ffff : pnp 00:0d
  fed40000-fed44fff : pnp 00:0a
  fed45000-fed8ffff : pnp 00:0d
feda0000-feda5fff : reserved
  feda0000-feda3fff : pnp 00:0d
  feda4000-feda4fff : pnp 00:0d
  feda5000-feda5fff : pnp 00:0d
feda6000-feda6fff : pnp 00:0d
fee00000-fee0ffff : reserved
  fee00000-fee0ffff : pnp 00:0d
    fee00000-fee00fff : Local APIC
ffa00000-ffbfffff : pnp 00:0d
ffe00000-ffffffff : reserved
  ffe00000-ffffffff : pnp 00:0d
100002000-11fffffff : System RAM
120000000-123ffffff : PCI Bus 0000:03

--------------020604000305040809080005--

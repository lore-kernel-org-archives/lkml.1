Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYL2JlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYL2JlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYL2JlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:41:12 -0500
Received: from mx04.mailboxcop.com ([206.125.223.74]:37505 "EHLO
	mx04.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYL2JlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:41:06 -0500
X-Greylist: delayed 4765 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 04:41:05 EST
Message-ID: <495888FD.6060907@jaysonking.com>
Date: Mon, 29 Dec 2008 02:23:25 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: problem with "sched: revert back to per-rq vruntime"?
Content-Type: multipart/mixed;
 boundary="------------020907070802010902080207"
X-Canit-CHI2: 0.50
X-Bayes-Prob: 0.9999 (Score 4, tokens from: @@RPTN, outgoing)
X-Spam-Score: 4.10 (****) [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2),Bayes(0.9999,4.0)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 332338134 - a924fb3f7647
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=332338134&m=a924fb3f7647&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=332338134&m=a924fb3f7647&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=332338134&m=a924fb3f7647&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020907070802010902080207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Greetings,
(please CC replies to me)

After upgrading to 2.6.28 I noticed some latency problems. Mostly, bash 
and other programs would take a second or so to start where earlier it 
would start almost instantly. I have some nice'd tasks that use 100% of 
the CPU on each core of the Core 2 duo, and killing these tasks make the 
latency go away. But with older kernels these tasks did not cause 
latency problems.

I bisected it to f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3 
"sched: revert back to per-rq vruntime," and reverting it from 2.6.28 
fixes the latency.

Here is config and dmesg output of vanilla 2.6.28. System is x86_64 
Fedora 10. Let me know if there is additional details I can provide. Thanks.

Jayson

--------------020907070802010902080207
Content-Type: text/plain;
 name="dmesg-2.6.28"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-2.6.28"

[    0.000000] BIOS EBDA/lowmem at: 0009e000/0009e000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28 (jayson@atlas) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #1 SMP Mon Dec 29 01:24:58 CST 2008
[    0.000000] Command line: ro root=/dev/Group081209/root apm=off noresume
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
[    0.000000]  BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.5 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x7fee0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007fee0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fee0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fee0000 @ 10000-14000
[    0.000000] last_map_addr: 7fee0000 end: 7fee0000
[    0.000000] RAMDISK: 37bf3000 - 37fefc2a
[    0.000000] ACPI: RSDP 000F78B0, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 7FEE3000, 0034 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 7FEE3080, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 7FEE3100, 4EC3 (r1 INTELR AWRDACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS 7FEE0000, 0040
[    0.000000] ACPI: MCFG 7FEE80C0, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 7FEE8000, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: SSDT 7FEE8760, 0380 (r1  PmRef    CpuPm     3000 INTL 20041203)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fee0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007fee0000
[    0.000000]   NODE_DATA [0000000000012000 - 0000000000016fff]
[    0.000000]   bootmap [0000000000017000 -  0000000000026fdf] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fee0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b212ec]    TEXT DATA BSS ==> [0000200000 - 0000b212ec]
[    0.000000]   #3 [0037bf3000 - 0037fefc2a]          RAMDISK ==> [0037bf3000 - 0037fefc2a]
[    0.000000]   #4 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000f3930] 000f3930
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007fee0
[    0.000000] On node 0 totalpages: 523886
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2442 pages reserved
[    0.000000]   DMA zone: 1484 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7109 pages used for memmap
[    0.000000]   DMA32 zone: 512795 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
[    0.000000] PERCPU: Allocating 57344 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000001010000
[    0.000000] per cpu data for cpu1 on node0 at 000000000101e000
[    0.000000] per cpu data for cpu2 on node0 at 000000000102c000
[    0.000000] per cpu data for cpu3 on node0 at 000000000103a000
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514279
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/Group081209/root apm=off noresume
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 3399.980 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Calgary: detecting Calgary via BIOS EBDA area
[    0.000999] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000999] Memory: 2052988k/2096000k available (4557k kernel code, 456k absent, 42556k reserved, 2838k data, 524k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.001007] Calibrating delay loop (skipped), value calculated using timer frequency.. 6799.96 BogoMIPS (lpj=3399980)
[    0.001542] Security Framework initialized
[    0.001801] SELinux:  Initializing.
[    0.002007] SELinux:  Starting in permissive mode
[    0.002143] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003370] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004024] Mount-cache hash table entries: 256
[    0.004390] Initializing cgroup subsys ns
[    0.004647] Initializing cgroup subsys cpuacct
[    0.004915] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005002] CPU: L2 cache: 4096K
[    0.005254] CPU 0/0x0 -> Node 0
[    0.005506] CPU: Physical Processor ID: 0
[    0.005761] CPU: Processor Core ID: 0
[    0.006001] using mwait in idle threads.
[    0.006268] ACPI: Core revision 20080926
[    0.012036] Setting APIC routing to flat
[    0.013354] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023621] CPU0: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.023996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 6798.89 BogoMIPS (lpj=3399445)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.094858] CPU1: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.095285] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.096007] Brought up 2 CPUs
[    0.096987] Total of 2 processors activated (13598.85 BogoMIPS).
[    0.097311] khelper used greatest stack depth: 6000 bytes left
[    0.097311] net_namespace: 1344 bytes
[    0.098060] Time:  7:36:47  Date: 12/29/08
[    0.098282] NET: Registered protocol family 16
[    0.098547] ACPI: bus type pci registered
[    0.099014] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.099275] PCI: MCFG area at e0000000 reserved in E820
[    0.105458] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.105717] PCI: Using configuration type 1 for base access
[    0.109359] ACPI: EC: Look up EC in DSDT
[    0.113763] ACPI: Interpreter enabled
[    0.113984] ACPI: (supports S0 S1 S4 S5)
[    0.114362] ACPI: Using IOAPIC for interrupt routing
[    0.117986] ACPI: No dock devices found.
[    0.118245] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.118520] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.118520] pci 0000:00:01.0: PME# disabled
[    0.119029] pci 0000:00:1a.0: reg 20 io port: [0xff00-0xff1f]
[    0.119072] pci 0000:00:1a.1: reg 20 io port: [0xfe00-0xfe1f]
[    0.119114] pci 0000:00:1a.2: reg 20 io port: [0xfd00-0xfd1f]
[    0.119151] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfdfff000-0xfdfff3ff]
[    0.119179] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.119443] pci 0000:00:1a.7: PME# disabled
[    0.119721] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfdff4000-0xfdff7fff]
[    0.119740] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.119984] pci 0000:00:1b.0: PME# disabled
[    0.120267] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.120530] pci 0000:00:1c.0: PME# disabled
[    0.120815] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.120983] pci 0000:00:1c.1: PME# disabled
[    0.121268] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.121532] pci 0000:00:1c.2: PME# disabled
[    0.122019] pci 0000:00:1d.0: reg 20 io port: [0xfc00-0xfc1f]
[    0.122062] pci 0000:00:1d.1: reg 20 io port: [0xfb00-0xfb1f]
[    0.122105] pci 0000:00:1d.2: reg 20 io port: [0xfa00-0xfa1f]
[    0.122141] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdffe000-0xfdffe3ff]
[    0.122168] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.122432] pci 0000:00:1d.7: PME# disabled
[    0.122768] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.122771] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.122983] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.123282] pci 0000:00:1f.2: reg 10 io port: [0xf900-0xf907]
[    0.123286] pci 0000:00:1f.2: reg 14 io port: [0xf800-0xf803]
[    0.123289] pci 0000:00:1f.2: reg 18 io port: [0xf700-0xf707]
[    0.123293] pci 0000:00:1f.2: reg 1c io port: [0xf600-0xf603]
[    0.123297] pci 0000:00:1f.2: reg 20 io port: [0xf500-0xf51f]
[    0.123300] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffd000-0xfdffd7ff]
[    0.123310] pci 0000:00:1f.2: PME# supported from D3hot
[    0.123570] pci 0000:00:1f.2: PME# disabled
[    0.123999] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfdffc000-0xfdffc0ff]
[    0.124008] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.124036] pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.124041] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.124047] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
[    0.124050] pci 0000:01:00.0: reg 24 io port: [0x9f00-0x9f7f]
[    0.124053] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.124082] pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
[    0.124084] pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
[    0.124087] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.124113] pci 0000:00:1c.0: bridge io port: [0xd000-0xdfff]
[    0.124116] pci 0000:00:1c.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.124119] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfd900000-0xfd9fffff]
[    0.124164] pci 0000:03:00.0: reg 10 io port: [0xcf00-0xcf07]
[    0.124171] pci 0000:03:00.0: reg 14 io port: [0xce00-0xce03]
[    0.124178] pci 0000:03:00.0: reg 18 io port: [0xcd00-0xcd07]
[    0.124186] pci 0000:03:00.0: reg 1c io port: [0xcc00-0xcc03]
[    0.124193] pci 0000:03:00.0: reg 20 io port: [0xcb00-0xcb0f]
[    0.124206] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.124251] pci 0000:00:1c.1: bridge io port: [0xc000-0xcfff]
[    0.124253] pci 0000:00:1c.1: bridge 32bit mmio: [0xfd800000-0xfd8fffff]
[    0.124257] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xfd700000-0xfd7fffff]
[    0.124302] pci 0000:04:00.0: reg 10 64bit mmio: [0xfdefc000-0xfdefffff]
[    0.124309] pci 0000:04:00.0: reg 18 io port: [0xae00-0xaeff]
[    0.124329] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.124338] pci 0000:04:00.0: supports D1 D2
[    0.124339] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124607] pci 0000:04:00.0: PME# disabled
[    0.125009] pci 0000:00:1c.2: bridge io port: [0xa000-0xafff]
[    0.125012] pci 0000:00:1c.2: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.125016] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.125043] pci 0000:05:03.0: reg 10 io port: [0xbf00-0xbf7f]
[    0.125047] pci 0000:05:03.0: reg 14 32bit mmio: [0xfdbff000-0xfdbff07f]
[    0.125066] pci 0000:05:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.125073] pci 0000:05:03.0: supports D1 D2
[    0.125074] pci 0000:05:03.0: PME# supported from D1 D2 D3hot
[    0.125337] pci 0000:05:03.0: PME# disabled
[    0.125621] pci 0000:00:1e.0: transparent bridge
[    0.125879] pci 0000:00:1e.0: bridge io port: [0xb000-0xbfff]
[    0.125881] pci 0000:00:1e.0: bridge 32bit mmio: [0xfdb00000-0xfdbfffff]
[    0.125885] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xfda00000-0xfdafffff]
[    0.125902] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.126105] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.126178] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.126251] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.126326] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.134414] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 7 9 10 11 12)
[    0.135413] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.136052] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 9 10 11 12)
[    0.136676] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.137292] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.138055] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 *7 9 10 11 12)
[    0.138678] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 *4 5 7 9 10 11 12)
[    0.139438] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12)
[    0.140016] SCSI subsystem initialized
[    0.140242] libata version 3.00 loaded.
[    0.140242] usbcore: registered new interface driver usbfs
[    0.140249] usbcore: registered new interface driver hub
[    0.140988] usbcore: registered new device driver usb
[    0.141240] PCI: Using ACPI for IRQ routing
[    0.148997] cfg80211: Using static regulatory domain info
[    0.149253] cfg80211: Regulatory domain: US
[    0.149508] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.149978] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.150243] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.150509] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.150775] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.150977] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.151977] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.152244] cfg80211: Calling CRDA for country: US
[    0.152504] NetLabel: Initializing
[    0.152504] NetLabel:  domain hash size = 128
[    0.152977] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.153242] NetLabel:  unlabeled traffic allowed by default
[    0.153582] hpet clockevent registered
[    0.153584] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.153981] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.154382] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.158996] pnp: PnP ACPI init
[    0.159255] ACPI: bus type pnp registered
[    0.161126] pnp: PnP ACPI: found 10 devices
[    0.161380] ACPI: ACPI bus type pnp unregistered
[    0.161641] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.161905] system 00:01: ioport range 0x290-0x30f has been reserved
[    0.162177] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.162444] system 00:06: ioport range 0x400-0x4bf could not be reserved
[    0.162711] system 00:08: iomem range 0xe0000000-0xefffffff has been reserved
[    0.162980] system 00:09: iomem range 0xf0000-0xfffff could not be reserved
[    0.163249] system 00:09: iomem range 0x7ff00000-0x7fffffff has been reserved
[    0.163516] system 00:09: iomem range 0x7fee0000-0x7fefffff could not be reserved
[    0.163994] system 00:09: iomem range 0x0-0x9ffff could not be reserved
[    0.164261] system 00:09: iomem range 0x100000-0x7fedffff could not be reserved
[    0.164738] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.165006] system 00:09: iomem range 0xfed14000-0xfed1dfff has been reserved
[    0.165274] system 00:09: iomem range 0xfed20000-0xfed9ffff has been reserved
[    0.165541] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.165808] system 00:09: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.166077] system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
[    0.166345] system 00:09: iomem range 0xe0000-0xeffff has been reserved
[    0.171443] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.171706] pci 0000:00:01.0:   IO window: 0x9000-0x9fff
[    0.171966] pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff
[    0.172231] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.172711] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.172972] pci 0000:00:1c.0:   IO window: 0xd000-0xdfff
[    0.173236] pci 0000:00:1c.0:   MEM window: 0xfdc00000-0xfdcfffff
[    0.173499] pci 0000:00:1c.0:   PREFETCH window: 0x000000fd900000-0x000000fd9fffff
[    0.173978] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.174243] pci 0000:00:1c.1:   IO window: 0xc000-0xcfff
[    0.174504] pci 0000:00:1c.1:   MEM window: 0xfd800000-0xfd8fffff
[    0.174768] pci 0000:00:1c.1:   PREFETCH window: 0x000000fd700000-0x000000fd7fffff
[    0.175251] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.175513] pci 0000:00:1c.2:   IO window: 0xa000-0xafff
[    0.175775] pci 0000:00:1c.2:   MEM window: 0xfde00000-0xfdefffff
[    0.176040] pci 0000:00:1c.2:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
[    0.176520] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.176783] pci 0000:00:1e.0:   IO window: 0xb000-0xbfff
[    0.177046] pci 0000:00:1e.0:   MEM window: 0xfdb00000-0xfdbfffff
[    0.177310] pci 0000:00:1e.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
[    0.177793] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.178061] pci 0000:00:01.0: setting latency timer to 64
[    0.178065] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.178332] pci 0000:00:1c.0: setting latency timer to 64
[    0.178337] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.178602] pci 0000:00:1c.1: setting latency timer to 64
[    0.178606] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.178873] pci 0000:00:1c.2: setting latency timer to 64
[    0.178877] pci 0000:00:1e.0: setting latency timer to 64
[    0.178879] bus: 00 index 0 io port: [0x00-0xffff]
[    0.179138] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.179400] bus: 01 index 0 io port: [0x9000-0x9fff]
[    0.179658] bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
[    0.179917] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.180178] bus: 01 index 3 mmio: [0x0-0x0]
[    0.180433] bus: 02 index 0 io port: [0xd000-0xdfff]
[    0.180690] bus: 02 index 1 mmio: [0xfdc00000-0xfdcfffff]
[    0.180950] bus: 02 index 2 mmio: [0xfd900000-0xfd9fffff]
[    0.181211] bus: 02 index 3 mmio: [0x0-0x0]
[    0.181466] bus: 03 index 0 io port: [0xc000-0xcfff]
[    0.181723] bus: 03 index 1 mmio: [0xfd800000-0xfd8fffff]
[    0.181984] bus: 03 index 2 mmio: [0xfd700000-0xfd7fffff]
[    0.182244] bus: 03 index 3 mmio: [0x0-0x0]
[    0.182499] bus: 04 index 0 io port: [0xa000-0xafff]
[    0.182757] bus: 04 index 1 mmio: [0xfde00000-0xfdefffff]
[    0.183018] bus: 04 index 2 mmio: [0xfdd00000-0xfddfffff]
[    0.183278] bus: 04 index 3 mmio: [0x0-0x0]
[    0.183533] bus: 05 index 0 io port: [0xb000-0xbfff]
[    0.183790] bus: 05 index 1 mmio: [0xfdb00000-0xfdbfffff]
[    0.184052] bus: 05 index 2 mmio: [0xfda00000-0xfdafffff]
[    0.184311] bus: 05 index 3 io port: [0x00-0xffff]
[    0.184568] bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.184834] NET: Registered protocol family 2
[    0.195148] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.195812] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.197343] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.197962] TCP: Hash tables configured (established 262144 bind 65536)
[    0.198232] TCP reno registered
[    0.201187] NET: Registered protocol family 1
[    0.201521] checking if image is initramfs... it is
[    0.369406] Freeing initrd memory: 4083k freed
[    0.370876] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.371514] audit: initializing netlink socket (disabled)
[    0.371787] type=2000 audit(1230536207.371:1): initialized
[    0.376424] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.378177] VFS: Disk quotas dquot_6.5.1
[    0.378476] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.379201] msgmni has been set to 4017
[    0.379511] SELinux:  Registering netfilter hooks
[    0.379708] alg: No test for stdrng (krng)
[    0.380025] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.380503] io scheduler noop registered
[    0.380756] io scheduler anticipatory registered
[    0.381015] io scheduler deadline registered
[    0.381332] io scheduler cfq registered (default)
[    0.381598] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
[    0.381600] pci 0000:00:1a.0: Performing full reset
[    0.381612] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.381613] pci 0000:00:1a.1: Performing full reset
[    0.381626] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.381627] pci 0000:00:1a.2: Performing full reset
[    0.381656] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x003b
[    0.381657] pci 0000:00:1d.0: Performing full reset
[    0.381670] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
[    0.381671] pci 0000:00:1d.1: Performing full reset
[    0.381683] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
[    0.381684] pci 0000:00:1d.2: Performing full reset
[    0.381715] pci 0000:01:00.0: Boot video device
[    0.383808] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.383824] pcieport-driver 0000:00:01.0: found MSI capability
[    0.384097] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    0.384102] pci_express 0000:00:01.0:pcie00: allocate port service
[    0.384125] pci_express 0000:00:01.0:pcie03: allocate port service
[    0.384164] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.384185] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.384461] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    0.384468] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.384489] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.384510] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.384558] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.384579] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.384853] pcieport-driver 0000:00:1c.1: irq 2301 for MSI/MSI-X
[    0.384864] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.384885] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.384906] pci_express 0000:00:1c.1:pcie03: allocate port service
[    0.384955] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.384976] pcieport-driver 0000:00:1c.2: found MSI capability
[    0.385251] pcieport-driver 0000:00:1c.2: irq 2300 for MSI/MSI-X
[    0.385259] pci_express 0000:00:1c.2:pcie00: allocate port service
[    0.385281] pci_express 0000:00:1c.2:pcie02: allocate port service
[    0.385301] pci_express 0000:00:1c.2:pcie03: allocate port service
[    0.385382] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.385753] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.386233] ACPI: Power Button (FF) [PWRF]
[    0.386530] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.387013] ACPI: Power Button (CM) [PWRB]
[    0.387322] fan PNP0C0B:00: registered as cooling_device0
[    0.387584] ACPI: Fan [FAN] (on)
[    0.388074] ACPI: SSDT 7FEE8140, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20041203)
[    0.388742] processor ACPI_CPU:00: registered as cooling_device1
[    0.389158] ACPI: SSDT 7FEE8600, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
[    0.389817] processor ACPI_CPU:01: registered as cooling_device2
[    0.594703] thermal LNXTHERM:01: registered as thermal_zone0
[    0.655930] Switched to high resolution mode on CPU 1
[    0.656160] Switched to high resolution mode on CPU 0
[    0.993205] ACPI: Thermal Zone [THRM] (28 C)
[    1.001281] Non-volatile memory driver v1.2
[    1.001537] Linux agpgart interface v0.103
[    1.001846] [drm] Initialized drm 1.1.0 20060810
[    1.002139] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.003560] brd: module loaded
[    1.004253] loop: module loaded
[    1.004503] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    1.004767] Copyright (c) 1999-2006 Intel Corporation.
[    1.005053] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    1.005318] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.005623] sky2 driver version 1.22
[    1.005889] sky2 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.006167] sky2 0000:04:00.0: setting latency timer to 64
[    1.006186] sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
[    1.038584] sky2 0000:04:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
[    1.039061]  Part Number: Yukon 88E8056
[    1.039062]  Engineering Level: Rev. 1.3
[    1.039063]  Manufacturer: Marvell
[    1.039104] sky2 0000:04:00.0: irq 2299 for MSI/MSI-X
[    1.039269] sky2 eth0: addr 00:50:8d:9f:38:ab
[    1.039613] console [netcon0] enabled
[    1.039866] netconsole: network logging started
[    1.040166] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.040688] Loading iSCSI transport class v2.0-870.
[    1.041068] Driver 'sd' needs updating - please use bus_type methods
[    1.041370] Driver 'sr' needs updating - please use bus_type methods
[    1.041683] ahci 0000:00:1f.2: version 3.0
[    1.041691] ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.041970] ahci 0000:00:1f.2: irq 2298 for MSI/MSI-X
[    1.042015] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.042499] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ems 
[    1.042977] ahci 0000:00:1f.2: setting latency timer to 64
[    1.043202] scsi0 : ahci
[    1.043528] scsi1 : ahci
[    1.043834] scsi2 : ahci
[    1.044142] scsi3 : ahci
[    1.044448] scsi4 : ahci
[    1.044754] scsi5 : ahci
[    1.045109] ata1: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd100 irq 2298
[    1.045589] ata2: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd180 irq 2298
[    1.046067] ata3: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd200 irq 2298
[    1.046546] ata4: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd280 irq 2298
[    1.047024] ata5: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd300 irq 2298
[    1.047503] ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd380 irq 2298
[    1.352022] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.397759] ata1.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
[    1.398029] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.456077] ata1.00: configured for UDMA/133
[    2.179019] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.221839] ata2.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
[    2.222105] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.280168] ata2.00: configured for UDMA/133
[    2.585017] ata3: SATA link down (SStatus 0 SControl 300)
[    2.890017] ata4: SATA link down (SStatus 0 SControl 300)
[    3.195017] ata5: SATA link down (SStatus 0 SControl 300)
[    3.500017] ata6: SATA link down (SStatus 0 SControl 300)
[    3.500345] scsi 0:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
[    3.500928] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    3.501417] sd 0:0:0:0: [sda] Write Protect is off
[    3.501675] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.501689] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.502216] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    3.502703] sd 0:0:0:0: [sda] Write Protect is off
[    3.502960] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.502974] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.503464]  sda: sda1 sda2
[    3.520382] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.520692] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.521013] scsi 1:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
[    3.521582] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    3.522067] sd 1:0:0:0: [sdb] Write Protect is off
[    3.522326] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.522340] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.522849] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    3.523337] sd 1:0:0:0: [sdb] Write Protect is off
[    3.523595] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.523609] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.524093]  sdb: sdb1 sdb2
[    3.544839] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.545145] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.545624] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.545890] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    3.545903] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.546181] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.546183] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.546474] drivers/usb/core/inode.c: creating file 'devices'
[    3.546477] drivers/usb/core/inode.c: creating file '001'
[    3.546508] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.546989] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    3.546992] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    3.547007] ehci_hcd 0000:00:1a.7: reset command 080012 (park)=0 ithresh=8 Periodic period=1024 Reset HALT
[    3.550891] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.550892] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    3.550900] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
[    3.551165] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.555036] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.561013] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.561295] usb usb1: default language 0x0409
[    3.561315] usb usb1: uevent
[    3.561334] usb usb1: usb_probe_device
[    3.561336] usb usb1: configuration #1 chosen from 1 choice
[    3.561598] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    3.561608] usb 1-0:1.0: uevent
[    3.561626] hub 1-0:1.0: usb_probe_interface
[    3.561627] hub 1-0:1.0: usb_probe_interface - got id
[    3.561629] hub 1-0:1.0: USB hub found
[    3.561885] hub 1-0:1.0: 6 ports detected
[    3.562141] hub 1-0:1.0: standalone hub
[    3.562142] hub 1-0:1.0: no power switching (usb 1.0)
[    3.562143] hub 1-0:1.0: individual port over-current protection
[    3.562144] hub 1-0:1.0: power on to power good time: 20ms
[    3.562147] hub 1-0:1.0: local power source is good
[    3.562148] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    3.562207] drivers/usb/core/inode.c: creating file '001'
[    3.562242] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.562508] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.562985] usb usb1: Product: EHCI Host Controller
[    3.563244] usb usb1: Manufacturer: Linux 2.6.28 ehci_hcd
[    3.563504] usb usb1: SerialNumber: 0000:00:1a.7
[    3.563770] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.564045] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.564047] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.564328] drivers/usb/core/inode.c: creating file '002'
[    3.564356] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.564836] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    3.564838] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
[    3.564849] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.568745] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.568746] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    3.568754] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
[    3.569018] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    3.572891] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[    3.578013] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.578293] usb usb2: default language 0x0409
[    3.578314] usb usb2: uevent
[    3.578333] usb usb2: usb_probe_device
[    3.578334] usb usb2: configuration #1 chosen from 1 choice
[    3.578597] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    3.578605] usb 2-0:1.0: uevent
[    3.578623] hub 2-0:1.0: usb_probe_interface
[    3.578624] hub 2-0:1.0: usb_probe_interface - got id
[    3.578625] hub 2-0:1.0: USB hub found
[    3.578880] hub 2-0:1.0: 6 ports detected
[    3.579137] hub 2-0:1.0: standalone hub
[    3.579138] hub 2-0:1.0: no power switching (usb 1.0)
[    3.579139] hub 2-0:1.0: individual port over-current protection
[    3.579140] hub 2-0:1.0: power on to power good time: 20ms
[    3.579142] hub 2-0:1.0: local power source is good
[    3.579143] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    3.579185] drivers/usb/core/inode.c: creating file '001'
[    3.579218] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.579484] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.579960] usb usb2: Product: EHCI Host Controller
[    3.580220] usb usb2: Manufacturer: Linux 2.6.28 ehci_hcd
[    3.580479] usb usb2: SerialNumber: 0000:00:1d.7
[    3.580757] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.581022] ohci_hcd: block sizes: ed 80 td 96
[    3.581044] uhci_hcd: USB Universal Host Controller Interface driver
[    3.581322] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.581591] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.581593] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.581875] drivers/usb/core/inode.c: creating file '003'
[    3.581902] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.582384] uhci_hcd 0000:00:1a.0: detected 2 ports
[    3.582642] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.582643] uhci_hcd 0000:00:1a.0: Performing full reset
[    3.582655] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    3.582662] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    3.582942] usb usb3: default language 0x0409
[    3.582963] usb usb3: uevent
[    3.582982] usb usb3: usb_probe_device
[    3.582983] usb usb3: configuration #1 chosen from 1 choice
[    3.583247] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    3.583255] usb 3-0:1.0: uevent
[    3.583274] hub 3-0:1.0: usb_probe_interface
[    3.583275] hub 3-0:1.0: usb_probe_interface - got id
[    3.583276] hub 3-0:1.0: USB hub found
[    3.583532] hub 3-0:1.0: 2 ports detected
[    3.583786] hub 3-0:1.0: standalone hub
[    3.583786] hub 3-0:1.0: no power switching (usb 1.0)
[    3.583787] hub 3-0:1.0: individual port over-current protection
[    3.583789] hub 3-0:1.0: power on to power good time: 2ms
[    3.583791] hub 3-0:1.0: local power source is good
[    3.583792] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    3.583824] drivers/usb/core/inode.c: creating file '001'
[    3.583856] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.584125] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.584601] usb usb3: Product: UHCI Host Controller
[    3.584858] usb usb3: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.585120] usb usb3: SerialNumber: 0000:00:1a.0
[    3.585387] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.585656] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.585658] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.585941] drivers/usb/core/inode.c: creating file '004'
[    3.585968] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.586450] uhci_hcd 0000:00:1a.1: detected 2 ports
[    3.586709] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.586711] uhci_hcd 0000:00:1a.1: Performing full reset
[    3.586722] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    3.586730] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[    3.587013] usb usb4: default language 0x0409
[    3.587032] usb usb4: uevent
[    3.587050] usb usb4: usb_probe_device
[    3.587052] usb usb4: configuration #1 chosen from 1 choice
[    3.587314] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    3.587323] usb 4-0:1.0: uevent
[    3.587342] hub 4-0:1.0: usb_probe_interface
[    3.587343] hub 4-0:1.0: usb_probe_interface - got id
[    3.587344] hub 4-0:1.0: USB hub found
[    3.587598] hub 4-0:1.0: 2 ports detected
[    3.587852] hub 4-0:1.0: standalone hub
[    3.587853] hub 4-0:1.0: no power switching (usb 1.0)
[    3.587854] hub 4-0:1.0: individual port over-current protection
[    3.587855] hub 4-0:1.0: power on to power good time: 2ms
[    3.587857] hub 4-0:1.0: local power source is good
[    3.587858] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    3.587889] drivers/usb/core/inode.c: creating file '001'
[    3.587922] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.588190] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.588666] usb usb4: Product: UHCI Host Controller
[    3.588924] usb usb4: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.589185] usb usb4: SerialNumber: 0000:00:1a.1
[    3.589452] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.589720] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.589722] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.590005] drivers/usb/core/inode.c: creating file '005'
[    3.590034] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.590514] uhci_hcd 0000:00:1a.2: detected 2 ports
[    3.590773] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.590774] uhci_hcd 0000:00:1a.2: Performing full reset
[    3.590785] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    3.590792] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000fd00
[    3.591074] usb usb5: default language 0x0409
[    3.591095] usb usb5: uevent
[    3.591113] usb usb5: usb_probe_device
[    3.591114] usb usb5: configuration #1 chosen from 1 choice
[    3.591375] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    3.591384] usb 5-0:1.0: uevent
[    3.591401] hub 5-0:1.0: usb_probe_interface
[    3.591402] hub 5-0:1.0: usb_probe_interface - got id
[    3.591403] hub 5-0:1.0: USB hub found
[    3.591659] hub 5-0:1.0: 2 ports detected
[    3.591913] hub 5-0:1.0: standalone hub
[    3.591914] hub 5-0:1.0: no power switching (usb 1.0)
[    3.591914] hub 5-0:1.0: individual port over-current protection
[    3.591916] hub 5-0:1.0: power on to power good time: 2ms
[    3.591918] hub 5-0:1.0: local power source is good
[    3.591919] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    3.591949] drivers/usb/core/inode.c: creating file '001'
[    3.591982] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.592251] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.592726] usb usb5: Product: UHCI Host Controller
[    3.592983] usb usb5: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.593245] usb usb5: SerialNumber: 0000:00:1a.2
[    3.593512] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.593781] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.593783] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.594066] drivers/usb/core/inode.c: creating file '006'
[    3.594093] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.594573] uhci_hcd 0000:00:1d.0: detected 2 ports
[    3.594833] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    3.594834] uhci_hcd 0000:00:1d.0: Performing full reset
[    3.594845] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    3.594847] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    3.595128] usb usb6: default language 0x0409
[    3.595149] usb usb6: uevent
[    3.595167] usb usb6: usb_probe_device
[    3.595168] usb usb6: configuration #1 chosen from 1 choice
[    3.595430] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    3.595439] usb 6-0:1.0: uevent
[    3.595456] hub 6-0:1.0: usb_probe_interface
[    3.595457] hub 6-0:1.0: usb_probe_interface - got id
[    3.595458] hub 6-0:1.0: USB hub found
[    3.595713] hub 6-0:1.0: 2 ports detected
[    3.595967] hub 6-0:1.0: standalone hub
[    3.595968] hub 6-0:1.0: no power switching (usb 1.0)
[    3.595969] hub 6-0:1.0: individual port over-current protection
[    3.595970] hub 6-0:1.0: power on to power good time: 2ms
[    3.595972] hub 6-0:1.0: local power source is good
[    3.595973] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    3.596006] drivers/usb/core/inode.c: creating file '001'
[    3.596043] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.596308] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.596784] usb usb6: Product: UHCI Host Controller
[    3.597044] usb usb6: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.597304] usb usb6: SerialNumber: 0000:00:1d.0
[    3.597571] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.597841] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.597842] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.598126] drivers/usb/core/inode.c: creating file '007'
[    3.598157] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.598637] uhci_hcd 0000:00:1d.1: detected 2 ports
[    3.598895] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    3.598896] uhci_hcd 0000:00:1d.1: Performing full reset
[    3.598907] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    3.598910] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    3.599192] usb usb7: default language 0x0409
[    3.599213] usb usb7: uevent
[    3.599232] usb usb7: usb_probe_device
[    3.599233] usb usb7: configuration #1 chosen from 1 choice
[    3.599495] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    3.599503] usb 7-0:1.0: uevent
[    3.599522] hub 7-0:1.0: usb_probe_interface
[    3.599523] hub 7-0:1.0: usb_probe_interface - got id
[    3.599524] hub 7-0:1.0: USB hub found
[    3.599779] hub 7-0:1.0: 2 ports detected
[    3.600035] hub 7-0:1.0: standalone hub
[    3.600036] hub 7-0:1.0: no power switching (usb 1.0)
[    3.600037] hub 7-0:1.0: individual port over-current protection
[    3.600038] hub 7-0:1.0: power on to power good time: 2ms
[    3.600040] hub 7-0:1.0: local power source is good
[    3.600041] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    3.600075] drivers/usb/core/inode.c: creating file '001'
[    3.600107] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.600373] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.600849] usb usb7: Product: UHCI Host Controller
[    3.601108] usb usb7: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.601368] usb usb7: SerialNumber: 0000:00:1d.1
[    3.601635] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.601904] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.601906] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.602192] drivers/usb/core/inode.c: creating file '008'
[    3.602220] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.602700] uhci_hcd 0000:00:1d.2: detected 2 ports
[    3.602959] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    3.602960] uhci_hcd 0000:00:1d.2: Performing full reset
[    3.602971] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    3.602974] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    3.603254] usb usb8: default language 0x0409
[    3.603274] usb usb8: uevent
[    3.603291] usb usb8: usb_probe_device
[    3.603293] usb usb8: configuration #1 chosen from 1 choice
[    3.603555] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    3.603565] usb 8-0:1.0: uevent
[    3.603583] hub 8-0:1.0: usb_probe_interface
[    3.603584] hub 8-0:1.0: usb_probe_interface - got id
[    3.603585] hub 8-0:1.0: USB hub found
[    3.603842] hub 8-0:1.0: 2 ports detected
[    3.604098] hub 8-0:1.0: standalone hub
[    3.604098] hub 8-0:1.0: no power switching (usb 1.0)
[    3.604099] hub 8-0:1.0: individual port over-current protection
[    3.604100] hub 8-0:1.0: power on to power good time: 2ms
[    3.604103] hub 8-0:1.0: local power source is good
[    3.604104] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    3.604138] drivers/usb/core/inode.c: creating file '001'
[    3.604172] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.604437] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.604913] usb usb8: Product: UHCI Host Controller
[    3.605173] usb usb8: Manufacturer: Linux 2.6.28 uhci_hcd
[    3.605433] usb usb8: SerialNumber: 0000:00:1d.2
[    3.605739] usbcore: registered new interface driver usblp
[    3.605998] Initializing USB Mass Storage driver...
[    3.606291] usbcore: registered new interface driver usb-storage
[    3.606553] USB Mass Storage support registered.
[    3.606842] usbcore: registered new interface driver libusual
[    3.607186] PNP: No PS/2 controller found. Probing ports directly.
[    3.610134] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.610394] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.615042] mice: PS/2 mouse device common for all mice
[    3.626123] rtc_cmos 00:03: RTC can wake from S4
[    3.626420] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.626700] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    3.626991] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    3.627593] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    3.628099] cpuidle: using governor ladder
[    3.628353] cpuidle: using governor menu
[    3.634396] No iBFT detected.
[    3.635066] modprobe used greatest stack depth: 5816 bytes left
[    3.635469] usbcore: registered new interface driver hiddev
[    3.635751] usbcore: registered new interface driver usbhid
[    3.636015] usbhid: v2.6:USB HID core driver
[    3.636298] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    3.636989] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.637487] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.646922] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    3.662018] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
[    3.662021] hub 1-0:1.0: port 1: status 0501 change 0001
[    3.662027] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[    3.662029] hub 1-0:1.0: port 2: status 0501 change 0001
[    3.662035] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
[    3.662037] hub 1-0:1.0: port 3: status 0501 change 0001
[    3.662043] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 001403 POWER sig=k CSC CONNECT
[    3.662045] hub 1-0:1.0: port 4: status 0501 change 0001
[    3.673178] ALSA device list:
[    3.673427]   #0: HDA Intel at 0xfdff4000 irq 22
[    3.673739] Netfilter messages via NETLINK v0.30.
[    3.674006] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.674409] ctnetlink v0.93: registering with nfnetlink.
[    3.675007] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.675281] TCP cubic registered
[    3.675532] Initializing XFRM netlink socket
[    3.675838] NET: Registered protocol family 10
[    3.676641] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.676932] IPv6 over IPv4 tunneling driver
[    3.677545] NET: Registered protocol family 17
[    3.677899] RPC: Registered udp transport module.
[    3.678158] RPC: Registered tcp transport module.
[    3.678833] registered taskstats version 1
[    3.679183]   Magic number: 4:538:623
[    3.679500] Freeing unused kernel memory: 524k freed
[    3.679867] Write protecting the kernel read-only data: 6560k
[    3.680288] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    3.685945] uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
[    3.685954] uhci_hcd 0000:00:1a.0: port 2 portsc 0082,00
[    3.687033] uhci_hcd 0000:00:1a.1: port 1 portsc 008a,00
[    3.687042] uhci_hcd 0000:00:1a.1: port 2 portsc 008a,00
[    3.691024] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.695022] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.700022] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.704058] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    3.762017] hub 1-0:1.0: state 7 ports 6 chg 001e evt 0000
[    3.762023] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    3.762029] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    3.813016] ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
[    3.813031] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[    3.864315] ehci_hcd 0000:00:1a.7: port 2 high speed
[    3.864317] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    3.915020] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    3.966189] ehci_hcd 0000:00:1a.7: port 2 high speed
[    3.966191] ehci_hcd 0000:00:1a.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[    4.029363] usb 1-2: uevent
[    4.029406] usb 1-2: usb_probe_device
[    4.029408] usb 1-2: configuration #1 chosen from 1 choice
[    4.029824] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[    4.029838] usb 1-2:1.0: uevent
[    4.029865] hub 1-2:1.0: usb_probe_interface
[    4.029867] hub 1-2:1.0: usb_probe_interface - got id
[    4.029868] hub 1-2:1.0: USB hub found
[    4.030198] hub 1-2:1.0: 2 ports detected
[    4.030454] hub 1-2:1.0: compound device; port removable status: FF
[    4.030455] hub 1-2:1.0: ganged power switching
[    4.030456] hub 1-2:1.0: global over-current protection
[    4.030457] hub 1-2:1.0: Single TT
[    4.030458] hub 1-2:1.0: TT requires at most 8 FS bit times (666 ns)
[    4.030459] hub 1-2:1.0: power on to power good time: 100ms
[    4.030697] hub 1-2:1.0: local power source is good
[    4.030698] hub 1-2:1.0: no over-current condition exists
[    4.030700] hub 1-2:1.0: enabling power on all ports
[    4.030986] drivers/usb/core/inode.c: creating file '003'
[    4.031027] usb 1-2: New USB device found, idVendor=0424, idProduct=2502
[    4.031300] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.031571] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.087816] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.087819] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
[    4.087821] hub 1-0:1.0: port 3 not reset yet, waiting 50ms
[    4.089136] md: raid1 personality registered for level 1
[    4.091269] md: md1 stopped.
[    4.130074] hub 1-2:1.0: port 1: status 0101 change 0001
[    4.130322] hub 1-2:1.0: port 2: status 0101 change 0001
[    4.134990] md: bind<sdb2>
[    4.135358] md: bind<sda2>
[    4.135999] raid1: raid set md1 active with 2 out of 2 mirrors
[    4.136717] md1: bitmap initialized from disk: read 1/1 pages, set 32 bits
[    4.136983] created bitmap (15 pages) for device md1
[    4.138147] ehci_hcd 0000:00:1a.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
[    4.138167] hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.138171] ehci_hcd 0000:00:1a.7: port 4 low speed --> companion
[    4.157250] mdadm used greatest stack depth: 5376 bytes left
[    4.178243]  md1: unknown partition table
[    4.189025] ehci_hcd 0000:00:1a.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
[    4.189039] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    4.189044] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.189049] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.189054] hub 3-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    4.230154] usb 1-2: link qh256-0001/ffff88007e1a7140 start 255 [1/0 us]
[    4.293025] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    4.381166] EXT4-fs: barriers enabled
[    4.392757] kjournald2 starting.  Commit interval 60 seconds
[    4.393032] EXT4-fs: delayed allocation enabled
[    4.393292] EXT4-fs: file extents enabled
[    4.393625] EXT4-fs: mballoc enabled
[    4.393877] EXT4-fs: mounted filesystem with ordered data mode.
[    4.395140] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    4.423853] SELinux:  Disabled at runtime.
[    4.424122] SELinux:  Unregistering netfilter hooks
[    4.440015] type=1404 audit(1230536211.440:2): selinux=0 auid=4294967295 ses=4294967295
[    4.536951] usb 3-1: skipped 1 descriptor after interface
[    4.541949] usb 3-1: default language 0x0409
[    4.558982] usb 3-1: uevent
[    4.558991] usb 3-1: usb_probe_device
[    4.558992] usb 3-1: configuration #1 chosen from 1 choice
[    4.561951] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    4.561963] usb 3-1:1.0: uevent
[    4.561974] usbhid 3-1:1.0: usb_probe_interface
[    4.561975] usbhid 3-1:1.0: usb_probe_interface - got id
[    4.576175] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input3
[    4.580131] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[    4.583153] generic-usb 0003:046D:C315.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1a.0-1/input0
[    4.583674] drivers/usb/core/inode.c: creating file '002'
[    4.583697] usb 3-1: New USB device found, idVendor=046d, idProduct=c315
[    4.583963] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.584232] usb 3-1: Product: Logitech USB Keyboard
[    4.584490] usb 3-1: Manufacturer: Logitech
[    4.584745] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0006
[    4.584750] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.584754] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    4.688131] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    4.704007] usb usb5: suspend_rh (auto-stop)
[    4.704024] usb usb6: suspend_rh (auto-stop)
[    4.704040] usb usb7: suspend_rh (auto-stop)
[    4.704057] usb usb8: suspend_rh (auto-stop)
[    4.790129] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    4.912128] usb 4-1: ep0 maxpacket = 8
[    4.938023] usb 4-1: default language 0x0409
[    4.961054] usb 4-1: uevent
[    4.961062] usb 4-1: usb_probe_device
[    4.961063] usb 4-1: configuration #1 chosen from 1 choice
[    4.969022] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    4.969032] usb 4-1:1.0: uevent
[    4.975057] usb 4-1: adding 4-1:1.1 (config #1, interface 1)
[    4.975067] usb 4-1:1.1: uevent
[    4.975073] usblp 4-1:1.1: usb_probe_interface
[    4.975074] usblp 4-1:1.1: usb_probe_interface - got id
[    4.999024] drivers/usb/core/file.c: looking for a minor, starting at 0
[    4.999044] usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x04B8 pid 0x0818
[    4.999535] drivers/usb/core/inode.c: creating file '002'
[    4.999557] usb 4-1: New USB device found, idVendor=04b8, idProduct=0818
[    4.999826] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.000099] usb 4-1: Product: USB MFP
[    5.000357] usb 4-1: Manufacturer: EPSON
[    5.000613] usb 4-1: SerialNumber: L56020512121311560
[    5.000878] uhci_hcd 0000:00:1a.1: port 2 portsc 01a3,00
[    5.000883] hub 4-0:1.0: port 2, status 0301, change 0001, 1.5 Mb/s
[    5.021297] mount used greatest stack depth: 5016 bytes left
[    5.104131] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x301
[    5.206129] usb 4-2: new low speed USB device using uhci_hcd and address 3
[    5.350026] usb 4-2: skipped 1 descriptor after interface
[    5.355026] usb 4-2: default language 0x0409
[    5.370057] usb 4-2: uevent
[    5.370066] usb 4-2: usb_probe_device
[    5.370067] usb 4-2: configuration #1 chosen from 1 choice
[    5.373026] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[    5.373034] usb 4-2:1.0: uevent
[    5.373045] usbhid 4-2:1.0: usb_probe_interface
[    5.373046] usbhid 4-2:1.0: usb_probe_interface - got id
[    5.391198] input: Logitech USB RECEIVER as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input4
[    5.397149] generic-usb 0003:046D:C50E.0002: input,hidraw1: USB HID v1.11 Mouse [Logitech USB RECEIVER] on usb-0000:00:1a.1-2/input0
[    5.397669] drivers/usb/core/inode.c: creating file '003'
[    5.397691] usb 4-2: New USB device found, idVendor=046d, idProduct=c50e
[    5.397957] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.398226] usb 4-2: Product: USB RECEIVER
[    5.398481] usb 4-2: Manufacturer: Logitech
[    5.398736] hub 1-2:1.0: state 7 ports 2 chg 0006 evt 0000
[    5.398841] hub 1-2:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    5.409206] hub 1-2:1.0: port 1 not reset yet, waiting 10ms
[    5.471210] usb 1-2.1: new high speed USB device using ehci_hcd and address 6
[    5.482203] hub 1-2:1.0: port 1 not reset yet, waiting 10ms
[    5.556376] usb 1-2.1: uevent
[    5.556386] usb 1-2.1: usb_probe_device
[    5.556387] usb 1-2.1: configuration #1 chosen from 1 choice
[    5.556459] usb 1-2.1: adding 1-2.1:1.0 (config #1, interface 0)
[    5.556475] usb 1-2.1:1.0: uevent
[    5.556483] hub 1-2.1:1.0: usb_probe_interface
[    5.556484] hub 1-2.1:1.0: usb_probe_interface - got id
[    5.556486] hub 1-2.1:1.0: USB hub found
[    5.556584] hub 1-2.1:1.0: 4 ports detected
[    5.556585] hub 1-2.1:1.0: standalone hub
[    5.556586] hub 1-2.1:1.0: ganged power switching
[    5.556587] hub 1-2.1:1.0: global over-current protection
[    5.556735] hub 1-2.1:1.0: TT per port
[    5.556736] hub 1-2.1:1.0: TT requires at most 8 FS bit times (666 ns)
[    5.556738] hub 1-2.1:1.0: power on to power good time: 100ms
[    5.556956] hub 1-2.1:1.0: local power source is good
[    5.556958] hub 1-2.1:1.0: no over-current condition exists
[    5.556959] hub 1-2.1:1.0: enabling power on all ports
[    5.557459] drivers/usb/core/inode.c: creating file '006'
[    5.557492] usb 1-2.1: New USB device found, idVendor=0424, idProduct=2504
[    5.557494] usb 1-2.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.557583] hub 1-2:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    5.568087] hub 1-2:1.0: port 2 not reset yet, waiting 10ms
[    5.630088] usb 1-2.2: new high speed USB device using ehci_hcd and address 7
[    5.648086] hub 1-2:1.0: port 2 not reset yet, waiting 10ms
[    5.657460] usb 1-2.1: link qh256-0001/ffff88007e1a7320 start 255 [1/0 us]
[    5.701142] hub 2-0:1.0: hub_suspend
[    5.701146] usb usb2: bus auto-suspend
[    5.701148] ehci_hcd 0000:00:1d.7: suspend root hub
[    5.701169] hub 5-0:1.0: hub_suspend
[    5.701171] usb usb5: bus auto-suspend
[    5.701172] usb usb5: suspend_rh
[    5.701184] hub 6-0:1.0: hub_suspend
[    5.701186] usb usb6: bus auto-suspend
[    5.701187] usb usb6: suspend_rh
[    5.701199] hub 7-0:1.0: hub_suspend
[    5.701201] usb usb7: bus auto-suspend
[    5.701202] usb usb7: suspend_rh
[    5.704009] hub 8-0:1.0: hub_suspend
[    5.704011] usb usb8: bus auto-suspend
[    5.704012] usb usb8: suspend_rh
[    5.743837] usb 1-2.2: skipped 1 descriptor after endpoint
[    5.751836] usb 1-2.2: default language 0x0409
[    5.791878] usb 1-2.2: uevent
[    5.791889] usb 1-2.2: usb_probe_device
[    5.791891] usb 1-2.2: configuration #1 chosen from 1 choice
[    5.791961] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[    5.791977] usb 1-2.2:1.0: uevent
[    5.791987] usb-storage 1-2.2:1.0: usb_probe_interface
[    5.791989] usb-storage 1-2.2:1.0: usb_probe_interface - got id
[    5.792022] scsi6 : SCSI emulation for USB Mass Storage devices
[    5.792096] drivers/usb/core/inode.c: creating file '007'
[    5.792120] usb 1-2.2: New USB device found, idVendor=0424, idProduct=223a
[    5.792122] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.792123] usb 1-2.2: Product: USB2223
[    5.792124] usb 1-2.2: Manufacturer: SMSC
[    5.792125] usb 1-2.2: SerialNumber: 000223223223
[    5.792127] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.792129] hub 1-2:1.0: state 7 ports 2 chg 0000 evt 0004
[    5.792133] usb-storage: device found at 7
[    5.792134] usb-storage: waiting for device to settle before scanning
[    5.792207] hub 1-2.1:1.0: state 7 ports 4 chg 0000 evt 0000
[    5.828325] udevd version 127 started
[    5.864753] usb usb3: uevent
[    5.864764] usb 3-0:1.0: uevent
[    5.864786] usb 3-1: uevent
[    5.864796] usb 3-1:1.0: uevent
[    5.864896] usb usb4: uevent
[    5.864905] usb 4-0:1.0: uevent
[    5.864925] usb 4-1: uevent
[    5.864935] usb 4-1:1.0: uevent
[    5.864964] usb 4-1:1.1: uevent
[    5.865020] usb 4-2: uevent
[    5.865030] usb 4-2:1.0: uevent
[    5.865137] usb usb5: uevent
[    5.865147] usb 5-0:1.0: uevent
[    5.865199] usb usb1: uevent
[    5.865209] usb 1-0:1.0: uevent
[    5.865229] usb 1-2: uevent
[    5.865239] usb 1-2.1: uevent
[    5.865250] usb 1-2.1:1.0: uevent
[    5.865279] usb 1-2.2: uevent
[    5.865289] usb 1-2.2:1.0: uevent
[    5.865344] usb 1-2:1.0: uevent
[    5.865646] usb usb6: uevent
[    5.865655] usb 6-0:1.0: uevent
[    5.865707] usb usb7: uevent
[    5.865717] usb 7-0:1.0: uevent
[    5.865769] usb usb8: uevent
[    5.865779] usb 8-0:1.0: uevent
[    5.865831] usb usb2: uevent
[    5.865841] usb 2-0:1.0: uevent
[    6.060111] 3c59x 0000:05:03.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    6.060173] 3c59x: Donald Becker and others.
[    6.060175] 0000:05:03.0: 3Com PCI 3c905B Cyclone 100baseTx at ffffc20010fa2000.
[    6.060179] 3c59x 0000:05:03.0: setting latency timer to 64
[    6.084097] modprobe used greatest stack depth: 4856 bytes left
[    6.503676] ip used greatest stack depth: 4512 bytes left
[    6.790624] md: md0 stopped.
[    6.912837] md: bind<sdb1>
[    6.912960] md: bind<sda1>
[    6.916966] raid1: raid set md0 active with 2 out of 2 mirrors
[    6.917366] md0: bitmap initialized from disk: read 1/1 pages, set 3 bits
[    6.917367] created bitmap (13 pages) for device md0
[    6.928089]  md0: unknown partition table
[    7.792014] hub 1-2.1:1.0: hub_suspend
[    7.792020] usb 1-2.1: unlink qh256-0001/ffff88007e1a7320 start 255 [1/0 us]
[    7.792346] usb 1-2.1: usb auto-suspend
[    7.881545] EXT4 FS on dm-0, internal journal on dm-0:8
[    7.935833] EXT4-fs: barriers enabled
[    7.944665] kjournald2 starting.  Commit interval 60 seconds
[    7.957574] EXT4 FS on dm-4, internal journal on dm-4:8
[    7.957576] EXT4-fs: delayed allocation enabled
[    7.957577] EXT4-fs: file extents enabled
[    7.958228] EXT4-fs: mballoc enabled
[    7.958230] EXT4-fs: mounted filesystem with ordered data mode.
[    7.983266] EXT4-fs: barriers enabled
[    7.994202] kjournald2 starting.  Commit interval 60 seconds
[    7.994474] EXT4 FS on dm-3, internal journal on dm-3:8
[    7.994476] EXT4-fs: delayed allocation enabled
[    7.994477] EXT4-fs: file extents enabled
[    7.994658] EXT4-fs: mballoc enabled
[    7.994660] EXT4-fs: mounted filesystem with ordered data mode.
[    8.007724] kjournald starting.  Commit interval 60 seconds
[    8.008046] EXT3 FS on md0, internal journal
[    8.008049] EXT3-fs: mounted filesystem with ordered data mode.
[    8.410484] rc.sysinit used greatest stack depth: 4408 bytes left
[    8.625472] microcode: CPU0 updated from revision 0xb3 to 0xb6, date = 2007-07-13 
[    8.630273] microcode: CPU1 updated from revision 0xb3 to 0xb6, date = 2007-07-13 
[    8.912361] sky2 eth0: enabling interface
[    8.915586] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   10.797636] isa bounce pool size: 16 pages
[   10.801256] scsi 6:0:0:0: Direct-Access     SMSC     223 U HS-CF      3.60 PQ: 0 ANSI: 0
[   10.805680] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   10.805720] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   10.807898] usb-storage: device scan complete
[   14.518014] sky2 eth0: disabling interface
[   14.600692] eth1:  setting full-duplex.
[   19.222969] sky2 eth0: enabling interface
[   19.226140] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.650067] usb usb2: usb auto-resume
[   20.650071] ehci_hcd 0000:00:1d.7: resume root hub
[   20.691009] hub 2-0:1.0: hub_resume
[   20.691067] usb usb8: usb auto-resume
[   20.691069] usb usb8: wakeup_rh
[   20.691643] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   20.722010] hub 8-0:1.0: hub_resume
[   20.722025] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.722074] usb usb7: usb auto-resume
[   20.722076] usb usb7: wakeup_rh
[   20.754015] hub 7-0:1.0: hub_resume
[   20.754031] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.754075] usb usb6: usb auto-resume
[   20.754077] usb usb6: wakeup_rh
[   20.786013] hub 6-0:1.0: hub_resume
[   20.786029] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.786069] usb usb5: usb auto-resume
[   20.786071] usb usb5: wakeup_rh
[   20.818012] hub 5-0:1.0: hub_resume
[   20.818028] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   20.818422] usb 1-2.1: usb auto-resume
[   20.855174] usb 1-2.1: finish resume
[   20.855421] hub 1-2.1:1.0: hub_resume
[   20.855923] ehci_hcd 0000:00:1a.7: reused qh ffff88007e1a7320 schedule
[   20.855925] usb 1-2.1: link qh256-0001/ffff88007e1a7320 start 255 [1/0 us]
[   20.855931] hub 1-2.1:1.0: state 7 ports 4 chg 0000 evt 0000
[   21.954030] usb usb8: suspend_rh (auto-stop)
[   21.954049] usb usb7: suspend_rh (auto-stop)
[   21.954066] usb usb6: suspend_rh (auto-stop)
[   21.954082] usb usb5: suspend_rh (auto-stop)
[   22.701137] hub 2-0:1.0: hub_suspend
[   22.701143] usb usb2: bus auto-suspend
[   22.701144] ehci_hcd 0000:00:1d.7: suspend root hub
[   22.722024] hub 8-0:1.0: hub_suspend
[   22.722028] usb usb8: bus auto-suspend
[   22.722030] usb usb8: suspend_rh
[   22.754022] hub 7-0:1.0: hub_suspend
[   22.754025] usb usb7: bus auto-suspend
[   22.754027] usb usb7: suspend_rh
[   22.786022] hub 6-0:1.0: hub_suspend
[   22.786025] usb usb6: bus auto-suspend
[   22.786027] usb usb6: suspend_rh
[   22.818013] hub 5-0:1.0: hub_suspend
[   22.818017] usb usb5: bus auto-suspend
[   22.818018] usb usb5: suspend_rh
[   22.855013] hub 1-2.1:1.0: hub_suspend
[   22.855018] usb 1-2.1: unlink qh256-0001/ffff88007e1a7320 start 255 [1/0 us]
[   22.855310] usb 1-2.1: usb auto-suspend
[   23.237449] JBD: barrier-based sync failed on dm-0:8 - disabling barriers
[   23.369174] newaliases used greatest stack depth: 3912 bytes left
[   23.486029] uhci_hcd 0000:00:1a.1: reserve dev 3 ep81-INT, period 8, phase 4, 118 us
[   23.647853] JBD: barrier-based sync failed on dm-3:8 - disabling barriers
[   24.989055] eth1: no IPv6 routers present
[   50.718093] usb usb2: usb auto-resume
[   50.718096] ehci_hcd 0000:00:1d.7: resume root hub
[   50.757010] hub 2-0:1.0: hub_resume
[   50.757030] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   50.757080] usb usb8: usb auto-resume
[   50.757082] usb usb8: wakeup_rh
[   50.789009] hub 8-0:1.0: hub_resume
[   50.789027] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   50.789076] usb usb7: usb auto-resume
[   50.789078] usb usb7: wakeup_rh
[   50.821009] hub 7-0:1.0: hub_resume
[   50.821026] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   50.821074] usb usb6: usb auto-resume
[   50.821076] usb usb6: wakeup_rh
[   50.853009] hub 6-0:1.0: hub_resume
[   50.853026] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   50.853073] usb usb5: usb auto-resume
[   50.853075] usb usb5: wakeup_rh
[   50.885009] hub 5-0:1.0: hub_resume
[   50.885027] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   50.885343] usb 1-2.1: usb auto-resume
[   50.914351] hub 1-2:1.0: state 7 ports 2 chg 0000 evt 0002
[   50.922098] usb 1-2.1: finish resume
[   50.922345] hub 1-2.1:1.0: hub_resume
[   50.922846] ehci_hcd 0000:00:1a.7: reused qh ffff88007e1a7320 schedule
[   50.922847] usb 1-2.1: link qh256-0001/ffff88007e1a7320 start 255 [1/0 us]
[   50.922853] hub 1-2.1:1.0: state 7 ports 4 chg 0000 evt 0000
[   51.954021] usb usb8: suspend_rh (auto-stop)
[   51.954039] usb usb7: suspend_rh (auto-stop)
[   51.954055] usb usb6: suspend_rh (auto-stop)
[   51.954071] usb usb5: suspend_rh (auto-stop)

--------------020907070802010902080207
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28
# Mon Dec 29 01:23:53 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_ICS932S401 is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
# CONFIG_TYPHOON is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH9K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_PCMCIA_IBMTR is not set
# CONFIG_WAN is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_BRIGHT=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DELL=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--------------020907070802010902080207--

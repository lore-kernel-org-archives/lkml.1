Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZIPL4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZIPL4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZIPL4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:56:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZIPL4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=b6Nqobfzpe5BMG2o0HiJWoe5zY03riVIt63NaJtw5m4T+HzzkeVEOjFxdzZeBzAxAv
         oudnDUGHaltcQPyUVnsTgdwqj7hEOmihN4pApvXeq4okmK4wCDdHB+A/XMWGIjiINXvq
         Oql0rpCMmGNcfBOfw1THbQTWJUoRq59zHdsks=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Wed, 16 Sep 2009 13:56:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200909142015.56698.volkerarmin@googlemail.com> <200909142235.32752.oliver@neukum.org>
In-Reply-To: <200909142235.32752.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909161356.26691.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 14 September 2009, Oliver Neukum wrote:
> Am Montag, 14. September 2009 20:15:56 schrieb Volker Armin Hemmann:
> > I turned off
> > USB selective suspend/resume and wakeup
> >
> > and turned on
> > Root Hub Transaction Translators
> >  Improved Transaction Translator scheduling
> >
> > and haven't had any lockup anymore.
> >
> > Sorry for the noise. Really.
> 
> Can you please find out whether all the options you found are needed?
> 
> 	Regards
> 		Oliver
> 

ok, I am done. Was back earlier then expected and had  an all-awake-night, so 
lots of time:

with 
USB selective suspend/resume and wakeup on

Root Hub Transaction Translators off
Improved Transaction Translator scheduling off

mouse unusable


with
USB selective suspend/resume and wakeup on

Root Hub Transaction Translators on
Improved Transaction Translator scheduling on

mouse is fine


with
USB selective suspend/resume and wakeup off

Root Hub Transaction Translators on
Improved Transaction Translator scheduling on

mouse is fine


with
USB selective suspend/resume and wakeup on

Root Hub Transaction Translators on
Improved Transaction Translator scheduling off

mouse is fine


with
USB selective suspend/resume and wakeup on

Root Hub Transaction Translators off
Improved Transaction Translator scheduling on

mouse is fine 


with
USB selective suspend/resume and wake off

Root Hub Transaction Translators off
Improved Transaction Translator scheduling off

mouse locks up after a couple of minutes, but not as bad as with 
USB selective suspend/resume and wake
on.

BUT: The last one (all off) I am only trying it for ~20min at the moment and 
had 1 lockup
with USB selective suspend/resume and wake on I had sometimes 10 minutes or so 
without lockup too.
The difference so far, with that option set, I have douzends of lockups. 
Without I had one and it is harder to trigger.

The other combinations I ran for 1-3h and doing all the stuff that usually 
results in the problem (fast scrolling, fast moving the mouse a lot with lots 
changes in direction aka 'shrubbing the desk').

So the problem exists, USB selective suspend/resume and wake makes it worse, 
and any of the Translator options make it go away.


dmesg from lockup:

[    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gentoo 
4.4.1 p1.0) ) #8 SMP Wed Sep 16 04:10:01 CEST 2009
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 
nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000238000000 aka 9088M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  modified: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  modified: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506 
MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601 
MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121 
INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7ec0000 00040
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506 
MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506 
MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506 
MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506 
MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506 
MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001 
AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0238000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0001000000 - 00015f68c0]    TEXT DATA BSS ==> [0001000000 
- 00015f68c0]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 
- 0000100000]
[    0.000000]   #4 [00015f7000 - 00015f7133]              BRK ==> [00015f7000 
- 00015f7133]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 
- 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 
- 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880028600000-
ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7eb0
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31
[    0.000000]   Normal zone: 17472 pages used for memmap
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 - 
00000000c7ec0000
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 - 
00000000c7ef0000
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 - 
00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 
00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: 
c7f00000:38000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 71904 
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 2064793
[    0.000000] Kernel command line: root=/dev/md1 
md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
[    0.000000] md: Will configure md3 (super-block) from 
/dev/sda3,/dev/sdb3,/dev/sdc3, below.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 2a02000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 
0000000024000000
[    0.000000] Memory: 8184476k/9306112k available (3484k kernel code, 919300k 
absent, 201360k reserved, 1750k data, 376k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3199.763 MHz processor.
[    0.000612] Console: colour VGA+ 80x25
[    0.000614] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333]   alloc irq_desc for 24 on node 0
[    0.003333]   alloc kstat_irqs on node 0
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu 
timer
[    0.003338] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6402.16 BogoMIPS (lpj=10665863)
[    0.003422] Mount-cache hash table entries: 256
[    0.003546] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.003582] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003616] tseg: 0000000000
[    0.003622] CPU: Physical Processor ID: 0
[    0.003656] CPU: Processor Core ID: 0
[    0.003689] mce: CPU supports 6 MCE banks
[    0.003729] using C1E aware idle routine
[    0.003773] ACPI: Core revision 20090521
[    0.016707] Setting APIC routing to flat
[    0.017032] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.051000] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666963)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106
[    0.144155] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.144504] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.146698] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666967)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106
[    0.240808] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.241156] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.243372] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666962)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106
[    0.337566] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.337917] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.340007] Brought up 4 CPUs
[    0.340041] Total of 4 processors activated (25610.72 BogoMIPS).
[    0.340110] CPU0 attaching sched-domain:
[    0.340112]  domain 0: span 0-3 level MC
[    0.340114]   groups: 0 1 2 3
[    0.340117] CPU1 attaching sched-domain:
[    0.340118]  domain 0: span 0-3 level MC
[    0.340119]   groups: 1 2 3 0
[    0.340122] CPU2 attaching sched-domain:
[    0.340123]  domain 0: span 0-3 level MC
[    0.340124]   groups: 2 3 0 1
[    0.340126] CPU3 attaching sched-domain:
[    0.340127]  domain 0: span 0-3 level MC
[    0.340128]   groups: 3 0 1 2
[    0.340394] xor: automatically using best checksumming function: 
generic_sse
[    0.356667]    generic_sse: 12835.200 MB/sec
[    0.356701] xor: using function: generic_sse (12835.200 MB/sec)
[    0.356755] Time: 13:29:25  Date: 09/16/09
[    0.356804] NET: Registered protocol family 16
[    0.357122] node 0 link 0: io port [1000, ffffff]
[    0.357124] TOM: 00000000c8000000 aka 3200M
[    0.357158] Fam 10h mmconf [e0000000, efffffff]
[    0.357160] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.357162] node 0 link 0: mmio [f0000000, ffffffff]
[    0.357164] node 0 link 0: mmio [a0000, bffff]
[    0.357166] node 0 link 0: mmio [c8000000, dfffffff]
[    0.357167] TOM2: 0000000238000000 aka 9088M
[    0.357201] bus: [00,07] on node 0 link 0
[    0.357202] bus: 00 index 0 io port: [0, ffff]
[    0.357204] bus: 00 index 1 mmio: [f0000000, ffffffff]
[    0.357205] bus: 00 index 2 mmio: [a0000, bffff]
[    0.357206] bus: 00 index 3 mmio: [c8000000, dfffffff]
[    0.357207] bus: 00 index 4 mmio: [238000000, fcffffffff]
[    0.357220] ACPI: bus type pci registered
[    0.357325] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.357361] PCI: Not using MMCONFIG.
[    0.357395] PCI: Using configuration type 1 for base access
[    0.357429] PCI: Using configuration type 1 for extended access
[    0.359454] bio: create slab <bio-0> at 0
[    0.359919] ACPI: EC: Look up EC in DSDT
[    0.367323] ACPI: Interpreter enabled
[    0.367359] ACPI: (supports S0 S1 S3 S4 S5)
[    0.367963] ACPI: Using IOAPIC for interrupt routing
[    0.368035] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.370745] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.376143] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.381448] ACPI: No dock devices found.
[    0.381744] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.381856] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.381902] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.381937] pci 0000:00:02.0: PME# disabled
[    0.382005] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.382040] pci 0000:00:09.0: PME# disabled
[    0.382100] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.382135] pci 0000:00:0a.0: PME# disabled
[    0.382215] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
[    0.382221] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
[    0.382227] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
[    0.382232] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
[    0.382238] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
[    0.382244] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
[    0.382293] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
[    0.382344] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
[    0.382413] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
[    0.382462] pci 0000:00:12.2: supports D1 D2
[    0.382464] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.382500] pci 0000:00:12.2: PME# disabled
[    0.382562] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
[    0.382613] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
[    0.382682] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
[    0.382731] pci 0000:00:13.2: supports D1 D2
[    0.382732] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.382769] pci 0000:00:13.2: PME# disabled
[    0.382911] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.382917] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.382923] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.382928] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.382934] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.383059] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
[    0.383193] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.383200] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.383205] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]
[    0.383212] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.383227] pci 0000:02:00.0: supports D1 D2
[    0.383255] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
[    0.383286] pci 0000:02:00.1: supports D1 D2
[    0.383338] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.383340] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
[    0.383343] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.383387] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]
[    0.383389] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]
[    0.383392] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]
[    0.383422] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]
[    0.383436] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
[    0.383445] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
[    0.383451] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
[    0.383478] pci 0000:01:00.0: supports D1 D2
[    0.383479] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.383516] pci 0000:01:00.0: PME# disabled
[    0.383602] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]
[    0.383604] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.383607] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]
[    0.383642] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
[    0.383722] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]
[    0.383780] pci 0000:05:08.0: supports D1 D2
[    0.383822] pci 0000:00:14.4: transparent bridge
[    0.383858] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.383864] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]
[    0.383876] pci_bus 0000:00: on NUMA node 0
[    0.383879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.384013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.384061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.384106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.384172] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.387104] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.387334] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.387562] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.387790] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.388018] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, 
disabled.
[    0.388292] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)
[    0.388520] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.388734] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.389097] SCSI subsystem initialized
[    0.389192] libata version 3.00 loaded.
[    0.389252] usbcore: registered new interface driver usbfs
[    0.389308] usbcore: registered new interface driver hub
[    0.389373] usbcore: registered new device driver usb
[    0.443345] raid6: int64x1   2763 MB/s
[    0.500013] raid6: int64x2   3866 MB/s
[    0.556669] raid6: int64x4   2869 MB/s
[    0.613341] raid6: int64x8   2535 MB/s
[    0.670016] raid6: sse2x1    3994 MB/s
[    0.726669] raid6: sse2x2    6495 MB/s
[    0.783339] raid6: sse2x4    7974 MB/s
[    0.783373] raid6: using algorithm sse2x4 (7974 MB/s)
[    0.783458] PCI: Using ACPI for IRQ routing
[    0.783497] pci 0000:00:00.0: BAR 3: address space collision on of device 
[0xe0000000-0xffffffff]
[    0.783551] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.796895] PCI-DMA: Disabling AGP.
[    0.797017] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.797052] PCI-DMA: using GART IOMMU.
[    0.797087] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.798881] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.798989] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.803362] hpet: hpet2 irq 24 for MSI
[    0.810016] Switched to high resolution mode on CPU 0
[    0.811167] Switched to high resolution mode on CPU 2
[    0.811183] Switched to high resolution mode on CPU 1
[    0.811263] Switched to high resolution mode on CPU 3
[    0.823369] pnp: PnP ACPI init
[    0.823419] ACPI: bus type pnp registered
[    0.825667] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 
(0x0-0x1fffffff), disabling
[    0.825722] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling
[    0.825777] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling
[    0.825832] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.826140] pnp: PnP ACPI: found 12 devices
[    0.826174] ACPI: ACPI bus type pnp unregistered
[    0.826215] system 00:06: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.826269] system 00:06: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.826306] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.826341] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.826377] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.826412] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.826447] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.826482] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.826517] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.826552] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.826587] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.826622] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.826657] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.826698] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.826733] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.826768] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.826803] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.826839] system 00:07: ioport range 0xb00-0xb0f has been reserved
[    0.826874] system 00:07: ioport range 0xb20-0xb3f has been reserved
[    0.826909] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.826944] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.826979] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.827014] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.827050] system 00:07: iomem range 0xfec10000-0xfec1001f has been 
reserved
[    0.827087] system 00:09: ioport range 0x290-0x29f has been reserved
[    0.827123] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.827160] system 00:0b: iomem range 0xfec00000-0xffffffff could not be 
reserved
[    0.832057] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.832092] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.832128] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.832164] pci 0000:00:02.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.832219] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.832254] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
[    0.832289] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff
[    0.832325] pci 0000:00:09.0:   PREFETCH window: 
0x000000fa000000-0x000000fcefffff
[    0.832380] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.832415] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
[    0.832450] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.832485] pci 0000:00:0a.0:   PREFETCH window: 
0x000000cff00000-0x000000cfffffff
[    0.832541] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.832576] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.832614] pci 0000:00:14.4:   MEM window: disabled
[    0.832650] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff
[    0.832691]   alloc irq_desc for 18 on node -1
[    0.832693]   alloc kstat_irqs on node -1
[    0.832696] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.832733] pci 0000:00:02.0: setting latency timer to 64
[    0.832737]   alloc irq_desc for 17 on node -1
[    0.832738]   alloc kstat_irqs on node -1
[    0.832741] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.832776] pci 0000:00:09.0: setting latency timer to 64
[    0.832780] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.832815] pci 0000:00:0a.0: setting latency timer to 64
[    0.832822] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.832824] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.832825] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.832827] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
[    0.832829] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.832830] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.832832] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]
[    0.832833] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
[    0.832835] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.832836] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.832838] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
[    0.832839] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.832841] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
[    0.832842] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.832844] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.832855] NET: Registered protocol family 2
[    0.832911] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.833387] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.834370] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.834772] TCP: Hash tables configured (established 262144 bind 65536)
[    0.834807] TCP reno registered
[    0.834887] NET: Registered protocol family 1
[    0.836062] Scanning for low memory corruption every 60 seconds
[    0.836794] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.836926] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.
[    0.837011] msgmni has been set to 15987
[    0.837314] alg: No test for stdrng (krng)
[    0.837355] async_tx: api initialized (sync-only)
[    0.837430] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.837485] io scheduler noop registered
[    0.837519] io scheduler cfq registered (default)
[    0.837642] pci 0000:02:00.0: Boot video device
[    0.837731]   alloc irq_desc for 25 on node -1
[    0.837732]   alloc kstat_irqs on node -1
[    0.837738] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.837743] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.837834]   alloc irq_desc for 26 on node -1
[    0.837835]   alloc kstat_irqs on node -1
[    0.837838] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
[    0.837842] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.837932]   alloc irq_desc for 27 on node -1
[    0.837933]   alloc kstat_irqs on node -1
[    0.837936] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    0.837939] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.838136] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.838189] ACPI: Power Button [PWRF]
[    0.838281] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.838335] ACPI: Power Button [PWRB]
[    0.838485] processor LNXCPU:00: registered as cooling_device0
[    0.838520] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.838617] processor LNXCPU:01: registered as cooling_device1
[    0.838686] processor LNXCPU:02: registered as cooling_device2
[    0.838757] processor LNXCPU:03: registered as cooling_device3
[    0.842424] Linux agpgart interface v0.103
[    0.842616] ahci 0000:00:11.0: version 3.0
[    0.842625]   alloc irq_desc for 22 on node -1
[    0.842626]   alloc kstat_irqs on node -1
[    0.842630] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.842778] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode
[    0.842832] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio 
slum part 
[    0.843386] scsi0 : ahci
[    0.843513] scsi1 : ahci
[    0.843610] scsi2 : ahci
[    0.843705] scsi3 : ahci
[    0.843803] scsi4 : ahci
[    0.843899] scsi5 : ahci
[    0.844031] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed 
irq 22
[    0.844085] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 
22
[    0.844140] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 
22
[    0.844195] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 
22
[    0.844249] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 
22
[    0.844304] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 
22
[    0.844549] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.844584] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp
[    0.845080] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.845201] mice: PS/2 mouse device common for all mice
[    0.845350] rtc_cmos 00:02: RTC can wake from S4
[    0.845414] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.845470] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.845525] md: raid1 personality registered for level 1
[    0.845560] md: raid6 personality registered for level 6
[    0.845594] md: raid5 personality registered for level 5
[    0.845628] md: raid4 personality registered for level 4
[    0.846212] cpuidle: using governor ladder
[    0.846661] usbcore: registered new interface driver hiddev
[    0.846723] usbcore: registered new interface driver usbhid
[    0.846758] usbhid: v2.6:USB HID core driver
[    0.846818] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.846852] ALSA device list:
[    0.846885]   No soundcards found.
[    0.846954] TCP cubic registered
[    0.846994] NET: Registered protocol family 10
[    0.847130] IPv6 over IPv4 tunneling driver
[    0.847273] NET: Registered protocol family 17
[    0.847329] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor 
processors (4 cpu cores) (version 2.20.00)
[    0.847405] powernow-k8:    0 : pstate 0 (3200 MHz)
[    0.847439] powernow-k8:    1 : pstate 1 (2500 MHz)
[    0.847473] powernow-k8:    2 : pstate 2 (2100 MHz)
[    0.847508] powernow-k8:    3 : pstate 3 (800 MHz)
[    0.847905] PM: Resume from disk failed.
[    0.847987]   Magic number: 9:524:483
[    0.870676] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input2
[    1.163787] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.163848] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.163901] ata3: SATA link down (SStatus 0 SControl 300)
[    1.164198] ata6: SATA link down (SStatus 0 SControl 300)
[    1.164257] ata5: SATA link down (SStatus 0 SControl 300)
[    1.170142] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[    1.170184] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.170231] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.170266] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.176638] ata4.00: configured for UDMA/133
[    1.176694] ata2.00: configured for UDMA/133
[    1.563786] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.570138] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.570174] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.576594] ata1.00: configured for UDMA/133
[    1.587995] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5
[    1.588225] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.588240] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.588302] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5
[    1.588389] sd 0:0:0:0: [sda] Write Protect is off
[    1.588415] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.588433] sd 1:0:0:0: [sdb] Write Protect is off
[    1.588434] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.588443] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    1.588497]  sdb:
[    1.588544] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.588603] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 
PQ: 0 ANSI: 5
[    1.588682] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.588695] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    1.588704] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 
GB/698 GiB)
[    1.588720] sd 3:0:0:0: [sdc] Write Protect is off
[    1.588722] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.588730] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    1.588770]  sdc:
[    1.588805] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.589014]  sda: sdc1 sdc2 sdc3 sdc4 < sda1 sda2 sda3 sda4 < sdb1 sdb2 
sdb3 sdb4 < sdc5 sda5 sdc6 sdb5 sda6 >
[    1.614833] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.621354]  sdb6 >
[    1.621698] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.622960]  sdc7 >
[    1.623335] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.623379] md: Waiting for all devices to be available before autodetect
[    1.623414] md: If you don't use raid, use raid=noautodetect
[    1.623531] md: Autodetecting RAID arrays.
[    1.721437] md: Scanned 12 and added 12 devices.
[    1.721472] md: autorun ...
[    1.721506] md: considering sdc6 ...
[    1.721541] md:  adding sdc6 ...
[    1.721576] md: sdc5 has different UUID to sdc6
[    1.721610] md: sdc3 has different UUID to sdc6
[    1.721645] md: sdc1 has different UUID to sdc6
[    1.721680] md:  adding sdb6 ...
[    1.721714] md: sdb5 has different UUID to sdc6
[    1.721749] md: sdb3 has different UUID to sdc6
[    1.721784] md: sdb1 has different UUID to sdc6
[    1.721819] md:  adding sda6 ...
[    1.721853] md: sda5 has different UUID to sdc6
[    1.721887] md: sda3 has different UUID to sdc6
[    1.721922] md: sda1 has different UUID to sdc6
[    1.722054] md: created md3
[    1.722088] md: bind<sda6>
[    1.722125] md: bind<sdb6>
[    1.722162] md: bind<sdc6>
[    1.722198] md: running: <sdc6><sdb6><sda6>
[    1.722339] raid5: device sdc6 operational as raid disk 2
[    1.722373] raid5: device sdb6 operational as raid disk 1
[    1.722407] raid5: device sda6 operational as raid disk 0
[    1.722561] raid5: allocated 3220kB for md3
[    1.722608] raid5: raid level 5 set md3 active with 3 out of 3 devices, 
algorithm 2
[    1.722661] RAID5 conf printout:
[    1.722694]  --- rd:3 wd:3
[    1.722728]  disk 0, o:1, dev:sda6
[    1.722761]  disk 1, o:1, dev:sdb6
[    1.722795]  disk 2, o:1, dev:sdc6
[    1.722841] md3: detected capacity change from 0 to 864065421312
[    1.722898] md: considering sdc5 ...
[    1.722934] md:  adding sdc5 ...
[    1.722968] md: sdc3 has different UUID to sdc5
[    1.723003] md: sdc1 has different UUID to sdc5
[    1.723038] md:  adding sdb5 ...
[    1.723072] md: sdb3 has different UUID to sdc5
[    1.723107] md: sdb1 has different UUID to sdc5
[    1.723142] md:  adding sda5 ...
[    1.723176] md: sda3 has different UUID to sdc5
[    1.723211] md: sda1 has different UUID to sdc5
[    1.723307] md: created md2
[    1.723342] md: bind<sda5>
[    1.723378] md: bind<sdb5>
[    1.723416] md: bind<sdc5>
[    1.723452] md: running: <sdc5><sdb5><sda5>
[    1.723586] raid5: device sdc5 operational as raid disk 2
[    1.723620] raid5: device sdb5 operational as raid disk 1
[    1.723655] raid5: device sda5 operational as raid disk 0
[    1.723813] raid5: allocated 3220kB for md2
[    1.723859] raid5: raid level 5 set md2 active with 3 out of 3 devices, 
algorithm 2
[    1.723913] RAID5 conf printout:
[    1.723946]  --- rd:3 wd:3
[    1.723979]  disk 0, o:1, dev:sda5
[    1.724012]  disk 1, o:1, dev:sdb5
[    1.724046]  disk 2, o:1, dev:sdc5
[    1.724090] md2: detected capacity change from 0 to 40007499776
[    1.724146] md: considering sdc3 ...
[    1.724181] md:  adding sdc3 ...
[    1.724216] md: sdc1 has different UUID to sdc3
[    1.724251] md:  adding sdb3 ...
[    1.724285] md: sdb1 has different UUID to sdc3
[    1.724321] md:  adding sda3 ...
[    1.724355] md: sda1 has different UUID to sdc3
[    1.724452] md: created md1
[    1.724486] md: bind<sda3>
[    1.724523] md: bind<sdb3>
[    1.724559] md: bind<sdc3>
[    1.724599] md: running: <sdc3><sdb3><sda3>
[    1.724733] raid5: device sdc3 operational as raid disk 2
[    1.724767] raid5: device sdb3 operational as raid disk 1
[    1.724802] raid5: device sda3 operational as raid disk 0
[    1.724960] raid5: allocated 3220kB for md1
[    1.725006] raid5: raid level 5 set md1 active with 3 out of 3 devices, 
algorithm 2
[    1.725059] RAID5 conf printout:
[    1.725093]  --- rd:3 wd:3
[    1.725126]  disk 0, o:1, dev:sda3
[    1.725159]  disk 1, o:1, dev:sdb3
[    1.725193]  disk 2, o:1, dev:sdc3
[    1.725241] md1: detected capacity change from 0 to 79998877696
[    1.725297] md: considering sdc1 ...
[    1.725333] md:  adding sdc1 ...
[    1.725367] md:  adding sdb1 ...
[    1.725402] md:  adding sda1 ...
[    1.725436] md: created md0
[    1.725469] md: bind<sda1>
[    1.725505] md: bind<sdb1>
[    1.725543] md: bind<sdc1>
[    1.725579] md: running: <sdc1><sdb1><sda1>
[    1.725747] raid1: raid set md0 active with 3 out of 3 mirrors
[    1.725791] md0: detected capacity change from 0 to 65667072
[    1.725845] md: ... autorun DONE.
[    1.725897] md: Loading md3: /dev/sda3
[    1.725935]  md3: unknown partition table
[    1.726092] md: couldn't update array info. -22
[    1.726129] md: could not bd_claim sda3.
[    1.726163] md: md_import_device returned -16
[    1.726199] md: could not bd_claim sdb3.
[    1.726233] md: md_import_device returned -16
[    1.726269] md: could not bd_claim sdc3.
[    1.726303] md: md_import_device returned -16
[    1.726338] md: starting md3 failed
[    1.726412]  md1: unknown partition table
[    1.773805] reiser4: md1: found disk format 4.0.0.
[    5.791018] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.
[    5.791069] Freeing unused kernel memory: 376k freed
[    9.028747] udev: starting version 145
[    9.229559]  md2:
[    9.229712]  md0: unknown partition table
[    9.266552]  unknown partition table
[   10.399918] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.399933] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.400165] r8169 0000:01:00.0: setting latency timer to 64
[   10.400196]   alloc irq_desc for 28 on node -1
[   10.400198]   alloc kstat_irqs on node -1
[   10.400207] r8169 0000:01:00.0: irq 28 for MSI/MSI-X
[   10.400309] eth0: RTL8168c/8111c at 0xffffc90012fba000, 00:19:66:86:ce:12, 
XID 3c4000c0 IRQ 28
[   10.443002] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.443005] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[   10.443032] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17
[   10.443071] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   10.443237] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1
[   10.443244] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6
[   10.443247] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024
[   10.443269] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround
[   10.443275] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[   10.443287] ehci_hcd 0000:00:12.2: debug port 1
[   10.443292] ehci_hcd 0000:00:12.2: MWI active
[   10.443293] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[   10.443307] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[   10.443310] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[   10.443315] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN
[   10.451257] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.451287] usb usb1: default language 0x0409
[   10.451291] usb usb1: udev 1, busnum 1, minor = 0
[   10.451292] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.451293] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   10.451295] usb usb1: Product: EHCI Host Controller
[   10.451296] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.451297] usb usb1: SerialNumber: 0000:00:12.2
[   10.451321] usb usb1: uevent
[   10.451642] usb usb1: usb_probe_device
[   10.451644] usb usb1: configuration #1 chosen from 1 choice
[   10.451649] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   10.451658] usb 1-0:1.0: uevent
[   10.451684] hub 1-0:1.0: usb_probe_interface
[   10.451686] hub 1-0:1.0: usb_probe_interface - got id
[   10.451687] hub 1-0:1.0: USB hub found
[   10.451693] hub 1-0:1.0: 6 ports detected
[   10.451694] hub 1-0:1.0: standalone hub
[   10.451695] hub 1-0:1.0: no power switching (usb 1.0)
[   10.451696] hub 1-0:1.0: individual port over-current protection
[   10.451697] hub 1-0:1.0: power on to power good time: 20ms
[   10.451700] hub 1-0:1.0: local power source is good
[   10.451702] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   10.451743]   alloc irq_desc for 19 on node -1
[   10.451745]   alloc kstat_irqs on node -1
[   10.451749] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[   10.451769] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   10.451810] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2
[   10.451816] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6
[   10.451819] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024
[   10.451832] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround
[   10.451838] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[   10.451851] ehci_hcd 0000:00:13.2: debug port 1
[   10.451854] ehci_hcd 0000:00:13.2: MWI active
[   10.451855] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[   10.451865] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[   10.451868] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT
[   10.451873] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN
[   10.461264] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.461284] usb usb2: default language 0x0409
[   10.461288] usb usb2: udev 1, busnum 2, minor = 128
[   10.461289] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.461290] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   10.461292] usb usb2: Product: EHCI Host Controller
[   10.461293] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.461294] usb usb2: SerialNumber: 0000:00:13.2
[   10.461316] usb usb2: uevent
[   10.461357] usb usb2: usb_probe_device
[   10.461358] usb usb2: configuration #1 chosen from 1 choice
[   10.461363] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   10.461372] usb 2-0:1.0: uevent
[   10.461389] hub 2-0:1.0: usb_probe_interface
[   10.461390] hub 2-0:1.0: usb_probe_interface - got id
[   10.461391] hub 2-0:1.0: USB hub found
[   10.461396] hub 2-0:1.0: 6 ports detected
[   10.461397] hub 2-0:1.0: standalone hub
[   10.461398] hub 2-0:1.0: no power switching (usb 1.0)
[   10.461399] hub 2-0:1.0: individual port over-current protection
[   10.461400] hub 2-0:1.0: power on to power good time: 20ms
[   10.461402] hub 2-0:1.0: local power source is good
[   10.461403] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   10.482889] Linux video capture interface: v2.00
[   10.494771] bttv: driver version 0.9.18 loaded
[   10.494773] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   10.494836] bttv: Bt8xx card found (0).
[   10.494844]   alloc irq_desc for 21 on node -1
[   10.494846]   alloc kstat_irqs on node -1
[   10.494850] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.494860] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, 
mmio: 0xfcfff000
[   10.494900] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra 
TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[   10.494903] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.494937] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   10.551270] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER 
sig=j CSC CONNECT
[   10.551272] hub 1-0:1.0: port 2: status 0501 change 0001
[   10.561275] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   10.651263] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   10.651272] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   10.703779] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.703783] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT
[   10.757102] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   10.810459] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.810462] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT
[   10.881956] usb 1-2: default language 0x0409
[   10.882205] usb 1-2: udev 2, busnum 1, minor = 1
[   10.882206] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[   10.882207] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0
[   10.882209] usb 1-2: Product: USB2.0 Hub
[   10.882246] usb 1-2: uevent
[   10.882256] usb 1-2: usb_probe_device
[   10.882258] usb 1-2: configuration #1 chosen from 1 choice
[   10.882682] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[   10.882694] usb 1-2:1.0: uevent
[   10.882702] hub 1-2:1.0: usb_probe_interface
[   10.882703] hub 1-2:1.0: usb_probe_interface - got id
[   10.882707] hub 1-2:1.0: USB hub found
[   10.882955] hub 1-2:1.0: 4 ports detected
[   10.882956] hub 1-2:1.0: standalone hub
[   10.882957] hub 1-2:1.0: individual port power switching
[   10.882958] hub 1-2:1.0: individual port over-current protection
[   10.882960] hub 1-2:1.0: Single TT
[   10.882961] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[   10.882962] hub 1-2:1.0: Port indicators are supported
[   10.882963] hub 1-2:1.0: power on to power good time: 100ms
[   10.883330] hub 1-2:1.0: local power source is good
[   10.883332] hub 1-2:1.0: enabling power on all ports
[   10.985086] hub 1-2:1.0: port 2: status 0301 change 0001
[   11.084589] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[   11.084596] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[   11.084835] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[   11.151839] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3
[   11.238593] usb 1-2.2: skipped 1 descriptor after interface
[   11.238595] usb 1-2.2: skipped 1 descriptor after interface
[   11.239091] usb 1-2.2: default language 0x0409
[   11.241347] usb 1-2.2: udev 3, busnum 1, minor = 2
[   11.241348] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[   11.241350] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   11.241351] usb 1-2.2: Product: USB Receiver
[   11.241352] usb 1-2.2: Manufacturer: Logitech
[   11.241374] usb 1-2.2: uevent
[   11.241385] usb 1-2.2: usb_probe_device
[   11.241386] usb 1-2.2: configuration #1 chosen from 1 choice
[   11.248723] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[   11.248732] usb 1-2.2:1.0: uevent
[   11.248744] usbhid 1-2.2:1.0: usb_probe_interface
[   11.248745] usbhid 1-2.2:1.0: usb_probe_interface - got id
[   11.249081] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.251955] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
[   11.251996] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   11.252005] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[   11.252017] usb 1-2.2:1.1: uevent
[   11.252024] usbhid 1-2.2:1.1: usb_probe_interface
[   11.252025] usbhid 1-2.2:1.1: usb_probe_interface - got id
[   11.252330] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.257642] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
[   11.257649] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[   11.257662] drivers/usb/core/file.c: looking for a minor, starting at 96
[   11.257689] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   11.257703] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[   11.280255] usb 1-2.2:1.0: uevent
[   11.280300] usb 1-2.2: uevent
[   11.280684] usb 1-2.2:1.0: uevent
[   11.280733] usb 1-2.2: uevent
[   11.280756] usb 1-2.2:1.1: uevent
[   11.280808] usb 1-2.2: uevent
[   11.281305] usb 1-2.2:1.0: uevent
[   11.281513] usb 1-2.2:1.1: uevent
[   11.289425] usb 1-2.2:1.0: uevent
[   11.500033] bttv0: tea5757: read timeout
[   11.500035] bttv0: tuner type=5
[   11.514539] bttv0: audio absent, no audio device found!
[   11.524867] TUNER: Unable to find symbol tea5767_autodetection()
[   11.524870] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.527659] tuner-simple 0-0060: creating new instance
[   11.527661] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))
[   11.528497] bttv0: registered device video0
[   11.528526] bttv0: registered device vbi0
[   11.821758] reiser4: md2: found disk format 4.0.0.
[   13.632790] reiser4: md3: found disk format 4.0.0.
[   54.809101] reiser4: sdc7: found disk format 4.0.0.
[   67.201688] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 
across:7815612k 
[   67.258049] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 
across:7815612k 
[   67.279757] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 
across:7815612k 
[   67.977357] w83627ehf: Found W83627EHG chip at 0x290
[   68.245636] r8169: eth0: link up
[   68.245642] r8169: eth0: link up
[   70.125283] usb usb1: uevent
[   70.125385] usb 1-0:1.0: uevent
[   70.125475] usb 1-2: uevent
[   70.125577] usb 1-2.2: uevent
[   70.125676] usb 1-2.2:1.0: uevent
[   70.126369] usb 1-2.2:1.1: uevent
[   70.127069] usb 1-2:1.0: uevent
[   70.127444] usb usb2: uevent
[   70.127542] usb 2-0:1.0: uevent
[   71.264971]   alloc irq_desc for 23 on node -1
[   71.264978]   alloc kstat_irqs on node -1
[   71.264992] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -
> IRQ 23
[   71.271929] Audigy2 value: Special config.
[   72.531061] fglrx: module license 'Proprietary. (C) 2002 - ATI 
Technologies, Starnberg, GERMANY' taints kernel.
[   72.531064] Disabling lock debugging due to kernel taint
[   72.543985] [fglrx] Maximum main memory to use for locked dma buffers: 7760 
MBytes.
[   72.544061] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.544241] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   72.544251] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.544255] pci 0000:02:00.0: setting latency timer to 64
[   72.544384] [fglrx] Kernel PAT support is enabled
[   72.544400] [fglrx] module loaded - fglrx 8.66.2 [Sep  1 2009] with 1 
minors
[   72.710232]   alloc irq_desc for 29 on node -1
[   72.710234]   alloc kstat_irqs on node -1
[   72.710243] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
[   72.710562] [fglrx] Firegl kernel thread PID: 3837
[   74.814846] [fglrx] Gart USWC size:1279 M.
[   74.814849] [fglrx] Gart cacheable size:508 M.
[   74.814852] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   74.814854] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000 
[   74.814855] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000 
[   75.970462] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  124.835074] reiser4[bogofilter(4037)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  124.835078] NOTICE: md3 does not support write barriers, using synchronous 
write instead.
[  239.027922] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  239.027929] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  239.027931] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  239.027933] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  239.028376] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  239.028378] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  474.084572] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  474.084588] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  474.084597] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  474.084605] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  474.085157] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  474.085167] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  616.832491] reiser4[ktxnmgrd:md1:ru(580)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  616.832495] NOTICE: md1 does not support write barriers, using synchronous 
write instead.
[  672.235774] reiser4[qmgr(3700)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  672.235776] NOTICE: md2 does not support write barriers, using synchronous 
write instead.
[  908.564515] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.564522] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.564524] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.564527] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.564926] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.564928] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.624512] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.624519] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.624521] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.624524] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.625050] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.625052] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.634518] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.634525] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.634527] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.634529] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.635802] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.635805] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.694512] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.694519] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.694521] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.694523] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.695301] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.695303] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.754510] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.754517] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.754519] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.754522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.755562] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.755565] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.814504] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.814509] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.814511] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.814513] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.815314] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.815317] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.874511] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.874520] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.874522] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.874525] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.875566] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.875570] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.934521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.934534] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.934541] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.934548] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.935316] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.935323] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.994519] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.994532] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.994538] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.994545] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  908.995587] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  908.995595] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.054532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.054546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.054552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.054559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.055319] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.055326] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.114525] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.114540] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.114547] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.114555] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.115588] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.115596] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.174526] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.174540] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.174547] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.174555] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.175332] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.175339] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.234519] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.234532] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.234539] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.234547] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.235588] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.235597] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.394522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.394537] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.394544] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.394552] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.395073] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.395079] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.454523] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.454538] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.454544] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.454551] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.455336] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.455343] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.514535] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.514550] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.514557] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.514565] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.515596] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.515605] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.574523] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.574537] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.574543] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.574550] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.575353] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.575360] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.634526] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.634541] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.634548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.634556] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.635581] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.635589] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.694524] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.694539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.694546] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.694554] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.695328] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.695335] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.754535] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.754551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.754558] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.754566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.755597] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.755605] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.914524] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.914539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.914546] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.914554] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.915079] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.915086] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.974523] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.974537] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.974543] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.974551] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  909.975352] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  909.975359] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.034521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.034534] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.034541] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.034548] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.035599] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.035608] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.094537] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.094552] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.094559] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.094566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.095353] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.095361] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.154521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.154535] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.154542] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.154549] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.155600] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.155609] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.214522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.214536] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.214542] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.214549] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.215342] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.215350] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.274519] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.274532] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.274538] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.274546] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.275602] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.275610] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.334526] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.334541] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.334548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.334556] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.335363] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.335370] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.394521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.394535] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.394542] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.394549] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.395603] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.395612] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.454521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.454534] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.454540] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.454547] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.455348] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.455357] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.514529] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.514542] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.514548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.514556] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.515604] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.515612] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.574527] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.574542] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.574549] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.574557] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.575355] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.575362] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.634522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.634536] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.634542] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.634550] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.635606] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.635615] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.694527] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.694543] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.694549] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.694557] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.695352] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.695359] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.754522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.754537] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.754543] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.754551] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.755961] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.755969] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.814529] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.814544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.814551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.814559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.815363] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.815370] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.874522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.874536] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.874542] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.874550] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.875593] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.875601] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.934526] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.934542] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.934548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.934556] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.935353] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.935360] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.994521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.994535] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.994541] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.994548] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  910.995610] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  910.995618] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.054521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.054534] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.054540] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.054547] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.055340] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.055347] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.114525] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.114540] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.114547] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.114555] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.115614] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.115622] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.174520] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.174533] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.174539] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.174546] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.175343] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.175350] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.234517] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.234531] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.234537] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.234544] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.235613] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.235621] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.294520] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.294533] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.294539] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.294546] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.295345] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.295352] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.354536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.354552] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.354559] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.354567] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.355617] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.355625] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.414522] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.414535] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.414541] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.414549] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.415358] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.415366] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.474519] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.474531] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.474537] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.474545] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.475616] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.475624] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.534520] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.534533] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.534539] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.534547] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.535366] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.535374] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.594534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.594549] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.594555] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.594562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.595620] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.595629] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.654525] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.654539] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.654545] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.654552] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.655371] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.655379] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.714534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.714548] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.714554] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.714562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.715623] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.715631] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.774533] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.774546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.774552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.774560] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.775372] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.775381] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.834534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.834548] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.834554] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.834562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.835623] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.835632] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.894532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.894546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.894552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.894560] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.895374] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.895382] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.954534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.954549] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.954555] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.954562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  911.955625] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  911.955634] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.014534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.014548] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.014554] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.014562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.015375] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.015384] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.074531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.074544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.074550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.074557] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.075626] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.075634] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.134537] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.134551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.134557] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.134565] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.135378] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.135386] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.194531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.194545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.194551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.194558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.195627] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.195636] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.254533] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.254546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.254552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.254560] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.255378] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.255387] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.314531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.314545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.314551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.314558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.315629] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.315638] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.374536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.374550] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.374556] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.374564] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.375381] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.375389] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.434531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.434545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.434551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.434558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.435630] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.435639] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.494532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.494546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.494552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.494560] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.495381] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.495389] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.554531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.554544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.554550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.554558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.555632] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.555640] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.614538] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.614553] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.614559] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.614566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.615384] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.615393] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.674531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.674544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.674550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.674557] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.675633] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.675642] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.734536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.734551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.734557] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.734565] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.735385] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.735394] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.794531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.794544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.794550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.794558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.795635] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.795643] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.854536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.854551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.854557] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.854564] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.855387] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.855396] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.914531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.914544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.914550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.914558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.915636] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.915645] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.974541] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.974555] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.974561] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.974569] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  912.975388] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  912.975397] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.034531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.034544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.034550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.034558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.035651] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.035660] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.094533] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.094547] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.094553] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.094560] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.095388] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.095397] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.154536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.154551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.154557] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.154565] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.155641] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.155649] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.214534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.214548] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.214554] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.214561] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.215390] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.215399] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.274531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.274545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.274551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.274558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.275641] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.275649] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.334532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.334546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.334552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.334559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.335384] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.335392] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.394535] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.394549] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.394555] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.394563] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.395643] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.395652] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.454532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.454546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.454552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.454559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.455393] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.455402] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.514531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.514545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.514551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.514558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.515643] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.515652] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.574532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.574546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.574552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.574559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.575395] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.575404] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.634539] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.634554] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.634560] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.634567] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.635646] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.635655] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.694532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.694546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.694552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.694559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.695397] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.695406] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.754534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.754549] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.754555] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.754562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  913.755648] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  913.755656] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.914535] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.914551] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  922.914560] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.914568] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.914984] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  922.914991] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.974536] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.974552] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  922.974558] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.974566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  922.975510] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  922.975520] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.034531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.034545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.034551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.034559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.034984] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.034990] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.094537] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.094552] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.094558] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.094566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.095513] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.095522] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.154531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.154545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.154551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.154559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.154986] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.154992] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.214539] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.214554] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.214560] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.214568] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.215514] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.215523] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.274531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.274545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.274551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.274558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.274987] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.274993] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.334532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.334546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.334552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.334559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.335514] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.335523] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.394530] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.394544] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.394550] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.394558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.394989] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.394995] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.454537] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.454552] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.454559] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.454566] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.455508] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.455517] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.514531] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.514545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.514551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.514558] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.514990] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.514996] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.574532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.574546] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.574552] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.574559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.575516] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.575525] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.634521] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.634535] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.634541] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.634549] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.634999] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.635006] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.694533] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.694548] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.694554] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.694562] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.695515] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.695524] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.754529] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.754542] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.754548] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.754556] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.754992] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.754998] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.814532] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.814545] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.814551] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.814559] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.815516] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.815524] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.874534] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.874550] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.874556] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.874564] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  923.874996] ehci_hcd 0000:00:12.2: reused qh ffff8800c78003c0 schedule
[  923.875002] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  950.466763] ehci_hcd 0000:00:13.2: remove, state 1                                 
[  950.466769] ehci_hcd 0000:00:13.2: roothub graceful disconnect                     
[  950.466782] usb usb2: USB disconnect, address 1                                    
[  950.466786] usb usb2: unregistering device                                         
[  950.466791] usb usb2: usb_disable_device nuking all URBs                           
[  950.466801] ehci_hcd 0000:00:13.2: shutdown urb ffff8802349393c0 ep1in-intr        
[  950.466807] usb usb2: unregistering interface 2-0:1.0                              
[  950.466903] usb 2-0:1.0: uevent                                                    
[  950.473459] usb usb2: uevent                                                       
[  950.473496] ehci_hcd 0000:00:13.2: stop                                            
[  950.474367] ehci_hcd 0000:00:13.2: reset command 01000a (park)=0 ithresh=1 
period=256 Reset HALT                                                                         
[  950.474401] ehci_hcd 0000:00:13.2: irq normal 0 err 0 reclaim 0 (lost 0)           
[  950.474406] ehci_hcd 0000:00:13.2: complete 0 unlink 0                             
[  950.474415] ehci_hcd 0000:00:13.2: ehci_stop completed status 1000 Halt            
[  950.474428] ehci_hcd 0000:00:13.2: USB bus 2 deregistered                          
[  950.474636] ehci_hcd 0000:00:13.2: PCI INT B disabled                              
[  950.475124] ehci_hcd 0000:00:12.2: remove, state 1                                 
[  950.475129] ehci_hcd 0000:00:12.2: roothub graceful disconnect                     
[  950.475141] usb usb1: USB disconnect, address 1                                    
[  950.475146] usb 1-2: USB disconnect, address 2                                     
[  950.475151] usb 1-2.2: USB disconnect, address 3                                   
[  950.475155] usb 1-2.2: unregistering device                                        
[  950.475160] usb 1-2.2: usb_disable_device nuking all URBs                          
[  950.475174] usb 1-2.2: unlink qh8-0601/ffff8800c78003c0 start 3 [1/2 us]           
[  950.475188] ehci_hcd 0000:00:12.2: shutdown urb ffff880235a04c00 ep1in-intr        
[  950.475197] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]           
[  950.475207] ehci_hcd 0000:00:12.2: shutdown urb ffff88023706e240 ep2in-intr        
[  950.475214] usb 1-2.2: unregistering interface 1-2.2:1.0                           
[  950.493804] usb 1-2.2:1.0: uevent                                                  
[  950.493908] usb 1-2.2: unregistering interface 1-2.2:1.1                           
[  950.527053] drivers/usb/core/file.c: removing 96 minor                             
[  950.528459] usb 1-2.2:1.1: uevent                                                  
[  950.528792] usb 1-2.2: uevent                                                      
[  950.529311] usb 1-2: unregistering device                                          
[  950.529318] usb 1-2: usb_disable_device nuking all URBs                            
[  950.529332] usb 1-2: unlink qh256-0001/ffff8800c7800180 start 1 [1/0 us]           
[  950.529403] ehci_hcd 0000:00:12.2: shutdown urb ffff880233cfa6c0 ep1in-intr        
[  950.530699] usb 1-2: unregistering interface 1-2:1.0                               
[  950.530803] usb 1-2:1.0: uevent                                                    
[  950.531187] usb 1-2: uevent                                                        
[  950.531616] usb usb1: unregistering device                                         
[  950.531622] usb usb1: usb_disable_device nuking all URBs                           
[  950.531632] ehci_hcd 0000:00:12.2: shutdown urb ffff880234822840 ep1in-intr        
[  950.531638] usb usb1: unregistering interface 1-0:1.0                              
[  950.531719] usb 1-0:1.0: uevent                                                    
[  950.532034] usb usb1: uevent                                                       
[  950.532436] ehci_hcd 0000:00:12.2: stop                                            
[  950.532810] ehci_hcd 0000:00:12.2: reset command 01000a (park)=0 ithresh=1 
period=256 Reset HALT                                                                         
[  950.532847] ehci_hcd 0000:00:12.2: irq normal 10184 err 2 reclaim 118 (lost 
0)     
[  950.532853] ehci_hcd 0000:00:12.2: complete 10290 unlink 3                         
[  950.532861] ehci_hcd 0000:00:12.2: ehci_stop completed status 1000 Halt            
[  950.532874] ehci_hcd 0000:00:12.2: USB bus 1 deregistered                          
[  950.533341] ehci_hcd 0000:00:12.2: PCI INT B disabled                              
[  960.865917] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver             
[  960.865926] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96                   
[  960.865983] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17      
[  960.866052] ehci_hcd 0000:00:12.2: EHCI Host Controller                            
[  960.866238] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1   
[  960.866254] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                       
[  960.866263] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024                                                                                   
[  960.866305] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround  
[  960.866320] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                        
[  960.866341] ehci_hcd 0000:00:12.2: debug port 1                                    
[  960.866348] ehci_hcd 0000:00:12.2: MWI active                                      
[  960.866352] ehci_hcd 0000:00:12.2: supports USB remote wakeup                      
[  960.866372] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000                       
[  960.866381] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                        
[  960.866393] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN                                                                                 
[  960.873687] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00                      
[  960.873741] usb usb1: default language 0x0409                                      
[  960.873755] usb usb1: udev 1, busnum 1, minor = 0                                  
[  960.873760] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002          
[  960.873766] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1     
[  960.873771] usb usb1: Product: EHCI Host Controller                                
[  960.873775] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd                        
[  960.873779] usb usb1: SerialNumber: 0000:00:12.2                                   
[  960.873866] usb usb1: uevent                                                       
[  960.873994] usb usb1: usb_probe_device                                             
[  960.874001] usb usb1: configuration #1 chosen from 1 choice                        
[  960.874017] usb usb1: adding 1-0:1.0 (config #1, interface 0)                      
[  960.874053] usb 1-0:1.0: uevent                                                    
[  960.874124] hub 1-0:1.0: usb_probe_interface                                       
[  960.874129] hub 1-0:1.0: usb_probe_interface - got id                              
[  960.874133] hub 1-0:1.0: USB hub found                                             
[  960.874148] hub 1-0:1.0: 6 ports detected                                          
[  960.874152] hub 1-0:1.0: standalone hub                                            
[  960.874155] hub 1-0:1.0: no power switching (usb 1.0)                              
[  960.874159] hub 1-0:1.0: individual port over-current protection                   
[  960.874164] hub 1-0:1.0: power on to power good time: 20ms                         
[  960.874173] hub 1-0:1.0: local power source is good                                
[  960.874178] hub 1-0:1.0: trying to enable port power on non-switchable hub         
[  960.874278] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19      
[  960.874315] ehci_hcd 0000:00:13.2: EHCI Host Controller                            
[  960.874445] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2   
[  960.874459] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                       
[  960.874468] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024                                                                                   
[  960.874501] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround  
[  960.874515] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                        
[  960.874536] ehci_hcd 0000:00:13.2: debug port 1                                    
[  960.874544] ehci_hcd 0000:00:13.2: MWI active                                      
[  960.874548] ehci_hcd 0000:00:13.2: supports USB remote wakeup                      
[  960.874566] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800                       
[  960.874575] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                        
[  960.874587] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN                                                                                 
[  960.883687] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00                      
[  960.883736] usb usb2: default language 0x0409                                      
[  960.883749] usb usb2: udev 1, busnum 2, minor = 128                                
[  960.883754] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002          
[  960.883759] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1     
[  960.883764] usb usb2: Product: EHCI Host Controller                                
[  960.883768] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd                        
[  960.883772] usb usb2: SerialNumber: 0000:00:13.2                                   
[  960.883852] usb usb2: uevent                                                       
[  960.883976] usb usb2: usb_probe_device                                             
[  960.883982] usb usb2: configuration #1 chosen from 1 choice                        
[  960.883995] usb usb2: adding 2-0:1.0 (config #1, interface 0)                      
[  960.884029] usb 2-0:1.0: uevent                                                    
[  960.884114] hub 2-0:1.0: usb_probe_interface                                       
[  960.884118] hub 2-0:1.0: usb_probe_interface - got id                              
[  960.884122] hub 2-0:1.0: USB hub found                                             
[  960.884136] hub 2-0:1.0: 6 ports detected                                          
[  960.884140] hub 2-0:1.0: standalone hub                                            
[  960.884143] hub 2-0:1.0: no power switching (usb 1.0)                              
[  960.884147] hub 2-0:1.0: individual port over-current protection                   
[  960.884152] hub 2-0:1.0: power on to power good time: 20ms                         
[  960.884160] hub 2-0:1.0: local power source is good                                
[  960.884165] hub 2-0:1.0: trying to enable port power on non-switchable hub         
[  960.973704] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER 
sig=j CSC CONNECT                                                                                
[  960.973713] hub 1-0:1.0: port 2: status 0501 change 0001                           
[  960.983729] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000                         
[  961.073705] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000                         
[  961.073725] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s                
[  961.127893] ehci_hcd 0000:00:12.2: port 2 high speed                               
[  961.127905] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT                                                                               
[  961.181195] usb 1-2: new high speed USB device using ehci_hcd and address 2        
[  961.234546] ehci_hcd 0000:00:12.2: port 2 high speed                               
[  961.234557] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT                                                                               
[  961.306035] usb 1-2: default language 0x0409                                       
[  961.306410] usb 1-2: udev 2, busnum 1, minor = 1                                   
[  961.306415] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608           
[  961.306420] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0      
[  961.306426] usb 1-2: Product: USB2.0 Hub                                           
[  961.306529] usb 1-2: uevent                                                        
[  961.306558] usb 1-2: usb_probe_device                                              
[  961.306565] usb 1-2: configuration #1 chosen from 1 choice                         
[  961.308320] usb 1-2: adding 1-2:1.0 (config #1, interface 0)                       
[  961.308363] usb 1-2:1.0: uevent                                                    
[  961.308390] hub 1-2:1.0: usb_probe_interface
[  961.308394] hub 1-2:1.0: usb_probe_interface - got id
[  961.308398] hub 1-2:1.0: USB hub found
[  961.308919] hub 1-2:1.0: 4 ports detected
[  961.308923] hub 1-2:1.0: standalone hub
[  961.308927] hub 1-2:1.0: individual port power switching
[  961.308931] hub 1-2:1.0: individual port over-current protection
[  961.308935] hub 1-2:1.0: Single TT
[  961.308940] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[  961.308944] hub 1-2:1.0: Port indicators are supported
[  961.308948] hub 1-2:1.0: power on to power good time: 100ms
[  961.309409] hub 1-2:1.0: local power source is good
[  961.309414] hub 1-2:1.0: enabling power on all ports
[  961.411788] hub 1-2:1.0: port 2: status 0301 change 0001
[  961.511193] usb 1-2: link qh256-0001/ffff8800c7592180 start 1 [1/0 us]
[  961.511213] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[  961.511547] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[  961.578584] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3
[  961.665692] usb 1-2.2: skipped 1 descriptor after interface
[  961.665700] usb 1-2.2: skipped 1 descriptor after interface
[  961.666184] usb 1-2.2: default language 0x0409
[  961.668423] usb 1-2.2: udev 3, busnum 1, minor = 2
[  961.668429] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[  961.668435] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[  961.668440] usb 1-2.2: Product: USB Receiver
[  961.668444] usb 1-2.2: Manufacturer: Logitech
[  961.668552] usb 1-2.2: uevent
[  961.668578] usb 1-2.2: usb_probe_device
[  961.668584] usb 1-2.2: configuration #1 chosen from 1 choice
[  961.675815] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[  961.675868] usb 1-2.2:1.0: uevent
[  961.675901] usbhid 1-2.2:1.0: usb_probe_interface
[  961.675905] usbhid 1-2.2:1.0: usb_probe_interface - got id
[  961.676286] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[  961.680639] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input5
[  961.680779] generic-usb 0003:046D:C518.0003: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[  961.680814] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[  961.680846] usb 1-2.2:1.1: uevent
[  961.680871] usbhid 1-2.2:1.1: usb_probe_interface
[  961.680875] usbhid 1-2.2:1.1: usb_probe_interface - got id
[  961.681662] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[  961.688374] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input6
[  961.688398] usb 1-2.2: link qh8-0601/ffff8800c7592300 start 2 [1/2 us]
[  961.688454] drivers/usb/core/file.c: looking for a minor, starting at 96
[  961.688561] generic-usb 0003:046D:C518.0004: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[  961.688623] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[  961.696088] usb 1-2.2:1.0: uevent
[  961.696263] usb 1-2.2: uevent
[  961.696624] usb 1-2.2:1.0: uevent
[  961.696805] usb 1-2.2: uevent
[  961.698587] usb 1-2.2:1.0: uevent
[  961.699721] usb 1-2.2:1.0: uevent
[  961.699845] usb 1-2.2:1.1: uevent
[  961.700005] usb 1-2.2: uevent
[  961.705651] usb 1-2.2:1.1: uevent
[  961.724537] usb 1-2.2: link qh8-0601/ffff8800c75923c0 start 3 [1/2 us]


Glück Auf,
Volker

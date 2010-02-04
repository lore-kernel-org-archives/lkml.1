Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0BDHS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:18:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab0BDHSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:18:55 -0500
Date: Thu, 4 Feb 2010 08:17:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch out
 of staging."
Message-ID: <20100204071705.GA28403@elte.hu>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <21d7e9971002020035v22318962w6412ccd8d93449da@mail.gmail.com>
 <20100202154656.GD27314@elte.hu>
 <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
 <20100204062619.GA29154@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20100204062619.GA29154@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 2.4
X-ELTE-SpamLevel: ss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=2.4 required=5.9 tests=FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.5
	2.4 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> * Dave Airlie <airlied@gmail.com> wrote:
> 
> > On Wed, Feb 3, 2010 at 1:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Dave Airlie <airlied@gmail.com> wrote:
> > >
> > >> On Tue, Feb 2, 2010 at 6:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >> >
> > >> > * Dave Airlie <airlied@linux.ie> wrote:
> > >> >
> > >> >> > Hi Linus,
> > >> >> >
> > >> >> > Please pull the 'drm-linus' branch from
> > >> >> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> > >> >> >
> > >> >>
> > >> >> I've also added an oops fix I seem to lose off my radar to this tree.
> > >> >>
> > >> >> commit 17aafccab4352b422aa01fa6ebf82daff693a5b3
> > >> >> Author: Michel D??nzer <daenzer@vmware.com>
> > >> >> Date: ? Fri Jan 22 09:20:00 2010 +0100
> > >> >>
> > >> >> ? ? drm/radeon/kms: Fix oops after radeon_cs_parser_init() failure.
> > >> >
> > >>
> > >> Wierd this suggests something else is wrong on that machine can you get me
> > >> the whole dmesg? I'm guessing some iommu or swiotlb issue.
> > >
> > > This box has no known hardware or software problems, just this week it booted
> > > in excess of 1000 kernels so i'd exclude that angle for now.
> > >
> > > I have bisected the crash back to the DRM tree and the crash went away with
> > > the Kconfig revert i applied - and it got fixed by Jerome's patch. I posted
> > > my config and i posted the relevant boot log as well. Find below the full
> > > bootlog as well with vanilla -git (ab65832) and the config. (i dont think it
> > > matters)
> > >
> > >> I've asked Jerome to fix the oops, but really anyone with an old .config
> > >> won't get hit by this, and we've booted this on quite a lot of machines at
> > >> this point.
> > >
> > > I dont see the commit in yesterday's linux-next. It has very fresh
> > > timestamps:
> > >
> > > ?commit f71d0187987e691516cd10c2702f002c0e2f0edc
> > > ?Author: ? ? Dave Airlie <airlied@redhat.com>
> > > ?AuthorDate: Mon Feb 1 11:35:47 2010 +1000
> > > ?Commit: ? ? Dave Airlie <airlied@redhat.com>
> > > ?CommitDate: Mon Feb 1 11:35:47 2010 +1000
> > >
> > > What kind of widespread testing could this commit have gotten in the less
> > > than 24 hours before it hit mainline?
> > >
> > 
> > Its shipping in a major distro by default, its planned to be shipped in an 
> > even more major distro. Its been boot tested on 1000s of machines by 1000s 
> > of ppl.
> 
> Well but that's not the precise tree you sent to Linus, is it?

btw., i just found another bug activated via this same commit, a boot hang 
after DRM init:

[    9.858352] [drm] Connector 1:
[    9.861417] [drm]   DVI-I
[    9.864031] [drm]   HPD1
[    9.866562] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    9.872579] [drm]   Encoders:
[    9.875540] [drm]     CRT2: INTERNAL_DAC2
[    9.879541] [drm]     DFP1: INTERNAL_TMDS1
[    9.883646] [drm] Connector 2:
[    9.886695] [drm]   S-video
[    9.889483] [drm]   Encoders:
[    9.892463] [drm]     TV1: INTERNAL_DAC2
[    9.896392] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
[    9.901796] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
[    9.909246] i2c i2c-0: NAK from device addr 0x50 msg #0
[    9.914564] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[    9.919957] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[    9.927413] i2c i2c-1: NAK from device addr 0x50 msg #0

(i power cycled the box after 45 minutes of waiting.)

The hang goes away if i revert commit f71d0187987e6 via the patch below, the 
boot sequence becomes:

[    9.068911] calling  drm_core_init+0x0/0x137 @ 1
[    9.073617] [drm] Initialized drm 1.1.0 20060810
[    9.078232] initcall drm_core_init+0x0/0x137 returned 0 after 4586 usecs
[    9.120162] [drm] radeon defaulting to userspace modesetting.
[    9.154295] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0

Config and bootlog attached.

	Ingo

------------->
>From 8b607af1a03d526aef14461e84de9f427b45d64f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 2 Feb 2010 09:06:04 +0100
Subject: [PATCH] Revert "drm/radeon/kms: move radeon KMS on/off switch out of staging."

This reverts commit f71d0187987e691516cd10c2702f002c0e2f0edc.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/gpu/drm/Kconfig |    2 --
 drivers/staging/Kconfig |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..96eddd1 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -66,8 +66,6 @@ config DRM_RADEON
 
 	  If M is selected, the module will be called radeon.
 
-source "drivers/gpu/drm/radeon/Kconfig"
-
 config DRM_I810
 	tristate "Intel I810"
 	depends on DRM && AGP && AGP_INTEL
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index fc2e963..94eb863 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -99,6 +99,8 @@ source "drivers/staging/line6/Kconfig"
 
 source "drivers/gpu/drm/vmwgfx/Kconfig"
 
+source "drivers/gpu/drm/radeon/Kconfig"
+
 source "drivers/gpu/drm/nouveau/Kconfig"
 
 source "drivers/staging/octeon/Kconfig"

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hang.log"

[    0.000000] Linux version 2.6.33-rc6-tip-00688-g4f4a2fd-dirty (mingo@sirius) (gcc version 4.4.1 20091008 (Red Hat 4.4.1-20) (GCC) ) #14894 SMP PREEMPT Thu Feb 4 09:40:09 CET 2010
[    0.000000] Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5680] f5680
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 16000-19000
[    0.000000] ACPI: RSDP 00000000000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000003fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000003fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000003fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000003fff0000 00040
[    0.000000] ACPI: SRAT 000000003fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: MCFG 000000003fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 000000003fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-40000000
[    0.000000] NUMA: Allocated memnodemap from 17000 - 17840
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000017840 - 000000000002683f]
[    0.000000]   bootmap [0000000000027000 -  000000000002efff] pages 8
[    0.000000] (11 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0002981024]    TEXT DATA BSS ==> [0001000000 - 0002981024]
[    0.000000]   #2 [00000f5690 - 0000100000]    BIOS reserved ==> [00000f5690 - 0000100000]
[    0.000000]   #3 [00000f5680 - 00000f5690]     MP-table mpf ==> [00000f5680 - 00000f5690]
[    0.000000]   #4 [000009f800 - 00000f1400]    BIOS reserved ==> [000009f800 - 00000f1400]
[    0.000000]   #5 [00000f152c - 00000f5680]    BIOS reserved ==> [00000f152c - 00000f5680]
[    0.000000]   #6 [00000f1400 - 00000f152c]     MP-table mpc ==> [00000f1400 - 00000f152c]
[    0.000000]   #7 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #8 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #9 [0000016000 - 0000017000]          PGTABLE ==> [0000016000 - 0000017000]
[    0.000000]   #10 [0000017000 - 0000017840]       MEMNODEMAP ==> [0000017000 - 0000017840]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3824 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3528 pages used for memmap
[    0.000000]   DMA32 zone: 254504 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff880002a00000 s77008 r0 d21296 u1048576
[    0.000000] pcpu-alloc: s77008 r0 d21296 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258328
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Memory: 1007068k/1048512k available (14511k kernel code, 452k absent, 40992k reserved, 8560k data, 676k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] allocated 10485760 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.324 MHz processor.
[    0.020003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.64 BogoMIPS (lpj=20103240)
[    0.032899] Security Framework initialized
[    0.040134] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.050158] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.057321] Mount-cache hash table entries: 256
[    0.060121] Initializing cgroup subsys debug
[    0.064384] Initializing cgroup subsys ns
[    0.070004] Initializing cgroup subsys cpuacct
[    0.074441] Initializing cgroup subsys memory
[    0.078797] Initializing cgroup subsys devices
[    0.080003] Initializing cgroup subsys blkio
[    0.084294] mce: CPU supports 5 MCE banks
[    0.090002] MCE: unknown CPU type - not enabling MCE support.
[    0.095739] Performance Events: 
[    0.100666] ACPI: Core revision 20091214
[    0.116953] Setting APIC routing to flat
[    0.120310] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.227202] CPU0: AuthenticAMD AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.240000] calling  migration_init+0x0/0x5a @ 1
[    0.240012] initcall migration_init+0x0/0x5a returned 0 after 9765 usecs
[    0.246700] calling  spawn_ksoftirqd+0x0/0x59 @ 1
[    0.260006] initcall spawn_ksoftirqd+0x0/0x59 returned 0 after 9765 usecs
[    0.266784] calling  init_call_single_data+0x0/0x8a @ 1
[    0.270004] initcall init_call_single_data+0x0/0x8a returned 0 after 0 usecs
[    0.277042] calling  relay_init+0x0/0x14 @ 1
[    0.280003] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.290028] Booting Node   0, Processors  #1 Ok.
[    0.450051] Brought up 2 CPUs
[    0.453021] Total of 2 processors activated (8041.33 BogoMIPS).
[    0.463378] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.468338] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.470005] calling  net_ns_init+0x0/0xff @ 1
[    0.474389] initcall net_ns_init+0x0/0xff returned 0 after 0 usecs
[    0.480005] calling  e820_mark_nvs_memory+0x0/0x41 @ 1
[    0.490043] initcall e820_mark_nvs_memory+0x0/0x41 returned 0 after 0 usecs
[    0.496999] calling  pci_reboot_init+0x0/0x8 @ 1
[    0.500002] initcall pci_reboot_init+0x0/0x8 returned 0 after 0 usecs
[    0.506435] calling  init_lapic_sysfs+0x0/0x2d @ 1
[    0.510102] initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
[    0.520006] calling  init_smp_flush+0x0/0x2d @ 1
[    0.524617] initcall init_smp_flush+0x0/0x2d returned 0 after 0 usecs
[    0.530004] calling  alloc_frozen_cpus+0x0/0x10 @ 1
[    0.534876] initcall alloc_frozen_cpus+0x0/0x10 returned 0 after 0 usecs
[    0.540002] calling  sysctl_init+0x0/0x32 @ 1
[    0.544413] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.550002] calling  ksysfs_init+0x0/0x94 @ 1
[    0.554362] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.560003] calling  async_init+0x0/0x60 @ 1
[    0.564293] initcall async_init+0x0/0x60 returned 0 after 0 usecs
[    0.570018] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.580005] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.587302] calling  pm_init+0x0/0x34 @ 1
[    0.590005] initcall pm_init+0x0/0x34 returned 0 after 0 usecs
[    0.595829] calling  pm_disk_init+0x0/0x19 @ 1
[    0.600004] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.606264] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.610004] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.616783] calling  init_hw_breakpoint+0x0/0x12 @ 1
[    0.620004] initcall init_hw_breakpoint+0x0/0x12 returned 0 after 0 usecs
[    0.630002] calling  init_zero_pfn+0x0/0x68 @ 1
[    0.634530] initcall init_zero_pfn+0x0/0x68 returned 0 after 0 usecs
[    0.640002] calling  filelock_init+0x0/0x2e @ 1
[    0.644531] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.650002] calling  init_misc_binfmt+0x0/0x41 @ 1
[    0.654789] initcall init_misc_binfmt+0x0/0x41 returned 0 after 0 usecs
[    0.660002] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.664963] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.670002] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.680002] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.686521] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.690003] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.697127] calling  debugfs_init+0x0/0x5c @ 1
[    0.700005] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.710002] calling  securityfs_init+0x0/0x53 @ 1
[    0.714706] initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
[    0.720002] calling  calibrate_xor_blocks+0x0/0x143 @ 1
[    0.725223] xor: automatically using best checksumming function: generic_sse
[    0.780002]    generic_sse:  5970.400 MB/sec
[    0.784264] xor: using function: generic_sse (5970.400 MB/sec)
[    0.790002] initcall calibrate_xor_blocks+0x0/0x143 returned 0 after 68359 usecs
[    0.797387] calling  random32_init+0x0/0xd9 @ 1
[    0.800002] initcall random32_init+0x0/0xd9 returned 0 after 0 usecs
[    0.806349] calling  regulator_init+0x0/0x2e @ 1
[    0.810001] regulator: core version 0.5
[    0.813879] initcall regulator_init+0x0/0x2e returned 0 after 0 usecs
[    0.820007] calling  cpuidle_init+0x0/0x40 @ 1
[    0.824448] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.830004] calling  virtio_init+0x0/0x30 @ 1
[    0.834409] initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
[    0.840009] calling  sock_init+0x0/0x5e @ 1
[    0.844213] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
[    0.850002] calling  net_inuse_init+0x0/0x26 @ 1
[    0.854618] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.860002] calling  netpoll_init+0x0/0x31 @ 1
[    0.870002] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.876263] calling  netlink_proto_init+0x0/0x14a @ 1
[    0.880010] NET: Registered protocol family 16
[    0.884463] initcall netlink_proto_init+0x0/0x14a returned 0 after 0 usecs
[    0.890002] calling  bdi_class_init+0x0/0x41 @ 1
[    0.894675] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
[    0.900010] calling  kobject_uevent_init+0x0/0x54 @ 1
[    0.905061] initcall kobject_uevent_init+0x0/0x54 returned 0 after 0 usecs
[    0.910002] calling  gpiolib_sysfs_init+0x0/0x93 @ 1
[    0.920060] initcall gpiolib_sysfs_init+0x0/0x93 returned 0 after 0 usecs
[    0.926835] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.930052] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.936747] calling  pci_driver_init+0x0/0x12 @ 1
[    0.940063] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.950010] calling  lcd_class_init+0x0/0x4d @ 1
[    0.954676] initcall lcd_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.960003] calling  backlight_class_init+0x0/0x5d @ 1
[    0.965200] initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
[    0.970011] calling  video_output_class_init+0x0/0x19 @ 1
[    0.975451] initcall video_output_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.980003] calling  tty_class_init+0x0/0x38 @ 1
[    0.990060] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.996486] calling  vtconsole_class_init+0x0/0xc3 @ 1
[    1.000108] initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
[    1.007058] calling  register_node_type+0x0/0x54 @ 1
[    1.010063] initcall register_node_type+0x0/0x54 returned 0 after 0 usecs
[    1.020004] calling  i2c_init+0x0/0x70 @ 1
[    1.024211] i2c-core: driver [dummy] registered
[    1.030018] initcall i2c_init+0x0/0x70 returned 0 after 9765 usecs
[    1.036191] calling  amd_postcore_init+0x0/0x76 @ 1
[    1.040002] initcall amd_postcore_init+0x0/0x76 returned 0 after 0 usecs
[    1.046693] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    1.050005] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    1.060002] calling  mtrr_if_init+0x0/0x61 @ 1
[    1.064447] initcall mtrr_if_init+0x0/0x61 returned 0 after 0 usecs
[    1.070002] calling  ffh_cstate_init+0x0/0x2a @ 1
[    1.074704] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    1.080003] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    1.086867] calling  acpi_pci_init+0x0/0x57 @ 1
[    1.090001] ACPI: bus type pci registered
[    1.094009] initcall acpi_pci_init+0x0/0x57 returned 0 after 0 usecs
[    1.100002] calling  pci_arch_init+0x0/0x58 @ 1
[    1.104795] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.110003] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.147271] PCI: Using configuration type 1 for base access
[    1.150007] initcall pci_arch_init+0x0/0x58 returned 0 after 48828 usecs
[    1.156693] calling  topology_init+0x0/0x98 @ 1
[    1.160283] initcall topology_init+0x0/0x98 returned 0 after 0 usecs
[    1.170023] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    1.175065] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    1.180004] calling  param_sysfs_init+0x0/0xfd @ 1
[    1.252116] initcall param_sysfs_init+0x0/0xfd returned 0 after 68359 usecs
[    1.259075] calling  pm_sysrq_init+0x0/0x20 @ 1
[    1.260053] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    1.270045] calling  audit_watch_init+0x0/0x2f @ 1
[    1.274834] initcall audit_watch_init+0x0/0x2f returned 0 after 0 usecs
[    1.280048] calling  init_slow_work+0x0/0x3d @ 1
[    1.284661] initcall init_slow_work+0x0/0x3d returned 0 after 0 usecs
[    1.290047] calling  default_bdi_init+0x0/0xb1 @ 1
[    1.296195] initcall default_bdi_init+0x0/0xb1 returned 0 after 0 usecs
[    1.300004] calling  init_bio+0x0/0xd8 @ 1
[    1.304150] bio: create slab <bio-0> at 0
[    1.310051] initcall init_bio+0x0/0xd8 returned 0 after 9765 usecs
[    1.316226] calling  fsnotify_init+0x0/0x12 @ 1
[    1.320044] initcall fsnotify_init+0x0/0x12 returned 0 after 0 usecs
[    1.330046] calling  fsnotify_notification_init+0x0/0xf0 @ 1
[    1.335700] initcall fsnotify_notification_init+0x0/0xf0 returned 0 after 0 usecs
[    1.340042] calling  cryptomgr_init+0x0/0x12 @ 1
[    1.344652] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    1.350043] calling  blk_settings_init+0x0/0x2c @ 1
[    1.354911] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    1.360056] calling  blk_ioc_init+0x0/0x2a @ 1
[    1.370058] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    1.376314] calling  blk_softirq_init+0x0/0x6e @ 1
[    1.380051] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    1.386650] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    1.390009] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    1.400002] calling  genhd_device_init+0x0/0x67 @ 1
[    1.404942] initcall genhd_device_init+0x0/0x67 returned 0 after 0 usecs
[    1.410020] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    1.415328] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    1.420002] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    1.425141] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    1.430002] calling  wm831x_gpio_init+0x0/0x12 @ 1
[    1.440069] initcall wm831x_gpio_init+0x0/0x12 returned 0 after 0 usecs
[    1.446671] calling  pci_slot_init+0x0/0x50 @ 1
[    1.450062] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    1.456408] calling  fbmem_init+0x0/0x98 @ 1
[    1.460410] initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
[    1.466497] calling  acpi_init+0x0/0x123 @ 1
[    1.471385] ACPI: EC: Look up EC in DSDT
[    1.492110] ACPI: Interpreter enabled
[    1.495770] ACPI: (supports S0 S1 S3 S4 S5)
[    1.500006] ACPI: Using IOAPIC for interrupt routing
[    1.521192] initcall acpi_init+0x0/0x123 returned 0 after 48828 usecs
[    1.527625] calling  dock_init+0x0/0xa5 @ 1
[    1.530282] ACPI: No dock devices found.
[    1.534201] initcall dock_init+0x0/0xa5 returned 0 after 0 usecs
[    1.540069] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    1.545173] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.550416] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    1.560282] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.567750] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.570009] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.580002] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.590003] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
[    1.600077] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.606956] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
[    1.610008] pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
[    1.615397] pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
[    1.620010] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.630003] pci 0000:00:01.1: PME# disabled
[    1.634199] pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
[    1.640018] pci 0000:00:02.0: supports D1 D2
[    1.644278] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.650002] pci 0000:00:02.0: PME# disabled
[    1.654197] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    1.660021] pci 0000:00:02.1: supports D1 D2
[    1.664285] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.670003] pci 0000:00:02.1: PME# disabled
[    1.674200] pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
[    1.680003] pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
[    1.685397] pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
[    1.690014] pci 0000:00:04.0: supports D1 D2
[    1.694297] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    1.700037] pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
[    1.710004] pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
[    1.715408] pci 0000:00:0a.0: supports D1 D2
[    1.719673] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.720002] pci 0000:00:0a.0: PME# disabled
[    1.730030] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.736633] pci 0000:00:0b.0: PME# disabled
[    1.740032] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.746633] pci 0000:00:0c.0: PME# disabled
[    1.750037] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.756642] pci 0000:00:0d.0: PME# disabled
[    1.760031] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.766634] pci 0000:00:0e.0: PME# disabled
[    1.770111] pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
[    1.775501] pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
[    1.780026] pci 0000:05:07.0: supports D1 D2
[    1.784287] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.790003] pci 0000:05:07.0: PME# disabled
[    1.794206] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    1.800002] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.810002] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.816811] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.820034] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.830034] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.835269] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    1.840005] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    1.845397] pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
[    1.850013] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.860015] pci 0000:01:00.0: supports D1 D2
[    1.864298] pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
[    1.870030] pci 0000:01:00.1: supports D1 D2
[    1.874306] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.880034] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.890003] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.896088] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.900003] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.910016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.916242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    2.005902] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 449218 usecs
[    2.010032] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    2.015145] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.024060] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    2.032893] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    2.041581] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.050172] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.058751] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.064052] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.074058] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    2.082899] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    2.090750] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.099321] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.104058] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.114059] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.124070] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.133681] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.142276] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.150412] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    2.156973] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    2.161065] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    2.166642] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    2.171942] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    2.181489] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    2.188883] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    2.192872] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    2.201899] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    2.208325] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    2.212877] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    2.222877] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    2.231391] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    2.238803] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    2.242892] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    2.252888] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    2.260313] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 244140 usecs
[    2.267527] calling  pnp_init+0x0/0x12 @ 1
[    2.270123] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    2.276037] calling  regulator_fixed_voltage_init+0x0/0x12 @ 1
[    2.280061] initcall regulator_fixed_voltage_init+0x0/0x12 returned 0 after 0 usecs
[    2.290012] calling  wm831x_dcdc_init+0x0/0x88 @ 1
[    2.295016] initcall wm831x_dcdc_init+0x0/0x88 returned 0 after 0 usecs
[    2.300017] calling  wm831x_isink_init+0x0/0x31 @ 1
[    2.304946] initcall wm831x_isink_init+0x0/0x31 returned 0 after 0 usecs
[    2.310003] calling  wm831x_ldo_init+0x0/0x68 @ 1
[    2.320192] initcall wm831x_ldo_init+0x0/0x68 returned 0 after 0 usecs
[    2.326712] calling  ab3100_regulators_init+0x0/0x12 @ 1
[    2.330070] initcall ab3100_regulators_init+0x0/0x12 returned 0 after 0 usecs
[    2.337195] calling  tps_65023_init+0x0/0x14 @ 1
[    2.340058] i2c-core: driver [tps65023] registered
[    2.344841] initcall tps_65023_init+0x0/0x14 returned 0 after 0 usecs
[    2.350017] calling  tps_6507x_init+0x0/0x14 @ 1
[    2.354690] i2c-core: driver [tps6507x] registered
[    2.360008] initcall tps_6507x_init+0x0/0x14 returned 0 after 9765 usecs
[    2.370002] calling  misc_init+0x0/0xba @ 1
[    2.374248] initcall misc_init+0x0/0xba returned 0 after 0 usecs
[    2.380012] calling  vga_arb_device_init+0x0/0x77 @ 1
[    2.385153] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.390003] vgaarb: loaded
[    2.392711] initcall vga_arb_device_init+0x0/0x77 returned 0 after 9765 usecs
[    2.400008] calling  cn_init+0x0/0x9e @ 1
[    2.404021] initcall cn_init+0x0/0x9e returned 0 after 0 usecs
[    2.410002] calling  tifm_init+0x0/0x81 @ 1
[    2.414342] initcall tifm_init+0x0/0x81 returned 0 after 0 usecs
[    2.420012] calling  wm8400_module_init+0x0/0x33 @ 1
[    2.425027] i2c-core: driver [WM8400] registered
[    2.430004] initcall wm8400_module_init+0x0/0x33 returned 0 after 9765 usecs
[    2.440010] calling  wm831x_i2c_init+0x0/0x33 @ 1
[    2.444770] i2c-core: driver [wm831x] registered
[    2.450011] initcall wm831x_i2c_init+0x0/0x33 returned 0 after 9765 usecs
[    2.456789] calling  tps_init+0x0/0xb3 @ 1
[    2.460001] tps65010: version 2 May 2005
[    2.463977] i2c-core: driver [tps65010] registered
[    2.470065] i2c-core: driver [tps65010] unregistered
[    2.490058] i2c-core: driver [tps65010] registered
[    2.494894] i2c-core: driver [tps65010] unregistered
[    2.510068] i2c-core: driver [tps65010] registered
[    2.514908] i2c-core: driver [tps65010] unregistered
[    2.519864] tps65010: no chip?
[    2.520012] initcall tps_init+0x0/0xb3 returned -19 after 58593 usecs
[    2.526443] calling  twl_init+0x0/0x14 @ 1
[    2.530060] i2c-core: driver [twl] registered
[    2.534417] initcall twl_init+0x0/0x14 returned 0 after 0 usecs
[    2.540012] calling  da903x_init+0x0/0x14 @ 1
[    2.544419] i2c-core: driver [da903x] registered
[    2.550004] initcall da903x_init+0x0/0x14 returned 0 after 9765 usecs
[    2.556434] calling  ab3100_i2c_init+0x0/0x14 @ 1
[    2.560061] i2c-core: driver [ab3100] registered
[    2.564676] initcall ab3100_i2c_init+0x0/0x14 returned 0 after 0 usecs
[    2.570008] calling  pm8607_init+0x0/0x33 @ 1
[    2.574413] i2c-core: driver [88PM8607] registered
[    2.580004] initcall pm8607_init+0x0/0x33 returned 0 after 9765 usecs
[    2.590007] calling  init_scsi+0x0/0x81 @ 1
[    2.594445] SCSI subsystem initialized
[    2.598194] initcall init_scsi+0x0/0x81 returned 0 after 0 usecs
[    2.600007] calling  ata_init+0x0/0x85 @ 1
[    2.604172] libata version 3.00 loaded.
[    2.610003] initcall ata_init+0x0/0x85 returned 0 after 9765 usecs
[    2.616177] calling  phy_init+0x0/0x2e @ 1
[    2.620190] initcall phy_init+0x0/0x2e returned 0 after 0 usecs
[    2.626105] calling  usb_init+0x0/0x195 @ 1
[    2.630162] usbcore: registered new interface driver usbfs
[    2.635755] usbcore: registered new interface driver hub
[    2.640085] usbcore: registered new device driver usb
[    2.645127] initcall usb_init+0x0/0x195 returned 0 after 9765 usecs
[    2.650019] calling  serio_init+0x0/0x8f @ 1
[    2.660089] initcall serio_init+0x0/0x8f returned 0 after 0 usecs
[    2.666175] calling  gameport_init+0x0/0x8f @ 1
[    2.670108] initcall gameport_init+0x0/0x8f returned 0 after 0 usecs
[    2.676452] calling  input_init+0x0/0xbc @ 1
[    2.680068] initcall input_init+0x0/0xbc returned 0 after 0 usecs
[    2.686151] calling  init_dvbdev+0x0/0xd7 @ 1
[    2.690075] initcall init_dvbdev+0x0/0xd7 returned 0 after 0 usecs
[    2.696242] calling  pps_init+0x0/0xb1 @ 1
[    2.700069] LinuxPPS API ver. 1 registered
[    2.704164] Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.710003] initcall pps_init+0x0/0xb1 returned 0 after 9765 usecs
[    2.720012] calling  power_supply_class_init+0x0/0x38 @ 1
[    2.725461] initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
[    2.730009] calling  hwmon_init+0x0/0x47 @ 1
[    2.734341] initcall hwmon_init+0x0/0x47 returned 0 after 0 usecs
[    2.740003] calling  thermal_init+0x0/0x3f @ 1
[    2.744500] initcall thermal_init+0x0/0x3f returned 0 after 0 usecs
[    2.750010] calling  raid6_select_algo+0x0/0x23e @ 1
[    2.930035] raid6: int64x1   1692 MB/s
[    3.100007] raid6: int64x2   2327 MB/s
[    3.270040] raid6: int64x4   1455 MB/s
[    3.440041] raid6: int64x8   1471 MB/s
[    3.610015] raid6: sse2x1    2492 MB/s
[    3.780005] raid6: sse2x2    3355 MB/s
[    3.950011] raid6: sse2x4    3550 MB/s
[    3.953757] raid6: using algorithm sse2x4 (3550 MB/s)
[    3.958809] initcall raid6_select_algo+0x0/0x23e returned 0 after 1162109 usecs
[    3.960002] calling  md_init+0x0/0xd0 @ 1
[    3.970015] initcall md_init+0x0/0xd0 returned 0 after 0 usecs
[    3.975836] calling  leds_init+0x0/0x40 @ 1
[    3.980064] initcall leds_init+0x0/0x40 returned 0 after 0 usecs
[    3.986063] calling  acpi_wmi_init+0x0/0x98 @ 1
[    3.990167] ACPI: WMI: Mapper loaded
[    3.993743] initcall acpi_wmi_init+0x0/0x98 returned 0 after 0 usecs
[    4.000003] calling  init_soundcore+0x0/0x96 @ 1
[    4.004673] initcall init_soundcore+0x0/0x96 returned 0 after 0 usecs
[    4.010010] calling  pci_subsys_init+0x0/0x70 @ 1
[    4.014710] PCI: Using ACPI for IRQ routing
[    4.020005] PCI: pci_cache_line_size set to 64 bytes
[    4.025043] initcall pci_subsys_init+0x0/0x70 returned 0 after 9765 usecs
[    4.030002] calling  proto_init+0x0/0x12 @ 1
[    4.034272] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    4.040002] calling  net_dev_init+0x0/0x17b @ 1
[    4.044721] initcall net_dev_init+0x0/0x17b returned 0 after 0 usecs
[    4.050014] calling  neigh_init+0x0/0x71 @ 1
[    4.054279] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    4.060002] calling  fib_rules_init+0x0/0xa6 @ 1
[    4.064618] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    4.070002] calling  genl_init+0x0/0x8f @ 1
[    4.074200] initcall genl_init+0x0/0x8f returned 0 after 0 usecs
[    4.080004] calling  cipso_v4_init+0x0/0x64 @ 1
[    4.090007] initcall cipso_v4_init+0x0/0x64 returned 0 after 0 usecs
[    4.096349] calling  wanrouter_init+0x0/0x55 @ 1
[    4.100002] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    4.107305] initcall wanrouter_init+0x0/0x55 returned 0 after 0 usecs
[    4.110002] calling  irda_init+0x0/0xae @ 1
[    4.114182] irda_init()
[    4.120018] NET: Registered protocol family 23
[    4.124476] initcall irda_init+0x0/0xae returned 0 after 9765 usecs
[    4.130002] calling  bt_init+0x0/0x5a @ 1
[    4.134011] Bluetooth: Core ver 2.15
[    4.140065] NET: Registered protocol family 31
[    4.144507] Bluetooth: HCI device and connection manager initialized
[    4.150005] Bluetooth: HCI socket layer initialized
[    4.154874] initcall bt_init+0x0/0x5a returned 0 after 19531 usecs
[    4.160002] calling  atm_init+0x0/0xb4 @ 1
[    4.164096] NET: Registered protocol family 8
[    4.170001] NET: Registered protocol family 20
[    4.174500] initcall atm_init+0x0/0xb4 returned 0 after 9765 usecs
[    4.180009] calling  wireless_nlevent_init+0x0/0x12 @ 1
[    4.185230] initcall wireless_nlevent_init+0x0/0x12 returned 0 after 0 usecs
[    4.190002] calling  netlbl_init+0x0/0x81 @ 1
[    4.194356] NetLabel: Initializing
[    4.200001] NetLabel:  domain hash size = 128
[    4.204354] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.210023] NetLabel:  unlabeled traffic allowed by default
[    4.215586] initcall netlbl_init+0x0/0x81 returned 0 after 19531 usecs
[    4.220003] calling  rfkill_init+0x0/0x5f @ 1
[    4.224482] initcall rfkill_init+0x0/0x5f returned 0 after 0 usecs
[    4.230006] calling  sysctl_init+0x0/0x48 @ 1
[    4.234357] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    4.240003] calling  print_ICs+0x0/0xc9 @ 1
[    4.244183] initcall print_ICs+0x0/0xc9 returned 0 after 0 usecs
[    4.250002] calling  hpet_late_init+0x0/0xc6 @ 1
[    4.254616] initcall hpet_late_init+0x0/0xc6 returned -19 after 0 usecs
[    4.260003] calling  clocksource_done_booting+0x0/0x36 @ 1
[    4.270003] Switching to clocksource jiffies
[    4.274271] initcall clocksource_done_booting+0x0/0x36 returned 0 after 0 usecs
[    4.280003] calling  init_pipe_fs+0x0/0x4c @ 1
[    4.284456] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    4.290002] calling  eventpoll_init+0x0/0xc3 @ 1
[    4.294617] initcall eventpoll_init+0x0/0xc3 returned 0 after 0 usecs
[    4.300002] calling  anon_inode_init+0x0/0x125 @ 1
[    4.304796] initcall anon_inode_init+0x0/0x125 returned 0 after 0 usecs
[    4.310003] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    4.320002] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    4.326956] calling  acpi_event_init+0x0/0x52 @ 1
[    4.330013] initcall acpi_event_init+0x0/0x52 returned 0 after 0 usecs
[    4.336530] calling  pnpacpi_init+0x0/0x8c @ 1
[    4.340001] pnp: PnP ACPI init
[    4.343063] ACPI: bus type pnp registered
[    4.357848] pnp: PnP ACPI: found 16 devices
[    4.360023] ACPI: ACPI bus type pnp unregistered
[    4.364640] initcall pnpacpi_init+0x0/0x8c returned 0 after 19531 usecs
[    4.370004] calling  pnp_system_init+0x0/0x12 @ 1
[    4.374716] system 00:01: [io  0x4000-0x407f] has been reserved
[    4.380003] system 00:01: [io  0x4080-0x40ff] has been reserved
[    4.390003] system 00:01: [io  0x4400-0x447f] has been reserved
[    4.395917] system 00:01: [io  0x4480-0x44ff] has been reserved
[    4.400003] system 00:01: [io  0x4800-0x487f] has been reserved
[    4.405914] system 00:01: [io  0x4880-0x48ff] has been reserved
[    4.410008] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    4.415915] system 00:02: [io  0x0800-0x0805] has been reserved
[    4.420003] system 00:02: [io  0x0290-0x0297] has been reserved
[    4.430011] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    4.436621] system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
[    4.440003] system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
[    4.450003] system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
[    4.456955] system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
[    4.460003] system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
[    4.470003] system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
[    4.476607] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    4.480003] system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
[    4.490003] system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
[    4.500003] system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
[    4.506609] system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
[    4.510003] system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
[    4.520003] system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
[    4.526609] system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
[    4.530062] initcall pnp_system_init+0x0/0x12 returned 0 after 156250 usecs
[    4.540074] calling  chr_dev_init+0x0/0xc4 @ 1
[    4.545217] initcall chr_dev_init+0x0/0xc4 returned 0 after 0 usecs
[    4.550010] calling  firmware_class_init+0x0/0x79 @ 1
[    4.555112] initcall firmware_class_init+0x0/0x79 returned 0 after 0 usecs
[    4.560020] calling  ieee1394_init+0x0/0x263 @ 1
[    4.565026] initcall ieee1394_init+0x0/0x263 returned 0 after 0 usecs
[    4.570005] calling  init_acpi_pm_clocksource+0x0/0xf5 @ 1
[    4.584590] Switching to clocksource acpi_pm
[    4.588938] initcall init_acpi_pm_clocksource+0x0/0xf5 returned 0 after 32 usecs
[    4.588938] calling  ssb_modinit+0x0/0x49 @ 1
[    4.591888] initcall ssb_modinit+0x0/0x49 returned 0 after 87 usecs
[    4.598161] calling  pcibios_assign_resources+0x0/0x76 @ 1
[    4.603711] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    4.608931] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    4.615036] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    4.621816] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    4.627914] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    4.633146] pci 0000:00:0b.0:   bridge window [io  disabled]
[    4.638795] pci 0000:00:0b.0:   bridge window [mem disabled]
[    4.644461] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    4.650548] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    4.655784] pci 0000:00:0c.0:   bridge window [io  disabled]
[    4.661432] pci 0000:00:0c.0:   bridge window [mem disabled]
[    4.667097] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    4.673189] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    4.678403] pci 0000:00:0d.0:   bridge window [io  disabled]
[    4.684067] pci 0000:00:0d.0:   bridge window [mem disabled]
[    4.689713] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    4.695822] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
[    4.703046] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    4.708260] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    4.714366] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    4.721147] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    4.728906] pci 0000:00:09.0: setting latency timer to 64
[    4.734311] pci 0000:00:0b.0: setting latency timer to 64
[    4.739705] pci 0000:00:0c.0: setting latency timer to 64
[    4.745116] pci 0000:00:0d.0: setting latency timer to 64
[    4.750514] pci 0000:00:0e.0: setting latency timer to 64
[    4.755922] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    4.761483] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    4.768454] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    4.774027] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    4.780288] pci_bus 0000:05: resource 3 [io  0x0000-0xffff]
[    4.785865] pci_bus 0000:05: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    4.792825] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    4.798386] pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
[    4.804654] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    4.811865] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 203328 usecs
[    4.819615] calling  sysctl_core_init+0x0/0x38 @ 1
[    4.824428] initcall sysctl_core_init+0x0/0x38 returned 0 after 20 usecs
[    4.831120] calling  inet_init+0x0/0x1d7 @ 1
[    4.835410] NET: Registered protocol family 2
[    4.839865] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    4.847611] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    4.856371] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.863716] TCP: Hash tables configured (established 131072 bind 65536)
[    4.870317] TCP reno registered
[    4.873485] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    4.879407] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    4.885884] initcall inet_init+0x0/0x1d7 returned 0 after 49289 usecs
[    4.892318] calling  af_unix_init+0x0/0x55 @ 1
[    4.896777] NET: Registered protocol family 1
[    4.901141] initcall af_unix_init+0x0/0x55 returned 0 after 4265 usecs
[    4.907679] calling  pci_apply_final_quirks+0x0/0x10c @ 1
[    4.932543] pci 0000:00:0b.0: Linking AER extended capability
[    4.938287] pci 0000:00:0c.0: Linking AER extended capability
[    4.944045] pci 0000:00:0d.0: Linking AER extended capability
[    4.949786] pci 0000:00:0e.0: Linking AER extended capability
[    4.955566] pci 0000:01:00.0: Boot video device
[    4.960095] PCI: CLS 32 bytes, default 64
[    4.964118] initcall pci_apply_final_quirks+0x0/0x10c returned 0 after 49835 usecs
[    4.971678] calling  populate_rootfs+0x0/0xd7 @ 1
[    4.976476] initcall populate_rootfs+0x0/0xd7 returned 0 after 76 usecs
[    4.983096] calling  pci_iommu_init+0x0/0x47 @ 1
[    5.085451] DMA-API: preallocated 32768 debug entries
[    5.090496] DMA-API: debugging enabled by kernel config
[    5.095776] initcall pci_iommu_init+0x0/0x47 returned 0 after 105532 usecs
[    5.102655] calling  calgary_fixup_tce_spaces+0x0/0x101 @ 1
[    5.108226] initcall calgary_fixup_tce_spaces+0x0/0x101 returned -19 after 1 usecs
[    5.115802] calling  irqfd_module_init+0x0/0x31 @ 1
[    5.120714] initcall irqfd_module_init+0x0/0x31 returned 0 after 42 usecs
[    5.127511] calling  i8259A_init_sysfs+0x0/0x22 @ 1
[    5.132556] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 157 usecs
[    5.139424] calling  vsyscall_init+0x0/0x6c @ 1
[    5.143997] initcall vsyscall_init+0x0/0x6c returned 0 after 21 usecs
[    5.150430] calling  sbf_init+0x0/0xf6 @ 1
[    5.154546] initcall sbf_init+0x0/0xf6 returned 0 after 1 usecs
[    5.160457] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    5.165807] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 452 usecs
[    5.172683] calling  add_rtc_cmos+0x0/0xa8 @ 1
[    5.177130] initcall add_rtc_cmos+0x0/0xa8 returned 0 after 4 usecs
[    5.183404] calling  cache_sysfs_init+0x0/0x59 @ 1
[    5.188195] initcall cache_sysfs_init+0x0/0x59 returned 0 after 1 usecs
[    5.194816] calling  mcheck_init_device+0x0/0x104 @ 1
[    5.199861] initcall mcheck_init_device+0x0/0x104 returned -5 after 1 usecs
[    5.206828] initcall mcheck_init_device+0x0/0x104 returned with error code -5 
[    5.214047] calling  threshold_init_device+0x0/0x8f @ 1
[    5.219265] initcall threshold_init_device+0x0/0x8f returned 0 after 2 usecs
[    5.226322] calling  inject_init+0x0/0x30 @ 1
[    5.230677] Machine check injector initialized
[    5.235137] initcall inject_init+0x0/0x30 returned 0 after 4350 usecs
[    5.241569] calling  thermal_throttle_init_device+0x0/0x94 @ 1
[    5.247410] initcall thermal_throttle_init_device+0x0/0x94 returned 0 after 1 usecs
[    5.255069] calling  ioapic_init_sysfs+0x0/0xbe @ 1
[    5.260122] initcall ioapic_init_sysfs+0x0/0xbe returned 0 after 170 usecs
[    5.267003] calling  add_pcspkr+0x0/0x28 @ 1
[    5.271361] initcall add_pcspkr+0x0/0x28 returned 0 after 92 usecs
[    5.277550] calling  microcode_init+0x0/0x128 @ 1
[    5.282244] microcode: no support for this CPU vendor
[    5.287309] initcall microcode_init+0x0/0x128 returned -19 after 4942 usecs
[    5.294279] calling  start_periodic_check_for_corruption+0x0/0x40 @ 1
[    5.300712] Scanning for low memory corruption every 60 seconds
[    5.306648] initcall start_periodic_check_for_corruption+0x0/0x40 returned 0 after 5790 usecs
[    5.315172] calling  audit_classes_init+0x0/0xaf @ 1
[    5.320134] initcall audit_classes_init+0x0/0xaf returned 0 after 6 usecs
[    5.326925] calling  crypto_fpu_module_init+0x0/0x12 @ 1
[    5.332230] initcall crypto_fpu_module_init+0x0/0x12 returned 0 after 2 usecs
[    5.339368] calling  aes_init+0x0/0x12 @ 1
[    5.343666] initcall aes_init+0x0/0x12 returned 0 after 190 usecs
[    5.349754] calling  init+0x0/0x12 @ 1
[    5.353673] initcall init+0x0/0x12 returned 0 after 129 usecs
[    5.359411] calling  aesni_init+0x0/0x164 @ 1
[    5.363788] Intel AES-NI instructions are not detected.
[    5.369010] initcall aesni_init+0x0/0x164 returned -19 after 5102 usecs
[    5.375633] calling  ghash_pclmulqdqni_mod_init+0x0/0x5d @ 1
[    5.381301] Intel PCLMULQDQ-NI instructions are not detected.
[    5.387043] initcall ghash_pclmulqdqni_mod_init+0x0/0x5d returned -19 after 5610 usecs
[    5.394968] calling  crc32c_intel_mod_init+0x0/0x20 @ 1
[    5.400207] initcall crc32c_intel_mod_init+0x0/0x20 returned -19 after 1 usecs
[    5.407415] calling  init_vdso_vars+0x0/0x239 @ 1
[    5.412145] initcall init_vdso_vars+0x0/0x239 returned 0 after 13 usecs
[    5.418743] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    5.423556] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 11 usecs
[    5.430259] calling  sysenter_setup+0x0/0xd7 @ 1
[    5.434883] initcall sysenter_setup+0x0/0xd7 returned 0 after 6 usecs
[    5.441327] calling  init_aout_binfmt+0x0/0x14 @ 1
[    5.446120] initcall init_aout_binfmt+0x0/0x14 returned 0 after 1 usecs
[    5.452741] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    5.458147] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 8 usecs
[    5.465378] calling  proc_schedstat_init+0x0/0x22 @ 1
[    5.470443] initcall proc_schedstat_init+0x0/0x22 returned 0 after 3 usecs
[    5.477306] calling  proc_execdomains_init+0x0/0x22 @ 1
[    5.482553] initcall proc_execdomains_init+0x0/0x22 returned 0 after 3 usecs
[    5.489587] calling  ioresources_init+0x0/0x3c @ 1
[    5.494399] initcall ioresources_init+0x0/0x3c returned 0 after 4 usecs
[    5.501015] calling  uid_cache_init+0x0/0x8c @ 1
[    5.505636] initcall uid_cache_init+0x0/0x8c returned 0 after 3 usecs
[    5.512082] calling  init_posix_timers+0x0/0x17a @ 1
[    5.517048] initcall init_posix_timers+0x0/0x17a returned 0 after 2 usecs
[    5.523845] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
[    5.529069] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 1 usecs
[    5.536123] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    5.541094] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 1 usecs
[    5.547871] calling  create_proc_profile+0x0/0x70 @ 1
[    5.552939] initcall create_proc_profile+0x0/0x70 returned 0 after 1 usecs
[    5.559804] calling  timekeeping_init_device+0x0/0x22 @ 1
[    5.565493] initcall timekeeping_init_device+0x0/0x22 returned 0 after 272 usecs
[    5.572897] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    5.578535] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 318 usecs
[    5.585859] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    5.591183] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 5 usecs
[    5.598304] calling  futex_init+0x0/0x69 @ 1
[    5.602615] initcall futex_init+0x0/0x69 returned 0 after 8 usecs
[    5.608704] calling  proc_dma_init+0x0/0x22 @ 1
[    5.613255] initcall proc_dma_init+0x0/0x22 returned 0 after 3 usecs
[    5.619597] calling  kallsyms_init+0x0/0x25 @ 1
[    5.624148] initcall kallsyms_init+0x0/0x25 returned 0 after 3 usecs
[    5.630505] calling  snapshot_device_init+0x0/0x12 @ 1
[    5.635741] initcall snapshot_device_init+0x0/0x12 returned 0 after 95 usecs
[    5.642806] calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
[    5.648569] initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 23 usecs
[    5.656230] calling  crash_notes_memory_init+0x0/0x36 @ 1
[    5.661641] initcall crash_notes_memory_init+0x0/0x36 returned 0 after 4 usecs
[    5.668850] calling  pid_namespaces_init+0x0/0x2d @ 1
[    5.673921] initcall pid_namespaces_init+0x0/0x2d returned 0 after 1 usecs
[    5.680799] calling  audit_init+0x0/0x133 @ 1
[    5.685154] audit: initializing netlink socket (disabled)
[    5.690579] type=2000 audit(1265287065.690:1): initialized
[    5.696059] initcall audit_init+0x0/0x133 returned 0 after 10649 usecs
[    5.702595] calling  audit_tree_init+0x0/0x49 @ 1
[    5.707303] initcall audit_tree_init+0x0/0x49 returned 0 after 3 usecs
[    5.713836] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    5.718908] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 19 usecs
[    5.725876] calling  init_lstats_procfs+0x0/0x25 @ 1
[    5.730856] initcall init_lstats_procfs+0x0/0x25 returned 0 after 4 usecs
[    5.737629] calling  perf_event_sysfs_init+0x0/0x19 @ 1
[    5.742869] initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 5 usecs
[    5.749901] calling  init_per_zone_wmark_min+0x0/0x6a @ 1
[    5.755383] initcall init_per_zone_wmark_min+0x0/0x6a returned 0 after 72 usecs
[    5.762691] calling  kswapd_init+0x0/0x76 @ 1
[    5.767093] initcall kswapd_init+0x0/0x76 returned 0 after 43 usecs
[    5.773374] calling  setup_vmstat+0x0/0xcd @ 1
[    5.777823] initcall setup_vmstat+0x0/0xcd returned 0 after 10 usecs
[    5.784183] calling  mm_sysfs_init+0x0/0x29 @ 1
[    5.788711] initcall mm_sysfs_init+0x0/0x29 returned 0 after 4 usecs
[    5.795070] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    5.799951] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 3 usecs
[    5.806658] calling  procswaps_init+0x0/0x22 @ 1
[    5.811291] initcall procswaps_init+0x0/0x22 returned 0 after 3 usecs
[    5.817719] calling  hugetlb_init+0x0/0x312 @ 1
[    5.822261] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.828628] initcall hugetlb_init+0x0/0x312 returned 0 after 6224 usecs
[    5.835250] calling  ksm_init+0x0/0x10c @ 1
[    5.839607] initcall ksm_init+0x0/0x10c returned 0 after 170 usecs
[    5.845802] calling  fasync_init+0x0/0x2a @ 1
[    5.850167] initcall fasync_init+0x0/0x2a returned 0 after 1 usecs
[    5.856338] calling  proc_filesystems_init+0x0/0x22 @ 1
[    5.861581] initcall proc_filesystems_init+0x0/0x22 returned 0 after 5 usecs
[    5.868618] calling  dnotify_init+0x0/0x80 @ 1
[    5.873075] initcall dnotify_init+0x0/0x80 returned 0 after 2 usecs
[    5.879332] calling  inotify_setup+0x0/0x12 @ 1
[    5.883874] initcall inotify_setup+0x0/0x12 returned 0 after 1 usecs
[    5.890230] calling  aio_setup+0x0/0xce @ 1
[    5.894462] initcall aio_setup+0x0/0xce returned 0 after 54 usecs
[    5.900565] calling  proc_locks_init+0x0/0x22 @ 1
[    5.905274] initcall proc_locks_init+0x0/0x22 returned 0 after 8 usecs
[    5.911811] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    5.916696] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 100 usecs
[    5.923495] calling  init_mbcache+0x0/0x14 @ 1
[    5.927940] initcall init_mbcache+0x0/0x14 returned 0 after 2 usecs
[    5.934215] calling  dquot_init+0x0/0xdc @ 1
[    5.938476] VFS: Disk quotas dquot_6.5.2
[    5.942438] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.948866] initcall dquot_init+0x0/0xdc returned 0 after 10146 usecs
[    5.955319] calling  init_v2_quota_format+0x0/0x22 @ 1
[    5.960469] initcall init_v2_quota_format+0x0/0x22 returned 0 after 1 usecs
[    5.967421] calling  quota_init+0x0/0x26 @ 1
[    5.971748] initcall quota_init+0x0/0x26 returned 0 after 36 usecs
[    5.977917] calling  proc_cmdline_init+0x0/0x22 @ 1
[    5.982815] initcall proc_cmdline_init+0x0/0x22 returned 0 after 3 usecs
[    5.989503] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    5.994503] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 109 usecs
[    6.001382] calling  proc_devices_init+0x0/0x22 @ 1
[    6.006355] initcall proc_devices_init+0x0/0x22 returned 0 after 91 usecs
[    6.013152] calling  proc_interrupts_init+0x0/0x22 @ 1
[    6.018293] initcall proc_interrupts_init+0x0/0x22 returned 0 after 3 usecs
[    6.025261] calling  proc_loadavg_init+0x0/0x22 @ 1
[    6.030153] initcall proc_loadavg_init+0x0/0x22 returned 0 after 3 usecs
[    6.036841] calling  proc_meminfo_init+0x0/0x22 @ 1
[    6.041732] initcall proc_meminfo_init+0x0/0x22 returned 0 after 3 usecs
[    6.048420] calling  proc_stat_init+0x0/0x22 @ 1
[    6.053058] initcall proc_stat_init+0x0/0x22 returned 0 after 3 usecs
[    6.059489] calling  proc_uptime_init+0x0/0x22 @ 1
[    6.064300] initcall proc_uptime_init+0x0/0x22 returned 0 after 3 usecs
[    6.070916] calling  proc_version_init+0x0/0x22 @ 1
[    6.075797] initcall proc_version_init+0x0/0x22 returned 0 after 3 usecs
[    6.082508] calling  proc_softirqs_init+0x0/0x22 @ 1
[    6.087470] initcall proc_softirqs_init+0x0/0x22 returned 0 after 3 usecs
[    6.094264] calling  proc_kmsg_init+0x0/0x25 @ 1
[    6.098876] initcall proc_kmsg_init+0x0/0x25 returned 0 after 3 usecs
[    6.105324] calling  proc_page_init+0x0/0x42 @ 1
[    6.109946] initcall proc_page_init+0x0/0x42 returned 0 after 5 usecs
[    6.116391] calling  configfs_init+0x0/0xda @ 1
[    6.120948] initcall configfs_init+0x0/0xda returned 0 after 13 usecs
[    6.127374] calling  init_devpts_fs+0x0/0x4c @ 1
[    6.132019] initcall init_devpts_fs+0x0/0x4c returned 0 after 16 usecs
[    6.138537] calling  init_dlm+0x0/0x88 @ 1
[    6.143291] DLM (built Feb  4 2010 09:38:23) installed
[    6.148432] initcall init_dlm+0x0/0x88 returned 0 after 5654 usecs
[    6.154626] calling  init_reiserfs_fs+0x0/0x63 @ 1
[    6.159414] initcall init_reiserfs_fs+0x0/0x63 returned 0 after 4 usecs
[    6.166033] calling  init_ext3_fs+0x0/0x77 @ 1
[    6.170486] initcall init_ext3_fs+0x0/0x77 returned 0 after 4 usecs
[    6.176740] calling  init_ext2_fs+0x0/0x77 @ 1
[    6.181199] initcall init_ext2_fs+0x0/0x77 returned 0 after 4 usecs
[    6.187452] calling  journal_init+0x0/0x5b @ 1
[    6.191918] initcall journal_init+0x0/0x5b returned 0 after 11 usecs
[    6.198260] calling  journal_init+0x0/0x72 @ 1
[    6.202728] initcall journal_init+0x0/0x72 returned 0 after 13 usecs
[    6.209068] calling  init_ramfs_fs+0x0/0x12 @ 1
[    6.213619] initcall init_ramfs_fs+0x0/0x12 returned 0 after 2 usecs
[    6.219962] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    6.224864] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 15 usecs
[    6.231660] calling  init_minix_fs+0x0/0x63 @ 1
[    6.236191] initcall init_minix_fs+0x0/0x63 returned 0 after 2 usecs
[    6.242552] calling  init_fat_fs+0x0/0x4f @ 1
[    6.246904] initcall init_fat_fs+0x0/0x4f returned 0 after 2 usecs
[    6.253092] calling  init_msdos_fs+0x0/0x12 @ 1
[    6.257623] initcall init_msdos_fs+0x0/0x12 returned 0 after 2 usecs
[    6.263986] calling  init_iso9660_fs+0x0/0x77 @ 1
[    6.268703] initcall init_iso9660_fs+0x0/0x77 returned 0 after 13 usecs
[    6.275322] calling  init_hfs_fs+0x0/0x5f @ 1
[    6.279682] initcall init_hfs_fs+0x0/0x5f returned 0 after 2 usecs
[    6.285869] calling  ecryptfs_init+0x0/0x1d6 @ 1
[    6.291030] initcall ecryptfs_init+0x0/0x1d6 returned 0 after 516 usecs
[    6.297633] calling  vxfs_init+0x0/0x5b @ 1
[    6.301852] initcall vxfs_init+0x0/0x5b returned 0 after 4 usecs
[    6.307854] calling  init_nls_cp437+0x0/0x12 @ 1
[    6.312488] initcall init_nls_cp437+0x0/0x12 returned 0 after 1 usecs
[    6.318919] calling  init_nls_cp737+0x0/0x12 @ 1
[    6.323556] initcall init_nls_cp737+0x0/0x12 returned 0 after 1 usecs
[    6.329987] calling  init_nls_cp775+0x0/0x12 @ 1
[    6.334623] initcall init_nls_cp775+0x0/0x12 returned 0 after 1 usecs
[    6.341067] calling  init_nls_cp852+0x0/0x12 @ 1
[    6.345679] initcall init_nls_cp852+0x0/0x12 returned 0 after 1 usecs
[    6.352127] calling  init_nls_cp855+0x0/0x12 @ 1
[    6.356746] initcall init_nls_cp855+0x0/0x12 returned 0 after 1 usecs
[    6.363195] calling  init_nls_cp861+0x0/0x12 @ 1
[    6.367813] initcall init_nls_cp861+0x0/0x12 returned 0 after 1 usecs
[    6.374263] calling  init_nls_cp862+0x0/0x12 @ 1
[    6.378881] initcall init_nls_cp862+0x0/0x12 returned 0 after 1 usecs
[    6.385334] calling  init_nls_cp865+0x0/0x12 @ 1
[    6.389948] initcall init_nls_cp865+0x0/0x12 returned 0 after 1 usecs
[    6.396397] calling  init_nls_cp866+0x0/0x12 @ 1
[    6.401028] initcall init_nls_cp866+0x0/0x12 returned 0 after 1 usecs
[    6.407459] calling  init_nls_cp869+0x0/0x12 @ 1
[    6.412096] initcall init_nls_cp869+0x0/0x12 returned 0 after 1 usecs
[    6.418527] calling  init_nls_cp874+0x0/0x12 @ 1
[    6.423165] initcall init_nls_cp874+0x0/0x12 returned 0 after 1 usecs
[    6.429595] calling  init_nls_cp932+0x0/0x12 @ 1
[    6.434231] initcall init_nls_cp932+0x0/0x12 returned 0 after 1 usecs
[    6.440675] calling  init_nls_euc_jp+0x0/0x48 @ 1
[    6.445381] initcall init_nls_euc_jp+0x0/0x48 returned 0 after 1 usecs
[    6.451915] calling  init_nls_cp936+0x0/0x12 @ 1
[    6.456526] initcall init_nls_cp936+0x0/0x12 returned 0 after 1 usecs
[    6.462975] calling  init_nls_cp949+0x0/0x12 @ 1
[    6.467593] initcall init_nls_cp949+0x0/0x12 returned 0 after 1 usecs
[    6.474042] calling  init_nls_cp950+0x0/0x12 @ 1
[    6.478652] initcall init_nls_cp950+0x0/0x12 returned 0 after 1 usecs
[    6.485100] calling  init_nls_cp1250+0x0/0x12 @ 1
[    6.489799] initcall init_nls_cp1250+0x0/0x12 returned 0 after 1 usecs
[    6.496333] calling  init_nls_cp1251+0x0/0x12 @ 1
[    6.501052] initcall init_nls_cp1251+0x0/0x12 returned 0 after 2 usecs
[    6.507569] calling  init_nls_iso8859_1+0x0/0x12 @ 1
[    6.512553] initcall init_nls_iso8859_1+0x0/0x12 returned 0 after 1 usecs
[    6.519329] calling  init_nls_iso8859_2+0x0/0x12 @ 1
[    6.524305] initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 1 usecs
[    6.531095] calling  init_nls_iso8859_3+0x0/0x12 @ 1
[    6.536054] initcall init_nls_iso8859_3+0x0/0x12 returned 0 after 1 usecs
[    6.542850] calling  init_nls_iso8859_5+0x0/0x12 @ 1
[    6.547813] initcall init_nls_iso8859_5+0x0/0x12 returned 0 after 1 usecs
[    6.554610] calling  init_nls_iso8859_6+0x0/0x12 @ 1
[    6.559574] initcall init_nls_iso8859_6+0x0/0x12 returned 0 after 1 usecs
[    6.566369] calling  init_nls_iso8859_7+0x0/0x12 @ 1
[    6.571339] initcall init_nls_iso8859_7+0x0/0x12 returned 0 after 1 usecs
[    6.578116] calling  init_nls_iso8859_9+0x0/0x12 @ 1
[    6.583093] initcall init_nls_iso8859_9+0x0/0x12 returned 0 after 1 usecs
[    6.589869] calling  init_nls_iso8859_13+0x0/0x12 @ 1
[    6.594940] initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 1 usecs
[    6.601816] calling  init_nls_koi8_u+0x0/0x12 @ 1
[    6.606513] initcall init_nls_koi8_u+0x0/0x12 returned 0 after 1 usecs
[    6.613049] calling  init_nls_koi8_ru+0x0/0x48 @ 1
[    6.617840] initcall init_nls_koi8_ru+0x0/0x48 returned 0 after 1 usecs
[    6.624463] calling  init_nls_utf8+0x0/0x2b @ 1
[    6.628996] initcall init_nls_utf8+0x0/0x2b returned 0 after 2 usecs
[    6.635358] calling  init_sysv_fs+0x0/0x4f @ 1
[    6.639805] initcall init_sysv_fs+0x0/0x4f returned 0 after 3 usecs
[    6.646079] calling  init_hpfs_fs+0x0/0x63 @ 1
[    6.650536] initcall init_hpfs_fs+0x0/0x63 returned 0 after 2 usecs
[    6.656794] calling  init_ntfs_fs+0x0/0x238 @ 1
[    6.661341] NTFS driver 2.1.29 [Flags: R/O DEBUG].
[    6.666142] initcall init_ntfs_fs+0x0/0x238 returned 0 after 4690 usecs
[    6.672763] calling  init_efs_fs+0x0/0x71 @ 1
[    6.677118] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    6.682091] initcall init_efs_fs+0x0/0x71 returned 0 after 4852 usecs
[    6.688523] calling  init_affs_fs+0x0/0x63 @ 1
[    6.692988] initcall init_affs_fs+0x0/0x63 returned 0 after 2 usecs
[    6.699245] calling  init_romfs_fs+0x0/0x87 @ 1
[    6.703791] ROMFS MTD (C) 2007 Red Hat, Inc.
[    6.708062] initcall init_romfs_fs+0x0/0x87 returned 0 after 4173 usecs
[    6.714684] calling  init_qnx4_fs+0x0/0x71 @ 1
[    6.719120] QNX4 filesystem 0.2.3 registered.
[    6.723492] initcall init_qnx4_fs+0x0/0x71 returned 0 after 4265 usecs
[    6.730024] calling  init_autofs4_fs+0x0/0x26 @ 1
[    6.734825] initcall init_autofs4_fs+0x0/0x26 returned 0 after 94 usecs
[    6.741453] calling  init_adfs_fs+0x0/0x63 @ 1
[    6.745894] initcall init_adfs_fs+0x0/0x63 returned 0 after 3 usecs
[    6.752169] calling  fuse_init+0x0/0xeb @ 1
[    6.756350] fuse init (API version 7.13)
[    6.760453] initcall fuse_init+0x0/0xeb returned 0 after 4000 usecs
[    6.766715] calling  cuse_init+0x0/0xac @ 1
[    6.771289] initcall cuse_init+0x0/0xac returned 0 after 353 usecs
[    6.777461] calling  init_omfs_fs+0x0/0x12 @ 1
[    6.781931] initcall init_omfs_fs+0x0/0x12 returned 0 after 4 usecs
[    6.788192] calling  init_nilfs_fs+0x0/0x9f @ 1
[    6.792748] initcall init_nilfs_fs+0x0/0x9f returned 0 after 3 usecs
[    6.799094] calling  init_befs_fs+0x0/0x7f @ 1
[    6.803555] BeFS version: 0.9.3
[    6.806700] initcall init_befs_fs+0x0/0x7f returned 0 after 3073 usecs
[    6.813235] calling  ocfs2_init+0x0/0x273 @ 1
[    6.817590] OCFS2 1.5.0
[    6.820145] initcall ocfs2_init+0x0/0x273 returned 0 after 2490 usecs
[    6.826576] calling  ocfs2_stack_glue_init+0x0/0x95 @ 1
[    6.831848] initcall ocfs2_stack_glue_init+0x0/0x95 returned 0 after 15 usecs
[    6.838969] calling  o2cb_stack_init+0x0/0x12 @ 1
[    6.843690] ocfs2: Registered cluster interface o2cb
[    6.848652] initcall o2cb_stack_init+0x0/0x12 returned 0 after 4848 usecs
[    6.855450] calling  ocfs2_user_plugin_init+0x0/0x56 @ 1
[    6.860976] ocfs2: Registered cluster interface user
[    6.865936] initcall ocfs2_user_plugin_init+0x0/0x56 returned 0 after 5043 usecs
[    6.873344] calling  init_o2nm+0x0/0xa9 @ 1
[    6.877520] OCFS2 Node Manager 1.5.0
[    6.881730] initcall init_o2nm+0x0/0xa9 returned 0 after 4103 usecs
[    6.887989] calling  dlm_init+0x0/0x286 @ 1
[    6.892193] OCFS2 DLM 1.5.0
[    6.894995] initcall dlm_init+0x0/0x286 returned 0 after 2736 usecs
[    6.901282] calling  init_dlmfs_fs+0x0/0xd1 @ 1
[    6.905810] OCFS2 DLMFS 1.5.0
[    6.908831] OCFS2 User DLM kernel interface loaded
[    6.913641] initcall init_dlmfs_fs+0x0/0xd1 returned 0 after 7642 usecs
[    6.920260] calling  init_btrfs_fs+0x0/0x90 @ 1
[    6.924871] Btrfs loaded
[    6.927406] initcall init_btrfs_fs+0x0/0x90 returned 0 after 2556 usecs
[    6.934035] calling  init_gfs2_fs+0x0/0x1e9 @ 1
[    6.939010] Slow work thread pool: Starting up
[    6.943581] Slow work thread pool: Ready
[    6.947622] GFS2 (built Feb  4 2010 09:39:18) installed
[    6.952873] initcall init_gfs2_fs+0x0/0x1e9 returned 0 after 13967 usecs
[    6.959567] calling  ipc_init+0x0/0x2f @ 1
[    6.963684] msgmni has been set to 1966
[    6.967524] initcall ipc_init+0x0/0x2f returned 0 after 3761 usecs
[    6.973709] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    6.978448] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 35 usecs
[    6.985071] calling  init_mqueue_fs+0x0/0xb4 @ 1
[    6.989719] initcall init_mqueue_fs+0x0/0xb4 returned 0 after 29 usecs
[    6.996252] calling  key_proc_init+0x0/0x5e @ 1
[    7.000799] initcall key_proc_init+0x0/0x5e returned 0 after 5 usecs
[    7.007140] calling  crypto_wq_init+0x0/0x2e @ 1
[    7.011837] initcall crypto_wq_init+0x0/0x2e returned 0 after 60 usecs
[    7.018355] calling  crypto_algapi_init+0x0/0xd @ 1
[    7.023263] initcall crypto_algapi_init+0x0/0xd returned 0 after 8 usecs
[    7.029951] calling  skcipher_module_init+0x0/0x39 @ 1
[    7.035107] initcall skcipher_module_init+0x0/0x39 returned 0 after 1 usecs
[    7.042078] calling  chainiv_module_init+0x0/0x12 @ 1
[    7.047124] initcall chainiv_module_init+0x0/0x12 returned 0 after 2 usecs
[    7.054006] calling  eseqiv_module_init+0x0/0x12 @ 1
[    7.058971] initcall eseqiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.065769] calling  seqiv_module_init+0x0/0x12 @ 1
[    7.070658] initcall seqiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.077347] calling  hmac_module_init+0x0/0x12 @ 1
[    7.082153] initcall hmac_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.088753] calling  crypto_xcbc_module_init+0x0/0x12 @ 1
[    7.094162] initcall crypto_xcbc_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.101388] calling  crypto_null_mod_init+0x0/0x7d @ 1
[    7.106564] alg: No test for cipher_null (cipher_null-generic)
[    7.112447] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    7.118525] alg: No test for digest_null (digest_null-generic)
[    7.124406] alg: No test for compress_null (compress_null-generic)
[    7.130602] initcall crypto_null_mod_init+0x0/0x7d returned 0 after 23509 usecs
[    7.137902] calling  md5_mod_init+0x0/0x12 @ 1
[    7.142598] initcall md5_mod_init+0x0/0x12 returned 0 after 232 usecs
[    7.149032] calling  rmd128_mod_init+0x0/0x12 @ 1
[    7.154005] initcall rmd128_mod_init+0x0/0x12 returned 0 after 234 usecs
[    7.160720] calling  rmd160_mod_init+0x0/0x12 @ 1
[    7.165574] initcall rmd160_mod_init+0x0/0x12 returned 0 after 146 usecs
[    7.172283] calling  rmd256_mod_init+0x0/0x12 @ 1
[    7.177131] initcall rmd256_mod_init+0x0/0x12 returned 0 after 141 usecs
[    7.183855] calling  sha1_generic_mod_init+0x0/0x12 @ 1
[    7.189311] initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 228 usecs
[    7.196544] calling  sha256_generic_mod_init+0x0/0x3f @ 1
[    7.202364] initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 404 usecs
[    7.209750] calling  sha512_generic_mod_init+0x0/0x3f @ 1
[    7.215462] initcall sha512_generic_mod_init+0x0/0x3f returned 0 after 284 usecs
[    7.222864] calling  tgr192_mod_init+0x0/0x6b @ 1
[    7.228001] initcall tgr192_mod_init+0x0/0x6b returned 0 after 425 usecs
[    7.234716] calling  crypto_ecb_module_init+0x0/0x12 @ 1
[    7.240032] initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.247157] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    7.252487] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.259610] calling  crypto_pcbc_module_init+0x0/0x12 @ 1
[    7.265019] initcall crypto_pcbc_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.272242] calling  crypto_cts_module_init+0x0/0x12 @ 1
[    7.277546] initcall crypto_cts_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.284690] calling  crypto_module_init+0x0/0x12 @ 1
[    7.289653] initcall crypto_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.296450] calling  crypto_module_init+0x0/0x12 @ 1
[    7.301427] initcall crypto_module_init+0x0/0x12 returned 0 after 1 usecs
[    7.308204] calling  crypto_ctr_module_init+0x0/0x3e @ 1
[    7.313526] initcall crypto_ctr_module_init+0x0/0x3e returned 0 after 1 usecs
[    7.320664] calling  crypto_gcm_module_init+0x0/0x84 @ 1
[    7.325970] initcall crypto_gcm_module_init+0x0/0x84 returned 0 after 3 usecs
[    7.333111] calling  cryptd_init+0x0/0xc8 @ 1
[    7.337472] initcall cryptd_init+0x0/0xc8 returned 0 after 4 usecs
[    7.343658] calling  des_generic_mod_init+0x0/0x3f @ 1
[    7.348897] initcall des_generic_mod_init+0x0/0x3f returned 0 after 99 usecs
[    7.355967] calling  fcrypt_mod_init+0x0/0x12 @ 1
[    7.360704] alg: No test for fcrypt (fcrypt-generic)
[    7.365664] initcall fcrypt_mod_init+0x0/0x12 returned 0 after 4870 usecs
[    7.372459] calling  blowfish_mod_init+0x0/0x12 @ 1
[    7.377961] initcall blowfish_mod_init+0x0/0x12 returned 0 after 611 usecs
[    7.384852] calling  twofish_mod_init+0x0/0x12 @ 1
[    7.389759] initcall twofish_mod_init+0x0/0x12 returned 0 after 114 usecs
[    7.396556] calling  serpent_mod_init+0x0/0x3f @ 1
[    7.401460] initcall serpent_mod_init+0x0/0x3f returned 0 after 103 usecs
[    7.408237] calling  aes_init+0x0/0x12 @ 1
[    7.412412] initcall aes_init+0x0/0x12 returned 0 after 56 usecs
[    7.418413] calling  camellia_init+0x0/0x12 @ 1
[    7.423031] initcall camellia_init+0x0/0x12 returned 0 after 57 usecs
[    7.429463] calling  cast5_mod_init+0x0/0x12 @ 1
[    7.434154] initcall cast5_mod_init+0x0/0x12 returned 0 after 49 usecs
[    7.440684] calling  tea_mod_init+0x0/0x6b @ 1
[    7.445390] initcall tea_mod_init+0x0/0x6b returned 0 after 256 usecs
[    7.451838] calling  khazad_mod_init+0x0/0x12 @ 1
[    7.456596] initcall khazad_mod_init+0x0/0x12 returned 0 after 53 usecs
[    7.463226] calling  salsa20_generic_mod_init+0x0/0x12 @ 1
[    7.468743] initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 33 usecs
[    7.476148] calling  deflate_mod_init+0x0/0x12 @ 1
[    7.481246] initcall deflate_mod_init+0x0/0x12 returned 0 after 287 usecs
[    7.488023] calling  zlib_mod_init+0x0/0x12 @ 1
[    7.492860] initcall zlib_mod_init+0x0/0x12 returned 0 after 269 usecs
[    7.499377] calling  michael_mic_init+0x0/0x12 @ 1
[    7.504234] initcall michael_mic_init+0x0/0x12 returned 0 after 43 usecs
[    7.510936] calling  crc32c_mod_init+0x0/0x12 @ 1
[    7.515686] initcall crc32c_mod_init+0x0/0x12 returned 0 after 46 usecs
[    7.522308] calling  crypto_authenc_module_init+0x0/0x12 @ 1
[    7.527965] initcall crypto_authenc_module_init+0x0/0x12 returned 0 after 3 usecs
[    7.535454] calling  lzo_mod_init+0x0/0x12 @ 1
[    7.539950] initcall lzo_mod_init+0x0/0x12 returned 0 after 50 usecs
[    7.546319] calling  krng_mod_init+0x0/0x12 @ 1
[    7.550879] alg: No test for stdrng (krng)
[    7.554974] initcall krng_mod_init+0x0/0x12 returned 0 after 4024 usecs
[    7.561594] calling  prng_mod_init+0x0/0x22 @ 1
[    7.570865] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    7.576787] initcall prng_mod_init+0x0/0x22 returned 0 after 10414 usecs
[    7.583497] calling  ghash_mod_init+0x0/0x12 @ 1
[    7.588160] initcall ghash_mod_init+0x0/0x12 returned 0 after 46 usecs
[    7.594693] calling  async_pq_init+0x0/0x3a @ 1
[    7.599224] initcall async_pq_init+0x0/0x3a returned 0 after 2 usecs
[    7.605590] calling  proc_genhd_init+0x0/0x3c @ 1
[    7.610317] initcall proc_genhd_init+0x0/0x3c returned 0 after 15 usecs
[    7.616915] calling  bsg_init+0x0/0x12e @ 1
[    7.621461] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    7.628853] initcall bsg_init+0x0/0x12e returned 0 after 7567 usecs
[    7.635141] calling  noop_init+0x0/0x14 @ 1
[    7.639323] io scheduler noop registered (default)
[    7.644129] initcall noop_init+0x0/0x14 returned 0 after 4690 usecs
[    7.650401] calling  cfq_init+0x0/0xa0 @ 1
[    7.654490] io scheduler cfq registered
[    7.658326] initcall cfq_init+0x0/0xa0 returned 0 after 3749 usecs
[    7.664520] calling  libcrc32c_mod_init+0x0/0x2c @ 1
[    7.669487] initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 5 usecs
[    7.676281] calling  percpu_counter_startup+0x0/0x3c @ 1
[    7.681611] initcall percpu_counter_startup+0x0/0x3c returned 0 after 3 usecs
[    7.688738] calling  dynamic_debug_init+0x0/0x138 @ 1
[    7.694076] initcall dynamic_debug_init+0x0/0x138 returned 0 after 262 usecs
[    7.701127] calling  adp5520_gpio_init+0x0/0x12 @ 1
[    7.706221] initcall adp5520_gpio_init+0x0/0x12 returned 0 after 218 usecs
[    7.713114] calling  lnw_gpio_init+0x0/0x1b @ 1
[    7.717713] initcall lnw_gpio_init+0x0/0x1b returned 0 after 66 usecs
[    7.724165] calling  pci_proc_init+0x0/0x6a @ 1
[    7.728945] initcall pci_proc_init+0x0/0x6a returned 0 after 242 usecs
[    7.735489] calling  pcie_portdrv_init+0x0/0x4c @ 1
[    7.740540] pcieport 0000:00:0b.0: setting latency timer to 64
[    7.746618] pcieport 0000:00:0c.0: setting latency timer to 64
[    7.752572] pcieport 0000:00:0d.0: setting latency timer to 64
[    7.758498] pcieport 0000:00:0e.0: setting latency timer to 64
[    7.764639] initcall pcie_portdrv_init+0x0/0x4c returned 0 after 23694 usecs
[    7.771696] calling  aer_service_init+0x0/0xb @ 1
[    7.776398] initcall aer_service_init+0x0/0xb returned -6 after 1 usecs
[    7.783037] initcall aer_service_init+0x0/0xb returned with error code -6 
[    7.789905] calling  aer_inject_init+0x0/0x12 @ 1
[    7.794699] initcall aer_inject_init+0x0/0x12 returned 0 after 70 usecs
[    7.801329] calling  ioapic_init+0x0/0x1b @ 1
[    7.805745] initcall ioapic_init+0x0/0x1b returned 0 after 61 usecs
[    7.812020] calling  pci_hotplug_init+0x0/0x1d @ 1
[    7.816810] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.822403] initcall pci_hotplug_init+0x0/0x1d returned 0 after 5458 usecs
[    7.829270] calling  shpcd_init+0x0/0x62 @ 1
[    7.833710] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.840424] initcall shpcd_init+0x0/0x62 returned 0 after 6703 usecs
[    7.846769] calling  acpiphp_init+0x0/0x5f @ 1
[    7.851229] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    7.858287] initcall acpiphp_init+0x0/0x5f returned -19 after 6895 usecs
[    7.865001] calling  init_legacy+0x0/0x43 @ 1
[    7.869448] initcall init_legacy+0x0/0x43 returned 0 after 89 usecs
[    7.875720] calling  pci_stub_init+0x0/0x13d @ 1
[    7.880664] pci-stub: invalid id string ""
[    7.884759] initcall pci_stub_init+0x0/0x13d returned 0 after 4307 usecs
[    7.891477] calling  platform_lcd_init+0x0/0x12 @ 1
[    7.896416] initcall platform_lcd_init+0x0/0x12 returned 0 after 60 usecs
[    7.903217] calling  genericbl_init+0x0/0x12 @ 1
[    7.907885] initcall genericbl_init+0x0/0x12 returned 0 after 55 usecs
[    7.914419] calling  progearbl_init+0x0/0x55 @ 1
[    7.919528] ALI M7101 PMU not found.
[    7.923134] initcall progearbl_init+0x0/0x55 returned 0 after 3998 usecs
[    7.929821] calling  cr_backlight_init+0x0/0x65 @ 1
[    7.935112] INTEL CARILLO RANCH LPC not found.
[    7.939548] Carillo Ranch Backlight Driver Initialized.
[    7.944808] initcall cr_backlight_init+0x0/0x65 returned 0 after 9861 usecs
[    7.951771] calling  da903x_backlight_init+0x0/0x12 @ 1
[    7.957057] initcall da903x_backlight_init+0x0/0x12 returned 0 after 60 usecs
[    7.964217] calling  kb3886_init+0x0/0xb @ 1
[    7.968490] initcall kb3886_init+0x0/0xb returned -19 after 1 usecs
[    7.974765] calling  wm831x_backlight_init+0x0/0x12 @ 1
[    7.980060] initcall wm831x_backlight_init+0x0/0x12 returned 0 after 67 usecs
[    7.987186] calling  display_class_init+0x0/0x7e @ 1
[    7.992238] initcall display_class_init+0x0/0x7e returned 0 after 60 usecs
[    7.999104] calling  arcfb_init+0x0/0x71 @ 1
[    8.003402] initcall arcfb_init+0x0/0x71 returned -6 after 1 usecs
[    8.009572] initcall arcfb_init+0x0/0x71 returned with error code -6 
[    8.016018] calling  cyber2000fb_init+0x0/0xd1 @ 1
[    8.020973] initcall cyber2000fb_init+0x0/0xd1 returned 0 after 147 usecs
[    8.027746] calling  pm2fb_init+0x0/0x4b @ 1
[    8.032120] initcall pm2fb_init+0x0/0x4b returned 0 after 83 usecs
[    8.038295] calling  pm3fb_init+0x0/0x4b @ 1
[    8.042662] initcall pm3fb_init+0x0/0x4b returned 0 after 67 usecs
[    8.048835] calling  rivafb_init+0x0/0x4b @ 1
[    8.053383] initcall rivafb_init+0x0/0x4b returned 0 after 166 usecs
[    8.059729] calling  nvidiafb_init+0x0/0x4b @ 1
[    8.064282] nvidiafb_setup START
[    8.067804] initcall nvidiafb_init+0x0/0x4b returned 0 after 3439 usecs
[    8.074438] calling  atyfb_init+0x0/0x51 @ 1
[    8.078770] initcall atyfb_init+0x0/0x51 returned 0 after 65 usecs
[    8.084958] calling  viafb_init+0x0/0x63 @ 1
[    8.089225] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    8.096179] initcall viafb_init+0x0/0x63 returned 0 after 6786 usecs
[    8.102545] calling  kyrofb_init+0x0/0x4b @ 1
[    8.106980] initcall kyrofb_init+0x0/0x4b returned 0 after 82 usecs
[    8.113253] calling  tdfxfb_init+0x0/0x4b @ 1
[    8.117764] initcall tdfxfb_init+0x0/0x4b returned 0 after 151 usecs
[    8.124137] calling  imsttfb_init+0x0/0x4b @ 1
[    8.128736] initcall imsttfb_init+0x0/0x4b returned 0 after 150 usecs
[    8.135194] calling  vmlfb_init+0x0/0x96 @ 1
[    8.139455] vmlfb: initializing
[    8.142759] initcall vmlfb_init+0x0/0x96 returned 0 after 3221 usecs
[    8.149099] calling  arkfb_init+0x0/0x82 @ 1
[    8.153538] initcall arkfb_init+0x0/0x82 returned 0 after 144 usecs
[    8.159795] calling  hgafb_init+0x0/0x6b @ 1
[    8.164403] hgafb: HGA card not detected.
[    8.168413] hgafb: probe of hgafb.0 failed with error -22
[    8.173836] initcall hgafb_init+0x0/0x6b returned 0 after 9520 usecs
[    8.180193] calling  tmiofb_init+0x0/0x69 @ 1
[    8.184726] initcall tmiofb_init+0x0/0x69 returned 0 after 170 usecs
[    8.191095] calling  metronomefb_init+0x0/0x12 @ 1
[    8.196045] initcall metronomefb_init+0x0/0x12 returned 0 after 155 usecs
[    8.202857] calling  broadsheetfb_init+0x0/0x12 @ 1
[    8.207869] initcall broadsheetfb_init+0x0/0x12 returned 0 after 130 usecs
[    8.214750] calling  s1d13xxxfb_init+0x0/0x2b @ 1
[    8.219683] initcall s1d13xxxfb_init+0x0/0x2b returned 0 after 224 usecs
[    8.226404] calling  sm501fb_init+0x0/0x12 @ 1
[    8.230923] initcall sm501fb_init+0x0/0x12 returned 0 after 61 usecs
[    8.237269] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    8.242613] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 5 usecs
[    8.249739] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    8.255005] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 107 usecs
[    8.262148] calling  acpi_ac_init+0x0/0x45 @ 1
[    8.266890] initcall acpi_ac_init+0x0/0x45 returned 0 after 291 usecs
[    8.273357] calling  acpi_button_init+0x0/0x56 @ 1
[    8.278328] input: Power Button as /class/input/input0
[    8.283478] ACPI: Power Button [PWRB]
[    8.287398] input: Power Button as /class/input/input1
[    8.292555] ACPI: Power Button [PWRF]
[    8.296282] initcall acpi_button_init+0x0/0x56 returned 0 after 17711 usecs
[    8.303267] calling  acpi_fan_init+0x0/0x32 @ 1
[    8.307951] ACPI: Fan [FAN] (on)
[    8.311409] initcall acpi_fan_init+0x0/0x32 returned 0 after 3527 usecs
[    8.318017] calling  acpi_processor_init+0x0/0xc3 @ 1
[    8.323750] initcall acpi_processor_init+0x0/0xc3 returned 0 after 638 usecs
[    8.330811] calling  acpi_container_init+0x0/0x4a @ 1
[    8.341273] initcall acpi_container_init+0x0/0x4a returned 0 after 5283 usecs
[    8.348399] calling  acpi_memory_device_init+0x0/0x86 @ 1
[    8.359514] initcall acpi_memory_device_init+0x0/0x86 returned 0 after 5534 usecs
[    8.367020] calling  acpi_battery_init+0x0/0x16 @ 1
[    8.371910] initcall acpi_battery_init+0x0/0x16 returned 0 after 6 usecs
[    8.371932] calling  1_acpi_battery_init_async+0x0/0x3c @ 1136
[    8.372078] initcall 1_acpi_battery_init_async+0x0/0x3c returned 0 after 135 usecs
[    8.391993] calling  acpi_smb_hc_init+0x0/0x18 @ 1
[    8.396979] initcall acpi_smb_hc_init+0x0/0x18 returned 0 after 190 usecs
[    8.403791] calling  acpi_sbs_init+0x0/0x4f @ 1
[    8.408454] initcall acpi_sbs_init+0x0/0x4f returned 0 after 132 usecs
[    8.414994] calling  acpi_pad_init+0x0/0x26 @ 1
[    8.419526] initcall acpi_pad_init+0x0/0x26 returned -22 after 1 usecs
[    8.426065] initcall acpi_pad_init+0x0/0x26 returned with error code -22 
[    8.432857] calling  regulator_virtual_consumer_init+0x0/0x12 @ 1
[    8.439066] initcall regulator_virtual_consumer_init+0x0/0x12 returned 0 after 117 usecs
[    8.447178] calling  regulator_userspace_consumer_init+0x0/0x12 @ 1
[    8.453547] initcall regulator_userspace_consumer_init+0x0/0x12 returned 0 after 92 usecs
[    8.461732] calling  bq24022_init+0x0/0x19 @ 1
[    8.466550] initcall bq24022_init+0x0/0x19 returned -19 after 370 usecs
[    8.473185] calling  lp3971_module_init+0x0/0x33 @ 1
[    8.478206] i2c-core: driver [LP3971] registered
[    8.482841] initcall lp3971_module_init+0x0/0x33 returned 0 after 4580 usecs
[    8.489879] calling  rand_initialize+0x0/0x30 @ 1
[    8.494628] initcall rand_initialize+0x0/0x30 returned 0 after 19 usecs
[    8.501243] calling  tty_init+0x0/0xfa @ 1
[    8.513940] initcall tty_init+0x0/0xfa returned 0 after 8401 usecs
[    8.520140] calling  pty_init+0x0/0x12 @ 1
[    8.629177] initcall pty_init+0x0/0x12 returned 0 after 102481 usecs
[    8.635612] calling  sysrq_init+0x0/0x25 @ 1
[    8.639889] initcall sysrq_init+0x0/0x25 returned 0 after 12 usecs
[    8.646132] calling  nozomi_init+0x0/0x129 @ 1
[    8.650654] Initializing Nozomi driver 2.1d (build date: Feb  4 2010 09:37:26)
[    8.658717] initcall nozomi_init+0x0/0x129 returned 0 after 7876 usecs
[    8.665310] calling  applicom_init+0x0/0x4bd @ 1
[    8.669924] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    8.677072] ac.o: No PCI boards found.
[    8.680828] ac.o: For an ISA board you must supply memory and irq parameters.
[    8.687950] initcall applicom_init+0x0/0x4bd returned -6 after 17604 usecs
[    8.694836] initcall applicom_init+0x0/0x4bd returned with error code -6 
[    8.701630] calling  rtc_init+0x0/0x103 @ 1
[    8.706018] Real Time Clock Driver v1.12b
[    8.710060] initcall rtc_init+0x0/0x103 returned 0 after 4143 usecs
[    8.716314] calling  hpet_init+0x0/0x6a @ 1
[    8.720755] initcall hpet_init+0x0/0x6a returned 0 after 235 usecs
[    8.726923] calling  i8k_init+0x0/0x54 @ 1
[    8.731098] initcall i8k_init+0x0/0x54 returned -19 after 1 usecs
[    8.737185] calling  mod_init+0x0/0x1ed @ 1
[    8.741513] initcall mod_init+0x0/0x1ed returned -19 after 76 usecs
[    8.747774] calling  mod_init+0x0/0xba @ 1
[    8.751965] initcall mod_init+0x0/0xba returned -19 after 23 usecs
[    8.758131] calling  mod_init+0x0/0x4d @ 1
[    8.762287] initcall mod_init+0x0/0x4d returned -19 after 1 usecs
[    8.768366] calling  init+0x0/0x12 @ 1
[    8.772203] initcall init+0x0/0x12 returned 0 after 73 usecs
[    8.777857] calling  pc8736x_gpio_init+0x0/0x3de @ 1
[    8.782932] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    8.790087] platform pc8736x_gpio.0: no device found
[    8.795114] initcall pc8736x_gpio_init+0x0/0x3de returned -19 after 11978 usecs
[    8.802435] calling  nsc_gpio_init+0x0/0x16 @ 1
[    8.806961] nsc_gpio initializing
[    8.810340] initcall nsc_gpio_init+0x0/0x16 returned 0 after 3294 usecs
[    8.816945] calling  tlclk_init+0x0/0x1ca @ 1
[    8.821328] telclk_interrup = 0xf non-mcpbl0010 hw.
[    8.826206] initcall tlclk_init+0x0/0x1ca returned -6 after 4772 usecs
[    8.832740] initcall tlclk_init+0x0/0x1ca returned with error code -6 
[    8.839261] calling  mwave_init+0x0/0x20a @ 1
[    8.843633] smapi::smapi_init, ERROR invalid usSmapiID
[    8.848760] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    8.858064] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    8.865283] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    8.871552] initcall mwave_init+0x0/0x20a returned -5 after 27269 usecs
[    8.878158] initcall mwave_init+0x0/0x20a returned with error code -5 
[    8.884699] calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
[    8.890177] ipmi message handler version 39.2
[    8.894542] initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 4333 usecs
[    8.902041] calling  init_ipmi_si+0x0/0x28d @ 1
[    8.906632] IPMI System Interface driver.
[    9.020132] ipmi_si: Unable to find any System Interface(s)
[    9.025704] initcall init_ipmi_si+0x0/0x28d returned -19 after 116342 usecs
[    9.032677] calling  hangcheck_init+0x0/0x87 @ 1
[    9.037292] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    9.046256] Hangcheck: Using get_cycles().
[    9.050365] initcall hangcheck_init+0x0/0x87 returned 0 after 12763 usecs
[    9.057144] calling  init_tis+0x0/0x8e @ 1
[    9.061322] initcall init_tis+0x0/0x8e returned 0 after 68 usecs
[    9.067320] calling  init_nsc+0x0/0x69a @ 1
[    9.071543] initcall init_nsc+0x0/0x69a returned -19 after 12 usecs
[    9.077797] calling  init_atmel+0x0/0x182 @ 1
[    9.082300] initcall init_atmel+0x0/0x182 returned -19 after 122 usecs
[    9.088820] calling  init_inf+0x0/0x12 @ 1
[    9.093002] initcall init_inf+0x0/0x12 returned 0 after 66 usecs
[    9.098996] calling  drm_core_init+0x0/0x137 @ 1
[    9.103719] [drm] Initialized drm 1.1.0 20060810
[    9.108333] initcall drm_core_init+0x0/0x137 returned 0 after 4592 usecs
[    9.115054] calling  ttm_init+0x0/0x6c @ 1
[    9.119218] initcall ttm_init+0x0/0x6c returned 0 after 66 usecs
[    9.125246] calling  tdfx_init+0x0/0x12 @ 1
[    9.129445] initcall tdfx_init+0x0/0x12 returned 0 after 16 usecs
[    9.135550] calling  r128_init+0x0/0x1e @ 1
[    9.139817] initcall r128_init+0x0/0x1e returned 0 after 81 usecs
[    9.145914] calling  radeon_init+0x0/0xc1 @ 1
[    9.150283] [drm] radeon defaulting to kernel modesetting.
[    9.155763] [drm] radeon kernel modesetting enabled.
[    9.161117] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[    9.166861]   alloc irq_desc for 18 on node -1
[    9.170730]   alloc kstat_irqs on node -1
[    9.175338] radeon 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[    9.183521] radeon 0000:01:00.0: setting latency timer to 64
[    9.192582] [drm] radeon: Initializing kernel modesetting.
[    9.210040] [drm] register mmio base: 0xD9000000
[    9.214655] [drm] register mmio size: 65536
[    9.219314] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[    9.225013] [drm] Generation 2 PCI interface, using max accessible memory
[    9.231802] [drm] radeon: VRAM 128M
[    9.235292] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[    9.240963] [drm] radeon: GTT 512M
[    9.244357] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[    9.249952] [drm] radeon: irq initialized.
[    9.254260] [drm] Detected VRAM RAM=128M, BAR=128M
[    9.259046] [drm] RAM width 64bits DDR
[    9.262908] [TTM] Zone  kernel: Available graphics memory: 503534 kiB.
[    9.269450] [drm] radeon: 128M of VRAM memory ready
[    9.274345] [drm] radeon: 512M of GTT memory ready.
[    9.279237] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    9.286759] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[    9.292683] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[    9.298867] [drm] radeon: cp idle (0x10000C03)
[    9.303496] [drm] Loading R300 Microcode
[    9.307418] platform radeon_cp.0: firmware: using built-in firmware radeon/R300_cp.bin
[    9.316599] [drm] radeon: ring at 0x0000000020000000
[    9.427546] [drm:r100_ring_test] *ERROR* radeon: ring test failed (sracth(0x15E4)=0xCAFEDEAD)
[    9.436079] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
[    9.442612] radeon 0000:01:00.0: failled initializing CP (-22).
[    9.448527] radeon 0000:01:00.0: Disabling GPU acceleration
[    9.560071] [drm:r100_cp_fini] *ERROR* Wait for CP idle timeout, shutting down CP.
[    9.673594] radeon: wait for empty RBBM fifo failed ! Bad things might happen.
[    9.786768] Failed to wait GUI idle while programming pipes. Bad things might happen.
[    9.794749] [drm] radeon: cp finalized
[    9.798537] radeon 0000:01:00.0: ffff88003e4bc410 unpin not necessary
[    9.805841] i2c i2c-0: adapter [] registered
[    9.810298] [drm] Default TV standard: PAL
[    9.814387] [drm] 27.000000000 MHz TV ref clk
[    9.818735] [drm] DFP table revision: 4
[    9.822661] i2c i2c-1: adapter [] registered
[    9.827065] [drm] Default TV standard: PAL
[    9.831171] [drm] 27.000000000 MHz TV ref clk
[    9.835665] [drm] Radeon Display Connectors
[    9.839847] [drm] Connector 0:
[    9.842930] [drm]   VGA
[    9.845373] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    9.851388] [drm]   Encoders:
[    9.854350] [drm]     CRT1: INTERNAL_DAC1
[    9.858352] [drm] Connector 1:
[    9.861417] [drm]   DVI-I
[    9.864031] [drm]   HPD1
[    9.866562] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    9.872579] [drm]   Encoders:
[    9.875540] [drm]     CRT2: INTERNAL_DAC2
[    9.879541] [drm]     DFP1: INTERNAL_TMDS1
[    9.883646] [drm] Connector 2:
[    9.886695] [drm]   S-video
[    9.889483] [drm]   Encoders:
[    9.892463] [drm]     TV1: INTERNAL_DAC2
[    9.896392] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
[    9.901796] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
[    9.909246] i2c i2c-0: NAK from device addr 0x50 msg #0
[    9.914564] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
[    9.919957] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
[    9.927413] i2c i2c-1: NAK from device addr 0x50 msg #0

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config-hang

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33-rc6
# Thu Feb  4 10:11:40 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEBUG_CFQ_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_PARAVIRT_CLOCK is not set
CONFIG_MEMTEST=y
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
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_SIP=y
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=y
# CONFIG_IP_VS_DH is not set
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#
# CONFIG_IP_VS_FTP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=y
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_SJA1000 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set

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
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_HP_ILO=y
CONFIG_ISL29003=y
CONFIG_DS1682=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ACPI=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATP867X=y
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_SC1200=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_RAID6_PQ=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
# CONFIG_BLK_DEV_DM is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
# CONFIG_IEEE1394_RAWIO is not set
CONFIG_IEEE1394_VIDEO1394=y
CONFIG_IEEE1394_DV1394=y
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
CONFIG_VETH=y
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
CONFIG_DNET=y
# CONFIG_NET_TULIP is not set
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_AMD8111_ETH=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
CONFIG_EPIC100=y
# CONFIG_SMSC9420 is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_TLAN is not set
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IP1000=y
# CONFIG_IGB is not set
CONFIG_IGBVF=y
CONFIG_NS83820=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_R8169 is not set
CONFIG_SIS190=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_QLA3XXX=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGB=y
CONFIG_S2IO=y
# CONFIG_MYRI10GE is not set
CONFIG_NIU=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_TEHUTI=y
# CONFIG_BNX2X is not set
CONFIG_QLGE=y
CONFIG_SFC=y
# CONFIG_BE2NET is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
# CONFIG_HOSTAP is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable MMC support to see WiMAX SDIO drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
# CONFIG_ATM_ENI_BURST_TX_8W is not set
CONFIG_ATM_ENI_BURST_TX_4W=y
# CONFIG_ATM_ENI_BURST_TX_2W is not set
CONFIG_ATM_ENI_BURST_RX_16W=y
# CONFIG_ATM_ENI_BURST_RX_8W is not set
# CONFIG_ATM_ENI_BURST_RX_4W is not set
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
CONFIG_VMXNET3=y
# CONFIG_ISDN is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC5UH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_WINBOND_CIR=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_WM831X_ON=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_TSL2550=y
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_LANGWELL=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_MAX17040=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_LIS3_I2C=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_GEODE_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_TPS65010=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_CODEC is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_88PM8607=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_BQ24022=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
CONFIG_IR_CORE=y
CONFIG_VIDEO_IR=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TDA9875=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_M52790=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_TCM825X=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_ADV7343 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_BT848=y
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_CPIA=y
CONFIG_VIDEO_CPIA_PP=y
CONFIG_VIDEO_CPIA_USB=y
CONFIG_VIDEO_CPIA2=y
CONFIG_VIDEO_SAA5246A=y
CONFIG_VIDEO_SAA5249=y
CONFIG_VIDEO_STRADIS=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
CONFIG_VIDEO_MEYE=y
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_DVB=y
CONFIG_VIDEO_MXB=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_CX23885 is not set
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_CX18=y
CONFIG_VIDEO_SAA7164=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_MT9M001=y
CONFIG_SOC_CAMERA_MT9M111=y
CONFIG_SOC_CAMERA_MT9T031=y
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=y
CONFIG_SOC_CAMERA_RJ54N1=y
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_SOC_CAMERA_PLATFORM=y
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=y
# CONFIG_V4L_USB_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=y
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_USB_DSBR=y
# CONFIG_RADIO_SI470X is not set
CONFIG_USB_MR800=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_TEF6862=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_AV7110=y
# CONFIG_DVB_AV7110_OSD is not set
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
CONFIG_DVB_BUDGET_CI=y
CONFIG_DVB_BUDGET_AV=y
CONFIG_DVB_BUDGET_PATCH=y

#
# Supported USB Adapters
#
CONFIG_DVB_TTUSB_BUDGET=y
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_SIANO_MDTV=y

#
# Siano module components
#
# CONFIG_SMS_USB_DRV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_USB=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=y

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=y

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
# CONFIG_DVB_FIREDTV_FIREWIRE is not set
CONFIG_DVB_FIREDTV_IEEE1394=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=y

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=y
# CONFIG_DVB_MANTIS is not set
CONFIG_DVB_HOPPER=y

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_DRX397XD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
# CONFIG_DVB_DIB3000MB is not set
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3304=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
CONFIG_DVB_LGS8GL5=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_SOUND_SB is not set
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
# CONFIG_SC6600_JOY is not set
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KYE is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=y
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_ATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=y
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_ADP5520=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DEBUG_VERBOSE=y
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_DELL_WMI=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_ACPI_ASUS=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

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
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_SAMPLES=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y

--gKMricLos+KVdGMg--

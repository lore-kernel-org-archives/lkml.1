Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZHDIWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZHDIWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZHDIWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:22:45 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:34913 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZHDIWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:22:37 -0400
Date: Tue, 4 Aug 2009 13:48:50 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090804081850.GA21474@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org> <20090802202720.GA32360@elte.hu> <20090802221324.GP6854@linux.vnet.ibm.com> <20090803070458.GA27581@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20090803070458.GA27581@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 03, 2009 at 09:04:58AM +0200, Ingo Molnar wrote:
> [    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.010000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.010000] ... MAX_LOCK_DEPTH:          48
> [    0.010000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.010000] ... CLASSHASH_SIZE:          4096
> [    0.010000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.010000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.010000] ... CHAINHASH_SIZE:          16384
> [    0.010000]  memory used by lock dependency info: 5823 kB
> [    0.010000]  per task-struct memory footprint: 1920 bytes
> [    0.010000] ------------------------
> [    0.010000] | Locking API testsuite:
> [    0.010000] ----------------------------------------------------------------------------
> [    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.010000]   --------------------------------------------------------------------------
> [    0.010000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
> [    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.010000]   --------------------------------------------------------------------------
> [    0.010000]               recursive read-lock:             |  ok  |             |failed|
> [    0.010000]            recursive read-lock #2:             |  ok  |             |failed|
> [    0.010000]             mixed read-write-lock:             |failed|             |failed|
> [    0.010000]             mixed write-read-lock:             |failed|             |failed|
> [    0.010000]   --------------------------------------------------------------------------
> [    0.010000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.010000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
> [    0.010000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.010000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
> [    0.010000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
> [    0.010000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
> [    0.010000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.010000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
> [    0.010000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.010000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
> [    0.010000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.010000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/123:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/123:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/132:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/132:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/213:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/213:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/231:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/231:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/312:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/312:failed|failed|  ok  |
> [    0.010000]       hard-irq lock-inversion/321:failed|failed|  ok  |
> [    0.010000]       soft-irq lock-inversion/321:failed|failed|  ok  |
> [    0.010000]       hard-irq read-recursion/123:  ok  |
> [    0.010000]       soft-irq read-recursion/123:  ok  |
> [    0.010000]       hard-irq read-recursion/132:  ok  |
> [    0.010000]       soft-irq read-recursion/132:  ok  |
> [    0.010000]       hard-irq read-recursion/213:  ok  |
> [    0.010000]       soft-irq read-recursion/213:  ok  |
> [    0.010000]       hard-irq read-recursion/231:  ok  |
> [    0.010000]       soft-irq read-recursion/231:  ok  |
> [    0.010000]       hard-irq read-recursion/312:  ok  |
> [    0.010000]       soft-irq read-recursion/312:  ok  |
> [    0.010000]       hard-irq read-recursion/321:  ok  |
> [    0.010000]       soft-irq read-recursion/321:  ok  |
> [    0.010000] --------------------------------------------------------
> [    0.010000] 133 out of 218 testcases failed, as expected. |
> [    0.010000] ----------------------------------------------------

Hmm.. I tried to reproduce this on a similar 2 CPU machine running
linux-2.6.31-rc5-tip. However, I couldn't reproduce this WARN_ON.

That aside, in my case, all the 218 lockdep test cases passed,
while this bootlog shows quite a few failures.
So, wondering if I am testing the right kernel version.

Appending the patch, bootup log and the config.

/*************** Patch ******************************/

rcu: Check if the cpu has been initialized before handling callbacks

From: Gautham R Shenoy <ego@in.ibm.com>

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/rcutree.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0e40e61..1809cc8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1137,6 +1137,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(rdp->beenonline == 0);
+
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
@@ -1351,6 +1353,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	printk(KERN_INFO "Initializing RCU for cpu %d\n", cpu);
+
 	/* Set up local state, ensuring consistent view of global state. */
 	spin_lock_irqsave(&rnp->lock, flags);
 	lastcomp = rsp->completed;


/*************** Boot Log ******************************/
root  (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel  /boot/vmlinuz-autobench console=tty0 console=ttyS0,9600 autobench_args:
 root=/dev/sda2 ABAT:1249362544
   [Linux-bzImage, setup=0x3000, size=0x334830]
initrd /boot/initrd-autobench.img
   [Linux-initrd @ 0x37de8000, 0x2077cb bytes]
boot
Linux version 2.6.31-rc5-autokern1-tip (root@elm3b165) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #1 SMP Tue Aug 4 05:08:45 UTC 2009
Command line: console=tty0 console=ttyS0,9600 autobench_args: root=/dev/sda2 ABAT:1249362544
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dff70000 (usable)
 BIOS-e820: 00000000dff70000 - 00000000dff7b000 (ACPI data)
 BIOS-e820: 00000000dff7b000 - 00000000dff80000 (ACPI NVS)
 BIOS-e820: 00000000dff80000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000400000000 (usable)
DMI 2.3 present.
last_pfn = 0x400000 max_arch_pfn = 0x400000000
last_pfn = 0xdff70 max_arch_pfn = 0x400000000
init_memory_mapping: 0000000000000000-00000000dff70000
init_memory_mapping: 0000000100000000-0000000400000000
RAMDISK: 37de8000 - 37fef7cb
ACPI: RSDP 00000000000f7560 00024 (v02 PTLTD )
ACPI: XSDT 00000000dff78a5b 0004C (v01 PTLTD     XSDT   06040000  LTP 00000000)
ACPI: FACP 00000000dff7ac02 000F4 (v03 AMD    HAMMER   06040000 PTEC 000F4240)
ACPI: DSDT 00000000dff78aa7 020E7 (v01 AMD-K8  AMDACPI 06040000 MSFT 0100000E)
ACPI: FACS 00000000dff7bfc0 00040
ACPI: SSDT 00000000dff7acf6 0020C (v01 PTLTD  POWERNOW 06040000  LTP 00000001)
ACPI: HPET 00000000dff7af02 00038 (v01 AMD    HAMMER   06040000 PTEC 00000000)
ACPI: APIC 00000000dff7af3a 00076 (v01 PTLTD     APIC   06040000  LTP 00000000)
ACPI: SPCR 00000000dff7afb0 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
Scanning NUMA topology in Northbridge 24
Number of nodes 2
Node 0 MemBase 0000000000000000 Limit 0000000200000000
Node 1 MemBase 0000000200000000 Limit 0000000400000000
Using node hash shift of 33
found SMP MP-table at [ffff8800000f75e0] f75e0
Bootmem setup node 0 0000000000000000-0000000200000000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [0000000000018000 -  0000000000057fff] pages 40
(8 early reservations) ==> bootmem [0000000000 - 0200000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00022fbea8]    TEXT DATA BSS ==> [0001000000 - 00022fbea8]
  #3 [0037de8000 - 0037fef7cb]          RAMDISK ==> [0037de8000 - 0037fef7cb]
  #4 [000009ac00 - 0000100000]    BIOS reserved ==> [000009ac00 - 0000100000]
  #5 [00022fc000 - 00022fc108]              BRK ==> [00022fc000 - 00022fc108]
  #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #7 [000000c000 - 0000018000]          PGTABLE ==> [000000c000 - 0000018000]
Bootmem setup node 1 0000000200000000-0000000400000000
  NODE_DATA [0000000200000000 - 0000000200004fff]
  bootmap [0000000200005000 -  0000000200044fff] pages 40
(8 early reservations) ==> bootmem [0200000000 - 0400000000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 00022fbea8]    TEXT DATA BSS
  #3 [0037de8000 - 0037fef7cb]          RAMDISK
  #4 [000009ac00 - 0000100000]    BIOS reserved
  #5 [00022fc000 - 00022fc108]              BRK
  #6 [0000008000 - 000000c000]          PGTABLE
  #7 [000000c000 - 0000018000]          PGTABLE
found SMP MP-table at [ffff8800000f75e0] f75e0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00400000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x0000009a
    0: 0x00000100 -> 0x000dff70
    0: 0x00100000 -> 0x00200000
    1: 0x00200000 -> 0x00400000
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x8008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xe8000000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 17, address 0xe8000000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xe8001000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 17, address 0xe8001000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x102282a0 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at e0000000 (gap: e0000000:1ec00000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:2
PERCPU: Remapped at ffffc90000000000 with large pages, static data 1914656 bytes
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 3956370
Policy zone: Normal
Kernel command line: console=tty0 console=ttyS0,9600 autobench_args: root=/dev/sda2 ABAT:1249362544
PID hash table entries: 4096 (order: 12, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 0 size 32 MB
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Memory: 15746208k/16777216k available (4270k kernel code, 525272k absent, 505736k reserved, 3005k data, 2396k init)
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
Initializing RCU for cpu 0
Initializing RCU for cpu 0
NR_IRQS:1280
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2392.251 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4784.50 BogoMIPS (lpj=9569004)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
mce: CPU supports 5 MCE banks
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
ACPI: Core revision 20090521
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: AMD Opteron(tm) Processor 250 stepping 0a
Initializing RCU for cpu 1
Initializing RCU for cpu 1
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4785.02 BogoMIPS (lpj=9570044)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x1 -> Node 1
mce: CPU supports 5 MCE banks
CPU1: AMD Opteron(tm) Processor 250 stepping 0a
Brought up 2 CPUs
Total of 2 processors activated (9569.52 BogoMIPS).
NET: Registered protocol family 16
TOM: 00000000e0000000 aka 3584M
TOM2: 0000000400000000 aka 16384M
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:02:01.0: PME# supported from D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:01.1: PME# supported from D3hot D3cold
pci 0000:02:01.1: PME# disabled
pci 0000:03:03.0: PME# supported from D0 D3hot D3cold
pci 0000:03:03.0: PME# disabled
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 10 11) *7
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 5 10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 32-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:00: mem resource (0xe0000-0xfffff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp 00:06: mem resource (0xc0000-0xc7fff) overlaps 0000:02:02.0 BAR 6 (0x0-0xfffff), disabling
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x100000-0xdfffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:00: iomem range 0xffc00000-0xfff7ffff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xfff80000-0xffffffff has been reserved
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0x1100-0x117f has been reserved
system 00:06: ioport range 0x1180-0x11ff has been reserved
system 00:06: ioport range 0x300-0x307 has been reserved
system 00:06: ioport range 0x421-0x42f has been reserved
system 00:06: ioport range 0xca2-0xca3 has been reserved
pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
pci 0000:00:06.0:   IO window: 0x2000-0x2fff
pci 0000:00:06.0:   MEM window: 0xe8100000-0xe81fffff
pci 0000:00:06.0:   PREFETCH window: 0xe0000000-0xe00fffff
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0x3000-0x3fff
pci 0000:00:0a.0:   MEM window: 0xe8200000-0xe82fffff
pci 0000:00:0a.0:   PREFETCH window: 0xe0100000-0xe01fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0b.0:   IO window: 0x4000-0x4fff
pci 0000:00:0b.0:   MEM window: 0xe8300000-0xe83fffff
pci 0000:00:0b.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 2077k freed
HugeTLB registered 2 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 30758
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
boot interrupts on PCI device 0x1022:0x746b already disabled
pci 0000:00:0a.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:0b.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
Real Time Clock Driver v1.12b
AMD768 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Platform driver 'serial8250' needs updating - please use dev_pm_ops
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Platform driver 'floppy' needs updating - please use dev_pm_ops
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:07.1: UDMA133 controller
amd74xx 0000:00:07.1: IDE controller (0x1022:0x7469 rev 0x03)
amd74xx 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1020-0x1027
    ide1: BM-DMA at 0x1028-0x102f
hdc: LG CD-ROM CRN-8245B, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hdc: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
sata_sil 0000:01:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xe8102000 tf 0xe8102080 irq 17
ata2: SATA max UDMA/100 mmio m512@0xe8102000 tf 0xe81020c0 irq 17
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-6: ST380013AS, 3.25, max UDMA/133
ata1.00: 156312576 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST380013AS       3.25 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156312576 512-byte logical blocks: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata2: SATA link down (SStatus 0 SControl 310)
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:03:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
e1000: 0000:03:03.0: e1000_probe: (PCI:66MHz:64-bit) 00:02:b3:9b:20:ef
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.99 (April 20, 2009)
tg3 0000:02:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
tg3 0000:02:01.0: PME# disabled
eth1: Tigon3 [partno(BCM95704A6) rev 2003] (PCIX:100MHz:64-bit) MAC address 00:0d:60:14:bf:64
eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
tg3 0000:02:01.1: PCI INT B -> GSI 25 (level, low) -> IRQ 25
tg3 0000:02:01.1: PME# disabled
eth2: Tigon3 [partno(BCM95704A6) rev 2003] (PCIX:100MHz:64-bit) MAC address 00:0d:60:14:bf:65
eth2: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth2: dma_rwctrl[769f4000] dma_mask[64-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.10
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.10
mptspi 0000:02:02.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B2: Capabilities={Initiator}
scsi2 : ioc0: LSI53C1030 B2, FwRev=01032316h, Ports=1, MaxQ=222, IRQ=26
Fusion MPT SAS Host driver 3.04.10
ieee1394: raw1394: /dev/raw1394 device initialized
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:01:00.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.0: OHCI Host Controller
ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:01:00.0: irq 19, io mem 0xe8100000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ohci_hcd 0000:01:00.1: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:00.1: OHCI Host Controller
ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:00.1: irq 19, io mem 0xe8101000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
Platform driver 'i8042' needs updating - please use dev_pm_ops
usb 1-1: new full speed USB device using ohci_hcd and address 2
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
powernow-k8: Found 2 AMD Opteron(tm) Processor 250 processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x2
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x6
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
usb 1-1: configuration #1 chosen from 1 choice
input: IBM PPC I/F as /devices/pci0000:00/0000:00:06.0/0000:01:00.0/usb1/1-1/1-1:1.0/input/input2
generic-usb 0003:04B3:4001.0001: input: USB HID v1.10 Keyboard [IBM PPC I/F] on usb-0000:01:00.0-1/input0
input: IBM PPC I/F as /devices/pci0000:00/0000:00:06.0/0000:01:00.0/usb1/1-1/1-1:1.1/input/input3
generic-usb 0003:04B3:4001.0002: input: USB HID v1.10 Mouse [IBM PPC I/F] on usb-0000:01:00.0-1/input1
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0xe
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x2
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x6
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0xe
Freeing unused kernel memory: 2396k freed
Begin: Loading essential drivers... ...
Done.
Begin: Running /scripts/init-premount ...
ata_id[1419]: main: unable to open '/dev/.tmp-0-0'
ata_id[1461]: main: unable to open '/dev/.tmp-0-0'
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
Done.
Begin: Waiting for root file system... ...


-- 
Thanks and Regards
gautham

--SUOF0GtieIMvvwua
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config-autobench-2.6.31-rc5-autokern1-tip.bz2"
Content-Transfer-Encoding: base64

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
f+LuSKcKEgEplAbg

--SUOF0GtieIMvvwua--

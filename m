Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYHUU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYHUU4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYHUU4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:56:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYHUU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:56:09 -0400
Date: Thu, 21 Aug 2008 10:55:58 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080821205558.GC23377@hoblitt.com>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Both hunks in the patch applied with an offset of -36 but the show_msr
flag doesn't seem to have any effect.  The dmesg is still the same
number of lines accord to wc.

I'm attaching the new dmesg anyways.

$ cat /proc/cmdline 
root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0
console=ttyS0,115200n8 

-J

--
On Wed, Aug 20, 2008 at 06:49:11PM -0700, Yinghai Lu wrote:
> On Wed, Aug 20, 2008 at 6:20 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Wed, Aug 20, 2008 at 6:04 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> >>
> >> (switched to email.  Please respond via emailed reply-to-all, not via the
> >> bugzilla web interface).
> >>
> >> On Wed, 20 Aug 2008 17:38:59 -0700 (PDT)
> >> bugme-daemon@bugzilla.kernel.org wrote:
> >>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=11388
> >>>
> >>>            Summary: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of
> >>>                     memory is usable
> >>>            Product: Memory Management
> >>>            Version: 2.5
> >>>      KernelVersion: 2.6.27-rc3
> >>>           Platform: All
> >>>         OS/Version: Linux
> >>>               Tree: Mainline
> >>>             Status: NEW
> >>>           Severity: normal
> >>>           Priority: P1
> >>>          Component: MTTR
> >>>         AssignedTo: akpm@osdl.org
> >>>         ReportedBy: j_kernel@hoblitt.com
> >>>
> >>>
> >>> Latest working kernel version: 2.4.24.2 (possibly later)
> >>> Earliest failing kernel version: 2.6.27-rc3-21328-ga7f5aaf (from netdev-2.6)
> >>> Distribution: Gentoo
> >>> Hardware Environment: 2x Intel X5482
> >>> Software Environment:
> >>> Problem Description:
> >>>
> >>> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing
> >>> 13056MB of RAM.
> >>> [    0.000000] ------------[ cut here ]------------
> >>> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1561
> >>> mtrr_trim_uncached_memory+0x508/0x550()
> >>> [    0.000000] Modules linked in:
> >>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-21328-ga7f5aaf #8
> >>> [    0.000000]
> >>> [    0.000000] Call Trace:
> >>> [    0.000000]  [<ffffffff80234c3e>] warn_on_slowpath+0x51/0x77
> >>> [    0.000000]  [<ffffffff8023570a>] printk+0x4e/0x56
> >>> [    0.000000]  [<ffffffff803add02>] sort+0xfa/0x18c
> >>> [    0.000000]  [<ffffffff808283d3>] cmp_range+0x0/0x6
> >>> [    0.000000]  [<ffffffff80828a47>] mtrr_trim_uncached_memory+0x508/0x550
> >>> [    0.000000]  [<ffffffff802178e1>] post_set+0x20/0x3d
> >>> [    0.000000]  [<ffffffff80824f99>] setup_arch+0x39d/0x6be
> >>> [    0.000000]  [<ffffffff8081e962>] start_kernel+0x74/0x341
> >>> [    0.000000]  [<ffffffff8081e394>] x86_64_start_kernel+0xe3/0xe7
> >>> [    0.000000]
> >>> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> >>>
> >>>
> >>> Steps to reproduce:
> >>>
> >>> This warning isn't present under 2.6.24.2 and the full range of physical memory
> >>> is usable.
> >>
> >> Looks like a post-2.6.26 regression caused by
> >> 12031a624af7816ec7660b82be648aa3703b4ebe.
> > reg00: base=0xd0000000 (3328MB), size=196864MB: uncachable, count=1
> > reg01: base=0xe0000000 (3584MB), size=197120MB: uncachable, count=1
> > reg02: base=0x00000000 (   0MB), size=212992MB: write-back, count=1
> > reg03: base=0x400000000 (16384MB), size=197120MB: write-back, count=1
> > reg04: base=0x420000000 (16896MB), size=196864MB: write-back, count=1
> >
> > the size mtrr looks crazy.
> 
> please apply attached patch and boot with show_msr=1 to dump the msr
> (including mtrr)
> 
> YH

> [PATCH] x86_64: printout msr
> 
> commandline show_msr=1 for bsp, show_msr=32 for all 32 cpus.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/cpu/common_64.c |   46 ++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/msr.h           |   23 ++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
> +++ linux-2.6/arch/x86/kernel/cpu/common_64.c
> @@ -430,6 +430,49 @@ static __init int setup_noclflush(char *
>  }
>  __setup("noclflush", setup_noclflush);
>  
> +struct msr_range {
> +	unsigned min;
> +	unsigned max;
> +};
> +
> +static struct msr_range msr_range_array[] __cpuinitdata = {
> +	{ 0x00000000, 0x00000418},
> +	{ 0xc0000000, 0xc000040b},
> +	{ 0xc0010000, 0xc0010142},
> +	{ 0xc0011000, 0xc001103b},
> +};
> +
> +static void __cpuinit print_cpu_msr(void)
> +{
> +	unsigned index;
> +	u64 val;
> +	int i;
> +	unsigned index_min, index_max;
> +
> +	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
> +		index_min = msr_range_array[i].min;
> +		index_max = msr_range_array[i].max;
> +		for (index = index_min; index < index_max; index++) {
> +			if (rdmsrl_amd_safe(index, &val))
> +				continue;
> +			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
> +		}
> +	}
> +}
> +
> +static int show_msr __cpuinitdata;
> +static __init int setup_show_msr(char *arg)
> +{
> +	int num;
> +
> +	get_option(&arg, &num);
> +
> +	if (num > 0)
> +		show_msr = num;
> +	return 1;
> +}
> +__setup("show_msr=", setup_show_msr);
> +
>  void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
>  {
>  	if (c->x86_model_id[0])
> @@ -439,6 +482,9 @@ void __cpuinit print_cpu_info(struct cpu
>  		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
>  	else
>  		printk(KERN_CONT "\n");
> +
> +	if (c->cpu_index < show_msr)
> +		print_cpu_msr();
>  }
>  
>  static __init int setup_disablecpuid(char *arg)
> Index: linux-2.6/include/asm-x86/msr.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/msr.h
> +++ linux-2.6/include/asm-x86/msr.h
> @@ -63,6 +63,22 @@ static inline unsigned long long native_
>  	return EAX_EDX_VAL(val, low, high);
>  }
>  
> +static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
> +						      int *err)
> +{
> +	DECLARE_ARGS(val, low, high);
> +
> +	asm volatile("2: rdmsr ; xor %0,%0\n"
> +		     "1:\n\t"
> +		     ".section .fixup,\"ax\"\n\t"
> +		     "3:  mov %3,%0 ; jmp 1b\n\t"
> +		     ".previous\n\t"
> +		     _ASM_EXTABLE(2b, 3b)
> +		     : "=r" (*err), EAX_EDX_RET(val, low, high)
> +		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
> +	return EAX_EDX_VAL(val, low, high);
> +}
> +
>  static inline void native_write_msr(unsigned int msr,
>  				    unsigned low, unsigned high)
>  {
> @@ -158,6 +174,13 @@ static inline int rdmsrl_safe(unsigned m
>  	*p = native_read_msr_safe(msr, &err);
>  	return err;
>  }
> +static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
> +{
> +	int err;
> +
> +	*p = native_read_msr_amd_safe(msr, &err);
> +	return err;
> +}
>  
>  #define rdtscl(low)						\
>  	((low) = (u32)native_read_tsc())


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.27-r3.dmesg2"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc3-21328-ga7f5aaf (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #8 SMP Wed Aug 20 14:17:51 HST 2008
[    0.000000] Command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0 console=ttyS0,115200n8 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff00000 (usable)
[    0.000000]  BIOS-e820: 00000000cff00000 - 00000000cff0a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff0a000 - 00000000cff0b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff0b000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000430000000 (usable)
[    0.000000] last_pfn = 0x430000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 13056MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1561 mtrr_trim_uncached_memory+0x508/0x550()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-21328-ga7f5aaf #8
[    0.000000] 
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80234c3e>] warn_on_slowpath+0x51/0x77
[    0.000000]  [<ffffffff8023570a>] printk+0x4e/0x56
[    0.000000]  [<ffffffff803add02>] sort+0xfa/0x18c
[    0.000000]  [<ffffffff808283d3>] cmp_range+0x0/0x6
[    0.000000]  [<ffffffff80828a47>] mtrr_trim_uncached_memory+0x508/0x550
[    0.000000]  [<ffffffff802178e1>] post_set+0x20/0x3d
[    0.000000]  [<ffffffff80824f99>] setup_arch+0x39d/0x6be
[    0.000000]  [<ffffffff8081e962>] start_kernel+0x74/0x341
[    0.000000]  [<ffffffff8081e394>] x86_64_start_kernel+0xe3/0xe7
[    0.000000] 
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  modified: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff00000 (usable)
[    0.000000]  modified: 00000000cff00000 - 00000000cff0a000 (ACPI data)
[    0.000000]  modified: 00000000cff0a000 - 00000000cff0b000 (ACPI NVS)
[    0.000000]  modified: 00000000cff0b000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000430000000 (reserved)
[    0.000000] last_pfn = 0xcff00 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff00000 page 4k
[    0.000000] kernel direct mapping tables up to cff00000 @ 8000-e000
[    0.000000] last_map_addr: cff00000 end: cff00000
[    0.000000] RAMDISK: 37e11000 - 37feff22
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F7020, 0024 (r2 PTLTD )
[    0.000000] ACPI: XSDT CFF0395D, 005C (r1 PTLTD  	 XSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP CFF09D60, 00F4 (r3 INTEL  TUMWATER  6040000 PTL         3)
[    0.000000] ACPI: DSDT CFF0599D, 434F (r1  Intel SEABURG   6040000 MSFT  3000000)
[    0.000000] ACPI: FACS CFF0AFC0, 0040
[    0.000000] ACPI: _MAR CFF09E54, 0030 (r1 Intel  OEMDMAR   6040000 LOHR        1)
[    0.000000] ACPI: APIC CFF09E84, 00C8 (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: MCFG CFF09F4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
[    0.000000] ACPI: BOOT CFF09F88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: SPCR CFF09FB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
[    0.000000] ACPI: SSDT CFF039B9, 1405 (r1  PmRef    CpuPm     3000 INTL 20050228)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000cff00000
[    0.000000] Bootmem setup node 0 0000000000000000-00000000cff00000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000016fff]
[    0.000000]   bootmap [0000000000017000 -  0000000000030fdf] pages 1a
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00cff00000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00009eff70]    TEXT DATA BSS ==> [0000200000 - 00009eff70]
[    0.000000]   #3 [0037e11000 - 0037feff22]          RAMDISK ==> [0037e11000 - 0037feff22]
[    0.000000]   #4 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000] found SMP MP-table at [ffff8800000f7050] 000f7050
[    0.000000]  [ffffe20000000000-ffffe200033fffff] PMD -> [ffff880001200000-ffff8800045fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cff00
[    0.000000] On node 0 totalpages: 851614
[    0.000000]   DMA zone: 1797 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 834372 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xfec88000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ca000
[    0.000000] PM: Registered nosave memory: 00000000000ca000 - 00000000000cc000
[    0.000000] PM: Registered nosave memory: 00000000000cc000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] PERCPU: Allocating 51624 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 8, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 836169
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc show_msr=1 console=tty0 console=ttyS0,115200n8 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 3192.011 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Memory: 3342244k/3406848k available (3799k kernel code, 64212k reserved, 2164k data, 672k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.006666] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.02 BogoMIPS (lpj=10640036)
[    0.013085] Security Framework initialized
[    0.016665] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.021467] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.026664] Mount-cache hash table entries: 256
[    0.029998] Initializing cgroup subsys ns
[    0.033331] Initializing cgroup subsys cpuacct
[    0.036664] Initializing cgroup subsys memory
[    0.039997] Initializing cgroup subsys devices
[    0.043330] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.048288] CPU: L2 cache: 6144K
[    0.051710] CPU 0/0 -> Node 0
[    0.054867] CPU: Physical Processor ID: 0
[    0.059061] CPU: Processor Core ID: 0
[    0.062918] CPU0: Thermal monitoring enabled (TM2)
[    0.066662] using mwait in idle threads.
[    0.069995] ACPI: Core revision 20080609
[    0.082860] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.119582] CPU0: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.124747] Using local APIC timer interrupts.
[    0.133324] APIC timer calibration result 24937571
[    0.133324] Detected 24.937 MHz APIC timer.
[    0.136657] Booting processor 1/4 ip 6000
[    0.149990] Initializing CPU#1
[    0.149990] Calibrating delay using timer specific routine.. 6386.11 BogoMIPS (lpj=10640186)
[    0.149990] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.149990] CPU: L2 cache: 6144K
[    0.149990] CPU 1/4 -> Node 0
[    0.149990] CPU: Physical Processor ID: 1
[    0.149990] CPU: Processor Core ID: 0
[    0.149990] CPU1: Thermal monitoring enabled (TM2)
[    0.149990] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.233318] CPU1: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.239984] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.243317] Booting processor 2/1 ip 6000
[    0.256649] Initializing CPU#2
[    0.256649] Calibrating delay using timer specific routine.. 6386.10 BogoMIPS (lpj=10640161)
[    0.256649] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.256649] CPU: L2 cache: 6144K
[    0.256649] CPU 2/1 -> Node 0
[    0.256649] CPU: Physical Processor ID: 0
[    0.256649] CPU: Processor Core ID: 1
[    0.256649] CPU2: Thermal monitoring enabled (TM2)
[    0.256649] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.339977] CPU2: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.348077] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.353310] Booting processor 3/5 ip 6000
[    0.366642] Initializing CPU#3
[    0.366642] Calibrating delay using timer specific routine.. 6386.11 BogoMIPS (lpj=10640183)
[    0.366642] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.366642] CPU: L2 cache: 6144K
[    0.366642] CPU 3/5 -> Node 0
[    0.366642] CPU: Physical Processor ID: 1
[    0.366642] CPU: Processor Core ID: 1
[    0.366642] CPU3: Thermal monitoring enabled (TM2)
[    0.366642] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.449857] CPU3: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.456636] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.459970] Booting processor 4/2 ip 6000
[    0.473302] Initializing CPU#4
[    0.473302] Calibrating delay using timer specific routine.. 6386.08 BogoMIPS (lpj=10640133)
[    0.473302] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.473302] CPU: L2 cache: 6144K
[    0.473302] CPU 4/2 -> Node 0
[    0.473302] CPU: Physical Processor ID: 0
[    0.473302] CPU: Processor Core ID: 2
[    0.473302] CPU4: Thermal monitoring enabled (TM2)
[    0.473302] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.556633] CPU4: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.563300] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.566633] Booting processor 5/6 ip 6000
[    0.579962] Initializing CPU#5
[    0.579962] Calibrating delay using timer specific routine.. 6386.09 BogoMIPS (lpj=10640155)
[    0.579962] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.579962] CPU: L2 cache: 6144K
[    0.579962] CPU 5/6 -> Node 0
[    0.579962] CPU: Physical Processor ID: 1
[    0.579962] CPU: Processor Core ID: 2
[    0.579962] CPU5: Thermal monitoring enabled (TM2)
[    0.579962] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.663300] CPU5: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.669967] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.673300] Booting processor 6/3 ip 6000
[    0.686621] Initializing CPU#6
[    0.686621] Calibrating delay using timer specific routine.. 6386.08 BogoMIPS (lpj=10640131)
[    0.686621] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.686621] CPU: L2 cache: 6144K
[    0.686621] CPU 6/3 -> Node 0
[    0.686621] CPU: Physical Processor ID: 0
[    0.686621] CPU: Processor Core ID: 3
[    0.686621] CPU6: Thermal monitoring enabled (TM2)
[    0.686621] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.769967] CPU6: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.776633] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.779967] Booting processor 7/7 ip 6000
[    0.793281] Initializing CPU#7
[    0.793281] Calibrating delay using timer specific routine.. 6386.11 BogoMIPS (lpj=10640183)
[    0.793281] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.793281] CPU: L2 cache: 6144K
[    0.793281] CPU 7/7 -> Node 0
[    0.793281] CPU: Physical Processor ID: 1
[    0.793281] CPU: Processor Core ID: 3
[    0.793281] CPU7: Thermal monitoring enabled (TM2)
[    0.793281] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.876633] CPU7: Intel(R) Xeon(R) CPU           X5482  @ 3.20GHz stepping 06
[    0.883300] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.886633] Brought up 8 CPUs
[    0.889809] Total of 8 processors activated (51093.73 BogoMIPS).
[    0.893300] net_namespace: 864 bytes
[    0.896633] xor: automatically using best checksumming function: generic_sse
[    0.916224]    generic_sse: 11872.800 MB/sec
[    0.919967] xor: using function: generic_sse (11872.800 MB/sec)
[    0.923300] NET: Registered protocol family 16
[    0.926633] No dock devices found.
[    0.929967] ACPI: bus type pci registered
[    0.933300] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 8
[    0.936633] PCI: MCFG area at e0000000 reserved in E820
[    0.939967] PCI: Using MMCONFIG at e0000000 - e08fffff
[    0.943300] PCI: Using configuration type 1 for base access
[    0.949967] ACPI: EC: Look up EC in DSDT
[    0.953300] ACPI: Interpreter enabled
[    0.956633] ACPI: (supports S0 S3 S4 S5)
[    0.959967] ACPI: Using IOAPIC for interrupt routing
[    0.966633] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.969967] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.973300] pci 0000:00:00.0: PME# disabled
[    0.976633] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.979967] pci 0000:00:01.0: PME# disabled
[    0.983300] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.986633] pci 0000:00:05.0: PME# disabled
[    0.989967] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.993300] pci 0000:00:09.0: PME# disabled
[    0.996633] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.999967] pci 0000:00:1b.0: PME# disabled
[    1.003300] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.006633] pci 0000:00:1c.0: PME# disabled
[    1.009967] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.013300] pci 0000:00:1d.7: PME# disabled
[    1.016633] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    1.016633] pci 0000:01:00.0: supports D1
[    1.016633] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.019967] pci 0000:03:00.0: PME# disabled
[    1.023300] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    1.026633] pci 0000:03:00.3: PME# disabled
[    1.029967] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.033300] pci 0000:04:00.0: PME# disabled
[    1.036633] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    1.039967] pci 0000:04:02.0: PME# disabled
[    1.043300] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.046633] pci 0000:06:00.0: PME# disabled
[    1.049967] pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
[    1.053300] pci 0000:06:00.1: PME# disabled
[    1.056633] pci 0000:09:05.0: supports D1
[    1.056633] pci 0000:09:05.0: supports D2
[    1.056633] pci 0000:09:06.0: supports D2
[    1.056633] pci 0000:09:06.0: PME# supported from D2 D3hot D3cold
[    1.059967] pci 0000:09:06.0: PME# disabled
[    1.063300] pci 0000:00:1e.0: transparent bridge
[    1.066633] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.067095] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.067267] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    1.067520] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.067855] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0._PRT]
[    1.068362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD0._PRT]
[    1.068952] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMD0.BPD2._PRT]
[    1.069622] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9.BMF3._PRT]
[    1.069967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.069967] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.079967] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
[    1.086417] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.093100] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.096633] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 14 15)
[    1.103092] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15)
[    1.109748] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15)
[    1.116209] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
[    1.123091] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *9
[    1.129967] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.133300] pnp: PnP ACPI init
[    1.136606] ACPI: bus type pnp registered
[    1.143300] pnp: PnP ACPI: found 11 devices
[    1.146633] ACPI: ACPI bus type pnp unregistered
[    1.149967] SCSI subsystem initialized
[    1.153300] libata version 3.00 loaded.
[    1.153300] usbcore: registered new interface driver usbfs
[    1.156633] usbcore: registered new interface driver hub
[    1.159967] usbcore: registered new device driver usb
[    1.163300] PCI: Using ACPI for IRQ routing
[    1.182453] PCI-GART: No AMD northbridge found.
[    1.186633] hpet clockevent registered
[    1.186633] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.191225] hpet0: 3 64-bit timers, 14318180 Hz
[    1.196633] ACPI: RTC can wake from S4
[    1.206787] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    1.210124] system 00:01: ioport range 0x800-0x80f has been reserved
[    1.216660] system 00:01: ioport range 0x1000-0x107f has been reserved
[    1.223304] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    1.230025] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    1.236751] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.244580] system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    1.252406] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.260230] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.267562] system 00:01: iomem range 0xfec88000-0xfec88fff has been reserved
[    1.274894] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    1.282225] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    1.294506] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.296791] pci 0000:00:01.0:   IO window: disabled
[    1.301858] pci 0000:00:01.0:   MEM window: 0xdc100000-0xdc1fffff
[    1.308140] pci 0000:00:01.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.316064] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
[    1.322185] pci 0000:00:05.0:   IO window: disabled
[    1.327259] pci 0000:00:05.0:   MEM window: disabled
[    1.332419] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.338019] pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
[    1.344139] pci 0000:04:00.0:   IO window: disabled
[    1.349215] pci 0000:04:00.0:   MEM window: disabled
[    1.354382] pci 0000:04:00.0:   PREFETCH window: disabled
[    1.359982] pci 0000:04:02.0: PCI bridge, secondary bus 0000:06
[    1.366655] pci 0000:04:02.0:   IO window: 0x2000-0x2fff
[    1.372163] pci 0000:04:02.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.378460] pci 0000:04:02.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.386390] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.392505] pci 0000:03:00.0:   IO window: 0x2000-0x2fff
[    1.398019] pci 0000:03:00.0:   MEM window: 0xdc200000-0xdc2fffff
[    1.404312] pci 0000:03:00.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.412230] pci 0000:03:00.3: PCI bridge, secondary bus 0000:07
[    1.418350] pci 0000:03:00.3:   IO window: disabled
[    1.423427] pci 0000:03:00.3:   MEM window: disabled
[    1.428588] pci 0000:03:00.3:   PREFETCH window: disabled
[    1.434184] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    1.440304] pci 0000:00:09.0:   IO window: 0x2000-0x2fff
[    1.445813] pci 0000:00:09.0:   MEM window: 0xdc200000-0xdc3fffff
[    1.456277] pci 0000:00:09.0:   PREFETCH window: 0x000000d1100000-0x000000d11fffff
[    1.464201] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    1.470313] pci 0000:00:1c.0:   IO window: disabled
[    1.475395] pci 0000:00:1c.0:   MEM window: disabled
[    1.480557] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.486173] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    1.492293] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
[    1.497803] pci 0000:00:1e.0:   MEM window: 0xdc000000-0xdc0fffff
[    1.504090] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    1.512011] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.518911] pci 0000:00:01.0: setting latency timer to 64
[    1.518917] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.525809] pci 0000:00:05.0: setting latency timer to 64
[    1.525815] pci 0000:00:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.532718] pci 0000:00:09.0: setting latency timer to 64
[    1.532725] pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.539636] pci 0000:03:00.0: setting latency timer to 64
[    1.539643] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.546542] pci 0000:04:00.0: setting latency timer to 64
[    1.546551] pci 0000:04:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.553447] pci 0000:04:02.0: setting latency timer to 64
[    1.553455] pci 0000:03:00.3: setting latency timer to 64
[    1.556782] pci 0000:00:1c.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.560356] pci 0000:00:1c.0: setting latency timer to 64
[    1.560363] pci 0000:00:1e.0: setting latency timer to 64
[    1.560380] NET: Registered protocol family 2
[    1.598362] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.605434] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.616791] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.623135] TCP: Hash tables configured (established 524288 bind 65536)
[    1.630426] TCP reno registered
[    1.643899] NET: Registered protocol family 1
[    1.648674] checking if image is initramfs... it is
[    1.749046] Freeing initrd memory: 1915k freed
[    1.756055] Simple Boot Flag at 0x40 set to 0x80
[    1.766066] audit: initializing netlink socket (disabled)
[    1.766526] type=2000 audit(1219350940.763:1): initialized
[    1.779499] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.789241] VFS: Disk quotas dquot_6.5.1
[    1.796059] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.802377] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.809394] msgmni has been set to 6531
[    1.812727] async_tx: api initialized (async)
[    1.817410] io scheduler noop registered
[    1.820520] io scheduler anticipatory registered
[    1.824640] io scheduler deadline registered
[    1.832001] io scheduler cfq registered (default)
[    1.834045] pci 0000:09:05.0: Boot video device
[    1.836062] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.836062] pcieport-driver 0000:00:01.0: found MSI capability
[    1.842343] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.842729] pci_express 0000:00:01.0:pcie01: allocate port service
[    1.842729] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    1.842729] pcieport-driver 0000:00:05.0: found MSI capability
[    1.848664] pci_express 0000:00:05.0:pcie00: allocate port service
[    1.849397] pci_express 0000:00:05.0:pcie01: allocate port service
[    1.849397] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    1.849397] pcieport-driver 0000:00:09.0: found MSI capability
[    1.854900] pci_express 0000:00:09.0:pcie00: allocate port service
[    1.856064] pci_express 0000:00:09.0:pcie01: allocate port service
[    1.856064] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.856064] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.861124] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.862731] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.862731] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.862731] pcieport-driver 0000:03:00.0: setting latency timer to 64
[    1.862731] pci_express 0000:03:00.0:pcie11: allocate port service
[    1.862731] pcieport-driver 0000:04:00.0: setting latency timer to 64
[    1.862731] pcieport-driver 0000:04:00.0: found MSI capability
[    1.867353] Switched to high resolution mode on CPU 7
[    1.867353] pci_express 0000:04:00.0:pcie21: allocate port service
[    1.867070] Switched to high resolution mode on CPU 2
[    1.869398] pcieport-driver 0000:04:02.0: setting latency timer to 64
[    1.869398] pcieport-driver 0000:04:02.0: found MSI capability
[    1.869398] Switched to high resolution mode on CPU 3
[    1.866687] Switched to high resolution mode on CPU 1
[    1.869398] Switched to high resolution mode on CPU 6
[    1.869336] Switched to high resolution mode on CPU 4
[    1.869764] Switched to high resolution mode on CPU 5
[    1.869987] Switched to high resolution mode on CPU 0
[    1.870468] pci_express 0000:04:02.0:pcie21: allocate port service
[    2.057905] aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC support
[    2.057905] aer 0000:00:05.0:pcie01: AER service couldn't init device: no _OSC support
[    2.057905] aer 0000:00:09.0:pcie01: AER service couldn't init device: no _OSC support
[    2.057905] input: Power Button (FF) as /class/input/input0
[    2.057905] ACPI: Power Button (FF) [PWRF]
[    2.057905] input: Power Button (CM) as /class/input/input1
[    2.057905] ACPI: Power Button (CM) [PWRB]
[    2.057905] ACPI: SSDT CFF04DBE, 01DD (r1  PmRef  Cpu0Ist     3000 INTL 20050228)
[    2.057905] processor ACPI0007:00: registered as cooling_device0
[    2.057905] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.057905] ACPI: SSDT CFF04F9B, 016E (r1  PmRef  Cpu1Ist     3000 INTL 20050228)
[    2.057905] processor ACPI0007:01: registered as cooling_device1
[    2.057905] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.057905] ACPI: SSDT CFF05109, 016E (r1  PmRef  Cpu2Ist     3000 INTL 20050228)
[    2.057905] processor ACPI0007:02: registered as cooling_device2
[    2.057905] ACPI: Processor [CPU2] (supports 8 throttling states)
[    2.057905] ACPI: SSDT CFF05277, 016E (r1  PmRef  Cpu3Ist     3000 INTL 20050228)
[    2.057905] processor ACPI0007:03: registered as cooling_device3
[    2.057905] ACPI: Processor [CPU3] (supports 8 throttling states)
[    2.057905] ACPI: SSDT CFF053E5, 016E (r1  PmRef  CPU4Ist     3000 INTL 20050228)
[    2.057906] processor ACPI0007:04: registered as cooling_device4
[    2.057906] ACPI: Processor [CPU4] (supports 8 throttling states)
[    2.057906] ACPI: SSDT CFF05553, 016E (r1  PmRef  CPU5Ist     3000 INTL 20050228)
[    2.057906] processor ACPI0007:05: registered as cooling_device5
[    2.057906] ACPI: Processor [CPU5] (supports 8 throttling states)
[    2.057906] ACPI: SSDT CFF056C1, 016E (r1  PmRef  Cpu6Ist     3000 INTL 20050228)
[    2.057906] processor ACPI0007:06: registered as cooling_device6
[    2.057906] ACPI: Processor [CPU6] (supports 8 throttling states)
[    2.057906] ACPI: SSDT CFF0582F, 016E (r1  PmRef  Cpu7Ist     3000 INTL 20050228)
[    2.057906] processor ACPI0007:07: registered as cooling_device7
[    2.059010] ACPI: Processor [CPU7] (supports 8 throttling states)
[    2.127920] Non-volatile memory driver v1.2
[    2.137073] intel_rng: FWH not detected
[    2.137655] Linux agpgart interface v0.103
[    2.142568] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    2.149464] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.155797] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.162133] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.168478] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.190625] FDC 0 is a post-1991 82077
[    2.196818] brd: module loaded
[    2.200798] loop: module loaded
[    2.203969] tun: Universal TUN/TAP device driver, 1.6
[    2.207954] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.216078] console [netcon0] enabled
[    2.220046] netconsole: network logging started
[    2.223557] Uniform Multi-Platform E-IDE driver
[    2.229458] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    2.239618] Probing IDE interface ide0...
[    2.938159] hda: Optiarc DVD RW AD-7590A, ATAPI CD/DVD-ROM drive
[    3.584497] Probing IDE interface ide1...
[    4.117883] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.120417] ide1 at 0x170-0x177,0x376 on irq 15
[    4.127680] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 974kB Cache
[    4.135328] Uniform CD-ROM driver Revision: 3.20
[    6.730957] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    6.739681] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    6.748200] megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
[    6.755287] Driver 'sd' needs updating - please use bus_type methods
[    6.761939] Driver 'sr' needs updating - please use bus_type methods
[    6.768535] ata_piix 0000:00:1f.1: version 2.12
[    6.768535] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.775217] ata_piix 0000:00:1f.1: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    6.782752] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 0 (errno=-16)
[    6.790999] ata_piix 0000:00:1f.1: BAR 2: can't reserve I/O region [0x170-0x177]
[    6.798722] ata_piix 0000:00:1f.1: failed to request/iomap BARs for port 1 (errno=-16)
[    6.806962] ata_piix 0000:00:1f.1: no available native port
[    6.814584] Fusion MPT base driver 3.04.07
[    6.817295] Copyright (c) 1999-2008 LSI Corporation
[    6.821978] Fusion MPT SPI Host driver 3.04.07
[    6.828279] Fusion MPT SAS Host driver 3.04.07
[    6.834584] ohci1394 0000:09:06.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.890635] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[dc040000-dc0407ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.913818] ieee1394: raw1394: /dev/raw1394 device initialized
[    6.917291] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.923965] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.923974] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.930097] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.940624] ehci_hcd 0000:00:1d.7: debug port 1
[    6.943963] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.943975] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc608000
[    6.963958] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.971250] usb usb1: configuration #1 chosen from 1 choice
[    6.974979] hub 1-0:1.0: USB hub found
[    6.978985] hub 1-0:1.0: 8 ports detected
[    7.087911] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.087911] USB Universal Host Controller Interface driver v3.0
[    7.090032] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.099763] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.099770] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.105905] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.113756] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[    7.119781] usb usb2: configuration #1 chosen from 1 choice
[    7.127916] hub 2-0:1.0: USB hub found
[    7.128922] hub 2-0:1.0: 2 ports detected
[    7.237910] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    7.243340] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.243347] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.249619] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.257487] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[    7.264583] usb usb3: configuration #1 chosen from 1 choice
[    7.268605] hub 3-0:1.0: USB hub found
[    7.272675] hub 3-0:1.0: 2 ports detected
[    7.381244] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    7.386677] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    7.386687] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.392948] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.400814] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[    7.409047] usb usb4: configuration #1 chosen from 1 choice
[    7.411620] hub 4-0:1.0: USB hub found
[    7.416665] hub 4-0:1.0: 2 ports detected
[    7.524577] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    7.530006] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    7.530013] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    7.536277] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    7.544152] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[    7.552385] usb usb5: configuration #1 chosen from 1 choice
[    7.555258] hub 5-0:1.0: USB hub found
[    7.559263] hub 5-0:1.0: 2 ports detected
[    7.667910] usbcore: registered new interface driver usblp
[    7.670009] Initializing USB Mass Storage driver...
[    7.679164] usbcore: registered new interface driver usb-storage
[    7.684364] USB Mass Storage support registered.
[    7.688774] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    7.706666] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.707299] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.713958] mice: PS/2 mouse device common for all mice
[    8.083323] md: linear personality registered for level -1
[    8.083327] md: raid0 personality registered for level 0
[    8.089095] md: raid1 personality registered for level 1
[    8.094588] md: raid10 personality registered for level 10
[    8.156666] raid6: int64x1   2955 MB/s
[    8.190623] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e08100002824f8]
[    8.217233] raid6: int64x2   3537 MB/s
[    8.276666] raid6: int64x4   3438 MB/s
[    8.336666] raid6: int64x8   2310 MB/s
[    8.396667] raid6: sse2x1    3699 MB/s
[    8.456666] raid6: sse2x2    7339 MB/s
[    8.516666] raid6: sse2x4    8744 MB/s
[    8.520001] raid6: using algorithm sse2x4 (8744 MB/s)
[    8.524573] md: raid6 personality registered for level 6
[    8.530066] md: raid5 personality registered for level 5
[    8.535567] md: raid4 personality registered for level 4
[    8.540833] md: multipath personality registered for level -4
[    8.550392] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    8.558945] cpuidle: using governor ladder
[    8.561311] cpuidle: using governor menu
[    8.565682] usbcore: registered new interface driver usbhid
[    8.571516] usbhid: v2.6:USB HID core driver
[    8.580208] oprofile: using NMI interrupt.
[    8.580421] TCP cubic registered
[    8.586874] NET: Registered protocol family 10
[    8.588544] IPv6 over IPv4 tunneling driver
[    8.596875] NET: Registered protocol family 17
[    8.600208] RPC: Registered udp transport module.
[    8.605577] RPC: Registered tcp transport module.
[    8.611255] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    8.617963] Freeing unused kernel memory: 672k freed
[    8.621765] Write protecting the kernel read-only data: 5536k
[    8.863538] arcmsr 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.863538] arcmsr 0000:01:00.0: setting latency timer to 64
[    8.876862] ARECA RAID ADAPTER0: FIRMWARE VERSION V1.44 2008-1-31  
[    8.890209] scsi0 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[    8.890209]  Driver Version 1.20.00.15 2008/02/27
[    8.891249] scsi 0:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[    8.891041] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    8.890625] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    8.891458] sd 0:0:0:0: [sda] Write Protect is off
[    8.891458] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    8.890833] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.893749] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[    8.893749] sd 0:0:0:0: [sda] 42968747008 512-byte hardware sectors (21999998 MB)
[    8.891041] sd 0:0:0:0: [sda] Write Protect is off
[    8.891041] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[    8.891458] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.891458]  sda: sda1 sda2 sda3 sda4
[    9.288125] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.288125] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.288125] scsi 0:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[    9.288125] scsi 0:0:16:0: Attached scsi generic sg1 type 3
[    9.357920] 3ware Storage Controller device driver for Linux v1.26.02.002.
[    9.369999] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[    9.384166] Adaptec aacraid driver 1.1-5[2456]-ms
[    9.491458] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    9.491459] SGI XFS Quota Management subsystem
[    9.507917] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[    9.507917] Copyright (c) 1999-2006 Intel Corporation.
[   13.719989] kjournald starting.  Commit interval 5 seconds
[   13.719989] EXT3-fs: mounted filesystem with ordered data mode.
[   22.084790] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   22.084790] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[   22.084790] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   22.088581] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[   22.088581] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   22.088581] e1000e 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.088581] e1000e 0000:06:00.0: setting latency timer to 64
[   22.104790] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.163954] 0000:06:00.0: eth0: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:14
[   22.163954] 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   22.163954] 0000:06:00.0: eth0: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[   22.163954] e1000e 0000:06:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   22.163954] e1000e 0000:06:00.1: setting latency timer to 64
[   22.240623] 0000:06:00.1: eth1: (PCI Express:2.5GB/s:Width x4) 00:e0:81:b0:84:15
[   22.240623] 0000:06:00.1: eth1: Intel(R) PRO/1000 Network Connection
[   22.240623] 0000:06:00.1: eth1: MAC: 3, PHY: 5, PBA No: ffffff-0ff
[  116.458114] EXT3 FS on sda3, internal journal
[  116.601448] SMsC 37B787 watchdog component driver 1.1 initialising...
[  116.601448] smsc37b787_wdt: Unable to register miscdev on minor 130
[  117.221031] XFS mounting filesystem sda4
[  117.301234] Ending clean XFS mount for filesystem: sda4
[  117.421000] Adding 31999992k swap on /dev/sda2.  Priority:-1 extents:1 across:31999992k
[  120.787905] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  123.537072] 0000:06:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
[  123.540197] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  134.356662] eth0: no IPv6 routers present
[  155.953259] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  155.953944] NFSD: starting 90-second grace period

--BXVAT5kNtrzKuDFl--

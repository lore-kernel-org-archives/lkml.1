Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbYDPUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbYDPUYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYDPUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:24:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYDPUYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:24:01 -0400
Date: Wed, 16 Apr 2008 22:23:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080416202338.GA6007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


what's brewing in x86.git for v2.6.26?

too many topics to list them all - there are 884 patches from 74 authors 
at the moment.

a few highlights:

 - 4096 CPUs support. (Yes, such big boxes exist, and they run Linux.)

 - mmiotrace feature: trace accesses to hw components to help figure out 
   how they are programmed.

 - kmemcheck feature: Valgrind for the native Linux kernel in essence - 
   detects access to uninitialized memory.

 - ftrace plugin for sysprof

 - fixed StackProtector security feature (these fixes were too intrusive 
   for v2.6.25)

 - lazy FPU allocation/speedup - offloaded/large FPU/SSE state support

 - SMP-boot, mpparse, DMA ops unification

 - PAT support - first step towards phasing out MTRR's for cache 
   attribute control

 - enable GBPAGES - faster TLB misses on CPUs that support it

 - debug helper: view kernel pagetable layout via debugfs

 - lots of paravirt work, unification and cleanups

 - generalized bitops - they are faster and smaller.

 - tons of code cleanups either via the unifications or via explicit 
   cleanup patches - the metrics [via checkpatch] look like this today:

                                         errors   lines of code   errors/KLOC
 [pre-unification:]
 v2.6.23          arch/i386/               5954           83593          71.2
 v2.6.23          arch/x86_64/             2899           31830          91.0

 [mechanic unification:]
 v2.6.24-rc1      arch/x86/                8695          117423          74.0

 [post-unification cleanup work-in-progress:]
 v2.6.24-x86.git  arch/x86/ [21 Nov 2007]  5190          117156          44.2
 v2.6.24-x86.git  arch/x86/ [18 Dec 2007]  4057          117213          34.6
 v2.6.24-x86.git  arch/x86/ [ 4 Feb 2008]  3334          133542          24.9
 v2.6.25-x86.git  arch/x86/ [21 Feb 2008]  2724          136963          19.8
 v2.6.25-x86.git  arch/x86/ [ 1 Mar 2008]  2155          136404          15.7
 v2.6.25-x86.git  arch/x86/ [ 7 Apr 2008]  1868          136793          13.6

 - lots of enhancements for large and small systems alike.

 - ... and more.

See the shortlog below for details. The git tree can be fetched via:

  http://people.redhat.com/mingo/x86.git/README

	Ingo

------------------>
Adrian Bunk (1):
      x86: remove the write-only timer_uses_ioapic_pin_0

Akinobu Mita (6):
      x86: avoid redundant loop in io_apic_level_ack_pending()
      x86: use ioapic_read_entry() and ioapic_write_entry()
      x86: remove unnecessary memset()
      x86: remove unnecessary tmp local variable
      x86: use cpumask_of_cpu()
      x86: use cpu_online()

Alan Mayer (1):
      x86: resize NR_IRQS for large machines

Alexander van Heukelum (24):
      x86: reserve end-of-conventional-memory to 1MB on 32-bit
      x86: reserve_early end-of-conventional-memory to 1MB, 64-bit
      x86: reserve end-of-conventional-memory to 1MB, 64-bit
      x86: reserve end-of-conventional-memory to 1MB, 32-bit, use paravirt_enabled
      x86: reserve end-of-conventional-memory to 1MB, 64-bit, use paravirt_enabled
      x86: remove superfluous initialisation in boot code.
      x86: cleanup boot-heap usage
      x86: change x86 to use generic find_next_bit
      x86: fix uml with generic find_next_bit for x86
      x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps
      x86: merge the simple bitops and move them to bitops.h
      x86: K8, GEODE_LX, CRUSOE, EFFICEON and CORE2 support the cmovxx instructions.
      generic: introduce a generic __fls implementation
      generic: implement __fls on all 64-bit archs
      Use __fls for fls64 on 64-bit archs
      x86: generic versions of find_first_(zero_)bit, convert i386
      x86: switch x86_64 to generic find_first_bit
      x86: optimize find_first_bit for small bitmaps
      x86: remove x86-specific implementations of find_first_bit
      x86: finalize bitops unification
      Build fix for uml/i386
      Build fix for uml/x86_64
      uml: cleanup: use def_bool in Kconfig files
      powerpc: fix find_next_bit breakage on ppc and powerpc

Alexey Dobriyan (1):
      arch/x86/: switch to proc_create()

Alexey Starikovskiy (72):
      x86: move quad_local_to_mp_bus_id to numa.c
      x86: add mp_bus_not_pci bitmap to mpparse_32.c
      x86: use not_pci bitmap #1
      x86: use not_pci bitmap #2
      x86: use not_pci bitmap #3
      x86: use not_pci bitmap #4
      x86: use not_pci bitmap #5
      x86: use not_pci bitmap #6
      x86: rearrange bus_type parse
      x86: make mp_bus_id_to_type optional
      x86: move mp_bus_id_to_local to numa.c
      Move mp_bus_id_to_node to numa.c
      x86: lindent mpparse_64.c
      x86: add bad_ioapic to mpparse_32.c
      x86: add uniq_ioapic_id to mpparse_32.c
      x86: use get_bios_ebda in mpparse_64.c
      x86: limit scan to 1k of EBDA.
      x86: rename gsi_start to gsi_base to match mpparse_32.c
      x86: remove mpc_apic_id()
      x86: remove mpc_oem_pci_bus()
      x86: remove mpc_oem_bus_info()
      x86: make struct mpc_config_translation NUMAQ-only
      x86: use same index for processor maps
      x86: move es7000_plat closer to its user
      x86: don't call MP_processor_info for disabled cpu
      x86: separate generic_processor_info into its own function
      x86: don't use MP_processor_info for ACPI mode
      x86: move apic_ver array to apic_32.c
      x86: move mp_lapic_addr to apic_32.c
      x86: move phys_cpu_present_map to smpboot.c
      x86: move num_processors to smpboot.c
      x86: move disabled_cpus to smpboot.c
      x86: move def_to_bigsmp to setup_32.c
      x86: move boot_cpu_physical_apicid to apic_32.c
      x86: move x86_bios_cpu_apicid to apic_32.c
      x86: move generic_processor_info to apic_32.c
      x86: don't call MP_processor_info for disabled cpu (64bit)
      x86: separate generic_processor_info into its own function (64bit)
      x86: don't use MP_processor_info for ACPI mode (64bit)
      x86: move mp_lapic_addr to apic_64.c
      x86: move phys_cpu_present_map to smpboot.c (64bit)
      x86: move num_processors to smpboot.c (64 bit)
      x86: move disabled_cpus to smpboot.c (64bit)
      x86: move boot_cpu_physical_apicid to apic_64.c
      x86: move generic_processor_info to apic_64.c
      x86: move x86_bios_cpu_apicid to io_apic_64.c
      x86: move x86_cpu_to_apicid to setup.c
      x86: move phys_cpu_present_map to setup.c
      x86: move x86_cpu_to_apicid_init to smpboot.c
      x86: move x86_bios_cpu_apicid_init to smpboot.c
      x86: Don't set IO APIC features if IO APIC is not enabled
      x86: move mp_ioapics to io_apic_32.c
      x86: move mp_ioapics to io_apic_64.c
      x86: move mp_ioapic_routing to boot.c
      x86: move mp_irqs to io_apics_32.c
      x86: move mp_irqs to io_apic_64.c
      x86: move up & smp variables to setup.c
      x86: move mp_register_lapic to boot.c
      x86: move mp_register_lapic_address to boot.c
      x86: Lindend mpparse_32.c
      x86: add early flags to mpparse_32.c
      x86: unify arch/x86/kernel/mpparse_64.c
      x86: unify mp_bus_info
      x86: unify smp_read_mpc
      x86: unify construct_default_ioirq_mptable
      x86: unify get_smp_config
      x86: unify smp_scan_config
      x86: unify uniq_io_apic_id
      x86: unify mp_register_ioapic
      x86: unify mp_config_acpi_legacy_irqs
      x86: unify mp_register_gsi
      x86: merge mpparse_{32,64}.c

Alok Kataria (1):
      x86: fix paranoia about using BIOS quickboot mechanism.

Andi Kleen (13):
      x86: do kernel direct mapping at boot using GB pages
      x86: use year 2000 offset for cmos clock
      x86: add warning when RTC clock reports binary
      x86: enable ACPI extended century handling for 32bit
      x86: don't set up early exception handlers for external interrupts
      x86: replace early exception setup macro recursion with loop
      x86: move early exception handlers into init.text
      x86: implement true end_pfn_mapped for 32bit
      x86: account overlapped mappings in max_pfn_mapped
      x86: add set_memory_4k to pageattr.c
      x86: don't use large pages to map the first 2/4MB of memory
      x86: re-add rdmsrl_safe
      x86: split large page mapping for AMD TSEG

Andres Salomon (1):
      x86: geode: MSR cleanup

Andrew Morton (2):
      i386: arch/x86/math-emu/fpu_entry.c warning fix
      i386: arch/x86/math-emu/reg_ld_str.c: fix warning

Arjan van de Ven (6):
      x86: add code to dump the (kernel) page tables for visual inspection by kernel developers
      x86: setup stack canary for the idle threads
      x86: introduce /dev/mem restrictions with a config option
      x86: add CONFIG_CC_STACKPROTECTOR selftest
      x86: mark init_mm deprecated
      x86: add comments to describe the new api's in cacheflush.h

Arnaldo Carvalho de Melo (1):
      x86: reducing debuginfo size by removing unneeded includes

Auke Kok (1):
      e1000e: set CONFIG_E1000E=y in x86 defconfigs

Ben Castricum (1):
      x86: microcode: show results on success too

Björn Steinbrink (1):
      x86, pci: fix off-by-one errors in some pirq warnings

Christian Limpach (1):
      xen blkfront: Delay wait for block devices until after the disk is added

Cyrill Gorcunov (4):
      x86: processor.h - use PAGE_SIZE instead of numeric value
      x86: relocate_kernel - use predefined PAGE_SIZE instead of own alias
      x86: entry_32.S - use flags from processor-flags.h
      x86: debug Store - call kfree if only we really need it

Dave Jones (1):
      x86: Centaur Isaiah processor to use sysenter in 64-bit compatibility mode rather than syscall

David P. Reed (3):
      x86: fix cmos read and write to not use inb_p and outb_p
      x86: define outb_pic and inb_pic to stop using outb_p and inb_p
      x86: use explicit timing delay for pit accesses in kernel and pcspkr driver

Eric Dumazet (1):
      percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro

Eric W. Biederman (1):
      x86: introduce kernel/head32.c

Erik Bosman (3):
      generic, x86: add prctl commands PR_GET_TSC and PR_SET_TSC
      x86: implement prctl PR_GET_TSC and PR_SET_TSC
      generic, x86: add tests for prctl PR_GET_TSC and PR_SET_TSC

Florian Fainelli (1):
      x86, rdc321x: remove watchdog file

Gautham R Shenoy (1):
      x86: Don't send RESCHEDULE_VECTOR to offlined cpus

Glauber Costa (110):
      x86: change vsmp compile dependency
      x86: make vsmp_init void, instead of static int
      x86: call vsmp_init explicitly
      introduce paravirt helpers
      use the paravirt helpers
      x86: commonize smp.h
      x86: merge extern function definitions
      x86: merge extern variables definitions
      x86: define smp_ops in common header
      x86: move smp_ops extern declaration to common header
      x86: merge smp_send_reschedule
      x86: unify smp_call_function_mask
      x86: unify __cpu_up.
      x86: unify prepare_boot_cpu
      x86: unify smp_prepare_cpus
      x86: unify smp_cpus_done
      x86: move disabled_cpus to common header
      x86: use disabled_cpus in i386
      x86: move prefill_possible_map to common file
      x86: remove export for smp_call_function_mask.
      x86: remove irqs disabled warning.
      x86: create smpcommon.c
      x86: provide __smp_call_function
      x86: change x86_64 smp_call_function_mask to look alike i386
      x86: provide hlt_works function.
      x86: make stop_this_cpu looks exactly equal in both arches
      x86: add reboot_force test to native_smp_send_stop
      x86: unify smp_send_stop
      x86: create smp.c
      x86: create ipi.c
      x86: create tlb files
      x86: get rid of smp_32.c and smp_64.c
      x86: remove cpu_llc_id from processor.h
      x86: adjust types in smpcommon_32.c
      x86: move equal types to common file
      x86: make set_cpu_sibling_map nonstatic
      x86: make remove_siblinginfo non-static
      x86: move hotplug related extern definitions to smp.h
      x86: move sibling functions to common file
      x86: move cpu_coregroup_map to common file
      x86: remove vector_lock around cpu_online_map
      x86: use remove_from_maps in cpu_disable
      x86: do not clear cpu_online_map
      x86: merge __cpu_disable and cpu_die
      x86: make x86_64 accept the max_cpus parameter
      x86: move trampoline arrays extern definition to smp.h
      x86: adapt voyager's trampoline_base
      x86: adapt voyager's setup_trampoline
      x86: unify setup_trampoline
      x86: use wait_for_init_deassert in x86_64
      x86: use cpu_relax instead of rep_nop
      x86: move ipi definitions to mach_ipi.h
      move apic declarations to mach_apic.h
      x86: surround hard_smp_processor_id in APIC_DEFINITION
      x86: provide bogus hard_smp_processor_id
      x86: merge hard/logical_smp_processor_id
      x86: surround apic headers in apic definitions
      x86: merge includes in smp.h
      x86: split safe_smp_processor_id
      x86: merge SMP definitions of smp.h
      x86: change naming of cpu_initialized_mask for xen
      x86: merge smp_32.h and smp_64.h into smp.h
      x86: move dma_ops struct definition to dma-mapping.h
      x86: implement dma_map_single through dma_ops
      x86: move dma_unmap_single to common header
      x86: move dma_map_sg to common header
      x86: move dma_unmap_sg to common header
      x86: move dma_sync_single_for_cpu to common header
      x86: move dma_sync_single_for_device to common header
      x86: move dma_sync_single_range_for_cpu to common header
      x86: move dma_sync_single_range_for_device to common header
      x86: move dma_sync_sg_for_cpu to common header
      x86: move dma_sync_sg_for_device to common header
      x86: move alloc and free coherent to common header
      x86: move dma_map_page and dma_unmap_page to common header
      x86: move dma_cache_sync to common header
      x86: move dma_supported and dma_set_mask to pci-dma_32.c
      x86: align to clflush size
      x86: provide a bad_dma_address symbol for i386
      x86: unify dma_mapping_error
      x86: move ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY to dma-mapping.h
      x86: delete the arch-specific dma-mapping headers.
      x86: introduce pci-dma.c
      x86: delete empty functions from pci-nommu_64.c
      x86: implement mapping_error in pci-nommu_64.c
      x86: Add flush_write_buffers in nommu functions
      x86: use sg_phys in x86_64
      x86: use WARN_ON in mapping functions
      x86: use dma_length in i386
      x86: move definition to pci-dma.c
      x86: unify pci-nommu
      x86: move initialization functions to pci-dma.c
      x86: move x86_64-specific to common code.
      x86: move pci fixup to pci-dma.c
      x86: merge dma_supported
      x86: merge iommu initialization parameters
      x86: move dma_coherent functions to pci-dma.c
      x86: isolate coherent mapping functions
      x86: move bad_dma_address
      x86: adjust dma_free_coherent for i386
      x86: remove virt_to_bus in pci-dma_64.c
      x86: use numa allocation function in i386
      x86: use a fallback dev for i386
      x86: don't try to allocate from DMA zone at first
      x86: retry allocation if failed
      x86: unify gfp masks
      x86: remove kludge from x86_64
      x86: return conditional to mmu
      x86: don't do dma if mask is NULL.
      x86: integrate pci-dma.c

Glauber de Oliveira Costa (78):
      x86: change var types in __inquire_remote_apic
      x86: add loglevel to printks
      x86: use apic_*_around instead of apic_write in x86_64
      x86: use start_ipi_hook in x86_64
      x86: add an smp_apply_quirks to smpboot_32.c
      x86: decouple call to print_cpu_info from smp_store_cpu_info
      x86: provide specialized identification routines for x86_64
      x86: use identify_boot_cpu
      x86: call identify_secondary_cpu in smp_store_cpu_info
      x86: merge smp_store_cpu_info
      x86: always enable irqs when entering idle
      x86: don't call local_irq_enable before entering idle
      x86: move setup_secondary_clock a little bit down in the function
      x86: move state update out of ipi_lock
      x86: provide APIC_INTEGRATED definition for x86_64
      x86: use APIC_INTEGRATED tests in x86_64
      x86: add barriers statement
      x86: isolate sanity checking
      x86: isolate logic to disable smp
      x86: do tests before do_boot_cpu in i386
      x86: make __smp_prepare_cpu void
      x86: move assignment of CPU_PREPARE before do_boot_cpu
      x86: unify extern masks declaration
      x86: define bios to apicid mapping
      x86: initialize map pointers in setup_32.c
      x86: make node to apic mapping declarations unconditional
      x86: fix alloc_bootmem_pages_node macro
      x86: use specialized routine for setup per-cpu area
      x86: fill bios cpu to apicid maps
      x86: fill cpu to apicid and present map in mpparse
      x86: get rid of cpucount
      x86: allow user to impress friends.
      x86: do smp tainting checks in a separate function
      x86: move impress_friends and smp_check to cpus_done
      x86: add subarch support (for headers) to x86_64
      x86: include mach_wakecpu.h in smpboot_64
      x86: include smpboot_hooks.h in smpboot_64.c
      x86: move smp_intr_init away from smpboot_32.c
      x86: don't set maps in native_smp_prepare_boot_cpu()
      x86: wipe get_nmi_reason out of nmi_64.h
      x86: unify nmi_32.h and nmi_64.h
      x86: call check_nmi_watchdog explicitly in native_smp_cpus_done
      x86: call nmi_watchdog_default in i386
      x86: don't initialize sibling and core maps during preparation
      x86: schedule work only if keventd is already running
      x86: do not zap_low_mappings in __smp_prepare_cpus
      x86: boot cpus from cpu_up, instead of prepare_cpus
      x86: get rid of commenced mask.
      x86: use create_idle struct in do_boot_cpu
      x86: don't span a new worker in __smp_prepare_cpu
      x86: modify smp_callin in x86_64 to look like i386
      x86: wrap esr setting up in i386 in lapic_setup_esr
      x86: provide an end_local_APIC_setup function
      x86: calibrate delay with irqs enabled
      x86: minor adjustments for do_boot_cpu
      x86: call do_boot_cpu directly from native_cpu_up
      x86: include mach_apic.h in smpboot_64.c and smpboot.c
      x86: change wakeup_secondary name
      x86: add callin tests to cpu_up
      x86: move {un}map_cpu_to_logical_apicid to smpboot.c
      x86: move stack_start to smp.h
      x86: change boot_cpu_id to boot_cpu_physical_apicid
      x86: integrate do_boot_cpu
      x86: integrate start_secondary
      x86: merge smp_prepare_boot_cpu
      x86: merge native_smp_cpus_done
      x86: use physical id when disabling smp
      x86: get rid of smp_boot_cpus
      x86: additions to i386 native_smp_prepare_cpus.
      x86: assign nr_ioapics = 0 in smpboot_hooks.h
      x86: change x86_64 native_smp_prepare_cpus to match i386
      x86: add extra sanity check
      x86: change x86_64 sanity checks to match i386.
      x86: introduce smpboot_clear_io_apic
      x86: merge native_smp_prepare_cpus
      x86: merge cpu_exit_clear
      x86: move apicid mappings to smpboot.c
      x86: remove smpboot_32.c and smpboot_64.c

H. Peter Anvin (2):
      x86: unify arch/x86/mm/Makefile
      x86: clean up the page table dumper and add 32-bit support

Harvey Harrison (11):
      x86: change most X86_32 pt_regs members to unsigned long
      x86: make X86_32 pt_regs members unsigned long
      x86: regparm(3) is mandatory, no need to annotate
      x86: reduce trivial style differences in signal_32|64.c
      x86: Use FIX_EFLAGS define in X86_64
      x86: use sizeof(long) to unify signal_32|64.c
      x86: move struct definitions to unifed sigframe.h
      x86: Unify argument names in signal_32|64.c
      x86: define DEBUG_SIG in signal_64.c
      x86: replace remaining __FUNCTION__ occurances
      x86: pageattr.c fix shadowed variable warning

Hiroshi Shimamoto (6):
      x86: split cpuinfo from setup_64.c into cpu/proc_64.c
      x86: make cpu/proc|_64.c similar
      x86: add power management line in /proc/cpuinfo
      x86: cosmetic unification cpu/proc|_64.c
      x86: unify cpu/proc|_64.c
      x86: X86_HT always enable on X86_64 SMP

Huang, Ying (5):
      x86: EFI_PAGE_SHIFT fix
      x86, boot: add free_early to early reservation machanism
      x86, boot: add linked list of struct setup_data
      x86, boot: export linked list of struct setup_data via debugfs
      x86, boot: Document for linked list of struct setup_data

Hugh Dickins (1):
      x86: MPSC should use P6 NOPs

Ian Campbell (4):
      x86: use ELF format in compressed images.
      x86: add a crc32 checksum to the kernel image.
      x86: reduce arch/x86/mm/ioremap.o size
      x86: boot protocol updates

Ingo Molnar (85):
      x86: check vmlinux limits, 64-bit
      x86: increase the kernel text limit to 512 MB
      x86: fix the pagetable dumper
      x86: add gbpages switches
      x86: bump image header to version 2.08.
      x86: clean up mmx_32.c
      x86: more coding style fixes in centaur.c
      x86: clean up include/asm-x86/processor.h
      x86: more cleanups in arch/x86/boot/compressed/misc.c
      x86: de-macro start_thread()
      x86: clean up cpu capabilities accesses
      x86: clean up cpu capabilities accesses, generic
      x86: clean up cpu capabilities accesses, amd.c
      x86: clean up cpu capabilities accesses, centaur.c
      x86: clean up cpu capabilities accesses, common.c
      x86: clean up cpu capabilities accesses, cyrix.c
      x86: clean-up-cpu-capabilities-intel.c.patch
      x86: clean up cpu capabilities accesses, transmeta.c
      x86: clean up traps_32.c
      x86, tracing: add notrace to asm-x86/linkage.h
      x86: ioremap(), extend check to all RAM pages
      x86: patches/lguest-fix4.patch
      x86: warn about RAM pages in ioremap()
      x86: redo cded932b75ab0a5f9181e
      x86: debug pmd_bad()
      x86: stackprotector & PARAVIRT fix
      x86: fix stackprotector canary updates during context switches
      x86: fix canary of the boot CPU's idle task
      panic: print more informative messages on stackprotect failure
      panic: print out stacktrace if DEBUG_BUGVERBOSE
      x86: enable stack-protector by default
      stackprotector: include files
      stackprotector: add boot_init_stack_canary()
      x86: fix the stackprotector canary of the boot CPU
      x86: stackprotector: mix TSC to the boot canary
      x86: unify stackprotector features
      x86: clean up switch_to()
      x86: fix switch_to() clobbers
      x86: add comments to processor.h
      x86: clean up i387.c
      x86: remove DEBUG_SIG
      x86: clean up arch/x86/kernel/signal_32.c
      x86: move extern declaration to vdso.h
      x86: add KERN_INFO to show_unhandled_signals printout
      x86: remove mach_reboot.h
      x86: fill cpu to apicid and present map in mpparse, fix
      x86: vsmp fix x86 vsmp fix is vsmp box cleanup
      debugging: always enable stacktrace
      x86: revert ucminus change
      x86: fix ioapic bug again
      x86: PAT fix
      undo "x86: fix breakage of vSMP irq operations"
      x86: tom2 warning fix
      x86: spinlock ops are always-inlined
      x86: ioremap of 64-bit resource on 32-bit kernel fix
      unify: mpparse2 move disabled cpus to smpboot c fix
      unify: mpparse2 move boot cpu physical apicid to apic 32 c fix
      unify: mpparse2 move generic processor info to apic 32 c fix
      unify: move phys cpu present map to smpboot.c, 64bit, prepare
      x86: mpparse: 64-bit fix
      x86: cleanup replace most vm86 flags with flags from processor-flags.h, fix
      x86: support for new UV apic, prepare
      x86: uv fix
      x86: set_cyc2ns_scale() remove prev scale
      x86: improve default idle
      pat: cleanup
      x86: extend the scheduled bzImage symlinks removal
      x86: 4kstacks default
      unify: mpparse4 x86 don t set io apic features if io apic is not enabled fix
      x86: add optimized inlining
      generic: optimized inlining, fix
      x86: clean up cpu capabilities accesses, p4-clockmod.c
      nohz: fix typo in tick-broadcast.c
      kgdb: light v16
      kgdb: IPI fixup
      x86: fix k8-bus_64.c build
      x86: sanity check gart for buggy device, fix
      x86: xen unify x86 add common mm pgtable c fix
      x86: dma-ops on highmem fix
      kmemcheck: fix-up (some bogus) reports
      x86: kmemcheck v7 fix
      kmemcheck: config
      x86: add x86-latest.git tag
      x86: standalone trampoline code
      x86: rename find_max_pfn() to propagate_e820_map()

Isaku Yamahata (12):
      xen: definisions which ia64 needs
      xen: definitions which ia64/xen needs
      xen: add missing definitions for xen grant table which ia64/xen needs
      xen: add missing definitions in include/xen/interface/vcpu.h which ia64/xen needs
      xen: move features.c from arch/x86/xen/features.c to drivers/xen
      xen: move events.c to drivers/xen for IA64/Xen support
      Xen: make events.c portable for ia64/xen support
      xen: add resend_irq_on_evtchn() definition into events.c
      xen: make include/xen/page.h portable moving those definitions under asm dir
      xen: replace callers of alloc_vm_area()/free_vm_area() with xen_ prefixed one
      xen: make grant table arch portable
      xen: import arch generic part of xencomm

Jacek Luczak (10):
      x86: remove vm86.h inclusion from process_32.c
      x86: e820_64, fix section mismatch warning
      x86: section mismatch fixes, #1
      x86: setup_trampoline() - fix section mismatch warning
      x86: section mismatch fixes, #2
      x86: section mismatch fixes, #3
      x86: trampoline_32.S - switch to .cpuinit.data
      x86: uniq_ioapic_id - fix section mismatch warning
      x86: unlock_ExtINT_logic() - fix section mismatch warnings
      x86: pgtable_32.h - prototype and section mismatch fixes

Jack Steiner (11):
      x86: increase max physical memory size of 64-bit
      x86: allow NODES_SHIFT to be a config option on x86_64
      x86: change GET_APIC_ID() from an inline function to an out-of-line function
      x86: add functions to determine if platform is a UV platform
      x86: increase size of APICID
      x86: parsing for ACPI "SAPIC" table
      x86: add UV specific header for MMR definitions
      x86: define the macros and tables for the basic UV infrastructure.
      x86: define the macros and tables for blade functions
      x86: support for new UV apic
      x86: support for new UV apic, fix

Jan Beulich (3):
      x86: prevent unconditional writes to DebugCtl MSR
      x86: simplify sync_test_bit()
      x86: bitops asm constraint fixes

Jeremy Fitzhardinge (39):
      xen: use iret instruction all the time
      x86: only enable interrupts when kernel state has been set up
      x86: simplify sync_test_bit(), improve
      x86: sparsemem: reduce i386 PAE section size
      x86: paravirt_ops: don't steal memory resources in paravirt_disable_iospace
      x86: convert pgalloc_64.h from macros to inlines
      x86: add common mm/pgtable.c
      x86: put paravirt stubs into common asm/pgalloc.h
      x86: move pte functions into common asm/pgalloc.h
      x86: move pmd functions into common asm/pgalloc.h
      x86: move pgalloc pud and pgd operations into common place
      x86: move all the pgd_list handling to one place
      x86: rename paravirt_alloc_pt etc after the pagetable structure
      x86: add pud_alloc for 4-level pagetables
      x86/pgtable.h: demacro ptep_set_access_flags
      x86/pgtable.h: demacro ptep_test_and_clear_young
      x86/pgtable.h: demacro ptep_clear_flush_young
      x86: demacro pgalloc paravirt stubs
      xen: use appropriate pte types
      xen: make use of pte_t union
      xen: unify pte operations
      xen: use phys_addr_t when referring to physical addresses
      xen: unify pte operations on machine frames
      xen: make sure iret faults are trapped
      x86: unify KERNEL_PGD_PTRS
      x86: unify pgd ctor/dtor
      xen: add support for callbackops hypercall
      xen: support sysenter/sysexit if hypervisor does
      xen: implement a debug-interrupt handler
      xen: make sure retriggered events are set pending
      xen: short-cut for recursive event handling
      xen: no need for domU to worry about MCE/MCA
      xen: jump to iret fixup
      xen/blkfront: use bdget_disk
      xen: disable preemption during tlb flush
      xen: allow set_pte_at on init_mm to be lockless
      xen: fold xen_sysexit into xen_iret
      xen: allow compilation with non-flat memory
      xen: add balloon driver

Jesper Juhl (1):
      x86 floppy: kill off the 'register' keyword from header

Jiri Slaby (3):
      x86: pgtable, document pde bits
      x86: fix exec mappings comments
      x86, generic: mark early_printk as asmlinkage

Joe Perches (146):
      x86: include/asm-x86/mutex_32.h - use angle brackets for include
      x86: arch/x86/kernel/cpu/feature_names.c - use angle brackets for include
      x86 - cleanup duplicate includes
      include/asm-x86/acpi.h: checkpatch cleanups - formatting only
      include/asm-x86/alternative.h: checkpatch cleanups - formatting only
      include/asm-x86/a.out-core.h: checkpatch cleanups - formatting only
      include/asm-x86/apicdef.h: checkpatch cleanups - formatting only
      include/asm-x86/apic.h: checkpatch cleanups - formatting only
      include/asm-x86/atomic_32.h: checkpatch cleanups - formatting only
      include/asm-x86/atomic_64.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops_32.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops_64.h: checkpatch cleanups - formatting only
      include/asm-x86/bitops.h: checkpatch cleanups - formatting only
      include/asm-x86/bug.h: checkpatch cleanups - formatting only
      include/asm-x86/byteorder.h: checkpatch cleanups - formatting only
      include/asm-x86/cacheflush.h: checkpatch cleanups - formatting only
      include/asm-x86/checksum_32.h: checkpatch cleanups - formatting only
      include/asm-x86/checksum_64.h: checkpatch cleanups - formatting only
      include/asm-x86/cmpxchg_32.h: checkpatch cleanups - formatting only
      include/asm-x86/cmpxchg_64.h: checkpatch cleanups - formatting only
      include/asm-x86/compat.h: checkpatch cleanups - formatting only
      include/asm-x86/current_32.h: checkpatch cleanups - formatting only
      include/asm-x86/current_64.h: checkpatch cleanups - formatting only
      include/asm-x86/desc_defs.h: checkpatch cleanups - formatting only
      include/asm-x86/desc.h: checkpatch cleanups - formatting only
      include/asm-x86/div64.h: checkpatch cleanups - formatting only
      include/asm-x86/dma.h: checkpatch cleanups - formatting only
      include/asm-x86/dwarf2_64.h: checkpatch cleanups - formatting only
      include/asm-x86/e820_32.h: checkpatch cleanups - formatting only
      include/asm-x86/e820_64.h: checkpatch cleanups - formatting only
      include/asm-x86/edac.h: checkpatch cleanups - formatting only
      include/asm-x86/efi.h: checkpatch cleanups - formatting only
      include/asm-x86/elf.h: checkpatch cleanups - formatting only
      include/asm-x86/fixmap_32.h: checkpatch cleanups - formatting only
      include/asm-x86/fixmap_64.h: checkpatch cleanups - formatting only
      include/asm-x86/floppy.h: checkpatch cleanups - formatting only
      include/asm-x86/futex.h: checkpatch cleanups - formatting only
      include/asm-x86/genapic_32.h: checkpatch cleanups - formatting only
      include/asm-x86/geode.h: checkpatch cleanups - formatting only
      include/asm-x86/highmem.h: checkpatch cleanups - formatting only
      include/asm-x86/hw_irq_64.h: checkpatch cleanups - formatting only
      include/asm-x86/hypertransport.h: checkpatch cleanups - formatting only
      include/asm-x86/i387.h: checkpatch cleanups - formatting only
      include/asm-x86/i8259.h: checkpatch cleanups - formatting only
      include/asm-x86/ia32.h: checkpatch cleanups - formatting only
      include/asm-x86/io_32.h: checkpatch cleanups - formatting only
      include/asm-x86/io_64.h: checkpatch cleanups - formatting only
      include/asm-x86/ioctls.h: checkpatch cleanups - formatting only
      include/asm-x86/io.h: checkpatch cleanups - formatting only
      include/asm-x86/ipcbuf.h: checkpatch cleanups - formatting only
      include/asm-x86/ipi.h: checkpatch cleanups - formatting only
      include/asm-x86/irq_32.h: checkpatch cleanups - formatting only
      include/asm-x86/irq_64.h: checkpatch cleanups - formatting only
      include/asm-x86/irqflags.h: checkpatch cleanups - formatting only
      include/asm-x86/kdebug.h: checkpatch cleanups - formatting only
      include/asm-x86/kexec.h: checkpatch cleanups - formatting only
      include/asm-x86/kprobes.h: checkpatch cleanups - formatting only
      include/asm-x86/kvm_host.h: checkpatch cleanups - formatting only
      include/asm-x86/kvm_x86_emulate.h: checkpatch cleanups - formatting only
      include/asm-x86/lguest_hcall.h: checkpatch cleanups - formatting only
      include/asm-x86/lguest.h: checkpatch cleanups - formatting only
      include/asm-x86/local.h: checkpatch cleanups - formatting only
      include/asm-x86/mc146818rtc.h: checkpatch cleanups - formatting only
      include/asm-x86/mca_dma.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu_context_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu_context_64.h: checkpatch cleanups - formatting only
      include/asm-x86/mmu.h: checkpatch cleanups - formatting only
      include/asm-x86/mmx.h: checkpatch cleanups - formatting only
      include/asm-x86/mmzone_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mmzone_64.h: checkpatch cleanups - formatting only
      include/asm-x86/mpspec_def.h: checkpatch cleanups - formatting only
      include/asm-x86/mpspec.h: checkpatch cleanups - formatting only
      include/asm-x86/msidef.h: checkpatch cleanups - formatting only
      include/asm-x86/msr.h: checkpatch cleanups - formatting only
      include/asm-x86/mtrr.h: checkpatch cleanups - formatting only
      include/asm-x86/mutex_32.h: checkpatch cleanups - formatting only
      include/asm-x86/mutex_64.h: checkpatch cleanups - formatting only
      include/asm-x86/numa_64.h: checkpatch cleanups - formatting only
      include/asm-x86/numaq.h: checkpatch cleanups - formatting only
      include/asm-x86/page_32.h: checkpatch cleanups - formatting only
      include/asm-x86/page_64.h: checkpatch cleanups - formatting only
      include/asm-x86/param.h: checkpatch cleanups - formatting only
      include/asm-x86/paravirt.h: checkpatch cleanups - formatting only
      include/asm-x86/parport.h: checkpatch cleanups - formatting only
      include/asm-x86/pci_64.h: checkpatch cleanups - formatting only
      include/asm-x86/pci-direct.h: checkpatch cleanups - formatting only
      include/asm-x86/pci.h: checkpatch cleanups - formatting only
      include/asm-x86/pda.h: checkpatch cleanups - formatting only
      include/asm-x86/percpu.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable-2level.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable_32.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable-3level.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable_64.h: checkpatch cleanups - formatting only
      include/asm-x86/pgtable.h: checkpatch cleanups - formatting only
      include/asm-x86/posix_types_32.h: checkpatch cleanups - formatting only
      include/asm-x86/posix_types_64.h: checkpatch cleanups - formatting only
      include/asm-x86/processor.h: checkpatch cleanups - formatting only
      include/asm-x86/proto.h: checkpatch cleanups - formatting only
      include/asm-x86/ptrace.h: checkpatch cleanups - formatting only
      include/asm-x86/reboot.h: checkpatch cleanups - formatting only
      include/asm-x86/resume-trace.h: checkpatch cleanups - formatting only
      include/asm-x86/rio.h: checkpatch cleanups - formatting only
      include/asm-x86/rwsem.h: checkpatch cleanups - formatting only
      include/asm-x86/setup.h: checkpatch cleanups - formatting only
      include/asm-x86/sigcontext32.h: checkpatch cleanups - formatting only
      include/asm-x86/sigcontext.h: checkpatch cleanups - formatting only
      include/asm-x86/signal.h: checkpatch cleanups - formatting only
      include/asm-x86/smp_32.h: checkpatch cleanups - formatting only
      include/asm-x86/smp_64.h: checkpatch cleanups - formatting only
      include/asm-x86/spinlock.h: checkpatch cleanups - formatting only
      include/asm-x86/srat.h: checkpatch cleanups - formatting only
      include/asm-x86/string_32.h: checkpatch cleanups - formatting only
      include/asm-x86/string_64.h: checkpatch cleanups - formatting only
      include/asm-x86/suspend_32.h: checkpatch cleanups - formatting only
      include/asm-x86/suspend_64.h: checkpatch cleanups - formatting only
      include/asm-x86/swiotlb.h: checkpatch cleanups - formatting only
      include/asm-x86/sync_bitops.h: checkpatch cleanups - formatting only
      include/asm-x86/system.h: checkpatch cleanups - formatting only
      include/asm-x86/tce.h: checkpatch cleanups - formatting only
      include/asm-x86/thread_info_32.h: checkpatch cleanups - formatting only
      include/asm-x86/thread_info_64.h: checkpatch cleanups - formatting only
      include/asm-x86/tlbflush.h: checkpatch cleanups - formatting only
      include/asm-x86/topology.h: checkpatch cleanups - formatting only
      include/asm-x86/tsc.h: checkpatch cleanups - formatting only
      include/asm-x86/uaccess_32.h: checkpatch cleanups - formatting only
      include/asm-x86/uaccess_64.h: checkpatch cleanups - formatting only
      include/asm-x86/unaligned.h: checkpatch cleanups - formatting only
      include/asm-x86/unistd_32.h: checkpatch cleanups - formatting only
      include/asm-x86/unistd_64.h: checkpatch cleanups - formatting only
      include/asm-x86/user_32.h: checkpatch cleanups - formatting only
      include/asm-x86/user32.h: checkpatch cleanups - formatting only
      include/asm-x86/user_64.h: checkpatch cleanups - formatting only
      include/asm-x86/vdso.h: checkpatch cleanups - formatting only
      include/asm-x86/vga.h: checkpatch cleanups - formatting only
      include/asm-x86/vm86.h: checkpatch cleanups - formatting only
      include/asm-x86/vmi.h: checkpatch cleanups - formatting only
      include/asm-x86/voyager.h: checkpatch cleanups - formatting only
      include/asm-x86/xor_32.h: checkpatch cleanups - formatting only
      include/asm-x86/xor_64.h: checkpatch cleanups - formatting only
      include/asm-x86/ide.h: checkpatch cleanups - formatting only
      include/asm-x86/semaphore_32.h: checkpatch cleanups - formatting only
      include/asm-x86/semaphore_64.h: checkpatch cleanups - formatting only
      x86: include/asm-x86/pgalloc.h/bitops.h: checkpatch cleanups - formatting only
      include/asm-x86/string_32.h - style only
      x86: checkpatch cleanups - formatting only
      x86: include/asm-x86/pgalloc.h: checkpatch cleanups - formatting only

Johannes Weiner (1):
      x86: Remove redundant display of free swap space in show_mem()

Mark McLoughlin (3):
      xen: Module autoprobing support for frontend drivers
      xen: Add compatibility aliases for frontend drivers
      x86: move dma_supported and dma_set_mask to pci-dma_32.c

Markus Armbruster (3):
      xen: make hvc0 the preferred console in domU
      xen: Make xen-blkfront write its protocol ABI to xenstore
      xen pvfb: Para-virtual framebuffer, keyboard and pointer driver

Markus Metzger (1):
      x86, ptrace: PEBS support

Mathieu Desnoyers (3):
      x86: enhance DEBUG_RODATA support - alternatives
      x86 - Enhance DEBUG_RODATA support for hotplug and kprobes
      x86: fix test_poke for vmalloced pages

Mikael Pettersson (1):
      x86: correct/clarify comment in nops.h

Mike Travis (8):
      x86: clean up non-smp usage of cpu maps
      cpumask: add cpumask_scnprintf_len function
      x86: reduce memory and stack usage in intel_cacheinfo
      x86: oprofile: remove NR_CPUS arrays in arch/x86/oprofile/nmi_int.c
      asm-generic: add node_to_cpumask_ptr macro
      numa: move large array from stack to _initdata section
      cpumask: Cleanup more uses of CPU_MASK and NODE_MASK
      x86: modify Kconfig to allow up to 4096 cpus

Paolo Ciarrocchi (42):
      x86: coding style fixes for arch/x86/kernel/cpu/centaur.c
      x86: coding style fixes to arch/x86/lib/memmove_64.c
      x86: coding style fixes to arch/x86/kernel/syscall_64.c
      x86: coding style fixes to arch/x86/lib/string_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p5.c
      x86: coding style fixes to arch/x86/kernel/x8664_ksyms_64.c
      x86: coding style fixes to arch/x86/oprofile/op_model_ppro.c
      x86: coding style fixes to arch/x86/oprofile/op_model_athlon.c
      x86: coding style fixes to arch/x86/mach-generic/probe.c
      x86: coding style fixes to arch/x86/mach-generic/default.c
      x86: coding style fixes to arch/x86/mach-generic/summit.c
      x86: coding style fixes to arch/x86/kernel/cpu/nexgen.c
      x86: coding style fixes to arch/x86/mach-generic/bigsmp.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/p6.c
      x86: coding style fixes to arch/x86/kernel/cpu/umc.c
      x86: coding style fixes to arch/x86/boot/compressed/misc.c
      x86: coding style fix to arch/x86/boot/pm.c
      x86: coding style fixes to arch/x86/kernel/summit_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/intel.c
      x86: coding style fixes to arch/x86/oprofile/init.c
      x86: coding style fixes to arch/x86/lib/strstr_3
      x86: coding style fixes to arch/x86/kernel/mca_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mtrr/state.c
      x86: coding style fixes to arch/x86/lib/memcpy_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/transmeta.c
      x86: coding style fixes to arch/x86/kernel/cpu/amd.c
      x86: coding style fixes to arch/x86/kernel/vm86_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/non-fatal.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/winchip.c
      x86: coding style fixes to arch/x86/kernel/cpu/mcheck/mce_32.c
      x86: coding style fixes to arch/x86/boot/cpucheck.c
      x86: coding style fixes to arch/x86/kernel/cpu/cyrix.c
      x86: coding style fixes to arch/x86/oprofile/nmi_timer_int.c
      x86: coding style fixes to arch/x86/kernel/msr.c
      x86: coding style fixes to arch/x86/xen/multicalls.c
      x86: coding style fixes to arch/x86/power/cpu_32.c
      x86: coding style fixes to arch/x86/kernel/cpu/common.c
      x86: coding style fixes to arch/x86/lib/usercopy_32.c
      x86: coding style fixes to arch/x86/kernel/early_printk.c
      x86: coding style fixes to x86/kernel/early_printk.c
      x86: coding style fixes to arch/x86/kernel/setup_32.c
      x86: coding style fixes to arch/x86/kernel/acpi/sleep.c

Pavel Machek (8):
      x86: wmb() confusion in system.h
      iommu: it could use some documentation
      x86: clean up aperture_64.c
      x86: fix iommu breaks usb after hibernation resume
      x86: iommu: use symbolic constants, not hardcoded numbers
      x86: clean up =0 initializations in arch/x86/kernel/tsc_32.c
      x86: move suspend wakeup code to C
      x86 gart: factor out common code

Pekka Enberg (2):
      x86: __show_registers() and __show_regs() API unification
      kmemcheck: support for x86-64

Pekka J Enberg (6):
      sysprof: minor cleanups
      sysprof: user pointer verification
      x86, sysprof: remove dead code
      x86, sysprof: clean up stack frame copying
      x86, sysprof: merge header to compilation unit
      kmemcheck: use pte helpers instead of ->pte_low

Randy Dunlap (2):
      x86: fix VisualWS and Voyager kexec build failures
      linux-next: Tree for April 10 (arch/x86)

Ravikiran G Thirumalai (5):
      x86: vSMP: Fix is_vsmp_box()
      x86: fix build breakage when PCI is define and PARAVIRT is not
      x86: vSMP: use pvops only if platform has the capability to support it
      x86: apic_is_clustered_box to indicate unsynched TSC's on multiboard vSMP systems
      x86: clean up vSMP detection

Robert Hancock (1):
      x86: validate against acpi motherboard resources

Robert P. J. Day (1):
      x86: Explicitly include required header files.

Robert Richter (1):
      x86: apic: extended interrupt LVT support for AMD

Roland McGrath (8):
      x86 vDSO: don't use disabled vDSO for signal trampoline
      x86 vdso: don't map 32-bit vdso when disabled
      x86: ia32 ptrace vs -ENOSYS
      x86: ptrace vs -ENOSYS
      x86: ia32 ptrace vs -ENOSYS sysenter/syscall
      x86: sys32_execve PT_DTRACE
      x86: handle_vm86_trap cleanup
      x86 vDSO: compile with -g, 64-bit

Roman Zippel (1):
      x86: fix recursive dependencies

Rusty Russell (1):
      x86: if we cannot calibrate the TSC, we panic.

Soren Sandmann (1):
      x86: add the debugfs interface for the sysprof tool

Steven Rostedt (1):
      ftrace: add notrace annotations for NMI routines

Suresh Siddha (5):
      srat, x86: add support for nodes spanning other nodes
      x86, fpu: split FPU state from task struct - v5
      x86, fpu: lazy allocation of FPU area - v5
      x86: fpu xstate split cleanup
      x86: fpu xstate split fix

Thomas Gleixner (8):
      x86: add debug info to DEBUG_PAGEALLOC
      cpa-debug-debugfs.patch
      pagetable-dumper-debugfs.patch
      x86: check physical address range in ioremap
      x86: replace the now useless max_pfn_mapped define
      input: fix PIT build bug on ppc64
      generic: find_next_bit() fix
      x86: tsc prevent time going backwards

Thomas Petazzoni (1):
      x86: use ELF section to list CPU vendor specific code

Vegard Nossum (7):
      x86: kmemcheck, v6
      x86: kmemcheck v7
      kmemcheck: check PTE before calling virt_to_page() on the address
      x86, kmemcheck: simplify shadow-address lookup logic
      kmemcheck: correct decoded size of movzbl instruction
      kmemcheck: one-shot mode
      x86: allocate fpu contexts with SLAB_NOTRACK flag

Venki Pallipadi (4):
      devmem: add range_is_allowed() check to mmap of /dev/mem
      x86: PAT bug fix for attribute type check after reserve_memtype
      x86: PAT infrastructure patch, documentation updates
      x86: PAT bug fix for attribute type check after reserve_memtype, debug

WANG Cong (1):
      x86: remove pointless comments

Yakov Lerner (1):
      x86, kprobes: correct post-eip value in post_hander()

Yinghai Lu (60):
      x86: clean up find_e820_area(), 64-bit
      x86_64: get apic_id later in acpi_numa_processor_affinity_init
      x86_64: remove never used nodenumer in pda
      x86: make amd quad core 8 socket system not be clustered_box, #2
      x86: clean up e820_reserve_resources on 64-bit
      x86_64: insert_resorce for lapic addr after e820_reserve_resources
      x86: apic_is_clustered_box for vsmp
      x86: remove wrong setting about CONSTANT_TSC for intel cpu
      x86_64: fix amd_detect_cmp
      x86: show apicid for cpu in proc
      x86: introduce initial apicid
      x86: sort address_markers for dump_pagetables
      x86_64: get boot_cpu_id as early for k8_scan_nodes
      x86: early memtest to find bad ram
      x86: allocate e820 resource struct all together
      smpboot integration
      x86: memtest bootparam
      x86: fix memtest print out
      x86: enable PAT for amd k8 and fam10h
      x86: pat cpu feature bit setting for known cpus
      x86: print out buggy mptable
      x86_64: do not reserve ramdisk two times
      x86: cleanup: change _end to end_before_pgt
      mm: make mem_map allocation continuous
      mm: fix alloc_bootmem_core to use fast searching for all nodes
      x86: clear pci_mmcfg_virt when mmcfg get rejected
      x86: mmconf enable mcfg early
      x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
      x86_64: check and enable MMCONFIG for AMD Family 10h
      x86_64: check MSR to get MMCONFIG for AMD Family 10h
      x86: if acpi=off, force setting the mmconf for fam10h
      x86: seperate mmconf for fam10h out from setup_64.c
      try parent numa_node at first before using default v2
      x86: skip it if Fam 10h only handle bus 0
      ide: use dev_to_node instead of pcibus_to_node
      x86: remove unneeded check in mmconf reject
      mm: offset align in alloc_bootmem v3
      mm: make reserve_bootmem can crossed the nodes
      x86_64: make reserve_bootmem_generic to use new reserve_bootmem
      x86_64: fix setup_node_bootmem to support big mem excluding with memmap
      x86 pci: remove checking type for mmconfig probe v2
      x86: change pci_direct_conf1 back not static
      x86: reserve dma32 early for gart
      x86: get mp_bus_to_node early
      x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit
      x86: multi pci root bus with different io resource range, on 64-bit
      x86/acpi: make dev_to_node return online node
      x86: double check the multi root bus with fam10h mmconf
      x86/pci: add pci=skip_isa_align command lines.
      net: use numa_node in net_devcice->dev instead of parent
      x86_64: don't need set default res if only have one root bus
      x86_64/mm: check and print vmemmap allocation continuous
      x86_64/mm: check and print vmemmap allocation continuous -fix
      acpi: get boot_cpu_id as early for k8_scan_nodes
      x86: work around io allocation overlap of HT links
      x86: agp_gart size checking for buggy device
      x86: checking aperture size order
      x86: add pci=check_enable_amd_mmconf and dmi check
      x86 PCI: call dmi_check_pciprobe()
      x86_64: allocate gart aperture from 512M

gorcunov@gmail.com (6):
      x86: relocate_kernel_32.S - clear register in more elegant way
      x86: relocate_kernel - use PAGE_SIZE instead of numeric constant
      x86: relocate_kernel - use predefined macroses for processor state
      x86: relocate_kernel - use predefined macroses for page attributes
      x86: cleanup - rename VM_MASK to X86_VM_MASK
      x86: replace most VM86 flags with flags from processor-flags.h

stephane eranian (3):
      x86: add cpu_has_arch_perfmon
      x86: add AMD Northbridge MSR definition
      x86: add AMD Northbridge PCI Id

venkatesh.pallipadi@intel.com (13):
      x86: PAT documentation
      x86: PAT infrastructure patch
      x86: PAT avoid aliasing in /dev/mem read/write
      x86: PAT make ioremap_change_attr non-static
      x86: PAT use reserve free memtype in ioremap and iounmap
      x86: PAT use reserve free memtype in set_memory_uc
      x86: PAT use reserve free memtype in pci_mmap_page_range
      x86: PAT phys_mem_access_prot_allowed for dev/mem mmap
      x86: PAT use reserve free memtype in mmap of /dev/mem
      x86: PAT add set_memory_wc() interface
      x86: PAT add ioremap_wc() interface
      x86: add PAT related debug prints
      x86: PAT export resource_wc in pci sysfs


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYJHVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYJHVeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYJHVe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:34:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbYJHVeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:34:25 -0400
Date: Wed, 8 Oct 2008 23:34:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: What's new in x86.git for v2.6.28
Message-ID: <20081008213410.GA31558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the x86 family of trees had 47 topic trees active during the past 3 
months of the v2.6.28 development cycle:

  x86/alternatives    x86/apic            x86/build           
  x86/cleanups        x86/commandline     x86/cpu
  x86/crashdump       x86/debug           x86/defconfig 
  x86/doc             x86/dumpstack       x86/early-printk    
  x86/exports         x86/gart            x86/header-guards
  x86/idle            x86/iommu           x86/memory-corruption-check
  x86/microcode       x86/mm              x86/mm-debug
  x86/mtrr            x86/nmi-watchdog    x86/oprofile
  x86/paravirt        x86/pat             x86/pci-ioapic-boot-irq-quirks
  x86/pebs            x86/prototypes      x86/ptrace
  x86/quirks          x86/reboot          x86/setup
  x86/signal          x86/sparse-fixes    x86/spinlocks
  x86/time            x86/tracehook       x86/traps
  x86/tsc             x86/unify-cpu-detect
  x86/uv              x86/vmalloc         x86/x2apic
  x86/xen             x86/xsave           

  [ in alphabetic ordering ]

Furthermore, the irq/sparseirq tree (which implements sparse IRQ 
support, and which will be offered in a separate pull request) hosted a 
number of followup x86 topics that depended on the revamped IRQ 
subsystem: IO-APIC and APIC code unification, per-CPU/MSI hpet timers, 
X2APIC support and more.

There are over 880 non-merge commits from close to a hundred developrs
spread out over these topics - too many to credit them individually -
find the shortlog below. The total impact is:

 665 files changed, 30622 insertions(+), 23284 deletions(-)

An incomplete list of bigger new items, in order of appearance:

  - new hardware support: Intel x2apic support

  - unification: IO-APIC code unification and modernisation

  - new hardware support: AMD IOMMU updates

  - kernel feature: Oprofile updates, AMD IBS support, Fam11h support

  - kernel feature: various Xen updates

  - new hardware support: per-CPU (MSI) hpet clocksource implementation
    for more intelligent and more robust nohz/dynticks

  - unification: x86 trap code unification

  - kernel feature: enable tracehook infrastructure

  - kernel feature: PEBS support in ptrace

  - kernel feature: sparse IRQ support

  - unification: local APIC code unification

  - new hardware support: AMD microcode support, x86 microcode loader
    enhancements

  - unification: timer interrupt code unification

  - new hardware support: extended SMM state, xsave support

  - kernel feature: MTRR sanitizer updates

  - kernel debug feature: USB debug port / USB debug key early-printk
    kernel console support

  - unification: signal code partial unification

  - new hardware support: x86/UV updates

  - kernel debug / robustness feature: memory corruption check for
    BIOS-corrupts-low-RAM bugs

  - kernel feature: PAT & TLB flush code updates, fixes and speedups

  - unification: CPU type detection unification

  - kernel feature: improve the information provided for SIGTRAP signals

  - ... and lots of cleanups all around.

	Ingo

------------->
Adam Jackson (1):
      x86, debug printouts: IOMMU setup failures should not be KERN_ERR

Akinobu Mita (2):
      x86: check for ioremap() failure in copy_oldmem_page()
      x86: use platform_device_register_simple()

Alan Cox (1):
      serial, 8250: remove NR_IRQ usage

Alex Nixon (13):
      xen: fix memory access violation bug when CONFIG_HAVE_SPARSE_IRQ is enabled
      xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
      x86: add cpu hotplug hooks into smp_ops
      x86_32: clean up play_dead
      x86: unify x86_32 and x86_64 play_dead into one function
      x86: separate generic cpu disabling code from APIC writes in cpu_disable
      xen: implement CPU hotplugging
      Xen: fix cpu_hotplug.c build by replacing is_running_on_xen() with xen_pv_domain()
      Xen: fix cpu_hotplug build when !CONFIG_SMP
      x86: build fix for !CONFIG_SMP
      x86/paravirt: Remove duplicate paravirt_pagetable_setup_{start, done}()
      x86, xen: fix build when !CONFIG_HOTPLUG_CPU
      xen: make CPU hotplug functions static

Alexander van Heukelum (56):
      x86, 64-bit, dwarf2: push pushes 8 bytes and popf pops 8
      i386: remove kprobes' restore_interrupts in favour of conditional_sti
      i386: prepare to convert exceptions to interrupts
      i386: convert hardware exception 0 to an interrupt gate
      i386: expand exception 3 DO_TRAP macro
      i386: convert hardware exception 4 to an interrupt gate
      i386: convert hardware exception 5 to an interrupt gate
      i386: convert hardware exception 6 to an interrupt gate
      i386: convert hardware exception 7 to an interrupt gate
      i386: convert hardware exception 9 to an interrupt gate
      i386: convert hardware exception 10 to an interrupt gate
      i386: convert hardware exception 11 to an interrupt gate
      i386: convert hardware exception 12 to an interrupt gate
      i386: convert hardware exception 13 to an interrupt gate
      i386: convert hardware exception 15 to an interrupt gate
      i386: convert hardware exception 16 to an interrupt gate
      i386: convert hardware exception 17 to an interrupt gate
      i386: convert hardware exception 18 to an interrupt gate
      i386: convert hardware exception 19 to an interrupt gate
      i386: remove temporary DO_TRAP macros, expanding the last one used
      i386: add TRACE_IRQS_OFF to entry_32.S in 'error_code'
      i386: add TRACE_IRQS_OFF for exception 1 (debug)
      i386: add TRACE_IRQS_OFF for the nmi
      i386: add TRACE_IRQS_OFF for the exception 3 (int3)
      i386: trace_hardirqs_fixup should now not be necessary: irqs are off.
      traps: x86_64: add TRACE_IRQS_OFF in error_entry
      traps: x86_64: add TRACE_IRQS_OFF in paranoidentry macro
      traps: x86_64: remove trace_hardirqs_fixup from DO_ERROR_INFO macro
      traps: x86_64: remove trace_hardirqs_fixup from int3 handler
      traps: x86_64: remove trace_hardirqs_fixup from debug handler
      traps: x86: remove trace_hardirqs_fixup from pagefault handler
      traps: i386: make do_trap more like x86_64
      i386: split out dumpstack code from traps_32.c
      x86_64: split out dumpstack code from traps_64.c
      fix: x86: remove cpu_vendor_dev
      x86, traps: split out math_error and simd_math_error
      x86, traps, i386: factor out lazy io-bitmap copy
      x86, traps: introduce dotraplinkage
      x86, traps: converge do_debug handlers
      traps: x86: converge trap_init functions
      traps: x86_64: make math_state_restore more like i386
      traps: i386: use preempt_conditional_sti/cli in do_int3
      traps: x86_64: make io_check_error equal to the one on i386
      traps: i386: expand clear_mem_error and remove from mach_traps.h
      traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
      traps: x86: various noop-changes preparing for unification of traps_xx.c
      traps: x86: make traps_32.c and traps_64.c equal
      traps: x86: finalize unification of traps.c
      dumpstack: x86: move die_nmi to dumpstack_32.c
      dumpstack: x86: make printk_address equal
      dumpstack: x86: add "end" parameter to valid_stack_ptr and print_context_stack
      dumptrace: x86: consistently include loglevel, print stack switch
      dumpstack: x86: use log_lvl and unify trace formatting
      dumpstack: i386: make kstack= an early boot-param and add oops=panic
      dumpstack: x86: various small unification steps
      dumpstack: x86: various small unification steps, fix

Alexey Dobriyan (5):
      x86_64: remove empty lines from stack traces/oopses
      x86 setup: remove remnants of CONFIG_VIDEO_SELECT (read: vga=)
      x86: make setup_xstate_init() __init
      seccomp: drop now bogus dependency on PROC_FS
      x86: simpler SYSVIPC_COMPAT definition

Alok Kataria (1):
      x86: VMI, initialize IRQ vector

Andi Kleen (2):
      x86: drop -funroll-loops for csum_partial_64.c
      x86: capitalize function call interrupts consistently

Andrea Righi (1):
      x86, oprofile: BUG: using smp_processor_id() in preemptible code

Andreas Herrmann (4):
      x86: compile pat debugfs interface only if CONFIG_X86_PAT is set
      x86: pda_init(): fix memory leak when using CPU hotplug
      x86: cpu_init(): fix memory leak when using CPU hotplug
      x86: hpet: modify IXP400 quirk to enable interrupts

Andrew Morton (3):
      x86, ptrace: PEBS support, warning fix
      arch/x86/pci/irq.c: attempt to clean up code layout
      fix warning: "x86: sparse_irq needs spin_lock in allocations"

Andrey Borzenkov (2):
      x86: fix ghost EDD devices in /sys again
      x86 setup: fix ghost entries under /sys/firmware/edd take 3

Aristeu Rozanski (2):
      x86, NMI watchdog: when booting with reset_devices, clear the performance counters
      x86, NMI watchdog: setup before enabling NMI watchdog

Arjan van de Ven (2):
      x86: print DMI information in the oops trace
      x86: use round_jiffies() for the corruption check timer

Avi Kivity (1):
      x86: default to reboot via ACPI

Barry Kasindorf (3):
      oprofile: Add support for AMD Family 11h
      x86/oprofile: add IBS support for AMD CPUs, IBS buffer handling routines
      x86/oprofile: add IBS support for AMD CPUs, model specific code

Bill Nottingham (1):
      x86_64: be less annoying on boot

Bruce Allan (1):
      x86: export set_memory_ro and set_memory_rw

Christoph Hellwig (1):
      x86: kill sys32_pause

Chuck Ebbert (3):
      x86: move prefill_possible_map calling early, fix, V2
      xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
      x86: allow number of additional hotplug CPUs to be set at compile time, V2

Cihula, Joseph (1):
      x86, e820: add support for AddressRangeUnusuable ACPI memory type

Cyrill Gorcunov (55):
      x86: DS cleanup - dont treat 0 as NULL
      x86: apic unification - merge down lapic_get_maxlvt
      x86: apic unification - merge down enable_NMI_through_LVT0
      x86: apic interrupts - move assignments to irqinit_32.c, v2
      x86: apic - use SET_APIC_DEST_FIELD instead of hardcoded shift
      x86: apic - unify disable_apic_timer
      x86: apic - unify __setup_APIC_LVTT
      x86: apic - do not clear APIC twice in lapic_shutdown
      x86: apic - get rid of local_apic_timer_verify_ok
      x86: apic - unify verify_local_APIC
      x86: apic - unify sync_Arb_IDs
      x86: apic - sync_Arb_IDs style fixup
      x86: apic - unify init_bsp_APIC
      x86: apic - unify clear_local_APIC
      x86: apic - unify lapic_resume
      x86: apic - unify lapic_suspend
      x86: apic - rearrange functions and comments
      x86: apic - unify lapic_is_integrated
      x86: apic - unify xapic_icr_read
      x86: apic - rearrange maxcpu definition
      x86: apic - unify setup_boot_APIC_clock
      x86: apic - unify disable_local_APIC
      x86: apic - unify lapic_shutdown
      x86: apic - unify connect_bsp_APIC
      x86: apic - unify lapic_setup_esr
      x86: apic - unify __setup_APIC_LVTT
      x86: apic - unify disconnect_bsp_APIC
      x86: apic - generic_processor_info
      x86: apic - unify end_local_APIC_setup
      x86: apic - unify local_apic_timer_interrupt
      x86: apic - unify apic_set_verbosity
      x86: apic - unify disableapic and nolapic setup handlers
      x86: apic - rearrange parse_lapic_timer_c2_ok
      x86: apic - lapic_resume 32bit - unification fix
      x86: apic - compilation warnings fix
      x86: apic_64.c - setup_APIC_timer has to be __cpuinit function
      x86: apic - introduce get_physical_broadcast for 64bit
      x86: apic - unify setup_apicpmtimer
      x86: apic_64.c - add sanity check for spurious vector definition
      x86: apic - unify setup_local_APIC
      x86: apic_32.c should use __cpuinit section
      x86: apic - unify smp_apic_timer_interrupt
      x86: apic - unify smp_spurious/error_interrupt declaration
      x86: io-apic - use ARRAY_SIZE macro
      x86: io-apic - declare irq_cfg_lock for SPARSE_IRQ only
      x86: io-apic - code style cleaning for setup_IO_APIC_irqs
      x86: io-apic - do not use KERN_DEBUG marker too much
      x86: io-apic - get rid of __DO_ACTION macro
      x86: apic - lapic_setup_esr does not handle esr_disable - fix it
      x86: apic - skip writting ESR register if we dont have on
      x86: apic - fix unused vars warning in calibrate_APIC_clock
      x86: io-apic - do not use KERN_DEBUG marker too much, fix
      x86: smpboot - check if we have ESR register in wakeup_secondary_cpu
      x86: io-apic - interrupt remapping fix
      x86: io-apic - interrupt remapping fix

Dave Young (1):
      i386: vmalloc size fix

David Brownell (2):
      hpet: /dev/hpet - fixes and cleanup
      hpet: /dev/hpet - fixes and cleanup, fix

David Woodhouse (2):
      Fix date output in x86 microcode driver.
      x86: blacklist DMAR on Intel G31/G33 chipsets

Dean Nelson (3):
      irq: error missed ifndef CONFIG_HAVE_SPARSE_IRQ
      irq: set_irq_chip() has redundant call to irq_to_desc()
      x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3

Dimitri Sivanich (1):
      x86: remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU

Dmitry Adamushko (6):
      x86-microcode: fix unbalanced use of get_cpu()
      x86-microcode: generic interface refactoring
      x86, microcode rework, v2
      x86: moved microcode.c to microcode_intel.c
      x86, microcode_amd: cleanup, mark request_microcode_user() as unsupported
      x86/microcode: fix sleeping function called from invalid context at kernel/mutex.c

Eduardo Habkost (3):
      x86, xen: Use native_pte_flags instead of native_pte_val for .pte_flags
      xen_alloc_ptpage: cast PFN_PHYS() argument to unsigned long
      x86, paravirt_ops: use unsigned long instead of u32 for alloc_p*() pfn args

Eric Dumazet (1):
      percpu: introduce DEFINE_PER_CPU_PAGE_ALIGNED() macro

Eric W. Biederman (1):
      genirq: enable polling for disabled screaming irqs

FUJITA Tomonori (33):
      x86 gart: allocate size-aligned address for alloc_coherent, v2
      dma-mapping.h, x86: remove last user of dma_mapping_ops->map_simple
      x86: dma_*_coherent rework patchset v2, fix
      x86: gart alloc_coherent doesn't need to check NULL device argument
      ia64: dma_alloc_coherent always use GFP_DMA
      x86: move pci-nommu's dma_mask check to common code
      x86: fix nommu_alloc_coherent allocation with NULL device argument
      x86: dma_alloc_coherent sets gfp flags properly
      swiotlb: remove GFP_DMA hack in swiotlb_alloc_coherent
      swiotlb: use map_single instead of swiotlb_map_single in swiotlb_alloc_coherent
      swiotlb: use unmap_single instead of swiotlb_unmap_single in swiotlb_free_coherent
      swiotlb: add is_swiotlb_buffer helper function
      add is_buffer_dma_capable helper function
      x86: convert gart to use is_buffer_dma_capable helper function
      x86: convert pci-nommu to use is_buffer_dma_capable helper function
      swiotlb: convert swiotlb to use is_buffer_dma_capable helper function
      x86: remove duplicated extern force_iommu
      x86: convert dma_alloc_coherent to use is_device_dma_capable
      iommu: add iommu_device_max_index IOMMU helper function
      iommu: add dma_get_mask helper function
      x86: make GART to respect device's dma_mask about virtual mappings
      x86: avoid unnecessary low zone allocation in Calgary's alloc_coherent
      x86: gart alloc_coherent does virtual mapppings only when necessary
      convert swiotlb to use dma_get_mask
      AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
      iommu: export iommu_area_reserve helper function
      x86: remove set_bit_string()
      iommu: remove fullflush and nofullflush in IOMMU generic option
      x86: export pci-nommu's alloc_coherent
      revert "x86: make GART to respect device's dma_mask about virtual mappings"
      x86: restore old GART alloc_coherent behavior
      x86 gart: remove unnecessary initialization
      AMD IOMMU: use iommu_device_max_index

Glauber Costa (13):
      x86: use user_mode macro
      x86: coalesce tests
      x86: set bp field in pt_regs properly
      x86: use frame pointer information on x86_64 profile_pc
      x86: remove SEGMENT_IS_FLAT_CODE
      x86: use user_mode_vm instead of user_mode
      x86: bind irq0 irq data to cpu0
      x86: factor out irq initialization for x86_64
      x86: make init_ISA_irqs nonstatic
      x86: rename timer_event_interrupt to timer_interrupt
      x86: replace hardcoded number
      x86: wrap MCA_bus test around an ifdef
      x86: move vgetcpu mode probing to cpu detection

Gustavo F. Padovan (7):
      x86: coding styles fixes to arch/x86/kernel/process_64.c
      x86: add KERN_INFO to printks on process_64.c
      x86: coding style fixes to arch/x86/kernel/crash_dump_64.c
      x86: coding style fixes to arch/x86/kernel/signal_64.c
      x86: coding style fixes to arch/x86/kernel/traps_64.c
      x86: coding style fixes to arch/x86/kernel/sys_x86_64.c
      x86: coding style fixes to arch/x86/kernel/traps_64.c

H. Peter Anvin (21):
      x86: doc: move x86-generic documentation from Doc/x86/i386
      x86: doc: boot.txt: fix the size of the start_sys field
      x86, xsave: add <asm/xcr.h> header file for XCR registers
      x86, xsave: keep the XSAVE feature mask as an u64
      x86: boot: stub out unimplemented CPU feature words
      x86: add NOPL as a synthetic CPU feature bit
      x86: use X86_FEATURE_NOPL in alternatives
      x86: <asm/asm.h> consistency cleanups
      x86: msr-on-cpu: remove unnecessary level of abstraction
      x86: generate names for /proc/cpuinfo from <asm/cpufeature.h>
      x86: cpufeature: add Intel features from CPUID and AVX specs
      x86: <asm/cpufeature.h>: clean up overlong lines, whitespace
      x86: cpufeature: fix SMX flag
      x86: boot/compressed/Makefile: fix "make clean"
      dyn_array: don't break compiling for !CONFIG_SMP
      x86: additional defconfig updates
      x86: when building image.iso, use isohybrid if it exists
      kbuild: fix cc-option and cc-option-yn
      x86: prevent binutils from being "smart" and generating NOPLs for us
      x86 setup: handle more than 8 CPU flag words
      Revert "x86: fix ghost EDD devices in /sys again"

Harvey Harrison (3):
      x86: early_printk.c trivial sparse fixes
      x86: ds.c ptrace.c integer as NULL pointer sparse fixes
      x86, olpc: fix endian bug in openfirmware workaround

Hiroshi Shimamoto (25):
      x86_32: use apic_ops at print_local_APIC()
      x86_64: uml: fix rename header guard
      x86: acpi: move acpi_mcfg_64bit_base_addr into CONFIG_PCI_MMCONFIG
      x86_32: signal: use syscall_get_nr and error
      x86_32: signal: introduce signal_fault()
      x86: signal: make NR_restart_syscall
      x86: signal: split out frame setups
      x86_32: signal: move signal number conversion to upper layer
      x86: signal_64.c: clean up signal_fault()
      x86: signal_64.c: arg for restore_i387_xstate() is void __user *
      x86: signal_64.c: make handle_signal() similar
      x86: signal: put give_sigsegv of setup frames together
      x86: signal: remove unneeded err handling
      x86: signal: introduce do_rt_sigreturn()
      x86: signal: cosmetic unification of do_signal()
      x86: signal: cosmetic unification of do_notify_resume()
      x86: signal: cosmetic unification of handle_signal()
      x86: signal_32.c: introduce signr_convert()
      x86: signal_64.c: introduce helper function signr_convert()
      x86: signal: introduce helper macro is_ia32
      x86: signal_32.c: introduce macro ia32_setup_frame and ia32_setup_rt_frame
      x86: ia32_signal.c: remove unnecessary cast to u32
      x86: ia32_signal.c remove unnecessary function calls
      x86: signal: move macros out from restore_sigcontext()
      x86: signal: remove indent in restore_sigcontext()

Huang Weiyi (5):
      arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include
      arch/x86/kernel/visws_quirks.c: Removed duplicated #include
      arch/x86/kernel/acpi/boot.c: removed duplicated #include
      arch/x86/kernel/cpuid.c: removed duplicated #include
      arch/x86/kernel/apm_32.c: remove duplicated #include

Hugh Dickins (2):
      x86: add periodic corruption check
      x86: unsigned long pte_pfn

Ingo Molnar (58):
      x86: PEBS cleanup
      x86, MM: virtual address debug, cleanups
      x86, xen: fix apic_ops build on UP
      x86, lguest: fix apic_ops build on UP
      x86, cyrix: debug
      x86: fix ds.c build error
      x86: usb debug port early console, fix
      x86: visws_quirks, fix build error
      x86: L3 cache index disable for 2.6.26, cleanups
      x86 l3 cache index disable for 2 6 26 fix
      x86: L3 cache index disable for 2.6.26, fix #2
      x86, microcode support: fix build error
      x86, microcode: fix symbol exports
      x86, microcode: fix module license string
      x86: fix xsave build error
      irq: sparse irqs, export nr_irqs
      irq: sparse irqs, fix #3
      irq: sparse irqs, fix IRQ auto-probe crash
      sparseirq: fix lockdep
      x86: make io_apic_32.c the same as io_apic_64.c
      warning: fix arch x86 kernel io_apic c
      Revert "reduce tlb/cache flush times of agpgart memory allocation"
      Revert "introduce two APIs for page attribute"
      dma-coherent: export dma_[alloc|release]_from_coherent methods
      sparseirq: export nr_irqs on m68k/sparc/s390
      x86: split e820 reserved entries record to late v4
      x86: quick TSC calibration, improve
      x86: cpu/common*.c, merge whitespaces
      x86, init_64.c: cleanup
      x86: HPET_MSI Basic HPET_MSI setup code, cleanups
      x86, tsc calibration: fix
      x86: x86_{phys,virt}_bits field also for i386, fix
      Revert "x86: x86_{phys,virt}_bits field also for i386, fix"
      Revert "x86: x86_{phys,virt}_bits field also for i386 (v2)"
      x86: cpuid, fix typo
      x86, microcode rework, v2, fix
      x86: print out EBDA/lowmem address
      x86: add DMI quirk for AMI BIOS which corrupts address 0xc000 during resume
      x86: reserve low 64K on AMI and Phoenix BIOS boxen
      x86: add X86_RESERVE_LOW_64K
      Revert "x86: handle error returns in set_memory_*()"
      Revert "x86: track memtype for RAM in page struct"
      Revert "x86, cpa: global flush tlb after splitting large page and before doing cpa"
      Revert "x86, cpa: remove cpa pool code"
      Revert "x86, cpa: fix taking the pgd_lock with interrupts off"
      Revert "x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC"
      Revert "x86, cpa: make the kernel physical mapping initialization a two pass sequence"
      Revert "x86, cpa: remove USER permission from the very early identity mapping attribute"
      Revert "x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot"
      x86, pat: cleanups
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86, UV: add uv_setup_irq() and uv_teardown_irq() functions, v3, fix
      x86: __show_registers() and __show_regs() API unification, fixlet
      x86: remove additional_cpus configurability
      Revert "pci: fix BAR print out"
      Revert "acpi/x86: introduce __apci_map_table, v4"
      Revert "acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap"

J.A. Magallón (1):
      x86: mtrr_cleanup try gran_size to less than 1M, cleanup

Jack Steiner (4):
      x86, uv: fix ordering of calls to uv_system_init & uv_cpu_init
      x86, uv: add early detection of UV system types
      x86, uv: fix for size of hub mappings
      x86, UV: new UV genapic functions for x2apic

Jan Beulich (15):
      x86: ticket spin locks: fix asm constraints
      x86: ticket spin locks: factor out more common code
      x86: ticket spin locks: reduce instruction dependencies
      x86: init annotations in early_printk() setup
      x86: pgd_{c,d}tor() cleanup
      x86: adjust vmalloc_sync_all() for Xen (2nd try)
      x86-64: reduce boot fixmap space
      x86-64: add two __cpuinit annotations
      x86-64: eliminate dead code
      x86-64: slightly stream-line 32-bit syscall entry code
      x86: x86_{phys,virt}_bits field also for i386 (v2)
      x86-64: fix combining of regions in init_memory_mapping()
      x86: make mm/gup.c more virtualization friendly
      x86: adjust dependencies for CONFIG_X86_CMOV
      x86: adjust dependencies for CONFIG_X86_CMOV

Jason Yeh (1):
      Oprofile Multiplexing Patch

Jaswinder Singh (27):
      x86: Introducing asm/syscalls.h
      x86: process_32.c declare cpu_number before they get used
      x86: signal_XX.c declare do_notify_resume before they get used
      x86: time_XX.c declare functions before they get used
      x86: setup.c declare saved_video_mode before they get used
      x86: e820.c declare pci_mem_start before they get used
      x86: pci-dma.c declare iommu_bio_merge before they get used
      x86: pci-nommu.c declare nommu_dma_ops before they get used
      x86: i387.c declare dump_fpu() before they get used
      x86: ptrace.c declare functions before they get used
      x86: proc.c declare cpuinfo_op before they get used
      x86: common.c declare idle_regs before they get used
      x86: mtrr/main.c declare range_state as static
      x86: apic_XX.c declare functions before they get used
      x86: vm86_32.c declare functions before they get used
      x86: mm/init_XX.c declare functions before they get used
      x86: mm/fault.c declare do_page_fault before they get used
      x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
      x86: mm/pageattr.c declare arch_report_meminfo before they get used
      x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
      x86: mach-default/setup.c declare no_broadcast before they get used
      x86_64: Declare new_utsname in asm-x86/syscalls.h
      X86_32: declare pt_regs_access as unsigned long
      X86_SMP: smp.c declare functions before they get used
      X86_SMP: smpboot.c declare idle_thread_array and smp_b_stepping as static
      X86_SMP: ipi.c declare functions before they get used
      X86_SMP: tlb_XX.c declare smp_invalidate_interrupt before they get used

Jeff Chua (1):
      x86: make sparsemem more available

Jeremy Fitzhardinge (39):
      x86/paravirt/xen: properly fill out the ldt ops
      x86: split spinlock implementations out into their own files
      x86: fix initialization of 'l' bit in ldt descriptors
      xen: fix allocation and use of large ldts
      generic, memparse(): constify argument
      xen-balloon: fix up sysfs issues
      xen-balloon: clean up unused functions
      xen: suppress known wrmsrs
      xen: compile irq functions without -pg for ftrace
      xen: fix allocation and use of large ldts, cleanup
      x86_64: use save/loadsegment in ia32 compat
      x86: another user of PTE_FLAGS_MASK
      xen: clean up domain mode predicates
      x86/paravirt: add spin_lock_flags lock op
      xen: clarify locking used when pinning a pagetable.
      xen: add xen_ prefixes to make tracing with ftrace easier
      xen: save previous spinlock when blocking
      xen: add debugfs support
      xen: allow interrupts to be enabled while doing a blocking spin
      xen: measure how long spinlocks spend blocking
      x86: build fix in "xen spinlock updates and performance measurements"
      x86: export pv_lock_ops non-GPL
      x86: make sure the CPA test code's use of _PAGE_UNUSED1 is obvious
      x86: check for and defend against BIOS memory corruption
      x86: clean up memory corruption check and add more kernel parameters
      x86: default corruption check to off, but put parameter default in Kconfig
      x86: fix compile error with corruption checking disabled
      x86: add _PAGE_IOMAP pte flag for IO mappings
      x86: remove duplicate early_ioremap declarations
      x86: add early_memremap()
      x86: use early_memremap() in setup.c
      x86-64: don't check for map replacement
      x86: use early_ioremap in __acpi_map_table
      x86: always explicitly map acpi memory
      mm: define USE_SPLIT_PTLOCKS rather than repeating expression
      xen: fix pinning when not using split pte locks
      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
      xen: clean up x86-64 warnings
      xen: remove unused balloon.h

Jiri Slaby (2):
      MM: virtual address debug
      x86, MM: virtual address debug, v2

Joe Buehler (1):
      x86: add PCI ID for 6300ESB force hpet

Joe Korty (1):
      x86: make poll_idle behave more like the other idle methods

Joerg Roedel (42):
      x86: convert pci-dma.c from round_up to roundup
      x86: convert pageattr.c from round_up to roundup
      x86: convert init_64.c from round_up to roundup
      x86: convert numa_64.c from round_up to roundup
      x86: convert discontig_32.c from round_up to roundup
      x86: add alloc_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to Calgary IOMMU driver
      x86: add alloc_coherent dma_ops callback to NOMMU driver
      x86: add free_coherent dma_ops callback to NOMMU driver
      x86: cleanup dma_*_coherent functions
      x86: move dma_*_coherent functions to include file
      x86, AMD IOMMU: remove obsolete FIXME comment
      x86, pci: add northbridge pci ids for fam 0x11 processors
      x86, gart: add detection of AMD family 0x11 northbridges
      AMD IOMMU: check for invalid device pointers
      AMD IOMMU: move TLB flushing to the map/unmap helper functions
      x86: move GART TLB flushing options to generic code
      AMD IOMMU: implement lazy IO/TLB flushing
      AMD IOMMU: add branch hints to completion wait checks
      AMD IOMMU: align alloc_coherent addresses properly
      AMD IOMMU: add event buffer allocation
      AMD IOMMU: save pci segment from ACPI tables
      AMD IOMMU: save pci_dev instead of devid
      AMD IOMMU: add MSI interrupt support
      AMD IOMMU: add event handling code
      AMD IOMMU: enable event logging
      AMD IOMMU: allow IO page faults from devices
      AMD IOMMU: add dma_supported callback
      AMD IOMMU: don't assign preallocated protection domains to devices
      AMD IOMMU: some set_device_domain cleanups
      AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
      AMD IOMMU: simplify dma_mask_to_pages
      AMD IOMMU: free domain bitmap with its allocation order
      AMD IOMMU: remove unnecessary cast to u64 in the init code
      AMD IOMMU: calculate IVHD size with a function
      AMD IOMMU: use cmd_buf_size when freeing the command buffer
      add AMD IOMMU tree to MAINTAINERS file
      AMD IOMMU: use coherent_dma_mask in alloc_coherent
      x86/iommu: make GART driver checkpatch clean
      x86/iommu: convert GART need_flush to bool
      x86/iommu: use __GFP_ZERO instead of memset for GART

Jordan Crouse (1):
      x86, hpet: SB600 - remove HPET resources from PCI device

Kevin Hao (1):
      x86: get irq for hpet timer

Krzysztof Helt (3):
      x86: delay early cpu initialization until cpuid is done
      x86: merge winchip-2 and winchip-2a cpu choices
      x86: do not allow to optimize flag_is_changeable_p() (rev. 2)

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force-hpet

Li Zefan (1):
      x86: remove nesting CONFIG_HOTPLUG_CPU

Linus Torvalds (1):
      x86: quick TSC calibration

Luiz Fernando N. Capitulino (1):
      x86: remove 8254 timer texts from Documentation

Maciej W. Rozycki (2):
      x86: PIC, L-APIC and I/O APIC debug information
      x86: fix up a comment in ack_APIC_irq()

Manfred Spraul (1):
      arch/x86/kernel/smpboot.c: Clarify when irq processing begins.

Marcin Slusarz (4):
      x86, tsc: fix section mismatch warning
      x86: fix MP_processor_info section mismatch warning
      x86: mmconf: fix section mismatch warning
      x86: mpparse.c: fix section mismatch warning

Mark Langsdorf (2):
      x86: L3 cache index disable for 2.6.26
      x86: L3 cache index disable for 2.6.26

Markus Metzger (1):
      x86, ptrace: PEBS support

Mathieu Desnoyers (3):
      x86: alternatives : fix LOCK_PREFIX race with preemptible kernel and CPU hotplug
      x86: revert replace LOCK_PREFIX in futex.h
      x86: spinlock use LOCK_PREFIX

Michal Januszewski (1):
      x86: replace a magic number with a named constant in the VESA boot code

Nick Piggin (1):
      x86, pat: avoid highmem cache attribute aliasing

Paolo Ciarrocchi (6):
      x86: coding style fixes to arch/x86/boot/compressed/misc.c
      x86: coding style fixes to arch/x86/kernel/bios_uv.c
      x86: coding style fixes to arch/x86/lib/strstr_32.c
      x86: coding style fixes to arch/x86/lib/string_32.c
      x86: coding style fixes to arch/x86/kernel/paravirt_patch_32.c
      x86: Coding style fixes to arch/x86/oprofile/op_model_p4.c

Paul Bolle (3):
      x86 setup: drop SWAP_DEV
      x86 setup: remove DEF_INITSEG and DEF_SETUPSEG
      x86 setup: remove IMAGE_OFFSET

Pekka Enberg (1):
      x86: __show_registers() and __show_regs() API unification

Peter Oruba (20):
      x86: AMD microcode patch loading support v2
      x86: moved Intel microcode patch loader declarations to seperate header file
      x86: typedef removal
      x86: move per CPU microcode structure declaration to header file
      x86: move microcode.c to microcode_intel.c
      x86: code split to two parts
      x86: structure declaration renaming
      x86: add AMD specific declarations
      x86: first step of refactoring, introducing microcode_ops
      x86: major refactoring
      x86: AMD microcode patch loading support
      x86: AMD microcode patch loader style corrections
      x86: Intel microcode patch loader style corrections
      x86: moved function declarations out from AMD microcode patch loader to heade file
      x86: minor pointer type cast in AMD microcode patch loader
      x86: Microcode patch loader style corrections
      x86: Fixed NULL function pointer dereference in AMD microcode patch loader.
      x86, microcode rework, v2, renaming
      x86, microcode rework, v2, renaming cont.
      x86: microcode patch loader bugfix

Petr Tesarik (1):
      x86, tracehook: clean up implementation of syscall_get_error()

Philipp Kohlbecher (1):
      x86: fix comment in protected mode header

Prarit Bhargava (1):
      x86, pci: iommu fix potential overflow in alloc_iommu()

Randy Dunlap (3):
      documentation: move hpet.txt to timers/ subdirectory
      documentation: move mtrr.txt to Doc/x86/ subdir
      x86, microcode_amd: fix shift warning

Rene Herman (3):
      x86: {reverve,free}_memtype() take a physical address
      x86: have set_memory_array_{uc,wb} coalesce memtypes.
      agp: enable optimized agp_alloc_pages methods

Robert Richter (25):
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: apic_*.c: add description to AMD's extended LVT functions
      x86/oprofile: introduce model specific init/exit functions
      x86/oprofile: Minor changes in op_model_athlon.c
      x86/oprofile: renaming athlon_*() into op_amd_*()
      drivers/oprofile: coding style fixes in buffer_sync.c
      OProfile: moving increment_tail() in buffer_sync.c
      OProfile: add IBS code macros
      x86/oprofile: separating the IBS handler
      OProfile: change IBS interrupt initialization
      OProfile: Fix build error in op_model_athlon.c
      OProfile: on_each_cpu(): kill unused retry parameter
      OProfile: fix setup_ibs_files() function interface
      OProfile: enable IBS for AMD CPUs
      OProfile: fix IBS build error for UP
      x86/oprofile: macro definition cleanup in op_model_athlon.c
      x86/oprofile: op_model_athlon.c: fix counter reset when reenabling IBS OP
      x86: apic: export symbols for extended interrupt LVT functions
      x86: apic: changing export symbols to *_GPL
      x86/oprofile: add CONFIG_OPROFILE_IBS option
      oprofile: fix printk in cpu_buffer.c
      x86/oprofile: reanaming op_model_athlon.c to op_model_amd.c
      x86/oprofile: fix on_each_cpu build error
      x86: cleanup in amd_cpu_notify()
      Revert "Oprofile Multiplexing Patch"

Roland McGrath (6):
      x86: tracehook_signal_handler
      x86: tracehook syscall
      x86: tracehook: asm/syscall.h
      x86 signals: use asm/syscall.h
      x86: tracehook: TIF_NOTIFY_RESUME
      x86: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

Russ Anderson (6):
      sysfs, x86, uv: Document files in /sys/firmware/sgi_uv/
      x86: trivial printk fix in efi.c
      x86: Add UV EFI table entry v4
      x86: Add UV bios call infrastructure v4
      x86: Add UV partition call v4
      x86: Add sysfs entries for UV v4

Shaohua Li (6):
      introduce two APIs for page attribute
      reduce tlb/cache flush times of agpgart memory allocation
      x86, pageattr: introduce APIs to change pageattr of a page array
      agp: generic_alloc_pages()
      agp: add agp_generic_destroy_pages()
      x86: fix pageattr-test

Sheng Yang (2):
      x86: move VMX MSRs to msr-index.h
      x86: extended "flags" to show virtualization HW feature in /proc/cpuinfo

Srinivasa Ds (2):
      signals: demultiplexing SIGTRAP signal
      signals: demultiplexing SIGTRAP signal, fix

Stephen Rothwell (1):
      linux-next: fix x86 tree build failure

Steven Noonan (2):
      x86: fix HPET compiler error when not using CONFIG_PCI_MSI
      x86: unused variable in dma_alloc_coherent_gfp_flags()

Suresh Siddha (71):
      x64, x2apic/intr-remap: Intel vt-d, IOMMU code reorganization
      x64, x2apic/intr-remap: fix the need for sequential array allocation of iommus
      x64, x2apic/intr-remap: code re-structuring, to be used by both DMA and Interrupt remapping
      x64, x2apic/intr-remap: use CONFIG_DMAR for DMA-remapping specific code
      x64, x2apic/intr-remap: Fix the need for RMRR in the DMA-remapping detection
      x64, x2apic/intr-remap: parse ioapic scope under vt-d structures
      x64, x2apic/intr-remap: move IOMMU_WAIT_OP() macro to intel-iommu.h
      x64, x2apic/intr-remap: Queued invalidation infrastructure (part of VT-d)
      x64, x2apic/intr-remap: Interrupt remapping infrastructure
      x64, x2apic/intr-remap: routines managing Interrupt remapping table entries.
      x64, x2apic/intr-remap: generic irq migration support from process context
      x64, x2apic/intr-remap: 8259 specific mask/unmask routines
      x64, x2apic/intr-remap: ioapic routines which deal with initial io-apic RTE setup
      x64, x2apic/intr-remap: introduce read_apic_id() to genapic routines
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support, fix
      x64, x2apic/intr-remap: basic apic ops support
      x64, x2apic/intr-remap: cpuid bits for x2apic feature
      x64, x2apic/intr-remap: disable DMA-remapping if Interrupt-remapping is detected (temporary quirk)
      x64, x2apic/intr-remap: x2apic ops for x2apic mode support
      x64, x2apic/intr-remap: introcude self IPI to genapic routines
      x64, x2apic/intr-remap: x2apic cluster mode support
      x64, x2apic/intr-remap: setup init_apic_ldr for UV
      x64, x2apic/intr-remap: IO-APIC support for interrupt-remapping
      x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
      x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping
      x64, x2apic/intr-remap: support for x2apic physical mode support
      x64, x2apic/intr-remap: introduce CONFIG_INTR_REMAP
      x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
      x2apic: uninline uv_init_apic_ldr()
      x2apic: xen64 paravirt basic apic ops
      x2apic: kernel-parameter documentation for "x2apic_phys"
      x86: let 32bit use apic_ops too - fix
      x86: apic_ops for lguest
      x86: APIC: Remove apic_write_around(); use alternatives, merge fix
      x64, apic: use generic apic_write() for ack_APIC_irq()
      x86, xsave: xsave cpuid feature bits
      x86, xsave: enable xsave/xrstor on cpus with xsave support
      x86, xsave: context switch support using xsave/xrstor
      x86, xsave: dynamically allocate sigframes fpstate instead of static allocation
      x86, xsave: reorganization of signal save/restore fpstate code layout
      x86, xsave: xsave/xrstor specific routines
      x86, xsave: struct _fpstate extensions to include extended state information
      x86, xsave: save/restore the extended state context in sigframe
      x86, xsave: update xsave header bits during ptrace fpregs set
      x86, xsave: remove the redundant access_ok() in setup_rt_frame()
      x86, xsave: clear the user buffer before doing fxsave/xsave
      x86, xsave: use BUG_ON() instead of BUILD_BUG_ON()
      sparseirq: fix intr-remap with dyn_array/nr_irqs changes]
      x86: use cpuid vector 0xb when available for detecting cpu topology
      x86: use x2apic id reported by cpuid during topology discovery
      x86: use x2apic id reported by cpuid during topology discovery, fix
      x86: xsave: restore xcr0 during resume
      dmar: use list_for_each_entry_safe() in dmar_dev_scope_init()
      dmar: fix dmar_parse_dev() devices_cnt error condition check
      x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
      x86, cpa: remove USER permission from the very early identity mapping attribute
      x86, cpa: make the kernel physical mapping initialization a two pass sequence
      x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
      x86, cpa: fix taking the pgd_lock with interrupts off
      x86, cpa: remove cpa pool code
      x86, cpa: global flush tlb after splitting large page and before doing cpa
      x86: track memtype for RAM in page struct
      x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
      x86, cpa: remove USER permission from the very early identity mapping attribute
      x86, cpa: make the kernel physical mapping initialization a two pass sequence
      x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
      x86, cpa: no need to check alias for __set_pages_p/__set_pages_np
      x86, cpa: remove cpa pool code
      x86, cpa: srlz cpa(), global flush tlb after splitting big page and before doing cpa
      x86: track memtype for RAM in page struct
      x86: fix pagetable init 64-bit breakage

Thomas Gleixner (8):
      genirq: remove last NO_IDLE_HZ leftovers
      x86: TSC: define the PIT latch value separate
      x86: TSC: separate hpet/pmtimer calculation out
      x86: TSC: use one set of reference variables
      x86: TSC make the calibration loop smarter
      x86: improve UP kernel when CPU-hotplug and SMP is enabled
      x86: remove additional_cpus
      AMD IOMMU: use iommu_device_max_index, fix

Thomas Petazzoni (3):
      x86: make movsl_mask definition non-CPU specific
      x86: move cmpxchg fallbacks to a generic place
      x86: configuration options to compile out x86 CPU support code

Tim Bird (1):
      x86, bootup: add built-in kernel command line for x86 (v2)

Uros Bizjak (1):
      x86, cleanup: use X86_CR4_PGE in x86/power/hibernate_asm_32.S

Uwe Kleine-König (1):
      x86, debug: gpio_free might sleep

Vegard Nossum (5):
      x86: fix spurious '#' in kvm header
      x86: consolidate header guards
      x86: consolidate header guards
      x86: add memory clobber in switch_to()
      x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y, v2

Venkatesh Pallipadi (1):
      x86: handle error returns in set_memory_*()

Venki Pallipadi (3):
      x86: have set_memory_array_{uc,wb} coalesce memtypes, fix
      x86: using HPET in MSI mode and setting up per CPU HPET timers, fix
      hpet: clean up warning

Yinghai Lu (190):
      x86: let 32bit use apic_ops too
      x86: mach_apicdef.h need to include before smp.h
      x86: make read_apic_id return final apicid
      x86: make 64bit have get_apic_id
      x86: let 32bit use apic_ops too - fix
      x86: add apic probe for genapic 64bit, v2
      x86: move declaring x2apic_extra_bits
      usb: move ehci reg def
      x86: usb debug port early console, v4
      x86: add setup_ioapic_ids for numaq in x86_quirks
      x86: mach-bigsmp to bigsmp
      x86: mach_es7000 to es7000
      x86: mach_summit to summit
      x86: mach-numaq to numaq
      x86: add apic probe for genapic 64bit - fix
      x86: print per_cpu data address
      x86: apic - unify lapic_resume - fix
      x86: add after_bootmem flag for 32bit
      x86: remove irq_vectors_limits
      generic: add dyn_array support
      add per_cpu_dyn_array support
      x86: alloc dyn_array all together
      x86: enable dyn_array support
      irq: introduce nr_irqs
      x86: use nr_irqs
      drivers/char: use nr_irqs
      drivers/net: use nr_irqs
      drivers/pci/ intr remapping: use nr_irqs
      drivers/pcmcia: use nr_irqs
      drivers/rtc: use nr_irqs
      drivers/scsi: use nr_irqs
      drivers/serial: use nr_irqs
      fs/proc: use nr_irqs
      drivers/xen: use nr_irqs
      irqs: make irq_timer_state to use dyn_array
      irq: make irq2_iommu to use dyn_array
      irq: make irq_desc to use dyn_array
      irq: make irqs in kernel stat use per_cpu_dyn_array
      x86: use dyn_array in io_apic_xx.c
      x86, irq: get nr_irqs from madt
      x86: remove nr_irq_vectors
      generic: sparse irqs: use irq_desc() together with dyn_array, instead of irq_desc[]
      x86: add irq_cfg in io_apic_64.c
      x86: put irq_2_pin pointer into irq_cfg
      x86: put timer_rand_state pointer into irq_desc
      x86: move kstat_irqs from kstat to irq_desc
      irq: add irq_desc_without_new
      irq: replace loop with nr_irqs with for_each_irq_desc
      irq, fs/proc: replace loop with nr_irqs for proc/stat
      x86, ioapic: replace loop with nr_irqs with for_each_irq_icfg
      irq: remove >= nr_irqs checking with config_have_sparse_irq
      generic: add irq_desc in function in parameter
      x86: check with without_new in show_interrupts
      x86_64: rename irq_desc/irq_desc_alloc
      irq: separate sparse_irqs from sparse_irqs_free
      x86_64: separate irq_cfgx from irq_cfgx_free
      x86_64: make /proc/interrupts work with dyn irq_desc
      x86: put irq_2_iommu pointer into irq_desc
      x86: use 28 bits irq NR for pci msi/msix and ht
      x86: remove irqbalance in kernel for 32 bit
      x86: add irq_cfg for 32bit
      x86: make 32bit use irq_cfg_alloc, etc
      x86: make 32bit to use irq_2_pin in irq_cfg
      x86: make 32 bit to use sparse_irq
      x86: make 32bit support per_cpu vector
      x86: add debug info for 32bit sparse_irq
      x86, io-apic: remove union about dest for log/phy
      x86: ordering functions in io_apic_32.c
      x86: ordering functions in io_apic_64.c
      x86: order variables in io_apic_xx.c
      x86: make headers files the same in io_apic_xx.c
      x86: make 64 handle sis_apic_bug like the 32 bit
      x86: remove ioapic_force
      x86: make io_apic_64.c and io_apic_32.c the same
      rename io_apic_64.c and io_apic_32.c to io_apic.c
      io_apic: make 32 bit have io_apic resource in /proc/iomem
      pci: change msi-x vector to 32bit
      x86: irq: interrupt array size should be NR_VECTORS
      x86: unify mask_IO_APIC_irq
      x86: unify ack_apic_edge
      x86: remove first_free_entry/pin_map_size
      x86: print local APIC of APs one by one
      x86: make HAVE_SPARSE_IRQ support selectable
      x86: probe nr_irqs even only mptable is used
      dyn_array: split dyn_array functions from init/main.c
      x86: fix apic version warning
      x86: sparse_irq needs spin_lock in allocations
      x86: fix 32-bit ioapic lockup with sparseirqs
      x86: fix probe_nr_irqs for xen
      x86_64: printout msr -v2
      x86: apic_xx.c order variables
      x86: use HAVE_X2APIC in apic_64.c
      x86: add hard_smp_prossor_id with MACRO in io_apic_xx.c
      x86: make apic_32/64.c more like
      x86: merge APIC_init_uniprocessor
      x86: copy detect_init_APIC to the other
      x86: merge header files in apic_xx.c
      x86: apic unify smp_spurious/error_interrupt
      x86: apic copy calibrate_APIC_clock to each other in apic_32/64.c
      x86: apic copy apic_64.c to apic_32.c
      x86: rename apic_32.c and apic_64.c to apic.c
      x86: let 64 bit to use 32 bit calibrate_apic_clock
      sparseirq: move kstat_irqs from kstat to irq_desc - fix
      x2apic: fix reserved APIC register accesses in print_local_APIC()
      dmar: fix using early fixmap mapping for DMAR table parsing
      dmar: initialize the return value in dmar_parse_dev()
      x86: move dir es7000 to es7000_32.c
      x86: split e820 reserved entries record to late v2
      x86: print out if acpi want physical flat of all
      dyn_array: fix typo
      pci: fix BAR print out
      IO resources: add reserve_region_with_split()
      x86: split e820 reserved entries record to late, v7
      x86: unify using pci_mmcfg_insert_resource
      x86: move mtrr cpu cap setting early in early_init_xxxx
      x86: make (early)_identify_cpu more the same between 32bit and 64 bit
      x86: order functions in cpu/common.c and cpu/common_64.c v2
      x86: remove cpu_vendor_dev
      x86: make 32bit support show_msr like 64 bit
      x86: make get_mode_name of 64bit the same as 32bit
      x86: move 32bit related functions together
      x86: make detect_ht depend on CONFIG_X86_HT
      x86: make header file the same in arch/x86/kernel/cpu/common_xx.c
      x86: same gdt_page with macro
      x86: cpu/common.c, let 64-bit code have 32-bit only functions
      x86: cpu/common*.c, make 32-bit have 64-bit only functions
      x86: cpu/common*.c have same cpu_init(), with copying and #ifdef
      x86: cpu/common*.c, merge switch_to_new_gdt()
      x86: cpu/common.c, merge default_init()
      x86: cpu/common*.c, merge display_cacheinfo()
      x86: cpu/common*.c, merge detect_ht()
      x86: cpu/common.c: merge get_cpu_cap()
      x86: cpu/common*.c, merge early_identify_cpu()
      x86: cpu/common*.c: merge print_cpu_info()
      x86: cpu/common*.c, merge generic_identify()
      x86: cpu/common*.c, merge identify_cpu()
      x86: use cpu/common.c on 64 bit
      x86: move nonx_setup etc from common.c to init_64.c
      irq: error missed ifndef CONFIG_HAVE_SPARSE_IRQ, v2
      x86: remove duplicated get_model_name() calling
      x86, cpu init: call early_init_xxx in init_xxx
      dyn_array: remove one panic
      x86: cpu make amd.c more like amd_64.c v2
      x86: remove duplicated force_mwait
      x86: add srat_detect_node for amd64
      x86: merge header in amd_64.c
      x86: make amd.c have 64bit support code
      x86: make amd_64 have 32 bit code
      x86: make 64 bit to use amd.c
      x86: lapic address print out like io apic addr
      x86: little clean up of intel.c/intel_64.c
      x86: make intel.c have 64-bit support code
      x86: make intel_64.c the same as intel.c
      x86: let intel 64-bit use intel.c
      x86: intel.c put workaround for old cpus together
      x86: centaur_64.c remove duplicated setting of CONSTANT_TSC
      x86: rename discontig_32.c to numa_32.c
      x86: print out apic id in hex format
      dyn_array: use %pF instead of print_fn_descriptor_symbol
      x86: change early_ioremap to use slots instead of nesting
      acpi/x86: introduce __apci_map_table, v4
      x86: check dsdt before find oem table for es7000, v2
      x86: identify_cpu_without_cpuid v2
      x86: move transmeta cap read to early_init_transmeta()
      irq: fix irqpoll && sparseirq
      x86: fix arch/x86/kernel/cpu/mtrr/main.c warning
      sparseirq: remove some debug print out
      x86: fix CONFIG_X86_RESERVE_LOW_64K=y
      x86: cpu don't print duplicated vendor string
      x86: use WARN_ONCE in workaround for mtrr mask
      x86: fix macro with bad_bios_dmi_table
      x86/pci: fix dmar_tbl early_ioremap leak v2
      x86: fix typo in irq_desc array
      x86: irq no should not use hex in /proc/interrupts
      x86: don't need to go to chunksize to 4G
      x86: mtrr_cleanup optimization, v2
      x86: add mtrr_cleanup_debug command line
      x86: cleanup, remove extra ifdef
      x86: print out irq nr for msi/ht, v3
      x86: mtrr_cleanup hole size should be less than half of chunk_size, v2
      x86: mtrr_cleanup safe to get more spare regs now
      x86: mtrr_cleanup prepare to make gran_size to less 1M
      x86: mtrr_cleanup try gran_size to less than 1M
      x86: change MTRR_SANITIZER to def_bool y
      x86: mtrr_cleanup try gran_size to less than 1M, v3
      x86, debug: mtrr_cleanup print out var mtrr before change it
      x86: mtrr_cleanup: print out correct type v2
      x86: mtrr_cleanup: first 1M may be covered in var mtrrs
      x86: mtrr_cleanup: treat WRPROT as UNCACHEABLE
      acpi/x86: introduce __apci_map_table, v4

dcg (1):
      x86_64: be less annoying on boot, v2

venkatesh.pallipadi@intel.com (5):
      x86: PAT documentation updates with debug info
      x86: HPET_MSI change IRQ affinity in process context when it is disabled
      x86: HPET_MSI Refactor code in preparation for HPET_MSI
      x86: HPET_MSI Basic HPET_MSI setup code
      x86: HPET_MSI Initialise per-cpu HPET timers

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYAUUPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYAUUPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYAUUPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:15:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYAUUO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:14:58 -0500
Date: Mon, 21 Jan 2008 21:14:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: what's up for v2.6.25 in x86.git
Message-ID: <20080121201437.GA31469@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


What's up for v2.6.25 for the x86 architecture code.

There are 763 commits in x86.git so far, from more than 90 contributors, 
so it would be difficult to mention and credit every contribution in 
this mail. See the shortlog attached further below for more details.

Here's an (incomplete) list of highlights:

 - Continued, intense arch/x86 unification and cleanup work by lots of
   people. (Harvey Harrison, Cyrill Gorcunov, Sam Ravnborg, Pavel
   Machek, Hiroshi Shimamoto, Julia Lawall, Chris Wright and many
   others)

 - FIFO ticket spinlocks for better spinlock scalability (Nick Piggin)

 - "regset" generalizations - the most important step towards utrace 
   support (==next-gen ptrace). (Roland McGrath)

 - support for more than 255 CPUs [up to 4096 - in theory up to 65535] 
   (Nick Piggin, Mike Travis)

 - almost complete 64-bit paravirt guest support :-) (Glauber de
   Oliveira Costa and Jeremy Fitzhardinge).

 - KGDB support on x86, finally! (Jason Wessel and others)

 - percpu infrastructure improvements and cleanups (Mike Travis)

 - PIE executable and brk randomization (Jiri Kosina)

 - VDSO improvements and cleanups (Roland McGrath)

 - branch-trace-store hardware support for ptrace (Markus Metzger)

 - kprobes improvements (Masami Hiramatsu, Harvey Harrison, Abhishek 
   Sagar and others)

 - continued "transform inb_p() uses safely" work (Alan Cox)

 - TLB flushing optimizations for lower power cosumption (Venki 
   Pallipadi)

 - next-gen platform enablement work and fixes (Yinghai Lu)

 - change_page_attr() API fixes and improvements (Andi Kleen)

 - CPU feature bits cleanups and improvements (Andi Kleen)

 - various fixes (Jan Beulich)

 - EFI support (Ying Huang)

 - updated x86 setup code (H. Peter Anvin)

 - more reliable sched_clock() (Guillaume Chazarain)

 - RDC R-321x SoC subarchitecture support (Florian Fainelli)

 - HPET improvements (Balaji Rao)

 - assorted fixlets that kept the arch/x86 ball rolling smoothly in -mm
   (Andrew Morton)

PAT support (and clflush and GBPAGES support) are probably v2.6.26 
items. But even without those we've got enough changes:

   630 files changed, 39784 insertions(+), 35850 deletions(-)

	Ingo

--------------------->
Aaron Durbin (1):
      x86_64: add ACPI reboot option

Abhishek Sagar (2):
      x86: kprobes change kprobe_handler flow
      x86: fix singlestep handling in reenter_kprobe

Adrian Bunk (8):
      x86: unexport __{read,write}_lock_failed
      x86 e820_64.c: make 2 functions static
      x86 mce_64.c: make struct mcelog static
      x86: nmi_64.c: make code static
      x86: pci-calgary_64.c: make a variable static
      x86: pci-dma_64.c: cleanups
      i386: remove -maccumulate-outgoing-args
      x86: default to PCI=y

Alan Cox (2):
      x86: isolate PIC/PIT in/out calls
      serverworks: IRQ routing needs no _p

Ananth N Mavinakayanahalli (1):
      Kprobes: Add kprobes smoke tests that run on boot

Andi Kleen (59):
      x86: untable __init references between IO data
      x86: make ptrace.h safe to include from assembler code
      x86: Implement support to synchronize RDTSC through MFENCE on AMD CPUs
      x86: Implement support to synchronize RDTSC with LFENCE on Intel CPUs
      x86: Move nop declarations into separate include file
      x86: introduce rdtsc_barrier()
      x86: remove get_cycles_sync
      x86: export native_read_tsc
      x86: remove the now unused X86_FEATURE_SYNC_RDTSC
      x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection
      x86: allow TSC clock source on AMD Fam10h and some cleanup
      x86: Remove explicit C3 TSC check on 64bit
      x86: Don't disable TSC in any C states on AMD Fam10h
      clocksource: make clocksource watchdog cycle through online CPUs
      genirq: turn irq debugging options into module params
      Add /proc/irq/*/spurious to dump the spurious irq debugging state
      Remove CPU capabitilites printks on i386
      Document fdimage/isoimage completely in make help
      Compile apm and voyager module only when selected in Kconfig
      i386: Set CFQ as default in i386 defconfig
      x86: mark memory_setup __init
      x86: cpa: use wbinvd() macro instead of inline assembly in 64bit c_p_a()
      x86: cpa: remove unnecessary masking of address
      x86: clean up pte_exec
      x86: add pte accessors for the global bit
      x86: c_p_a(): implement change_page_attr_addr entry point on 32-bit
      x86: c_p_a(), handle 4K split pages at boot on 64bit
      x86: shrink __PAGE_KERNEL/__PAGE_KERNEL_EXEC on non PAE kernels
      c_p_a(): do a simple self test at boot
      x86: add pte_pgprot to 32-bit
      x86: don't drop NX bit in pte modifier functions on 32-bit
      x86: c_p_a(), add simple self test at boot
      x86: fix c_p_a() boot crash
      x86: c_p_a(), change kernel_map_pages to not use c_p_a()
      x86: c_p_a(), change 32-bit back to init_mm semaphore locking
      x86: c_p_a(), use macros to modify the PG_arch_1 page flags in change_page_attr
      x86: c_p_a() fix: reorder TLB / cache flushes to follow Intel recommendation
      x86: c_p_a() make it more robust against use of PAT bits
      x86: c_p_a() fix inaccurate comment in 64-bit change_page_attr()
      x86: c_p_a(), only unmap kernel init pages in text mapping when CONFIG_DEBUG_RODATA is set
      x86: c_p_a(), fix reference counting when changing already changed pages
      x86: c_p_a(): change comments of external interfaces to kerneldoc format
      x86: c_p_a(): add a BUG_ON() checking for someone setting the kernel text NX
      x86: remove set_kernel_exec()
      i386: Move MWAIT idle check to generic CPU initialization
      Use the correct cpuid method to detect MWAIT support for C states
      Use shorter addresses in i386 segfault printks
      x86: replace hard coded reservations in 64-bit early boot code with dynamic table
      Optimize lock prefix switching to run less frequently v2
      Don't disable the APIC if it hasn't been mapped yet
      Print which shared library/executable faulted in segfault etc. messages v3
      x86: implement MTRR check on AMD systems with > 4GB RAM
      x86: fix early_ioremap() on 64-bit
      Add frame work to disable CPUID bits on the command line
      Convert some existing cpuid disable options to new generic bitmap
      Don't disable RDTSC in userland for 32bit notsc
      Convert TSC disabling to generic cpuid disable bitmap
      x86: add noclflush option
      Add generic clearcpuid=... option

Andreas Herrmann (1):
      x86: fix detection of CONSTANT_TSC bit for AMD CPUs

Andres Salomon (1):
      x86: GEODE: update GPIO API to support setting multiple GPIOs at once

Andrew Morton (11):
      x86: kmap_atomic() debugging
      pie-executable-randomization-checkpatch-fixes
      pie-executable-randomization-uninlining
      git-x86: __vdso_getcpu() warning fix
      git-x86: fix allnoconfig build
      arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
      arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes-checkpatch-fixes
      git-x86: arch/x86/math-emu/errors.c: fix printk warnings
      git-x86: drivers/pnp/pnpbios/bioscalls.c build fix
      arch/x86/mm/numa_64.c: section fix
      x86, 32-bit: trim memory not covered by wb mtrrs, fix

Arjan van de Ven (11):
      move WARN_ON() out of line
      Add the end-of-trace marker and the module list to
      x86: fix 32-bit FRAME_POINTER chasing code
      x86: add the capability to print fuzzy backtraces
      x86: improve the 32 bit Frame Pointer backtracer to also use the traditional backtrace
      x86: pull bp calculation earlier into the backtrace path
      x86: turn 64 bit x86 HANDLE_STACK into print_context_stack like 32 bit has
      x86: use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
      x86: add a simple backtrace test module
      x86: add the "print code before the trapping instruction" feature to 64 bit
      small bug in x86 git tree

Atsushi Nemoto (1):
      clocksource: Make CLOCKSOURCE_MASK bullet-proof

Avi Kivity (1):
      KVM, x86: add dummy Makefile and Kconfig wiring

Balaji Rao (2):
      x86: assign IRQs to HPET timers
      x86: assign IRQs to HPET timers, fix

Benjamin LaHaise (1):
      synchronize_rcu(): high latency on idle system

Bernhard Kaindl (1):
      x86: early boot debugging via FireWire (ohci1394_dma=early)

Bernhard Walle (1):
      x86: remove extern declarations for code, data, bss resources

Borislav Petkov (1):
      x86: vmlinux_32.lds.S: remove repeated comment from the x86-32 linker script

Carlos R. Mafra (2):
      x86: fix style errors in nmi_int.c
      x86: Clean up k8topology.c

Chris Wright (2):
      x86: fix ioport unification on 32-bit
      x86: refactor ioport unification

Christoph Lameter (1):
      x86: 64-bit, make sparsemem vmemmap the only memory model

Cyrill Gorcunov (5):
      x86: remove dead code in ia32-emu
      x86: clean up include/asm-x86/pda.h
      x86: cleanup i387_32.c according to checkpatch
      x86: coding style cleanup for kernel/bootflag.c
      x86: get rid of checkpatch.pl complains on apm_32.c

Daniel Walker (1):
      mcheck mce_64: mce_read_sem to mutex

Dave Jones (2):
      Remove more bogus filenames in comments.
      Use CR0 defines.

Dmitri Vorobiev (1):
      x86_32: remove the useless NR_syscalls macro

Eric Dumazet (1):
      i386 : Make arch/x86/kernel/acpi/wakeup_32.S use a separate

Florian Fainelli (4):
      x86: Add generic GPIO support to x86
      pci: Add PCI identifiers for the RDC devices
      x86: Add support for the RDC R-321x SoC
      x86: Add the RDC machine specific reboot fixup

Gary Hade (1):
      PCI: remove default PCI expansion ROM memory allocation

Geert Uytterhoeven (1):
      time: fold __get_realtime_clock_ts() into getnstimeofday()

Glauber de Oliveira Costa (98):
      irqflags consolidation
      x86: consolidate spinlock.h
      Wipe out traditional opt from x86_64 Makefile
      unify msr smp funcs
      allow sched clock to be overridden by paravirt
      split get_cycles_sync
      unify cpuid functions
      introduce native_read_tscp
      change rdpmc interface
      change write msr functions interface
      make fixups wordsize agnostic
      integrate i386 and x86_64 code in msr.h
      remove volatile keyword from clflush.
      put together equal pieces of system.h
      unify load_segment macro
      unify paravirt parts of system.h
      remove unused macro
      unify smp parts of system.h
      move switch_to macro to system.h
      unify system.h
      put get_kernel_rpl in a common location
      unify common parts of segment.h
      remove arch specific segment headers
      export math_state_restore
      export cpu_gdt_descr
      turn priviled operation into a macro in head_64.S
      prepare time related functions for paravirt
      tweak io_64.h for paravirt.
      prepare x86_64 architecture initialization for paravirt
      unify desc_struct
      unify struct desc_ptr
      change gdt acessor macro name
      removed unused variable
      introduce gate_desc type.
      change write_idt_entry signature
      introduce ldt_desc type.
      modify write_ldt function
      introduce fill_ldt
      provide tss_desc
      change write_gdt_entry signature.
      change write_ldt_entry signature
      move constants to desc_defs.h
      unify non-paravirt parts of desc.h
      use the same data type for tls_array.
      modify get_desc_base
      unify paravirt pieces of descriptor handling
      move _set_gate and its users to a common location
      unify set_tss_desc
      x86: avoid ifdefs in desc.h, getting rid of pack_ldt and pack_tss
      move tsc definitions to were they belong
      get rid of _MASK flags
      move desc_empty to where they belong
      move load_cr3 to a common place.
      unify paravirt pieces of processor.h
      move the definition of set_iopl_mask to common header
      unify common parts of processor.h
      unify current_text_addr
      unify tss_struct
      provide x86_64 with a load_sp0 function.
      unify thread struct.
      unify TASK_ALIGN definitions
      change bitwise operations to get a void parameter.
      unify x86_cpuinfo struct.
      remove legacy stuff from processor_64.h
      unify mm_segment_t definition
      move definitions to processor.h
      unify prefetch operations
      unify asm nops
      move i387 definitions to processor.h
      x86: remove __init modifier from header declaration
      finish processor.h integration
      change paravirt_32.c name
      adjust PVOP_CALL/VCALL macros for x86_64
      cleanup write_tsc
      provide paravirtualized hook for rdtscp
      change assembly definition of paravirt_patch_site
      adjust assembly macros to x86_64 as well.
      change irq functions to accomodate x86_64
      add macro for privileged x86_64 operation
      adds paravirt hook for swapgs
      replace privileged instructions with paravirt macros
      cleanup CLI_STRING, STI_STRING and friends
      add CLBR_ defines for x86_64.
      move patching code to arch-specific file.
      x86_64 patching functions
      replace x86_read/write_per_cpu with a common function.
      add missing parameter for lookup_address
      add stringify header
      provide a native_init_IRQ function to x86_64
      put generic mm_hooks include into PARAVIRT
      puts read and write cr8 into pv_cpu_ops
      provide read and write cr8 paravirt hooks
      fill pv_cpu_ops structure with cr8 fields
      add asm_offset PARAVIRT constants
      provide __parainstructions section
      change function orders in paravirt.h
      x86: export check_tsc_unstable
      x86: export __supported_pte_mask

Guillaume Chazarain (1):
      x86: scale cyc_2_nsec according to CPU frequency

H. Peter Anvin (21):
      x86: add <asm/asm.h>
      x86: unify asm/cpufeature.h
      x86: prepare merger of <asm/alternative_{32,64}.h>
      x86: actually merge <asm/alternative.h>
      x86: rename the struct pt_regs members for 32/64-bit consistency
      x86: Use generic register names in struct user_regs_struct
      x86: use generic register names in struct sigcontext
      x86: use generic register name in the thread and tss structures
      i386: handle an initrd in highmem (version 2)
      x86: <asm/segment.h>: boot GDT entries are 32/64-independent
      x86 setup: make PM transition more paranoid; cleanup 32-bit entry
      x86 setup: initialize LDTR and TR to make life easier to Intel VT
      x86 setup: use X86_CR0_PE macro instead of hard-coded constant
      x86 setup: display VESA graphics modes in vga=ask menu
      x86 setup: fix constraints in segment accessor functions
      x86 setup: OK -> ok (no need to scream)
      x86 setup: add missing prototype; formatting fix
      x86 setup: add note to use edd=off on EDD probing hangs
      x86 setup: push video mode setup as late as possible
      x86 setup: guard the heap against invalid stack setups
      x86 setup: correct the base in the GDT_ENTRY() macro

Harvey Harrison (48):
      x86: Use def_bool where possible
      x86: Use def_bool where possible in Kconfig.cpu
      x86: Unify include/asm-x86/linkage_[32|64].h
      x86: unify mmap_{32|64}.c
      UML: Remove remaining FASTCALL uses
      x86: Remove last users of FASTCALL
      Remove last users of empty FASTCALL macro
      x86: Remove all definitions with fastcall
      x86: remove fastcall from include/asm-x86
      x86: clean up local_{32|64}.h
      x86: fix asm memory constraints in local_64.h
      x86: Introduce asm helpers in local_{32|64}.h
      x86: Unify local_{32|64}.h
      x86: local.h fix checkpatch warnings
      x86: unify kexec_{32|64}.h
      x86: unify extable_{32|64}.c
      x86: use helper in fault_64.c
      x86: kprobes leftover cleanups
      x86: unify module_{32|64}.h
      x86: add reenter_kprobe helper
      x86: Introduce REX prefix helper for kprobes
      x86: kprobes remove fix_riprel #ifdef
      x86: Cosmetic fixes fault_{32|64}.c
      x86: kprobes change kprobe_handler flow
      x86: fault_32.c cleanup
      x86: begin fault_{32|64}.c unification
      x86: introduce force_sig_info_fault helper to X86_64
      x86: Introduce __die helper to X86_32
      x86: More users of PF_ constants in fault_32|64.c
      x86: Use fixup_exception() in traps_64.c
      x86: Move get_segment_eip() to step.c
      x86: trivial whitespace in kprobes.c
      x86: Use wrmsrl in kprobes.c, step.c
      x86: common x86_32|64 naming
      x86: Remove last user of get_segment_eip
      x86: do_page_fault small unification
      x86: Last of trivial fault_32|64.c unification
      x86: Function ifdefs in fault_32|64.c
      x86: add dump_pagetable helper to X86_32
      x86: unify pt_regs accessors ptrace.h
      x86: Cleanup ptrace.h
      x86: Rename stack_pointer to kernel_trap_sp
      x86: add is_f00f_bug helper to fault_32|64.c
      x86: add is_errata100 helper to fault_32|64.c
      x86: unify printk strings in fault_32|64.c
      x86: Use v8086_mode helper, trivial unification
      x86: add vdso32-int80-syms.lds to .gitignore
      x86: update reliability argument to printk_address

Hiroshi Shimamoto (10):
      x86: enable irq in default_idle on 64-bit
      x86: io_apic_64.c: remove unused config check
      x86: clean up nmi_32/64.c
      x86: clean up process_32/64.c
      x86: clean up apic_32/64.c
      x86: clean up apic_32.c, take 2
      x86: move out tick_nohz_stop_sched_tick() call from the loop
      x86: kdump failure
      x86: move warning message of polling idle and HT enabled
      x86_64: move select_idle_routine() call after detect_ht()

Huang, Ying (10):
      x86_64 EFI runtime service support: EFI basic runtime service support
      x86_64 EFI runtime service support: EFI runtime services
      x86_64 EFI runtime service support: document for EFI runtime services
      x86_64 EFI runtime service support: remove duplicated code from efi_32.c
      x86 boot: use E820 memory map on EFI 32 platform
      i386 EFI runtime service support: fixes in sync with x86_64 support
      x86 boot : export boot_params via debugfs for debugging
      i386 boot: replace boot_ioremap with enhanced bt_ioremap - enhance bt_ioremap
      x86: replace boot_ioremap() with enhanced bt_ioremap() - remove boot_ioremap()
      x86 32-bit boot: rename bt_ioremap() to early_ioremap()

Ingo Molnar (81):
      x86: various changes and cleanups to in_p/out_p delay details
      x86: make io_delay=0xed the default
      x86: add DMI quirk for io-delay hangs on Compaq Presario V6000 laptops
      x86: idle wakeup event in the HLT loop
      x86: clean up arch/x86/mm/pageattr_32.c
      x86: clean up arch/x86/mm/pageattr_64.c
      x86: clean up arch/x86/kernel/aperture_64.c
      x86: clean up arch/x86/kernel/aperture_64.c printk()s
      x86: mach-voyager, lindent
      x86: lindent arch/i386/math-emu
      x86: lindent arch/i386/math-emu, cleanup
      x86: code cleanups in arch/x86/kernel/pci-gart_64.c
      x86: fix acpi.h build warning
      x86: clean up drivers/char/rtc.c
      x86: avoid build warning
      x86: dummy placeholder for acpi/reboot.h
      x86: replace outb_p() with udelay(2) in drivers/input/mouse/pc110pad.c
      x86: add some pirq debugging
      x86: remove unused include/asm-x86/processor_32/64.h
      x86: hlt on early crash
      x86: debug: double-check the empty zero page
      x86: lfence fix
      x86: move native_read_tsc() offline
      x86: map vsyscalls early enough
      x86: mark native_read_tsc() as __vsyscall_fn
      x86: read_tsc sync
      x86: remove get_cycles_sync(), fix
      x86: fix sched_clock()
      x86: page.h: move and unify types for pagetable entry, #1
      x86: page.h: move and unify types for pagetable entry, #2
      x86: page.h: move and unify types for pagetable entry, #3
      x86: page.h: move and unify types for pagetable entry, #4
      x86: page.h: move and unify types for pagetable entry, #5
      x86: page.h: move and unify types for pagetable entry, #6
      x86: kgdb Kconfig fix
      x86: kgdb build fix
      x86: clean up include/asm-x86/calling.h
      x86: offer is_hpet_enabled() on !CONFIG_HPET_TIMER too
      x86: clean up arch/x86/mm/fault_64.c
      x86: migration helpers for KVM
      x86: undo kvm changes
      x86: move all asm/pgtable constants into one place, fix
      x86/pgtable: fix constant sign extension problem
      x86/pgtable: unify pagetable accessors, #1
      x86/pgtable: unify pagetable accessors, #2
      x86/pgtable: unify pagetable accessors, #3
      x86/pgtable: unify pagetable accessors, #4
      x86/pgtable: unify pagetable accessors, #5
      x86: unify pgtable accessors which use, #2
      x86: fix pte_modify() bug
      x86: unify-pgtable.h, fix
      x86: fix UML and -regparm=3
      x86: warn about bad APIC calibration results
      x86: make clockevents more robust
      x86: make early printk selectable on 64-bit as well
      x86: smp_scan_config() debugging printouts
      x86: enhance early_ioremap()
      x86: increase the number of boot-mappings
      x86: add debug warnings to early_ioremap()
      x86: early_ioremap(), debugging
      x86: add early_ioremap() leak detection
      x86: pat: e820 cleanup
      x86: fix early_ioremap()/btmap
      x86: fix EISA ioremap
      x86: fix DMI ioremap leak
      x86: early fault debugging improvement
      x86: early_ioremap_init(), enhance warnings
      x86: percpu4-x86-change-nr-cpus-arrays-in-numa-64, fix
      x86: bios_ebda.h build fix
      x86: return the page table level in lookup_address()
      x86: clean up arch/x86/mm/pageattr-test.c
      x86: trim memory not covered by wb mtrrs, comment fixes
      x86: fix more non-global TLB flushes
      x86: provide read and write cr8 paravirt hooks, fix
      x86: add debug of invalid per_cpu map accesses
      x86: check_tsc_warp() slowness fix
      x86: add warning to check_tsc_warp()
      x86: fix up alternatives with lockdep enabled
      genirq: stackdump after the "Trying to free already-free IRQ" message
      x86: get_cycles() fix
      x86: clean up paging_init()

Jan Beulich (8):
      i386: hard_{en,dis}able_TSC can be static
      x86-64: make pda's cpunumber and nodenumber unsigned
      x86-64: honor notify_die() returning NOTIFY_STOP
      to .rodata/.init.data
      x86: make __{save,restore}_processor_state static
      x86: adjust enable_NMI_through_LVT0()
      x86: also define AT_VECTOR_SIZE_ARCH
      x86-64: clean up linker script

Jan Engelhardt (1):
      x86: remove unneded casts

Jason Wessel (8):
      kgdb: core-lite
      x86: kgdb, clocksource_watchdog
      x86: kgdb, softlockup
      x86: kgdb, 8250
      x86: kgdb, lite
      x86: kgdb, sysrq_bugfix
      x86: kgdb, modules
      x86: kgdb, asm_debug

Jeff Dike (2):
      UML - change sigcontext fields to match x86
      uml: add asm-um/asm.h

Jeremy Fitzhardinge (37):
      xen-mask-_page_pcd-from-ptes
      x86: partial unification of asm-x86/bitops.h
      x86: clean up bitops-related warnings
      x86: add set/clear_cpu_cap operations
      x86: kill mk_pte_huge
      x86: clean up mm/init_32.c
      x86: export native_read_tsc
      x86: page.h: unify constants
      x86: page.h: unify page copying and clearing
      x86: add _AT() macro to conditionally cast
      x86: page.h: move and unify types for pagetable entry
      x86: page.h: move pa and va related things
      x86: page.h: move remaining bits and pieces
      x86: page.h: move things back to their own files
      x86/efi: fix improper use of lvalue
      x86: move all asm/pgtable constants into one place
      x86: avoid name conflict for Voyager leave_mm
      x86/pgtable: unify pagetable accessors, #6
      x86: mask NX from pte_pfn
      x86: unify pgtable accessors which use
      x86: page.h: make pte_t a union to always include
      x86/vmi: fix compilation as a result of pte_t changes
      x86: pgtable: unify pte accessors
      x86: fix warning
      x86: unify zero_page definition
      x86: unify paravirt pagetable accessors
      xen: mask out PWT too
      adjust/fix LDT handling for Xen
      x86/pgtable: fix constant sign extension problem
      add native_pud_val and _pmd_val for 2 and 3
      x86/paravirt: rearrange common mmu_ops
      x86/paravirt: common implementation for pte value ops
      x86/paravirt: common implementation for pgd value ops
      x86/paravirt: common implementation for pmd value ops
      x86/paravirt: make set_pte operations common
      x86/paravirt: make set_pmd operation common
      x86/paravirt: make set_pud operation common

Jesse Barnes (1):
      x86, 32-bit: trim memory not covered by wb mtrrs

Jiri Kosina (2):
      x86: randomize brk
      PIE executable randomization

Joe Perches (1):
      arch/x86/: spelling fixes

Joerg Roedel (4):
      x86_64: define all _PAGE_* in terms of _PAGE_BIT_*
      x86_64: use __PAGE_KERNEL* instead of _KERNPG_TABLE
      x86_64: use __PAGE_KERNEL_EXEC in ioremap_64.c
      x86_64: some whitespace cleanups in paging code

John Reiser (1):
      STT_FUNC for assembler checksum and semaphore ops" in git-x86

Julia Lawall (3):
      arch/x86/ia32: Use time_before, time_before_eq, etc.
      arch/x86/kernel/apm_32.c: Use time_before, time_before_eq,
      arch/x86/kernel/io_apic_{64,32}.c: Use time_before,

Kyle McMartin (1):
      x86: 64-bit, remove redundant cpu_has_ definitions

Len Brown (1):
      x86: 32-bit IOAPIC: de-fang IRQ compression

Lucas Woods (1):
      x86: remove duplicate includes

Markus Metzger (10):
      x86, ptrace: support for branch trace store(BTS)
      x86, ptrace: remove bad comment
      x86, ptrace: use jiffies for BTS timestamps
      x86, ptrace: change BTS GET ptrace interface
      x86, ptrace: new ptrace BTS API
      x86, ptrace: rlimit BTS buffer allocation
      x86, ptrace: support 32bit-cross-64bit BTS recording
      x86, ptrace: add buffer size checks
      x86, ptrace: overflow signal API
      x86, ptrace: add bts_struct size to status command

Masami Hiramatsu (6):
      kprobe-booster for x86-64
      return probe-booster for x86-64
      prepare kprobes code for x86 unification
      kprobes code for x86 unification
      x86: fix kprobe_handler reenable preemption
      x86: move deeply indented code to reenter_kprobe

Mathieu Desnoyers (1):
      x86: fall back on interrupt disable in cmpxchg8b on 80386 and 80486

Mel Gorman (1):
      [Fwd: Re: iffy config]

Michael Opdenacker (1):
      x86: fix unconditional arch/x86/kernel/pcspeaker.o compiling

Miguel Boton (1):
      x86: reboot_{32|64}.c unification

Mike Galbraith (1):
      x86: fix: s2ram + P4 + tsc = annoyance

Mike Travis (3):
      prevent dereferencing non-allocated per_cpu variables
      x86: Reduce memory and intra-node effects with
      x86: Add config variables for SMP_MAX

Min Zhang (1):
      arch/x86/kernel/cpu/mcheck/p4.c: cleanups

Neil Horman (2):
      x86, kexec: force x86 arches to boot kdump kernels on boot cpu
      x86: clean up arch/x86/kernel/early-quirks.c

Nick Piggin (5):
      spinlock: lockbreak cleanup
      x86: FIFO ticket spinlocks
      x86: FIFO ticket spinlocks, fix
      mm: fix PageUptodate memory ordering bug
      x86: big ticket locks

Nikanth Karthikesan (1):
      x86: change x86 machine check handler to use unlocked_ioctl instead

Olof Johansson (1):
      Introduce __WARN()

Paolo Ciarrocchi (2):
      x86: coding style fixes in arch/x86/ia32/audit.c
      x86: coding style fixes in arch/x86/pci/fixup.c

Parag Warudkar (3):
      x86: fix DMI out of memory problems
      x86: fix dmi_alloc() to not advance alloc index in case of
      clocksource.c: use init_timer_deferrable for clocksource_watchdog

Paul Jimenez (2):
      x86: Make i8259_64 more _32-like
      x86: mtrr use type bool [RESEND AGAIN]

Pavel Machek (4):
      time: clean hungarian notation from timers
      time: timer cleanups
      time: more timer related cleanups
      Unify arch/x86/kernel/acpi/sleep*.c

Quentin Barnes (1):
      Code clarification patch to Kprobes arch code

Rafael J. Wysocki (1):
      x86: hibernation: document __save_processor_state() on x86

Ralf Baechle (1):
      mips, x86: optimize the i8259 code a bit

Randy Dunlap (4):
      x86: bitops_32.h style cleanups
      x64/page.h: convert some macros to inlines
      x86: gpio: fix build problem: gpio_keys
      x86: discover_ebda section mismatch

Rene Herman (1):
      x86: provide a DMI based port 0x80 I/O delay override.

Robert Richter (1):
      Extended interrupt LVT support for AMD Barcelona

Roland McGrath (105):
      x86: protect against sigaltstack wraparound
      x86 vDSO: generate vdso-syms.lds
      x86 vDSO: use vdso-syms.lds
      x86 vDSO: remove vdso-syms.o
      x86 vDSO: new layout
      x86 vDSO: harmonize asm-offsets
      x86 vDSO: arch/x86/vdso/vdso32
      x86 vDSO: vdso32 build
      x86 vDSO: i386 vdso32
      x86 vDSO: absolute relocs
      x86 vDSO: i386 vdso32 install
      x86 vDSO: vdso32 setup
      x86 vDSO: ia32_sysenter_target
      x86 vDSO: ia32 sysenter_return
      x86 vDSO: ia32 vdso32-syscall build
      x86 vDSO: consolidate vdso32
      x86 vDSO: ia32 vsyscall removal
      x86 vDSO: reorder vdso32 code
      x86 vDSO: i386 vdso32
      x86 vDSO: makefile cleanup
      x86 vDSO: canonicalize sysenter .eh_frame
      x86: fix vdso32 build error
      x86: get_desc_base
      x86: use get_desc_base
      x86: ptrace fs/gs_base
      x86: desc_empty
      x86: tls32 moved
      x86: TLS cleanup
      ptrace: arch_has_single_step
      x86: segment selector macros
      x86: remove TRAP_FLAG
      x86: arch_has_single_step
      x86: single_step moved
      x86: single_step segment macros
      x86: single_step 0xf0
      x86: single_step: share code
      x86 single_step: TIF_FORCED_TF
      ptrace: generic resume
      x86-64: ptrace generic resume
      x86-32: ptrace generic resume
      powerpc: arch_has_single_step
      powerpc: ptrace generic resume
      x86-32 ptrace: use task_pt_regs
      x86-64 ptrace: use task_pt_regs
      x86-64 ptrace debugreg cleanup
      x86-64 ia32 ptrace debugreg cleanup
      x86-32 ptrace debugreg cleanup
      ptrace: arch_has_block_step
      ptrace: generic PTRACE_SINGLEBLOCK
      x86: debugctlmsr constants
      x86: debugctlmsr kconfig
      x86: debugctlmsr context switch
      x86: debugctlmsr arch_has_block_step
      x86: debugctlmsr kprobes
      x86: PTRACE_SINGLEBLOCK
      x86: setup64 eflags constants
      x86: eflags enum
      x86-64 ia32 ptrace pt_regs cleanup
      x86-64 ptrace whitespace
      x86-32 ptrace whitespace
      x86-64 ptrace get/putreg current task
      x86-32 ptrace get/putreg current task
      x86-64 ia32 ptrace get/putreg32 current task
      x86-32 thread_struct.debugreg
      x86: ptrace_32 renamed
      x86: ptrace FLAG_MASK cleanup
      x86 ptrace getreg/putreg cleanup
      x86 ptrace getreg/putreg merge
      x86 ptrace arch merge
      x86 ptrace merge syscall trace
      x86 ia32 ptrace getreg/putreg merge
      x86 ia32 ptrace arch merge
      x86 ptrace merge complete
      x86 ptrace merge removals
      x86 ptrace getreg/putreg merge
      user_regset header
      elf core dump: notes reorg
      elf core dump: notes user_regset
      user_regset helpers
      compat_binfmt_elf
      compat_binfmt_elf Kconfig
      user_regset user-copy helpers
      ptrace_request peekdata/pokedata
      compat_ptrace_request
      compat_sys_ptrace
      x86-64 wired cpu_has macros
      x86 i387 unify structs
      x86 i387 header cleanup
      x86 user_regset math_emu
      x86: i387 renaming
      x86 i387 user_regset
      x86 i387 cleanup
      x86_64 save_i387_ia32 snafu
      x86 TLS desc_struct cleanup
      x86 user_regset TLS
      x86 user_regset general regs
      x86 user_regset_view
      x86 CORE_DUMP_USE_REGSET
      x86 ptrace user_regset
      x86 user_regset cleanup
      x86: compat_binfmt_elf
      x86 ia32_binfmt removal
      x86 core dump TLS
      x86 ptrace generic requests
      x86: early_idt_handler improvements, 64-bit

Sam Ravnborg (9):
      x86: fix make mrproper
      x86: unification of arch/x86/Makefiles
      x86: share more options between 32 and 64 bit build
      x86: biarch support for 32 bit builds beautified
      x86: teach vdso to clean
      x86: unify arch/x86/kernel/Makefile(s)
      x86: unify arch/x86/boot/compressed/Makefile(s)
      x86: unify arch/x86/lib/Makefile(s)
      x86: gitignore arch/x86/vdso files

Siddha, Suresh B (1):
      x86: set strong uncacheable where UC is really desired

Steven Rostedt (1):
      remove unused tsk_thread from asm-offsets_64.c

Thomas Gleixner (85):
      x86: clean up arch/x86/ia32/fpu32.c
      x86: clean up arch/x86/ia32/aout32.c
      x86: clean up arch/x86/ia32/ia32_signal.c
      x86: clean up arch/x86/ia32/ipc32.c
      x86: clean up arch/x86/ia32/ptrace32.c
      x86: clean up arch/x86/ia32/sys_ia32.c
      x86: clean up arch/x86/ia32/syscall32.c
      x86: clean up arch/x86/ia32/mmap32.c
      x86: clean up arch/x86/kernel/e820_64.c
      x86: clean up arch/x86/kernel/ldt_32/64.c
      x86: clean up include/asm-x86/desc_64.h
      x86: introduce ldt_write accessor
      x86: prepare arch/x86/kernel/ldt_32/64.c for merging
      x86: merge arch/x86/kernel/ldt_32/64.c
      x86: Unify include/asm-x86/apicdef_32/64.h
      x86: prepare unification of include/asm-x86/apic_32/64.h
      x86: rename get_maxlvt to lapic_get_maxlvt
      x86: use u32 for safe_apic_wait_icr_idle()
      x86: use u32 for some lapic functions
      x86: merge apic_32/64.h
      x86: remove duplicated declarations
      x86: move acpi and pci declarations
      x86: make early_indentify_cpu static
      x86: move idle related declarations
      x86: move k8 related declarations
      x86: move debug related declarations to kdebug.h
      x86: move mce related declarations
      x86: move numa related declarations
      x86: move page related declaration
      x86: move pda related declaration
      x86: move tsc related declarations
      x86: move pmtmr related declarations
      x86: remove obsolete nohpet declaration
      x86: remove duplicate start_kernel declaration
      x86: remove obsolte declarations from proto.h
      x86: move ioapic code where it belongs
      x86: move ack_bad_irq into irq code
      x86: make smp_local_timer_interrupt() static
      x86: prepare merging arch/x86/kernel/apic_32/64.c
      x86: prepare merging futex_32/64.h
      x86: merge futex_32/64.h
      x86: merge include/asm-x86/dma.h
      x86: merge include/asm-x86/scatterlist.h
      x86: simplify set_bitmap in ioport_32.c
      x86: clean up ioport_32.c
      x86: clean up arch/x86/kernel/vsmp_64.c
      x86: clean up arch/x86/mm/mmap_32/64.c
      x86: remove the duplicated arch/x86/ia32/mmap32.c
      x86: unify mc146818rtc.h - prepare for sharing rtc code
      x86: isolate the rtc code for sharing
      x86: share rtc code
      x86: clean up arch/x86/kernel/time_64.c includes
      x86: smp_64.c: Remove unused exports and cleanup while at it
      x86: nuke a ton of dead hpet code
      x86: Remove dead code and exports
      x86: Nuke a ton of unused exports
      x86: move 8259 defines to i8259.h
      x86: fix asm constraints in spinlock_32/64.h
      x86: use immediates instead of RW_LOCK_BIAS_STR
      x86: spinlock_32/64 match the jump labels and symbols
      x86: spinlock_32/64 substitute types and instructions
      x86: merge spinlock.h variants
      x86 cleanup boot_ioreamp_32.c
      x86: cleanup tlbflush.h variants
      x86: merge tlbflush.h variants
      x86: cleanup mpspec variants
      x86: merge mpspec variants
      x86: cleanup smp.h variants
      x86: cleanup acpi_32/64.h
      x86: merge acpi_32/64.h
      x86: put all kern_addr_valid() incarnations to pgtable.h
      x86: merge include/asm-x86/sparsemem.h
      x86: merge include/asm-x86/sparsemem.h
      x86: cleanup numa_64.c
      x86: fixup numa 64 namespace
      x86: adjust numa 32 namespace
      x86: consolidate toloplogy_32/64.h
      x86: merge topology.h variants
      x86: merge resume-trace.h variants
      x86: cleanup kernel/setup_64.c
      timer: clean up tick-broadcast.c
      x86: restrict PIT clocksource usage
      clocksource: add unregister function to disable unusable clocksources
      x86: unregister PIT clocksource when PIT is disabled
      x86: preset apic clockevents multiplicator

Venki Pallipadi (2):
      Track accurate idle time with tick_sched.idle_sleeptime
      x86: Voluntary leave_mm before entering ACPI C3

Vladimir Berezniker (1):
      x86_64: sanitize user specified e820 memmap values

WANG Cong (2):
      git-x86: unbreak UML
      git-x86: uml: fix a building error

Yinghai Lu (12):
      x86: clear IO_APIC before enabing apic error vector.
      store core id bits in cpuinfo_x8
      x86: use core id bits for apicid_to_node initialization
      x86: set cpu_index to nr_cpus instead of 0
      x86: do not set boot cpu in cpu_online_map at x86_64_start_kernel()
      x86_64: not clear empty_zero_page again
      x86: cleanup setup_node_zones called by paging_init()
      x86: disable the GART early, 64-bit
      x86_64: only call early_init_amd one time
      x86: msr for AMD Fam 10h mmio
      x86_64: checking aperture report for node instead
      x86: only support sparsemem

akpm@linux-foundation.org (1):
      x86: fix typo in ptrace.c

clameter@sgi.com (1):
      x86: clean up stack allocation and free

devzero@web.de (2):
      x86 setup: early cmdline parser handle boolean options
      x86 setup: be more verbose when probing EDD

mboton@gmail.com (1):
      x86: ioport_{32|64}.c unification

travis@sgi.com (20):
      percpu: Use a kconfig variable to signal arch specific percpu setup
      percpu: Move arch XX_PER_CPU_XX definitions into linux/percpu.h
      percpu: Make the asm-generic/percpu.h more "generic"
      x86_32: Use generic percpu.h
      x86_64: Use generic percpu
      x86: Unify percpu.h
      x86: Change size of APICIDs from u8 to u16
      x86: Change size of node ids from u8 to u16
      x86: Change NR_CPUS arrays in powernow-k8
      x86: Change NR_CPUS arrays in intel_cacheinfo
      x86: Change NR_CPUS arrays in smpboot_64
      x86: Change NR_CPUS arrays in topology
      x86: Cleanup x86_cpu_to_apicid references
      x86: Change NR_CPUS arrays in numa_64
      x86: Change NR_CPUS arrays in acpi-cpufreq
      x86: Change bios_cpu_apicid to percpu data variable
      x86: Fixup NR-CPUS patch for numa
      x86: Change NR_CPUS arrays in numa_64 fixup
      x86: Change bios_cpu_apicid to percpu data variable fixup
      x86: add debug of invalid per_cpu map accesses


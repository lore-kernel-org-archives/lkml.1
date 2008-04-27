Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYD0Pjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYD0Pjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYD0Pje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:39:34 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:38298
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbYD0Pjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:39:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] KVM updates for 2.6.26rc
Date: Sun, 27 Apr 2008 18:39:28 +0300
Message-Id: <1209310768-12322-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kvm updates for 2.6.26 from the repo and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.26

The changes include new host architectures (s390, ia64, and ppc 44x),
paravirtualized kernel support, support for the new AMD NPT and Intel VPID
hardware virtualization extensions, large host page support, scalability
improvements, a PIT model, a performance tracing system (kvmtrace), as well
as the usual guest support improvement and minor speedups.

Note that a few changes to s390 and ppc arch code are included; these have
been acked by the respective maintainers.

Al Viro (1):
      KVM: kill file->f_count abuse in kvm

Alexander Graf (1):
      KVM: Implement dummy values for MSR_PERF_STATUS

Amit Shah (1):
      KVM: Add stat counter for hypercalls

Andrea Arcangeli (1):
      KVM: Disable pagefaults during copy_from_user_inatomic()

Anthony Liguori (1):
      KVM: MMU: Don't assume struct page for x86

Avi Kivity (33):
      KVM: x86 emulator: add support for group decoding
      KVM: x86 emulator: group decoding for group 1A
      KVM: x86 emulator: Group decoding for group 3
      KVM: x86 emulator: Group decoding for groups 4 and 5
      KVM: x86 emulator: add group 7 decoding
      KVM: Only x86 has pio
      KVM: x86 emulator: group decoding for group 1 instructions
      KVM: MMU: Decouple mmio from shadow page tables
      KVM: Limit vcpu mmap size to one page on non-x86
      KVM: Add API to retrieve the number of supported vcpus per vm
      KVM: Increase vcpu count to 16
      KVM: Add API for determining the number of supported memory slots
      KVM: Increase the number of user memory slots per vm
      KVM: Use x86's segment descriptor struct instead of private definition
      KVM: Prefix control register accessors with kvm_ to avoid namespace pollution
      KVM: VMX: Don't adjust tsc offset forward
      KVM: Remove pointless desc_ptr #ifdef
      KVM: Provide unlocked version of emulator_write_phys()
      KVM: MMU: Set the accessed bit on non-speculative shadow ptes
      KVM: Move some x86 specific constants and structures to include/asm-x86
      KVM: MMU: Introduce and use spte_to_page()
      KVM: no longer EXPERIMENTAL
      KVM: VMX: Add module option to disable flexpriority
      KVM: Free apic access page on vm destruction
      KVM: MMU: Only mark_page_accessed() if the page was accessed by the guest
      KVM: Register ioctl range
      KVM: s390: Stub out kvmtrace
      KVM: ia64: Stub out kvmtrace
      KVM: Rename VCPU_MP_STATE_* to KVM_MP_STATE_*
      KVM: SVM: force a new asid when initializing the vmcb
      KVM: x86 emulator: initialize src.val and dst.val for register operands
      KVM: x86 emulator: fix smsw and lmsw with a memory operand
      KVM: x86 emulator: fix lea to really get the effective address

Carsten Otte (4):
      s390: KVM preparation: provide hook to enable pgstes in user pagetable
      KVM: s390: interrupt subsystem, cpu timer, waitpsw
      KVM: s390: API documentation
      s390: KVM guest: detect when running on kvm

Christian Borntraeger (10):
      KVM: kvm.h: __user requires compiler.h
      s390: KVM preparation: host memory management changes for s390 kvm
      s390: KVM preparation: address of the 64bit extint parm in lowcore
      KVM: s390: sie intercept handling
      KVM: s390: intercepts for privileged instructions
      KVM: s390: interprocessor communication via sigp
      KVM: s390: intercepts for diagnose instructions
      KVM: s390: add kvm to kconfig on s390
      KVM: s390: update maintainers
      s390: KVM guest: virtio device support, and kvm hypercalls

Dong, Eddie (2):
      KVM: MMU: Update shadow ptes on partial guest pte writes
      KVM: MMU: Simplify hash table indexing

Feng (Eric) Liu (1):
      KVM: Add trace markers

Feng(Eric) Liu (1):
      KVM: Add kvm trace userspace interface

Glauber Costa (3):
      x86: allow machine_crash_shutdown to be replaced
      x86: make native_machine_shutdown non-static
      x86: KVM guest: disable clock before rebooting.

Glauber de Oliveira Costa (2):
      KVM: paravirtualized clocksource: host part
      x86: KVM guest: paravirtualized clocksource

Harvey Harrison (7):
      KVM: x86 emulator: add ad_mask static inline
      KVM: x86 emulator: make register_address, address_mask static inlines
      KVM: x86 emulator: make register_address_increment and JMP_REL static inlines
      KVM: x86 emulator: fix sparse warnings in x86_emulate.c
      KVM: SVM: make iopm_base static
      KVM: sparse fixes for kvm/x86.c
      KVM: replace remaining __FUNCTION__ occurances

Heiko Carstens (4):
      KVM: s390: arch backend for the kvm kernel module
      KVM: s390: Fix incorrect return value
      KVM: s390: rename stfl to kvm_stfl
      KVM: s390: Improve pgste accesses

Hollis Blanchard (6):
      KVM: Use CONFIG_PREEMPT_NOTIFIERS around struct preempt_notifier
      KVM: Rename debugfs_dir to kvm_debugfs_dir
      ppc: Export tlb_44x_hwater for KVM
      KVM: ppc: Add DCR access information to struct kvm_run
      KVM: Add MAINTAINERS entry for PowerPC KVM
      KVM: ppc: PowerPC 440 KVM implementation

Izik Eidus (5):
      KVM: MMU: fix dirty bit setting when removing write permissions
      KVM: x86: add functions to get the cpl of vcpu
      KVM: x86: hardware task switching support
      KVM: MMU: allow the vm to shrink the kvm mmu shadow caches
      KVM: add vm refcounting

Jan Engelhardt (1):
      KVM: constify function pointer tables

Joerg Roedel (27):
      KVM: make EFER_RESERVED_BITS configurable for architecture code
      KVM: align valid EFER bits with the features of the host system
      KVM: VMX: unifdef the EFER specific code
      KVM: allow access to EFER in 32bit KVM
      KVM: SVM: move feature detection to hardware setup code
      KVM: SVM: add detection of Nested Paging feature
      KVM: SVM: add module parameter to disable Nested Paging
      KVM: export information about NPT to generic x86 code
      KVM: MMU: make the __nonpaging_map function generic
      KVM: export the load_pdptrs() function to modules
      KVM: MMU: add TDP support to the KVM MMU
      KVM: SVM: add support for Nested Paging
      KVM: SVM: let init_vmcb() take struct vcpu_svm as parameter
      KVM: SVM: allocate the MSR permission map per VCPU
      KVM: SVM: enable LBR virtualization
      KVM: detect if VCPU triple faults
      KVM: function declaration parameter name cleanup
      KVM: SVM: indent svm_set_cr4 with tabs instead of spaces
      KVM: SVM: align shadow CR4.MCE with host
      KVM: SVM: add intercept for machine check exception
      KVM: SVM: do not intercept task switch with NPT
      KVM: SVM: sync TPR value to V_TPR field in the VMCB
      KVM: export kvm_lapic_set_tpr() to modules
      KVM: SVM: sync V_TPR with LAPIC.TPR if CR8 write intercept is disabled
      KVM: SVM: disable CR8 intercept when tpr is not masking interrupts
      KVM: SVM: remove now obsolete FIXME comment
      KVM: SVM: remove selective CR0 comment

Marcelo Tosatti (13):
      KVM: MMU: ignore zapped root pagetables
      KVM: MMU: large page support
      KVM: add basic paravirt support
      x86: KVM guest: add basic paravirt support
      KVM: MMU: hypercall based pte updates and TLB flushes
      x86: KVM guest: hypercall based pte updates and TLB flushes
      x86: KVM guest: hypercall batching
      KVM: MMU: unify slots_lock usage
      KVM: MMU: prepopulate guest pages after write-protecting
      KVM: hlt emulation should take in-kernel APIC/PIT timers into account
      KVM: add ioctls to save/store mpstate
      KVM: fix kvm_vcpu_kick vs __vcpu_run race
      KVM: MMU: kvm_pv_mmu_op should not take mmap_sem

Ryan Harper (1):
      KVM: VMX: fix typo in VMX header define

Sheng Yang (5):
      KVM: VMX: Enable Virtual Processor Identification (VPID)
      KVM: In kernel PIT model
      KVM: Add save/restore supporting of in kernel PIT
      KVM: Add reset support for in kernel PIT
      KVM: VMX: Enable MSR Bitmap feature

Xiantao Zhang (17):
      KVM: Use kzalloc to avoid allocating kvm_regs from kernel stack
      KVM: ia64: Prepare some structure and routines for kvm use
      KVM: ia64: Add header files for kvm/ia64
      KVM: ia64: Add kvm arch-specific core code for kvm/ia64
      KVM: ia64: Add header files for kvm/ia64
      KVM: ia64: VMM module interfaces
      KVM: ia64: Add TLB virtulization support
      KVM: ia64: Add interruption vector table for vmm
      KVM: ia64: Add mmio decoder for kvm/ia64
      KVM: ia64: Add trampoline for guest/host mode switch
      KVM: ia64: Add processor virtulization support
      KVM: ia64: Add optimization for some virtulization faults
      KVM: ia64: Generate offset values for assembly code use
      KVM: ia64: Add guest interruption injection support
      KVM: ia64: Add kvm sal/pal virtulization support
      KVM: ia64: Enable kvm build for ia64
      KVM: ia64: Add a guide about how to create kvm guests on ia64

 Documentation/ia64/kvm.txt          |   82 ++
 Documentation/ioctl-number.txt      |    2 +
 Documentation/powerpc/kvm_440.txt   |   41 +
 Documentation/s390/kvm.txt          |  125 ++
 MAINTAINERS                         |   17 +
 arch/ia64/Kconfig                   |    3 +
 arch/ia64/Makefile                  |    1 +
 arch/ia64/kvm/Kconfig               |   49 +
 arch/ia64/kvm/Makefile              |   61 +
 arch/ia64/kvm/asm-offsets.c         |  251 ++++
 arch/ia64/kvm/kvm-ia64.c            | 1806 +++++++++++++++++++++++++++++
 arch/ia64/kvm/kvm_fw.c              |  500 ++++++++
 arch/ia64/kvm/kvm_minstate.h        |  273 +++++
 arch/ia64/kvm/lapic.h               |   25 +
 arch/ia64/kvm/misc.h                |   93 ++
 arch/ia64/kvm/mmio.c                |  341 ++++++
 arch/ia64/kvm/optvfault.S           |  918 +++++++++++++++
 arch/ia64/kvm/process.c             |  970 ++++++++++++++++
 arch/ia64/kvm/trampoline.S          | 1038 +++++++++++++++++
 arch/ia64/kvm/vcpu.c                | 2163 +++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/vcpu.h                |  740 ++++++++++++
 arch/ia64/kvm/vmm.c                 |   66 ++
 arch/ia64/kvm/vmm_ivt.S             | 1424 +++++++++++++++++++++++
 arch/ia64/kvm/vti.h                 |  290 +++++
 arch/ia64/kvm/vtlb.c                |  636 ++++++++++
 arch/powerpc/Kconfig                |    1 +
 arch/powerpc/Kconfig.debug          |    3 +
 arch/powerpc/Makefile               |    1 +
 arch/powerpc/kernel/asm-offsets.c   |   28 +
 arch/powerpc/kvm/44x_tlb.c          |  224 ++++
 arch/powerpc/kvm/44x_tlb.h          |   91 ++
 arch/powerpc/kvm/Kconfig            |   42 +
 arch/powerpc/kvm/Makefile           |   15 +
 arch/powerpc/kvm/booke_guest.c      |  615 ++++++++++
 arch/powerpc/kvm/booke_host.c       |   83 ++
 arch/powerpc/kvm/booke_interrupts.S |  436 +++++++
 arch/powerpc/kvm/emulate.c          |  760 ++++++++++++
 arch/powerpc/kvm/powerpc.c          |  436 +++++++
 arch/s390/Kconfig                   |   14 +
 arch/s390/Makefile                  |    2 +-
 arch/s390/kernel/early.c            |    4 +
 arch/s390/kernel/setup.c            |   14 +-
 arch/s390/kernel/vtime.c            |    1 +
 arch/s390/kvm/Kconfig               |   46 +
 arch/s390/kvm/Makefile              |   14 +
 arch/s390/kvm/diag.c                |   67 ++
 arch/s390/kvm/gaccess.h             |  274 +++++
 arch/s390/kvm/intercept.c           |  216 ++++
 arch/s390/kvm/interrupt.c           |  592 ++++++++++
 arch/s390/kvm/kvm-s390.c            |  685 +++++++++++
 arch/s390/kvm/kvm-s390.h            |   64 +
 arch/s390/kvm/priv.c                |  323 ++++++
 arch/s390/kvm/sie64a.S              |   47 +
 arch/s390/kvm/sigp.c                |  288 +++++
 arch/s390/mm/pgtable.c              |   65 +-
 arch/x86/Kconfig                    |   19 +
 arch/x86/kernel/Makefile            |    2 +
 arch/x86/kernel/crash.c             |    3 +-
 arch/x86/kernel/kvm.c               |  248 ++++
 arch/x86/kernel/kvmclock.c          |  187 +++
 arch/x86/kernel/reboot.c            |   13 +-
 arch/x86/kernel/setup_32.c          |    6 +
 arch/x86/kernel/setup_64.c          |    7 +
 arch/x86/kvm/Kconfig                |   13 +-
 arch/x86/kvm/Makefile               |    6 +-
 arch/x86/kvm/i8254.c                |  611 ++++++++++
 arch/x86/kvm/i8254.h                |   63 +
 arch/x86/kvm/irq.c                  |   18 +
 arch/x86/kvm/irq.h                  |    3 +
 arch/x86/kvm/kvm_svm.h              |    2 +
 arch/x86/kvm/lapic.c                |   35 +-
 arch/x86/kvm/mmu.c                  |  672 +++++++++--
 arch/x86/kvm/mmu.h                  |    6 +
 arch/x86/kvm/paging_tmpl.h          |   86 +-
 arch/x86/kvm/segment_descriptor.h   |   29 -
 arch/x86/kvm/svm.c                  |  352 +++++--
 arch/x86/kvm/svm.h                  |    3 +
 arch/x86/kvm/tss.h                  |   59 +
 arch/x86/kvm/vmx.c                  |  278 ++++-
 arch/x86/kvm/vmx.h                  |   10 +-
 arch/x86/kvm/x86.c                  |  897 +++++++++++++--
 arch/x86/kvm/x86_emulate.c          |  285 +++--
 drivers/s390/Makefile               |    2 +-
 drivers/s390/kvm/Makefile           |    9 +
 drivers/s390/kvm/kvm_virtio.c       |  338 ++++++
 include/asm-ia64/gcc_intrin.h       |   12 +
 include/asm-ia64/kvm.h              |  205 ++++-
 include/asm-ia64/kvm_host.h         |  524 +++++++++
 include/asm-ia64/kvm_para.h         |   29 +
 include/asm-ia64/processor.h        |   63 +
 include/asm-powerpc/kvm.h           |   53 +-
 include/asm-powerpc/kvm_asm.h       |   55 +
 include/asm-powerpc/kvm_host.h      |  152 +++
 include/asm-powerpc/kvm_para.h      |   37 +
 include/asm-powerpc/kvm_ppc.h       |   88 ++
 include/asm-powerpc/mmu-44x.h       |    2 +
 include/asm-s390/Kbuild             |    1 +
 include/asm-s390/kvm.h              |   41 +-
 include/asm-s390/kvm_host.h         |  234 ++++
 include/asm-s390/kvm_para.h         |  150 +++
 include/asm-s390/kvm_virtio.h       |   53 +
 include/asm-s390/lowcore.h          |   15 +-
 include/asm-s390/mmu.h              |    1 +
 include/asm-s390/mmu_context.h      |    8 +-
 include/asm-s390/pgtable.h          |   93 ++-
 include/asm-s390/setup.h            |    1 +
 include/asm-x86/kvm.h               |   41 +
 include/asm-x86/kvm_host.h          |   99 ++-
 include/asm-x86/kvm_para.h          |   55 +
 include/asm-x86/reboot.h            |    2 +
 include/linux/kvm.h                 |  130 +++-
 include/linux/kvm_host.h            |   59 +-
 include/linux/kvm_para.h            |   11 +-
 include/linux/kvm_types.h           |    2 +
 include/linux/sched.h               |    2 +
 kernel/fork.c                       |    2 +-
 mm/rmap.c                           |    7 +-
 virt/kvm/kvm_main.c                 |  230 ++++-
 virt/kvm/kvm_trace.c                |  276 +++++
 119 files changed, 23723 insertions(+), 638 deletions(-)
 create mode 100644 Documentation/ia64/kvm.txt
 create mode 100644 Documentation/powerpc/kvm_440.txt
 create mode 100644 Documentation/s390/kvm.txt
 create mode 100644 arch/ia64/kvm/Kconfig
 create mode 100644 arch/ia64/kvm/Makefile
 create mode 100644 arch/ia64/kvm/asm-offsets.c
 create mode 100644 arch/ia64/kvm/kvm-ia64.c
 create mode 100644 arch/ia64/kvm/kvm_fw.c
 create mode 100644 arch/ia64/kvm/kvm_minstate.h
 create mode 100644 arch/ia64/kvm/lapic.h
 create mode 100644 arch/ia64/kvm/misc.h
 create mode 100644 arch/ia64/kvm/mmio.c
 create mode 100644 arch/ia64/kvm/optvfault.S
 create mode 100644 arch/ia64/kvm/process.c
 create mode 100644 arch/ia64/kvm/trampoline.S
 create mode 100644 arch/ia64/kvm/vcpu.c
 create mode 100644 arch/ia64/kvm/vcpu.h
 create mode 100644 arch/ia64/kvm/vmm.c
 create mode 100644 arch/ia64/kvm/vmm_ivt.S
 create mode 100644 arch/ia64/kvm/vti.h
 create mode 100644 arch/ia64/kvm/vtlb.c
 create mode 100644 arch/powerpc/kvm/44x_tlb.c
 create mode 100644 arch/powerpc/kvm/44x_tlb.h
 create mode 100644 arch/powerpc/kvm/Kconfig
 create mode 100644 arch/powerpc/kvm/Makefile
 create mode 100644 arch/powerpc/kvm/booke_guest.c
 create mode 100644 arch/powerpc/kvm/booke_host.c
 create mode 100644 arch/powerpc/kvm/booke_interrupts.S
 create mode 100644 arch/powerpc/kvm/emulate.c
 create mode 100644 arch/powerpc/kvm/powerpc.c
 create mode 100644 arch/s390/kvm/Kconfig
 create mode 100644 arch/s390/kvm/Makefile
 create mode 100644 arch/s390/kvm/diag.c
 create mode 100644 arch/s390/kvm/gaccess.h
 create mode 100644 arch/s390/kvm/intercept.c
 create mode 100644 arch/s390/kvm/interrupt.c
 create mode 100644 arch/s390/kvm/kvm-s390.c
 create mode 100644 arch/s390/kvm/kvm-s390.h
 create mode 100644 arch/s390/kvm/priv.c
 create mode 100644 arch/s390/kvm/sie64a.S
 create mode 100644 arch/s390/kvm/sigp.c
 create mode 100644 arch/x86/kernel/kvm.c
 create mode 100644 arch/x86/kernel/kvmclock.c
 create mode 100644 arch/x86/kvm/i8254.c
 create mode 100644 arch/x86/kvm/i8254.h
 delete mode 100644 arch/x86/kvm/segment_descriptor.h
 create mode 100644 arch/x86/kvm/tss.h
 create mode 100644 drivers/s390/kvm/Makefile
 create mode 100644 drivers/s390/kvm/kvm_virtio.c
 create mode 100644 include/asm-ia64/kvm_host.h
 create mode 100644 include/asm-ia64/kvm_para.h
 create mode 100644 include/asm-powerpc/kvm_asm.h
 create mode 100644 include/asm-powerpc/kvm_host.h
 create mode 100644 include/asm-powerpc/kvm_para.h
 create mode 100644 include/asm-powerpc/kvm_ppc.h
 create mode 100644 include/asm-s390/kvm_host.h
 create mode 100644 include/asm-s390/kvm_para.h
 create mode 100644 include/asm-s390/kvm_virtio.h
 create mode 100644 virt/kvm/kvm_trace.c

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXIQIdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXIQIdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXIQIcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:45220 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXIQIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:22 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 000/104] KVM patch queue for the 2.6.24 merge window
Date: Mon, 17 Sep 2007 10:30:42 +0200
Message-Id: <11900179463203-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following represents the patch queue for the 2.6.24, posted here for
review.  Most of the patches have already been on kvm-devel (and all of
them on kvm-commits), but some folding has occured to merge fixes
and to make the whole series bisect-friendly.

A few patches are likely to change in the near future; they will be reposted
if they do.

The most visible new feature is the in-kernel lapic/ioapic/pic emulation;
others include making kvm preemptible (a first step for guest swapping),
additional x86 emulator work, and Rusty Unleashed.

Amit Shah (1):
      KVM: Set the ET flag in CR0 after initializing FX

Aurelien Jarno (1):
      KVM: Remove dead code in the cmpxchg instruction emulation

Avi Kivity (11):
      KVM: Future-proof the exit information union ABI
      KVM: x86 emulator: fix cmov for writeback changes
      KVM: x86 emulator: fix faulty check for two-byte opcode
      KVM: Use the scheduler preemption notifiers to make kvm preemptible
      KVM: Close minor race in signal handling
      KVM: X86 emulator: fix 'push reg' writeback
      KVM: MMU: Don't do GFP_NOWAIT allocations
      KVM: VMX: Move vm entry failure handling to the exit handler
      KVM: Move main vcpu loop into subarch independent code
      KVM: Improve emulation failure reporting
      KVM: Skip pio instruction when it is emulated, not executed

Christian Ehrhardt (1):
      KVM: Rename kvm_arch_ops to kvm_x86_ops

Eddie Dong (11):
      KVM: In-kernel string pio write support
      KVM: Add support for in-kernel PIC emulation
      KVM: Define and use cr8 access functions
      KVM: Emulate local APIC in kernel
      KVM: In-kernel I/O APIC model
      KVM: Emulate hlt in the kernel
      KVM: Protect in-kernel pio using kvm->lock
      KVM: in-kernel LAPIC save and restore support
      KVM: pending irq save/restore
      KVM: Keep track of missed timer irq injections
      KVM: Migrate lapic hrtimer when vcpu moves to another cpu

Gabriel C (1):
      KVM: Fix defined but not used warning in drivers/kvm/vmx.c

Gregory Haskins (1):
      KVM: Remove arch specific components from the general code

He, Qing (7):
      KVM: Add get/set irqchip ioctls for in-kernel PIC live migration support
      KVM: Bypass irq_pending get/set when using in kernel irqchip
      KVM: in-kernel IOAPIC save and restore support
      KVM: disable tpr/cr8 sync when in-kernel APIC is used
      KVM: round robin for APIC lowest priority delivery mode
      KVM: enable in-kernel APIC INIT/SIPI handling
      KVM: VMX: Fix exit qualification width on i386

Izik Eidus (2):
      KVM: VMX: allow rmode_tss_base() to work with >2G of guest memory
      KVM: Support more memory slots

Jeff Dike (2):
      KVM: Set exit_reason to KVM_EXIT_MMIO where run->mmio is initialized.
      KVM: add hypercall nr to kvm_run

Laurent Vivier (7):
      KVM: Change the emulator_{read,write,cmpxchg}_* functions to take a vcpu
      KVM: Remove kvm_{read,write}_guest()
      KVM: Remove useless assignment
      KVM: Cleanup string I/O instruction emulation
      KVM: Clean up kvm_setup_pio()
      KVM: VMX: Split segments reload in vmx_load_host_state()
      KVM: Simplify memory allocation

Li, Xin B (1):
      KVM: VMX: Remove a duplicated ia32e mode vm entry control

Nguyen Anh Quynh (1):
      KVM: Fix *nopage() in kvm_main.c

Nitin A Kamble (14):
      KVM: x86 emulator: implement 'and $imm, %{al|ax|eax}'
      KVM: x86 emulator: implement 'jmp rel' instruction (opcode 0xe9)
      KVM: x86 emulator: Implement 'jmp rel short' instruction (opcode 0xeb)
      KVM: x86 emulator: implement 'push reg' (opcodes 0x50-0x57)
      KVM: x86 emulator: push imm8
      KVM: x86 emulator: call near
      KVM: x86 emulator: pushf
      KVM: x86 emulator: sort opcodes into ascending order
      KVM: x86 emulator: imlpement jump conditional relative
      KVM: X86 emulator: jump conditional short
      KVM: x86 emulator: lea
      KVM: x86 emulator: jmp abs
      KVM: x86 emulator: fix src, dst value initialization
      KVM: x86 emulator: popf

Qing He (2):
      KVM: SMP: Add vcpu_id field in struct vcpu
      KVM: deliver PIC interrupt only to vcpu0

Rusty Russell (33):
      KVM: Trivial: /dev/kvm interface is no longer experimental.
      KVM: Trivial: Remove unused struct cpu_user_regs declaration
      KVM: Trivial: Make decode_register() static
      KVM: Trivial: Comment spelling may escape grep
      KVM: Trivial: Avoid hardware_disable predeclaration
      KVM: Trivial: Use standard CR0 flags macros from asm/cpu-features.h
      KVM: Use standard CR3 flags, tighten checking
      KVM: Use standard CR4 flags, tighten checking
      KVM: Trivial: Use standard BITMAP macros, open-code userspace-exposed header
      KVM: Use standard CR8 flags, and fix TPR definition
      KVM: Return if the pdptrs are invalid when the guest turns on PAE.
      KVM: load_pdptrs() cleanups
      KVM: Dynamically allocate vcpus
      KVM: fx_init() needs preemption disabled while it plays with the FPU state
      KVM: VMX: pass vcpu_vmx internally
      KVM: Remove three magic numbers
      KVM: SVM: de-containization
      KVM: SVM: internal function name cleanup
      KVM: Use kmem cache for allocating vcpus
      KVM: Use alignment properties of vcpu to simplify FPU ops
      KVM: kvm_vm_ioctl_get_dirty_log restore "nothing dirty" optimization
      KVM: Don't assign vcpu->cr3 if it's invalid: check first, set last
      KVM: Cleanup mark_page_dirty
      KVM: SVM: Make set_msr_interception more reliable
      KVM: Remove redundant alloc_vmcs_cpu declaration
      KVM: Remove stat_set from debugfs
      KVM: Remove unneeded kvm_dev_open and kvm_dev_release functions.
      KVM: Add and use pr_unimpl for standard formatting of unimplemented features
      KVM: Use kmem_cache_free for kmem_cache_zalloc'ed objects
      KVM: Remove the unused invlpg member of struct kvm_arch_ops.
      KVM: Clean up unloved invlpg emulation
      KVM: Keep control regs in sync
      KVM: Hoist SVM's get_cs_db_l_bits into core code.

Shaohua Li (3):
      KVM: Hoist kvm_mmu_reload() out of the critical section
      KVM: Move gfn_to_page out of kmap/unmap pairs
      KVM: Convert vm lock to a mutex

Yang, Sheng (5):
      KVM: VMX: Import some constants of vmcs from IA32 SDM
      KVM: VMX: Improve the method of writing vmcs control
      KVM: VMX: Add cpu consistency check
      KVM: Communicate cr8 changes to userspace
      KVM: VMX: Use shadow TPR/cr8 for 64-bits guests


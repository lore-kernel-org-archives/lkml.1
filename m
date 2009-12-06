Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbZLFJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbZLFJu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZLFJuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:50:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474AbZLFJuU (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:50:20 -0500
Message-ID: <4B1B7E59.9080709@redhat.com>
Date: Sun, 06 Dec 2009 11:50:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for the 2.6.33 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.33

to receive the KVM updates for the 2.6.33 merge window.

Highlights:
- improved kernel context switching speed
- better interoperation with other users of virtualization extensions
- improved irq scaling
- nested svm improvements and tracing
- improved cpufreq integration
- spin loop detection on newer hardware

Notes:
- this update depends on, and thus merges, tip's x86/entry branch (user 
return notifiers)
- kvm/ppc64 support will be merged through the powerpc tree

Shortlog/diffstat:

Alexander Graf (2):
       KVM: Activate Virtualization On Demand
       KVM: SVM: Notify nested hypervisor of lost event injections

Arnd Bergmann (1):
       KVM: Enable 32bit dirty log pointers on 64bit host

Avi Kivity (17):
       core, x86: Add user return notifiers
       x86: Fix user return notifier build
       core: Fix user return notifier on fork()
       Merge remote branch 'tip/x86/entry' into kvm-updates/2.6.33
       KVM: Don't wrap schedule() with vcpu_put()/vcpu_load()
       KVM: Don't pass kvm_run arguments
       KVM: Return -ENOTTY on unrecognized ioctls
       KVM: Move assigned device code to own file
       KVM: VMX: Move MSR_KERNEL_GS_BASE out of the vmx autoload msr area
       KVM: x86 shared msr infrastructure
       KVM: VMX: Use shared msr infrastructure
       KVM: VMX: Remove vmx->msr_offset_efer
       KVM: Allow internal errors reported to userspace to carry extra data
       KVM: VMX: Report unexpected simultaneous exceptions as internal 
errors
       KVM: x86 emulator: limit instructions to 15 bytes
       KVM: Drop user return notifier when disabling virtualization on a cpu
       KVM: VMX: Fix comparison of guest efer with stale host value

Carsten Otte (2):
       KVM: s390: Make psw available on all exits, not just a subset
       KVM: s390: Fix prefix register checking in arch/s390/kvm/sigp.c

Ed Swierk (1):
       KVM: Xen PV-on-HVM guest support

Eduardo Habkost (3):
       KVM: VMX: Use macros instead of hex value on cr0 initialization
       KVM: SVM: Reset cr0 properly on vcpu reset
       KVM: SVM: init_vmcb(): remove redundant save->cr0 initialization

Glauber Costa (2):
       KVM: x86: include pvclock MSRs in msrs_to_save
       KVM: allow userspace to adjust kvmclock offset

Gleb Natapov (10):
       KVM: Call pic_clear_isr() on pic reset to reuse logic there
       KVM: Move irq sharing information to irqchip level
       KVM: Change irq routing table to use gsi indexed array
       KVM: Maintain back mapping from irqchip/pin to gsi
       KVM: Move irq routing data structure to rcu locking
       KVM: Move irq ack notifier list to arch independent code
       KVM: Convert irq notifiers lists to RCU locking
       KVM: Move IO APIC to its own lock
       KVM: Drop kvm->irq_lock lock from irq injection path
       KVM: remove duplicated task_switch check

Hollis Blanchard (1):
       KVM: powerpc: Fix BUILD_BUG_ON condition

Huang Weiyi (1):
       KVM: remove duplicated #include

Jan Kiszka (8):
       KVM: x86: Refactor guest debug IOCTL handling
       KVM: x86: Rework guest single-step flag injection and filtering
       KVM: x86: Drop unneeded CONFIG_HAS_IOMEM check
       KVM: x86: Fix guest single-stepping while interruptible
       KVM: SVM: Cleanup NMI singlestep
       KVM: x86: Polish exception injection via KVM_SET_GUEST_DEBUG
       KVM: Reorder IOCTLs in main kvm.h
       KVM: x86: Add KVM_GET/SET_VCPU_EVENTS

Jiri Slaby (1):
       KVM: fix lock imbalance in kvm_*_irq_source_id()

Joerg Roedel (11):
       KVM: SVM: reorganize svm_interrupt_allowed
       KVM: SVM: don't copy exit_int_info on nested vmrun
       KVM: SVM: Remove remaining occurences of rdtscll
       KVM: SVM: Move INTR vmexit out of atomic code
       KVM: SVM: Add tracepoint for nested vmrun
       KVM: SVM: Add tracepoint for nested #vmexit
       KVM: SVM: Add tracepoint for injected #vmexit
       KVM: SVM: Add tracepoint for #vmexit because intr pending
       KVM: SVM: Add tracepoint for invlpga instruction
       KVM: SVM: Add tracepoint for skinit instruction
       KVM: SVM: Remove nsvm_printk debugging code

Juan Quintela (1):
       KVM: remove pre_task_link setting in save_state_to_tss16

Marcelo Tosatti (9):
       KVM: SVM: remove needless mmap_sem acquision from nested_svm_map
       KVM: x86: disable paravirt mmu reporting
       KVM: VMX: fix handle_pause declaration
       KVM: fix irq_source_id size verification
       KVM: VMX: move CR3/PDPTR update to vmx_set_cr3
       KVM: MMU: update invlpg handler comment
       KVM: x86: disallow multiple KVM_CREATE_IRQCHIP
       KVM: x86: disallow KVM_{SET,GET}_LAPIC without allocated 
in-kernel lapic
       KVM: only clear irq_source_id if irqchip is present

Mark Langsdorf (1):
       KVM: SVM: Support Pause Filter in AMD processors

Mohammed Gamal (5):
       KVM: x86 emulator: Add 'push/pop sreg' instructions
       KVM: x86 emulator: Introduce No64 decode option
       KVM: x86 emulator: Add missing decoder flags for 'or' instructions
       KVM: x86 emulator: Add pusha and popa instructions
       KVM: VMX: Enhance invalid guest state emulation

Sheng Yang (1):
       KVM: VMX: Disable unrestricted guest when EPT disabled

Stephen Rothwell (1):
       x86: Fix user return notifier put_cpu_var() invocation

Zachary Amsden (5):
       KVM: Separate timer intialization into an indepedent function
       KVM: Kill the confusing tsc_ref_khz and ref_freq variables
       KVM: Fix printk name error in svm.c
       KVM: Fix hotplug of CPUs
       KVM: x86: Harden against cpufreq

Zhai, Edwin (2):
       KVM: introduce kvm_vcpu_on_spin
       KVM: VMX: Add support for Pause-Loop Exiting

  Documentation/kvm/api.txt            |  109 ++++
  arch/Kconfig                         |   10 +
  arch/ia64/include/asm/kvm.h          |    1 +
  arch/ia64/include/asm/kvm_host.h     |    1 -
  arch/ia64/kvm/Makefile               |    2 +-
  arch/ia64/kvm/kvm-ia64.c             |   19 +-
  arch/powerpc/kvm/powerpc.c           |    5 +-
  arch/powerpc/kvm/timing.h            |    2 +-
  arch/s390/include/asm/kvm.h          |    3 +-
  arch/s390/kvm/kvm-s390.c             |   30 +-
  arch/s390/kvm/sigp.c                 |    6 +-
  arch/x86/Kconfig                     |    1 +
  arch/x86/include/asm/kvm.h           |   30 +
  arch/x86/include/asm/kvm_emulate.h   |    2 +-
  arch/x86/include/asm/kvm_host.h      |   34 +-
  arch/x86/include/asm/svm.h           |    3 +-
  arch/x86/include/asm/thread_info.h   |    7 +-
  arch/x86/include/asm/vmx.h           |    4 +
  arch/x86/kernel/process.c            |    2 +
  arch/x86/kernel/signal.c             |    3 +
  arch/x86/kvm/Kconfig                 |    1 +
  arch/x86/kvm/Makefile                |    3 +-
  arch/x86/kvm/emulate.c               |  159 +++++-
  arch/x86/kvm/i8254.c                 |    2 -
  arch/x86/kvm/i8259.c                 |   44 +-
  arch/x86/kvm/irq.h                   |    7 +-
  arch/x86/kvm/lapic.c                 |    8 +-
  arch/x86/kvm/mmu.c                   |    3 +-
  arch/x86/kvm/paging_tmpl.h           |    1 -
  arch/x86/kvm/svm.c                   |  331 +++++++-----
  arch/x86/kvm/trace.h                 |  165 ++++++
  arch/x86/kvm/vmx.c                   |  448 +++++++++-------
  arch/x86/kvm/x86.c                   |  550 ++++++++++++++++----
  include/linux/kvm.h                  |  272 ++++++----
  include/linux/kvm_host.h             |   53 ++-
  include/linux/user-return-notifier.h |   49 ++
  kernel/Makefile                      |    1 +
  kernel/fork.c                        |    2 +
  kernel/user-return-notifier.c        |   46 ++
  virt/kvm/assigned-dev.c              |  818 +++++++++++++++++++++++++++++
  virt/kvm/eventfd.c                   |    2 -
  virt/kvm/ioapic.c                    |   80 +++-
  virt/kvm/ioapic.h                    |    5 +
  virt/kvm/irq_comm.c                  |  231 +++++----
  virt/kvm/kvm_main.c                  |  961 
++++++----------------------------
  45 files changed, 2937 insertions(+), 1579 deletions(-)
  create mode 100644 include/linux/user-return-notifier.h
  create mode 100644 kernel/user-return-notifier.c
  create mode 100644 virt/kvm/assigned-dev.c



-- 
error compiling committee.c: too many arguments to function


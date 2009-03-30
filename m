Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbZC3Tmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbZC3Tmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760242AbZC3TmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:42:23 -0400
Received: from gw.goop.org ([64.81.55.164]:54907 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177AbZC3TmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:42:22 -0400
Message-ID: <49D1209A.9000800@goop.org>
Date: Mon, 30 Mar 2009 12:42:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [GIT PULL] Xen for 2.6.30 #1
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the first set of Xen changes for 2.6.30.  This set contains 
updates, bugfixes, etc for the existing Xen domU support.

The following pull request will have the dom0 bits.

Thanks,
       J

The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:
  Linus Torvalds (1):
        Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-linus/xen/master

Alex Nixon (1):
      Xen: Add virt_to_pfn helper function

Hannes Eder (1):
      NULL noise: arch/x86/xen/smp.c

Ian Campbell (7):
      xen: resume interrupts before system devices.
      xen: add irq_from_evtchn
      xen: add /dev/xen/evtchn driver
      xen: export ioctl headers to userspace
      xen: remove suspend_cancel hook
      xen: use device model for suspending xenbus devices
      xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet

Jeremy Fitzhardinge (27):
      mm: disable preemption in apply_to_pte_range
      x86/paravirt: remove lazy mode in interrupts
      x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch
      x86/paravirt: flush pending mmu updates on context switch
      x86/paravirt: finish change from lazy cpu to context switch start/end
      x86/paravirt: allow preemption with lazy mmu mode
      mm: allow preemption in apply_to_pte_range
      x86/paravirt: use percpu_ rather than __get_cpu_var
      xen: disable preempt for leave_lazy_mmu
      xen: separate p2m allocation from setting
      xen: split construction of p2m mfn tables from registration
      xen: clean up xen_load_gdt
      xen: make xen_load_gdt simpler
      xen: remove xen_load_gdt debug
      xen: mask XSAVE from cpuid
      x86-64: remove PGE from must-have feature list
      x86-64: non-paravirt systems always has PSE and PGE
      xen/mmu: some early pagetable cleanups
      xen/mmu: weaken flush_tlb_other test
      xen: set _PAGE_NX in __supported_pte_mask before pagetable construction
      xen: clean up gate trap/interrupt constants
      xen/dev-evtchn: clean up locking in evtchn
      xen/xenbus: export xenbus_dev_changed
      xen: add /sys/hypervisor support
      xen/sys/hypervisor: change writable_pt to features
      xen: add "capabilities" file
      Merge branches 'for-linus/xen/dev-evtchn', 'for-linus/xen/xenbus', 'for-linus/xen/xenfs' and 'for-linus/xen/sys-hypervisor' into for-linus/xen/master

 arch/x86/include/asm/paravirt.h          |   22 +-
 arch/x86/include/asm/pgtable.h           |    2 +
 arch/x86/include/asm/required-features.h |    8 +-
 arch/x86/include/asm/thread_info.h       |    2 +
 arch/x86/include/asm/xen/page.h          |    3 +-
 arch/x86/kernel/kvm.c                    |    2 +-
 arch/x86/kernel/paravirt.c               |   56 ++--
 arch/x86/kernel/process_32.c             |    2 +-
 arch/x86/kernel/process_64.c             |    2 +-
 arch/x86/kernel/vmi_32.c                 |   20 +-
 arch/x86/lguest/boot.c                   |   16 +-
 arch/x86/mm/fault.c                      |    6 +-
 arch/x86/mm/highmem_32.c                 |    2 -
 arch/x86/mm/iomap_32.c                   |    1 -
 arch/x86/mm/pageattr.c                   |   14 -
 arch/x86/xen/enlighten.c                 |   99 +++++--
 arch/x86/xen/mmu.c                       |  134 ++++++---
 arch/x86/xen/mmu.h                       |    3 +
 arch/x86/xen/smp.c                       |    4 +-
 arch/x86/xen/xen-ops.h                   |    3 -
 drivers/xen/Kconfig                      |   20 ++
 drivers/xen/Makefile                     |    4 +-
 drivers/xen/events.c                     |    6 +
 drivers/xen/evtchn.c                     |  507 ++++++++++++++++++++++++++++++
 drivers/xen/manage.c                     |   15 +-
 drivers/xen/sys-hypervisor.c             |  445 ++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c        |   61 +---
 drivers/xen/xenbus/xenbus_xs.c           |    2 +
 drivers/xen/xenfs/super.c                |   19 +-
 include/Kbuild                           |    1 +
 include/asm-frv/pgtable.h                |    4 +-
 include/asm-generic/pgtable.h            |   21 +-
 include/xen/Kbuild                       |    1 +
 include/xen/events.h                     |    3 +
 include/xen/evtchn.h                     |   88 +++++
 include/xen/interface/version.h          |    3 +
 include/xen/xenbus.h                     |    3 +-
 kernel/sched.c                           |    2 +-
 38 files changed, 1376 insertions(+), 230 deletions(-)
 create mode 100644 drivers/xen/evtchn.c
 create mode 100644 drivers/xen/sys-hypervisor.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/evtchn.h



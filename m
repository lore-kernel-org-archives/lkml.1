Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbZFLNnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbZFLNnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbZFLNbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:50 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51573 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765492AbZFLNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GqbvGrR5sFFZrQcgAZ5t1LpQ4HqwsiQTmMomh/nHrk1ggrZGTiGX07HPfzVagcsZzz
         IKcew3cCupYFkEzpwqbu4DtuwJZhVrDUo7ciKB7zb1U0/IGm8mkoRBS5WWf055TH0hn8
         VpAqv4yio2HYvkVIfeSFKyC/JG4FXLTagpTd4=
Date: Fri, 12 Jun 2009 15:31:46 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck for mainline
Message-ID: <20090612132443.GA24002@damson.ad.medicalresearch.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the kmemcheck tree;

kmemcheck is a feature which can (at run-time) detect some uses of
uninitialized memory within the kernel, similarly to what Valgrind's memcheck
does for userspace programs. We also have the ability to find use-after-free
errors and leaks of uninitialized data to userspace, both with a false-
positive rate of zero.

kmemcheck is self-contained in the sense that when CONFIG_KMEMCHECK=n, it has
no effect on the compiled kernel whatsoever. Our code has lived in the -tip
tree and been in -next for over a year, and has the acks of x86 and slab
maintainers (Ingo and Pekka). Inclusion in mainline would lower the threshold
for building and running kmemcheck-enabled kernels, which would also
hopefully increase testing coverage of the rest of the kernel code.


Vegard


The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-linus

Ingo Molnar (40):
      Merge branch 'current' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck2
      Merge branch 'linus' into kmemcheck2
      Manual merge of tip/x86/irq into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge branch 'linus' into kmemcheck
      kmemcheck: export kmemcheck_mark_initialized
      Merge branch 'linus' into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge commit 'v2.6.27-rc3' into kmemcheck
      kmemcheck: build fix
      Merge branch 'linus' into kmemcheck
      Merge branches 'oprofile' and 'timers/hpet' into x86/core-v4
      Merge branch 'linus' into kmemcheck-v2
      Merge branch 'x86/core-v4' into kmemcheck-v2
      Merge commit 'v2.6.28-rc2' into kmemcheck
      Merge commit 'v2.6.28' into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge commit 'v2.6.29-rc2' into kmemcheck
      Merge branch 'x86/mm' into kmemcheck
      Merge branch 'x86/headers' into kmemcheck
      Merge branch 'x86/headers' into kmemcheck
      Merge branch 'x86/headers' into kmemcheck
      Merge branch 'x86/headers' into kmemcheck
      Merge branch 'for-ingo' of git://git.kernel.org/.../penberg/slab-2.6 into kmemcheck
      Merge branch 'x86/core' into kmemcheck
      Merge branch 'core/iommu' into kmemcheck
      Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
      Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
      Merge branch 'x86/core' into kmemcheck
      Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
      Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck
      kmemcheck: fix split_page() of the page allocator, fix
      Merge branch 'x86/mm-v2' into kmemcheck
      Merge branch 'linus' into kmemcheck
      Merge commit 'v2.6.30-rc5' into kmemcheck
      Merge branch 'linus' into kmemcheck

Jeremy Fitzhardinge (2):
      x86: make _PAGE_HIDDEN conditional
      x86: unify pte_hidden

Pekka Enberg (13):
      x86: __show_registers() and __show_regs() API unification
      slab: move struct kmem_cache to headers
      kmemcheck: add Vegard and Pekka to MAINTAINERS
      x86: add hooks for kmemcheck on x86_64
      slab: add hooks for kmemcheck
      kmemcheck: Disable SLUB and SLAB debugging when kmemcheck is enabled
      kmemcheck: remove forward declarations from error.c
      kmemcheck: make initialization message less confusing
      kmemcheck: remove multiple ifdef'd definitions of the same global variable
      kmemcheck: move 64-bit ifdef out of kmemcheck_opcode_decode()
      kmemcheck: missing whitespace in do_page_fault()
      kmemcheck: use kmemcheck_pte_lookup() instead of open-coding it
      kmemcheck: make kconfig accessible for other architectures

Randy Dunlap (1):
      kmemcheck: include module.h to prevent warnings

Vegard Nossum (76):
      x86: add save_stack_trace_bp() for tracing from a specific stack frame
      stacktrace: add forward-declaration struct task_struct
      tasklets: new tasklet scheduling function
      kmemcheck: add the kmemcheck core
      x86: add hooks for kmemcheck
      kmemcheck: add mm functions
      slub: add hooks for kmemcheck
      kmemcheck: enable in the x86 Kconfig
      kmemcheck: fix sparse warnings
      softirq: raise the right softirq
      kmemcheck: use the proper comment style
      kmemcheck: fix use of uninitialized spinlock
      kmemcheck: constrain tracking to non-debugged caches
      kmemcheck: mark SMP support BROKEN
      kmemcheck: use capital Y/N in kconfig help-texts
      kmemcheck: remove unnecessary tests in the slab allocator
      kmemcheck: add DMA hooks
      kmemcheck: work with sizes in terms of bytes instead of bits
      kmemcheck: allow memory accesses that cross page boundaries
      kmemcheck: add some more documentation
      kmemcheck: add some comments
      kmemcheck: save memory contents on use of uninitialized memory
      kmemcheck: implement REP MOVS/STOS emulation
      kmemcheck: hide/show pages in each iteration of a REP instruction
      kmemcheck: rip out the optimized memset()
      kmemcheck: rip out SMP code
      kmemcheck: hide/show pages in each iteration of a REP instruction #2
      kmemcheck: lazy checking for MOVS instructions
      Revert "kmemcheck: use set_memory_4k() instead of disabling PSE"
      x86: use REP MOVS instruction for memcpy if kmemcheck is enabled
      kmemcheck: use set_memory_4k() on x86_64 only
      kmemcheck: fix crash in PnP BIOS calls
      kmemcheck: tag warning printks
      kmemcheck: (finally) use 4k pages for identity mapping
      x86: fix mis-merge
      kmemcheck: fix mis-merge in sysctl table
      kmemcheck: update documentation
      kmemcheck: update Kconfig help text
      kmemcheck: document the shadow member of struct page
      kmemcheck: bitfield API
      net: use kmemcheck bitfields API for skbuff
      net: annotate bitfields in struct inet_sock
      ieee1394: annotate bitfield
      ieee1394/csr1212: fix false positive kmemcheck report
      kmemcheck: annotate inet_timewait_sock bitfields
      kmemcheck: disable fast string operations on P4 CPUs
      kmemcheck: rip out REP instruction emulation
      kmemcheck: add hooks for page- and sg-dma-mappings
      kmemcheck: don't track allocated page tables
      kmemcheck: add hooks for the page allocator
      kmemcheck: depend on !SLUB_DEBUG_ON
      kmemcheck: fix CONFIG_KMEMCHECK=n build failure
      kmemcheck: make ftrace and kmemcheck mutually exclusive
      kmemcheck: fix an incorrect BUG_ON()
      kmemcheck: fix shadow updates that cross page boundaries
      crypto: don't track xor test pages with kmemcheck
      x86: don't use MMX/SSE in xor routines if kmemcheck is compiled in
      kmemcheck: reverse dependencies between DEBUG_PAGEALLOC and KMEMCHECK
      kmemcheck: depend on DEBUG_KERNEL
      c2port: annotate bitfield for kmemcheck
      kmemcheck (bitfields): don't actually initialize the bitfield
      net: annotate struct sock bitfield
      kmemcheck: add opcode self-testing at boot
      kmemcheck: decode sign/zero-extension move instructions correctly
      kmemcheck: bitfields: introduce hack to work around gcc bug
      trace: annotate bitfields in struct ring_buffer_event
      kmemcheck: fix split_page() of the page allocator
      kmemcheck: disable CPA self-test
      x86: don't track page tables with kmemcheck
      Revert "kmemcheck: disable CPA self-test"
      kmemcheck: make bitfield annotations be valid C
      fs: introduce __getname_gfp()
      kmemcheck: add __GFP_NOTRACK_FALSE_POSITIVE flag
      kmemcheck: fix do_mount_root() false positive
      kmemcheck: fix __send_signal() false positive
      kmemcheck: update documentation

Yinghai Lu (1):
      x86: introduce bootmem_state

 Documentation/kmemcheck.txt          |  773 ++++++++++++++++++++++++++++++++++
 MAINTAINERS                          |    8 +
 arch/x86/Kconfig                     |    1 +
 arch/x86/Kconfig.debug               |    1 +
 arch/x86/Makefile                    |    5 +
 arch/x86/include/asm/dma-mapping.h   |    8 +
 arch/x86/include/asm/kmemcheck.h     |   42 ++
 arch/x86/include/asm/page_types.h    |    8 +
 arch/x86/include/asm/pgtable.h       |    5 +
 arch/x86/include/asm/pgtable_types.h |    9 +-
 arch/x86/include/asm/string_32.h     |    8 +
 arch/x86/include/asm/string_64.h     |    8 +
 arch/x86/include/asm/thread_info.h   |    4 +-
 arch/x86/include/asm/xor.h           |    5 +
 arch/x86/kernel/cpu/intel.c          |   23 +
 arch/x86/kernel/process.c            |    2 +-
 arch/x86/kernel/setup.c              |    1 +
 arch/x86/kernel/stacktrace.c         |    7 +
 arch/x86/kernel/traps.c              |    5 +
 arch/x86/mm/Makefile                 |    2 +
 arch/x86/mm/fault.c                  |   18 +-
 arch/x86/mm/init.c                   |   15 +-
 arch/x86/mm/init_32.c                |   30 +-
 arch/x86/mm/init_64.c                |   37 +-
 arch/x86/mm/kmemcheck/Makefile       |    1 +
 arch/x86/mm/kmemcheck/error.c        |  228 ++++++++++
 arch/x86/mm/kmemcheck/error.h        |   15 +
 arch/x86/mm/kmemcheck/kmemcheck.c    |  637 ++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c       |  106 +++++
 arch/x86/mm/kmemcheck/opcode.h       |    9 +
 arch/x86/mm/kmemcheck/pte.c          |   22 +
 arch/x86/mm/kmemcheck/pte.h          |   10 +
 arch/x86/mm/kmemcheck/selftest.c     |   69 +++
 arch/x86/mm/kmemcheck/selftest.h     |    6 +
 arch/x86/mm/kmemcheck/shadow.c       |  162 +++++++
 arch/x86/mm/kmemcheck/shadow.h       |   16 +
 arch/x86/mm/pageattr.c               |    2 +-
 arch/x86/mm/pgtable.c                |   12 +-
 crypto/xor.c                         |    7 +-
 drivers/ieee1394/csr1212.c           |    2 +
 drivers/ieee1394/nodemgr.c           |    5 +
 drivers/misc/c2port/core.c           |    2 +
 include/linux/c2port.h               |    3 +
 include/linux/fs.h                   |    5 +-
 include/linux/gfp.h                  |   14 +-
 include/linux/interrupt.h            |   14 +
 include/linux/kmemcheck.h            |  157 +++++++
 include/linux/mm_types.h             |    8 +
 include/linux/ring_buffer.h          |    4 +
 include/linux/skbuff.h               |    7 +
 include/linux/slab.h                 |    7 +
 include/linux/slab_def.h             |   81 ++++
 include/linux/stacktrace.h           |    3 +
 include/net/inet_sock.h              |   14 +-
 include/net/inet_timewait_sock.h     |    5 +-
 include/net/sock.h                   |    2 +
 init/do_mounts.c                     |    3 +-
 init/main.c                          |    4 +
 kernel/fork.c                        |   14 +-
 kernel/signal.c                      |   11 +-
 kernel/softirq.c                     |   11 +
 kernel/sysctl.c                      |   11 +
 kernel/trace/ring_buffer.c           |    3 +
 lib/Kconfig.debug                    |    6 +-
 lib/Kconfig.kmemcheck                |   91 ++++
 mm/Makefile                          |    1 +
 mm/kmemcheck.c                       |  122 ++++++
 mm/page_alloc.c                      |   18 +
 mm/slab.c                            |  108 +----
 mm/slub.c                            |   38 ++-
 net/core/skbuff.c                    |    8 +
 net/core/sock.c                      |    2 +
 net/ipv4/inet_timewait_sock.c        |    3 +
 73 files changed, 2958 insertions(+), 156 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/include/asm/kmemcheck.h
 create mode 100644 arch/x86/mm/kmemcheck/Makefile
 create mode 100644 arch/x86/mm/kmemcheck/error.c
 create mode 100644 arch/x86/mm/kmemcheck/error.h
 create mode 100644 arch/x86/mm/kmemcheck/kmemcheck.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.h
 create mode 100644 arch/x86/mm/kmemcheck/pte.c
 create mode 100644 arch/x86/mm/kmemcheck/pte.h
 create mode 100644 arch/x86/mm/kmemcheck/selftest.c
 create mode 100644 arch/x86/mm/kmemcheck/selftest.h
 create mode 100644 arch/x86/mm/kmemcheck/shadow.c
 create mode 100644 arch/x86/mm/kmemcheck/shadow.h
 create mode 100644 include/linux/kmemcheck.h
 create mode 100644 lib/Kconfig.kmemcheck
 create mode 100644 mm/kmemcheck.c

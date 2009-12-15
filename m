Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbZLOKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbZLOKxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbZLOKxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:53:18 -0500
Received: from www.tglx.de ([62.245.132.106]:36463 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZLOKxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:53:15 -0500
Date: Tue, 15 Dec 2009 11:52:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] locking name space cleanup and lock annotation for
 2.6.33
Message-ID: <alpine.LFD.2.00.0912150916500.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

The patches have been extensively reviewed and the resulting code has
been checked on the binary level. It compiles on all architectures,
boots on x86,arm,power,mips,sh,avr32 and survived the automated -tip
testing without a single hickup.

Most pending architecture trees are upstream now but merge
interactions in the past few days may have introduced small
complications that we have not found yet.

For mainline these patches are basically a zero impact change, but
they take a huge maintainence burden from preempt-rt.

Thanks,

	tglx

------------------>
Thomas Gleixner (26):
      locking: Reorder functions in spinlock.c
      locking: Split rwlock from spinlock headers
      locking: Separate rwlock api from spinlock api
      locking: Convert raw_spinlock to arch_spinlock
      locking: Rename __RAW_SPIN_LOCK_UNLOCKED to __ARCH_SPIN_LOCK_UNLOCKED
      locking: Convert __raw_spin* functions to arch_spin*
      locking: Convert raw_rwlock to arch_rwlock
      locking: Convert raw_rwlock functions to arch_rwlock
      locking: Implement new raw_spinlock
      alpha: Fix fallout from locking changes
      locking: Further name space cleanups
      locking: Cleanup the name space completely
      bkl: Fixup core_lock fallout
      plist: Make plist debugging raw_spinlock aware
      sched: Convert rq->lock to raw_spinlock
      sched: Convert rt_runtime_lock to raw_spinlock
      sched: Convert cpupri lock to raw_spinlock
      sched: Convert pi_lock to raw_spinlock
      rtmutes: Convert rtmutex.lock to raw_spinlock
      smp: Convert smplocks to raw_spinlocks
      genirq: Convert irq_desc.lock to raw_spinlock
      hrtimers: Convert to raw_spinlocks
      perf_event: Convert to raw_spinlock
      debugobjects: Convert to raw_spinlocks
      clockevents: Make tick_device_lock static
      clockevents: Convert to raw_spinlock


 arch/alpha/include/asm/core_t2.h           |   34 ++--
 arch/alpha/include/asm/spinlock.h          |   38 ++--
 arch/alpha/include/asm/spinlock_types.h    |    8 +-
 arch/alpha/kernel/core_t2.c                |    2 +-
 arch/alpha/kernel/irq.c                    |    4 +-
 arch/arm/include/asm/mach/irq.h            |    4 +-
 arch/arm/include/asm/spinlock.h            |   40 ++--
 arch/arm/include/asm/spinlock_types.h      |    8 +-
 arch/arm/kernel/irq.c                      |   12 +-
 arch/arm/mach-ns9xxx/irq.c                 |    8 +-
 arch/avr32/kernel/irq.c                    |    4 +-
 arch/blackfin/include/asm/spinlock.h       |   62 +++---
 arch/blackfin/include/asm/spinlock_types.h |    8 +-
 arch/blackfin/kernel/irqchip.c             |    6 +-
 arch/blackfin/kernel/traps.c               |    4 +-
 arch/cris/include/arch-v32/arch/spinlock.h |   62 +++---
 arch/cris/kernel/irq.c                     |    4 +-
 arch/frv/kernel/irq.c                      |    4 +-
 arch/h8300/kernel/irq.c                    |    4 +-
 arch/ia64/include/asm/bitops.h             |    2 +-
 arch/ia64/include/asm/spinlock.h           |   76 +++---
 arch/ia64/include/asm/spinlock_types.h     |    8 +-
 arch/ia64/kernel/iosapic.c                 |    6 +-
 arch/ia64/kernel/irq.c                     |    4 +-
 arch/ia64/kernel/irq_ia64.c                |    4 +-
 arch/m32r/include/asm/spinlock.h           |   48 ++--
 arch/m32r/include/asm/spinlock_types.h     |    8 +-
 arch/m32r/kernel/irq.c                     |    4 +-
 arch/microblaze/kernel/irq.c               |    4 +-
 arch/mips/include/asm/spinlock.h           |   78 +++---
 arch/mips/include/asm/spinlock_types.h     |    8 +-
 arch/mips/kernel/irq.c                     |    4 +-
 arch/mips/vr41xx/common/icu.c              |   92 ++++----
 arch/mn10300/kernel/irq.c                  |    4 +-
 arch/parisc/include/asm/atomic.h           |   10 +-
 arch/parisc/include/asm/spinlock.h         |   64 +++---
 arch/parisc/include/asm/spinlock_types.h   |   12 +-
 arch/parisc/kernel/irq.c                   |    4 +-
 arch/parisc/lib/bitops.c                   |    4 +-
 arch/powerpc/include/asm/rtas.h            |    2 +-
 arch/powerpc/include/asm/spinlock.h        |   68 +++---
 arch/powerpc/include/asm/spinlock_types.h  |    8 +-
 arch/powerpc/kernel/irq.c                  |    8 +-
 arch/powerpc/kernel/rtas.c                 |   16 +-
 arch/powerpc/lib/locks.c                   |    8 +-
 arch/powerpc/platforms/52xx/media5200.c    |    8 +-
 arch/powerpc/platforms/cell/interrupt.c    |    8 +-
 arch/powerpc/platforms/iseries/irq.c       |    4 +-
 arch/powerpc/platforms/pasemi/setup.c      |   10 +-
 arch/powerpc/platforms/pseries/xics.c      |    4 +-
 arch/powerpc/sysdev/fsl_msi.c              |    4 +-
 arch/powerpc/sysdev/uic.c                  |    8 +-
 arch/s390/include/asm/spinlock.h           |   66 +++---
 arch/s390/include/asm/spinlock_types.h     |    8 +-
 arch/s390/lib/spinlock.c                   |   46 ++--
 arch/sh/include/asm/spinlock.h             |   58 +++---
 arch/sh/include/asm/spinlock_types.h       |    8 +-
 arch/sh/kernel/irq.c                       |    4 +-
 arch/sparc/include/asm/spinlock_32.h       |   62 +++---
 arch/sparc/include/asm/spinlock_64.h       |   54 ++--
 arch/sparc/include/asm/spinlock_types.h    |    8 +-
 arch/sparc/kernel/irq_64.c                 |    8 +-
 arch/um/kernel/irq.c                       |    4 +-
 arch/x86/include/asm/paravirt.h            |   14 +-
 arch/x86/include/asm/paravirt_types.h      |   14 +-
 arch/x86/include/asm/spinlock.h            |   62 +++---
 arch/x86/include/asm/spinlock_types.h      |   10 +-
 arch/x86/kernel/apic/io_apic.c             |    4 +-
 arch/x86/kernel/dumpstack.c                |    8 +-
 arch/x86/kernel/irq.c                      |   14 +-
 arch/x86/kernel/paravirt-spinlocks.c       |    4 +-
 arch/x86/kernel/tsc_sync.c                 |   10 +-
 arch/x86/xen/spinlock.c                    |   16 +-
 arch/xtensa/kernel/irq.c                   |    4 +-
 include/asm-generic/bitops/atomic.h        |   10 +-
 include/linux/hrtimer.h                    |    2 +-
 include/linux/init_task.h                  |    2 +-
 include/linux/irq.h                        |    2 +-
 include/linux/perf_event.h                 |    2 +-
 include/linux/plist.h                      |   43 +++-
 include/linux/rtmutex.h                    |    6 +-
 include/linux/rwlock.h                     |  125 +++++++++
 include/linux/rwlock_api_smp.h             |  282 +++++++++++++++++++++
 include/linux/rwlock_types.h               |   56 ++++
 include/linux/sched.h                      |    2 +-
 include/linux/spinlock.h                   |  377 ++++++++++++++++------------
 include/linux/spinlock_api_smp.h           |  360 +++++----------------------
 include/linux/spinlock_api_up.h            |   66 +++---
 include/linux/spinlock_types.h             |   92 ++++----
 include/linux/spinlock_types_up.h          |   12 +-
 include/linux/spinlock_up.h                |   42 ++--
 kernel/exit.c                              |    2 +-
 kernel/fork.c                              |    4 +-
 kernel/futex.c                             |   50 ++--
 kernel/hrtimer.c                           |   50 ++--
 kernel/hw_breakpoint.c                     |    4 +-
 kernel/irq/autoprobe.c                     |   20 +-
 kernel/irq/chip.c                          |   86 ++++----
 kernel/irq/handle.c                        |   22 +-
 kernel/irq/internals.h                     |    2 +-
 kernel/irq/manage.c                        |   50 ++--
 kernel/irq/migration.c                     |    2 +-
 kernel/irq/numa_migrate.c                  |    8 +-
 kernel/irq/pm.c                            |    8 +-
 kernel/irq/proc.c                          |    4 +-
 kernel/irq/spurious.c                      |   14 +-
 kernel/lockdep.c                           |   20 +-
 kernel/mutex-debug.h                       |   12 +-
 kernel/perf_event.c                        |  106 ++++----
 kernel/rtmutex-debug.c                     |    4 +-
 kernel/rtmutex.c                           |  106 ++++----
 kernel/sched.c                             |  223 +++++++++--------
 kernel/sched_cpupri.c                      |   10 +-
 kernel/sched_cpupri.h                      |    2 +-
 kernel/sched_debug.c                       |    4 +-
 kernel/sched_fair.c                        |    4 +-
 kernel/sched_idletask.c                    |    4 +-
 kernel/sched_rt.c                          |   60 +++---
 kernel/smp.c                               |   32 ++--
 kernel/spinlock.c                          |  306 +++++++++++-----------
 kernel/time/clockevents.c                  |   14 +-
 kernel/time/tick-broadcast.c               |   42 ++--
 kernel/time/tick-common.c                  |   20 +-
 kernel/time/tick-internal.h                |    1 -
 kernel/time/timer_list.c                   |    6 +-
 kernel/time/timer_stats.c                  |   17 +-
 kernel/trace/ring_buffer.c                 |   16 +-
 kernel/trace/trace.c                       |   50 ++--
 kernel/trace/trace_clock.c                 |    8 +-
 kernel/trace/trace_sched_wakeup.c          |   16 +-
 kernel/trace/trace_selftest.c              |    4 +-
 kernel/trace/trace_stack.c                 |   16 +-
 lib/debugobjects.c                         |   74 +++---
 lib/kernel_lock.c                          |   22 +-
 lib/plist.c                                |    8 +-
 lib/spinlock_debug.c                       |   64 +++---
 136 files changed, 2394 insertions(+), 2086 deletions(-)
 create mode 100644 include/linux/rwlock.h
 create mode 100644 include/linux/rwlock_api_smp.h
 create mode 100644 include/linux/rwlock_types.h


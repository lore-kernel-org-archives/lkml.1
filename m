Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYJTTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYJTTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJTTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:31:27 -0400
Received: from www.tglx.de ([62.245.132.106]:51960 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbYJTTb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:31:26 -0400
Date: Mon, 20 Oct 2008 21:30:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer updates for 2.6.28
Message-ID: <alpine.LFD.2.00.0810202059330.3301@apollo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest v28-timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git v28-timers-for-linus

Fixlets, improvements and janitorial work.

Full patch available at: http://userweb.kernel.org/~tglx/v28-timers-for-linus.patch

Thanks,

	tglx

------------------>
Andi Kleen (1):
      Fix documentation of sysrq-q

David Howells (1):
      clocksource: check range

Frank Mayhar (3):
      timers: fix itimer/many thread hang
      timers: fix itimer/many thread hang, v2
      timers: fix itimer/many thread hang, v3

Ingo Molnar (4):
      timers: fix itimer/many thread hang, fix
      timers: fix itimer/many thread hang, fix #2
      timers: fix itimer/many thread hang, cleanups
      timers: fix itimer/many thread hang, fix

John Stultz (2):
      clocksource: keep track of original clocksource frequency
      clocksource: introduce CLOCK_MONOTONIC_RAW

Maciej W. Rozycki (1):
      ntp: let update_persistent_clock() sleep

Mark McLoughlin (2):
      hrtimer: remove hrtimer_clock_base::get_softirq_time()
      hrtimer: remove hrtimer_clock_base::reprogram()

Oleg Nesterov (10):
      migrate_timers: add comment, use spinlock_irq()
      posix-timers: don't switch to ->group_leader if ->it_process dies
      posix-timers: always do get_task_struct(timer->it_process)
      posix-timers: sys_timer_create: remove the buggy PF_EXITING check
      posix-timers: sys_timer_create: simplify and s/tasklist/rcu/
      posix-timers: move the initialization of timer->sigq from send to create path
      posix-timers: sys_timer_create: cleanup the error handling
      posix-timers: kill ->it_sigev_signo and ->it_sigev_value
      posix-timers: lock_timer: kill the bogus ->it_id check
      posix-timers: lock_timer: make it readable

Richard Kennedy (1):
      hrtimer: reorder struct hrtimer to save 8 bytes on 64bit builds

Roman Zippel (4):
      clocksource: introduce clocksource_forward_now()
      ntp: fix ADJ_OFFSET_SS_READ bug and do_adjtimex() cleanup
      timekeeping: fix rounding problem during clock update
      ntp: improve adjtimex frequency rounding

Thomas Gleixner (7):
      NOHZ: unify the nohz function calls in irq_enter()
      NOHZ: split tick_nohz_restart_sched_tick()
      NOHZ: restart tick device from irq_enter()
      timer_list: print real timer address
      timer_list: print cpu number of clockevents device
      timer_list: add base address to clock base
      fix documentation of sysrq-q really


 Documentation/sysrq.txt       |    3 +-
 drivers/char/sysrq.c          |    2 +-
 drivers/clocksource/acpi_pm.c |    7 +-
 fs/binfmt_elf.c               |   19 +-
 fs/proc/array.c               |    8 +-
 include/linux/clocksource.h   |   14 +-
 include/linux/hrtimer.h       |   10 +-
 include/linux/kernel_stat.h   |    1 +
 include/linux/posix-timers.h  |    4 +-
 include/linux/sched.h         |   84 ++++++-
 include/linux/tick.h          |    7 +-
 include/linux/time.h          |    5 +
 include/linux/timex.h         |   11 +-
 kernel/compat.c               |   53 ++---
 kernel/exit.c                 |   19 +-
 kernel/fork.c                 |   92 ++++----
 kernel/hrtimer.c              |   15 +-
 kernel/itimer.c               |   33 +--
 kernel/posix-cpu-timers.c     |  512 +++++++++++++++++++++--------------------
 kernel/posix-timers.c         |  153 +++++--------
 kernel/sched.c                |   19 +-
 kernel/sched_fair.c           |    1 +
 kernel/sched_rt.c             |    4 +-
 kernel/sched_stats.h          |   86 +++++++
 kernel/signal.c               |    8 +-
 kernel/softirq.c              |   10 +-
 kernel/sys.c                  |   75 ++----
 kernel/time/clocksource.c     |    3 +
 kernel/time/jiffies.c         |    1 +
 kernel/time/ntp.c             |   93 ++++----
 kernel/time/tick-broadcast.c  |   13 +
 kernel/time/tick-internal.h   |    2 +
 kernel/time/tick-sched.c      |   93 +++++---
 kernel/time/timekeeping.c     |  122 +++++++----
 kernel/time/timer_list.c      |   20 +-
 kernel/timer.c                |   11 +-
 security/selinux/hooks.c      |    9 +-
 37 files changed, 902 insertions(+), 720 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYJQUHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYJQUHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYJQUHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:07:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:45814 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYJQUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:07:11 -0400
Date: Fri, 17 Oct 2008 13:07:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tglx@tglx.de
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: updated range-hrtimers tree uploaded
Message-ID: <20081017130714.6c32a39d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I've merged the latest Linus tree into the range-hrtimer tree (there
were a few trivial conflicts due to the many patches in the first part
of the merge window) and pushed it to the git-repo.



The following changes since commit 2e532d68a2b3e2aa6b19731501222069735c741c:
  Linus Torvalds (1):
        {pci,pnp} quirks.c: don't use deprecated print_fn_descriptor_symbol()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git for-linus

The range-hrtimer series significantly improves the quality of behavior of the select()
and poll() system calls, as well as using timer ranges to optimize the power impact
of these timers.

Arjan van de Ven (29):
      select: Introduce a hrtimeout function
      select: switch select() and poll() over to hrtimers
      hrtimer: add abstraction functions for accessing the "expires" member
      hrtimer: convert kvm to the new hrtimer apis
      hrtimer: convert timerfd to the new hrtimer apis
      hrtimer: convert net::sched_cbq to the new hrtimer apis
      hrtimer: convert kernel/* to the new hrtimer apis
      hrtimer: convert powerpc/oprofile to the new hrtimer apis
      hrtimer: convert kvm-ia64 to the new hrtimer apis
      hrtimer: convert s390 to the new hrtimer apis
      hrtimer: convert sound/ to the new hrtimer apis
      hrtimer: rename the "expires" struct member to avoid accidental usage
      hrtimer: turn hrtimers into range timers
      hrtimer: create a "timer_slack" field in the task struct
      hrtimer: make select() and poll() use the hrtimer range feature
      hrtimer: fix build bug found by Ingo
      hrtimer: another build fix
      hrtimer: add a hrtimer_start_range() function
      hrtimer: incorporate feedback from Peter Zijlstra
      hrtimer: show the timer ranges in /proc/timer_list
      hrtimer: fix signed/unsigned bug in slack estimator
      hrtimer: make the nanosleep() syscall use the per process slack
      hrtimer: make the futex() system call use the per process slack value
      hrtimer: peek at the timer queue just before going idle
      select: fix alpha OSF wrapper
      rangetimer: fix x86 build failure for the !HRTIMERS case
      rangetimer: fix BUG_ON reported by Ingo
      rangetimers: fix the bug reported by Ingo for real
      Merge commit 'linus/master' into merge-linus

Stephen Rothwell (1):
      DECLARE_PER_CPU needs linux/percpu.h

Thomas Gleixner (3):
      select: add a timespec_add_safe() function
      select: add poll_select_set_timeout() and poll_select_copy_remaining() helpers
      select: add a poll specific struct to the restart_block union

 arch/alpha/kernel/osf_sys.c               |   13 +-
 arch/ia64/kvm/kvm-ia64.c                  |    2 +-
 arch/powerpc/oprofile/cell/spu_profiler.c |    2 +-
 arch/x86/kvm/i8254.c                      |    8 +-
 arch/x86/kvm/lapic.c                      |    6 +-
 drivers/cpuidle/cpuidle.c                 |    7 +
 drivers/s390/crypto/ap_bus.c              |    6 +-
 fs/compat.c                               |  187 +++++---------
 fs/select.c                               |  396 ++++++++++++++++-------------
 fs/timerfd.c                              |    8 +-
 include/linux/hrtimer.h                   |   96 +++++++-
 include/linux/init_task.h                 |    1 +
 include/linux/poll.h                      |    8 +-
 include/linux/prctl.h                     |    7 +
 include/linux/sched.h                     |    6 +
 include/linux/thread_info.h               |    8 +
 include/linux/time.h                      |    4 +
 kernel/fork.c                             |    2 +
 kernel/futex.c                            |   11 +-
 kernel/hrtimer.c                          |  212 ++++++++++++++--
 kernel/posix-timers.c                     |   10 +-
 kernel/rtmutex.c                          |    3 +-
 kernel/sched.c                            |    7 +-
 kernel/sys.c                              |   10 +
 kernel/time.c                             |   18 ++
 kernel/time/ntp.c                         |    3 +-
 kernel/time/tick-sched.c                  |   21 +-
 kernel/time/timer_list.c                  |    8 +-
 net/sched/sch_cbq.c                       |    7 +-
 sound/drivers/pcsp/pcsp_lib.c             |    5 +-
 30 files changed, 706 insertions(+), 376 deletions(-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYITSDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYITSDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 14:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYITSDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 14:03:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:49489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbYITSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 14:03:42 -0400
Date: Sat, 20 Sep 2008 11:03:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, torvalds@linux-foundation.org, tglx@tglx.de
Subject: What's in hrtimer.git for 2.6.28
Message-ID: <20080920110343.6b68876c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hrtimer.git tree contains the patches that turn select/poll/etc into
nanosecond accurate userland APIs (using hrtimers), increasing the
quality of behavior that Linux gives to desktop and multimedia apps.

In addition, this patchkit also turns hrtimers into so called "range
timers", which counters (and in fact improves) the power effects of
using hrtimers for select/poll.

These patches have been posted to lkml and in addition LWN had an
article about this series in its weekly kernel section.
 

Updating linus
The following changes since commit 9824b8f11373b0df806c135a342da9319ef1d893:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.osdl.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git master

Arjan van de Ven (24):
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

Thomas Gleixner (3):
      select: add a timespec_add_safe() function
      select: add poll_select_set_timeout() and poll_select_copy_remaining() helpers
      select: add a poll specific struct to the restart_block union

 arch/ia64/kvm/kvm-ia64.c                  |    2 +-
 arch/powerpc/oprofile/cell/spu_profiler.c |    2 +-
 arch/x86/kvm/i8254.c                      |    6 +-
 arch/x86/kvm/lapic.c                      |    6 +-
 drivers/cpuidle/cpuidle.c                 |    7 +
 drivers/s390/crypto/ap_bus.c              |    6 +-
 fs/compat.c                               |  187 +++++---------
 fs/select.c                               |  396 ++++++++++++++++-------------
 fs/timerfd.c                              |    8 +-
 include/linux/hrtimer.h                   |   92 +++++++-
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
 29 files changed, 694 insertions(+), 369 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

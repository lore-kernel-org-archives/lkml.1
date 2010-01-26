Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510Ab0AZE1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0AZE1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668Ab0AZE1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:64461 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0AZE1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:20 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: [PATCH 0/4] kgdb regression fixes for 2.6.33
Date: Mon, 25 Jan 2010 22:26:36 -0600
Message-Id: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 26 Jan 2010 04:26:44.0411 (UTC) FILETIME=[C42110B0:01CA9E3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to get acks from the respective parties to fix these
reported regressions against kgdb in 2.6.33.

I imagine the constraints for the hw breakpoint API is possibly still
a dicey issue, so it is split into its own patch.  Even without the
constraints patch it is possible to use hw breakpoints in the kernel
debugger in the same manner that has existed since 2.6.26 (only kgdb
gets to use hw breakpoints).

The regression are:
  * hw breakpoints no longer work on x86 after the perf API merge
  * clocksource watchdog can dead lock while in the kernel debugger
  * softlockup watchdog can reboot the system while using the kernel debugger

I collected all the patches which could go into the tip branch or the
kgdb for_linus branch at the following location depending on the
status of the discussion that ensues.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_igno

Thanks,
Jason.


---
The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jason Wessel (4):
      x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
      perf,hw_breakpoint: add lockless reservation for hw_breaks
      kgdb,clocksource: Prevent kernel hang in kernel debugger
      softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume

 arch/x86/kernel/hw_breakpoint.c |    5 +-
 arch/x86/kernel/kgdb.c          |  216 ++++++++++++++++++++++++++++-----------
 include/linux/perf_event.h      |    1 +
 include/linux/sched.h           |    4 +
 kernel/hw_breakpoint.c          |   16 +++
 kernel/kgdb.c                   |    9 +-
 kernel/softlockup.c             |   15 +++
 kernel/time/clocksource.c       |    7 +-
 8 files changed, 205 insertions(+), 68 deletions(-)

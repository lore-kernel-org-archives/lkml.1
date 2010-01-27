Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279Ab0A0W1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0A0W1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230Ab0A0W1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:27:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:54931 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0A0W1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:27:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: [PATCH 0/3] V2 kgdb regression fixes for 2.6.33
Date: Wed, 27 Jan 2010 16:25:21 -0600
Message-Id: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 27 Jan 2010 22:26:24.0782 (UTC) FILETIME=[C2A6FAE0:01CA9F9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to get acks from the respective parties to fix these
reported regressions against kgdb in 2.6.33.

The constraints for the hw breakpoint API is possibly was definitely a
dicey issue, but is hopefully resolved in this series.  Even without
the constraints patch it is possible to use hw breakpoints in the
kernel debugger in the same manner that has existed since 2.6.26 (only
kgdb gets to use hw breakpoints).

The regression are:
  * hw breakpoints no longer work on x86 after the perf API merge
  * softlockup watchdog can reboot the system while using the kernel debugger
    *** This has been in linux-next for several months waiting for acks

Dropped from the series was the clocksource patch, it was resolved
separately.

I collected all the patches which could go into the tip branch or the
kgdb for_linus branch at the following location depending on the
status of the discussion that ensues.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_igno

Thanks,
Jason.

---

The following changes since commit be8cde8b24c9dca1e54598690115eee5b1476519:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-rc-fixes-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jason Wessel (3):
      softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
      x86,hw_breakpoint,kgdb: kgdb to use hw_breakpoint API
      perf,hw_breakpoint,kgdb: No mutex taken for kernel debugger

 arch/x86/kernel/hw_breakpoint.c |    5 +-
 arch/x86/kernel/kgdb.c          |  251 ++++++++++++++++++++++++++++++---------
 include/linux/hw_breakpoint.h   |    2 +
 include/linux/sched.h           |    4 +
 kernel/hw_breakpoint.c          |   52 +++++++--
 kernel/kgdb.c                   |    9 +-
 kernel/softlockup.c             |   15 +++
 7 files changed, 264 insertions(+), 74 deletions(-)

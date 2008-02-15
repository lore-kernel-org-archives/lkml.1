Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbYBOUzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbYBOUzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYBOUzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:55857 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbYBOUzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] kgdb-light-v10: proposed fixes
Date: Fri, 15 Feb 2008 14:55:51 -0600
Message-Id: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 15 Feb 2008 20:55:32.0687 (UTC) FILETIME=[1AD54DF0:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for kgdb-light-v10 to address some regressions,
and further the RFC against kgdb core as a module.

All of these patches are up for consideration to be collapsed into the
kgdb-light tree for an upstream merge pending review. The kgdb core as
a module patch will be kept separate because the kernel.org community
may or may not object to exposing too many low level exports.

The following changes since commit 2680c15446821264fa3c2278e584974f2feb97b4:
  Jason Wessel (1):
        Merge branch 'master' of git://git.kernel.org/.../mingo/linux-2.6-kgdb

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_ingo

Jan Kiszka (1):
      kgdb: build core and arch pieces as a kernel module

Jason Wessel (6):
      kgdb: fix kgdboc dynamic module configuration
      kgdb: fix NMI hangs
      kgdb: clocksource watchdog
      kgdb: print breakpoint removed on exception
      kgdb: x86 HW breakpoints
      kgdb: move the kgdb core and arch implementation

 arch/x86/kernel/Makefile               |    4 +-
 arch/x86/kernel/{kgdb.c => kgdb-x86.c} |  167 +++++++++++++++++++++++++++++---
 arch/x86/kernel/reboot.c               |    1 +
 arch/x86/kernel/setup64.c              |   14 +++
 arch/x86/kernel/smp_32.c               |    6 +
 arch/x86/kernel/smp_64.c               |    5 +
 arch/x86/kernel/traps_32.c             |    2 +
 arch/x86/kernel/traps_64.c             |    2 +
 drivers/serial/kgdboc.c                |    7 +-
 include/asm-x86/kdebug.h               |    1 +
 include/asm-x86/smp_32.h               |    5 +
 include/asm-x86/smp_64.h               |    4 +
 include/linux/clocksource.h            |    1 +
 kernel/Makefile                        |    1 -
 kernel/sched.c                         |    1 +
 kernel/time/clocksource.c              |   13 +++
 lib/Kconfig.kgdb                       |    2 +-
 {kernel => lib}/kgdb.c                 |   19 +++-
 18 files changed, 234 insertions(+), 21 deletions(-)
 rename arch/x86/kernel/{kgdb.c => kgdb-x86.c} (78%)
 rename {kernel => lib}/kgdb.c (99%)



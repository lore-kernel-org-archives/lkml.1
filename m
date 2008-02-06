Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYBFOsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYBFOsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYBFOr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:47:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYBFOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:47:57 -0500
Date: Wed, 6 Feb 2008 15:47:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080206144741.GA18657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Shortlog attached below.

It includes 16 x86 fixes, and 4 general fixes:

   - brk randomization fixes for ancient binaries
   - virtio trivial fix (acked by Rusty)
   - __FINITDATA added to include/linux/init.h [relied on by an x86 fix]
   - include/linux/cpuidle.h trivial sparse fix

there's also a MAINTAINERS file update for the new RDC R-321X SoC x86 
subarch. Thanks,

	Ingo

------------------>
Arjan van de Ven (2):
      x86: mark the .rodata section also NX
      x86: remove suprious ifdefs from pageattr.c

Florian Fainelli (1):
      MAINTAINERS: RDC R-321x SoC maintainer

Harvey Harrison (4):
      x86: trivial sparse/checkpatch in quirks.c
      x86: fix sparse error in traps_32.c
      x86: fix sparse warnings in powernow-k8.c
      cpuidle: dubious one-bit signed bitfield in cpuidle.h

Ingo Molnar (6):
      x86: remove X2 workaround
      brk randomization: introduce CONFIG_COMPAT_BRK
      generic: add __FINITDATA
      x86: delay CPA self-test and repeat it
      virtio: fix trivial build bug
      x86: fix deadlock, make pgd_lock irq-safe

Jiri Kosina (1):
      brk: check the lower bound properly

Roland McGrath (3):
      x86: make traps on entry code be debuggable in user space, 64-bit
      x86 ptrace: disallow null cs/ss
      x86: fix iret exception recovery on 64-bit

Sam Ravnborg (1):
      x86: fix 64-bit sections

Thomas Gleixner (1):
      x86: make spurious fault handler aware of large mappings

Yinghai Lu (1):
      x86: fix mttr trimming

 MAINTAINERS                               |    6 +++
 arch/x86/Kconfig.debug                    |    4 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    1 -
 arch/x86/kernel/cpu/mtrr/main.c           |   17 ++++----
 arch/x86/kernel/entry_64.S                |   30 ++++++++++----
 arch/x86/kernel/head_64.S                 |   15 ++----
 arch/x86/kernel/ptrace.c                  |   25 ++++++++++-
 arch/x86/kernel/quirks.c                  |   26 ++++++------
 arch/x86/kernel/test_nx.c                 |    2 +-
 arch/x86/kernel/traps_32.c                |   15 ++----
 arch/x86/mm/fault.c                       |   23 ++++++++---
 arch/x86/mm/init_64.c                     |    9 ++++-
 arch/x86/mm/pageattr-test.c               |   65 ++++++++++++++++++++++------
 arch/x86/mm/pageattr.c                    |   14 ------
 drivers/virtio/virtio_balloon.c           |    1 +
 fs/binfmt_elf.c                           |    2 +-
 include/asm-x86/pgalloc_64.h              |   10 +++--
 include/linux/cpuidle.h                   |    2 +-
 include/linux/init.h                      |    1 +
 init/Kconfig                              |   12 +++++
 mm/memory.c                               |   13 +++++-
 mm/mmap.c                                 |    2 +-
 22 files changed, 196 insertions(+), 99 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0CICdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:33:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:55385 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0CICdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:33:41 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 13:33:01 +1100
Message-ID: <1268101981.22204.140.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Ideally this should have reached you earlier last week but I was
bogged down in meetings and then away on an extended week-end.

It's mostly a few bug fixes, some trivial raw spinlock conversions,
and a couple of "features" that I didn't have in my previous merge
request for all the wrong reasons, which are the e500 perf support
and the dynamic PACA stuff from Michael.

Cheers,
Ben.

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Adam Lackorzynski (1):
      powerpc: Fix SMP build with disabled CPU hotplugging.

Andrea Gelmini (1):
      powerpc/cpm2: Checkpatch cleanup

Anton Vorontsov (4):
      powerpc/85xx: Convert socrates_fpga_pic_lock to raw_spinlock
      powerpc/82xx: Convert pci_pic_lock to raw_spinlock
      powerpc/qe: Convert qe_ic_lock to raw_spinlock
      powerpc/86xx: Convert gef_pic_lock to raw_spinlock

Benjamin Herrenschmidt (1):
      Merge commit 'kumar/next' into merge

Dave Kleikamp (2):
      powerpc/booke: Fix a couple typos in the advanced ptrace code
      powerpc/booke: Fix breakpoint/watchpoint one-shot behavior

Josh Boyer (1):
      powerpc: Fix G5 thermal shutdown

Mark Nelson (1):
      powerpc/pseries: Pass CPPR value to H_XIRR hcall

Martyn Welch (1):
      powerpc/86xx: Renaming following split of GE Fanuc joint venture

Michael Ellerman (1):
      powerpc: Dynamically allocate pacas

Scott Wood (2):
      powerpc/perf: Build callchain code regardless of hardware event support.
      powerpc/perf: e500 support

Vaidyanathan Srinivasan (3):
      powerpc: Reset kernel stack on cpu online from cede state
      powerpc: Move checks in pseries_mach_cpu_die()
      powerpc: Reduce printk from pseries_mach_cpu_die()

 arch/powerpc/boot/dts/gef_ppc9a.dts             |    4 +-
 arch/powerpc/boot/dts/gef_sbc310.dts            |    4 +-
 arch/powerpc/boot/dts/gef_sbc610.dts            |    4 +-
 arch/powerpc/include/asm/paca.h                 |   18 +-
 arch/powerpc/include/asm/perf_event.h           |  109 +----
 arch/powerpc/include/asm/perf_event_fsl_emb.h   |   50 ++
 arch/powerpc/include/asm/perf_event_server.h    |  110 ++++
 arch/powerpc/include/asm/reg_booke.h            |    4 +-
 arch/powerpc/include/asm/reg_fsl_emb.h          |    2 +-
 arch/powerpc/kernel/Makefile                    |    7 +-
 arch/powerpc/kernel/cputable.c                  |    2 +-
 arch/powerpc/kernel/e500-pmu.c                  |  129 +++++
 arch/powerpc/kernel/head_64.S                   |   17 +-
 arch/powerpc/kernel/paca.c                      |   93 +++-
 arch/powerpc/kernel/perf_event_fsl_emb.c        |  654 +++++++++++++++++++++++
 arch/powerpc/kernel/prom.c                      |    3 +
 arch/powerpc/kernel/ptrace.c                    |   12 +-
 arch/powerpc/kernel/setup-common.c              |    3 +
 arch/powerpc/kernel/setup_64.c                  |   12 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c    |   10 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c |   34 +-
 arch/powerpc/platforms/86xx/Kconfig             |   12 +-
 arch/powerpc/platforms/86xx/gef_gpio.c          |   10 +-
 arch/powerpc/platforms/86xx/gef_pic.c           |   20 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c         |   12 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c        |   12 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c        |   12 +-
 arch/powerpc/platforms/Kconfig.cputype          |   10 +
 arch/powerpc/platforms/iseries/exception.S      |   25 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   42 +-
 arch/powerpc/platforms/pseries/offline_states.h |   23 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    4 +-
 arch/powerpc/platforms/pseries/xics.c           |    7 +-
 arch/powerpc/sysdev/cpm2_pic.h                  |    2 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c              |   10 +-
 drivers/macintosh/therm_pm72.c                  |   30 +-
 drivers/macintosh/therm_pm72.h                  |    2 +-
 37 files changed, 1250 insertions(+), 264 deletions(-)
 create mode 100644 arch/powerpc/include/asm/perf_event_fsl_emb.h
 create mode 100644 arch/powerpc/include/asm/perf_event_server.h
 create mode 100644 arch/powerpc/kernel/e500-pmu.c
 create mode 100644 arch/powerpc/kernel/perf_event_fsl_emb.c



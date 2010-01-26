Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616Ab0AZA4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0AZA4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576Ab0AZA4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:56:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35570
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab0AZA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:56:32 -0500
Date: Mon, 25 Jan 2010 16:56:44 -0800 (PST)
Message-Id: <20100125.165644.197238824.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Use rlimit helpers, from Jiri Slaby.

2) Use arch_gettimeoffset() in sparc32.

3) Simplify asm/param.h by using asm-generic/param.h

4) Central board driver sets up leds_resource erroneously, fix from
   Roel Kluin.

5) Fix copy_from_user() return on error, from Heiko Carstens.

6) Page fault perf SW events not being counted.

7) IRQ ->set_affinity() using wrong cpu mask, thanks to Ben H. for
   noticing.

8) page_to_phys() calculations completely busted on sparc32.

9) cpumask_of_node() fix to handle -1 properly from Anton Blanchard.

10) Perf callchain support and full support of both PMU counters
    on sparc64.

Please pull, thanks a lot!

The following changes since commit f6760aa024199cfbce564311dc4bc4d47b6fb349:
  Linus Torvalds (1):
        Merge branch 'timers-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Anton Blanchard (1):
      sparc: cpumask_of_node() should handle -1 as a node

David S. Miller (7):
      sparc32: Update defconfig.
      sparc32: Fix page_to_phys().
      sparc64: Add perf callchain support.
      sparc64: Fully support both performance counters.
      sparc: Add missing SW perf fault events.
      sparc64: Update defconfig.
      sparc64: Fix IRQ ->set_affinity() methods.

Heiko Carstens (1):
      sparc: copy_from_user() should not return -EFAULT

Jiri Slaby (1):
      SPARC: use helpers for rlimits

John Stultz (1):
      sparc: convert to arch_gettimeoffset()

Robert P. J. Day (1):
      sparc: Simplify param.h by simply including <asm-generic/param.h>

Roel Kluin (1):
      sparc: leds_resource.end assigned to itself in clock_board_probe()

 arch/sparc/Kconfig                   |    5 +-
 arch/sparc/configs/sparc32_defconfig |   87 ++++-
 arch/sparc/configs/sparc64_defconfig |  131 ++++++--
 arch/sparc/include/asm/io_32.h       |    2 +-
 arch/sparc/include/asm/page_32.h     |    2 +-
 arch/sparc/include/asm/param.h       |   19 +-
 arch/sparc/include/asm/timex_32.h    |    1 +
 arch/sparc/include/asm/topology_64.h |    4 +-
 arch/sparc/include/asm/uaccess_32.h  |    2 +-
 arch/sparc/include/asm/uaccess_64.h  |    2 +-
 arch/sparc/kernel/central.c          |    4 +-
 arch/sparc/kernel/irq_64.c           |   37 ++-
 arch/sparc/kernel/pcic.c             |  103 +-----
 arch/sparc/kernel/perf_event.c       |  627 +++++++++++++++++++++++++---------
 arch/sparc/kernel/sys_sparc_64.c     |    6 +-
 arch/sparc/kernel/time_32.c          |  116 ++-----
 arch/sparc/mm/fault_32.c             |   12 +-
 arch/sparc/mm/fault_64.c             |   13 +-
 18 files changed, 749 insertions(+), 424 deletions(-)

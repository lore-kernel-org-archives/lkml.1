Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZFPMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZFPMXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZFPMXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:23:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36934
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbZFPMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:23:41 -0400
Date: Tue, 16 Jun 2009 05:23:44 -0700 (PDT)
Message-Id: <20090616.052344.242315717.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sparc updates for 2.6.31:

1) Use dynamic per-cpu allocator on sparc64.

2) Wire up new syscall.

3) sparc64 FTRACE touchups

4) SBUS video driver cleanups and fixups from Krzystof Helt

5) DMA interface consolidation from FUJITA Tomonori

6) of_device layer commonization from Robert Reif

7) cpumask usage fixup from Stephen Rothwell

Please pull, thanks a lot!

The following changes since commit 03347e2592078a90df818670fddf97a33eec70fb:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

David S. Miller (16):
      sparc64: Reclaim trap_block[]->hdesc
      sparc64: Move trap_block[] definitions into a new header file.
      sparc64: Store per-cpu offset in trap_block[]
      sparc64: Use BUILD_BUG_ON() in trap_init().
      sparc64: Refactor OBP cpu scanning code using an iterator.
      sparc64: Refactor MDESC cpu scanning code using an iterator.
      sparc: Call OF and MD cpu scanning explicitly from paging_init()
      sparc64: Make mdesc_fill_in_cpu_data take a cpumask_t pointer.
      sparc64: Defer cpu_data() setup until end of per-cpu data initialization.
      sparc64: Get rid of real_setup_per_cpu_areas().
      sparc64: Only allocate per-cpu areas for possible cpus.
      sparc64: Use new dynamic per-cpu allocator.
      sparc64: Add proper dynamic ftrace support.
      openprom: Squelch useless GCC warning.
      sparc: Wire up sys_rt_tgsigqueueinfo().
      sparc64: Update defconfig.

FUJITA Tomonori (4):
      sparc: move the duplication in dma-mapping_{32|64}.h to dma-mapping.h
      sparc: add sync_single_for_device and sync_sg_for_device to struct dma_ops
      sparc: use dma_map_page instead of dma_map_single
      sparc: remove dma-mapping_{32|64}.h

Hong H. Pham (1):
      sparc64: fix and optimize irq distribution

Krzysztof Helt (6):
      bw2: use standard fields for framebuffer physical address and length
      cg14: use standard fields for framebuffer physical address and length
      cg3: use standard fields for framebuffer physical address and length
      cg6: use standard fields for framebuffer physical address and length
      leo: use standard fields for framebuffer physical address and length
      p9100: use standard fields for framebuffer physical address and length

Robert P. J. Day (1):
      sparc: Simplify code using is_power_of_2() routine.

Robert Reif (1):
      sparc: move of_device common code to of_device_common

Stephen Rothwell (1):
      sparc: replace uses of CPU_MASK_ALL_PTR

 arch/sparc/Kconfig                      |    5 +
 arch/sparc/configs/sparc64_defconfig    |   63 ++++--
 arch/sparc/include/asm/cpudata_64.h     |  197 +--------------
 arch/sparc/include/asm/dma-mapping.h    |  168 ++++++++++++-
 arch/sparc/include/asm/dma-mapping_32.h |   60 -----
 arch/sparc/include/asm/dma-mapping_64.h |  154 -----------
 arch/sparc/include/asm/ftrace.h         |   11 +
 arch/sparc/include/asm/mdesc.h          |    3 +-
 arch/sparc/include/asm/percpu_64.h      |    8 +-
 arch/sparc/include/asm/prom.h           |    2 +
 arch/sparc/include/asm/trap_block.h     |  207 +++++++++++++++
 arch/sparc/include/asm/unistd.h         |    3 +-
 arch/sparc/kernel/Makefile              |    2 +
 arch/sparc/kernel/cpumap.c              |  431 +++++++++++++++++++++++++++++++
 arch/sparc/kernel/cpumap.h              |   16 ++
 arch/sparc/kernel/dma.c                 |  127 +++-------
 arch/sparc/kernel/ds.c                  |    3 +-
 arch/sparc/kernel/ftrace.c              |   47 +++-
 arch/sparc/kernel/head_64.S             |   22 --
 arch/sparc/kernel/iommu.c               |   15 +-
 arch/sparc/kernel/irq_64.c              |   29 +--
 arch/sparc/kernel/mdesc.c               |  149 +++++++-----
 arch/sparc/kernel/of_device_32.c        |  195 +--------------
 arch/sparc/kernel/of_device_64.c        |  188 +-------------
 arch/sparc/kernel/of_device_common.c    |  174 +++++++++++++
 arch/sparc/kernel/of_device_common.h    |   36 +++
 arch/sparc/kernel/pci_sun4v.c           |   15 +-
 arch/sparc/kernel/prom.h                |    1 -
 arch/sparc/kernel/prom_64.c             |  232 +++++++++--------
 arch/sparc/kernel/prom_common.c         |    2 -
 arch/sparc/kernel/smp_64.c              |  196 ++++++++++++--
 arch/sparc/kernel/systbls_32.S          |    4 +-
 arch/sparc/kernel/systbls_64.S          |    6 +-
 arch/sparc/kernel/traps_64.c            |  170 +++++++------
 arch/sparc/mm/init_32.c                 |    1 +
 arch/sparc/mm/init_64.c                 |   16 +-
 arch/sparc/mm/srmmu.c                   |    3 +-
 drivers/sbus/char/openprom.c            |    2 +-
 drivers/video/bw2.c                     |   20 +-
 drivers/video/cg14.c                    |   19 +-
 drivers/video/cg3.c                     |   20 +-
 drivers/video/cg6.c                     |   25 +-
 drivers/video/leo.c                     |   14 +-
 drivers/video/p9100.c                   |   20 +-
 scripts/recordmcount.pl                 |   20 ++
 45 files changed, 1751 insertions(+), 1350 deletions(-)
 delete mode 100644 arch/sparc/include/asm/dma-mapping_32.h
 delete mode 100644 arch/sparc/include/asm/dma-mapping_64.h
 create mode 100644 arch/sparc/include/asm/trap_block.h
 create mode 100644 arch/sparc/kernel/cpumap.c
 create mode 100644 arch/sparc/kernel/cpumap.h
 create mode 100644 arch/sparc/kernel/of_device_common.c
 create mode 100644 arch/sparc/kernel/of_device_common.h

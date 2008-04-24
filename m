Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYDXLCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYDXLCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYDXLCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:02:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50125
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbYDXLCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:02:40 -0400
Date: Thu, 24 Apr 2008 04:02:39 -0700 (PDT)
Message-Id: <20080424.040239.193699673.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several Sparc updates for 2.6.26:

1) NUMA support, detection is added for Niagara machines.
   Support for detection on older systems will be forthcoming.

2) Make use of an unused field in pt_regs to store both
   a magic number, and the trap number, this allows:

   a) Removing the funny passing of the "restart_syscall"
      boolean in the trap return paths to the signal dispatch.

   b) Allow more accurate stack backtraces, since we have the
      magic cookie, we can detect trap frames accurately.

   c) The UTRACE guys want to be able to detect if a thread
      off the cpu is in a system call, they can do that trivially
      now just like they can on x86.

   In fact much of this idea is from Roland McGrath.

3) Two cleanups from Adrian Bunk that are possible as a result
   of the SunOS/Solaris support removal.

Please pull, thanks a lot!

The following changes since commit 807501475fce0ebe68baedf87f202c3e4ee0d12c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Adrian Bunk (2):
      sparc: cleanup after SunOS binary emulation removal
      sparc64: cleanup after SunOS/Solaris binary emulation removal

David S. Miller (20):
      [LMB]: Fix lmb allocation regression.
      [SPARC64]: Move ramdisk discovery code out to seperate function.
      [SPARC64]: Initialize LMB tables.
      [SPARC64]: Start using LMB information in bootmem_init().
      [SPARC64]: Fully use LMB information in bootmem_init().
      [SPARC64]: Call real_setup_per_cpu_areas() earlier and use lmb_alloc().
      [SPARC64]: Use lmb_alloc() for PROM device tree.
      [SPARC64]: Initialize MDESC earlier and use lmb_alloc()
      [SPARC64]: Decrease SECTION_SIZE_BITS to 30.
      [SPARC64]: Remove unused asm-sparc64/numnodes.h
      [SPARC64]: Once we have the boot cmdline, call parse_early_param()
      [SPARC64]: Kill pci_iommu_table_init() declaration.
      [SPARC64]: NUMA device infrastructure.
      [SPARC64]: Allocate TSB node-local.
      [SPARC64]: Add NUMA support.
      [SPARC64]: PROM debug console can be CON_ANYTIME.
      [SPARC64]: Store magic cookie and trap type in pt_regs.
      [SPARC64]: Use trap type stored in pt_regs to handle syscall restart.
      [SPARC64]: %l6 trap return handling no longer necessary.
      [SPARC64]: Detect trap frames in stack backtraces.

Robert Reif (1):
      sparc: sunzilog uart order

 Makefile                             |    2 +-
 arch/sparc/kernel/entry.S            |    1 -
 arch/sparc/kernel/signal.c           |    5 -
 arch/sparc64/Kconfig                 |   20 +
 arch/sparc64/defconfig               |   99 +++--
 arch/sparc64/kernel/ebus.c           |    1 +
 arch/sparc64/kernel/entry.S          |   37 +-
 arch/sparc64/kernel/entry.h          |    1 -
 arch/sparc64/kernel/etrap.S          |    4 +
 arch/sparc64/kernel/iommu.c          |   33 +-
 arch/sparc64/kernel/isa.c            |    1 +
 arch/sparc64/kernel/mdesc.c          |   28 +-
 arch/sparc64/kernel/of_device.c      |   12 +-
 arch/sparc64/kernel/pci.c            |   12 +
 arch/sparc64/kernel/pci_fire.c       |    5 +-
 arch/sparc64/kernel/pci_impl.h       |    4 +-
 arch/sparc64/kernel/pci_msi.c        |    8 +-
 arch/sparc64/kernel/pci_psycho.c     |    5 +-
 arch/sparc64/kernel/pci_sabre.c      |    4 +-
 arch/sparc64/kernel/pci_schizo.c     |    5 +-
 arch/sparc64/kernel/pci_sun4v.c      |   13 +-
 arch/sparc64/kernel/prom.c           |   14 +-
 arch/sparc64/kernel/rtrap.S          |   21 +-
 arch/sparc64/kernel/sbus.c           |    3 +-
 arch/sparc64/kernel/setup.c          |    3 +-
 arch/sparc64/kernel/signal.c         |   25 +-
 arch/sparc64/kernel/signal32.c       |   20 +-
 arch/sparc64/kernel/smp.c            |   11 +-
 arch/sparc64/kernel/sparc64_ksyms.c  |    2 -
 arch/sparc64/kernel/stacktrace.c     |   16 +-
 arch/sparc64/kernel/sun4v_tlb_miss.S |   16 +-
 arch/sparc64/kernel/sysfs.c          |   12 +
 arch/sparc64/kernel/traps.c          |   19 +-
 arch/sparc64/kernel/tsb.S            |    2 +-
 arch/sparc64/kernel/winfixup.S       |   12 +-
 arch/sparc64/mm/init.c               |  989 ++++++++++++++++++++++++----------
 arch/sparc64/mm/tsb.c                |    3 +-
 arch/sparc64/mm/ultra.S              |    4 +-
 drivers/serial/sunzilog.c            |   30 +-
 include/asm-sparc/device.h           |    2 +
 include/asm-sparc/prom.h             |    5 +
 include/asm-sparc64/iommu.h          |    3 +-
 include/asm-sparc64/mmzone.h         |   17 +
 include/asm-sparc64/numnodes.h       |    6 -
 include/asm-sparc64/ptrace.h         |   18 +-
 include/asm-sparc64/sparsemem.h      |    2 +-
 include/asm-sparc64/topology.h       |   73 +++-
 include/asm-sparc64/ttable.h         |   14 +-
 lib/lmb.c                            |    2 +-
 49 files changed, 1160 insertions(+), 484 deletions(-)
 create mode 100644 include/asm-sparc64/mmzone.h
 delete mode 100644 include/asm-sparc64/numnodes.h

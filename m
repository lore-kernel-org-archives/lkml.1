Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYG1J7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYG1J7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYG1J6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:58:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:37530 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYG1J6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:58:53 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 19:58:37 +1000
Message-Id: <1217239117.11188.187.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

I lied :-) There is a couple more features coming in. Mostly Roland
tracehook stuff which came in a bit late but since the generic bits
are in and he had some powerpc support ready, we felt like it was
something worth having. There's also some SPI bits from Grant who
were around but took some time to be fully acked and some stuff to
expose our cache topology through sysfs that we wanted but took a
bit longer to finish than expected.

The rest is mostly fixes.

It's all in:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

(Hopefully no silly non-printable character this time, at least
nothing I manage to spot with evo but who knows...)

Cheers,
Ben.

 arch/powerpc/Kconfig                       |    1 
 arch/powerpc/kernel/entry_32.S             |   17 +-
 arch/powerpc/kernel/entry_64.S             |   10 +
 arch/powerpc/kernel/legacy_serial.c        |   44 ++--
 arch/powerpc/kernel/process.c              |    8 -
 arch/powerpc/kernel/prom_init.c            |   39 ----
 arch/powerpc/kernel/ptrace.c               |   54 ++---
 arch/powerpc/kernel/setup-common.c         |   24 --
 arch/powerpc/kernel/setup_64.c             |    3 
 arch/powerpc/kernel/signal.c               |   23 ++
 arch/powerpc/kernel/smp.c                  |  119 ++++++++++-
 arch/powerpc/kernel/stacktrace.c           |    1 
 arch/powerpc/kernel/sysfs.c                |  311 ++++++++++++++++++++++++++++
 arch/powerpc/kernel/vio.c                  |    6 -
 arch/powerpc/mm/hugetlbpage.c              |    9 +
 arch/powerpc/platforms/powermac/setup.c    |   72 ++++++
 arch/powerpc/platforms/powermac/udbg_scc.c |   12 +
 arch/powerpc/platforms/pseries/cmm.c       |    8 +
 drivers/net/ibmveth.c                      |    8 -
 drivers/of/Kconfig                         |    6 +
 drivers/of/Makefile                        |    1 
 drivers/of/base.c                          |   88 ++++++++
 drivers/of/of_i2c.c                        |   64 ------
 drivers/of/of_spi.c                        |   93 ++++++++
 drivers/spi/spi.c                          |  139 +++++++++----
 include/asm-powerpc/pgtable-4k.h           |    2 
 include/asm-powerpc/pgtable-64k.h          |    2 
 include/asm-powerpc/pgtable-ppc32.h        |    3 
 include/asm-powerpc/pgtable-ppc64.h        |    4 
 include/asm-powerpc/ptrace.h               |    1 
 include/asm-powerpc/signal.h               |    3 
 include/asm-powerpc/smp.h                  |    2 
 include/asm-powerpc/syscall.h              |   84 ++++++++
 include/asm-powerpc/thread_info.h          |    5 
 include/asm-powerpc/topology.h             |    2 
 include/linux/of.h                         |    1 
 include/linux/of_spi.h                     |   18 ++
 include/linux/spi/spi.h                    |   12 +
 38 files changed, 1039 insertions(+), 260 deletions(-)
 create mode 100644 drivers/of/of_spi.c
 create mode 100644 include/asm-powerpc/syscall.h
 create mode 100644 include/linux/of_spi.h

Benjamin Herrenschmidt (3):
      powerpc/powermac: Use sane default baudrate for SCC debugging
      powerpc/powermac: Fixup default serial port device for pmac_zilog
      powerpc: Disable 64K hugetlb support when doing 64K SPU mappings

Grant Likely (3):
      of: adapt of_find_i2c_driver() to be usable by SPI also
      spi: split up spi_new_device() to allow two stage registration.
      spi: Add OF binding support for SPI busses

Huang Weiyi (1):
      powerpc: Removed duplicated include in stacktrace.c

Kumar Gala (2):
      powerpc/booke: Clean up the hardware watchpoint support
      powerpc: Fix 8xx build failure

Nathan Lynch (7):
      powerpc: Fix vio build warnings
      powerpc: kill useless SMT code in prom_hold_cpus
      powerpc: register_cpu_online should be __cpuinit
      powerpc: Update cpu_sibling_maps dynamically
      powerpc: Make core sibling information available to userspace
      powerpc: Make core id information available to userspace
      powerpc: Show processor cache information in sysfs

Nick Piggin (1):
      powerpc/mm: Implement _PAGE_SPECIAL & pte_special() for 64-bit

Roland McGrath (5):
      powerpc: Call tracehook_signal_handler() when setting up signal frames
      powerpc: Make syscall tracing use tracehook.h helpers
      powerpc: Add asm/syscall.h with the tracehook entry points
      powerpc: Add TIF_NOTIFY_RESUME support for tracehook
      powerpc: Enable tracehook for the architecture

Stephen Rothwell (3):
      powerpc/pseries: Fix CMO sysdev attribute API change fallout
      ibmveth: Fix multiple errors with dma_mapping_error conversion
      powerpc/vio: More fallout from dma_mapping_error API change




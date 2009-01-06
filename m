Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZAFCeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZAFCeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZAFCeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:34:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbZAFCd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:33:59 -0500
Date: Mon, 05 Jan 2009 18:34:00 -0800 (PST)
Message-Id: <20090105.183400.155883414.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lots of more 32/64 unification work from Sam Ravnborg,
with some smaller changes and fixes from Julian Calaby
and Bastian Blank.

Please pull, thanks a lot!

The following changes since commit fe0bdec68b77020281dc814805edfe594ae89e0f:
  Linus Torvalds (1):
        Merge branch 'audit.b61' of git://git.kernel.org/.../viro/audit-current

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Bastian Blank (1):
      sparc: Use 64BIT config entry

David S. Miller (5):
      sparc: Kill bogus comment about IRQF_SHARED in pci_psycho.c
      sparc: Update 64-bit defconfig.
      sparc: Kill asm/reg*.h
      sparc: Remove reg*.h from Kbuild

Julian Calaby (2):
      sparc: Clean arch-specific code in prom_common.c
      sparc: Fix minor SPARC32 compile error

Sam Ravnborg (23):
      sparc: delete unused config symbols
      sparc: unify posix_types.h
      sparc32: drop __old_kernel_stat
      sparc32: use proper types in struct stat
      sparc: unify stat.h
      sparc64: prepare signal_64 for unification
      sparc: unify signal.h
      sparc: add '32' suffix to reg_window, sigcontext, __siginfo_t
      sparc: unify sigcontext.h
      sparc: unify ptrace.h
      sparc: unify siginfo.h
      sparc: remove ebus definitions from openprom*.h
      sparc: remove linux_prom_pci_assigned_addresses from openprom_32.h
      sparc: prepare openprom for unification
      sparc64: delete unused linux_prom64_ranges from openprom_64.h
      sparc: unify openprom.h
      sparc: fix warning in userspace header jsflash.h
      sparc: fix warnings in userspace header byteorder.h
      sparc: fix warning in userspace header traps.h
      sparc: drop get_tbr() in traps.h
      sparc: remove NO_PROC_ID - it is no longer used
      sparc: unify ipcbuf.h
      MAINTAINERS: update sparc maintainer

 MAINTAINERS                             |   15 +-
 arch/sparc/Kconfig                      |   57 +---
 arch/sparc/configs/sparc64_defconfig    |  105 +++++---
 arch/sparc/include/asm/Kbuild           |   20 --
 arch/sparc/include/asm/byteorder.h      |   12 +-
 arch/sparc/include/asm/ipcbuf.h         |   38 +++-
 arch/sparc/include/asm/ipcbuf_32.h      |   31 ---
 arch/sparc/include/asm/ipcbuf_64.h      |   28 --
 arch/sparc/include/asm/jsflash.h        |    2 +-
 arch/sparc/include/asm/openprom.h       |  277 +++++++++++++++++++-
 arch/sparc/include/asm/openprom_32.h    |  255 ------------------
 arch/sparc/include/asm/openprom_64.h    |  280 -------------------
 arch/sparc/include/asm/posix_types.h    |  157 +++++++++++-
 arch/sparc/include/asm/posix_types_32.h |  118 --------
 arch/sparc/include/asm/posix_types_64.h |  122 ---------
 arch/sparc/include/asm/processor_32.h   |    2 +-
 arch/sparc/include/asm/ptrace.h         |  448 ++++++++++++++++++++++++++++++-
 arch/sparc/include/asm/ptrace_32.h      |  186 -------------
 arch/sparc/include/asm/ptrace_64.h      |  356 ------------------------
 arch/sparc/include/asm/reg.h            |    8 -
 arch/sparc/include/asm/reg_32.h         |   79 ------
 arch/sparc/include/asm/reg_64.h         |   56 ----
 arch/sparc/include/asm/sigcontext.h     |  102 +++++++-
 arch/sparc/include/asm/sigcontext_32.h  |   62 -----
 arch/sparc/include/asm/sigcontext_64.h  |   87 ------
 arch/sparc/include/asm/siginfo.h        |   43 +++-
 arch/sparc/include/asm/siginfo_32.h     |   17 --
 arch/sparc/include/asm/siginfo_64.h     |   32 ---
 arch/sparc/include/asm/signal.h         |  212 ++++++++++++++-
 arch/sparc/include/asm/signal_32.h      |  207 --------------
 arch/sparc/include/asm/signal_64.h      |  194 -------------
 arch/sparc/include/asm/smp_32.h         |    3 -
 arch/sparc/include/asm/stat.h           |  111 +++++++-
 arch/sparc/include/asm/stat_32.h        |   76 ------
 arch/sparc/include/asm/stat_64.h        |   47 ----
 arch/sparc/include/asm/thread_info_32.h |    2 +-
 arch/sparc/include/asm/traps.h          |   11 +-
 arch/sparc/kernel/irq_32.c              |    2 +
 arch/sparc/kernel/kgdb_32.c             |   12 +-
 arch/sparc/kernel/muldiv.c              |    8 +-
 arch/sparc/kernel/pci_psycho.c          |    5 +-
 arch/sparc/kernel/process_32.c          |   16 +-
 arch/sparc/kernel/prom_common.c         |   14 +-
 arch/sparc/kernel/signal_32.c           |    6 +-
 arch/sparc/kernel/traps_32.c            |    4 +-
 arch/sparc/kernel/unaligned_32.c        |   12 +-
 arch/sparc/kernel/windows.c             |    6 +-
 47 files changed, 1481 insertions(+), 2462 deletions(-)
 delete mode 100644 arch/sparc/include/asm/ipcbuf_32.h
 delete mode 100644 arch/sparc/include/asm/ipcbuf_64.h
 delete mode 100644 arch/sparc/include/asm/openprom_32.h
 delete mode 100644 arch/sparc/include/asm/openprom_64.h
 delete mode 100644 arch/sparc/include/asm/posix_types_32.h
 delete mode 100644 arch/sparc/include/asm/posix_types_64.h
 delete mode 100644 arch/sparc/include/asm/ptrace_32.h
 delete mode 100644 arch/sparc/include/asm/ptrace_64.h
 delete mode 100644 arch/sparc/include/asm/reg.h
 delete mode 100644 arch/sparc/include/asm/reg_32.h
 delete mode 100644 arch/sparc/include/asm/reg_64.h
 delete mode 100644 arch/sparc/include/asm/sigcontext_32.h
 delete mode 100644 arch/sparc/include/asm/sigcontext_64.h
 delete mode 100644 arch/sparc/include/asm/siginfo_32.h
 delete mode 100644 arch/sparc/include/asm/siginfo_64.h
 delete mode 100644 arch/sparc/include/asm/signal_32.h
 delete mode 100644 arch/sparc/include/asm/signal_64.h
 delete mode 100644 arch/sparc/include/asm/stat_32.h
 delete mode 100644 arch/sparc/include/asm/stat_64.h

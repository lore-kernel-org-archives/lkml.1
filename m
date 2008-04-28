Return-Path: <linux-kernel-owner+w=401wt.eu-S1764877AbYD1ABv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764877AbYD1ABv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYD1ABl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46660
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbYD1ABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:01:39 -0400
Date: Sun, 27 Apr 2008 17:01:39 -0700 (PDT)
Message-Id: <20080427.170139.242528272.davem@davemloft.net>
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


Several fixes and cleanups:

1) Remove SunOS signal frame support, that Linux used for like
   a month some 12 years ago :-)  I added an assertion that checks
   to make sure 32-bit processes request the newer style signal
   frames, which I doubt will ever trigger since Jakub Jelinek
   and myself are probably the only two people on the planet who
   ever had such Linux binaries on their system :-)

2) Revamp sparcspkr probing to use the generic OF platform bus
   probing methods, instead of the cruddy ISA and EBUS layers.

   This along with deleting the never-enabled ISA floppy support
   code allows us to delete the sparc64 specific ISA bus layer
   entirely.

   Getting rid of the EBUS layer is much hardware, and will require
   some coordination with 32-bit sparc.

3) Fix regression in the new "regs->orig_eax == -1" x86 style syscall
   restart handling on sparc64.  We'd accidently restart a successful
   fork/vfork/clone in the child.  Doh! :)

4) SBUS video driver fixes and cleanups from Robert Reif.

Please pull, thanks a lot!

The following changes since commit c3bf9bc243092c53946fd6d8ebd6dc2f4e572d48:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../x86/linux-2.6-x86-bigbox-bootmem-v3

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (11):
      sparc64: Fix wedged irq regression.
      sparc64: Cleanups and corrections for arch/sparc64/Kconfig
      sparc64: Kill CONFIG_SPARC32_COMPAT
      sparc64: Kill ISA_FLOPPY_WORKS code.
      sparc64: Do not ignore 'pmu' device ranges.
      input: Rewrite sparcspkr device probing.
      sparc64: Kill unused local ISA bus layer.
      sparc64: Kill bogus RT_ALIGNEDSZ macro from signal.c
      sparc: Remove old style signal frame support.
      sparc64: Clean up handling of pt_regs trap type encoding.
      sparc64: Fix accidental syscall restart on child return from clone/fork/vfork.

Robert Reif (7):
      sparc: fix drivers/video/tcx.c warning
      sparc: sunzilog.c remove unused argument
      sparc: bw2.c fix bw2_exit
      sparc: cg14.c make cg14_init and cg15_exit static
      sparc: ffb.c make ffb_init and ffb_exit static
      sparc: tcx.c make tcx_init and tcx_exit static
      sparc: video drivers: add facility level

 arch/sparc/kernel/process.c         |    2 -
 arch/sparc/kernel/signal.c          |  260 +++------------------------------
 arch/sparc/kernel/sys_sparc.c       |   14 +--
 arch/sparc64/Kconfig                |   85 ++---------
 arch/sparc64/defconfig              |   23 ++--
 arch/sparc64/kernel/Makefile        |    6 +-
 arch/sparc64/kernel/audit.c         |    6 +-
 arch/sparc64/kernel/irq.c           |    3 +-
 arch/sparc64/kernel/isa.c           |  191 ------------------------
 arch/sparc64/kernel/of_device.c     |    6 -
 arch/sparc64/kernel/pci.c           |    2 -
 arch/sparc64/kernel/process.c       |   12 +-
 arch/sparc64/kernel/signal.c        |   16 +--
 arch/sparc64/kernel/signal32.c      |  272 +++--------------------------------
 arch/sparc64/kernel/sparc64_ksyms.c |    2 -
 arch/sparc64/kernel/sys_sparc32.c   |   11 +--
 drivers/input/misc/sparcspkr.c      |  262 +++++++++++++++++++++++----------
 drivers/serial/sunzilog.c           |    4 +-
 drivers/video/bw2.c                 |    5 +-
 drivers/video/cg14.c                |    6 +-
 drivers/video/cg3.c                 |    2 +-
 drivers/video/cg6.c                 |    2 +-
 drivers/video/ffb.c                 |    7 +-
 drivers/video/leo.c                 |    2 +-
 drivers/video/p9100.c               |    2 +-
 drivers/video/tcx.c                 |   10 +-
 include/asm-sparc/processor.h       |    4 +-
 include/asm-sparc64/floppy.h        |   84 +-----------
 include/asm-sparc64/isa.h           |   47 ------
 include/asm-sparc64/ptrace.h        |   23 +++-
 include/asm-sparc64/thread_info.h   |    6 +-
 init/Kconfig                        |    2 +-
 32 files changed, 318 insertions(+), 1061 deletions(-)
 delete mode 100644 arch/sparc64/kernel/isa.c
 delete mode 100644 include/asm-sparc64/isa.h


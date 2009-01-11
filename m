Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbZAKH4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbZAKH4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZAKH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:56:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56783
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbZAKH4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:56:22 -0500
Date: Sat, 10 Jan 2009 23:56:23 -0800 (PST)
Message-Id: <20090110.235623.195854446.davem@davemloft.net>
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


Some build fixes, and some work to move sparc symbol exports to that
symbol's definition.

Big thanks to Robert Reif for reporting the sparc 32-bit bootup
regression, bisecting it, and testing the fix.

Please pull, thanks a lot!

The following changes since commit 9e42d0cf5020aaf217433cad1a224745241d212a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc: Update 32-bit defconfig.
      sparc: Fix sun4d_irq.c build.
      sparc: Most unaligned_64.c tweaks for branch tracer warnings.
      sparc: Fix asm/signal.h for 32-bit.

Julian Calaby (2):
      sparc: Kill exports of prom internal functions
      sparc: Eliminate PROMLIB_INTERNAL as it does nothing

Sam Ravnborg (4):
      sparc64: fix warnings in psycho_common after ull conversion
      sparc: Create a new file lib/ksyms.c and add export of all symbols defined in assembler in lib/ to this file.
      sparc: move EXPORT_SYMBOL to the symbols definition
      sparc64: move EXPORT_SYMBOL to the symbols definition

 arch/sparc/configs/sparc32_defconfig |  290 +++++++++++++++++++++++++---------
 arch/sparc/include/asm/oplib_32.h    |   11 --
 arch/sparc/include/asm/oplib_64.h    |   10 --
 arch/sparc/include/asm/signal.h      |    4 +
 arch/sparc/kernel/auxio_32.c         |    3 +-
 arch/sparc/kernel/auxio_64.c         |    2 +
 arch/sparc/kernel/cpu.c              |    2 +
 arch/sparc/kernel/idprom.c           |    3 +
 arch/sparc/kernel/ioport.c           |   15 ++
 arch/sparc/kernel/irq_32.c           |    1 +
 arch/sparc/kernel/pci.c              |    1 +
 arch/sparc/kernel/pcic.c             |    6 +
 arch/sparc/kernel/process_32.c       |    2 +
 arch/sparc/kernel/process_64.c       |    2 +
 arch/sparc/kernel/psycho_common.c    |   60 ++++----
 arch/sparc/kernel/sbus.c             |    1 +
 arch/sparc/kernel/setup_32.c         |    3 +
 arch/sparc/kernel/setup_64.c         |    3 +
 arch/sparc/kernel/sparc_ksyms_32.c   |  225 +-------------------------
 arch/sparc/kernel/sparc_ksyms_64.c   |  243 ++---------------------------
 arch/sparc/kernel/sun4d_smp.c        |    4 +-
 arch/sparc/kernel/sys_sparc_64.c     |    2 +
 arch/sparc/kernel/time_32.c          |    2 +
 arch/sparc/kernel/time_64.c          |    2 +
 arch/sparc/kernel/traps_32.c         |    1 +
 arch/sparc/kernel/traps_64.c         |    2 +
 arch/sparc/kernel/unaligned_64.c     |    8 +-
 arch/sparc/lib/Makefile              |    1 +
 arch/sparc/lib/PeeCeeI.c             |    8 +
 arch/sparc/lib/ksyms.c               |  196 +++++++++++++++++++++++
 arch/sparc/lib/user_fixup.c          |    5 +
 arch/sparc/mm/generic_32.c           |    1 +
 arch/sparc/mm/generic_64.c           |    1 +
 arch/sparc/mm/highmem.c              |    2 +
 arch/sparc/mm/init_32.c              |    6 +
 arch/sparc/mm/init_64.c              |    4 +
 arch/sparc/prom/init_32.c            |    4 +
 arch/sparc/prom/misc_32.c            |    3 +
 arch/sparc/prom/misc_64.c            |    3 +
 arch/sparc/prom/ranges.c             |    3 +
 arch/sparc/prom/tree_32.c            |   17 ++-
 arch/sparc/prom/tree_64.c            |   18 ++-
 42 files changed, 595 insertions(+), 585 deletions(-)
 create mode 100644 arch/sparc/lib/ksyms.c

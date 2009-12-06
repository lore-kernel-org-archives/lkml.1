Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbZLFDfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbZLFDfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 22:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZLFDf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 22:35:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57101
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758046AbZLFDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 22:35:06 -0500
Date: Sat, 05 Dec 2009 19:35:11 -0800 (PST)
Message-Id: <20091205.193511.226786837.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More progress on 32-bit LEON cpu support.

BKL removals from Thomas Gleixner.

A nicer early-boot OpenFirmware based framebuffer for sparc64
based upon PowerPC's bootx.

Please pull, thanks a lot!

The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
  Linus Torvalds (1):
        Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Boaz Harrosh (1):
      sparc: remove unused nfsd #includes

David S. Miller (6):
      apbuart: Fix build warning.
      apbuart: Kill dependency on deprecated Sparc-only PROM interfaces.
      apbuart: Fix build and missing driver unregister.
      Revert "sparc: Make atomic locks raw"
      sparc64: Faster early-boot framebuffer console.
      sparc: Set UTS_MACHINE correctly.

Konrad Eisele (1):
      sparc,leon: Sparc-Leon SMP support

Kristoffer Glembo (7):
      sparc: Support for GRLIB APBUART serial port
      apbuart: Use of_find_node_by_path to find root node.
      No auxio on LEON
      Added sparc_leon3_snooping_enabled() and converted extern inline to static inline
      sparc, leon: Added Aeroflex Gaisler entry in manufacturer_info structure
      sparc32: Remove early interrupt enable.
      sparc,leon: init_leon srmmu cleanup

Thomas Gleixner (5):
      sparc: Remove BKL from apc
      watchdog: Remove BKL from rio watchdog driver
      sparc: Make atomic locks raw
      sparc: Replace old style lock initializer
      sparc: Fixup last users of irq_chip->typename

 arch/sparc/Kconfig                |    7 +
 arch/sparc/Makefile               |    2 +
 arch/sparc/include/asm/btext.h    |    6 +
 arch/sparc/include/asm/leon.h     |   45 ++-
 arch/sparc/include/asm/rwsem.h    |    4 +-
 arch/sparc/include/asm/smp_32.h   |    9 +
 arch/sparc/kernel/Makefile        |    3 +-
 arch/sparc/kernel/apc.c           |   37 +--
 arch/sparc/kernel/auxio_32.c      |    1 +
 arch/sparc/kernel/btext.c         |  673 +++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/cpu.c           |   11 +
 arch/sparc/kernel/entry.S         |   33 ++
 arch/sparc/kernel/head_32.S       |   22 ++
 arch/sparc/kernel/ioport.c        |    5 +
 arch/sparc/kernel/irq_64.c        |    8 +-
 arch/sparc/kernel/leon_kernel.c   |   84 +++++
 arch/sparc/kernel/leon_smp.c      |  468 ++++++++++++++++++++++++
 arch/sparc/kernel/pci_msi.c       |    2 +-
 arch/sparc/kernel/setup_64.c      |    6 +-
 arch/sparc/kernel/smp_32.c        |   10 +
 arch/sparc/kernel/sys_sparc32.c   |    5 -
 arch/sparc/kernel/time_32.c       |    3 -
 arch/sparc/kernel/trampoline_32.S |   69 ++++-
 arch/sparc/mm/srmmu.c             |    9 +-
 drivers/serial/Kconfig            |   13 +
 drivers/serial/Makefile           |    1 +
 drivers/serial/apbuart.c          |  710 +++++++++++++++++++++++++++++++++++++
 drivers/serial/apbuart.h          |   64 ++++
 drivers/watchdog/riowd.c          |    6 +-
 include/linux/serial_core.h       |    3 +
 30 files changed, 2262 insertions(+), 57 deletions(-)
 create mode 100644 arch/sparc/include/asm/btext.h
 create mode 100644 arch/sparc/kernel/btext.c
 create mode 100644 arch/sparc/kernel/leon_smp.c
 create mode 100644 drivers/serial/apbuart.c
 create mode 100644 drivers/serial/apbuart.h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYGWSgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYGWSgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGWSgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:64503 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYGWSgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [git pull] kgdb 2.6.27 merge
Date: Wed, 23 Jul 2008 13:35:34 -0500
Message-Id: <1216838139-719-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 23 Jul 2008 18:35:42.0170 (UTC) FILETIME=[E96043A0:01C8ECF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull kgdb the kgdb git tree.

Summary:

 - Add ARCH=arm kgdb support
 - Add ARCH=powerpc kgdb support
 - Add 2 more rs232 polled drivers for use with kgdboc
 - Remove Kconfig option for a non-merged architecture

Details:

The ARCH=arm support was reviewed by rmk and changes were made during
the 2.6.26 development cycle and it has been in the linux-next tree
for some time.  The original author has also acked this work now.

The powerpc kgdb code removes the left over pieces of the old ARCH=ppc
kgdb stub.

The kgdb test suite is known to pass correctly arm and powerpc.

Jason.

The following changes since commit c010b2f76c3032e48097a6eef291d8593d5d79a6:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (5):
      kgdb: remove unused HAVE_ARCH_KGDB_SHADOW_INFO config variable
      kgdb: support for ARCH=arm
      kgdb, powerpc: arch specific powerpc kgdb support
      kgdb: kgdboc console poll hooks for cpm uart
      kgdb: kgdboc console poll hooks for mpsc uart

 arch/arm/Kconfig                        |    1 +
 arch/arm/kernel/Makefile                |    1 +
 arch/arm/kernel/kgdb.c                  |  201 +++++++++++++++
 arch/arm/kernel/setup.c                 |    2 +
 arch/arm/kernel/traps.c                 |    5 +
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/Kconfig.debug              |   50 +----
 arch/powerpc/kernel/Makefile            |    1 +
 arch/powerpc/kernel/kgdb.c              |  410 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_32.c          |   16 --
 arch/powerpc/platforms/powermac/setup.c |    6 -
 drivers/serial/cpm_uart/cpm_uart_core.c |   95 +++++++-
 drivers/serial/mpsc.c                   |  148 +++++++++++-
 include/asm-arm/kgdb.h                  |  104 ++++++++
 include/asm-arm/traps.h                 |    2 +
 include/asm-powerpc/kgdb.h              |   92 ++++----
 lib/Kconfig.kgdb                        |    3 -
 17 files changed, 1025 insertions(+), 113 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb.c
 create mode 100644 arch/powerpc/kernel/kgdb.c
 create mode 100644 include/asm-arm/kgdb.h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbYGOM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbYGOM2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYGOM2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:28:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:39643 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbYGOM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:27:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] kgdb 2.6.27 merge plans
Date: Tue, 15 Jul 2008 07:27:52 -0500
Message-Id: <1216124876-19108-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 15 Jul 2008 12:27:55.0680 (UTC) FILETIME=[356B1A00:01C8E676]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 4 patches represent the current merge request plans for
the 2.6.27 kernel with respect to ongoing kgdb work.

Summary:
 - Add ARCH=arm kgdb support
 - Add ARCH=powerpc kgdb support
 - Add 2 more rs232 polled drivers for use with kgdboc

The ARCH=arm support was reviewed by rmk and changes were made during
the 2.6.26 development cycle and it has been in the linux-next tree
for some time.  The kgdb test suite is known to pass correctly with UP
kernels on arm and powerpc.

The powerpc kgdb code is out for review at this time, and may or may
not make the 2.6.27 merge window.

Jason.

The following changes since commit 50515af207d410c9f228380e529c56f43c3de0bd:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (4):
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
 arch/powerpc/Kconfig.debug              |   34 +--
 arch/powerpc/kernel/Makefile            |    1 +
 arch/powerpc/kernel/kgdb.c              |  410 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_32.c          |   16 --
 arch/powerpc/platforms/powermac/setup.c |    6 -
 drivers/serial/cpm_uart/cpm_uart_core.c |   95 +++++++-
 drivers/serial/mpsc.c                   |  148 +++++++++++-
 include/asm-arm/kgdb.h                  |  104 ++++++++
 include/asm-arm/traps.h                 |    2 +
 include/asm-powerpc/kgdb.h              |   92 ++++----
 16 files changed, 1025 insertions(+), 94 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb.c
 create mode 100644 arch/powerpc/kernel/kgdb.c
 create mode 100644 include/asm-arm/kgdb.h


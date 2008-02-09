Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYBIGnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYBIGnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBIGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:42:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:44851 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYBIGmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:42:54 -0500
Message-ID: <47AD4AAD.6010500@windriver.com>
Date: Sat, 09 Feb 2008 00:39:41 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [git pull] kgdb core and rs232 I/O drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2008 06:39:17.0827 (UTC) FILETIME=[7E8D4930:01C86AE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb tree has been collapsed review.  It includes
the kgdb core, the x86 arch, the kgdb8250 uart driver
and the kgdb console sharing driver.

Since the last time the kgdb patches were posted to LKML
several months ago, the kgdb core has undergone some
significant cleanup, as well as the kgdb I/O driver
interface.

All the kgdb hooks are initialized dynamically only when a
kgdb I/O module is configured. When not configured
kgdb will not exist in any kernel execution path.

Further comments are certainly welcome.

Thanks,
Jason.

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Ingo Molnar (1):
      pid, kgdb: add pid_max prototype

Jason Wessel (7):
      kgdb: core API and gdb protocol handler
      kgdb, modules: Always allow module sect info for KGDB
      kgdb: COPTIMIZE flag
      kgdb, x86: Add arch specfic kgdb support
      kgdb, sysrq_bugfix
      kgdb: exclusive use kgdb8250 uart I/O driver
      kgdb: kgdboc 8250 I/O module

 Documentation/DocBook/Makefile      |    2 +-
 Documentation/DocBook/kgdb.tmpl     |  214 ++++
 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |    7 +
 Makefile                            |    8 +-
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  533 +++++++++
 arch/x86/kernel/setup_32.c          |    2 +
 arch/x86/kernel/setup_64.c          |    4 +
 arch/x86/kernel/traps_32.c          |   14 +-
 arch/x86/kernel/traps_64.c          |   17 +-
 drivers/char/keyboard.c             |    1 +
 drivers/char/tty_io.c               |    8 +
 drivers/serial/8250.c               |   91 ++
 drivers/serial/8250_kgdb.c          |  489 +++++++++
 drivers/serial/Kconfig              |    5 +-
 drivers/serial/Makefile             |    2 +
 drivers/serial/kgdboc.c             |  182 ++++
 drivers/serial/serial_core.c        |   89 ++-
 include/asm-generic/kgdb.h          |  105 ++
 include/asm-x86/kgdb.h              |   79 ++
 include/asm-x86/system.h            |    3 +
 include/linux/clocksource.h         |    1 +
 include/linux/kgdb.h                |  268 +++++
 include/linux/module.h              |    9 +-
 include/linux/pid.h                 |    2 +
 include/linux/sched.h               |    1 +
 include/linux/serial_8250.h         |    2 +
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   11 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 2018 +++++++++++++++++++++++++++++++++++
 kernel/module.c                     |   34 +-
 kernel/sched.c                      |    3 +-
 kernel/softlockup.c                 |    7 +-
 kernel/sysctl.c                     |    2 +-
 kernel/time/clocksource.c           |   12 +
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   62 ++
 39 files changed, 4268 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/DocBook/kgdb.tmpl
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/8250_kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

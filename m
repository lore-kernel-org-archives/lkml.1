Return-Path: <linux-kernel-owner+w=401wt.eu-S1751205AbZILEBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbZILEBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 00:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZILEBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 00:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56057
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbZILEBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 00:01:41 -0400
Date: Fri, 11 Sep 2009 21:01:56 -0700 (PDT)
Message-Id: <20090911.210156.127191632.davem@davemloft.net>
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


Items of note here:

1) Initial LEON processor support, from Konrad Eisele

2) Basic SW perf counter support from Jens Axboe

3) Very simple HW counter support for UltraSPARC-IIIi and Niagara-2

Please pull, thanks a lot!

The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
  Linus Torvalds (1):
        Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Alexey Dobriyan (2):
      sparc64: cheaper asm/uaccess.h inclusion
      sparc: convert /proc/io_map, /proc/dvma_map to seq_file

David S. Miller (13):
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: Manage NMI watchdog enabling like x86.
      sparc64: Kill unnecessary cast in profile_timer_exceptions_notify().
      sparc64: Make touch_nmi_watchdog() actually work.
      sparc64: Provide extern decls for sparc_??u_type strings.
      sparc64: Use nmi_enter() and nmi_exit(), as needed.
      sparc64: Implement a real set_perf_counter_pending().
      sparc64: Initial hw perf counter support.
      sparc64: Provide hypervisor tracing bit support for perf counters.
      sparc64: Provide a way to specify a perf counter overflow IRQ enable bit.
      sparc64: Perf counter 'nop' event is not constant.
      sparc64: Initial niagara2 perf counter support.
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

Jaswinder Singh Rajput (1):
      SPARC: fix duplicate declaration

Jens Axboe (1):
      sparc: add basic support for 'perf'

Jurij Smakov (1):
      sparc64: build compressed image (zImage) by default

Konrad Eisele (5):
      sparc,leon: CONFIG_SPARC_LEON option and leon specific files.
      sparc,leon: Redefine MMU register access asi if CONFIG_LEON
      sparc,leon: Introduce the sparc-leon CPU type.
      sparc,leon: Added support for AMBAPP bus.
      sparc, leon: sparc-leon specific SRMMU initialization and bootup fixes.

 arch/sparc/Kconfig                    |   13 +
 arch/sparc/Makefile                   |   12 +-
 arch/sparc/boot/Makefile              |    3 +
 arch/sparc/include/asm/asi.h          |    4 +
 arch/sparc/include/asm/leon.h         |  362 +++++++++++++++++++++
 arch/sparc/include/asm/leon_amba.h    |  263 ++++++++++++++++
 arch/sparc/include/asm/machines.h     |    6 +-
 arch/sparc/include/asm/nmi.h          |    5 +-
 arch/sparc/include/asm/perf_counter.h |   14 +
 arch/sparc/include/asm/pgtsrmmu.h     |    4 +
 arch/sparc/include/asm/prom.h         |    3 +
 arch/sparc/include/asm/system_32.h    |    1 +
 arch/sparc/include/asm/system_64.h    |    4 +
 arch/sparc/include/asm/types.h        |   27 +--
 arch/sparc/include/asm/uaccess_64.h   |    2 +-
 arch/sparc/include/asm/unistd.h       |    3 +-
 arch/sparc/kernel/Makefile            |    5 +
 arch/sparc/kernel/cpu.c               |    5 +
 arch/sparc/kernel/head_32.S           |    5 +
 arch/sparc/kernel/idprom.c            |    2 +
 arch/sparc/kernel/ioport.c            |   32 ++-
 arch/sparc/kernel/irq_32.c            |    5 +
 arch/sparc/kernel/leon_kernel.c       |  203 ++++++++++++
 arch/sparc/kernel/nmi.c               |   72 +++--
 arch/sparc/kernel/of_device_32.c      |   40 +++
 arch/sparc/kernel/pcr.c               |   14 +-
 arch/sparc/kernel/perf_counter.c      |  557 +++++++++++++++++++++++++++++++++
 arch/sparc/kernel/prom_32.c           |   33 ++
 arch/sparc/kernel/prom_common.c       |   10 +-
 arch/sparc/kernel/setup_32.c          |    5 +
 arch/sparc/kernel/sysfs.c             |    1 +
 arch/sparc/kernel/systbls_32.S        |    2 +-
 arch/sparc/kernel/systbls_64.S        |    4 +-
 arch/sparc/mm/Makefile                |    1 +
 arch/sparc/mm/init_32.c               |    4 +
 arch/sparc/mm/leon_mm.c               |  260 +++++++++++++++
 arch/sparc/mm/loadmmu.c               |    1 +
 arch/sparc/mm/srmmu.c                 |   53 +++-
 arch/sparc/oprofile/init.c            |    4 +-
 samples/kprobes/kretprobe_example.c   |    1 +
 tools/perf/perf.h                     |    6 +
 41 files changed, 1981 insertions(+), 70 deletions(-)
 create mode 100644 arch/sparc/include/asm/leon.h
 create mode 100644 arch/sparc/include/asm/leon_amba.h
 create mode 100644 arch/sparc/include/asm/perf_counter.h
 create mode 100644 arch/sparc/kernel/leon_kernel.c
 create mode 100644 arch/sparc/kernel/perf_counter.c
 create mode 100644 arch/sparc/mm/leon_mm.c

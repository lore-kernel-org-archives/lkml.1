Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYFZLyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYFZLyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYFZLyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:54:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14109 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYFZLyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:54:07 -0400
Date: Thu, 26 Jun 2008 13:54:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: What's in linux-2.6-block.git for 2.6.27
Message-ID: <20080626115404.GS20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this time it's a little beyond just block stuff, since the
generic-ipi branch is included (in preparation for block parts actually
using that code).

- xen block bits

- Write starvation fix for 'AS', a very long standing bug

- CFQ using the message trace for debugging.

- Ability to inject messages into the blktrace stream from user space,
  which helps annotate a longer running trace where you make changes
  meanwhile.

- Finally kill off request_queue_t typedef.

- The data integrity block parts.

- Export of the disk read-only attribute in sysfs

- The generic-ipi smp helpers and a slew of arch conversions.

All of the above can be viewed/tested in the for-next branch, which is
what Stephen is pulling as well. For manual code browsing, go to gitweb
here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-next

or pull

git://git.kernel.dk/linux-2.6-block.git for-next

if you want to get at the source. Changelog below.


Adel Gadllah (1):
      allow userspace to modify scsi command filter on per device basis

Alan D. Brunelle (1):
      Added in user-injected messages into blk traces

Christian Limpach (1):
      xen/blkfront: Add the CDROM_GET_CAPABILITY ioctl to blkfront.

Divyesh Shah (1):
      block: Fix the starving writes bug in the anticipatory IO scheduler

Ian Campbell (2):
      xen/blkfront: Make sure we don't use bounce buffers, we don't need them.
      xen: Avoid allocations causing swap activity on the resume path

Jan Beulich (1):
      xen/blkfront: add __exit to module_exit() handlers

Jens Axboe (21):
      cfq-iosched: properly protect ioc_gone and ioc count
      as-iosched: properly protect ioc_gone and ioc count
      cfq-iosched: add message logging through blktrace
      block: kill request_queue_t
      block: integrity checkpatch cleanups
      block: blkdev.h cleanup, move iocontext stuff to iocontext.h
      block: integrity cleanups
      block: turn immediate wait_on_buffer() async write into sync
      Add generic helpers for arch IPI function calls
      x86: convert to generic helpers for IPI function calls
      powerpc: convert to generic helpers for IPI function calls
      ia64: convert to generic helpers for IPI function calls
      alpha: convert to generic helpers for IPI function calls
      arm: convert to generic helpers for IPI function calls
      m32r: convert to generic helpers for IPI function calls
      mips: convert to generic helpers for IPI function calls
      parisc: convert to generic helpers for IPI function calls
      sh: convert to generic helpers for IPI function calls
      Merge branch 'generic-ipi' into for-next
      Merge branch 'for-linus' into for-next
      cfq-iosched: get rid of enable_idle being unused warning

Kay Sievers (1):
      block: export "ro" attribute

Martin K. Petersen (3):
      block: Globalize bio_set and bio_vec_slab
      block: Block layer data integrity support
      block: Data integrity infrastructure documentation

Wim Colgate (1):
      xen/blkfront: Make sure that the device is fully ready before allowing release.

 Documentation/ABI/testing/sysfs-block      |   34 ++
 Documentation/block/data-integrity.txt     |  327 +++++++++++++
 arch/Kconfig                               |    3 +
 arch/alpha/Kconfig                         |    1 +
 arch/alpha/kernel/core_marvel.c            |    6 +-
 arch/alpha/kernel/smp.c                    |  170 +------
 arch/arm/Kconfig                           |    1 +
 arch/arm/kernel/smp.c                      |  157 +------
 arch/ia64/Kconfig                          |    1 +
 arch/ia64/kernel/smp.c                     |  250 +---------
 arch/ia64/kernel/smpboot.c                 |    4 +-
 arch/m32r/Kconfig                          |    1 +
 arch/m32r/kernel/m32r_ksyms.c              |    3 -
 arch/m32r/kernel/smp.c                     |  128 +-----
 arch/m32r/kernel/traps.c                   |    3 +-
 arch/mips/Kconfig                          |    1 +
 arch/mips/kernel/smp.c                     |  141 +-----
 arch/mips/kernel/smtc.c                    |    1 -
 arch/parisc/Kconfig                        |    1 +
 arch/parisc/kernel/smp.c                   |  134 +-----
 arch/powerpc/Kconfig                       |    1 +
 arch/powerpc/kernel/smp.c                  |  234 +---------
 arch/powerpc/platforms/cell/interrupt.c    |    1 +
 arch/powerpc/platforms/ps3/smp.c           |    7 +-
 arch/powerpc/platforms/pseries/xics.c      |    6 +-
 arch/powerpc/sysdev/mpic.c                 |    2 +-
 arch/sh/Kconfig                            |    1 +
 arch/sh/kernel/smp.c                       |   48 +--
 arch/sparc64/kernel/smp.c                  |   11 +-
 arch/x86/Kconfig                           |    1 +
 arch/x86/kernel/apic_32.c                  |    4 +
 arch/x86/kernel/entry_64.S                 |    3 +
 arch/x86/kernel/i8259_64.c                 |    4 +
 arch/x86/kernel/smp.c                      |  158 +------
 arch/x86/kernel/smpboot.c                  |    4 +-
 arch/x86/kernel/smpcommon.c                |   56 ---
 arch/x86/mach-voyager/voyager_smp.c        |   94 +---
 arch/x86/xen/enlighten.c                   |    4 +-
 arch/x86/xen/mmu.c                         |    2 +-
 arch/x86/xen/smp.c                         |  133 ++----
 arch/x86/xen/xen-ops.h                     |    9 +-
 block/Kconfig                              |   12 +
 block/Makefile                             |    4 +-
 block/as-iosched.c                         |   20 +-
 block/blk-core.c                           |    7 +
 block/blk-integrity.c                      |  384 +++++++++++++++
 block/blk-merge.c                          |    3 +
 block/blk.h                                |    8 +
 block/blktrace.c                           |   45 ++
 block/bsg.c                                |   38 +-
 block/cfq-iosched.c                        |   83 +++-
 block/cmd-filter.c                         |  325 +++++++++++++
 block/elevator.c                           |    6 +
 block/genhd.c                              |   12 +
 block/scsi_ioctl.c                         |  121 +-----
 drivers/block/xen-blkfront.c               |   48 ++-
 drivers/net/xen-netfront.c                 |    4 +-
 drivers/scsi/sg.c                          |   40 +--
 drivers/xen/xenbus/xenbus_client.c         |    2 +-
 drivers/xen/xenbus/xenbus_xs.c             |   10 +-
 fs/Makefile                                |    1 +
 fs/bio-integrity.c                         |  719 ++++++++++++++++++++++++++++
 fs/bio.c                                   |   62 ++--
 fs/buffer.c                                |   13 +-
 include/asm-alpha/smp.h                    |    3 +-
 include/asm-arm/smp.h                      |    3 +
 include/asm-ia64/smp.h                     |    8 +-
 include/asm-m32r/smp.h                     |    4 +
 include/asm-mips/smp.h                     |   13 +-
 include/asm-parisc/smp.h                   |    3 +
 include/asm-powerpc/smp.h                  |    8 +-
 include/asm-sh/smp.h                       |   14 +-
 include/asm-x86/hw_irq_32.h                |    1 +
 include/asm-x86/hw_irq_64.h                |    2 +
 include/asm-x86/mach-default/entry_arch.h  |    1 +
 include/asm-x86/mach-default/irq_vectors.h |    1 +
 include/asm-x86/mach-voyager/entry_arch.h  |    2 +-
 include/asm-x86/mach-voyager/irq_vectors.h |    4 +-
 include/asm-x86/smp.h                      |   21 +-
 include/asm-x86/xen/events.h               |    1 +
 include/linux/bio.h                        |  130 +++++-
 include/linux/blkdev.h                     |  127 +++++-
 include/linux/blktrace_api.h               |    1 +
 include/linux/fs.h                         |    1 +
 include/linux/genhd.h                      |   12 +
 include/linux/iocontext.h                  |   18 +
 include/linux/smp.h                        |   35 ++-
 init/main.c                                |    2 +
 kernel/Makefile                            |    1 +
 kernel/smp.c                               |  383 +++++++++++++++
 90 files changed, 3086 insertions(+), 1830 deletions(-)
 create mode 100644 Documentation/block/data-integrity.txt
 create mode 100644 block/blk-integrity.c
 create mode 100644 block/cmd-filter.c
 create mode 100644 fs/bio-integrity.c
 create mode 100644 kernel/smp.c

-- 
Jens Axboe


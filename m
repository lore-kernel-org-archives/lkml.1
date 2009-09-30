Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZI3RlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZI3RlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZI3RlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:41:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZI3RlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:41:07 -0400
Date: Wed, 30 Sep 2009 19:41:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block updates for 2.6.32-rc
Message-ID: <20090930174109.GD14918@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This looks huge, but it's mostly a cciss driver update and the addition
of drbd. I would have submitted this before -rc1, but Plumbers got in
the way.

Apart from that, it includes the discard bits from Christoph and a few
trivial updates and fixes.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alexander Beregalov (1):
      cciss: fix build when !PROC_FS

Alexey Dobriyan (2):
      cpqarray: switch to seq_file
      dac960: switch to seq_file

Andrew Patterson (3):
      cciss: Remove sysfs entries for logical drives on driver cleanup.
      cciss: Use one scan thread per controller and fix hang during rmmod
      cciss: Allow triggering of rescan of logical drive topology via sysfs entry

Christoph Hellwig (2):
      block: use normal I/O path for discard requests
      block: allow large discard requests

H Hartley Sweeten (1):
      fs/bio.c: move EXPORT* macros to line after function

Jens Axboe (3):
      cciss: cciss_host_attr_groups should be const
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus

Jun'ichi Nomura (1):
      Add a tracepoint for block request remapping

Lars Ellenberg (1):
      dropping unneeded include autoconf.h

Martin K. Petersen (2):
      block: Set max_sectors correctly for stacking devices
      block: Do not clamp max_hw_sectors for stacking devices

Philipp Reisner (1):
      The DRBD driver

Randy Dunlap (1):
      cciss: fix schedule_timeout() parameters

Stephen M. Cameron (17):
      cciss: Remove some unused code in rebuild_lun_table()
      cciss: Dynamically allocate struct device for each logical drive as needed.
      cciss: Rearrange logical drive sysfs code to make the "changing a disk" path work.
      cciss: Handle failure of blk_init_queue gracefully in cciss_add_disk.
      cciss: Handle cases when cciss_add_disk fails.
      cciss: Handle special case for sysfs attributes of the first logical drive.
      cciss: Clear all sysfs-exposed data for deleted logical drives.
      cciss: Fix usage_count check in rebuild_lun_table when triggered via sysfs.
      cciss: Fix excessive gendisk freeing bug on driver unload.
      cciss: Silence noisy per-disk messages output by cciss_read_capacity
      cciss: Preserve all 8 bytes of LUN ID for logical drives.
      cciss: Don't check h->busy_initializing in cciss_open().
      cciss: Add lunid attribute to each logical drive in /sys
      cciss: fix some magic numbers in the raid-level decoding
      cciss: Add a "raid_level" attribute to each logical drive in /sys
      cciss: Add usage_count attribute to each logical drive in /sys
      cciss: Dynamically allocate the drive_info_struct for each logical drive.

Suresh Jayaraman (1):
      swapfile: avoid NULL pointer dereference in swapon when s_bdev is NULL

Zdenek Kabelac (1):
      Add missing blk_trace_remove_sysfs to be in pair with blk_trace_init_sysfs

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   28 +
 .../blockdev/drbd/DRBD-8.3-data-packets.svg        |  588 +++
 Documentation/blockdev/drbd/DRBD-data-packets.svg  |  459 ++
 Documentation/blockdev/drbd/README.txt             |   16 +
 Documentation/blockdev/drbd/conn-states-8.dot      |   18 +
 Documentation/blockdev/drbd/disk-states-8.dot      |   16 +
 .../drbd/drbd-connection-state-overview.dot        |   85 +
 Documentation/blockdev/drbd/node-states-8.dot      |   14 +
 MAINTAINERS                                        |   13 +
 block/blk-barrier.c                                |   45 +-
 block/blk-core.c                                   |    7 +-
 block/blk-settings.c                               |   34 +-
 block/blk-sysfs.c                                  |   11 +-
 drivers/block/DAC960.c                             |  156 +-
 drivers/block/Kconfig                              |    2 +
 drivers/block/Makefile                             |    1 +
 drivers/block/cciss.c                              |  753 +++-
 drivers/block/cciss.h                              |   12 +-
 drivers/block/cpqarray.c                           |   63 +-
 drivers/block/drbd/Kconfig                         |   82 +
 drivers/block/drbd/Makefile                        |    8 +
 drivers/block/drbd/drbd_actlog.c                   | 1484 +++++++
 drivers/block/drbd/drbd_bitmap.c                   | 1327 ++++++
 drivers/block/drbd/drbd_int.h                      | 2258 ++++++++++
 drivers/block/drbd/drbd_main.c                     | 3734 ++++++++++++++++
 drivers/block/drbd/drbd_nl.c                       | 2364 +++++++++++
 drivers/block/drbd/drbd_proc.c                     |  265 ++
 drivers/block/drbd/drbd_receiver.c                 | 4455 ++++++++++++++++++++
 drivers/block/drbd/drbd_req.c                      | 1131 +++++
 drivers/block/drbd/drbd_req.h                      |  326 ++
 drivers/block/drbd/drbd_strings.c                  |  113 +
 drivers/block/drbd/drbd_tracing.c                  |  752 ++++
 drivers/block/drbd/drbd_tracing.h                  |   87 +
 drivers/block/drbd/drbd_vli.h                      |  351 ++
 drivers/block/drbd/drbd_worker.c                   | 1528 +++++++
 drivers/block/drbd/drbd_wrappers.h                 |   91 +
 drivers/mtd/mtd_blkdevs.c                          |   19 +-
 drivers/staging/dst/dcore.c                        |    2 +-
 fs/bio.c                                           |   49 +-
 include/linux/blkdev.h                             |    9 +-
 include/linux/blktrace_api.h                       |    2 +
 include/linux/drbd.h                               |  349 ++
 include/linux/drbd_limits.h                        |  137 +
 include/linux/drbd_nl.h                            |  137 +
 include/linux/drbd_tag_magic.h                     |   83 +
 include/linux/lru_cache.h                          |  294 ++
 include/trace/events/block.h                       |   33 +
 kernel/trace/blktrace.c                            |   39 +
 lib/Kconfig                                        |    3 +
 lib/Makefile                                       |    2 +
 lib/lru_cache.c                                    |  560 +++
 mm/swapfile.c                                      |   12 +-
 52 files changed, 23993 insertions(+), 414 deletions(-)
 create mode 100644 Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg
 create mode 100644 Documentation/blockdev/drbd/DRBD-data-packets.svg
 create mode 100644 Documentation/blockdev/drbd/README.txt
 create mode 100644 Documentation/blockdev/drbd/conn-states-8.dot
 create mode 100644 Documentation/blockdev/drbd/disk-states-8.dot
 create mode 100644 Documentation/blockdev/drbd/drbd-connection-state-overview.dot
 create mode 100644 Documentation/blockdev/drbd/node-states-8.dot
 create mode 100644 drivers/block/drbd/Kconfig
 create mode 100644 drivers/block/drbd/Makefile
 create mode 100644 drivers/block/drbd/drbd_actlog.c
 create mode 100644 drivers/block/drbd/drbd_bitmap.c
 create mode 100644 drivers/block/drbd/drbd_int.h
 create mode 100644 drivers/block/drbd/drbd_main.c
 create mode 100644 drivers/block/drbd/drbd_nl.c
 create mode 100644 drivers/block/drbd/drbd_proc.c
 create mode 100644 drivers/block/drbd/drbd_receiver.c
 create mode 100644 drivers/block/drbd/drbd_req.c
 create mode 100644 drivers/block/drbd/drbd_req.h
 create mode 100644 drivers/block/drbd/drbd_strings.c
 create mode 100644 drivers/block/drbd/drbd_tracing.c
 create mode 100644 drivers/block/drbd/drbd_tracing.h
 create mode 100644 drivers/block/drbd/drbd_vli.h
 create mode 100644 drivers/block/drbd/drbd_worker.c
 create mode 100644 drivers/block/drbd/drbd_wrappers.h
 create mode 100644 include/linux/drbd.h
 create mode 100644 include/linux/drbd_limits.h
 create mode 100644 include/linux/drbd_nl.h
 create mode 100644 include/linux/drbd_tag_magic.h
 create mode 100644 include/linux/lru_cache.h
 create mode 100644 lib/lru_cache.c

-- 
Jens Axboe


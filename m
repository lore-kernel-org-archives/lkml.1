Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbZLFKpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbZLFKpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbZLFKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:45:34 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55961 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272AbZLFKpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:45:32 -0500
Date: Sun, 6 Dec 2009 11:45:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       philipp.reisner@linbit.com
Subject: [GIT PULL] block updates for 2.6.33-rc1
Message-ID: <20091206104538.GM8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are the block/IO related bits I have queued for the first big
push. The big part is the inclusion of drbd, the IO controller
support, a cciss driver update, and more CFQ tweaking. Apart from that
it's little updates here and there.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.33

Alberto Bertogli (1):
      Do not __always_inline bvec_kmap_irq() and bvec_kunmap_irq()

Alex Chiang (2):
      cciss: Make device attributes static
      cciss: change Cmd_sg_list.sg_chain_dma type to dma_addr_t

Changli Gao (1):
      sendfile(): check f_op.splice_write() rather than f_op.sendpage()

Christoph Hellwig (3):
      block: use normal I/O path for discard requests
      block: allow large discard requests
      blkdev: flush disk cache on ->fsync

Corrado Zoccolo (12):
      cfq-iosched: adapt slice to number of processes doing I/O
      cfq-iosched: preparation to handle multiple service trees
      cfq-iosched: reimplement priorities using different service trees
      cfq-iosched: enable idling for last queue on priority class
      cfq-iosched: fairness for sync no-idle queues
      cfq-iosched: simplify prio-unboost code
      cfq-iosched: fix next_rq computation
      cfq-iosched: cleanup unreachable code
      cfq-iosched: fix ncq detection code
      cfq-iosched: fix no-idle preemption logic
      cfq-iosched: idling on deep seeky sync queues
      cfq-iosched: fix corner cases in idling logic

Don Brace (1):
      cciss: Add enhanced scatter-gather support.

Gui Jianfeng (1):
      cfq: Make use of service count to estimate the rb_key offset

H Hartley Sweeten (1):
      block/scsi_ioctl.c: quiet sparse noise

Hideyuki Sasaki (1):
      block/ps3: fix slow VRAM IO

Ilya Loginov (1):
      block: add helpers to run flush_dcache_page() against a bio and a request's pages

Jeff Moyer (6):
      cfq: calculate the seek_mean per cfq_queue not per cfq_io_context
      cfq: merge cooperating cfq_queues
      cfq: change the meaning of the cfqq_coop flag
      cfq: break apart merged cfqqs if they stop cooperating
      block: get rid of the WRITE_ODIRECT flag
      aio: implement request batching

Jens Axboe (21):
      drbd: remove tracing bits
      block: remove the anticipatory IO scheduler
      block: CFQ is more than a desktop scheduler
      Merge branch 'master' into for-2.6.33
      drbd: fixup for reverted dual in_flight patch
      Merge branch 'for-linus' into for-2.6.33
      cfq-iosched: fix style issue in cfq_get_avg_queues()
      drbd: fix in_flight rw indexing
      block: move bdi/address_space unplug functions to backing-dev.h
      Merge branch 'cfq-2.6.33' into for-2.6.33
      Merge branch 'for-linus' into for-2.6.33
      cfq-iosched: fix merge error
      cfq-iosched: get rid of the coop_preempt flag
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-2.6.33
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-2.6.33
      Revert "cfq: Make use of service count to estimate the rb_key offset"
      Merge branch 'master' into for-2.6.33
      cfq-iosched: fix compile problem with !CONFIG_CGROUP
      cfq-iosched: move IO controller declerations to a header file
      io controller: quick fix for blk-cgroup and modular CFQ
      cfq-iosched: use call_rcu() instead of doing grace period stall on queue exit

Jun'ichi Nomura (1):
      Add a tracepoint for block request remapping

Karel Zak (2):
      partitions: use sector size for EFI GPT
      partitions: read whole sector with EFI GPT header

Lars Ellenberg (7):
      dropping unneeded include autoconf.h
      change default: by default, use socket buffer auto tuning
      fix grammar in printk
      drbd: fix check for too large lower level device
      drbd: performance - don't lose unplug events
      fix in-kernel configuration serialization
      add missing state change on corrupt packet header in drbd_recv_header

Louis Rilling (2):
      block: Fix io_context leak after clone with CLONE_IO
      block: Fix io_context leak after failure of clone with CLONE_IO

Martin K. Petersen (2):
      block: Expose discard granularity
      block: Allow devices to indicate whether discarded blocks are zeroed

OGAWA Hirofumi (1):
      flusher: Fix PF_FROZEN race

Philipp Reisner (10):
      The DRBD driver
      drbd: Work on permission enforcement
      Merge branch 'for-2.6.33' of git://git.kernel.dk/linux-2.6-block into for-2.6.33
      drbdsetup X resume-io should be usable to resume IO [Bugz 256]
      Do not deadlock in drbd_disconnect() [bugz 258]
      Now it is equal to DRBD release 8.3.5 without compat crap
      Fixed a regression in resync decission code drbd_uuid_compare() [Bugz 260]
      DRBD: Now the code is 8.3.6 + 3 fixes (without compat crap)
      drbd: moved CN_IDX_DRBD and CN_VAL_DRBD to the right file
      drbd_req.c: use part_[inc|dec]_in_flight()

Randy Dunlap (2):
      drbd: needs __ratelimit()
      block: jiffies fixes

Shaohua Li (3):
      cfq-iosched: improve hw_tag detection
      cfq-iosched: no dispatch limit for single queue
      cfq-iosched: make nonrot check logic consistent

Stephen M. Cameron (10):
      cciss: Fix problem with remove_from_scan_list on driver unload
      cciss: Retry driver initiated cmds with unit attention condition
      cciss: Remove the "withirq" parameter from various functions where possible
      cciss: clean up code in cciss_shutdown
      cciss: remove sendcmd() as it is no longer used.
      cciss: fix typo that causes scsi status to be lost.
      cciss: Remove unnecessary check in scan_thread
      cciss: Do not automatically rescan on UNIT ATTENTION/LUN DATA CHANGED
      cciss: Fix weird usage of ENXIO in cciss_scsi.c
      cciss: fix scatter gather cleanup problems

Vivek Goyal (25):
      Fix regression in direct writes performance due to WRITE_ODIRECT flag removal
      blkio: Set must_dispatch only if we decided to not dispatch the request
      blkio: Introduce the notion of cfq groups
      blkio: Implement macro to traverse each service tree in group
      blkio: Keep queue on service tree until we expire it
      blkio: Introduce the root service tree for cfq groups
      blkio: Introduce blkio controller cgroup interface
      blkio: Introduce per cfq group weights and vdisktime calculations
      blkio: Implement per cfq group latency target and busy queue avg
      blkio: Group time used accounting and workload context save restore
      blkio: Dynamic cfq group creation based on cgroup tasks belongs to
      blkio: Take care of cgroup deletion and cfq group reference counting
      blkio: Some debugging aids for CFQ
      blkio: Export disk time and sectors used by a group to user space
      blkio: Provide some isolation between groups
      blkio: Drop the reference to queue once the task changes cgroup
      blkio: Propagate cgroup weight updation to cfq groups
      blkio: Wait for cfq queue to get backlogged if group is empty
      blkio: Determine async workload length based on total number of queues
      blkio: Implement group_isolation tunable
      blkio: Wait on sync-noidle queue even if rq_noidle = 1
      blkio: Documentation
      blkio: Export some symbols from blkio as its user CFQ can be a module
      blkio: Implement dynamic io controlling policy registration
      blkio: Allow CFQ group IO scheduling even when CFQ is a module

Wu Fengguang (3):
      writeback: remove the always false bdi_cap_writeback_dirty() test
      writeback: introduce wbc.for_background
      writeback: remove unused nonblocking and congestion checks

 .../blockdev/drbd/DRBD-8.3-data-packets.svg        |  588 +++
 Documentation/blockdev/drbd/DRBD-data-packets.svg  |  459 ++
 Documentation/blockdev/drbd/README.txt             |   16 +
 Documentation/blockdev/drbd/conn-states-8.dot      |   18 +
 Documentation/blockdev/drbd/disk-states-8.dot      |   16 +
 .../drbd/drbd-connection-state-overview.dot        |   85 +
 Documentation/blockdev/drbd/node-states-8.dot      |   14 +
 Documentation/cgroups/blkio-controller.txt         |  135 +
 MAINTAINERS                                        |   13 +
 arch/alpha/include/asm/cacheflush.h                |    1 +
 arch/arm/include/asm/cacheflush.h                  |    1 +
 arch/avr32/include/asm/cacheflush.h                |    1 +
 arch/blackfin/include/asm/cacheflush.h             |    2 +
 arch/cris/include/asm/cacheflush.h                 |    1 +
 arch/frv/include/asm/cacheflush.h                  |    1 +
 arch/h8300/include/asm/cacheflush.h                |    1 +
 arch/ia64/include/asm/cacheflush.h                 |    1 +
 arch/m32r/include/asm/cacheflush.h                 |    3 +
 arch/m68k/include/asm/cacheflush_mm.h              |    1 +
 arch/m68k/include/asm/cacheflush_no.h              |    1 +
 arch/microblaze/include/asm/cacheflush.h           |    1 +
 arch/mips/include/asm/cacheflush.h                 |    1 +
 arch/mn10300/include/asm/cacheflush.h              |    1 +
 arch/parisc/include/asm/cacheflush.h               |    1 +
 arch/powerpc/include/asm/cacheflush.h              |    1 +
 arch/s390/include/asm/cacheflush.h                 |    1 +
 arch/score/include/asm/cacheflush.h                |    1 +
 arch/sh/include/asm/cacheflush.h                   |    1 +
 arch/sparc/include/asm/cacheflush_32.h             |    1 +
 arch/sparc/include/asm/cacheflush_64.h             |    1 +
 arch/x86/include/asm/cacheflush.h                  |    1 +
 arch/xtensa/include/asm/cacheflush.h               |    1 +
 block/Kconfig                                      |   22 +
 block/Kconfig.iosched                              |   43 +-
 block/Makefile                                     |    2 +-
 block/as-iosched.c                                 | 1520 -------
 block/blk-cgroup.c                                 |  360 ++
 block/blk-cgroup.h                                 |  127 +
 block/blk-core.c                                   |   19 +
 block/blk-ioc.c                                    |   12 +-
 block/blk-settings.c                               |   51 +-
 block/blk-sysfs.c                                  |   33 +
 block/bsg.c                                        |    3 +-
 block/cfq-iosched.c                                | 1492 ++++++-
 block/compat_ioctl.c                               |    2 +
 block/elevator.c                                   |   10 +-
 block/genhd.c                                      |   12 +
 block/ioctl.c                                      |    2 +
 block/scsi_ioctl.c                                 |    6 +-
 drivers/block/Kconfig                              |    2 +
 drivers/block/Makefile                             |    1 +
 drivers/block/cciss.c                              |  544 ++--
 drivers/block/cciss.h                              |   18 +-
 drivers/block/cciss_cmd.h                          |    7 +-
 drivers/block/cciss_scsi.c                         |    4 +-
 drivers/block/drbd/Kconfig                         |   71 +
 drivers/block/drbd/Makefile                        |    5 +
 drivers/block/drbd/drbd_actlog.c                   | 1424 +++++++
 drivers/block/drbd/drbd_bitmap.c                   | 1327 ++++++
 drivers/block/drbd/drbd_int.h                      | 2252 ++++++++++
 drivers/block/drbd/drbd_main.c                     | 3699 ++++++++++++++++
 drivers/block/drbd/drbd_nl.c                       | 2364 +++++++++++
 drivers/block/drbd/drbd_proc.c                     |  265 ++
 drivers/block/drbd/drbd_receiver.c                 | 4426 ++++++++++++++++++++
 drivers/block/drbd/drbd_req.c                      | 1125 +++++
 drivers/block/drbd/drbd_req.h                      |  326 ++
 drivers/block/drbd/drbd_strings.c                  |  113 +
 drivers/block/drbd/drbd_vli.h                      |  351 ++
 drivers/block/drbd/drbd_worker.c                   | 1512 +++++++
 drivers/block/drbd/drbd_wrappers.h                 |   91 +
 drivers/block/ps3vram.c                            |   10 +-
 drivers/mtd/mtd_blkdevs.c                          |    2 +
 drivers/staging/pohmelfs/inode.c                   |   10 -
 fs/aio.c                                           |   62 +-
 fs/bio.c                                           |   12 +
 fs/block_dev.c                                     |   12 +-
 fs/direct-io.c                                     |   10 +-
 fs/fs-writeback.c                                  |   28 +-
 fs/nfs/write.c                                     |    2 +-
 fs/partitions/check.c                              |   12 +
 fs/partitions/efi.c                                |   30 +-
 fs/partitions/efi.h                                |    8 +-
 fs/read_write.c                                    |    2 -
 fs/splice.c                                        |   24 +-
 fs/xfs/linux-2.6/xfs_aops.c                        |    9 +-
 include/asm-generic/cacheflush.h                   |    1 +
 include/linux/backing-dev.h                        |   13 +
 include/linux/bio.h                                |   20 +-
 include/linux/blkdev.h                             |   56 +-
 include/linux/cgroup_subsys.h                      |    6 +
 include/linux/connector.h                          |    2 +
 include/linux/drbd.h                               |  343 ++
 include/linux/drbd_limits.h                        |  137 +
 include/linux/drbd_nl.h                            |  137 +
 include/linux/drbd_tag_magic.h                     |   83 +
 include/linux/fs.h                                 |    5 +-
 include/linux/genhd.h                              |    1 +
 include/linux/iocontext.h                          |   14 +-
 include/linux/lru_cache.h                          |  294 ++
 include/linux/writeback.h                          |    1 +
 kernel/exit.c                                      |    2 +-
 kernel/fork.c                                      |    3 +-
 lib/Kconfig                                        |    3 +
 lib/Makefile                                       |    2 +
 lib/lru_cache.c                                    |  560 +++
 mm/backing-dev.c                                   |    2 +-
 mm/page-writeback.c                                |   12 -
 107 files changed, 24811 insertions(+), 2132 deletions(-)
 create mode 100644 Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg
 create mode 100644 Documentation/blockdev/drbd/DRBD-data-packets.svg
 create mode 100644 Documentation/blockdev/drbd/README.txt
 create mode 100644 Documentation/blockdev/drbd/conn-states-8.dot
 create mode 100644 Documentation/blockdev/drbd/disk-states-8.dot
 create mode 100644 Documentation/blockdev/drbd/drbd-connection-state-overview.dot
 create mode 100644 Documentation/blockdev/drbd/node-states-8.dot
 create mode 100644 Documentation/cgroups/blkio-controller.txt
 delete mode 100644 block/as-iosched.c
 create mode 100644 block/blk-cgroup.c
 create mode 100644 block/blk-cgroup.h
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


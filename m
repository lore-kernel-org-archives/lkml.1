Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbZFKLNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbZFKLNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762836AbZFKLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:13:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51655 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZFKLNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:13:37 -0400
Date: Thu, 11 Jun 2009 13:13:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] first block round for 2.6.31
Message-ID: <20090611111339.GQ11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the bulk of the block changes for 2.6.31, please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.31

Akinobu Mita (1):
      loop: use BIO list management functions

Andrew Morton (2):
      splice: fix error return code
      cciss: use schedule_timeout_interruptible()

Andrew Patterson (1):
      cciss: add cciss driver sysfs entries

Bartlomiej Zolnierkiewicz (4):
      mg_disk: fix CONFIG_LBD=y warning
      block: enable by default support for large devices and files on 32-bit archs
      mg_disk: fix dependency on libata
      mg_disk: use defines from <linux/ata.h>

Boaz Harrosh (5):
      libosd: Use new blk_rq_map_kern
      block: Add blk_make_request(), takes bio, returns a request
      libosd: Use of new blk_make_request
      block: Un-export blk_rq_append_bio
      scsi_lib: remove unused variable

Borislav Petkov (3):
      ide: add helpers for preparing sense requests
      ide-cd: convert to using generic sense request
      ide-atapi: convert ide-{floppy,tape} to using preallocated sense buffer

Christoph Hellwig (1):
      virtio_blk: don't blindly derefence req->rq_disk

FUJITA Tomonori (4):
      block: let blk_end_request_all handle bidi requests
      scsi: simplify the bidi completion
      block: move completion related functions back to blk-core.c
      block: needs to set the residual length of a bidi request

Hannes Reinecke (1):
      virtio_blk: SG_IO passthru support

James Bottomley (3):
      block: allow blk_rq_map_kern to append to requests
      block: fix oops with block tag queueing
      block: fix an oops on BLKPREP_KILL

Jeff Moyer (1):
      block: implement blkdev_readpages

Jens Axboe (11):
      block: make blk_do_io_stat() do the full "is this rq accountable" checks
      block: include discard requests in IO accounting
      splice: fix misleading comment
      splice: fix repeated kmap()'s in default_file_splice_read()
      virtio_blk: get rid of unused variable
      block: add warning to blk_make_request()
      block: change the tag sync vs async restriction logic
      Merge branch 'master' into for-2.6.31
      Merge branch 'master' into for-2.6.31
      Revert "block: implement blkdev_readpages"
      Revert "block: Fix bounce limit setting in DM"

Kiyoshi Ueda (3):
      block: fix no diskstat problem
      block: fix a possible oops on elv_abort_queue()
      block: add request clone interface (v2)

Martin K. Petersen (8):
      block: Do away with the notion of hardsect_size
      block: Use accessor functions for queue limits
      block: Move queue limits to an embedded struct
      block: Expose stacked device queues in sysfs
      block: Export I/O topology for block devices and partitions
      ide-disk: fix missing max_sectors accessor function
      block: Fix bounce limit setting in DM
      block: Add missing bounce_pfn stacking and fix comments

Michal Simek (1):
      fs/bio.c: add missing __user annotation

Mike Snitzer (1):
      block: export blk_stack_limits()

Miklos Szeredi (4):
      splice: implement pipe to pipe splicing
      splice: implement default splice_read method
      splice: implement default splice_write method
      splice: fix kmaps in default_file_splice_write()

Nikanth Karthikesan (2):
      block: catch trying to use more bits than request->cmd_flags has
      block: prevent possible io_context->refcount overflow

Ondrej Zary (1):
      floppy: fix hibernation

Robert P. J. Day (1):
      ramdisk: remove long-deprecated "ramdisk=" boot-time parameter

Roel Kluin (1):
      xen-blkfront: beyond ARRAY_SIZE of info->shadow

Stephen M. Cameron (2):
      cciss: factor out core of sendcmd() for a more sane interface
      cciss: fix SCSI device reset handler

Tejun Heo (84):
      mg_disk: fix locking
      hd: fix locking
      block: clear req->errors on bio completion only for fs requests
      ide-tape: remove back-to-back REQUEST_SENSE detection
      ide: use blk_run_queue() instead of blk_start_queueing()
      ide: don't set REQ_SOFTBARRIER
      ide kill unused ide_cmd->special
      ide-cd: clear sense buffer before issuing request sense
      ide-floppy: block pc always uses bio
      ide-taskfile: don't abuse rq->buffer
      ide-atapi: don't abuse rq->buffer
      ide-cd: don't abuse rq->buffer
      ide-cd,atapi: use bio for internal commands
      ide-pm: don't abuse rq->data
      ide-tape,floppy: fix failed command completion after request sense
      ide-atapi,tape,floppy: allow ->pc_callback() to change rq->data_len
      ide-tape: use single continuous buffer
      ide-tape: use standard data transfer mechanism
      ide-tape: kill idetape_bh
      ide-tape: unify r/w init paths
      ide-tape: use byte size instead of sectors on rw issue functions
      ide-tape: simplify read/write functions
      ide-atapi: kill unused fields and callbacks
      ide: drop rq->data handling from ide_map_sg()
      ide-dma: don't reset request fields on dma_timeout_retry()
      block: merge blk_invoke_request_fn() into __blk_run_queue()
      block: kill blk_start_queueing()
      block: don't set REQ_NOMERGE unnecessarily
      block: cleanup REQ_SOFTBARRIER usages
      block: clean up misc stuff after block layer timeout conversion
      block: reorder request completion functions
      block: reorganize request fetching functions
      block: kill blk_end_request_callback()
      block: clean up request completion API
      block: move rq->start_time initialization to blk_rq_init()
      block: implement and use [__]blk_end_request_all()
      block: replace end_request() with [__]blk_end_request_cur()
      arm-omap: don't abuse rq->data
      block: kill rq->data
      block: make blk_end_request_cur() return bool
      block: don't init rq fields unnecessarily
      amiflop,ataflop,xd,mg_disk: clean up unnecessary stuff from block drivers
      ps3disk: simplify request completion
      sunvdc: kill vdc_end_request()
      ubd: cleanup completion path
      ubd: drop unnecessary rq->sector manipulation
      hd: clean up request completion paths
      swim3: clean up request completion paths
      swim: clean up request completion paths
      mg_disk: fold mg_disk.h into mg_disk.c
      mg_disk: clean up request completion paths
      nbd: don't clear rq->sector and nr_sectors unnecessarily
      ide-tape: don't initialize rq->sector for rw requests
      block: add rq->resid_len
      block: implement blk_rq_pos/[cur_]sectors() and convert obvious ones
      block: convert to pos and nr_sectors accessors
      ide: convert to rq pos and nr_sectors accessors
      block: drop request->hard_* and *nr_sectors
      block: cleanup rq->data_len usages
      ide: cleanup rq->data_len usages
      block: hide request sector and data_len
      block: blk_rq_[cur_]_{sectors|bytes}() usage cleanup
      ide: dequeue in-flight request
      mg_disk: fix queue hang / infinite retry on !fs requests
      mg_disk: dequeue and track in-flight request
      hd: dequeue and track in-flight request
      ataflop: dequeue and track in-flight request
      swim3: dequeue in-flight request
      xsysace: dequeue in-flight request
      paride: dequeue in-flight request
      ps3disk: dequeue in-flight request
      amiflop: dequeue in-flight request
      swim: dequeue in-flight request
      xd: dequeue in-flight request
      mtd_blkdevs: dequeue in-flight request
      jsflash: dequeue in-flight request
      z2ram: dequeue in-flight request
      block: convert to dequeueing model (easy ones)
      gdrom: dequeue in-flight request
      block: implement and enforce request peek/start/fetch
      scsi: fix resid_len mis-conversion in scsi_end_request()
      ub: use __blk_end_request_all()
      block: set rq->resid_len to blk_rq_bytes() on issue
      bio: always copy back data for copied kernel requests

john cooper (1):
      Add serial number support for virtio_blk, V4a

scameron@beardog.cca.cpqcorp.net (8):
      cciss: Use schedule_timeout_uninterruptible in SCSI error handling code
      cciss: factor out core of sendcmd_withirq() for use by SCSI error handling code
      cciss: simplify interface of sendcmd() and sendcmd_withirq()
      cciss: factor out fix target status processing code from sendcmd functions
      cciss: separate error processing and command retrying code in sendcmd_withirq_core()
      cciss: change SCSI error handling routines to work with interrupts enabled.
      cciss: Remove no longer needed sendcmd reject processing code
      cciss: decode unit attention in SCSI error handling code

vibi sreenivasan (1):
      Removed reference to non-existing file Documentation/PCI/PCI-DMA-mapping.txt

 Documentation/ABI/testing/sysfs-block              |   59 ++
 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   33 +
 Documentation/block/biodoc.txt                     |    2 +-
 arch/arm/plat-omap/mailbox.c                       |   63 +-
 arch/powerpc/sysdev/axonram.c                      |    2 +-
 arch/um/drivers/ubd_kern.c                         |   36 +-
 block/Kconfig                                      |   11 +-
 block/as-iosched.c                                 |   24 +-
 block/blk-barrier.c                                |   27 +-
 block/blk-core.c                                   |  858 ++++++++++++-------
 block/blk-exec.c                                   |    1 -
 block/blk-integrity.c                              |    2 +-
 block/blk-ioc.c                                    |   12 +-
 block/blk-map.c                                    |   25 +-
 block/blk-merge.c                                  |   71 +-
 block/blk-settings.c                               |  269 +++++-
 block/blk-sysfs.c                                  |   59 +-
 block/blk-tag.c                                    |   17 +-
 block/blk-timeout.c                                |   22 +-
 block/blk.h                                        |   51 +-
 block/bsg.c                                        |    8 +-
 block/cfq-iosched.c                                |   38 +-
 block/compat_ioctl.c                               |    4 +-
 block/deadline-iosched.c                           |    2 +-
 block/elevator.c                                   |  185 +----
 block/genhd.c                                      |   11 +
 block/ioctl.c                                      |   12 +-
 block/scsi_ioctl.c                                 |   13 +-
 drivers/ata/libata-scsi.c                          |    2 +-
 drivers/block/DAC960.c                             |   10 +-
 drivers/block/Kconfig                              |    2 +-
 drivers/block/amiflop.c                            |   54 +-
 drivers/block/ataflop.c                            |   66 +-
 drivers/block/brd.c                                |    7 +-
 drivers/block/cciss.c                              |  927 ++++++++++++--------
 drivers/block/cciss.h                              |   34 +-
 drivers/block/cciss_cmd.h                          |    2 +
 drivers/block/cciss_scsi.c                         |  109 ++-
 drivers/block/cpqarray.c                           |   20 +-
 drivers/block/floppy.c                             |   85 ++-
 drivers/block/hd.c                                 |  106 ++--
 drivers/block/loop.c                               |   37 +-
 drivers/block/mg_disk.c                            |  537 +++++++-----
 drivers/block/nbd.c                                |   23 +-
 drivers/block/paride/pcd.c                         |   29 +-
 drivers/block/paride/pd.c                          |   22 +-
 drivers/block/paride/pf.c                          |   47 +-
 drivers/block/pktcdvd.c                            |    8 +-
 drivers/block/ps3disk.c                            |   24 +-
 drivers/block/sunvdc.c                             |   14 +-
 drivers/block/swim.c                               |   48 +-
 drivers/block/swim3.c                              |  107 ++--
 drivers/block/sx8.c                                |   17 +-
 drivers/block/ub.c                                 |   54 +-
 drivers/block/viodasd.c                            |   12 +-
 drivers/block/virtio_blk.c                         |  110 ++-
 drivers/block/xd.c                                 |   41 +-
 drivers/block/xen-blkfront.c                       |   34 +-
 drivers/block/xsysace.c                            |   46 +-
 drivers/block/z2ram.c                              |   19 +-
 drivers/cdrom/cdrom.c                              |    4 +-
 drivers/cdrom/gdrom.c                              |   36 +-
 drivers/cdrom/viocd.c                              |   33 +-
 drivers/char/raw.c                                 |    2 +-
 drivers/ide/ide-atapi.c                            |  177 +++--
 drivers/ide/ide-cd.c                               |  152 +---
 drivers/ide/ide-cd.h                               |    4 -
 drivers/ide/ide-disk.c                             |   11 +-
 drivers/ide/ide-dma.c                              |   22 +-
 drivers/ide/ide-floppy.c                           |   32 +-
 drivers/ide/ide-io.c                               |   57 +-
 drivers/ide/ide-ioctls.c                           |    1 -
 drivers/ide/ide-lib.c                              |    2 +-
 drivers/ide/ide-park.c                             |    7 +-
 drivers/ide/ide-pm.c                               |   38 +-
 drivers/ide/ide-tape.c                             |  735 ++++------------
 drivers/ide/ide-taskfile.c                         |   20 +-
 drivers/ide/pdc202xx_old.c                         |    2 +-
 drivers/ide/tc86c001.c                             |    2 +-
 drivers/ide/tx4939ide.c                            |    2 +-
 drivers/md/bitmap.c                                |    4 +-
 drivers/md/dm-exception-store.c                    |    2 +-
 drivers/md/dm-log.c                                |    3 +-
 drivers/md/dm-snap-persistent.c                    |    2 +-
 drivers/md/dm-table.c                              |   38 +-
 drivers/md/linear.c                                |    2 +-
 drivers/md/md.c                                    |    2 +-
 drivers/md/multipath.c                             |    4 +-
 drivers/md/raid0.c                                 |    2 +-
 drivers/md/raid1.c                                 |    4 +-
 drivers/md/raid10.c                                |    8 +-
 drivers/md/raid5.c                                 |    4 +-
 drivers/memstick/core/mspro_block.c                |   19 +-
 drivers/message/fusion/mptsas.c                    |   22 +-
 drivers/message/i2o/i2o_block.c                    |   43 +-
 drivers/mmc/card/block.c                           |   12 +-
 drivers/mmc/card/queue.c                           |   11 +-
 drivers/mtd/mtd_blkdevs.c                          |   43 +-
 drivers/s390/block/dasd.c                          |   37 +-
 drivers/s390/block/dasd_diag.c                     |    5 +-
 drivers/s390/block/dasd_eckd.c                     |    6 +-
 drivers/s390/block/dasd_fba.c                      |    7 +-
 drivers/s390/block/dcssblk.c                       |    2 +-
 drivers/s390/block/xpram.c                         |    2 +-
 drivers/s390/char/tape_34xx.c                      |    2 +-
 drivers/s390/char/tape_3590.c                      |    2 +-
 drivers/s390/char/tape_block.c                     |   26 +-
 drivers/sbus/char/jsflash.c                        |   26 +-
 drivers/scsi/eata.c                                |   24 +-
 drivers/scsi/libsas/sas_expander.c                 |   16 +-
 drivers/scsi/libsas/sas_host_smp.c                 |   49 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   22 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c           |   23 +-
 drivers/scsi/osd/osd_initiator.c                   |   72 +-
 drivers/scsi/scsi_lib.c                            |   87 +--
 drivers/scsi/scsi_tgt_lib.c                        |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    4 +-
 drivers/scsi/sd.c                                  |   26 +-
 drivers/scsi/sd_dif.c                              |    2 +-
 drivers/scsi/sg.c                                  |   17 +-
 drivers/scsi/sr.c                                  |   17 +-
 drivers/scsi/st.c                                  |    6 +-
 drivers/scsi/u14-34f.c                             |   22 +-
 drivers/usb/storage/scsiglue.c                     |    4 +-
 fs/bio.c                                           |   26 +-
 fs/block_dev.c                                     |    6 +-
 fs/buffer.c                                        |    6 +-
 fs/coda/file.c                                     |    9 +-
 fs/direct-io.c                                     |    2 +-
 fs/exofs/osd.c                                     |    4 +-
 fs/ext3/super.c                                    |    4 +-
 fs/ext4/super.c                                    |    2 +-
 fs/gfs2/ops_fstype.c                               |    4 +-
 fs/gfs2/rgrp.c                                     |    2 +-
 fs/nilfs2/the_nilfs.c                              |    2 +-
 fs/ntfs/super.c                                    |    6 +-
 fs/ocfs2/cluster/heartbeat.c                       |    2 +-
 fs/ocfs2/super.c                                   |    2 +-
 fs/partitions/check.c                              |   10 +
 fs/partitions/ibm.c                                |    2 +-
 fs/partitions/msdos.c                              |    4 +-
 fs/pipe.c                                          |   14 +
 fs/read_write.c                                    |    7 +-
 fs/splice.c                                        |  338 +++++++-
 fs/udf/super.c                                     |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c                         |    2 +-
 include/linux/bio.h                                |   10 +-
 include/linux/blkdev.h                             |  245 ++++--
 include/linux/device-mapper.h                      |    2 +-
 include/linux/elevator.h                           |    4 +-
 include/linux/fs.h                                 |    2 +
 include/linux/genhd.h                              |    1 +
 include/linux/ide.h                                |   27 +-
 include/linux/iocontext.h                          |    6 +-
 include/linux/loop.h                               |    3 +-
 include/linux/mg_disk.h                            |  206 -----
 include/linux/pipe_fs_i.h                          |    1 +
 include/linux/splice.h                             |    3 +-
 include/linux/virtio_blk.h                         |   12 +
 include/scsi/scsi_cmnd.h                           |    2 +-
 kernel/trace/blktrace.c                            |   16 +-
 mm/bounce.c                                        |    4 +-
 162 files changed, 4126 insertions(+), 3516 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
 delete mode 100644 include/linux/mg_disk.h

-- 
Jens Axboe


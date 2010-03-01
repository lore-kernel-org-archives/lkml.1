Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0CAMQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 07:16:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0CAMQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 07:16:53 -0500
Date: Mon, 1 Mar 2010 13:16:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.34-rc1
Message-ID: <20100301121651.GW5768@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing earth shattering in here:

- Various tweaks to CFQ, mostly a few performance tweaks.
- cciss driver update
- Cleanup/unification of the max transfer size setting for drivers, this
  was left in a bit of a mess after the io limits patches.
- Switch block core and pktcdvd to using the bio list instead of doing
  they own list management.
- Modify the 'nomerges' sysfs knob to be able to completely turn off
  merges. We used to have 0/1 possibilities, but even with nomerges==1,
  we would check and perform last_hit merges. For testing, it's useful
  to disable even that bit. The new value '2' turns off all merging.
- Various other small patchlets.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-2.6.34

Akinobu Mita (2):
      blk-core: use BIO list management functions
      pktcdvd: use BIO list management functions

Alan D. Brunelle (1):
      block: Added in stricter no merge semantics for block I/O

Corrado Zoccolo (3):
      cfq-iosched: rework seeky detection
      cfq-iosched: rethink seeky detection for SSDs
      cfq-iosched: requests "in flight" vs "in driver" clarification

Dmitry Monakhov (2):
      blkdev: fix merge_bvec_fn return value checks
      blktrace: perform cleanup after setup error

Gui Jianfeng (1):
      cfq: Remove useless css reference get

Jens Axboe (3):
      Merge branch 'master' into for-2.6.34
      Merge branch 'master' into for-2.6.34
      Merge branch 'for-2.6.34-next' into for-2.6.34

Martin K. Petersen (6):
      block: Stop using byte offsets
      block: Update blk_queue_max_sectors and documentation
      block: Remove unused accessor function
      block: Add BLK_ prefix to definitions
      block: Rename blk_queue_max_sectors to blk_queue_max_hw_sectors
      block: Consolidate phys_segment and hw_segment limits

Márton Németh (5):
      block: make PCI device id constant
      block: make USB device id constant
      block: make Open Firmware device id constant
      block: make xenbus device id constant
      block: make virtio device id constant

Richard Kennedy (4):
      cfq: reorder cfq_queue removing padding on 64bit
      block: remove padding from io_context on 64bit builds
      cfq: remove 8 bytes of padding from cfq_rb_root on 64 bit builds
      block: don't access jiffies when initialising io_context

Shaohua Li (1):
      cfq-iosched: quantum check tweak

Stephen M. Cameron (9):
      cciss: clarify command list padding calculation
      cciss: detect bad alignment of scsi commands at build time
      cciss: factor out scatter gather chain block allocation and freeing
      cciss: simplify scatter gather code
      cciss: fix scatter gather chain block dma direction kludge
      cciss: factor out scatter gather chain block mapping code
      cciss: do not use void pointer for scsi hba data
      cciss: eliminate unnecessary pointer use in cciss scsi code
      cciss: Fix problem with scatter gather elements in the scsi half of the driver

Stephen Rothwell (1):
      block: fix for "Consolidate phys_segment and hw_segment limits"

dann frazier (3):
      cciss: remove C99-style comments
      cciss: Consolidate duplicate bits in cciss_cmd.h & cciss_ioctl.h
      cciss: export linux/cciss_defs.h header

 Documentation/ABI/testing/sysfs-block |   14 ++
 Documentation/block/queue-sysfs.txt   |   10 +-
 arch/um/drivers/ubd_kern.c            |    4 +-
 block/blk-cgroup.c                    |   14 --
 block/blk-cgroup.h                    |    3 -
 block/blk-core.c                      |   34 +++---
 block/blk-ioc.c                       |    2 +-
 block/blk-merge.c                     |    8 +-
 block/blk-settings.c                  |  131 +++++++-------------
 block/blk-sysfs.c                     |   11 +-
 block/cfq-iosched.c                   |  147 ++++++++++------------
 block/elevator.c                      |   11 ++-
 drivers/ata/libata-scsi.c             |    2 +-
 drivers/ata/sata_nv.c                 |    2 +-
 drivers/block/DAC960.c                |    6 +-
 drivers/block/brd.c                   |    2 +-
 drivers/block/cciss.c                 |  218 ++++++++++++++++-----------------
 drivers/block/cciss.h                 |   21 +---
 drivers/block/cciss_cmd.h             |  164 +++++--------------------
 drivers/block/cciss_scsi.c            |  145 +++++++++++++---------
 drivers/block/cciss_scsi.h            |   18 ++--
 drivers/block/cpqarray.c              |    5 +-
 drivers/block/drbd/drbd_nl.c          |    5 +-
 drivers/block/floppy.c                |    2 +-
 drivers/block/hd.c                    |    2 +-
 drivers/block/mg_disk.c               |    2 +-
 drivers/block/paride/pd.c             |    2 +-
 drivers/block/paride/pf.c             |    3 +-
 drivers/block/pktcdvd.c               |   97 ++++-----------
 drivers/block/ps3disk.c               |    5 +-
 drivers/block/ps3vram.c               |    7 +-
 drivers/block/sunvdc.c                |    5 +-
 drivers/block/sx8.c                   |    5 +-
 drivers/block/ub.c                    |    7 +-
 drivers/block/viodasd.c               |    5 +-
 drivers/block/virtio_blk.c            |    2 +-
 drivers/block/xd.c                    |    2 +-
 drivers/block/xen-blkfront.c          |    7 +-
 drivers/block/xsysace.c               |    2 +-
 drivers/cdrom/gdrom.c                 |    2 +-
 drivers/cdrom/viocd.c                 |    5 +-
 drivers/firewire/sbp2.c               |    2 +-
 drivers/ide/ide-disk.c                |    2 +-
 drivers/ide/ide-floppy.c              |    4 +-
 drivers/ide/ide-probe.c               |    5 +-
 drivers/ieee1394/sbp2.c               |    2 +-
 drivers/md/linear.c                   |    2 +-
 drivers/md/multipath.c                |    4 +-
 drivers/md/raid0.c                    |    4 +-
 drivers/md/raid1.c                    |    4 +-
 drivers/md/raid10.c                   |    4 +-
 drivers/md/raid5.c                    |    2 +-
 drivers/memstick/core/mspro_block.c   |    5 +-
 drivers/message/i2o/i2o_block.c       |    5 +-
 drivers/mmc/card/queue.c              |   10 +-
 drivers/s390/block/dasd.c             |    5 +-
 drivers/s390/char/tape_block.c        |    5 +-
 drivers/scsi/ibmvscsi/ibmvfc.c        |    4 +-
 drivers/scsi/ipr.c                    |    2 +-
 drivers/scsi/pmcraid.c                |    2 +-
 drivers/scsi/scsi_lib.c               |    6 +-
 drivers/scsi/scsi_scan.c              |    2 +-
 drivers/scsi/sg.c                     |    6 +-
 drivers/scsi/st.c                     |    3 +-
 drivers/staging/hv/blkvsc_drv.c       |    5 +-
 drivers/usb/storage/scsiglue.c        |    6 +-
 fs/bio.c                              |   13 +--
 fs/partitions/check.c                 |    7 +-
 include/linux/Kbuild                  |    1 +
 include/linux/blkdev.h                |   65 ++++++----
 include/linux/cciss_defs.h            |  130 ++++++++++++++++++++
 include/linux/cciss_ioctl.h           |  128 +-------------------
 include/linux/i2o.h                   |    2 +-
 include/linux/iocontext.h             |    2 +-
 include/linux/pktcdvd.h               |   10 +-
 include/linux/sched.h                 |    4 +-
 kernel/trace/blktrace.c               |    5 +-
 77 files changed, 704 insertions(+), 903 deletions(-)
 create mode 100644 include/linux/cciss_defs.h

-- 
Jens Axboe


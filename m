Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYGXTlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYGXTlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYGXTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:40:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:54760 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYGXTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iLbdaEoBFALQEy4WL2ZKwHOGlNyV+SojbSEBrlvgNiBJuGO1RmtQUSZn/9IShptu1H
         uAuY0xBTv4brkQrut/Oadyi6o00E9fmQfVb0bZIboBt8hvuQa2SYjctwFnUaoUXeQ8IZ
         25zd6PczMdm3UadWZ3BfzI4JCIXobtImqKiGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] convert <linux/hdreg.h> users to use <linux/hdio_ioctls.h>
Date: Thu, 24 Jul 2008 21:37:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242137.11834.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following files don't need <linux/hdreg.h> at all:

- arch/mips/jazz/setup.c
- arch/sh/boards/renesas/systemh/irq.c
- drivers/macintosh/mediabay.c
- drivers/scsi/hptiop.c
- drivers/usb/storage/freecom.c
- include/asm-powerpc/ide.h
- init/main.c

Convert the rest of files to use <linux/hdio_ioctls.h> instead
(this also fixes them from accidentially pulling <linux/ata.h> in).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 arch/mips/jazz/setup.c               |    1 -
 arch/sh/boards/renesas/systemh/irq.c |    1 -
 block/compat_ioctl.c                 |    2 +-
 block/ioctl.c                        |    2 +-
 drivers/block/DAC960.c               |    2 +-
 drivers/block/amiflop.c              |    2 +-
 drivers/block/aoe/aoeblk.c           |    2 +-
 drivers/block/aoe/aoechr.c           |    2 +-
 drivers/block/aoe/aoedev.c           |    2 +-
 drivers/block/aoe/aoemain.c          |    2 +-
 drivers/block/aoe/aoenet.c           |    2 +-
 drivers/block/cciss.c                |    2 +-
 drivers/block/cpqarray.c             |    2 +-
 drivers/block/floppy.c               |    2 +-
 drivers/block/paride/pd.c            |    2 +-
 drivers/block/paride/pf.c            |    2 +-
 drivers/block/sunvdc.c               |    2 +-
 drivers/block/sx8.c                  |    2 +-
 drivers/block/umem.c                 |    2 +-
 drivers/block/viodasd.c              |    2 +-
 drivers/block/virtio_blk.c           |    2 +-
 drivers/block/xd.c                   |    2 +-
 drivers/block/xen-blkfront.c         |    2 +-
 drivers/macintosh/mediabay.c         |    1 -
 drivers/md/dm-ioctl.c                |    2 +-
 drivers/md/dm.c                      |    2 +-
 drivers/md/dm.h                      |    2 +-
 drivers/memstick/core/mspro_block.c  |    2 +-
 drivers/message/i2o/i2o_block.c      |    2 +-
 drivers/mmc/card/block.c             |    2 +-
 drivers/mtd/ftl.c                    |    2 +-
 drivers/mtd/inftlcore.c              |    2 +-
 drivers/mtd/mtd_blkdevs.c            |    2 +-
 drivers/mtd/nftlcore.c               |    2 +-
 drivers/mtd/rfd_ftl.c                |    2 +-
 drivers/mtd/ssfdc.c                  |    2 +-
 drivers/s390/block/dasd.c            |    2 +-
 drivers/s390/block/dasd_diag.c       |    2 +-
 drivers/s390/block/dasd_eckd.c       |    2 +-
 drivers/s390/block/dasd_fba.c        |    2 +-
 drivers/s390/block/dasd_int.h        |    2 +-
 drivers/s390/block/xpram.c           |    2 +-
 drivers/scsi/hptiop.c                |    1 -
 drivers/scsi/ipr.c                   |    2 +-
 drivers/scsi/sd.c                    |    2 +-
 drivers/usb/storage/freecom.c        |    2 --
 fs/partitions/ibm.c                  |    2 +-
 include/asm-powerpc/ide.h            |    1 -
 include/linux/raid/md.h              |    2 +-
 init/main.c                          |    1 -
 50 files changed, 43 insertions(+), 51 deletions(-)

Index: b/arch/mips/jazz/setup.c
===================================================================
--- a/arch/mips/jazz/setup.c
+++ b/arch/mips/jazz/setup.c
@@ -10,7 +10,6 @@
  * Copyright (C) 2007 by Thomas Bogendoerfer
  */
 #include <linux/eisa.h>
-#include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
Index: b/arch/sh/boards/renesas/systemh/irq.c
===================================================================
--- a/arch/sh/boards/renesas/systemh/irq.c
+++ b/arch/sh/boards/renesas/systemh/irq.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <asm/io.h>
 #include <asm/systemh7751.h>
Index: b/block/compat_ioctl.c
===================================================================
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -5,7 +5,7 @@
 #include <linux/compat.h>
 #include <linux/elevator.h>
 #include <linux/fd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/syscalls.h>
 #include <linux/smp_lock.h>
 #include <linux/types.h>
Index: b/block/ioctl.c
===================================================================
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -1,7 +1,7 @@
 #include <linux/capability.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
 #include <linux/smp_lock.h>
Index: b/drivers/block/DAC960.c
===================================================================
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -29,7 +29,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/genhd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkpg.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
Index: b/drivers/block/amiflop.c
===================================================================
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -56,7 +56,7 @@
 #include <linux/module.h>
 
 #include <linux/fd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/amifdreg.h>
Index: b/drivers/block/aoe/aoeblk.c
===================================================================
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -4,7 +4,7 @@
  * block device routines
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
Index: b/drivers/block/aoe/aoechr.c
===================================================================
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -4,7 +4,7 @@
  * AoE character device driver
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
Index: b/drivers/block/aoe/aoedev.c
===================================================================
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -4,7 +4,7 @@
  * AoE device utility functions; maintains device list.
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkdev.h>
 #include <linux/netdevice.h>
 #include <linux/delay.h>
Index: b/drivers/block/aoe/aoemain.c
===================================================================
--- a/drivers/block/aoe/aoemain.c
+++ b/drivers/block/aoe/aoemain.c
@@ -4,7 +4,7 @@
  * Module initialization routines, discover timer
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include "aoe.h"
Index: b/drivers/block/aoe/aoenet.c
===================================================================
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -4,7 +4,7 @@
  * Ethernet portion of AoE driver
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blkdev.h>
 #include <linux/netdevice.h>
 #include <linux/moduleparam.h>
Index: b/drivers/block/cciss.c
===================================================================
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -35,7 +35,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/blktrace_api.h>
Index: b/drivers/block/cpqarray.c
===================================================================
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -33,7 +33,7 @@
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
Index: b/drivers/block/floppy.c
===================================================================
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -163,7 +163,7 @@ static int print_unex = 1;
 #define FDPATCHES
 #include <linux/fdreg.h>
 #include <linux/fd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
Index: b/drivers/block/paride/pd.c
===================================================================
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -147,7 +147,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_GEO,
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/cdrom.h>	/* for the eject ioctl */
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
Index: b/drivers/block/paride/pf.c
===================================================================
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -147,7 +147,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/cdrom.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
Index: b/drivers/block/sunvdc.c
===================================================================
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/genhd.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
Index: b/drivers/block/sx8.c
===================================================================
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -24,7 +24,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/time.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
Index: b/drivers/block/umem.c
===================================================================
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -50,7 +50,7 @@
 #include <linux/dma-mapping.h>
 
 #include <linux/fcntl.h>        /* O_ACCMODE */
-#include <linux/hdreg.h>  /* HDIO_GETGEO */
+#include <linux/hdio_ioctls.h>  /* HDIO_GETGEO */
 
 #include "umem.h"
 
Index: b/drivers/block/viodasd.c
===================================================================
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -34,7 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
Index: b/drivers/block/virtio_blk.c
===================================================================
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1,7 +1,7 @@
 //#define DEBUG
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
Index: b/drivers/block/xd.c
===================================================================
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -41,7 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/genhd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/wait.h>
Index: b/drivers/block/xen-blkfront.c
===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -37,7 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
 
Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -16,7 +16,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
-#include <linux/hdreg.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/md/dm-ioctl.c
===================================================================
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -14,7 +14,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/dm-ioctl.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/compat.h>
 
 #include <asm/uaccess.h>
Index: b/drivers/md/dm.c
===================================================================
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,7 +19,7 @@
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
 
Index: b/drivers/md/dm.h
===================================================================
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -14,7 +14,7 @@
 #include <linux/device-mapper.h>
 #include <linux/list.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 
 /*
  * Suspend feature flags
Index: b/drivers/memstick/core/mspro_block.c
===================================================================
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -14,7 +14,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/idr.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/memstick.h>
Index: b/drivers/message/i2o/i2o_block.c
===================================================================
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -57,7 +57,7 @@
 
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 
 #include <scsi/scsi.h>
 
Index: b/drivers/mmc/card/block.c
===================================================================
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -24,7 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/errno.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
Index: b/drivers/mtd/ftl.c
===================================================================
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -68,7 +68,7 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/vmalloc.h>
 #include <linux/blkpg.h>
 #include <asm/uaccess.h>
Index: b/drivers/mtd/inftlcore.c
===================================================================
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -31,7 +31,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/kmod.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nftl.h>
 #include <linux/mtd/inftl.h>
Index: b/drivers/mtd/mtd_blkdevs.c
===================================================================
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -18,7 +18,7 @@
 #include <linux/blkpg.h>
 #include <linux/freezer.h>
 #include <linux/spinlock.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
Index: b/drivers/mtd/nftlcore.c
===================================================================
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -20,7 +20,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 
 #include <linux/kmod.h>
 #include <linux/mtd/mtd.h>
Index: b/drivers/mtd/rfd_ftl.c
===================================================================
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -13,7 +13,7 @@
  * based on ftl.c
  */
 
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/init.h>
 #include <linux/mtd/blktrans.h>
 #include <linux/mtd/mtd.h>
Index: b/drivers/mtd/ssfdc.c
===================================================================
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/blktrans.h>
Index: b/drivers/s390/block/dasd.c
===================================================================
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -16,7 +16,7 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 
 #include <asm/ccwdev.h>
 #include <asm/ebcdic.h>
Index: b/drivers/s390/block/dasd_diag.c
===================================================================
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -11,7 +11,7 @@
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
Index: b/drivers/s390/block/dasd_eckd.c
===================================================================
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -12,7 +12,7 @@
 #include <linux/stddef.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/hdreg.h>	/* HDIO_GETGEO			    */
+#include <linux/hdio_ioctls.h>	/* HDIO_GETGEO */
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
Index: b/drivers/s390/block/dasd_fba.c
===================================================================
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -11,7 +11,7 @@
 #include <asm/debug.h>
 
 #include <linux/slab.h>
-#include <linux/hdreg.h>	/* HDIO_GETGEO			    */
+#include <linux/hdio_ioctls.h>	/* HDIO_GETGEO */
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
Index: b/drivers/s390/block/dasd_int.h
===================================================================
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -51,7 +51,7 @@
 #include <linux/wait.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/interrupt.h>
 #include <linux/log2.h>
 #include <asm/ccwdev.h>
Index: b/drivers/s390/block/xpram.c
===================================================================
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
-#include <linux/hdreg.h>  /* HDIO_GETGEO */
+#include <linux/hdio_ioctls.h>  /* HDIO_GETGEO */
 #include <linux/sysdev.h>
 #include <linux/bio.h>
 #include <asm/uaccess.h>
Index: b/drivers/scsi/hptiop.c
===================================================================
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -25,7 +25,6 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
-#include <linux/hdreg.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/div64.h>
Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -71,7 +71,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/libata.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -38,7 +38,7 @@
 #include <linux/mm.h>
 #include <linux/bio.h>
 #include <linux/genhd.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/errno.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
Index: b/drivers/usb/storage/freecom.c
===================================================================
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -26,8 +26,6 @@
  * (http://www.freecom.de/)
  */
 
-#include <linux/hdreg.h>
-
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
Index: b/fs/partitions/ibm.c
===================================================================
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -7,7 +7,7 @@
  */
 
 #include <linux/buffer_head.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/slab.h>
 #include <asm/dasd.h>
 #include <asm/ebcdic.h>
Index: b/include/asm-powerpc/ide.h
===================================================================
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -20,7 +20,6 @@
 #define __ide_mm_outsl(p, a, c)	writesl((void __iomem *)(p), (a), (c))
 
 #ifndef  __powerpc64__
-#include <linux/hdreg.h>
 #include <linux/ioport.h>
 
 /* FIXME: use ide_platform host driver */
Index: b/include/linux/raid/md.h
===================================================================
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -24,7 +24,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
-#include <linux/hdreg.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/smp_lock.h>
Index: b/init/main.c
===================================================================
--- a/init/main.c
+++ b/init/main.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/initrd.h>
-#include <linux/hdreg.h>
 #include <linux/bootmem.h>
 #include <linux/tty.h>
 #include <linux/gfp.h>

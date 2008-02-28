Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYB1Gt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYB1Gt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYB1GqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:46:07 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52743 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbYB1Gpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:51 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 12/12] Convert asm/semaphore.h users to linux/semaphore.h
Date: Thu, 28 Feb 2008 01:34:01 -0500
Message-Id: <1204180441-8540-12-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-11-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
 <1204180441-8540-7-git-send-email-matthew@wil.cx>
 <1204180441-8540-8-git-send-email-matthew@wil.cx>
 <1204180441-8540-9-git-send-email-matthew@wil.cx>
 <1204180441-8540-10-git-send-email-matthew@wil.cx>
 <1204180441-8540-11-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also deprecate the asm/semaphore.h files in feature-removal-schedule.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 Documentation/DocBook/kernel-locking.tmpl  |    6 +++---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 arch/ia64/kernel/salinfo.c                 |    2 +-
 drivers/base/core.c                        |    2 +-
 drivers/char/snsc.h                        |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +-
 drivers/firewire/fw-device.c               |    2 +-
 drivers/i2c/i2c-core.c                     |    2 +-
 drivers/ieee1394/nodemgr.c                 |    2 +-
 drivers/infiniband/core/user_mad.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_dev.h    |    3 +--
 drivers/input/serio/hp_sdc_mlc.c           |    2 +-
 drivers/macintosh/adb.c                    |    2 +-
 drivers/macintosh/windfarm_smu_sat.c       |    2 +-
 drivers/net/3c527.c                        |    2 +-
 drivers/net/hamradio/6pack.c               |    2 +-
 drivers/s390/cio/qdio.c                    |    2 +-
 drivers/scsi/aacraid/commctrl.c            |    2 +-
 drivers/scsi/aacraid/commsup.c             |    2 +-
 drivers/scsi/aacraid/dpcsup.c              |    2 +-
 drivers/scsi/megaraid/megaraid_ioctl.h     |    2 +-
 drivers/scsi/qla2xxx/qla_def.h             |    2 +-
 drivers/watchdog/sc1200wdt.c               |    2 +-
 fs/jffs2/jffs2_fs_i.h                      |    2 +-
 fs/jffs2/jffs2_fs_sb.h                     |    2 +-
 fs/reiserfs/journal.c                      |    2 +-
 fs/xfs/linux-2.6/sema.h                    |    2 +-
 include/linux/device.h                     |    2 +-
 include/linux/fs.h                         |    2 +-
 include/linux/hil_mlc.h                    |    2 +-
 include/linux/i2o.h                        |    2 +-
 include/linux/memory.h                     |    3 +--
 include/linux/parport.h                    |    2 +-
 lib/kernel_lock.c                          |    2 +-
 net/tipc/socket.c                          |    2 +-
 35 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 2e9d6b4..b1ab442 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -241,7 +241,7 @@
    </para>
    <para>
      The third type is a semaphore
-     (<filename class="headerfile">include/asm/semaphore.h</filename>): it
+     (<filename class="headerfile">include/linux/semaphore.h</filename>): it
      can have more than one holder at any time (the number decided at
      initialization time), although it is most commonly used as a
      single-holder lock (a mutex).  If you can't get a semaphore, your
@@ -290,7 +290,7 @@
      <para>
        If you have a data structure which is only ever accessed from
        user context, then you can use a simple semaphore
-       (<filename>linux/asm/semaphore.h</filename>) to protect it.  This 
+       (<filename>linux/linux/semaphore.h</filename>) to protect it.  This 
        is the most trivial case: you initialize the semaphore to the number 
        of resources available (usually 1), and call
        <function>down_interruptible()</function> to grab the semaphore, and 
@@ -1656,7 +1656,7 @@ the amount of locking which needs to be done.
  #include &lt;linux/slab.h&gt;
  #include &lt;linux/string.h&gt;
 +#include &lt;linux/rcupdate.h&gt;
- #include &lt;asm/semaphore.h&gt;
+ #include &lt;linux/semaphore.h&gt;
  #include &lt;asm/errno.h&gt;
 
  struct object
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4d3aa51..c43cba9 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -306,3 +306,11 @@ Why:	Largely unmaintained and almost entirely unused.  File system
 	is largely pointless as without a lot of work only the most
 	trivial of Solaris binaries can work with the emulation code.
 Who:	David S. Miller <davem@davemloft.net>
+
+---------------------------
+
+What:	asm/semaphore.h
+When:	2.6.26
+Why:	Implementation became generic; users should now include
+	linux/semaphore.h instead.
+Who:	Matthew Wilcox <willy@linux.intel.com>
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 779c3cc..b11bb50 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -44,8 +44,8 @@
 #include <linux/smp.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
+#include <linux/semaphore.h>
 
-#include <asm/semaphore.h>
 #include <asm/sal.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9c0070b..1a37406 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -19,7 +19,7 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 #include <linux/genhd.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
diff --git a/drivers/char/snsc.h b/drivers/char/snsc.h
index 8a98169..4be62ed 100644
--- a/drivers/char/snsc.h
+++ b/drivers/char/snsc.h
@@ -22,8 +22,8 @@
 #include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
+#include <linux/semaphore.h>
 #include <asm/sn/types.h>
-#include <asm/semaphore.h>
 
 #define CHUNKSIZE 127
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 24f6aef..68df07f 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -84,7 +84,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <linux/sysctl.h>
 #include <linux/version.h>
 #include <linux/fs.h>
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 2ab13e0..79fb504 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -26,7 +26,7 @@
 #include <linux/delay.h>
 #include <linux/idr.h>
 #include <linux/rwsem.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/system.h>
 #include <linux/ctype.h>
 #include "fw-transaction.h"
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 96da22e..d8de1b0 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -35,8 +35,8 @@
 #include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/semaphore.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "i2c-core.h"
 
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 511e432..a6183e5 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -18,8 +18,8 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/semaphore.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 #include "csr.h"
 #include "highlevel.h"
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 4e91510..be953e8 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -46,9 +46,9 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <linux/compat.h>
+#include <linux/semaphore.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include <rdma/ib_mad.h>
 #include <rdma/ib_user_mad.h>
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7bbdd1f..ad8861a 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -46,8 +46,7 @@
 #include <linux/timer.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include "mthca_provider.h"
 #include "mthca_doorbell.h"
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index c45ea74..f1fd3b6 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -40,7 +40,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/string.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #define PREFIX "HP SDC MLC: "
 
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 2895810..2097820 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -37,9 +37,9 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/platform_device.h>
+#include <linux/semaphore.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #ifdef CONFIG_PPC
 #include <asm/prom.h>
 #include <asm/machdep.h>
diff --git a/drivers/macintosh/windfarm_smu_sat.c b/drivers/macintosh/windfarm_smu_sat.c
index f449d77..797918d 100644
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/prom.h>
 #include <asm/smu.h>
 #include <asm/pmac_low_i2c.h>
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index b72b89d..fae295b 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -103,8 +103,8 @@ DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " Richard Procter <rnp@paradise.net.
 #include <linux/ethtool.h>
 #include <linux/completion.h>
 #include <linux/bitops.h>
+#include <linux/semaphore.h>
 
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/io.h>
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 0a9b751..1da55dd 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -33,7 +33,7 @@
 #include <linux/init.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/atomic.h>
 
 #define SIXPACK_VERSION    "Revision: 0.3.0"
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index 2b5bfb7..9a85422 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -38,11 +38,11 @@
 #include <linux/proc_fs.h>
 #include <linux/timer.h>
 #include <linux/mempool.h>
+#include <linux/semaphore.h>
 
 #include <asm/ccwdev.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 #include <asm/timex.h>
 
 #include <asm/debug.h>
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index abef051..5fd83de 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -39,7 +39,7 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h> /* ssleep prototype */
 #include <linux/kthread.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/uaccess.h>
 
 #include "aacraid.h"
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4743449..3753835 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -41,11 +41,11 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
+#include <linux/semaphore.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <asm/semaphore.h>
 
 #include "aacraid.h"
 
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index d1163de..933f208 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -36,7 +36,7 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include "aacraid.h"
 
diff --git a/drivers/scsi/megaraid/megaraid_ioctl.h b/drivers/scsi/megaraid/megaraid_ioctl.h
index 706fa05..05f6e4e 100644
--- a/drivers/scsi/megaraid/megaraid_ioctl.h
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -18,7 +18,7 @@
 #define _MEGARAID_IOCTL_H_
 
 #include <linux/types.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include "mbox_defs.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3750319..97aa48d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -24,7 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
 #include <linux/aer.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 32ccd7c..35cddff 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -38,8 +38,8 @@
 #include <linux/init.h>
 #include <linux/pnp.h>
 #include <linux/fs.h>
+#include <linux/semaphore.h>
 
-#include <asm/semaphore.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/jffs2/jffs2_fs_i.h b/fs/jffs2/jffs2_fs_i.h
index 0b78fdc..a841f49 100644
--- a/fs/jffs2/jffs2_fs_i.h
+++ b/fs/jffs2/jffs2_fs_i.h
@@ -15,7 +15,7 @@
 #include <linux/version.h>
 #include <linux/rbtree.h>
 #include <linux/posix_acl.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 struct jffs2_inode_info {
 	/* We need an internal mutex similar to inode->i_mutex.
diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 3a2197f..18fca2b 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/list.h>
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index bb05a3e..060eb3f 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -38,7 +38,7 @@
 #include <asm/system.h>
 
 #include <linux/time.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 #include <linux/vmalloc.h>
 #include <linux/reiserfs_fs.h>
diff --git a/fs/xfs/linux-2.6/sema.h b/fs/xfs/linux-2.6/sema.h
index 2009e6d..3abe7e9 100644
--- a/fs/xfs/linux-2.6/sema.h
+++ b/fs/xfs/linux-2.6/sema.h
@@ -20,8 +20,8 @@
 
 #include <linux/time.h>
 #include <linux/wait.h>
+#include <linux/semaphore.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 /*
  * sema_t structure just maps to struct semaphore in Linux kernel.
diff --git a/include/linux/device.h b/include/linux/device.h
index 2258d89..c79b93e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -20,7 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b84b848..91e8dec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -287,9 +287,9 @@ extern int dir_notify_enable;
 #include <linux/pid.h>
 #include <linux/mutex.h>
 #include <linux/capability.h>
+#include <linux/semaphore.h>
 
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 #include <asm/byteorder.h>
 
 struct export_operations;
diff --git a/include/linux/hil_mlc.h b/include/linux/hil_mlc.h
index 8df29ca..394a840 100644
--- a/include/linux/hil_mlc.h
+++ b/include/linux/hil_mlc.h
@@ -34,7 +34,7 @@
 #include <linux/hil.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <linux/serio.h>
 #include <linux/list.h>
 
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 7da5b98..e92170d 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -33,9 +33,9 @@
 #include <linux/mempool.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
+#include <linux/semaphore.h>	/* Needed for MUTEX init macros */
 
 #include <asm/io.h>
-#include <asm/semaphore.h>	/* Needed for MUTEX init macros */
 
 /* message queue empty */
 #define I2O_QUEUE_EMPTY		0xffffffff
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 33f0ff0..54d7866 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -18,8 +18,7 @@
 #include <linux/sysdev.h>
 #include <linux/node.h>
 #include <linux/compiler.h>
-
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 struct memory_block {
 	unsigned long phys_index;
diff --git a/include/linux/parport.h b/include/linux/parport.h
index d1ad546..dcb9e01 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -101,9 +101,9 @@ typedef enum {
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/irqreturn.h>
+#include <linux/semaphore.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
-#include <asm/semaphore.h>
 
 /* Define this later. */
 struct parport;
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index fbc11a3..cd3e825 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -8,7 +8,7 @@
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 
 /*
  * The 'big kernel semaphore'
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2290903..6e3f0d3 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -43,7 +43,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
-#include <asm/semaphore.h>
+#include <linux/semaphore.h>
 #include <asm/string.h>
 #include <asm/atomic.h>
 #include <net/sock.h>
-- 
1.5.4.1


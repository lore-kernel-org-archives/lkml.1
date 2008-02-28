Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYB1GtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYB1GtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYB1Gpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:54 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52732 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756452AbYB1Gpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:45 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 05/12] drivers: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:54 -0500
Message-Id: <1204180441-8540-5-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-4-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.  It's possible that they rely on it dragging in some
unrelated header file, but I can't build all these files, so we'll have
fix any build failures as they come up.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ata/libata-core.c                     |    1 -
 drivers/block/cryptoloop.c                    |    1 -
 drivers/char/generic_serial.c                 |    1 -
 drivers/char/rio/rioboot.c                    |    1 -
 drivers/char/rio/riocmd.c                     |    1 -
 drivers/char/rio/rioctrl.c                    |    1 -
 drivers/char/rio/rioinit.c                    |    1 -
 drivers/char/rio/riointr.c                    |    1 -
 drivers/char/rio/rioparam.c                   |    1 -
 drivers/char/rio/rioroute.c                   |    1 -
 drivers/char/rio/riotable.c                   |    1 -
 drivers/char/rio/riotty.c                     |    1 -
 drivers/firewire/fw-transaction.c             |    1 -
 drivers/firmware/dcdbas.c                     |    1 -
 drivers/infiniband/hw/amso1100/c2.h           |    1 -
 drivers/infiniband/hw/nes/nes.h               |    1 -
 drivers/lguest/lg.h                           |    1 -
 drivers/media/radio/radio-aimslab.c           |    1 -
 drivers/media/video/ir-kbd-i2c.c              |    1 -
 drivers/media/video/ov511.c                   |    1 -
 drivers/media/video/pvrusb2/pvrusb2-context.c |    1 -
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    1 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c   |    1 -
 drivers/mfd/ucb1x00-ts.c                      |    1 -
 drivers/s390/cio/ccwgroup.c                   |    1 -
 drivers/s390/net/qeth_main.c                  |    1 -
 drivers/scsi/aacraid/aachba.c                 |    1 -
 drivers/scsi/aacraid/comminit.c               |    1 -
 drivers/scsi/aacraid/linit.c                  |    1 -
 drivers/scsi/aacraid/rx.c                     |    1 -
 drivers/scsi/aacraid/sa.c                     |    1 -
 drivers/scsi/dpt/dpti_i2o.h                   |    1 -
 drivers/scsi/megaraid/mega_common.h           |    1 -
 drivers/serial/mcfserial.c                    |    1 -
 drivers/usb/atm/usbatm.h                      |    1 -
 drivers/usb/core/hub.c                        |    1 -
 drivers/usb/misc/appledisplay.c               |    1 -
 drivers/usb/serial/io_ti.c                    |    1 -
 drivers/usb/serial/ti_usb_3410_5052.c         |    1 -
 39 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4fbcce7..b665674 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -62,7 +62,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <asm/semaphore.h>
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 2411678..8b6bb76 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -27,7 +27,6 @@
 #include <linux/blkdev.h>
 #include <linux/loop.h>
 #include <linux/scatterlist.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index 8facf3e..7ed7da1 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -28,7 +28,6 @@
 #include <linux/interrupt.h>
 #include <linux/tty_flip.h>
 #include <linux/delay.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #define DEBUG 
diff --git a/drivers/char/rio/rioboot.c b/drivers/char/rio/rioboot.c
index eca2b95..d956dd3 100644
--- a/drivers/char/rio/rioboot.c
+++ b/drivers/char/rio/rioboot.c
@@ -35,7 +35,6 @@
 #include <linux/termios.h>
 #include <linux/serial.h>
 #include <linux/vmalloc.h>
-#include <asm/semaphore.h>
 #include <linux/generic_serial.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff --git a/drivers/char/rio/riocmd.c b/drivers/char/rio/riocmd.c
index 7321d00..bf36959 100644
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -41,7 +41,6 @@ static char *_riocmd_c_sccs_ = "@(#)riocmd.c	1.2";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/rioctrl.c b/drivers/char/rio/rioctrl.c
index 7ce7761..d8eb2bc 100644
--- a/drivers/char/rio/rioctrl.c
+++ b/drivers/char/rio/rioctrl.c
@@ -40,7 +40,6 @@ static char *_rioctrl_c_sccs_ = "@(#)rioctrl.c	1.3";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/rioinit.c b/drivers/char/rio/rioinit.c
index 0794844..add1718 100644
--- a/drivers/char/rio/rioinit.c
+++ b/drivers/char/rio/rioinit.c
@@ -40,7 +40,6 @@ static char *_rioinit_c_sccs_ = "@(#)rioinit.c	1.3";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/riointr.c b/drivers/char/rio/riointr.c
index ebc7634..4734e26 100644
--- a/drivers/char/rio/riointr.c
+++ b/drivers/char/rio/riointr.c
@@ -42,7 +42,6 @@ static char *_riointr_c_sccs_ = "@(#)riointr.c	1.2";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/rioparam.c b/drivers/char/rio/rioparam.c
index bb498d2..da276ed 100644
--- a/drivers/char/rio/rioparam.c
+++ b/drivers/char/rio/rioparam.c
@@ -41,7 +41,6 @@ static char *_rioparam_c_sccs_ = "@(#)rioparam.c	1.3";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/rioroute.c b/drivers/char/rio/rioroute.c
index a99f3d9..85091ff 100644
--- a/drivers/char/rio/rioroute.c
+++ b/drivers/char/rio/rioroute.c
@@ -39,7 +39,6 @@ static char *_rioroute_c_sccs_ = "@(#)rioroute.c	1.3";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/riotable.c b/drivers/char/rio/riotable.c
index 991119c..dfce405 100644
--- a/drivers/char/rio/riotable.c
+++ b/drivers/char/rio/riotable.c
@@ -42,7 +42,6 @@ static char *_riotable_c_sccs_ = "@(#)riotable.c	1.2";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/char/rio/riotty.c b/drivers/char/rio/riotty.c
index a4f0b1e..5f053e1 100644
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -44,7 +44,6 @@ static char *_riotty_c_sccs_ = "@(#)riotty.c	1.3";
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/string.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 #include <linux/termios.h>
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 7fcc59d..1fe3d45 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -28,7 +28,6 @@
 #include <linux/list.h>
 #include <linux/kthread.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "fw-transaction.h"
 #include "fw-topology.h"
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 1636806..d8822ee 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -35,7 +35,6 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 
 #include "dcdbas.h"
 
diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index fa58200..dd5c889 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -40,7 +40,6 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
-#include <asm/semaphore.h>
 
 #include "c2_provider.h"
 #include "c2_mq.h"
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index fd57e8a..0b10474 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -43,7 +43,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
-#include <asm/semaphore.h>
 #include <linux/version.h>
 #include <asm/io.h>
 #include <linux/crc32c.h>
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 2337e1a..005bd04 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -10,7 +10,6 @@
 #include <linux/wait.h>
 #include <linux/hrtimer.h>
 #include <linux/err.h>
-#include <asm/semaphore.h>
 
 #include <asm/lguest.h>
 
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index f0a67e9..c69bde3 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -36,7 +36,6 @@
 #include <asm/uaccess.h>	/* copy to/from user		*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <media/v4l2-common.h>
-#include <asm/semaphore.h>	/* Lock for the I/O 		*/
 
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 #define RADIO_VERSION KERNEL_VERSION(0,0,2)
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 9851987..dabafdf 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -40,7 +40,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/workqueue.h>
-#include <asm/semaphore.h>
 
 #include <media/ir-common.h>
 #include <media/ir-kbd-i2c.h>
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index d55d580..6590058 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -41,7 +41,6 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/pagemap.h>
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <linux/mm.h>
 #include <linux/device.h>
diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.c b/drivers/media/video/pvrusb2/pvrusb2-context.c
index 9d94aed..160437b 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-context.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <asm/semaphore.h>
 
 
 static void pvr2_context_destroy(struct pvr2_context *mp)
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 41ae980..763b562 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -25,7 +25,6 @@
 #include <linux/firmware.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
-#include <asm/semaphore.h>
 #include "pvrusb2.h"
 #include "pvrusb2-std.h"
 #include "pvrusb2-util.h"
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 7a1cd87..07f4eae 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -21,7 +21,6 @@
 
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <asm/semaphore.h>
 #include "pvrusb2-sysfs.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2-debug.h"
diff --git a/drivers/mfd/ucb1x00-ts.c b/drivers/mfd/ucb1x00-ts.c
index fdbaa77..5e85948 100644
--- a/drivers/mfd/ucb1x00-ts.c
+++ b/drivers/mfd/ucb1x00-ts.c
@@ -32,7 +32,6 @@
 #include <linux/kthread.h>
 
 #include <asm/dma.h>
-#include <asm/semaphore.h>
 #include <asm/arch/collie.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 03914fa..fe1ad17 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -16,7 +16,6 @@
 #include <linux/ctype.h>
 #include <linux/dcache.h>
 
-#include <asm/semaphore.h>
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 
diff --git a/drivers/s390/net/qeth_main.c b/drivers/s390/net/qeth_main.c
index 62606ce..df81259 100644
--- a/drivers/s390/net/qeth_main.c
+++ b/drivers/s390/net/qeth_main.c
@@ -59,7 +59,6 @@
 #include <asm/io.h>
 #include <asm/qeth.h>
 #include <asm/timex.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <asm/s390_rdev.h>
 
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index c05092f..96903bc 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <linux/highmem.h> /* For flush_kernel_dcache_page */
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 89cc8b7..294a802 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -39,7 +39,6 @@
 #include <linux/completion.h>
 #include <linux/mm.h>
 #include <scsi/scsi_host.h>
-#include <asm/semaphore.h>
 
 #include "aacraid.h"
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ae5f74f..8372bf6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -42,7 +42,6 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
-#include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 1f18b83..073208b 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -39,7 +39,6 @@
 #include <linux/completion.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <asm/semaphore.h>
 
 #include <scsi/scsi_host.h>
 
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index cfc3410..fc1a557 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -39,7 +39,6 @@
 #include <linux/completion.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <asm/semaphore.h>
 
 #include <scsi/scsi_host.h>
 
diff --git a/drivers/scsi/dpt/dpti_i2o.h b/drivers/scsi/dpt/dpti_i2o.h
index 100b49b..19406ce 100644
--- a/drivers/scsi/dpt/dpti_i2o.h
+++ b/drivers/scsi/dpt/dpti_i2o.h
@@ -21,7 +21,6 @@
 
 #include <linux/i2o-dev.h>
 
-#include <asm/semaphore.h> /* Needed for MUTEX init macros */
 #include <linux/version.h>
 #include <linux/notifier.h>
 #include <asm/atomic.h>
diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index fef9ac9..f62ed46 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -28,7 +28,6 @@
 #include <linux/list.h>
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
-#include <asm/semaphore.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
index 99af084..ddd3aa5 100644
--- a/drivers/serial/mcfserial.c
+++ b/drivers/serial/mcfserial.c
@@ -40,7 +40,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/semaphore.h>
 #include <asm/delay.h>
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index ff8551e..fc6c2be 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -24,7 +24,6 @@
 #ifndef	_USBATM_H_
 #define	_USBATM_H_
 
-#include <asm/semaphore.h>
 #include <linux/atm.h>
 #include <linux/atmdev.h>
 #include <linux/completion.h>
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 68fc521..57aeca1 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -23,7 +23,6 @@
 #include <linux/mutex.h>
 #include <linux/freezer.h>
 
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1cb56f2..a5e4c35 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -29,7 +29,6 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 
 #define APPLE_VENDOR_ID		0x05AC
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index cd34059..e5ea5ef 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -38,7 +38,6 @@
 #include <linux/serial.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index b517f93..959f768 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -82,7 +82,6 @@
 #include <linux/circ_buf.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-- 
1.5.4.1


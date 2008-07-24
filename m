Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYGXTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYGXTl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYGXTk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:40:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:63999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYGXTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=XgEf849XqXDm6LLjynb+Ac8E5NN8mTJNnCaSkSq1ux+IY/MoRC1DqZriFnCnSNlAfY
         eoSWuXngmbRjW0F99X376SHg48iOZwcSkVVosamk16kwEIq7nk6x8hy9uj6Xf549UEP2
         d8ZESNK9yUaMSI9JCFhmngf3qRTjkOPV9Pi3o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide: use <linux/hdio_ioctls.h> instead of <linux/hdreg.h>
Date: Thu, 24 Jul 2008 21:35:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242135.48368.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Include <linux/ata.h> directly in <linux/ide.h>
  instead of through <linux/hdreg.h>.

* Include <linux/hdio_ioctls.h> when needed.

* Remove <linux/hdreg.h> includes.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c       |    1 -
 drivers/ide/arm/palm_bk3710.c  |    1 -
 drivers/ide/ide-disk.c         |    1 +
 drivers/ide/ide-floppy.c       |    1 +
 drivers/ide/ide-io.c           |    1 +
 drivers/ide/ide-iops.c         |    1 -
 drivers/ide/ide-lib.c          |    1 -
 drivers/ide/ide-proc.c         |    1 -
 drivers/ide/ide-taskfile.c     |    2 +-
 drivers/ide/ide-timings.c      |    1 -
 drivers/ide/ide.c              |    1 +
 drivers/ide/legacy/ali14xx.c   |    1 -
 drivers/ide/legacy/buddha.c    |    1 -
 drivers/ide/legacy/dtc2278.c   |    1 -
 drivers/ide/legacy/falconide.c |    1 -
 drivers/ide/legacy/gayle.c     |    1 -
 drivers/ide/legacy/ht6560b.c   |    1 -
 drivers/ide/legacy/ide-cs.c    |    1 -
 drivers/ide/legacy/macide.c    |    1 -
 drivers/ide/legacy/q40ide.c    |    2 --
 drivers/ide/legacy/qd65xx.c    |    1 -
 drivers/ide/legacy/umc8672.c   |    1 -
 drivers/ide/pci/aec62xx.c      |    1 -
 drivers/ide/pci/alim15x3.c     |    1 -
 drivers/ide/pci/atiixp.c       |    1 -
 drivers/ide/pci/cmd640.c       |    1 -
 drivers/ide/pci/cmd64x.c       |    1 -
 drivers/ide/pci/cs5520.c       |    1 -
 drivers/ide/pci/cs5530.c       |    1 -
 drivers/ide/pci/delkin_cb.c    |    1 -
 drivers/ide/pci/generic.c      |    1 -
 drivers/ide/pci/hpt34x.c       |    1 -
 drivers/ide/pci/hpt366.c       |    1 -
 drivers/ide/pci/it8213.c       |    1 -
 drivers/ide/pci/it821x.c       |    1 -
 drivers/ide/pci/jmicron.c      |    1 -
 drivers/ide/pci/ns87415.c      |    1 -
 drivers/ide/pci/opti621.c      |    1 -
 drivers/ide/pci/pdc202xx_new.c |    1 -
 drivers/ide/pci/pdc202xx_old.c |    1 -
 drivers/ide/pci/piix.c         |    1 -
 drivers/ide/pci/rz1000.c       |    1 -
 drivers/ide/pci/sc1200.c       |    1 -
 drivers/ide/pci/scc_pata.c     |    1 -
 drivers/ide/pci/serverworks.c  |    1 -
 drivers/ide/pci/sgiioc4.c      |    1 -
 drivers/ide/pci/siimage.c      |    1 -
 drivers/ide/pci/sis5513.c      |    1 -
 drivers/ide/pci/sl82c105.c     |    1 -
 drivers/ide/pci/slc90e66.c     |    1 -
 drivers/ide/pci/triflex.c      |    1 -
 drivers/ide/pci/trm290.c       |    1 -
 drivers/scsi/ide-scsi.c        |    1 -
 include/linux/ide.h            |    2 +-
 54 files changed, 6 insertions(+), 51 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/delay.h>
 #include <linux/init.h>
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -34,6 +34,7 @@
 #define _IDE_DISK
 
 #include <linux/ide.h>
+#include <linux/hdio_ioctls.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/cdrom.h>
 #include <linux/ide.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -40,6 +40,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/completion.h>
 #include <linux/reboot.h>
 #include <linux/cdrom.h>
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 #include <linux/nmi.h>
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -2,7 +2,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/bitops.h>
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -23,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/ctype.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/seq_file.h>
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -16,8 +16,8 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/scatterlist.h>
 
 #include <asm/uaccess.h>
Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/module.h>
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -58,6 +58,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
+#include <linux/hdio_ioctls.h>
 #include <linux/completion.h>
 #include <linux/device.h>
 
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -43,7 +43,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -20,7 +20,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/zorro.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/zorro.h>
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -38,7 +38,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <asm/io.h>
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
 
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -14,8 +14,6 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
-
 #include <linux/ide.h>
 
     /*
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -27,7 +27,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <asm/system.h>
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -45,7 +45,6 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -103,7 +103,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -19,7 +19,6 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/pci.h>
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -122,7 +122,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -63,7 +63,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -11,7 +11,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -85,7 +85,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/blkdev.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -48,7 +48,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -39,7 +39,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/io.h>
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -47,7 +47,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -135,7 +135,6 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -40,7 +40,6 @@
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/errno.h>
-#include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -8,7 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/hdreg.h>
+#include <linux/ata.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>

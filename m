Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYACNY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYACNY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYACNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:10 -0500
Received: from smtp103.plus.mail.re1.yahoo.com ([69.147.102.66]:45433 "HELO
	smtp103.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752206AbYACNXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=wCy9Jr3/8sgtRgU/SDsNv0niZ0enRhccAMrfk9Ii2LdpfrMIAW4t/a/QWR8gqUMaAGAcuxNZhi+jG4ye1BrkbVOdbjHxUT0vTt0/RmPtIKEXyJi+YpyyAs9v+gYIWgJjhv85hBaMrXjUVf2uZzc3PMSYaH6/WaOSbXvBURPUd9k=  ;
X-YMail-OSG: VDiLzFoVM1lECII.gnGD3zQKaL.cvoLQNPZ5u_bq7Gdiutu6zpicu2id2ZMYNzKtNVw1mcyigfZXEfU5cKbVReNXA0T7kfbTwaS7VGMiwtWHddnS9w--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 01/10] move ide-floppy historical changelog to Documentation/ide/ChangeLog.ide-floppy.1996-2002;
Date: Thu,  3 Jan 2008 14:20:00 +0100
Message-Id: <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 Documentation/ide/ChangeLog.ide-floppy.1996-2002 |   64 ++++++++++++++++++++
 drivers/ide/ide-floppy.c                         |   69 +---------------------
 2 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/Documentation/ide/ChangeLog.ide-floppy.1996-2002 b/Documentation/ide/ChangeLog.ide-floppy.1996-2002
new file mode 100644
index 0000000..70166f3
--- /dev/null
+++ b/Documentation/ide/ChangeLog.ide-floppy.1996-2002
@@ -0,0 +1,64 @@
+/*
+ * Many thanks to Lode Leroy <Lode.Leroy@www.ibase.be>, who tested so many
+ * ALPHA patches to this driver on an EASYSTOR LS-120 ATAPI floppy drive.
+ *
+ * Ver 0.1   Oct 17 96   Initial test version, mostly based on ide-tape.c.
+ * Ver 0.2   Oct 31 96   Minor changes.
+ * Ver 0.3   Dec  2 96   Fixed error recovery bug.
+ * Ver 0.4   Jan 26 97   Add support for the HDIO_GETGEO ioctl.
+ * Ver 0.5   Feb 21 97   Add partitions support.
+ *                       Use the minimum of the LBA and CHS capacities.
+ *                       Avoid hwgroup->rq == NULL on the last irq.
+ *                       Fix potential null dereferencing with DEBUG_LOG.
+ * Ver 0.8   Dec  7 97   Increase irq timeout from 10 to 50 seconds.
+ *                       Add media write-protect detection.
+ *                       Issue START command only if TEST UNIT READY fails.
+ *                       Add work-around for IOMEGA ZIP revision 21.D.
+ *                       Remove idefloppy_get_capabilities().
+ * Ver 0.9   Jul  4 99   Fix a bug which might have caused the number of
+ *                        bytes requested on each interrupt to be zero.
+ *                        Thanks to <shanos@es.co.nz> for pointing this out.
+ * Ver 0.9.sv Jan 6 01   Sam Varshavchik <mrsam@courier-mta.com>
+ *                       Implement low level formatting.  Reimplemented
+ *                       IDEFLOPPY_CAPABILITIES_PAGE, since we need the srfp
+ *                       bit.  My LS-120 drive barfs on
+ *                       IDEFLOPPY_CAPABILITIES_PAGE, but maybe it's just me.
+ *                       Compromise by not reporting a failure to get this
+ *                       mode page.  Implemented four IOCTLs in order to
+ *                       implement formatting.  IOCTls begin with 0x4600,
+ *                       0x46 is 'F' as in Format.
+ *            Jan 9 01   Userland option to select format verify.
+ *                       Added PC_SUPPRESS_ERROR flag - some idefloppy drives
+ *                       do not implement IDEFLOPPY_CAPABILITIES_PAGE, and
+ *                       return a sense error.  Suppress error reporting in
+ *                       this particular case in order to avoid spurious
+ *                       errors in syslog.  The culprit is
+ *                       idefloppy_get_capability_page(), so move it to
+ *                       idefloppy_begin_format() so that it's not used
+ *                       unless absolutely necessary.
+ *                       If drive does not support format progress indication
+ *                       monitor the dsc bit in the status register.
+ *                       Also, O_NDELAY on open will allow the device to be
+ *                       opened without a disk available.  This can be used to
+ *                       open an unformatted disk, or get the device capacity.
+ * Ver 0.91  Dec 11 99   Added IOMEGA Clik! drive support by 
+ *     		   <paul@paulbristow.net>
+ * Ver 0.92  Oct 22 00   Paul Bristow became official maintainer for this 
+ *           		   driver.  Included Powerbook internal zip kludge.
+ * Ver 0.93  Oct 24 00   Fixed bugs for Clik! drive
+ *                        no disk on insert and disk change now works
+ * Ver 0.94  Oct 27 00   Tidied up to remove strstr(Clik) everywhere
+ * Ver 0.95  Nov  7 00   Brought across to kernel 2.4
+ * Ver 0.96  Jan  7 01   Actually in line with release version of 2.4.0
+ *                       including set_bit patch from Rusty Russell
+ * Ver 0.97  Jul 22 01   Merge 0.91-0.96 onto 0.9.sv for ac series
+ * Ver 0.97.sv Aug 3 01  Backported from 2.4.7-ac3
+ * Ver 0.98  Oct 26 01   Split idefloppy_transfer_pc into two pieces to
+ *                        fix a lost interrupt problem. It appears the busy
+ *                        bit was being deasserted by my IOMEGA ATAPI ZIP 100
+ *                        drive before the drive was actually ready.
+ * Ver 0.98a Oct 29 01   Expose delay value so we can play.
+ * Ver 0.99  Feb 24 02   Remove duplicate code, modify clik! detection code 
+ *                        to support new PocketZip drives 
+ */
+
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 04a3578..785fbde 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1,12 +1,8 @@
 /*
- * linux/drivers/ide/ide-floppy.c	Version 0.99	Feb 24 2002
+ * IDE ATAPI floppy driver.
  *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2000 - 2002 Paul Bristow <paul@paulbristow.net>
- */
-
-/*
- * IDE ATAPI floppy driver.
  *
  * The driver currently doesn't have any fancy features, just the bare
  * minimum read/write support.
@@ -17,67 +13,8 @@
  * Iomega Zip 100/250
  * Iomega PC Card Clik!/PocketZip
  *
- * Many thanks to Lode Leroy <Lode.Leroy@www.ibase.be>, who tested so many
- * ALPHA patches to this driver on an EASYSTOR LS-120 ATAPI floppy drive.
- *
- * Ver 0.1   Oct 17 96   Initial test version, mostly based on ide-tape.c.
- * Ver 0.2   Oct 31 96   Minor changes.
- * Ver 0.3   Dec  2 96   Fixed error recovery bug.
- * Ver 0.4   Jan 26 97   Add support for the HDIO_GETGEO ioctl.
- * Ver 0.5   Feb 21 97   Add partitions support.
- *                       Use the minimum of the LBA and CHS capacities.
- *                       Avoid hwgroup->rq == NULL on the last irq.
- *                       Fix potential null dereferencing with DEBUG_LOG.
- * Ver 0.8   Dec  7 97   Increase irq timeout from 10 to 50 seconds.
- *                       Add media write-protect detection.
- *                       Issue START command only if TEST UNIT READY fails.
- *                       Add work-around for IOMEGA ZIP revision 21.D.
- *                       Remove idefloppy_get_capabilities().
- * Ver 0.9   Jul  4 99   Fix a bug which might have caused the number of
- *                        bytes requested on each interrupt to be zero.
- *                        Thanks to <shanos@es.co.nz> for pointing this out.
- * Ver 0.9.sv Jan 6 01   Sam Varshavchik <mrsam@courier-mta.com>
- *                       Implement low level formatting.  Reimplemented
- *                       IDEFLOPPY_CAPABILITIES_PAGE, since we need the srfp
- *                       bit.  My LS-120 drive barfs on
- *                       IDEFLOPPY_CAPABILITIES_PAGE, but maybe it's just me.
- *                       Compromise by not reporting a failure to get this
- *                       mode page.  Implemented four IOCTLs in order to
- *                       implement formatting.  IOCTls begin with 0x4600,
- *                       0x46 is 'F' as in Format.
- *            Jan 9 01   Userland option to select format verify.
- *                       Added PC_SUPPRESS_ERROR flag - some idefloppy drives
- *                       do not implement IDEFLOPPY_CAPABILITIES_PAGE, and
- *                       return a sense error.  Suppress error reporting in
- *                       this particular case in order to avoid spurious
- *                       errors in syslog.  The culprit is
- *                       idefloppy_get_capability_page(), so move it to
- *                       idefloppy_begin_format() so that it's not used
- *                       unless absolutely necessary.
- *                       If drive does not support format progress indication
- *                       monitor the dsc bit in the status register.
- *                       Also, O_NDELAY on open will allow the device to be
- *                       opened without a disk available.  This can be used to
- *                       open an unformatted disk, or get the device capacity.
- * Ver 0.91  Dec 11 99   Added IOMEGA Clik! drive support by 
- *     		   <paul@paulbristow.net>
- * Ver 0.92  Oct 22 00   Paul Bristow became official maintainer for this 
- *           		   driver.  Included Powerbook internal zip kludge.
- * Ver 0.93  Oct 24 00   Fixed bugs for Clik! drive
- *                        no disk on insert and disk change now works
- * Ver 0.94  Oct 27 00   Tidied up to remove strstr(Clik) everywhere
- * Ver 0.95  Nov  7 00   Brought across to kernel 2.4
- * Ver 0.96  Jan  7 01   Actually in line with release version of 2.4.0
- *                       including set_bit patch from Rusty Russell
- * Ver 0.97  Jul 22 01   Merge 0.91-0.96 onto 0.9.sv for ac series
- * Ver 0.97.sv Aug 3 01  Backported from 2.4.7-ac3
- * Ver 0.98  Oct 26 01   Split idefloppy_transfer_pc into two pieces to
- *                        fix a lost interrupt problem. It appears the busy
- *                        bit was being deasserted by my IOMEGA ATAPI ZIP 100
- *                        drive before the drive was actually ready.
- * Ver 0.98a Oct 29 01   Expose delay value so we can play.
- * Ver 0.99  Feb 24 02   Remove duplicate code, modify clik! detection code 
- *                        to support new PocketZip drives 
+ * For a historical changelog see
+ * Documentation/ide/ChangeLog.ide-floppy.1996-2002
  */
 
 #define IDEFLOPPY_VERSION "0.99.newide"
-- 
1.5.3.7


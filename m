Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbZBLUaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbZBLUaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760615AbZBLU3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:29:01 -0500
Received: from kroah.org ([198.145.64.141]:58998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760601AbZBLU3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:29:00 -0500
Subject: patch staging-stlc45xx-fix-printk-format-warnings.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 12 Feb 2009 12:25:37 -0800
In-Reply-To: <20090211132146.18e0e30b.randy.dunlap@oracle.com>
Message-ID: <1234470337823@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: stlc45xx: fix printk format warnings

to my gregkh-2.6 tree.  Its filename is

    staging-stlc45xx-fix-printk-format-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Thu Feb 12 11:53:49 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 11 Feb 2009 13:21:46 -0800
Subject: Staging: stlc45xx: fix printk format warnings
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Message-ID: <20090211132146.18e0e30b.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/stlc45xx printk format warnings:

drivers/staging/stlc45xx/stlc45xx.c:453: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:509: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:718: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:851: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:857: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:1508: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/stlc45xx/stlc45xx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -450,7 +450,7 @@ static ssize_t stlc45xx_sysfs_store_cal_
 	mutex_lock(&stlc->mutex);
 
 	if (count != RSSI_CAL_ARRAY_LEN) {
-		stlc45xx_error("invalid cal_rssi length: %d", count);
+		stlc45xx_error("invalid cal_rssi length: %zu", count);
 		count = 0;
 		goto out_unlock;
 	}
@@ -506,7 +506,7 @@ static ssize_t stlc45xx_sysfs_store_cal_
 	mutex_lock(&stlc->mutex);
 
 	if (count != CHANNEL_CAL_ARRAY_LEN) {
-		stlc45xx_error("invalid cal_channels size: %d ", count);
+		stlc45xx_error("invalid cal_channels size: %zu ", count);
 		count = 0;
 		goto out_unlock;
 	}
@@ -715,7 +715,7 @@ static int stlc45xx_txbuffer_find(struct
 		/* not enough room */
 		pos = -1;
 
-	stlc45xx_debug(DEBUG_TXBUFFER, "txbuffer: find %d B: 0x%x", len, pos);
+	stlc45xx_debug(DEBUG_TXBUFFER, "txbuffer: find %zu B: 0x%x", len, pos);
 
 out:
 	return pos;
@@ -848,13 +848,13 @@ static int stlc45xx_request_firmware(str
 	}
 
 	if (fw->size % 4) {
-		stlc45xx_error("firmware size is not multiple of 32bit: %d",
+		stlc45xx_error("firmware size is not multiple of 32bit: %zu",
 			       fw->size);
 		return -EILSEQ; /* Illegal byte sequence  */;
 	}
 
 	if (fw->size < 1000) {
-		stlc45xx_error("firmware is too small: %d", fw->size);
+		stlc45xx_error("firmware is too small: %zu", fw->size);
 		return -EILSEQ;
 	}
 
@@ -1505,7 +1505,7 @@ static int stlc45xx_tx_frame(struct stlc
 
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 
-	stlc45xx_debug(DEBUG_TX, "tx frame 0x%p %d B", buf, len);
+	stlc45xx_debug(DEBUG_TX, "tx frame 0x%p %zu B", buf, len);
 	stlc45xx_dump(DEBUG_TX_CONTENT, buf, len);
 
 	stlc45xx_wakeup(stlc);


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

pending/firmware-add-kconfig-and-makefile-to-build-the-firmware-samples.patch
staging/staging-dst-kconfig-update.patch
staging/staging-dst-fix-build-dependancy.patch
staging/staging-rt2860-fix-printk-format-warnings.patch
staging/staging-rtl8187se-fix-kconfig-dependencies.patch
staging/staging-rtl8187se-fix-printk-format-warnings.patch
staging/staging-stlc45xx-fix-printk-format-warnings.patch
staging/staging-otus-fix-mixed-declarations.patch
staging/staging-android-ram_console-fix-printk-format-warning.patch
staging/staging-android-binder-fix-printk-format-warnings.patch
staging/staging-altera-fix-printk-format-warnings.patch

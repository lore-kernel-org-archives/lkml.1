Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZBKV3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZBKV3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbZBKV1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:27:04 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45303 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbZBKV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:27:03 -0500
Date: Wed, 11 Feb 2009 13:21:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 8/9] staging/stlc45xx: fix printk format warnings
Message-Id: <20090211132146.18e0e30b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4993429F.010C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/stlc45xx printk format warnings:

drivers/staging/stlc45xx/stlc45xx.c:453: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:509: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:718: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:851: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:857: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/staging/stlc45xx/stlc45xx.c:1508: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/stlc45xx/stlc45xx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/stlc45xx/stlc45xx.c
+++ mmotm-2009-0210-1635/drivers/staging/stlc45xx/stlc45xx.c
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

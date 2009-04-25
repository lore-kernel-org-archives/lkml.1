Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZDYNIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZDYNIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 09:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZDYNHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 09:07:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56995 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZDYNHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 09:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=eDC8XLT2G9txm4Wx57dyZxn6vUiB46T8m7BknxzNUyc0moGMEOr3CG8mDtWjVjgyCl
         g1wD/OpZKOJ8tGCAm9Ps3iwYIdzzAefuNVTW9XpoKcQwoDbGhZu/MZPklATP/OAB4S75
         NIHovCpdzcYS40kGCSMHlrZq12j5G9CMjigPQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: [PATCH 3/3] mg_disk: use defines from <linux/ata.h>
Date: Sat, 25 Apr 2009 15:10:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904251510.03924.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- remove MG_REG_HEAD_MUST_BE_ON define
- remove MG_REG_CTRL_INTR_ENABLE define
- remove MG_REG_HEAD_LBA_MODE define
- remove unused defines

Cc: unsik Kim <donari75@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/block/mg_disk.c |  143 ++++++++++++++----------------------------------
 1 file changed, 43 insertions(+), 100 deletions(-)

Index: b/drivers/block/mg_disk.c
===================================================================
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -50,51 +50,10 @@
 #define MG_REG_DRV_CTRL			(MG_REG_OFFSET + 0x10)
 #define MG_REG_BURST_CTRL		(MG_REG_OFFSET + 0x12)
 
-/* "Drive Select/Head Register" bit values */
-#define MG_REG_HEAD_MUST_BE_ON		0xA0 /* These 2 bits are always on */
-#define MG_REG_HEAD_DRIVE_MASTER	(0x00 | MG_REG_HEAD_MUST_BE_ON)
-#define MG_REG_HEAD_DRIVE_SLAVE		(0x10 | MG_REG_HEAD_MUST_BE_ON)
-#define MG_REG_HEAD_LBA_MODE		(0x40 | MG_REG_HEAD_MUST_BE_ON)
-
-
-/* "Device Control Register" bit values */
-#define MG_REG_CTRL_INTR_ENABLE			0x0
-#define MG_REG_CTRL_INTR_DISABLE		(0x1<<1)
-#define MG_REG_CTRL_RESET			(0x1<<2)
-#define MG_REG_CTRL_INTR_POLA_ACTIVE_HIGH	0x0
-#define MG_REG_CTRL_INTR_POLA_ACTIVE_LOW	(0x1<<4)
-#define MG_REG_CTRL_DPD_POLA_ACTIVE_LOW		0x0
-#define MG_REG_CTRL_DPD_POLA_ACTIVE_HIGH	(0x1<<5)
-#define MG_REG_CTRL_DPD_DISABLE			0x0
-#define MG_REG_CTRL_DPD_ENABLE			(0x1<<6)
-
-/* Status register bit */
-/* error bit in status register */
-#define MG_REG_STATUS_BIT_ERROR			0x01
-/* corrected error in status register */
-#define MG_REG_STATUS_BIT_CORRECTED_ERROR	0x04
-/* data request bit in status register */
-#define MG_REG_STATUS_BIT_DATA_REQ		0x08
-/* DSC - Drive Seek Complete */
-#define MG_REG_STATUS_BIT_SEEK_DONE		0x10
-/* DWF - Drive Write Fault */
-#define MG_REG_STATUS_BIT_WRITE_FAULT		0x20
-#define MG_REG_STATUS_BIT_READY			0x40
-#define MG_REG_STATUS_BIT_BUSY			0x80
-
 /* handy status */
-#define MG_STAT_READY	(MG_REG_STATUS_BIT_READY | MG_REG_STATUS_BIT_SEEK_DONE)
-#define MG_READY_OK(s)	(((s) & (MG_STAT_READY | \
-				(MG_REG_STATUS_BIT_BUSY | \
-				 MG_REG_STATUS_BIT_WRITE_FAULT | \
-				 MG_REG_STATUS_BIT_ERROR))) == MG_STAT_READY)
-
-/* Error register */
-#define MG_REG_ERR_AMNF		0x01
-#define MG_REG_ERR_ABRT		0x04
-#define MG_REG_ERR_IDNF		0x10
-#define MG_REG_ERR_UNC		0x40
-#define MG_REG_ERR_BBK		0x80
+#define MG_STAT_READY	(ATA_DRDY | ATA_DSC)
+#define MG_READY_OK(s)	(((s) & (MG_STAT_READY | (ATA_BUSY | ATA_DF | \
+				 ATA_ERR))) == MG_STAT_READY)
 
 /* error code for others */
 #define MG_ERR_NONE		0
@@ -224,41 +183,39 @@ static void mg_dump_status(const char *m
 	}
 
 	printk(KERN_ERR "%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
-	if (stat & MG_REG_STATUS_BIT_BUSY)
+	if (stat & ATA_BUSY)
 		printk("Busy ");
-	if (stat & MG_REG_STATUS_BIT_READY)
+	if (stat & ATA_DRDY)
 		printk("DriveReady ");
-	if (stat & MG_REG_STATUS_BIT_WRITE_FAULT)
+	if (stat & ATA_DF)
 		printk("WriteFault ");
-	if (stat & MG_REG_STATUS_BIT_SEEK_DONE)
+	if (stat & ATA_DSC)
 		printk("SeekComplete ");
-	if (stat & MG_REG_STATUS_BIT_DATA_REQ)
+	if (stat & ATA_DRQ)
 		printk("DataRequest ");
-	if (stat & MG_REG_STATUS_BIT_CORRECTED_ERROR)
+	if (stat & ATA_CORR)
 		printk("CorrectedError ");
-	if (stat & MG_REG_STATUS_BIT_ERROR)
+	if (stat & ATA_ERR)
 		printk("Error ");
 	printk("}\n");
-	if ((stat & MG_REG_STATUS_BIT_ERROR) == 0) {
+	if ((stat & ATA_ERR) == 0) {
 		host->error = 0;
 	} else {
 		host->error = inb((unsigned long)host->dev_base + MG_REG_ERROR);
 		printk(KERN_ERR "%s: %s: error=0x%02x { ", name, msg,
 				host->error & 0xff);
-		if (host->error & MG_REG_ERR_BBK)
+		if (host->error & ATA_BBK)
 			printk("BadSector ");
-		if (host->error & MG_REG_ERR_UNC)
+		if (host->error & ATA_UNC)
 			printk("UncorrectableError ");
-		if (host->error & MG_REG_ERR_IDNF)
+		if (host->error & ATA_IDNF)
 			printk("SectorIdNotFound ");
-		if (host->error & MG_REG_ERR_ABRT)
+		if (host->error & ATA_ABORTED)
 			printk("DriveStatusError ");
-		if (host->error & MG_REG_ERR_AMNF)
+		if (host->error & ATA_AMNF)
 			printk("AddrMarkNotFound ");
 		printk("}");
-		if (host->error &
-				(MG_REG_ERR_BBK | MG_REG_ERR_UNC |
-				 MG_REG_ERR_IDNF | MG_REG_ERR_AMNF)) {
+		if (host->error & (ATA_BBK | ATA_UNC | ATA_IDNF | ATA_AMNF)) {
 			if (host->breq) {
 				req = elv_next_request(host->breq);
 				if (req)
@@ -283,12 +240,12 @@ static unsigned int mg_wait(struct mg_ho
 
 	do {
 		cur_jiffies = jiffies;
-		if (status & MG_REG_STATUS_BIT_BUSY) {
-			if (expect == MG_REG_STATUS_BIT_BUSY)
+		if (status & ATA_BUSY) {
+			if (expect == ATA_BUSY)
 				break;
 		} else {
 			/* Check the error condition! */
-			if (status & MG_REG_STATUS_BIT_ERROR) {
+			if (status & ATA_ERR) {
 				mg_dump_status("mg_wait", status, host);
 				break;
 			}
@@ -297,8 +254,8 @@ static unsigned int mg_wait(struct mg_ho
 				if (MG_READY_OK(status))
 					break;
 
-			if (expect == MG_REG_STATUS_BIT_DATA_REQ)
-				if (status & MG_REG_STATUS_BIT_DATA_REQ)
+			if (expect == ATA_DRQ)
+				if (status & ATA_DRQ)
 					break;
 		}
 		if (!msec) {
@@ -403,12 +360,10 @@ static int mg_get_disk_id(struct mg_host
 	char serial[ATA_ID_SERNO_LEN + 1];
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_DISABLE,
-				(unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 
 	outb(MG_CMD_ID, (unsigned long)host->dev_base + MG_REG_COMMAND);
-	err = mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_RD_DRQ);
+	err = mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_RD_DRQ);
 	if (err)
 		return err;
 
@@ -448,8 +403,7 @@ static int mg_get_disk_id(struct mg_host
 			host->n_sectors, host->nres_sectors);
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 
 	return err;
 }
@@ -463,7 +417,7 @@ static int mg_disk_init(struct mg_host *
 
 	/* hdd rst low */
 	gpio_set_value(host->rst, 0);
-	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
+	err = mg_wait(host, ATA_BUSY, MG_TMAX_RST_TO_BUSY);
 	if (err)
 		return err;
 
@@ -474,17 +428,14 @@ static int mg_disk_init(struct mg_host *
 		return err;
 
 	/* soft reset on */
-	outb(MG_REG_CTRL_RESET |
-			(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
-			 MG_REG_CTRL_INTR_ENABLE),
+	outb(ATA_SRST | (prv_data->use_polling ? ATA_NIEN : 0),
 			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
-	err = mg_wait(host, MG_REG_STATUS_BIT_BUSY, MG_TMAX_RST_TO_BUSY);
+	err = mg_wait(host, ATA_BUSY, MG_TMAX_RST_TO_BUSY);
 	if (err)
 		return err;
 
 	/* soft reset off */
-	outb(prv_data->use_polling ? MG_REG_CTRL_INTR_DISABLE :
-			MG_REG_CTRL_INTR_ENABLE,
+	outb(prv_data->use_polling ? ATA_NIEN : 0,
 			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 	err = mg_wait(host, MG_STAT_READY, MG_TMAX_SWRST_TO_RDY);
 	if (err)
@@ -530,7 +481,7 @@ static unsigned int mg_out(struct mg_hos
 			MG_REG_CYL_LOW);
 	outb((u8)(sect_num >> 16), (unsigned long)host->dev_base +
 			MG_REG_CYL_HIGH);
-	outb((u8)((sect_num >> 24) | MG_REG_HEAD_LBA_MODE),
+	outb((u8)((sect_num >> 24) | ATA_LBA | ATA_DEVICE_OBS),
 			(unsigned long)host->dev_base + MG_REG_DRV_HEAD);
 	outb(cmd, (unsigned long)host->dev_base + MG_REG_COMMAND);
 	return MG_ERR_NONE;
@@ -558,7 +509,7 @@ static void mg_read(struct request *req)
 	       req->nr_sectors, req->sector, req->buffer);
 
 	do {
-		if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+		if (mg_wait(host, ATA_DRQ,
 					MG_TMAX_WAIT_RD_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
@@ -595,7 +546,7 @@ static void mg_write(struct request *req
 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
 	       req->nr_sectors, req->sector, req->buffer);
 
-	if (mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+	if (mg_wait(host, ATA_DRQ,
 			MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
@@ -607,7 +558,7 @@ static void mg_write(struct request *req
 
 	do {
 		if ((req->nr_sectors > 1) &&
-		     mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ,
+		     mg_wait(host, ATA_DRQ,
 				MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return;
@@ -630,11 +581,11 @@ static void mg_read_intr(struct mg_host 
 	/* check status */
 	do {
 		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
-		if (i & MG_REG_STATUS_BIT_BUSY)
+		if (i & ATA_BUSY)
 			break;
 		if (!MG_READY_OK(i))
 			break;
-		if (i & MG_REG_STATUS_BIT_DATA_REQ)
+		if (i & ATA_DRQ)
 			goto ok_to_read;
 	} while (0);
 	mg_dump_status("mg_read_intr", i, host);
@@ -675,11 +626,11 @@ static void mg_write_intr(struct mg_host
 	/* check status */
 	do {
 		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
-		if (i & MG_REG_STATUS_BIT_BUSY)
+		if (i & ATA_BUSY)
 			break;
 		if (!MG_READY_OK(i))
 			break;
-		if ((req->nr_sectors <= 1) || (i & MG_REG_STATUS_BIT_DATA_REQ))
+		if ((req->nr_sectors <= 1) || (i & ATA_DRQ))
 			goto ok_to_write;
 	} while (0);
 	mg_dump_status("mg_write_intr", i, host);
@@ -764,18 +715,15 @@ static unsigned int mg_issue_req(struct 
 		break;
 	case WRITE:
 		/* TODO : handler */
-		outb(MG_REG_CTRL_INTR_DISABLE,
-				(unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
 				!= MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
 		del_timer(&host->timer);
-		mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, MG_TMAX_WAIT_WR_DRQ);
-		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ);
+		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 		if (host->error) {
 			mg_bad_rw_intr(host);
 			return host->error;
@@ -856,9 +804,7 @@ static int mg_suspend(struct platform_de
 		return -EIO;
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_DISABLE,
-				(unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 
 	outb(MG_CMD_SLEEP, (unsigned long)host->dev_base + MG_REG_COMMAND);
 	/* wait until mflash deep sleep */
@@ -866,9 +812,7 @@ static int mg_suspend(struct platform_de
 
 	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD)) {
 		if (!prv_data->use_polling)
-			outb(MG_REG_CTRL_INTR_ENABLE,
-					(unsigned long)host->dev_base +
-					MG_REG_DRV_CTRL);
+			outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 		return -EIO;
 	}
 
@@ -891,8 +835,7 @@ static int mg_resume(struct platform_dev
 		return -EIO;
 
 	if (!prv_data->use_polling)
-		outb(MG_REG_CTRL_INTR_ENABLE, (unsigned long)host->dev_base +
-				MG_REG_DRV_CTRL);
+		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 
 	return 0;
 }

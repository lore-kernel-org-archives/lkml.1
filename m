Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZERCZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZERCZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZERCYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 22:24:39 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4766 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZERCYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 22:24:38 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Joe Perches <joe@perches.com>
Subject: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
Date: Sun, 17 May 2009 19:21:15 -0700
Message-Id: <3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
In-Reply-To: <cover.1242609803.git.joe@perches.com>
References: <cover.1242609803.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ht6560b.c    |    5 ++---
 drivers/ide/ide-acpi.c   |    2 +-
 drivers/ide/ide-cs.c     |    2 +-
 drivers/ide/ide-floppy.c |   16 +++++++---------
 drivers/ide/ide-tape.c   |    6 +++---
 drivers/ide/qd65xx.c     |    4 ++--
 6 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index 2fb0f29..0d56920 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -343,13 +343,12 @@ static int __init ht6560b_init(void)
 		return -ENODEV;
 
 	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
-		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
-			__func__);
+		pr_notice("%s: HT_CONFIG_PORT not found\n", __func__);
 		return -ENODEV;
 	}
 
 	if (!try_to_init_ht6560b()) {
-		printk(KERN_NOTICE "%s: HBA not found\n", __func__);
+		pr_notice("%s: HBA not found\n", __func__);
 		goto release_region;
 	}
 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 757d9f2..f0b77a5 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -67,7 +67,7 @@ static bool ide_noacpi_psx;
 static int no_acpi_psx(const struct dmi_system_id *id)
 {
 	ide_noacpi_psx = true;
-	printk(KERN_NOTICE"%s detected - disable ACPI _PSx.\n", id->ident);
+	pr_notice("%s detected - disable ACPI _PSx.\n", id->ident);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 3a97e66..268b604 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -338,7 +338,7 @@ static int ide_config(struct pcmcia_device *link)
     return 0;
 
 err_mem:
-    printk(KERN_NOTICE "ide-cs: ide_config failed memory allocation\n");
+    pr_notice("ide-cs: ide_config failed memory allocation\n");
     goto failed;
 
 cs_failed:
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index a6edb0d..d7c4f5c 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -349,9 +349,9 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	lba_capacity = floppy->blocks * floppy->block_size;
 
 	if (capacity < lba_capacity) {
-		printk(KERN_NOTICE PFX "%s: The disk reports a capacity of %d "
-			"bytes, but the drive only handles %d\n",
-			drive->name, lba_capacity, capacity);
+		pr_notice(PFX "%s: The disk reports a capacity of %d "
+			  "bytes, but the drive only handles %d\n",
+			  drive->name, lba_capacity, capacity);
 		floppy->blocks = floppy->block_size ?
 			capacity / floppy->block_size : 0;
 		drive->capacity64 = floppy->blocks * floppy->bs_factor;
@@ -428,17 +428,15 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 			memcpy(&floppy->cap_desc, cap_desc, 8);
 
 			if (!length || length % 512) {
-				printk(KERN_NOTICE PFX "%s: %d bytes block size"
-				       " not supported\n", drive->name, length);
+				pr_notice(PFX "%s: %d bytes block size not supported\n",
+					  drive->name, length);
 			} else {
 				floppy->blocks = blocks;
 				floppy->block_size = length;
 				floppy->bs_factor = length / 512;
 				if (floppy->bs_factor != 1)
-					printk(KERN_NOTICE PFX "%s: Warning: "
-					       "non 512 bytes block size not "
-					       "fully supported\n",
-					       drive->name);
+					pr_notice(PFX "%s: Warning: non 512 bytes block size not fully supported\n",
+						  drive->name);
 				drive->capacity64 =
 					floppy->blocks * floppy->bs_factor;
 				rc = 0;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 138c42d..bf3c128 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -756,8 +756,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if (!blk_special_request(rq)) {
 		/* We do not support buffer cache originated requests. */
-		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
-			"request queue (%d)\n", drive->name, rq->cmd_type);
+		pr_notice("ide-tape: %s: Unsupported request in request queue (%d)\n",
+			  drive->name, rq->cmd_type);
 		if (blk_fs_request(rq) == 0 && rq->errors == 0)
 			rq->errors = -EIO;
 		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
@@ -2176,7 +2176,7 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->user_bs_factor = 1;
 	tape->buffer_size = *ctl * tape->blk_size;
 	while (tape->buffer_size > 0xffff) {
-		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
+		pr_notice("ide-tape: decreasing stage size\n");
 		*ctl /= 2;
 		tape->buffer_size = *ctl * tape->blk_size;
 	}
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 5d02171..a25d18f 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -378,7 +378,7 @@ static int __init qd_probe(int base)
 			return -ENODEV;
 		}
 
-		printk(KERN_NOTICE "qd6500 at %#x\n", base);
+		pr_notice("qd6500 at %#x\n", base);
 		pr_debug("qd6500: config=%#x, ID3=%u\n", config, QD_ID3);
 
 		d.port_ops = &qd6500_port_ops;
@@ -391,7 +391,7 @@ static int __init qd_probe(int base)
 
 		control = inb(QD_CONTROL_PORT);
 
-		printk(KERN_NOTICE "qd6580 at %#x\n", base);
+		pr_notice("qd6580 at %#x\n", base);
 		pr_debug("qd6580: config=%#x, control=%#x, ID3=%u\n",
 			 config, control, QD_ID3);
 
-- 
1.6.3.1.10.g659a0.dirty


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXIIUZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXIIUZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbXIIUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:24:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60709 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759275AbXIIUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:24:48 -0400
Date: Sun, 9 Sep 2007 22:24:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] remove ide_get_error_location()
Message-ID: <20070909202455.GM3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
>  git-block.patch
>...
>  git trees
>...

ide_get_error_location() is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/ide-io.c |   35 -----------------------------------
 include/linux/ide.h  |    5 -----
 2 files changed, 40 deletions(-)

924249789a0c0d577c5c5bfa91f4e514b7ebde60 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c1692d9..ec835e3 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -322,41 +322,6 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
-/*
- * FIXME: probably move this somewhere else, name is bad too :)
- */
-u64 ide_get_error_location(ide_drive_t *drive, char *args)
-{
-	u32 high, low;
-	u8 hcyl, lcyl, sect;
-	u64 sector;
-
-	high = 0;
-	hcyl = args[5];
-	lcyl = args[4];
-	sect = args[3];
-
-	if (ide_id_has_flush_cache_ext(drive->id)) {
-		low = (hcyl << 16) | (lcyl << 8) | sect;
-		HWIF(drive)->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
-		high = ide_read_24(drive);
-	} else {
-		u8 cur = HWIF(drive)->INB(IDE_SELECT_REG);
-		if (cur & 0x40) {
-			high = cur & 0xf;
-			low = (hcyl << 16) | (lcyl << 8) | sect;
-		} else {
-			low = hcyl * drive->head * drive->sect;
-			low += lcyl * drive->sect;
-			low += sect - 1;
-		}
-	}
-
-	sector = ((u64) high << 24) | low;
-	return sector;
-}
-EXPORT_SYMBOL(ide_get_error_location);
-
 /**
  *	ide_end_drive_cmd	-	end an explicit drive command
  *	@drive: command 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 48871f9..65de5c3 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1088,11 +1088,6 @@ extern ide_startstop_t ide_do_reset (ide_drive_t *);
 extern void ide_init_drive_cmd (struct request *rq);
 
 /*
- * this function returns error location sector offset in case of a write error
- */
-extern u64 ide_get_error_location(ide_drive_t *, char *);
-
-/*
  * "action" parameter type for ide_do_drive_cmd() below.
  */
 typedef enum {


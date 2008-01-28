Return-Path: <linux-kernel-owner+w=401wt.eu-S1764062AbYA1WVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764062AbYA1WVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbYA1WPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:15:42 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52503 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762855AbYA1WPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:15:41 -0500
Date: Tue, 29 Jan 2008 00:10:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.o
Subject: [2.6 patch] ide: make wait_drive_not_busy() static again
Message-ID: <20080128221006.GK8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 7267c3377443322588cddaf457cf106839a60463 
wait_drive_not_busy() can become static again.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/ide-taskfile.c |    2 +-
 include/linux/ide.h        |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 5eb6fa1..d320001 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -260,7 +260,7 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 	return ide_stopped;
 }
 
-u8 wait_drive_not_busy(ide_drive_t *drive)
+static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 	int retries;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 27cb39d..5d3d88e 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -986,8 +986,6 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
 void task_end_request(ide_drive_t *, struct request *, u8);
 
-u8 wait_drive_not_busy(ide_drive_t *);
-
 int ide_raw_taskfile(ide_drive_t *, ide_task_t *, u8 *, u16);
 int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
 


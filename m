Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXDOKzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXDOKzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXDOKzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:55:42 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:2692 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752336AbXDOKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:55:42 -0400
Date: Sun, 15 Apr 2007 12:54:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Clean up mutex_trylock noise
Message-ID: <20070415125444.4f06f233@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar's semaphore to mutex conversions left some noise on a few
trylock calls. Clean it up.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/zoran_driver.c |    2 +-
 drivers/mtd/mtd_blkdevs.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc6.orig/drivers/media/video/zoran_driver.c	2007-04-14 16:00:12.000000000 +0200
+++ linux-2.6.21-rc6/drivers/media/video/zoran_driver.c	2007-04-15 12:47:37.000000000 +0200
@@ -2034,7 +2034,7 @@ zoran_do_ioctl (struct inode *inode,
 	 * but moving the free code outside the munmap() handler fixes
 	 * all this... If someone knows why, please explain me (Ronald)
 	 */
-	if (!!mutex_trylock(&zr->resource_lock)) {
+	if (mutex_trylock(&zr->resource_lock)) {
 		/* we obtained it! Let's try to free some things */
 		if (fh->jpg_buffers.ready_to_be_freed)
 			jpg_fbuffer_free(file);
--- linux-2.6.21-rc6.orig/drivers/mtd/mtd_blkdevs.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6/drivers/mtd/mtd_blkdevs.c	2007-04-15 12:47:26.000000000 +0200
@@ -236,7 +236,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	int last_devnum = -1;
 	struct gendisk *gd;
 
-	if (!!mutex_trylock(&mtd_table_mutex)) {
+	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
 	}
@@ -314,7 +314,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
-	if (!!mutex_trylock(&mtd_table_mutex)) {
+	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
 	}


-- 
Jean Delvare

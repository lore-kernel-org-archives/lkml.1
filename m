Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZDFQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZDFQgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZDFQgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:36:39 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:50074 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZDFQgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:36:38 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] tx4939ide: Fix tx4939ide_{in,out}put_data_swap argument
Date: Tue,  7 Apr 2009 01:36:41 +0900
Message-Id: <1239035801-9603-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit adb1af9 ("ide: pass command instead of request to
ide_pio_datablock()") missed tx4939ide driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/ide/tx4939ide.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 2aad79b..571ad24 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -445,7 +445,7 @@ static void tx4939ide_tf_load(ide_drive_t *drive, struct ide_cmd *cmd)
 #ifdef __BIG_ENDIAN
 
 /* custom iops (independent from SWAP_IO_SPACE) */
-static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4939ide_input_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
@@ -457,7 +457,7 @@ static void tx4939ide_input_data_swap(ide_drive_t *drive, struct request *rq,
 	__ide_flush_dcache_range((unsigned long)buf, roundup(len, 2));
 }
 
-static void tx4939ide_output_data_swap(ide_drive_t *drive, struct request *rq,
+static void tx4939ide_output_data_swap(ide_drive_t *drive, struct ide_cmd *cmd,
 				void *buf, unsigned int len)
 {
 	unsigned long port = drive->hwif->io_ports.data_addr;
-- 
1.5.6.3


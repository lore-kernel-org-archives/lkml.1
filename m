Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbYJ0Ccg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbYJ0Ccg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 22:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ0Cc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 22:32:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:61011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJ0Cc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 22:32:28 -0400
Message-ID: <29ab51dc0810261932n7580e87aua85103f8b1dcc5a5@mail.gmail.com>
Date: Mon, 27 Oct 2008 11:32:27 +0900
From: "Nobuhiro Iwamatsu" <iwamatsu@nigauri.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gdrom: Fix compile error
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, Linux-sh <linux-sh@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value and argument of block_device_operations.release of gdrom
was changed.
This patch fix this problem.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsunigauri.org>
---
 drivers/cdrom/gdrom.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 9aaa86b..2eecb77 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -495,9 +495,10 @@ static int gdrom_bdops_open(struct block_device
*bdev, fmode_t mode)
 	return cdrom_open(gd.cd_info, bdev, mode);
 }

-static int gdrom_bdops_release(struct block_device *bdev, fmode_t mode)
+static int gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 {
-	return cdrom_release(gd.cd_info, mode);
+	cdrom_release(gd.cd_info, mode);
+	return 0;
 }

 static int gdrom_bdops_mediachanged(struct gendisk *disk)
-- 
1.5.6.5

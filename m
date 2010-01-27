Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850Ab0A0Usw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0A0Usw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449Ab0A0Ust
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:48:49 -0500
Received: from mail.perches.com ([173.55.12.10]:1547 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0A0Uqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 12/13] drivers/block/floppy.c: Remove misleading, used once FD_IOCTL_ALLOWED macro
Date: Wed, 27 Jan 2010 12:46:28 -0800
Message-Id: <5567cfaa74dc1f59d2584c3add23695011b316e2.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just code the test directly

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index d559964..623fda5 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3420,8 +3420,6 @@ static int fd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		    unsigned long param)
 {
-#define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE|FMODE_WRITE_IOCTL))
-
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
 	int i;
@@ -3454,7 +3452,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return ret;
 
 	/* permission checks */
-	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
+	if (((cmd & 0x40) && !(mode & (FMODE_WRITE | FMODE_WRITE_IOCTL))) ||
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
-- 
1.6.6.rc0.57.gad7a


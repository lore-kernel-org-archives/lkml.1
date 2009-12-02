Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZLBGIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZLBGIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZLBGH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1225 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 12/13] drivers/block/floppy.c: Readd SunOS eject cmd comment
Date: Tue,  1 Dec 2009 22:07:52 -0800
Message-Id: <2559266325cef800503beb097b24bb0cbe3ef215.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a little comment neatening

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e054fae..7c33f61 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1814,8 +1814,7 @@ static int fdc_configure(void)
 		return 0;
 	output_byte(0);
 	output_byte(0x10 | (no_fifo & 0x20) | (fifo_depth & 0xf));
-	output_byte(0);		/* pre-compensation from track
-				   0 upwards */
+	output_byte(0);		/* pre-compensation from track 0 upwards */
 	return 1;
 }
 
@@ -3991,9 +3990,12 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	} inparam;		/* parameters coming from user space */
 	const char *outparam;	/* parameters passed back to user space */
 
-	/* convert compatibility eject ioctls into floppy eject ioctl.
+	/*
+	 * convert compatibility eject ioctls into floppy eject ioctl.
 	 * We do this in order to provide a means to eject floppy disks before
-	 * installing the new fdutils package */
+	 * installing the new fdutils package,
+	 * 0x6470 is SunOS floppy eject
+	 */
 	if (cmd == CDROMEJECT || cmd == 0x6470) {
 		DPRINT("obsolete eject ioctl\n");
 		DPRINT("please use floppycontrol --eject\n");
@@ -4029,8 +4031,8 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		if (lock_fdc(drive, true))
 			return -EINTR;
 
-		/* do the actual eject. Fails on
-		 * non-Sparc architectures */
+		/* Do the actual eject.
+		 * Fails on non-Sparc architectures */
 		ret = fd_eject(UNIT(drive));
 
 		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
-- 
1.6.6.rc0.57.gad7a


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092Ab0AVE4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0AVE4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0AVE4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:30 -0500
Received: from mail.perches.com ([173.55.12.10]:1340 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/24] drivers/block/floppy.c: Remove CLEARSTRUCT macro, use memset
Date: Thu, 21 Jan 2010 20:52:39 -0800
Message-Id: <d039bdc66c9272da2818f2697ca28b907c02b01f.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f274aff..4a43373 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -314,8 +314,6 @@ static int initialising = 1;
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
 
-#define CLEARSTRUCT(x)	memset((x), 0, sizeof(*(x)))
-
 /* read/write */
 #define COMMAND		(raw_cmd->cmd[0])
 #define DR_SELECT	(raw_cmd->cmd[1])
@@ -3509,7 +3507,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		return -EINVAL;
 
 	/* copyin */
-	CLEARSTRUCT(&inparam);
+	memset(&inparam, 0, sizeof(inparam));
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 	    ECALL(fd_copyin((void __user *)param, &inparam, size))
 
@@ -3598,7 +3596,7 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 			OUT(FDGETFDCSTAT, UFDCS);
 
 		case FDWERRORCLR:
-			CLEARSTRUCT(UDRWE);
+			memset(UDRWE, 0, sizeof(*UDRWE));
 			return 0;
 			OUT(FDWERRORGET, UDRWE);
 
@@ -4260,7 +4258,7 @@ static int __init floppy_init(void)
 
 	for (i = 0; i < N_FDC; i++) {
 		fdc = i;
-		CLEARSTRUCT(FDCS);
+		memset(FDCS, 0, sizeof(*FDCS));
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
@@ -4293,8 +4291,8 @@ static int __init floppy_init(void)
 
 	/* initialise drive state */
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		CLEARSTRUCT(UDRS);
-		CLEARSTRUCT(UDRWE);
+		memset(UDRS, 0, sizeof(*UDRS));
+		memset(UDRWE, 0, sizeof(*UDRWE));
 		USETF(FD_DISK_NEWCHANGE);
 		USETF(FD_DISK_CHANGED);
 		USETF(FD_VERIFY);
-- 
1.6.6.rc0.57.gad7a


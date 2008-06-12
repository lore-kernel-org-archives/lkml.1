Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYFLGpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYFLGpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbYFLGld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:9089 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYFLGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=uVJvjMdboXkcDJTds1ZkzU4x3Fo/VEm7hXBvyhblEUzbiLCAWPohH/YiMK/9mSXYrU
         E1cMgow96BGMw5lfY8JkG+U15mvPxHLZGk3YkGoVqgrNtn36YQ8wmobKrXOyZe4QFjmy
         vVQMjGKRdkzhOTEooLYB/bn3gyuW8rMqSr/8I=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 14/18] ide-floppy: fold idefloppy_create_test_unit_ready_cmd into idefloppy_open
Date: Thu, 12 Jun 2008 08:41:06 +0200
Message-Id: <1213252870-20474-15-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for this function since it is used only once.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index ffebf83..615d3a3 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -569,13 +569,6 @@ static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start,
 	cmd[4] = start;
 }
 
-static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc,
-						 unsigned char *cmd)
-{
-	idefloppy_init_pc(pc, cmd);
-	cmd[0] = GPCMD_TEST_UNIT_READY;
-}
-
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
@@ -1161,7 +1154,9 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
-		idefloppy_create_test_unit_ready_cmd(&pc, cmd);
+		idefloppy_init_pc(&pc, cmd);
+		cmd[0] = GPCMD_TEST_UNIT_READY;
+
 		if (idefloppy_queue_pc_tail(drive, &pc, cmd)) {
 			idefloppy_create_start_stop_cmd(&pc, 1, cmd);
 			(void) idefloppy_queue_pc_tail(drive, &pc, cmd);
-- 
1.5.5.1


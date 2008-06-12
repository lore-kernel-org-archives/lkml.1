Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYFLGow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYFLGow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYFLGlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:9186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYFLGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=sRwgFrC+h1e/Dx9gAz0HflHkFQGxuFcgDXGKM7lSVxSuyBqySoGmIVTVsw99h0fUp/
         epvPa/m4fV53U13NXv3MjWlItcNXqr2xXsuwHqRCShG6j3hocLnNHe72iCwOdwleI+rg
         llvceP4HK0m2xtV9V4S7CNThIuzUojPUt6a/I=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 17/18] ide-floppy: cleanup idefloppy_create_rw_cmd
Date: Thu, 12 Jun 2008 08:41:09 +0200
Message-Id: <1213252870-20474-18-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change introduced by this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 1ec4951..8bdef60 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -576,8 +576,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int rw_dir = rq_data_dir(rq);
 
-	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
-		  block, blocks);
+	debug_log("%s: block == %d, blocks == %d\n", __func__, block, blocks);
 
 	idefloppy_init_pc(pc, NULL);
 	rq->cmd[0] = rw_dir == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
@@ -586,8 +585,10 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 
 	pc->rq = rq;
 	pc->b_count = rw_dir == READ ? 0 : rq->bio->bi_size;
-	if (rq->cmd_flags & REQ_RW)
+
+	if (rw_dir)
 		pc->flags |= PC_FLAG_WRITING;
+
 	pc->buf = NULL;
 	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
 	pc->flags |= PC_FLAG_DMA_OK;
-- 
1.5.5.1


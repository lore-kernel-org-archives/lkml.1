Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYCGQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYCGQgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYCGQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:36:13 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:28523 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYCGQgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UvSifHD50r4PbKbzC9BtF4iE9UeGUyLUdFYZk+ulr8NyXJXr5BTNsK5g+xXIKmJXvBaVoxxMd2g/vUga0G30bXhaeKeJENRWXtI1jbS22/4JHlpGZWqTUDsNapANqZQbwDEY5wiXCtRhqFNuOpS7RXs0enUbU04vdCBKhPUcBrw=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6.24.y stable]
Date: Fri, 7 Mar 2008 17:35:10 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803071735.10539.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi patch for 2.6.24.y
---
>From 541645be8bbb67d39113096263dcf00615d789e3 Mon Sep 17 00:00:00 2001
From: Pete Zaitcev <zaitcev@redhat.com>
Date: Sat, 9 Feb 2008 00:10:17 -0800
Subject: [PATCH] ub: fix up the conversion to sg_init_table()

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index a70c1c2..c452e2d 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -657,7 +657,6 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
-	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -668,6 +667,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	/*
 	 * get scatterlist from block layer
 	 */
+	sg_init_table(&urq->sgv[0], UB_MAX_REQ_SG);
 	n_elem = blk_rq_map_sg(lun->disk->queue, rq, &urq->sgv[0]);
 	if (n_elem < 0) {
 		/* Impossible, because blk_rq_map_sg should not hit ENOMEM. */

---
thanks,
Oliver

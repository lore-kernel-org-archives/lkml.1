Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZFWVdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZFWVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZFWVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:35 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38080 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZFWVca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iO9Wr3+3cK0XX+TYrm7l780vntj4/l8W6AP3q8Sfmndq2ow2HjocfLzHPKJjiHjVo7
         1zf9e7LoWM/JW3X0WlrkDiAfL+jmv3TToNOabIV+m1IXTUUnctRY/DB+EZiHS5VGtIRk
         F7ypLKCHeTUcAbfzqTGVntkG/lw6eqF1ph5bI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 2/6] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
Date: Tue, 23 Jun 2009 23:26:06 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906232326.06830.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests

Such requests should be failed with -EIO (like all other requests
in this function) instead of being completed successfully.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Untested, you may try pinging Borislav and/or Tejun about possible
testing if you would like to verify the patch before applying.

 drivers/ide/ide-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -152,7 +152,7 @@ void ide_kill_rq(ide_drive_t *drive, str
 
 	if ((media == ide_floppy || media == ide_tape) && drv_req) {
 		rq->errors = 0;
-		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
 	} else {
 		if (media == ide_tape)
 			rq->errors = IDE_DRV_ERROR_GENERAL;

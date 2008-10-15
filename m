Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYJOTwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYJOTwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYJOTua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:61913 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbYJOTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=nz5Bxx4kciPZfF3yeDuHkJSDYROh+nttid/yHd8SN45LZjvNCax6TS/hkQ3oPVlFz0
         Cdo4s3d/9BQzaqztVpTqgMv7+gXP4W6JD4g4M8Q6SA1MXkas+6GDwO6nu3a8LzKsIASw
         lZIkRkKhOJydNW5iQFEHtmJyI4q+gCRDJPvHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: cleanup ide_do_request()
Date: Wed, 15 Oct 2008 21:35:40 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810152135.41022.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both choose_drive() and PM handling code make sure that the queue
is unplugged so no need to check it again.

Cc: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: don't execute the next queued command from the
hard-IRQ context" but is independent from it

 drivers/ide/ide-io.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1016,11 +1016,6 @@ static void ide_do_request (ide_hwgroup_
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 		drive->service_start = jiffies;
 
-		if (blk_queue_plugged(drive->queue)) {
-			printk(KERN_ERR "ide: huh? queue was plugged!\n");
-			break;
-		}
-
 		/*
 		 * we know that the queue isn't empty, but this can happen
 		 * if the q->prep_rq_fn() decides to kill a request

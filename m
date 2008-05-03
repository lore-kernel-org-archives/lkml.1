Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYECNM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYECNM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbYECNMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:12:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31286 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYECNLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cRKvGfKarZMt1LF7umMTV1dSurn/u9ZeKgqBJL9VLpQ7brGTJm6JTaD5EiOw6Vw9DfGekD8o5rDdRunAlp2ihp8Y5RQHnPibqcws/5NPKc4peJCslLFm+2Bz3B6jmZGtEuYwZ0CPnCWxOYF3T6Of6h/AlSvXc3Yob7mqVrV5OIc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: set REQ_NOMERGE request flag in ide_do_drive_cmd()
Date: Sat, 3 May 2008 15:14:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Borislav Petkov <petkovbb@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031514.24727.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for converting IDE to use blk_execute_rq().

There should be no functional changes caused by this patch.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1603,6 +1603,8 @@ int ide_do_drive_cmd (ide_drive_t *drive
 	if (action == ide_preempt || action == ide_head_wait)
 		where = ELEVATOR_INSERT_FRONT;
 
+	rq->cmd_flags |= REQ_NOMERGE;
+
 	spin_lock_irqsave(&ide_lock, flags);
 	if (action == ide_preempt)
 		hwgroup->rq = NULL;

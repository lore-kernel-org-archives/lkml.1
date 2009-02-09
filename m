Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZBIUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZBIUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZBIUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:00:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbZBIUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:00:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pYbJZ/vKS9JMF8a44LkLFQw4NYVuln9ZJ2tBwcx+o8LW/hrM2JcT8oX9wvtt2KfCKi
         b1k70EET8wZfP61jWuCc+/mixxXk4csmMHnYvNyOgtaBiz0S3OjY0gfwnwT9yq7M/fjK
         DXNALm0g+YJPNfrgJo4aejO0O7hhlfGVLC0Co=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:43 +0100
Message-Id: <20090209200143.7985.44232.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: use ide_end_rq() in ide_complete_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ide_end_rq() in ide_complete_rq()

This results in PIO->DMA retry being triggered also on completion
of requests using ide_complete_rq() instead of ide_end_request().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -143,7 +143,7 @@ int ide_complete_rq(ide_drive_t *drive, 
 	struct request *rq = hwif->rq;
 	int rc;
 
-	rc = blk_end_request(rq, error, nr_bytes);
+	rc = ide_end_rq(drive, rq, error, nr_bytes);
 	if (rc == 0)
 		hwif->rq = NULL;
 

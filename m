Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbYBBSZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbYBBSZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbYBBSZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:25:10 -0500
Received: from ag-out-0708.google.com ([72.14.246.241]:63461 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761932AbYBBSZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=i17uUfYCviWbZGJLuDamRzY9Wz2tzfRNwrlpr3phejatfA5zByHTlDR38xgLTWuw5976Y9LRcB4CYfg58YwsSYI9z8NlsolZOxquRmuTCO5gm3UGXQWmOipSJGog2z+DRDufPIxHE04OnL8Blycoy+/rt9kA56t3Hl/ML2KZiSc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-scsi: remove needless SELECT_DRIVE() call
Date: Sat, 2 Feb 2008 19:06:33 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021906.33277.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SELECT_DRIVE() is called by IDE core code in start_request() before device
driver's ->do_request method.  In ide-scsi case ->do_request is implemented
by idescsi_do_request() which is also the only user of idescsi_issue_pc().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: unexport SELECT_DRIVE()" patch in IDE quilt tree

 drivers/scsi/ide-scsi.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -588,8 +588,6 @@ static ide_startstop_t idescsi_issue_pc 
 		hwif->sg_mapped = 0;
 	}
 
-	SELECT_DRIVE(drive);
-
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)

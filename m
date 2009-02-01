Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZBAT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZBAT1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZBAT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:26:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:64635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZBAT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CWuxqrYlwdi3asa01MDUyU4rG8kH58mFH8gkA3aHBIH/sjlvTUMn5Jk2UDPIZuJKwg
         tvhUw7bC9mbl+PA4sdx3bqdVqVMtTpAX26bF7x6DN75/Smm9Xj0bYjjWG6S53iFwYbJK
         iXiHUwTqJX91efcvGn/cnEMUdiY15LRfMPu4g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:27:46 +0100
Message-Id: <20090201192746.1592.67196.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] ide-floppy: remove superfluous check from ide_floppy_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-floppy: remove superfluous check from ide_floppy_end_request()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -91,9 +91,7 @@ static int ide_floppy_end_request(ide_dr
 
 	if (error)
 		floppy->failed_pc = NULL;
-	/* Why does this happen? */
-	if (!rq)
-		return 0;
+
 	if (!blk_special_request(rq)) {
 		/* our real local end request function */
 		ide_end_request(drive, uptodate, nsecs);

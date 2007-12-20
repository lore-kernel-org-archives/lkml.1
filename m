Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXLTBqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXLTBqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759153AbXLTBf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:12844 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955AbXLTBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nWrghrDkNbPHqg3vIUshw3Vc65JIe0+YJh/8dQMQ0MCuhCBLcI4jFZZiHfPyC939z8zCizwiTy9hqgN/I1bS+vuksnPK9H6W9EoMfLSl5v+seULKl1giObNKf14sAK+DrFmSgWxFDe/gBhL9XKIfZv+uSaMjem24xWdPSynjr14=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 59/63] ide-cd: call blk_dump_rq_flags() on "missing data" in cdrom_rw_intr()
Date: Thu, 20 Dec 2007 02:37:16 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200237.16566.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1301,10 +1301,12 @@ static ide_startstop_t cdrom_rw_intr(ide
 				 */
 				cdrom_buffer_sectors(drive, rq->sector,
 						     thislen >> 9);
-			else
+			else {
 				printk(KERN_ERR "%s: %s: confused, missing "
 						"data\n",
 						drive->name, __FUNCTION__);
+				blk_dump_rq_flags(rq, "cdrom_rw_intr, write");
+			}
 			break;
 		}
 

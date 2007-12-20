Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXLTBgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXLTBgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXLTBeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbXLTBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=M2cf1nIuV0GB3WqJ7U37xQoAwGK6/rzkio5te6vjHVkT8vGUfBUS50WIlN3bub/p4e63/YLwsgvPXZsbbobKEBR86nciUk4RboPnDj+bdjuEQpBuCfX4pKpbRua32lLPWPjw/JtC56+rrWJrwHh8C6GmDrfRNW3q7UTeelhACoo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 07/63] ide-cd: add error message for DMA error to cdrom_read_intr()
Date: Thu, 20 Dec 2007 01:57:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200157.04907.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1106,8 +1106,11 @@ static ide_startstop_t cdrom_read_intr (
 	 */
 	if (dma) {
 		info->dma = 0;
-		if ((dma_error = HWIF(drive)->ide_dma_end(drive)))
+		dma_error = HWIF(drive)->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA read error\n", drive->name);
 			ide_dma_off(drive);
+		}
 	}
 
 	if (cdrom_decode_status(drive, 0, &stat))

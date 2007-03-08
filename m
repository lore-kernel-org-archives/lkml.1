Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbXCHORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbXCHORN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXCHORN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:17:13 -0500
Received: from mail.parknet.jp ([210.171.160.80]:4356 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbXCHORM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:17:12 -0500
X-AuthUser: hirofumi@parknet.jp
To: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: libata: Fix host->simplex_claimed != ap typo
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 08 Mar 2007 23:17:00 +0900
Message-ID: <87lki7zuoz.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following patch is needed to boot my laptop using pata_ali.ko, at least.
Please apply.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>




Fix typo. "host->simplex_claimed != ap" should be "==", not "!=".

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~ata-fix-simplex-handling-fix drivers/ata/libata-core.c
--- linux-2.6/drivers/ata/libata-core.c~ata-fix-simplex-handling-fix	2007-03-08 07:31:49.000000000 +0900
+++ linux-2.6-hirofumi/drivers/ata/libata-core.c	2007-03-08 07:31:59.000000000 +0900
@@ -3455,7 +3455,7 @@ static void ata_dev_xfermask(struct ata_
 			       "device is on DMA blacklist, disabling DMA\n");
 	}
 
-	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed != ap) {
+	if ((host->flags & ATA_HOST_SIMPLEX) && host->simplex_claimed == ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
 			       "other device, disabling DMA\n");
_

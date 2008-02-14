Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYBNFPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYBNFPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYBNFOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:15 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:8412 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYBNFOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PIXq6KFSdS1WrXCxKGktzYr0yQvyGjslKxRsGkPa1hlnxg+EoaAEEip2yM4xgZMFLtzyzdu/96uhwA0UKLXEjEN6csQe2CvmpqPQejR94k16AH0tJbz2MKJHS0XxlVmxAITLEnk/0sGzOgsN8PEu4OtRwsumJ+bN2MsBEO+nVmo=
Subject: [PATCH 02/11] ata: fix sparse warning in sata_promise.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:08 -0800
Message-Id: <1202966048.2748.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/sata_promise.c:546:15: warning: symbol 'len' shadows an earlier one
drivers/ata/sata_promise.c:538:6: originally declared here

len is set again immediately after the loop, so this is safe.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/sata_promise.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index a07d319..f251a5f 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -543,7 +543,7 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 	idx = 0;
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
-		u32 sg_len, len;
+		u32 sg_len;
 
 		/* determine if physical DMA addr spans 64K boundary.
 		 * Note h/w doesn't support 64-bit, so we unconditionally
-- 
1.5.4.1.1278.gc75be



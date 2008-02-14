Return-Path: <linux-kernel-owner+w=401wt.eu-S933560AbYBNFQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560AbYBNFQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764069AbYBNFOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:37 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:8363 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277AbYBNFOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=URJieDFQ9JM5+P/v1+OY6DwNcj+GeYQDgl56kWj39QmQr7vEhVwk10Ot8E7lY9rwHa4YIi198vXkhz0bvhuZvZ49SZDgTu/bccLd+YZoAkr1Z6vIEv74rTVdNj73NfWUvP8gXgTjLmAeQxb+t5M7nHD7tFqJQl/aA23IVf3fKyg=
Subject: [PATCH 04/11] ata: fix sparse warnings in sata_mv.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:14 -0800
Message-Id: <1202966055.2748.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pp is never used again in this function, no need to declare a
new one.

drivers/ata/sata_mv.c:1545:24: warning: symbol 'pp' shadows an earlier one
drivers/ata/sata_mv.c:1501:22: originally declared here
drivers/ata/sata_mv.c:1553:24: warning: symbol 'pp' shadows an earlier one
drivers/ata/sata_mv.c:1501:22: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/sata_mv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 04b5717..2ecd44d 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1542,7 +1542,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		eh_freeze_mask = EDMA_EH_FREEZE_5;
 
 		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
-			struct mv_port_priv *pp	= ap->private_data;
+			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
@@ -1550,7 +1550,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		eh_freeze_mask = EDMA_EH_FREEZE;
 
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
-			struct mv_port_priv *pp	= ap->private_data;
+			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
-- 
1.5.4.1.1278.gc75be



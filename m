Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYDWJ4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYDWJ4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYDWJvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:50 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59428 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbYDWJvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:49 -0400
Date: Wed, 23 Apr 2008 12:51:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/FlashPoint.c: fix off-by-one errors
Message-ID: <20080423095110.GX28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes off-by-one errors in error checks (the variables are 
used as array indexes for arrays with MAX_SCSI_TAR resp. MAX_LUN 
elements) spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
02fc526feb4e67cfb0008e04f5b797e8315b9cd4 diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b374e45..b898d38 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -1499,7 +1499,7 @@ static void FlashPoint_StartCCB(unsigned long pCurrCard, struct sccb *p_Sccb)
 	thisCard = ((struct sccb_card *)pCurrCard)->cardIndex;
 	ioport = ((struct sccb_card *)pCurrCard)->ioPort;
 
-	if ((p_Sccb->TargID > MAX_SCSI_TAR) || (p_Sccb->Lun > MAX_LUN)) {
+	if ((p_Sccb->TargID >= MAX_SCSI_TAR) || (p_Sccb->Lun >= MAX_LUN)) {
 
 		p_Sccb->HostStatus = SCCB_COMPLETE;
 		p_Sccb->SccbStatus = SCCB_ERROR;


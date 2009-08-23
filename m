Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbZHWNdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbZHWNdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbZHWNdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:33:51 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64177 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632AbZHWNa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DB8MO6EfT8UfT434iBPCyuDsvCYyJU+e1G4BpYiJejjJZoveZM7uzyqo8xojBa1KFT
         imZPyXoudpn9y9jtER+YPs+mj8SQcWzgKpmGRaXD9ivTFkXfVu8l4kC9d7F6Ex4ruOSq
         g0LrUkqpfK4TLgAzXCf61nOBITEaC/mWaS3wY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:56 +0200
Message-Id: <20090823133056.17784.57980.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/33] Staging: rt28x0: MlmeSelectTxRateTable() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: MlmeSelectTxRateTable() fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1566,12 +1566,7 @@ VOID MlmeSelectTxRateTable(
 		}
 
 		//else if ((pAd->StaActive.SupRateLen == 4) && (pAd->StaActive.ExtRateLen == 0) && (pAd->StaActive.SupportedPhyInfo.MCSSet[0] == 0) && (pAd->StaActive.SupportedPhyInfo.MCSSet[1] == 0))
-		if ((pEntry->RateLen == 4)
-#ifndef RT30xx
-//Iverson mark for Adhoc b mode,sta will use rate 54  Mbps when connect with sta b/g/n mode
-			&& (pEntry->HTCapability.MCSSet[0] == 0) && (pEntry->HTCapability.MCSSet[1] == 0)
-#endif
-			)
+		if (pEntry->RateLen == 4)
 		{// B only AP
 			*ppTable = RateSwitchTable11B;
 			*pTableSize = RateSwitchTable11B[0];

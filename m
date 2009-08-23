Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbZHWNdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbZHWNdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933984AbZHWNaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:19 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbZHWNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FAD5FHx7bW6RKl4DWieY0cDalbSQmKhvrieiSKsMx90MWQjMKU8sEYJCgrIrCCWXea
         1DvBZNCgM76cOZwIlDFNcl/MiZj/SI2Ajfmi7TwJkfR0C1AiTOzETb8vT539apzKRfRF
         Ed5Mb3RecD7q14A+de1R6fsdzB6KgfwidaS4E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:43 +0200
Message-Id: <20090823133043.17784.28086.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/33] Staging: rt28x0: AsicSwitchChannel() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: AsicSwitchChannel() fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -5756,7 +5756,6 @@ VOID AsicSwitchChannel(
 	RTMP_RF_REGS *RFRegTable;
 
 	// Search Tx power value
-#ifdef RT30xx
 	// We can't use ChannelList to search channel, since some central channl's txpowr doesn't list
 	// in ChannelList, so use TxPower array instead.
 	//
@@ -5769,17 +5768,6 @@ VOID AsicSwitchChannel(
 			break;
 		}
 	}
-#else
-	for (index = 0; index < pAd->ChannelListNum; index++)
-	{
-		if (Channel == pAd->ChannelList[index].Channel)
-		{
-			TxPwer = pAd->ChannelList[index].Power;
-			TxPwer2 = pAd->ChannelList[index].Power2;
-			break;
-		}
-	}
-#endif
 
 	if (index == MAX_NUM_OF_CHANNELS)
 		DBGPRINT(RT_DEBUG_ERROR, ("AsicSwitchChannel: Can't find the Channel#%d \n", Channel));

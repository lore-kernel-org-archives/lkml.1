Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbZHWN3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbZHWN3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933891AbZHWN3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:12 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbZHWN3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XfRJG3UrhPjgs5uVpIVRFLQYekkqwLJ/SHNNS6vuh6EuExHE4S4tfeBZxdnwjQQedw
         6d18feunpH7iHdi44m0rKGQJ1cjladQvb1gEEZa9k2gc7q4pbVRF1rvjBun9RqQxlgyN
         fcz5UXf42XR7xKqgU0JZBshpYwuamTYFCj58c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:39 +0200
Message-Id: <20090823132939.17784.94504.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/33] Staging: rt3070: AsicSetSlotTime() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: AsicSetSlotTime() fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -7004,7 +7004,6 @@ VOID 	AsicSetSlotTime(
 	SlotTime = (bUseShortSlotTime)? 9 : 20;
 
 	{
-#ifndef RT30xx
 		// force using short SLOT time for FAE to demo performance when TxBurst is ON
 		if (((pAd->StaActive.SupportedPhyInfo.bHtEnable == FALSE) && (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_WMM_INUSED)))
 			|| ((pAd->StaActive.SupportedPhyInfo.bHtEnable == TRUE) && (pAd->CommonCfg.BACapability.field.Policy == BA_NOTUSE))
@@ -7014,10 +7013,6 @@ VOID 	AsicSetSlotTime(
 			// And we will not set to short slot when bEnableTxBurst is TRUE.
 		}
 		else if (pAd->CommonCfg.bEnableTxBurst)
-#endif
-#ifdef RT30xx
-		if (pAd->CommonCfg.bEnableTxBurst)
-#endif
 			SlotTime = 9;
 	}
 

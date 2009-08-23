Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbZHWNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbZHWNaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933933AbZHWNaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:16 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64177 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933970AbZHWNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xvxeNxWqCHjWzDrP6rYsIp5WFgPGcB2YhFpGV8bj6OnIk+spkRsq1A/Vz2d2WU8dCf
         wOtSLMpN2GvxEODdnltINY0n00cF62JCT+V22Wdx6z/8YfDFdATLmamTPH8gtahs7Kur
         LwHbsr3TLj2V+QGIGpR0vfUsmV6+Qt9eKYIvw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:37 +0200
Message-Id: <20090823133037.17784.76688.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/33] Staging: rt28x0 fix BACapability policy handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0 fix BACapability policy handling

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_info.c |    7 +------
 drivers/staging/rt2860/rt_profile.c      |    6 ------
 2 files changed, 1 insertion(+), 12 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_info.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -2491,24 +2491,19 @@ INT	Set_HtAutoBa_Proc(
 	if (Value == 0)
 	{
 		pAd->CommonCfg.BACapability.field.AutoBA = FALSE;
-#ifdef RT30xx
 		pAd->CommonCfg.BACapability.field.Policy = BA_NOTUSE;
-#endif
 	}
     else if (Value == 1)
 	{
 		pAd->CommonCfg.BACapability.field.AutoBA = TRUE;
-#ifdef RT30xx
 		pAd->CommonCfg.BACapability.field.Policy = IMMED_BA;
-#endif
 	}
 	else
 		return FALSE; //Invalid argument
 
     pAd->CommonCfg.REGBACapability.field.AutoBA = pAd->CommonCfg.BACapability.field.AutoBA;
-#ifdef RT30xx
     pAd->CommonCfg.REGBACapability.field.Policy = pAd->CommonCfg.BACapability.field.Policy;
-#endif
+
 	SetCommonHT(pAd);
 
 	DBGPRINT(RT_DEBUG_TRACE, ("Set_HtAutoBa_Proc::(HtAutoBa=%d)\n",pAd->CommonCfg.BACapability.field.AutoBA));
Index: b/drivers/staging/rt2860/rt_profile.c
===================================================================
--- a/drivers/staging/rt2860/rt_profile.c
+++ b/drivers/staging/rt2860/rt_profile.c
@@ -1541,21 +1541,15 @@ static void	HTParametersHook(
         if (Value == 0)
         {
             pAd->CommonCfg.BACapability.field.AutoBA = FALSE;
-#ifdef RT30xx
 	    pAd->CommonCfg.BACapability.field.Policy = BA_NOTUSE;
-#endif
         }
         else
         {
             pAd->CommonCfg.BACapability.field.AutoBA = TRUE;
-#ifdef RT30xx
 	    pAd->CommonCfg.BACapability.field.Policy = IMMED_BA;
-#endif
         }
         pAd->CommonCfg.REGBACapability.field.AutoBA = pAd->CommonCfg.BACapability.field.AutoBA;
-#ifdef RT30xx
 	pAd->CommonCfg.REGBACapability.field.Policy = pAd->CommonCfg.BACapability.field.Policy;
-#endif
         DBGPRINT(RT_DEBUG_TRACE, ("HT: Auto BA  = %s\n", (Value==0) ? "Disable" : "Enable"));
     }
 

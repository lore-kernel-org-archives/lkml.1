Return-Path: <linux-kernel-owner+w=401wt.eu-S933992AbZHWNa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbZHWNa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933986AbZHWNaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:24 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbZHWNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Y3VvPyy4J9rvhrzT2h17qtxZQ7h6gS5t35lsmmit/cEMdz5qk1D+wWfugbCsvYSEzz
         DqGf4L0oVy8aGL5o4JIz5WiyqQ8aT6v5A0aSJRzNqsWGE3UrNfuhh8Zia0ip1vGm/K4I
         S3L63CnMSkSIvFY51obkyETJQGLXcdBiQRFto=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:50 +0200
Message-Id: <20090823133050.17784.44149.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/33] Staging: rt28x0: BssTableSetEntry() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: BssTableSetEntry() fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -3840,18 +3840,14 @@ ULONG BssTableSetEntry(
 	}
 	else
 	{
-#ifdef RT30xx
 		/* avoid  Hidden SSID form beacon to overwirite correct SSID from probe response */
 		if ((SSID_EQUAL(Ssid, SsidLen, Tab->BssEntry[Idx].Ssid, Tab->BssEntry[Idx].SsidLen)) ||
 			(NdisEqualMemory(Tab->BssEntry[Idx].Ssid, ZeroSsid, Tab->BssEntry[Idx].SsidLen)))
 		{
-#endif
 		BssEntrySet(pAd, &Tab->BssEntry[Idx], pBssid, Ssid, SsidLen, BssType, BeaconPeriod,CfParm, AtimWin,
 					CapabilityInfo, SupRate, SupRateLen, ExtRate, ExtRateLen,pHtCapability, pAddHtInfo,HtCapabilityLen, AddHtInfoLen,
 					NewExtChanOffset, ChannelNo, Rssi, TimeStamp, CkipFlag, pEdcaParm, pQosCapability, pQbssLoad, LengthVIE, pVIE);
-#ifdef RT30xx
 		}
-#endif
 	}
 
 	return Idx;

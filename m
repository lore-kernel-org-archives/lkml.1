Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbZHWN3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbZHWN3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZHWN3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:30 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbZHWN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=opapGt1+SLbCN9iT3zmZaNh0inygf15Y2OHjXVxPIUEgIkBYLq/T84lt7u2jJxgHx7
         o2xSB+N+/jVuwafbzC/QPwd13s+H3LJWWqXfY6DMm2WXmcG0QioVf6nSOlL5ZOQnjEYZ
         sP90R6lxTQvzt17l1j+GXXJfj9ZD/B9ElrjSI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:58 +0200
Message-Id: <20090823132958.17784.93783.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/33] Staging: rt2870: use internal command for AsicUpdateProtect()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: use internal command for AsicUpdateProtect()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_data.c |    5 ++---
 drivers/staging/rt2870/common/rtusb_io.c |    6 ------
 2 files changed, 2 insertions(+), 9 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -2332,10 +2332,9 @@ BOOLEAN MacTableDeleteEntry(
 	if (pAd->MacTab.Size == 0)
 	{
 		pAd->CommonCfg.AddHTInfo.AddHtInfo2.OperaionMode = 0;
-#ifndef RT30xx
+#ifdef RT2860
 		AsicUpdateProtect(pAd, 0 /*pAd->CommonCfg.AddHTInfo.AddHtInfo2.OperaionMode*/, (ALLN_SETPROTECT), TRUE, 0 /*pAd->MacTab.fAnyStationNonGF*/);
-#endif
-#ifdef RT30xx
+#else
 		// edit by johnli, fix "in_interrupt" error when call "MacTableDeleteEntry" in Rx tasklet
 		// Set MAC register value according operation mode
 		RTUSBEnqueueInternalCmd(pAd, CMDTHREAD_UPDATE_PROTECT, NULL, 0);
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1807,17 +1807,11 @@ VOID CMDHandler(
 								pEntry->Addr[0], pEntry->Addr[1], pEntry->Addr[2], pEntry->Addr[3], pEntry->Addr[4], pEntry->Addr[5]);
 					}
 					break;
-
-#ifdef RT30xx
-// add by johnli, fix "in_interrupt" error when call "MacTableDeleteEntry" in Rx tasklet
 				case CMDTHREAD_UPDATE_PROTECT:
 					{
 						AsicUpdateProtect(pAd, 0, (ALLN_SETPROTECT), TRUE, 0);
 					}
 					break;
-// end johnli
-#endif
-
 				case OID_802_11_ADD_WEP:
 					{
 						UINT	i;

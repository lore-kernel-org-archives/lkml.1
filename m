Return-Path: <linux-kernel-owner+w=401wt.eu-S933949AbZHWN3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbZHWN3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933881AbZHWN3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880AbZHWN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gV9837+d27AV7zSD4/cnVd0SwVFqgtIzEePpZdxPQKgqUdHJE70P6mEJ3/sCQjvnpA
         K/1mS8jvUz219kCN0giJ9/wxU9CVr8d4zvScZwIFwHb4sE3tr/LiVRKkFKM/vpCO3jDN
         g5qZ38in9bBkHFKLIiuxUtsLZRibQENK/A+yU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:04 +0200
Message-Id: <20090823133004.17784.80695.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/33] Staging: rt2870: add fRTUSB_BULK_OUT_DATA_NORMAL_5 quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: add fRTUSB_BULK_OUT_DATA_NORMAL_5 quirk

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2870/common/2870_rtmp_init.c |    5 -----
 drivers/staging/rt2870/common/rtusb_bulk.c     |    3 +--
 2 files changed, 1 insertion(+), 7 deletions(-)

Index: b/drivers/staging/rt2870/common/2870_rtmp_init.c
===================================================================
--- a/drivers/staging/rt2870/common/2870_rtmp_init.c
+++ b/drivers/staging/rt2870/common/2870_rtmp_init.c
@@ -1293,12 +1293,7 @@ static void rt2870_hcca_dma_done_tasklet
 				RTMPDeQueuePacket(pAd, FALSE, BulkOutPipeId, MAX_TX_PROCESS);
 			}
 
-#ifndef RT30xx
-			RTUSB_SET_BULK_FLAG(pAd, fRTUSB_BULK_OUT_DATA_NORMAL);
-#endif
-#ifdef RT30xx
 			RTUSB_SET_BULK_FLAG(pAd, fRTUSB_BULK_OUT_DATA_NORMAL<<4);
-#endif
 			RTUSBKickBulkOut(pAd);
 		}
 	}
Index: b/drivers/staging/rt2870/common/rtusb_bulk.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_bulk.c
+++ b/drivers/staging/rt2870/common/rtusb_bulk.c
@@ -976,7 +976,7 @@ VOID	RTUSBKickBulkOut(
 				RTUSBBulkOutDataPacket(pAd, 3, pAd->NextBulkOutIndex[3]);
 			}
 		}
-#ifdef RT30xx
+
 		//PS packets use HCCA queue when dequeue from PS unicast queue (WiFi WPA2 MA9_DT1 for Marvell B STA)
 		if (RTUSB_TEST_BULK_FLAG(pAd, fRTUSB_BULK_OUT_DATA_NORMAL_5))
 		{
@@ -986,7 +986,6 @@ VOID	RTUSBKickBulkOut(
 			{
 			}
 		}
-#endif
 
 		// 7. Null frame is the last
 		else if (RTUSB_TEST_BULK_FLAG(pAd, fRTUSB_BULK_OUT_DATA_NULL))

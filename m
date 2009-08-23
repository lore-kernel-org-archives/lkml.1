Return-Path: <linux-kernel-owner+w=401wt.eu-S934060AbZHWNbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbZHWNbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934000AbZHWNbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:31:11 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbZHWNbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JIO1S8xQLN8iwPtNvlUOQSXodtD3k4YDnqYA0lGd44m/F60cCkRKq7ThgRmV+1HHx7
         9zF9/Vozqu6zLYYdyv1xNtBMMb7gHHFjZJuvChLE0SqOvYxZRd+TSZwmV7JAguwo8I7x
         Hfb3Z3dGbkCKQn35ASa9y0yDzFgfIB08RspDU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:34 +0200
Message-Id: <20090823133134.17784.29200.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 26/33] Staging: rt3070: remove unused RT_CMD_SET_* internal commands
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: remove unused RT_CMD_SET_* internal commands

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2870/common/rtusb_io.c |   33 -------------------------------
 drivers/staging/rt2870/rt2870.h          |    2 -
 2 files changed, 35 deletions(-)

Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1729,39 +1729,6 @@ VOID CMDHandler(
 						}
 					}
 					break;
-
-#ifdef RT30xx
-//Benson modified for USB interface, avoid in interrupt when write key, 20080724 -->
-				case RT_CMD_SET_KEY_TABLE: //General call for AsicAddPairwiseKeyEntry()
-				{
-					RT_ADD_PAIRWISE_KEY_ENTRY KeyInfo;
-					KeyInfo = *((PRT_ADD_PAIRWISE_KEY_ENTRY)(pData));
-					AsicAddPairwiseKeyEntry(pAd,
-											KeyInfo.MacAddr,
-											(UCHAR)KeyInfo.MacTabMatchWCID,
-											&KeyInfo.CipherKey);
-				}
-					break;
-				case RT_CMD_SET_RX_WCID_TABLE: //General call for RTMPAddWcidAttributeEntry()
-				{
-					PMAC_TABLE_ENTRY pEntry;
-					UCHAR KeyIdx = 0;
-					UCHAR CipherAlg = 0;
-					UCHAR ApIdx = 0;
-
-					pEntry = (PMAC_TABLE_ENTRY)(pData);
-
-						RTMPAddWcidAttributeEntry(
-										  pAd,
-										  ApIdx,
-										  KeyIdx,
-										  CipherAlg,
-										  pEntry);
-					}
-						break;
-//Benson modified for USB interface, avoid in interrupt when write key, 20080724 <--
-#endif
-
 				case CMDTHREAD_SET_CLIENT_MAC_ENTRY:
 					{
 						MAC_TABLE_ENTRY *pEntry;
Index: b/drivers/staging/rt2870/rt2870.h
===================================================================
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -557,8 +557,6 @@ typedef	struct	_CMDHandler_TLV	{
 #define CMDTHREAD_SET_ASIC_WCID                     0x0D730226	// cmd
 #define CMDTHREAD_SET_ASIC_WCID_CIPHER              0x0D730227	// cmd
 #define CMDTHREAD_QKERIODIC_EXECUT                  0x0D73023D	// cmd
-#define RT_CMD_SET_KEY_TABLE                        0x0D730228  // cmd
-#define RT_CMD_SET_RX_WCID_TABLE                    0x0D730229  // cmd
 #define CMDTHREAD_SET_CLIENT_MAC_ENTRY              0x0D73023E	// cmd
 #define CMDTHREAD_802_11_QUERY_HARDWARE_REGISTER    0x0D710105	// cmd
 #define CMDTHREAD_802_11_SET_PHY_MODE               0x0D79010C	// cmd

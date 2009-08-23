Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbZHWNas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbZHWNas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934008AbZHWNaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:46 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002AbZHWNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KHcD8solNHqZQGQE+a1bCRqHouN3CET8RvotyFj8GYWxgG+t2d74XAK0Y3SO+ounjq
         PPApOgZY9v+qCGP0egZgyt8oNrDjHxdKrY3YEIF9vlVv91Y5hYSWU0Shf+QgLrL16Mp4
         IF2xCir3CPMPEk6Wg0ExiA+e9YQPGaCbc3FJM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:09 +0200
Message-Id: <20090823133109.17784.11110.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/33] Staging: rt28x0: MlmeAssocReqAction() fixes for wpa_supplicant support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: MlmeAssocReqAction() fixes for wpa_supplicant support

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta/assoc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: b/drivers/staging/rt2860/sta/assoc.c
===================================================================
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -454,9 +454,7 @@ VOID MlmeAssocReqAction(
 				RSNIe = IE_WPA2;
 			}
 
-#ifdef RT30xx
 			if (pAd->StaCfg.WpaSupplicantUP != 1)
-#endif
             RTMPMakeRSNIE(pAd, pAd->StaCfg.AuthMode, pAd->StaCfg.WepStatus, BSS0);
 
             // Check for WPA PMK cache list
@@ -483,7 +481,6 @@ VOID MlmeAssocReqAction(
 				}
 			}
 
-#ifdef RT30xx
 			if (pAd->StaCfg.WpaSupplicantUP == 1)
 			{
 				MakeOutgoingFrame(pOutBuffer + FrameLen,    		&tmp,
@@ -491,7 +488,6 @@ VOID MlmeAssocReqAction(
 		                        	END_OF_ARGS);
 			}
 			else
-#endif
 			{
 				MakeOutgoingFrame(pOutBuffer + FrameLen,    		&tmp,
 				              		1,                              &RSNIe,
@@ -502,9 +498,7 @@ VOID MlmeAssocReqAction(
 
 			FrameLen += tmp;
 
-#ifdef RT30xx
 			if (pAd->StaCfg.WpaSupplicantUP != 1)
-#endif
 			{
 	            // Append Variable IE
 	            NdisMoveMemory(pAd->StaCfg.ReqVarIEs + VarIesOffset, &RSNIe, 1);

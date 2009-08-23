Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbZHWNav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbZHWNav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934022AbZHWNas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:48 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014AbZHWNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=iPKqmWca6wgU/mGHJP+tzNuRXyjtUmWPQiQvcihf53se0mxMdjnw/kpUlzefcDe4Xy
         v9kKMgJsdtsrz9TLPQsfDJSShogwii8SAOsJI/R5wfoOZLKRBcWxy3QZpIW0WTFOZbeP
         foN9uOpsaPvakKILoRJYdP5XvS+zJ7t9P+6iw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:15 +0200
Message-Id: <20090823133115.17784.35324.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 23/33] Staging: rt28x0: rt_ioctl_siwencode() fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: rt_ioctl_siwencode() fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1425,9 +1425,6 @@ int rt_ioctl_siwencode(struct net_device
         pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeOpen;
         goto done;
 	} else if (
-#ifndef RT30xx
-		 erq->length == 0 &&
-#endif
 		 (erq->flags & IW_ENCODE_RESTRICTED || erq->flags & IW_ENCODE_OPEN)) {
 		STA_PORT_SECURED(pAdapter);
 		pAdapter->StaCfg.PairCipher = Ndis802_11WEPEnabled;
@@ -1438,9 +1435,6 @@ int rt_ioctl_siwencode(struct net_device
 			pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeShared;
     	else
 			pAdapter->StaCfg.AuthMode = Ndis802_11AuthModeOpen;
-#ifndef RT30xx
-        goto done;
-#endif
 	}
 
     if (erq->length > 0)
@@ -1459,12 +1453,8 @@ int rt_ioctl_siwencode(struct net_device
             //Using default key
 			keyIdx = pAdapter->StaCfg.DefaultKeyId;
         }
-#ifdef RT30xx
 		else
-		{
 			pAdapter->StaCfg.DefaultKeyId=keyIdx;
-		}
-#endif
 
         NdisZeroMemory(pAdapter->SharedKey[BSS0][keyIdx].Key,  16);
 

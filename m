Return-Path: <linux-kernel-owner+w=401wt.eu-S933884AbZHWN27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884AbZHWN27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbZHWN26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933878AbZHWN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qPeO4aDFFGCTRxWxPtULd1vBxUcsnWnNTib37ktvnpaYKuxnFJ0+ffTWtxooGdafgl
         t20ABk83+1YsdT9Q/4Iy7ompXvnFdYicA/w81P2/yhG41vaffBVVQgpmVbiFpfeilnF0
         QtLOuSQxEEKQONjD+PxPgR7TNyhsahIJjaqsY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:26 +0200
Message-Id: <20090823132926.17784.7947.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/33] Staging: rt3070: fix PID checking in RTUSBEnqueueCmdFromNdis()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: fix PID checking in RTUSBEnqueueCmdFromNdis()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2870/common/rtusb_io.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -974,12 +974,7 @@ NDIS_STATUS	RTUSBEnqueueCmdFromNdis(
 	PCmdQElmt	cmdqelmt = NULL;
 	POS_COOKIE pObj = (POS_COOKIE) pAd->OS_Cookie;
 
-#ifndef RT30xx
 	if (pid_nr(pObj->RTUSBCmdThr_pid) > 0)
-#endif
-#ifdef RT30xx
-	if (pObj->RTUSBCmdThr_pid < 0)
-#endif
 		return (NDIS_STATUS_RESOURCES);
 
 	status = RTMPAllocateMemory((PVOID *)&cmdqelmt, sizeof(CmdQElmt));

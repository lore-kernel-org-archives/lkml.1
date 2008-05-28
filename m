Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYE1Vnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYE1Vnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYE1Vm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49842 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYE1Vm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VJAcYtjYNqRtnCluDVnxLOtzGL26bcLoeAz4EUaL3QWy/vhkumAMF4tnS/eyzvMpb6qtk9dfsUUhypQAasYWSJ7pGvrK9lugsvqQ6Z9MX+Gr7O+acJjxqOP3JQqx2lQ66ZGe2qKICh9fPcfW4PHmvC91t0nckKSbpm9NaKrz3Io=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:02 +0200
Message-Id: <20080528214002.16327.28489.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/21] ide: remove unused XFER_UDMA_SLOW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused XFER_UDMA_SLOW from ide_timing[].

While at it:

- fix re-defining XFER_PIO_5 (no need to define it in ide-timing.h as
  it is defined in <linux/ata.h> which is included by <linux/hdreg.h>)

- fix whitespace damage

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timing.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -28,9 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/hdreg.h>
 
-#define XFER_PIO_5		0x0d
-#define XFER_UDMA_SLOW		0x4f
-
 struct ide_timing {
 	short mode;
 	short setup;	/* t1 */
@@ -61,12 +58,10 @@ static struct ide_timing ide_timing[] = 
 	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
 	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
 
-	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0,   0, 150 },
-                                          
 	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
 	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
 	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-                                          
+
 	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
 	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
 	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096Ab0A2QTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0A2QTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367Ab0A2QS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:18:58 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0A2QF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eTc7BuSX/TCXZryZX5tIigdqK7BjmKOJ7pHOFgr1IBAbSrF3DPITeuYuPvhIOIXRZw
         GuI/pjUUNq3aKb3nC9S82SrxjAbd+dud2D9RjLBT408d/aSyTJuR0jSLetjIpwaGaKKp
         4pUH+FFPvpsO61nS0Ka2IgGuS+U8CTWcxE784=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:19 +0100
Message-Id: <20100129160519.21495.68671.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 20/68] ide: add hwif->udma_mask field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add hwif->udma_mask field

Add udma_mask field to ide_hwif_t to match udma_mask field used in
struct ata_port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -693,7 +693,10 @@ typedef struct hwif_s {
 
 	u8 pio_mask;
 
-	u8 ultra_mask;
+	union {
+		u8 ultra_mask;
+		u8 udma_mask;
+	};
 	u8 mwdma_mask;
 	u8 swdma_mask;
 

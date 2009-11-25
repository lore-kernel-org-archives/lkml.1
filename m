Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZKYRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZKYRKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbZKYRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:10:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:28343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbZKYRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QhNdkZY0NBae4cEMIaooVhdaeg+XeRGufPnF0gMT26ql0wrk4KtftDG83A8CyDusTh
         lClqKaMs30k5GEiJMfV17jf3aSult8PphidiAedrpCN6fYSoBNhde+uLGpG7bEg20Vez
         CA0KM3e/h9yIAtOdOWk5PIwhur43CS+2r07pQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:55 +0100
Message-Id: <20091125170955.5446.92093.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 63/86] pata_radisys: fix UDMA handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_radisys: fix UDMA handling

Set correct bits to switch between UDMA2 and UDMA4.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_radisys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_radisys.c
===================================================================
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -139,9 +139,9 @@ static void radisys_set_dmamode (struct 
 		pci_read_config_byte(dev, 0x4A, &udma_mode);
 
 		if (adev->xfer_mode == XFER_UDMA_2)
-			udma_mode &= ~ (1 << adev->devno);
+			udma_mode &= ~(2 << (adev->devno * 4));
 		else /* UDMA 4 */
-			udma_mode |= (1 << adev->devno);
+			udma_mode |= (2 << (adev->devno * 4));
 
 		pci_write_config_byte(dev, 0x4A, udma_mode);
 

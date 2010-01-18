Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413Ab0ARRQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0ARRQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386Ab0ARRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:54649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0ARRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qrZg3iuFbBkemedln5Qd93+WK6cLnYMbbVEWtiwfZzupPXXTxYq9MNPn1E+1SxowBu
         AAHVuRRjk82OgXCPzKoTrNSsM7HOwE3ZJcw+GWSS/u1BPZN0I/AzCUgjDJdNo9CVHW3T
         CUpWocI4lsguzIZ/Y6uuS0FgUdzYnJy9p0YWw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:04 +0100
Message-Id: <20100118171504.14623.11688.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 09/64] pata_cmd64x: fix handling of address setup timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: fix handling of address setup timings

Account for the requirements of the DMA mode currently used
by the pair device.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -165,8 +165,14 @@ static void cmd64x_set_timing(struct ata
 
 		if (pair) {
 			struct ata_timing tp;
+
 			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
 			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
+			if (pair->dma_mode) {
+				ata_timing_compute(pair, pair->dma_mode,
+						&tp, T, 0);
+				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
+			}
 		}
 	}
 

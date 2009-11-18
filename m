Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbZKRSc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbZKRSc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932397AbZKRSc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:32:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:37566 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbZKRSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=g1z8irGDSSgu0GLe1niXOBGdbSmBQqv0qm5yvkNfZ+JiMK3EdROZAHJSUEtPwYh6TK
         O4QsIfg9rvtMHj7fRFHn+qceDsyMv++GQBqkF4J04deUI6HWfo4S4ax/NgYT8KkBAxpY
         a2ROPoQthzkAD3cXWvPHL93pcnDb1B667+Nfg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] hpt366: remove dead old timing tables
Date: Wed, 18 Nov 2009 19:32:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181932.07651.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been enough time since introduction of the new timing tables
(commit 809b53c from Dec 12 2007) and the old timing tables are still
available in pata_hpt37x.c (or git history) if somebody needs them.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/hpt366.c |   63 ---------------------------------------------------
 1 file changed, 63 deletions(-)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -297,68 +297,6 @@ static u32 twenty_five_base_hpt36x[] = {
 	/* XFER_PIO_0 */	0xc0d08585
 };
 
-#if 0
-/* These are the timing tables from the HighPoint open source drivers... */
-static u32 thirty_three_base_hpt37x[] = {
-	/* XFER_UDMA_6 */	0x12446231,	/* 0x12646231 ?? */
-	/* XFER_UDMA_5 */	0x12446231,
-	/* XFER_UDMA_4 */	0x12446231,
-	/* XFER_UDMA_3 */	0x126c6231,
-	/* XFER_UDMA_2 */	0x12486231,
-	/* XFER_UDMA_1 */	0x124c6233,
-	/* XFER_UDMA_0 */	0x12506297,
-
-	/* XFER_MW_DMA_2 */	0x22406c31,
-	/* XFER_MW_DMA_1 */	0x22406c33,
-	/* XFER_MW_DMA_0 */	0x22406c97,
-
-	/* XFER_PIO_4 */	0x06414e31,
-	/* XFER_PIO_3 */	0x06414e42,
-	/* XFER_PIO_2 */	0x06414e53,
-	/* XFER_PIO_1 */	0x06814e93,
-	/* XFER_PIO_0 */	0x06814ea7
-};
-
-static u32 fifty_base_hpt37x[] = {
-	/* XFER_UDMA_6 */	0x12848242,
-	/* XFER_UDMA_5 */	0x12848242,
-	/* XFER_UDMA_4 */	0x12ac8242,
-	/* XFER_UDMA_3 */	0x128c8242,
-	/* XFER_UDMA_2 */	0x120c8242,
-	/* XFER_UDMA_1 */	0x12148254,
-	/* XFER_UDMA_0 */	0x121882ea,
-
-	/* XFER_MW_DMA_2 */	0x22808242,
-	/* XFER_MW_DMA_1 */	0x22808254,
-	/* XFER_MW_DMA_0 */	0x228082ea,
-
-	/* XFER_PIO_4 */	0x0a81f442,
-	/* XFER_PIO_3 */	0x0a81f443,
-	/* XFER_PIO_2 */	0x0a81f454,
-	/* XFER_PIO_1 */	0x0ac1f465,
-	/* XFER_PIO_0 */	0x0ac1f48a
-};
-
-static u32 sixty_six_base_hpt37x[] = {
-	/* XFER_UDMA_6 */	0x1c869c62,
-	/* XFER_UDMA_5 */	0x1cae9c62,	/* 0x1c8a9c62 */
-	/* XFER_UDMA_4 */	0x1c8a9c62,
-	/* XFER_UDMA_3 */	0x1c8e9c62,
-	/* XFER_UDMA_2 */	0x1c929c62,
-	/* XFER_UDMA_1 */	0x1c9a9c62,
-	/* XFER_UDMA_0 */	0x1c829c62,
-
-	/* XFER_MW_DMA_2 */	0x2c829c62,
-	/* XFER_MW_DMA_1 */	0x2c829c66,
-	/* XFER_MW_DMA_0 */	0x2c829d2e,
-
-	/* XFER_PIO_4 */	0x0c829c62,
-	/* XFER_PIO_3 */	0x0c829c84,
-	/* XFER_PIO_2 */	0x0c829ca6,
-	/* XFER_PIO_1 */	0x0d029d26,
-	/* XFER_PIO_0 */	0x0d029d5e
-};
-#else
 /*
  * The following are the new timing tables with PIO mode data/taskfile transfer
  * overclocking fixed...
@@ -424,7 +362,6 @@ static u32 sixty_six_base_hpt37x[] = {
 	/* XFER_PIO_1 */	0x0d02ff26,
 	/* XFER_PIO_0 */	0x0d42ff7f
 };
-#endif
 
 #define HPT366_DEBUG_DRIVE_INFO		0
 #define HPT371_ALLOW_ATA133_6		1

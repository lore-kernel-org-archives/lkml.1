Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYEGR3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYEGR3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYEGR3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:29:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:24579 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbYEGR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gv8/hIkUq+f4VNOzBXbGgVSVXuf8qNLQdvCFC7+j5PlMXUleX4o8m5oCWf+Hy4MqoLJWpKOI9VVnav0f1bSNHHGHyqTDPoNquvtFh6/Q5P9T0dK0PK7OoKBzosxnqAq3ZU0hJkQkUbviH9XXC/FY0G02Xs9qbQJkDTUev9q5xME=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/6] sgiioc4: use ->extra_base instead of ->dma_status for dma_handle
Date: Wed, 7 May 2008 19:39:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071939.41558.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for removal of ->dma_status field from ide_hwif_t.

There should be no functional changes caused by this patch.

Cc: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -369,8 +369,7 @@ ide_dma_sgiioc4(ide_hwif_t *hwif, const 
 	hwif->sg_max_nents = IOC4_PRD_ENTRIES;
 
 	pad = pci_alloc_consistent(dev, IOC4_IDE_CACHELINE_SIZE,
-				   (dma_addr_t *) &(hwif->dma_status));
-
+				   (dma_addr_t *)&hwif->extra_base);
 	if (pad) {
 		ide_set_hwifdata(hwif, pad);
 		return 0;
@@ -439,7 +438,7 @@ sgiioc4_configure_for_dma(int dma_direct
 
 	/* Address of the Ending DMA */
 	memset(ide_get_hwifdata(hwif), 0, IOC4_IDE_CACHELINE_SIZE);
-	ending_dma_addr = cpu_to_le32(hwif->dma_status);
+	ending_dma_addr = cpu_to_le32(hwif->extra_base);
 	writel(ending_dma_addr, (void __iomem *)(dma_base + IOC4_DMA_END_ADDR * 4));
 
 	writel(dma_direction, (void __iomem *)ioc4_dma_addr);

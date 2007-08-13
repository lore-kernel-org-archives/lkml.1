Return-Path: <linux-kernel-owner+w=401wt.eu-S1031489AbXHMNfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031489AbXHMNfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943743AbXHMJrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:47:16 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:41268 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943735AbXHMJrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:47:14 -0400
Subject: [KJ] replacing kmalloc with kzalloc in
	drivers/mtd/chips/cfi_probe.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:16:47 +0530
Message-Id: <1186998407.29518.2.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 09:47:25.0684 (UTC) FILETIME=[F4489340:01C7DD8E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in 
arch/i386/kernel/io_apic.c


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
---

diff --git a/drivers/mtd/chips/cfi_probe.c b/drivers/mtd/chips/cfi_probe.c
index 60e11a0..efb51f7 100644
--- a/drivers/mtd/chips/cfi_probe.c
+++ b/drivers/mtd/chips/cfi_probe.c
@@ -203,14 +203,12 @@ static int __xipram cfi_chip_setup(struct map_info *map,
 	if (!num_erase_regions)
 		return 0;
 
-	cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
+	cfi->cfiq = kzalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
 	if (!cfi->cfiq) {
 		printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
 		return 0;
 	}
 
-	memset(cfi->cfiq,0,sizeof(struct cfi_ident));
-
 	cfi->cfi_mode = CFI_MODE_CFI;
 
 	/* Read the CFI info structure */

--
thanks 
surya.

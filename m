Return-Path: <linux-kernel-owner+w=401wt.eu-S1031289AbXHMNhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031289AbXHMNhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030392AbXHMJxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:53:13 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:42124 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385AbXHMJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:53:10 -0400
Subject: [KJ] replacing kmalloc with kzalloc in
	drivers/mtd/chips/jedec_probe.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:22:44 +0530
Message-Id: <1186998764.29518.11.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 09:53:21.0918 (UTC) FILETIME=[C89D91E0:01C7DD8F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in
drivers/mtd/chips/jedec_probe.c.


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
---

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 58e561e..ba5fc39 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1853,14 +1853,12 @@ static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
 
 	num_erase_regions = jedec_table[index].NumEraseRegions;
 
-	p_cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
+	p_cfi->cfiq = kzalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
 	if (!p_cfi->cfiq) {
 		//xx printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
 		return 0;
 	}
 
-	memset(p_cfi->cfiq,0,sizeof(struct cfi_ident));
-
 	p_cfi->cfiq->P_ID = jedec_table[index].CmdSet;
 	p_cfi->cfiq->NumEraseRegions = jedec_table[index].NumEraseRegions;
 	p_cfi->cfiq->DevSize = jedec_table[index].DevSize;

--
thanks
surya.

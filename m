Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbZBKV1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbZBKV1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbZBKV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:26:49 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43397 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbZBKV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:48 -0500
Date: Wed, 11 Feb 2009 13:14:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 1/9] staging/altera: fix printk format warnings
Message-Id: <20090211131417.2cb62328.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49934291.016E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in altera pcie chdma:

drivers/staging/altpciechdma/altpciechdma.c:429: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:433: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:449: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:450: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/altpciechdma/altpciechdma.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/altpciechdma/altpciechdma.c
+++ mmotm-2009-0210-1635/drivers/staging/altpciechdma/altpciechdma.c
@@ -426,11 +426,13 @@ static int ape_sg_to_chdma_table(struct 
 		dma_addr_t next = sg_dma_address(&sgl[i + 1]);
 		/* length of this entry i */
 		len = sg_dma_len(&sgl[i]);
-		printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n", i, addr, len);
+		printk(KERN_DEBUG "%04d: addr=0x%Lx length=0x%08x\n", i,
+			(unsigned long long)addr, len);
 		/* entry i + 1 is non-contiguous with entry i? */
 		if (next != addr + len) {
 			/* TODO create entry here (we could overwrite i) */
-			printk(KERN_DEBUG "%4d: cont_addr=0x%08x cont_len=0x%08x\n", j, cont_addr, cont_len);
+			printk(KERN_DEBUG "%4d: cont_addr=0x%Lx cont_len=0x%08x\n", j,
+				(unsigned long long)cont_addr, cont_len);
 			/* set descriptor for contiguous transfer */
 			ape_chdma_desc_set(&desc[j], cont_addr, ep_addr, cont_len);
 			/* next end point memory address */
@@ -446,8 +448,10 @@ static int ape_sg_to_chdma_table(struct 
 		addr = next;
 	}
 	/* TODO create entry here  (we could overwrite i) */
-	printk(KERN_DEBUG "%04d: addr=0x%08x length=0x%08x\n", i, addr, len);
-	printk(KERN_DEBUG "%4d: cont_addr=0x%08x length=0x%08x\n", j, cont_addr, cont_len);
+	printk(KERN_DEBUG "%04d: addr=0x%Lx length=0x%08x\n", i,
+		(unsigned long long)addr, len);
+	printk(KERN_DEBUG "%4d: cont_addr=0x%Lx length=0x%08x\n", j,
+		(unsigned long long)cont_addr, cont_len);
 	j++;
 	return j;
 }

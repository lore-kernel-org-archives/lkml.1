Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZBLU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZBLU3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbZBLU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:28:38 -0500
Received: from kroah.org ([198.145.64.141]:58942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759060AbZBLU2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:28:36 -0500
Subject: patch staging-altera-fix-printk-format-warnings.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 12 Feb 2009 12:24:20 -0800
In-Reply-To: <20090211131417.2cb62328.randy.dunlap@oracle.com>
Message-ID: <12344702601449@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: altera: fix printk format warnings

to my gregkh-2.6 tree.  Its filename is

    staging-altera-fix-printk-format-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Thu Feb 12 11:52:06 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 11 Feb 2009 13:14:17 -0800
Subject: Staging: altera: fix printk format warnings
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Message-ID: <20090211131417.2cb62328.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in altera pcie chdma:

drivers/staging/altpciechdma/altpciechdma.c:429: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:433: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:449: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'
drivers/staging/altpciechdma/altpciechdma.c:450: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/altpciechdma/altpciechdma.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
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


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

pending/firmware-add-kconfig-and-makefile-to-build-the-firmware-samples.patch
staging/staging-dst-kconfig-update.patch
staging/staging-dst-fix-build-dependancy.patch
staging/staging-rt2860-fix-printk-format-warnings.patch
staging/staging-rtl8187se-fix-kconfig-dependencies.patch
staging/staging-rtl8187se-fix-printk-format-warnings.patch
staging/staging-stlc45xx-fix-printk-format-warnings.patch
staging/staging-otus-fix-mixed-declarations.patch
staging/staging-android-ram_console-fix-printk-format-warning.patch
staging/staging-android-binder-fix-printk-format-warnings.patch
staging/staging-altera-fix-printk-format-warnings.patch

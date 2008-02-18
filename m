Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYBROCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYBROCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYBROCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:02:09 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51682 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYBROCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:02:06 -0500
Date: Mon, 18 Feb 2008 19:31:59 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au,
       apw@shadowen.org
Subject: [PATCH] next-20080218 build failure at pmac_ide_macio_attach ()
Message-ID: <20080218140159.GA31310@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The next-20080218 kernel build fails on the powerpc(s)

drivers/ide/ppc/pmac.c: In function ‘pmac_ide_macio_attach’:
drivers/ide/ppc/pmac.c:1094: error: conversion to non-scalar type requested
drivers/ide/ppc/pmac.c: In function ‘pmac_ide_pci_attach’:
drivers/ide/ppc/pmac.c:1232: error: conversion to non-scalar type requested
make[3]: *** [drivers/ide/ppc/pmac.o] Error 1
make[2]: *** [drivers/ide/ppc] Error 2
make[1]: *** [drivers/ide] Error 2
make: *** [drivers] Error 2

I Have tested this patch for build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
--- linux-2.6.25-rc1/drivers/ide/ppc/pmac.c	2008-02-18 18:41:48.000000000 +0530
+++ linux-2.6.25-rc1/drivers/ide/ppc/~pmac.c	2008-02-18 19:20:37.000000000 +0530
@@ -1091,7 +1091,7 @@ pmac_ide_macio_attach(struct macio_dev *
 	int irq, rc;
 	hw_regs_t hw;
 
-	pmif = (struct pmac_ide_hwif)kzalloc(sizeof(*pmif), GFP_KERNEL);
+	pmif = (struct pmac_ide_hwif*)kzalloc(sizeof(*pmif), GFP_KERNEL);
 	if (pmif == NULL)
 		return -ENOMEM;
 
@@ -1229,7 +1229,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev
 		return -ENODEV;
 	}
 
-	pmif = (struct pmac_ide_hwif)kzalloc(sizeof(*pmif), GFP_KERNEL);
+	pmif = (struct pmac_ide_hwif*)kzalloc(sizeof(*pmif), GFP_KERNEL);
 	if (pmif == NULL)
 		return -ENOMEM;
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

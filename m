Return-Path: <linux-kernel-owner+w=401wt.eu-S1761850AbXF2JIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761850AbXF2JIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXF2JIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:08:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:9757 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbXF2JIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cGV2QTGFQdcWhSJ2IHFIqPkg4UYP7g5CmAUBq+TPSctd/SSa05d4uVVgszQI3XPydMQdZvUcYCrYo8jNkPA45YzBCQcDopBFColXb7Vr2hlNw9v1HsPP6vCNRT0gKALkEueqR/t1XV2NcBFwzqazNaA0x5pHikR4UiClsd/xfHM=
Date: Fri, 29 Jun 2007 17:09:07 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ioremap: fix iounmap numpages
Message-ID: <20070629170907.GA1735@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The second parameter of change_page_attr in iounmap is wrong, it should be (p->size - 1) >> PAGE_SHIFT

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---

diff -upr linux/arch/i386/mm/ioremap.c linux.new/arch/i386/mm/ioremap.c
--- linux/arch/i386/mm/ioremap.c	2007-06-29 16:48:40.000000000 +0000
+++ linux.new/arch/i386/mm/ioremap.c	2007-06-29 16:50:09.000000000 +0000
@@ -196,7 +196,7 @@ void iounmap(volatile void __iomem *addr
 	/* Reset the direct mapping. Can block */
 	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
 		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 p->size >> PAGE_SHIFT,
+				 (p->size - 1) >> PAGE_SHIFT,
 				 PAGE_KERNEL);
 		global_flush_tlb();
 	} 

Regards
dave

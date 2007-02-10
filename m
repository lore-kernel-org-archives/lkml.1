Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbXBJLrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbXBJLrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXBJLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:47:00 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:16712 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXBJLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:46:58 -0500
Date: Sat, 10 Feb 2007 12:45:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

9ac7849e35f705830f7b016ff272b0ff1f7ff759 causes this:

  CC      arch/s390/mm/ioremap.o
In file included from arch/s390/mm/ioremap.c:18:
include/linux/io.h:46:
	warning: "struct pci_dev" declared inside parameter list
include/linux/io.h:46:
	warning: its scope is only this definition or declaration,
		 which is probably not what you want

Guess it's time to get rid of ioremap.c on s390 if possible...

Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/io.h |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6/include/linux/io.h
===================================================================
--- linux-2.6.orig/include/linux/io.h
+++ linux-2.6/include/linux/io.h
@@ -22,6 +22,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 
+struct pci_dev;
 struct device;
 
 void __iowrite32_copy(void __iomem *to, const void *from, size_t count);

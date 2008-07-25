Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYGYCVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYGYCVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGYCUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:20:53 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:50284 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYGYCUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:20:52 -0400
Date: Fri, 25 Jul 2008 04:20:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Let HP iLO driver depend on PCI
Message-ID: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Let HP iLO driver depend on PCI

From: Heiko Carstens <heiko.carstens@de.ibm.com>

"HP iLO driver" causes this on s390:

drivers/misc/hpilo.c: In function 'doorbell_set':
drivers/misc/hpilo.c:147: error: implicit declaration of function 'iowrite8'
drivers/misc/hpilo.c: In function 'ilo_ccb_close':
drivers/misc/hpilo.c:204: error: implicit declaration of function 'iowrite32'
drivers/misc/hpilo.c:204: error: implicit declaration of function 'ioread32'
drivers/misc/hpilo.c:222: error: implicit declaration of function 'memset_io'
drivers/misc/hpilo.c:225: error: implicit declaration of function 'pci_free_consistent'
drivers/misc/hpilo.c: In function 'ilo_ccb_open':
drivers/misc/hpilo.c:244: error: implicit declaration of function 'pci_alloc_consistent'
drivers/misc/hpilo.c:245: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:296: error: implicit declaration of function 'memcpy_toio'
drivers/misc/hpilo.c: In function 'ilo_unmap_device':
drivers/misc/hpilo.c:575: error: implicit declaration of function 'pci_iounmap'
drivers/misc/hpilo.c: In function 'ilo_map_device':
drivers/misc/hpilo.c:585: error: implicit declaration of function 'pci_iomap'
drivers/misc/hpilo.c:585: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:592: warning: assignment makes pointer from integer without a cast
drivers/misc/hpilo.c:599: warning: assignment makes pointer from integer without a cast
make[2]: *** [drivers/misc/hpilo.o] Error 1

Just let it depend on PCI.

Cc: David Altobelli <david.altobelli@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Sent already two weeks ago to Greg because it caused the same
build bug on linux-next.

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/misc/Kconfig
===================================================================
--- linux-2.6.orig/drivers/misc/Kconfig
+++ linux-2.6/drivers/misc/Kconfig
@@ -425,6 +425,7 @@ config SGI_XP
 config HP_ILO
 	tristate "Channel interface driver for HP iLO/iLO2 processor"
 	default n
+	depends on PCI
 	help
 	  The channel interface driver allows applications to communicate
 	  with iLO/iLO2 management processors present on HP ProLiant

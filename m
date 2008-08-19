Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYHSNsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYHSNsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbYHSNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:47:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60793 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbYHSNr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:47:28 -0400
Date: Tue, 19 Aug 2008 16:47:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: gerg@uclinux.org, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [2.6 patch] m68knommu: let PCI depend on BROKEN
Message-ID: <20080819134718.GH8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists blackfin hardware with PCI support, but the support
currently in the kernel fails to build starting with:

<--  snip  -->

...
  CC      init/main.o
In file included from dma-mapping.h:5,
                 from dma-mapping.h:52,
                 from dmaengine.h:29,
                 from skbuff.h:29,
                 from netlink.h:155,
                 from genetlink.h:4,
                 from genetlink.h:4,
                 from taskstats_kern.h:12,
                 from main.c:46:
dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: 
error: implicit declaration of function 'pci_dma_supported'
...
make[2]: *** [init/main.o] Error 1


<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3bdc07c86b6fd5fc18b7676a75c3ff907e00e807 
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 2e7515e..77a5bdf 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -702,6 +702,7 @@ menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
 
 config PCI
 	bool "PCI support"
+	depends on BROKEN
 	help
 	  Support for PCI bus.
 


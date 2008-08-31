Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYHaQM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYHaQM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbYHaQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:11:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54817 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbYHaQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:11:42 -0400
Date: Sun, 31 Aug 2008 19:10:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [2.6 patch] m68knommu: remove the unused PCI option
Message-ID: <20080831161029.GG3695@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com> <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B77764.6060607@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 02:13:24PM +1000, Greg Ungerer wrote:
> Hi Adrian,

Hi Greg,

> Adrian Bunk wrote:
>...
>> But COMEMPCI fails with a different error - this init/main.o build 
>> error is present for CONFIG_PCI=y, CONFIG_COMEMPCI=n, so the dependency 
>> of PCI on BROKEN is still required (unless it gets fixed).
>
> Unless I am mistaken there is now no need for the CONFIG_PCI option
> if selecting m68knommu. The only m68knommu platforms that had PCI
> as far as I know where those that use the comempci part.
>...

Patch to remove the few PCI bits (on top of the comempci removal) is 
below.

> Regards
> Greg

cu
Adrian


<--  snip  -->


This patch removes the no longer used PCI option.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68knommu/Kconfig                   |   13 -------------
 arch/m68knommu/include/asm/dma-mapping.h |    4 ----
 2 files changed, 17 deletions(-)


diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index f43d50f..46b9c43 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -692,21 +692,8 @@ config ISA_DMA_API
 	depends on !M5272
 	default y
 
-menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
-
-config PCI
-	bool "PCI support"
-	help
-	  Support for PCI bus.
-
-source "drivers/pci/Kconfig"
-
 source "drivers/pcmcia/Kconfig"
 
-source "drivers/pci/hotplug/Kconfig"
-
-endmenu
-
 menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
diff --git a/arch/m68knommu/include/asm/dma-mapping.h b/arch/m68knommu/include/asm/dma-mapping.h
index 6aeab18..1748f2b 100644
--- a/arch/m68knommu/include/asm/dma-mapping.h
+++ b/arch/m68knommu/include/asm/dma-mapping.h
@@ -1,10 +1,6 @@
 #ifndef _M68KNOMMU_DMA_MAPPING_H
 #define _M68KNOMMU_DMA_MAPPING_H
 
-#ifdef CONFIG_PCI
-#include <asm-generic/dma-mapping.h>
-#else
 #include <asm-generic/dma-mapping-broken.h>
-#endif
 
 #endif  /* _M68KNOMMU_DMA_MAPPING_H */


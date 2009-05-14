Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZENSp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZENSp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZENSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:45:50 -0400
Received: from gw.goop.org ([64.81.55.164]:52270 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZENSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:45:49 -0400
Message-ID: <4A0C66DB.9020707@goop.org>
Date: Thu, 14 May 2009 11:45:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>	<1242164891-3859-7-git-send-email-jeremy@goop.org>	<20090513095535.140134e1@jbarnes-g45>	<4A0AFE84.2040805@goop.org> <20090513102316.5ef3ce4e@jbarnes-g45>
In-Reply-To: <20090513102316.5ef3ce4e@jbarnes-g45>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Anyway it's not a big deal, this code is already ugly (a 0 define for
> all arches?  why?) so you shouldn't have to spend too much time
> cleaning it up.
>   

OK, how's this as a delta (I can fold it into the previous patch if 
you're OK with it):

Subject: [PATCH] pci: add HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS

Jesse objected to the "#undef pcibios_scan_all_fns"'s ugliness,
so replace it with the more common HAVE_ARCH_ idiom.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 092706e..cabea93 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -134,8 +134,8 @@ extern void pci_iommu_alloc(void);
 #include <asm-generic/pci-dma-compat.h>
 
 /* generic pci stuff */
+#define HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
 #include <asm-generic/pci.h>
-#undef pcibios_scan_all_fns
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index c36a77d..9ad9cb7 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -43,7 +43,9 @@ pcibios_select_root(struct pci_dev *pdev, struct resource *res)
 	return root;
 }
 
+#ifndef HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
 #define pcibios_scan_all_fns(a, b)	0
+#endif
 
 #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)



Thanks,
    J

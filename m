Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZGQUUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZGQUUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZGQUUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:20:03 -0400
Received: from kroah.org ([198.145.64.141]:43134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbZGQUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:36 2009
Message-Id: <20090717201236.713006028@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 20/24] Fix pci_unmap_addr() et al on i386.
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=fix-pci_unmap_addr-et-al-on-i386.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 788d84bba47ea3eb377f7a3ae4fd1ee84b84877b upstream.

We can run a 32-bit kernel on boxes with an IOMMU, so we need
pci_unmap_addr() etc. to work -- without it, drivers will leak mappings.

To be honest, this whole thing looks like it's more pain than it's
worth; I'm half inclined to remove the no-op #else case altogether.

But this is the minimal fix, which just does the right thing if
CONFIG_DMAR is set.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/pci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -91,7 +91,7 @@ extern void pci_iommu_alloc(void);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_DMA_API_DEBUG)
+#if defined(CONFIG_X86_64) || defined(CONFIG_DMAR) || defined(CONFIG_DMA_API_DEBUG)
 
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
 	        dma_addr_t ADDR_NAME;



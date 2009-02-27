Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZB0Jis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZB0Jis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZB0Jij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:38:39 -0500
Received: from relay3.sgi.com ([192.48.171.31]:52195 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753799AbZB0Jii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:38:38 -0500
Date: Fri, 27 Feb 2009 01:38:35 -0800
From: Jeremy Higdon <jeremy@sgi.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jesse.barnes@intel.com, habeck@sgi.com
Subject: [PATCH 1/1] Fix PCI DMA flag propagation on SN (Altix) with PICs
Message-ID: <20090227093835.GA306198@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently discovered a problem with passing of DMA attributes on
SN systems with the older PIC chips.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

--- a/arch/ia64/sn/pci/pcibr/pcibr_dma.c	2009-02-25 23:29:21.000000000 -0800
+++ b/arch/ia64/sn/pci/pcibr/pcibr_dma.c	2009-02-25 23:29:09.318611870 -0800
@@ -135,11 +135,10 @@ pcibr_dmatrans_direct64(struct pcidev_in
 	if (SN_DMA_ADDRTYPE(dma_flags) == SN_DMA_ADDR_PHYS)
 		pci_addr = IS_PIC_SOFT(pcibus_info) ?
 				PHYS_TO_DMA(paddr) :
-		    		PHYS_TO_TIODMA(paddr) | dma_attributes;
+		    		PHYS_TO_TIODMA(paddr);
 	else
-		pci_addr = IS_PIC_SOFT(pcibus_info) ?
-				paddr :
-				paddr | dma_attributes;
+		pci_addr = paddr;
+	pci_addr |= dma_attributes;
 
 	/* Handle Bus mode */
 	if (IS_PCIX(pcibus_info))

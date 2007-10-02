Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbXJBMbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbXJBMbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXJBMbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:31:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48864 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbXJBMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:31:40 -0400
Date: Tue, 2 Oct 2007 06:31:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Make DMA-mapping more coherent
Message-ID: <20071002123138.GR12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A couple of updates haven't considered whether the documentation makes
sense as a whole any more.  Three changes here:

 - Remove the reference to the "DAC Addressing for Address Space Hungry
   Devices" section which was deleted by Jan Beulich.
 - Remove the comment about DMA_24BIT_MASK which became obsolete when
   Tobias Klauser changed the code to actually use DMA_24BIT_MASK.
 - Remove the section "64-bit DMA and DAC cycle support" since it's
   fully covered above, and contains a reference to the section deleted
   by Jan.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/Documentation/DMA-mapping.txt b/Documentation/DMA-mapping.txt
index e07f253..a7d944d 100644
--- a/Documentation/DMA-mapping.txt
+++ b/Documentation/DMA-mapping.txt
@@ -189,12 +189,6 @@ smaller mask as pci_set_dma_mask(). However for the rare case that a
 device driver only uses consistent allocations, one would have to
 check the return value from pci_set_consistent_dma_mask().
 
-If your 64-bit device is going to be an enormous consumer of DMA
-mappings, this can be problematic since the DMA mappings are a
-finite resource on many platforms.  Please see the "DAC Addressing
-for Address Space Hungry Devices" section near the end of this
-document for how to handle this case.
-
 Finally, if your device can only drive the low 24-bits of
 address during PCI bus mastering you might do something like:
 
@@ -203,8 +197,6 @@ address during PCI bus mastering you might do something like:
 		       "mydev: 24-bit DMA addressing not available.\n");
 		goto ignore_this_device;
 	}
-[Better use DMA_24BIT_MASK instead of 0x00ffffff.
-See linux/include/dma-mapping.h for reference.]
 
 When pci_set_dma_mask() is successful, and returns zero, the PCI layer
 saves away this mask you have provided.  The PCI layer will use this
@@ -652,18 +644,6 @@ It is planned to completely remove virt_to_bus() and bus_to_virt() as
 they are entirely deprecated.  Some ports already do not provide these
 as it is impossible to correctly support them.
 
-		64-bit DMA and DAC cycle support
-
-Do you understand all of the text above?  Great, then you already
-know how to use 64-bit DMA addressing under Linux.  Simply make
-the appropriate pci_set_dma_mask() calls based upon your cards
-capabilities, then use the mapping APIs above.
-
-It is that simple.
-
-Well, not for some odd devices.  See the next section for information
-about that.
-
 		Optimizing Unmap State Space Consumption
 
 On many platforms, pci_unmap_{single,page}() is simply a nop.
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

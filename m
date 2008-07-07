Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYGGIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYGGIRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYGGIR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:17:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:34624 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYGGIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:17:26 -0400
Date: Mon, 7 Jul 2008 17:17:11 +0900
To: mingo@elte.hu
Cc: mgross@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: move the descriptions of VT-d to
 Documentations/x86/x86_64/boot-options.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080707171707V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentations/x86/x86_64/boot-options.txt is the more appropriate
place for the descriptions of the VT-d IOMMU kernel parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/kernel-parameters.txt       |   22 ----------------------
 Documentation/x86/x86_64/boot-options.txt |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cd98762..a96f6f7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -874,28 +874,6 @@ and is between 256 and 4096 characters. It is defined in the file
 		forcesac
 		soft
 
-
-	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
-		off
-			Disable intel iommu driver.
-		igfx_off [Default Off]
-			By default, gfx is mapped as normal device. If a gfx
-			device has a dedicated DMAR unit, the DMAR unit is
-			bypassed by not enabling DMAR with this option. In
-			this case, gfx device will use physical address for
-			DMA.
-		forcedac [x86_64]
-			With this option iommu will not optimize to look
-			for io virtual address below 32 bit forcing dual
-			address cycle on pci bus for cards supporting greater
-			than 32 bit addressing. The default is to look
-			for translation below 32 bit and if not available
-			then look in the higher range.
-		strict [Default Off]
-			With this option on every unmap_single operation will
-			result in a hardware IOTLB flush operation as opposed
-			to batching them for performance.
-
 	io_delay=	[X86-32,X86-64] I/O delay method
 		0x80
 			Standard port 0x80 based delay
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index b0c7b6c..46cef05 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -216,6 +216,10 @@ IOMMU (input/output memory management unit)
       mapping with memory protection, etc.
       Kernel boot message: "PCI-DMA: Using Calgary IOMMU"
 
+   5. <drivers/pci/intel-iommu.c> : Intel VT-d hardware IOMMU.
+      Kernel boot message: "PCI-DMA: Intel(R) Virtualization Technology for
+      Directed I/O\n"
+
  iommu=[<size>][,noagp][,off][,force][,noforce][,leak[=<nr_of_leak_pages>]
 	[,memaper[=<order>]][,merge][,forcesac][,fullflush][,nomerge]
 	[,noaperture][,calgary]
@@ -287,6 +291,23 @@ IOMMU (input/output memory management unit)
     space might stop working. Use this option if you have devices that
     are accessed from userspace directly on some PCI host bridge.
 
+  iommu options only relevant to the Intel VT-d hardware IOMMU:
+    off                Disable intel iommu driver.
+    igfx_off           By default, gfx is mapped as normal device. If a gfx
+                       device has a dedicated DMAR unit, the DMAR unit is
+                       bypassed by not enabling DMAR with this option. In
+                       this case, gfx device will use physical address for
+                       DMA (Default Off).
+    forcedac           With this option iommu will not optimize to look
+                       for io virtual address below 32 bit forcing dual
+                       address cycle on pci bus for cards supporting greater
+                       than 32 bit addressing. The default is to look
+                       for translation below 32 bit and if not available
+                       then look in the higher range.
+    strict             With this option on every unmap_single operation will
+                       result in a hardware IOTLB flush operation as opposed
+                       to batching them for performance (Default Off).
+
 Debugging
 
   oops=panic	Always panic on oopses. Default is to just kill the process,
-- 
1.5.5.GIT


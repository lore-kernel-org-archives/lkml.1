Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZLGA0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZLGA0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758494AbZLGAZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:25:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38717 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521AbZLGAZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:25:51 -0500
Date: Mon, 7 Dec 2009 11:25:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20091207112557.dfbe6b6e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
drivers/pci/dmar.c between commit
75f1cdf1dda92cae037ec848ae63690d91913eac ("x86: Handle HW IOMMU
initialization failure gracefully") from Linus' tree and commit
5d990b627537e59a3a2f039ff588a4750e9c1a6a ("PCI: add pci_request_acs")
from the pci tree.

Just context changes.  I fxied it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/dmar.c
index 416f6ac,0e98f6b..0000000
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@@ -645,13 -613,13 +645,16 @@@ void __init detect_intel_iommu(void
  			       "x2apic and Intr-remapping.\n");
  #endif
  #ifdef CONFIG_DMAR
- 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled)
 -		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 -		    !dmar_disabled) {
++		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
  			iommu_detected = 1;
+ 			/* Make sure ACS will be enabled */
+ 			pci_request_acs();
+ 		}
  #endif
 +#ifdef CONFIG_X86
 +		if (ret)
 +			x86_init.iommu.iommu_init = intel_iommu_init;
 +#endif
  	}
  	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
  	dmar_tbl = NULL;

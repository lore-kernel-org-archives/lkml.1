Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbZLGA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbZLGA0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbZLGA0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:26:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524AbZLGAZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:25:48 -0500
Date: Mon, 7 Dec 2009 11:25:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20091207112551.368605d5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
arch/x86/kernel/amd_iommu_init.c between commit
ea1b0d3945c7374849235b6ecaea1191ee1d9d50 ("x86: amd_iommu: Convert
amd_iommu_detect() to use iommu_init hook") from Linus' tree and commit
5d990b627537e59a3a2f039ff588a4750e9c1a6a ("PCI: add pci_request_acs")
from the pci tree.

I did a fixup (see below) but I have no confidence in it.  Please check.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/amd_iommu_init.c
index 7ffc399,e60530a..0000000
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@@ -1335,7 -1326,12 +1335,9 @@@ void __init amd_iommu_detect(void
  	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
  		iommu_detected = 1;
  		amd_iommu_detected = 1;
 -#ifdef CONFIG_GART_IOMMU
 -		gart_iommu_aperture_disabled = 1;
 -		gart_iommu_aperture = 0;
 -#endif
 +		x86_init.iommu.iommu_init = amd_iommu_init;
+ 		/* Make sure ACS will be enabled */
+ 		pci_request_acs();
  	}
  }
  

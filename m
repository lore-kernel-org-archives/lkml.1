Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYKXTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYKXTxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYKXTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:53:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:8779 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080AbYKXTx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:53:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,660,1220252400"; 
   d="scan'208";a="363806421"
Date: Mon, 24 Nov 2008 11:53:27 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] Enable Pass Through Feature in Intel IOMMU 
Message-ID: <20081124195327.GA29471@linux-os.sc.intel.com>
References: <A6AD88C3F2289247BE726C37303E1EB884780E2A@orsmsx505.amr.corp.intel.com> <48F62C0E.2060705@redhat.com> <A6AD88C3F2289247BE726C37303E1EB884876541@orsmsx505.amr.corp.intel.com> <1224236501.6770.1256.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224236501.6770.1256.camel@macbook.infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set adds kernel parameter intel_iommu=pt to set up pass through mode in
context mapping entry. This disables DMAR in linux kernel; but KVM still runs on
VT-d. In this mode, kernel uses swiotlb for DMA API functions but other VT-d
functionalities are enabled for KVM. By default, pass though mode is disabled in
kernel.

This second patch changes context mapping interface called in KVM vtd.c. KVM
always uses multi level translation page table in VT-d.


Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Allen Kay <allen.m.kay@intel.com>
Signed-off-by: David Woodhouse <david.woodhouse@intel.com>

---

 vtd.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/virt/kvm/vtd.c b/virt/kvm/vtd.c
index a770874..7b753d7 100644
--- a/virt/kvm/vtd.c
+++ b/virt/kvm/vtd.c
@@ -124,7 +124,7 @@ int kvm_iommu_map_guest(struct kvm *kvm,
 			       pdev->bus->number, pdev->devfn);
 
 	r = intel_iommu_context_mapping(kvm->arch.intel_iommu_domain,
-					pdev);
+					pdev, CONTEXT_TT_MULTI_LEVEL);
 	if (r) {
 		printk(KERN_ERR "Domain context map for %s failed",
 		       pci_name(pdev));

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYLJSZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYLJSZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYLJSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:25:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLJSZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:25:24 -0500
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, weidong.han@intel.com,
       torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20081210142525.GC12816@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com>
	 <20081210141131.GB12816@amd.com>
	 <1228918928.21454.27.camel@macbook.infradead.org>
	 <20081210142525.GC12816@amd.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 18:24:35 +0000
Message-Id: <1228933475.23842.70.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 15:25 +0100, Joerg Roedel wrote:
> I already did it on-top of your tree because Han Weidong's patches 1-17
> were rebased to your tree and my IOMMU-API patches apply on-top of his
> patches.

OK, thanks. Looks like you still need this though, as Mike Day pointed
out:

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 97df47c..a5f6e28 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -204,7 +204,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 }
 
 /* devices under the same p2p bridge are owned in one domain */
-#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 < 0)
+#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
 
 /* domain represents a virtual machine, more than one devices
  * across iommus may be owned in one domain, e.g. kvm guest.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


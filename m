Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZKJL1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZKJL1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZKJL1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:27:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZKJL1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:27:33 -0500
Date: Tue, 10 Nov 2009 12:27:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com
Subject: Re: [PATCH -v2 9/9] x86: handle HW IOMMU initialization failure
 gracely
Message-ID: <20091110112723.GA24190@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1257849980-22640-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257849980-22640-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this patch needed the fixlet below. (it could be cleaned up later 
perhaps to not need the #ifdef - but wanted to keep it simple for now.)

	Ingo

------------->
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c7a8bcf..43d755a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3252,7 +3252,9 @@ int __init intel_iommu_init(void)
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
 
 	init_timer(&unmap_timer);
+#ifdef CONFIG_SWIOTLB
 	swiotlb = 0;
+#endif
 	dma_ops = &intel_dma_ops;
 
 	init_iommu_sysfs();

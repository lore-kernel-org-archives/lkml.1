Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZHMI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZHMI0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZHMI0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:42750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZHMI0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:26:16 -0400
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
 failure
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: luming.yu@gmail.com, fenghua.yu@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090813121727W.fujita.tomonori@lab.ntt.co.jp>
References: <20090813110948V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908121924t1589941fmcd45d3669b78bba4@mail.gmail.com>
	 <20090813121444W.fujita.tomonori@lab.ntt.co.jp>
	 <20090813121727W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 09:26:12 +0100
Message-Id: <1250151972.29180.193.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 12:18 +0900, FUJITA Tomonori wrote:
> > Duh, yeah, intel_iommu_init() fails, it doesn't work.
> > 
> > X86 falls back into nommu_dam_ops but IA64 has nothing.
> > 
> > pci_swiotlb_init() can't set swiotlb to 1 or overwrite dma_ops? If it
> > sets swiotlb to 1, intel_iommu_init() fails.
> > 
> > A quick fix could be something like this:
> 
> Oops, here's a good one.

Closer, but don't we still want to free the swiotlb buffers if the iommu
init _does_ actually work?

And we want the same on x86 too -- we want swiotlb, not nommu.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


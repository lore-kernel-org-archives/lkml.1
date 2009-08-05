Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbZHEIUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbZHEIUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbZHEIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:20:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881AbZHEIUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:20:01 -0400
Subject: Re: [PATCH 4/4] Bug Fix drivers/pci/intel-iommu.c: convert pfn_lo
 to VTD page address when calling iommu_flush_dev_iotlb()
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090804221119.GA21544@linux-os.sc.intel.com>
References: <bug-504363-150293@bugzilla.redhat.com>
	 <200908042017.n74KHsNw018095@bz-web1.app.phx.redhat.com>
	 <20090804221119.GA21544@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 09:19:59 +0100
Message-Id: <1249460399.9324.350.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:11 -0700, Fenghua Yu wrote:
> The iova->pfn_lo should be converted to VTD page address before it's passed to
> iommu_flush_dev_iotlb().
> 
> This issue may cause DMA failure on PAGE_SIZE>VTD_PAGE_SIZE platforms e.g. ia64
> platforms.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

I think this one is wrong. We allocate IOVA space in MM pages, not DMA
pages -- so the pfn_lo is an MM page already, and shifting by PAGE_SHIFT
is the right thing to do.

(I could be tempted to allocate it in DMA pages instead, but that's a
different story).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbZDFVtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbZDFVtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbZDFVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:48:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454AbZDFVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:48:45 -0400
Subject: Re: [PATCH] Intel-IOMMU Alignment Issue in dma_pte_clear_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "Zhao, Yu" <yu.zhao@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       iommu <iommu@lists.linux-foundation.org>
In-Reply-To: <20090406182149.GA28529@linux-os.sc.intel.com>
References: <1238507922.3294.35.camel@macbook.infradead.org>
	 <alpine.LFD.2.00.0904031140520.19690@localhost.localdomain>
	 <20090403191923.GA7772@linux-os.sc.intel.com>
	 <20090406182149.GA28529@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 14:48:22 -0700
Message-Id: <1239054502.22733.102.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 11:21 -0700, Fenghua Yu wrote:
> This issue was pointed out by Linus.
> 
> In dma_pte_clear_range() in intel-iommu.c
> 
> start = PAGE_ALIGN(start);
> end &= PAGE_MASK;
> npages = (end - start) / VTD_PAGE_SIZE;
> 
> In partial page case, start could be bigger than end and npages will be
> negative.
> 
> Currently the issue doesn't show up as a real bug in testing because start and
> end have been aligned to page boundary already by all callers. So the issue has
> been hiden. But it is dangerous programming practice.
> 
> The following patch fixes the issue. It's applied on iommu-2.6.git tree.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Applied to git://git.infradead.org/iommu-2.6.git; thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


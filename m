Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYJGAfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYJGAfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYJGAfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:35:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:3799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYJGAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:35:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,370,1220252400"; 
   d="scan'208";a="344734427"
Date: Mon, 6 Oct 2008 17:35:39 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/2]Add Variable Page Size and IA64 Support in Intel IOMMU: IA64 Specific Part
Message-ID: <20081007003539.GA5920@linux-os.sc.intel.com>
References: <20081001165750.GA21272@linux-os.sc.intel.com> <200810030941.42800.bjorn.helgaas@hp.com> <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com> <200810060855.36880.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810060855.36880.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Could you please point me to the doc that explicitly says that architecturally ia64 doesn't need cache flush?
> 
> The following sections in volume 2 of the SDM mention DMA:
> Part 1, Sec 4.4.3, Cacheability and Coherency Attribute:
> Part 2, Sec 2.5.4, DMA:
> 
> It sounds like the expectation is that DMA will be fully coherent
> and no flushes would be required, but there is wiggle room in that
> last paragraph for platforms that don't maintain coherency.

The cache coherency bit in VT-d is for root, context, and page tables which are for DMA management, not DMA data itself. VT-d DMA data should be cache coherent.The Intel IOMMU code doesn't need to deal with non cache coherency in DMA data traffic. But root, context, and page tables could be non cache coherent and this is handled by Intel IOMMU code.

Thanks.

-Fenghua

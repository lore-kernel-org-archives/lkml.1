Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZHMItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZHMItj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZHMItj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:49:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:56521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZHMIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:49:38 -0400
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
 failure
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 09:49:33 +0100
Message-Id: <1250153373.29180.225.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 16:11 +0800, Luming Yu wrote:
> I treat this as -32 or -33 stuff, because I don't see a real system is blocking
> on the problem. I found this problem when I was trying to disable some drhd
> for debugging a real iommu issue...that one has priority.

(The real bug you were chasing is fixed, isn't it? Or worked around, at
least, since the BIOS in question is still closed source and broken.)

But by talking about disabling _some_ drhd units, you've just reminded
me that the problem is far more interesting -- we can have the IOMMU
active for _some_ devices but not others.

I was toying with the idea of putting the intel_dma_ops into
dev->archdata for each pci device at boot or hotplug time, and leaving
the global variable alone. We can calculate the dev->iommu mapping at
that point too. And we can stop being quite so broken w.r.t. PCI
hotplug...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


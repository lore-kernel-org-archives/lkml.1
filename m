Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZHLSYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZHLSYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZHLSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:24:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:45940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbZHLSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:24:35 -0400
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
 failure
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Luming Yu <luming.yu@gmail.com>, "Luck, Tony" <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090812181722.GA32653@linux-os.sc.intel.com>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
	 <20090812181722.GA32653@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 19:20:22 +0100
Message-Id: <1250101222.29180.139.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 11:17 -0700, Fenghua Yu wrote:
> 
> >  void __init pci_swiotlb_init(void)
> >  {
> > -     if (!iommu_detected || iommu_pass_through) {
> 
> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
> previous dma_ops value.
> 
> I think you can change this check to something like:
>         if (!dma_ops || iommu_pass_through) {
> With this change, checking iommu_detected is unnecesary because checking dma_ops
> covers it.

Hm, that iommu_pass_through should go away anyway. See commit 19943b0e3.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


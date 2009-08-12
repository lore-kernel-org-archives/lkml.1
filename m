Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZHLJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZHLJgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZHLJgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:36:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZHLJgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:36:23 -0400
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
 failure
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 10:36:08 +0100
Message-Id: <1250069768.29180.85.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 17:20 +0800, Luming Yu wrote:
> Hi there,
> 
> On ia64 platform with dmar table and new upstream
> kernel(config_dmar_default_on enabled),
> if intel_iommu_init ends up without dma_ops initialized or other iommu
> failures.
> We got nothing to fall back. The following patch fixes it.

Hm, don't we then end up with a 64MiB allocation for swiotlb buffers
which we don't need? We can't defer the allocation until we know -- I
think we need to come up with some way to give it _back_ if the swiotlb
turns out not to be needed? And we should do this for i386/x86_64 too.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


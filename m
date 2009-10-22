Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZJVPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZJVPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbZJVPBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:01:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:58740 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbZJVPBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:01:52 -0400
Date: Fri, 23 Oct 2009 00:00:57 +0900
To: dwmw2@infradead.org
Cc: alex.williamson@hp.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mike.miller@hp.com
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through
 devices
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1256222867.2990.47.camel@macbook.infradead.org>
References: <1256192928.2990.10.camel@macbook.infradead.org>
	<1256214241.2842.50.camel@2710p.home>
	<1256222867.2990.47.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091023000034A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 23 Oct 2009 00:00:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 23:47:47 +0900
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2009-10-22 at 06:24 -0600, Alex Williamson wrote:
> > The coherent_dma_mask is independent of the dma_mask and can be set
> > separately by the device.  The default for any device that doesn't
> > specify one is 32bits.  iommu_should_identity_map() only checks the
> > dma_mask, not the coherent_dma_mask. 
> 
> Are you telling me that this particular device supports only a 32-bit
> coherent DMA mask, but that it _does_ support a 64-bit DMA mask for
> non-coherent DMA? On x86?

This is not related with architectures. This card support 64 bit
addresses but doesn't support 64 bit addresses for descriptors, etc.
There are several hardware that have such limit.

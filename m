Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYJJWpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYJJWpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYJJWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:45:23 -0400
Received: from colo.lackof.org ([198.49.126.79]:49577 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYJJWpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:45:22 -0400
Date: Fri, 10 Oct 2008 16:45:08 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, grundler@parisc-linux.org, matthew@wil.cx,
       jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081010224508.GB28369@colo.lackof.org>
References: <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081010114003X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010114003X.fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:40:56AM +0900, FUJITA Tomonori wrote:
> IIRC, except for one SGI architecture, coherent_dma_mask is
> meaningless, dma_mask is always equal to coherent_dma_mask.

Not correct. Several PCI-X devices can only do 32-bit DMA to control
data but can do 64-bit DMA for payload data. I don't have the list off
the top of my head but that is the origin of coherent DMA mask.

> Lots of
> IOMMU implementations ignore coherent_dma_mask and use dma_mask for
> alloc_coherent().

That sounds like a bug. And I don't think it's "lots".

> Some drivers don't set up coherent_dma_mask.

They probably should. Current default is 32-bits for PCI devices.

> Theoretically, we need to fix this but it doesn't cause any
> problem. That's why nobody cares about it, I guess.

Agreed - for the "supported" configurations, it works.

hth,
grant

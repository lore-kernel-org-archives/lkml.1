Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYJNGwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYJNGwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYJNGv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:51:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:53914 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYJNGvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:51:55 -0400
Date: Tue, 14 Oct 2008 15:50:02 +0900
To: grundler@parisc-linux.org
Cc: fujita.tomonori@lab.ntt.co.jp, yinghai@kernel.org, matthew@wil.cx,
       jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081010224508.GB28369@colo.lackof.org>
References: <48EE8E55.4000009@kernel.org>
	<20081010114003X.fujita.tomonori@lab.ntt.co.jp>
	<20081010224508.GB28369@colo.lackof.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081014154217L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 16:45:08 -0600
Grant Grundler <grundler@parisc-linux.org> wrote:

> On Fri, Oct 10, 2008 at 11:40:56AM +0900, FUJITA Tomonori wrote:
> > IIRC, except for one SGI architecture, coherent_dma_mask is
> > meaningless, dma_mask is always equal to coherent_dma_mask.
> 
> Not correct. Several PCI-X devices can only do 32-bit DMA to control
> data but can do 64-bit DMA for payload data. I don't have the list off
> the top of my head but that is the origin of coherent DMA mask.

Thanks. I misunderstood coherent_dma_mask. I needed to read several
old mails (posted in 2002 and 2003) in ia64 mailing list.


> > Lots of
> > IOMMU implementations ignore coherent_dma_mask and use dma_mask for
> > alloc_coherent().
> 
> That sounds like a bug. And I don't think it's "lots".

Maybe it's not "lots" but seems that only IA64 and x86 non-hardware
IOMMU code (pci-nommu.c and GART) use coherent_dma_mask for
alloc_coherent. 

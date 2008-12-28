Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYL1Haq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYL1Haq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 02:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYL1Hah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 02:30:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYL1Hag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 02:30:36 -0500
Date: Sun, 28 Dec 2008 02:30:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, jeremy@goop.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228073012.GA30012@infradead.org>
References: <20081228014432L.fujita.tomonori@lab.ntt.co.jp> <20081227165622.GA19796@elte.hu> <20081228020312K.fujita.tomonori@lab.ntt.co.jp> <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 02:29:54PM +0900, FUJITA Tomonori wrote:
> If we really want to clean up the dma mapping operations, we should
> define struct dma_mapping_ops in a generic place (such as
> include/linux/dma-mapping.h) instead each architecture define the own
> struct dma_mapping_ops. These dma_mapping_ops structures are very
> similar but a bit different. That's the root cause of the dma mapping
> operation ugliness.

Yes, please.  For people hacking on different architectures occasionally
the current setup with per-arch ops (and sometimes none at all) is pain.

> If we do, X86 and IA64 can share swiotlb and intel VTD code cleanly,
> X86, IA64, and POWERPC can share swiotlb cleanly too. For example, we
> can define swiotlb_dma_ops in lib/swiotlb.c and then everyone can
> share it. Currently, X86 and IA64 define the own swiotlb_dma_ops (and
> X86 needs swiotlb_map_single_phys hack). It doesn't make sense.

Also the calgary iommu is very similar to those used on some pseries
machines, but I'd have to look at the code if the interface actually
still is similar, or if the PPC firmware adds too much abstractions
inbetween.

Also the older IA64 altixens have a slightly updated version of the
iommu used on MIPS IP27 (and the same as on MIPS IP35 which we'll
hopefully support one day)


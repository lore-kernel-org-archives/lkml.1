Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYL1Jg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYL1Jg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 04:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL1Jgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 04:36:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:55078 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYL1Jgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 04:36:44 -0500
Date: Sun, 28 Dec 2008 18:36:07 +0900
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, jeremy@goop.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228073012.GA30012@infradead.org>
References: <20081228020312K.fujita.tomonori@lab.ntt.co.jp>
	<20081228142900W.fujita.tomonori@lab.ntt.co.jp>
	<20081228073012.GA30012@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228183054Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 02:30:12 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Dec 28, 2008 at 02:29:54PM +0900, FUJITA Tomonori wrote:
> > If we really want to clean up the dma mapping operations, we should
> > define struct dma_mapping_ops in a generic place (such as
> > include/linux/dma-mapping.h) instead each architecture define the own
> > struct dma_mapping_ops. These dma_mapping_ops structures are very
> > similar but a bit different. That's the root cause of the dma mapping
> > operation ugliness.
> 
> Yes, please.  For people hacking on different architectures occasionally
> the current setup with per-arch ops (and sometimes none at all) is pain.

The biggest obstacle is IA64's way to handle multiple dma mapping
operations (artistic define magics).

I'll take care of the cleanups if Tony lets me change IA64 to handle
multiple dma mapping operations as other architectures do (x86 and
powerpc).

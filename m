Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYL1VoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYL1VoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 16:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYL1Vnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 16:43:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:40984 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbYL1Vnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 16:43:46 -0500
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@elte.hu,
       jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
In-Reply-To: <20081228073012.GA30012@infradead.org>
References: <20081228014432L.fujita.tomonori@lab.ntt.co.jp>
	 <20081227165622.GA19796@elte.hu>
	 <20081228020312K.fujita.tomonori@lab.ntt.co.jp>
	 <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
	 <20081228073012.GA30012@infradead.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 08:37:44 +1100
Message-Id: <1230500264.15389.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-28 at 02:30 -0500, Christoph Hellwig wrote:
> Also the calgary iommu is very similar to those used on some pseries
> machines, but I'd have to look at the code if the interface actually
> still is similar, or if the PPC firmware adds too much abstractions
> inbetween.

Well, we have basically two backends... in the same file but they are
really different and I may split them one of these days. One is
"native", used in theory only on POWER4 (and internal bare-metal stuff)
and one is purely via hypervisor calls.

> Also the older IA64 altixens have a slightly updated version of the
> iommu used on MIPS IP27 (and the same as on MIPS IP35 which we'll
> hopefully support one day)

BTW. On a tangent here, but I do prefer in the long run switching DMA
ops mostly away from struct page * + offset and toward phys_addr_t (even
if we won't change the SG variant).

The reason is sneaky :-) But there are cases, especially in embedded
space, where it would be nice to be able to DMA to/from MMIO areas or in
general areas not covered by struct pages. Currently doing so requires
hacking all the way through the stack, it might be possible to do it
more nicely with arch custom DMA ops provided we can pass around
addresses an not struct page*.

Cheers, 
Ben.



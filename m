Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYJTAre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYJTAre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 20:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYJTArY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 20:47:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:35094 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbYJTArX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 20:47:23 -0400
Date: Mon, 20 Oct 2008 09:46:03 +0900
To: dwmw2@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, mgross@linux.intel.com, mingo@elte.hu,
       grundler@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: use coherent_dma_mask in alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1224337616.6770.1366.camel@macbook.infradead.org>
References: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
	<1224337616.6770.1366.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081020093824G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 14:46:56 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2008-10-15 at 16:08 +0900, FUJITA Tomonori wrote:
> > This patch fixes intel-iommu to use dev->coherent_dma_mask in
> > alloc_coherent. Currently, intel-iommu uses dev->dma_mask in
> > alloc_coherent but alloc_coherent is supposed to use
> > coherent_dma_mask. It could break drivers that uses smaller
> > coherent_dma_mask than dma_mask (though the current code works for the
> > majority that use the same mask for coherent_dma_mask and dma_mask).
> 
> I've fixed this up to cope with the fact that dma_mask can be bigger
> than an 'unsigned long', and committed it to the iommu-2-6.git tree.

Hmm, 'unsigned long' is 64 bits on IA64 and X86_64. How can dma_mask
be bigger than an 'unsigned long'?

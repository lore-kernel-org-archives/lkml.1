Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZJ0BrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZJ0BrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZJ0BrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:47:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:60587 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZJ0BrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:47:22 -0400
Date: Tue, 27 Oct 2009 10:47:02 +0900
To: alex.williamson@hp.com
Cc: dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dma: create dma_generic_alloc/free_coherent()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091026232458.9646.36818.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	<20091026232458.9646.36818.stgit@nehalem.aw>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027104526V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 10:47:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 17:24:58 -0600
Alex Williamson <alex.williamson@hp.com> wrote:

> Move dma_generic_alloc_coherent() out of x86 code and create
> corresponding dma_generic_free_coherent() for symmetry.  These
> can then be used by IOMMU drivers attempting to implement
> passthrough mode.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> ---
> 
>  arch/x86/include/asm/dma-mapping.h |    3 --
>  arch/x86/kernel/pci-dma.c          |   31 -------------------------
>  arch/x86/kernel/pci-nommu.c        |   10 +++++++-
>  include/linux/dma-mapping.h        |   44 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 52 insertions(+), 36 deletions(-)

dma_generic_alloc_coherent() is x86 specific; other sane architectures
don't need such GFP_ hack. So moving it to the generic place is not a
good idea.

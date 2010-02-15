Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0BOLTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:19:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:39370 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0BOLT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:19:28 -0500
Date: Mon, 15 Feb 2010 20:18:41 +0900
To: mb@bu3sch.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, stefano.brivio@polimi.it,
       Larry.Finger@lwfinger.net, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201002151203.42805.mb@bu3sch.de>
References: <20100215142111R.fujita.tomonori@lab.ntt.co.jp>
	<201002151203.42805.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100215201825M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 15 Feb 2010 20:18:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 12:03:41 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> On Monday 15 February 2010 06:21:58 FUJITA Tomonori wrote:
> > This patch is against -mm since it depends on the DMA API changes in
> 
> I appreciate your efforts to remove bus-specific APIs.
> However, always keep in mind that a SSB bus might be running on a system
> where there's no PCI bus at all.

Yup, that's why we introduced the generic device model and the generic
DMA API is better.


> In the past we used the generic dma_... API for DMA operations on all
> SSB devices. This worked 99.9% of the time. _But_ it broke in really obscure
> cases where the architecture implementations _slightly_ differed between
> the generic dma and the pci variants.

Yeah, I know. There are some differences between the PCI DMA API and
the generic DMA API on some architectures.

My patchset in -mm fixes the above problem:

http://marc.info/?l=linux-kernel&m=126596737604808&w=2

http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-misc.git;a=blob;f=include/asm-generic/pci-dma-compat.h;h=ddfa9c5309229d171af63dcaf3872288fb4fa845;hb=refs/heads/pending

The PCI DMA API simply calls the generic DMA API. And all the
architectures that supports pci uses asm-generic/pci-dma-compat.h.

You can use the generic DMA API with any buses. I'll remove the PCI
DMA API in the long term.


Thanks,

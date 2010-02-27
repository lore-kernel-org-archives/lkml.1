Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641Ab0B0Sib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:38:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:35066 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474Ab0B0Si2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:38:28 -0500
Date: Sun, 28 Feb 2010 03:38:19 +0900
To: hancockrwd@gmail.com
Cc: davem@davemloft.net, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking 
	drivers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <51f3faa71002271015i7c9ec45j18381b1269bfd799@mail.gmail.com>
References: <201002271259.31596.bzolnier@gmail.com>
	<20100227.040502.182574085.davem@davemloft.net>
	<51f3faa71002271015i7c9ec45j18381b1269bfd799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100228033706G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 28 Feb 2010 03:38:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 12:15:19 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On Sat, Feb 27, 2010 at 6:05 AM, David Miller <davem@davemloft.net> wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date: Sat, 27 Feb 2010 12:59:31 +0100
> >
> >> Having IOMMU (even if it is only a software one, i.e. this would
> >> mean swiotlb for x86-32/highmem) always in place would simplify
> >> things greatly..
> >
> > I agree, things would be a lot simpler.
> 
> Yeah, the situation kind of sucks on the platforms that don't have any
> IOMMU support, since it means that the DMA API can't handle anything
> over 4GB properly and you need all these hacks in the block layer,
> networking layer, etc. It would be nice if some kind of IOMMU support
> could be relied upon always.

When I proposed such approach (always use swiotlb) before, IIRC,
the objections were:

- better to make allocation respect dma_mask. (I don't think that this
  approach is possible since we don't know which device handles data
  later when we allocate memory).

- swiotlb is not good for small systems since it allocates too much
  memory (we can fix this though).

There might be more.

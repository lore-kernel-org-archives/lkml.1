Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0CBElL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 23:41:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:57906 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CBElJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 23:41:09 -0500
Date: Tue, 2 Mar 2010 13:40:57 +0900
To: hancockrwd@gmail.com
Cc: konrad.wilk@oracle.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Was: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in 
	networking, Now: SWIOTLB dynamic allocation
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <51f3faa71003011312n3e7f8151x1a5e4b8bb57bb7c0@mail.gmail.com>
References: <20100228.001628.48507956.davem@davemloft.net>
	<20100301163437.GE7881@phenom.dumpdata.com>
	<51f3faa71003011312n3e7f8151x1a5e4b8bb57bb7c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20100302133758W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 13:40:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010 15:12:41 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On Mon, Mar 1, 2010 at 10:34 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Sun, Feb 28, 2010 at 12:16:28AM -0800, David Miller wrote:
> >> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> Date: Sun, 28 Feb 2010 03:38:19 +0900
> >>
> >> > When I proposed such approach (always use swiotlb) before, IIRC,
> >> > the objections were:
> >> >
> >> > - better to make allocation respect dma_mask. (I don't think that this
> >> >   approach is possible since we don't know which device handles data
> >> >   later when we allocate memory).
> >>
> >> And such objects might end up being processed by multiple devices with
> >> different DMA restrictions.
> >>
> >> > - swiotlb is not good for small systems since it allocates too much
> >> >   memory (we can fix this though).
> >>
> >> Indeed.
> >
> > What would be a good mechanism for this? Enumerating all of the PCI
> > devices to find out which ones are 32-bit and then allocate some chunk
> > of memory based on the amount of them? say, 1MB per card?
> >
> > Or maybe a simpler one - figure out how many pages we have an allocate
> > based on some sliding rule (say, 8MB for under 512MB, 16MB between 512MB
> > and 2GB, and 32MB for 2GB to 4GB, and after that the full 64MB?)
> 
> Why do we need to allocate SWIOTLB if your highest memory address is
> under 4GB? You can just disable it in that case, like x86_64 does.

Unfortunately, we need to do because the goal is removing the block
layer bounce (and other bounce mechanisms in sub systems).

For example, even if highest memory address is under 4GB, you must
provide bounce buffer for ISA devices (and some devices for strange
DMA restrictions such as under 1GB).

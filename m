Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZK0IHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZK0IHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZK0IHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:07:08 -0500
Received: from sh.osrg.net ([192.16.179.4]:38590 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZK0IHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:07:07 -0500
Date: Fri, 27 Nov 2009 17:06:21 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B0F839D.5050104@kernel.org>
References: <4B0DB0B7.9040004@kernel.org>
	<20091127162918G.fujita.tomonori@lab.ntt.co.jp>
	<4B0F839D.5050104@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091127170347O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 Nov 2009 17:06:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 23:45:33 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> >> when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
> > 
> > I have such machine (with sane BIOS).
> > 
> > But if BIOS is broken, early_gart_iommu_check() disables GART_EN bit
> > (bits 0)?
> 
> not for 32M small size.
> 
> that function only clear that bit when different nodes have different setting.
> 
> > 
> >> 1. iommu=soft, will go through POINT A and POINT B
> > 
> > Not always. if aperture_valid() is true, it doesn't go POINT A. My
> > GART machine doesn't go.
> 
> maybe your bios set GART iommu set to 64M?

Yeah, my machine has sane BIOS.


> >> 2. no "iommu=soft", will go through POINT A and POINT C
> > 
> > As I said, it's not true about POINT A.
> 
> maybe your bios set GART iommu set to 64M?
> 
> > 
> > 
> >> and all will reach POINT X to make sure ENABLE bit is not set.
> > 
> > POINT X doesn't look make sure ENABLE bit is not set. It just fixes up
> > (sets) the address and its size.
> 
>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
> 
> that bit is that bit 0 of AMD64_GARTAPERTURECTL reg.

Oops, thanks.

But as I wrote in the previous mail, can you tell me why we need this?
With 2.6.31 my machine uses swiotlb with GART_EN bit enabled.

My another question is that why can't early_gart_iommu_check()
_always_ disable GART_EN bit?

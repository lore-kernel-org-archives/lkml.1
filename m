Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0BJAJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:09:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:59477 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0BJAJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:09:09 -0500
Date: Wed, 10 Feb 2010 09:06:28 +0900
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, x86@kernel.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
       dhowells@redhat.com, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, deller@gmx.de, James.Bottomley@suse.de,
       benh@kernel.crashing.org, lethal@linux-sh.org, davem@davemloft.net,
       chris@zankel.net
Subject: Re: [PATCH -mm 00/12] adds include/asm-generic/pci-dma-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201002091623.35791.arnd@arndb.de>
References: <1265722524-9493-1-git-send-email-e>
	<201002091623.35791.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100210090542G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 09:06:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010 16:23:35 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 09 February 2010, e@lab.ntt.co.jp wrote:
> > This patchset adds include/asm-generic/pci-dma-common.h that defines
> > the pci_unmap state API:
> > 
> > DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
> > DECLARE_PCI_UNMAP_LEN(LEN_NAME)
> > pci_unmap_addr(PTR, ADDR_NAME)
> > pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
> > pci_unmap_len(PTR, LEN_NAME)
> > pci_unmap_len_set(PTR, LEN_NAME, VAL)
> > 
> > This enables us to remove lots of the duplication in architecture
> > implementations since there are only two ways to define the API.
> 
> Good stuff, moving this code to a common location is certainly
> a step in the right direction.
> 
> A few general comments though:
> 
> * It seems you left out arch/cris for no good reason.

Yeah, somehow I missed it. I'll do next time.


> * The general tendency nowadays is to avoid new HAVE_ARCH_*
>   macros and instead using either a Kconfig symbol or
>   checking the presence of the macros themselves. In this case,
>   the macro would always be present, so CONFIG_PCI_UNMAP
>   would be reasonable.

I see. I go with CONFIG_NEED_DMA_MAP_STATE (it's a bit explanatory and
mips already uses CONFIG_DMA_NEED_PCI_MAP_STATE for the same purpose).


> * AFAICT, there are no architectures left doing the
>   non-generic version, so the code could be moved to
>   a global file in include/linux instead of include/asm-generic.
>   While include/linux/pci.h is already a bit overloaded, it's
>   probably the right place for this. Alternatively,
>   include/linux/pci-dma.h, included from include/linux/pci.h.

Ok, I go with linux/pci-dma.h. I prefer linux/pci.h but as you said,
looks like already too big. We'll remove this file after moving to the
generic device model. So the name shouldn't matter much.


Thanks!

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZJ0Bjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZJ0Bjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZJ0Bjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:39:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:34408 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZJ0Bja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:39:30 -0400
Date: Tue, 27 Oct 2009 10:38:18 +0900
To: mingo@elte.hu
Cc: JBeulich@novell.com, yinghai@kernel.org, tglx@linutronix.de, tiwai@suse.de,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent allocations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091026201917.GE24682@elte.hu>
References: <20091026152246.GB3749@elte.hu>
	<4AE5D238020000780001BD46@vpn.id2.novell.com>
	<20091026201917.GE24682@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027103758L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 10:38:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 21:19:17 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > >>> Ingo Molnar <mingo@elte.hu> 26.10.09 16:22 >>>
> > >* Jan Beulich <JBeulich@novell.com> wrote:
> > >> And any attempt to eliminate the conditional another way would just 
> > >> introduce a very similar conditional elsewhere; with this having a 
> > >> single user (and foreseeably not ever a second one) I would think this 
> > >> would just make the code less readable.
> > >
> > >There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 - couldnt 
> > >those use ISA_DMA_BIT_MASK too?
> > 
> > Oh, so you didn't mean me to eliminate the conditional in pci-dma.c, 
> > but just to replace the DMA_BIT_MASK(24) here an elsewhere. Sure, I'm 
> > fine with adding this to the patch.
> 
> Well, can ISA_BIT_MASK fall back to DMA_BIT_MASK(32) on !CONFIG_ISA? If 
> we have ISA support disabled we might as well pretend the whole world is 
> PCI, right?

I don't think that it works. At least, you can't do that with
the DMA_BIT_MASK(24) in arch/x86/kernl/pci-dma.c; it must be
DMA_BIT_MASK(24) even with !CONFIG_ISA.


> That way we'd get rid of that #ifdef in the .c code too.

Well, in the first place, we don't need the #ifdef in Jan's patch. We
can always use DMA_BIT_MASK(24) for the fallback device.

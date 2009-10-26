Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZJZUog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZJZUog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZJZUof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:44:35 -0400
Received: from outbound-mail-33.bluehost.com ([69.89.18.153]:46454 "HELO
	outbound-mail-33.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755815AbZJZUod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:44:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nFuD9QTTKtf7WNoFZQWnZilxTGhqZ+JE0AzrpiE/NA1U+ScDtazEHKVkF3n/z5vCug688Mbh35zUGKp6p9uNiOSBpuW819Dx74LAGHDfBVC/GdXFMFI61uW0mn1/Pm7p;
Date: Mon, 26 Oct 2009 13:44:34 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, Yinghai Lu <yinghai@kernel.org>,
       tglx@linutronix.de, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent allocations
Message-ID: <20091026134434.035cab90@jbarnes-g45>
In-Reply-To: <20091026201917.GE24682@elte.hu>
References: <4AE06644020000780001B4AD@vpn.id2.novell.com>
	<20091023114825.GH5886@elte.hu>
	<4AE5CA8C020000780001BD09@vpn.id2.novell.com>
	<20091026152246.GB3749@elte.hu>
	<4AE5D238020000780001BD46@vpn.id2.novell.com>
	<20091026201917.GE24682@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
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
> > >> And any attempt to eliminate the conditional another way would
> > >> just introduce a very similar conditional elsewhere; with this
> > >> having a single user (and foreseeably not ever a second one) I
> > >> would think this would just make the code less readable.
> > >
> > >There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 -
> > >couldnt those use ISA_DMA_BIT_MASK too?
> > 
> > Oh, so you didn't mean me to eliminate the conditional in
> > pci-dma.c, but just to replace the DMA_BIT_MASK(24) here an
> > elsewhere. Sure, I'm fine with adding this to the patch.
> 
> Well, can ISA_BIT_MASK fall back to DMA_BIT_MASK(32) on !CONFIG_ISA?
> If we have ISA support disabled we might as well pretend the whole
> world is PCI, right?
> 
> That way we'd get rid of that #ifdef in the .c code too.

Sounds good to me, feel free to add my acked-by and push it via the
-tip tree.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

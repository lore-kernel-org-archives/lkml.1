Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYJ1Kja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYJ1Kja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYJ1KjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:39:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYJ1KjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:39:22 -0400
Date: Tue, 28 Oct 2008 11:39:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, svens@stackframe.org,
       joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: swiotlb_alloc_coherent: allocated memory is out of range for
	device
Message-ID: <20081028103902.GB22319@elte.hu>
References: <s5hmygwn89z.wl%tiwai@suse.de> <20081022221321J.fujita.tomonori@lab.ntt.co.jp> <s5hfxmon4aj.wl%tiwai@suse.de> <20081023113618T.fujita.tomonori@lab.ntt.co.jp> <s5h63nj51j2.wl%tiwai@suse.de> <s5hfxmnjzg5.wl%tiwai@suse.de> <20081023101557.GA30302@elte.hu> <s5hk5btm2g2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk5btm2g2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Takashi Iwai <tiwai@suse.de> wrote:

> At Thu, 23 Oct 2008 12:15:57 +0200,
> Ingo Molnar wrote:
> > 
> > 
> > * Takashi Iwai <tiwai@suse.de> wrote:
> > 
> > > At Thu, 23 Oct 2008 07:22:09 +0200,
> > > I wrote:
> > > > 
> > > > > The current dma_alloc_coherent (asm-x86/dma-mapping.h) handles the gfp
> > > > > flags in the exact same way as the old dma_alloc_coherent
> > > > > (pci-dma.c). Neither sets GFP_DMA even if coherent_dma_mask is
> > > > > 24bits. The old code is fine because of the GFP_DMA retry
> > > > > mechanism. But if coherent_dma_mask is 24bits, there is no point to go
> > > > > into the GFP_DMA retry mechanism. We should use GFP_DMA in the first
> > > > > place.
> > > > > 
> > > > > How about the following patch?
> > > > 
> > > > I'll give it a try later (the machine is in my office).
> > > 
> > > The patch seems working fine.  Thanks!
> > > 
> > > Tested-by: Takashi Iwai <tiwai@suse.de>
> > 
> > thanks guys - i've queued it up in tip/core/urgent and will send a pull 
> > request to Linus later today.
> 
> Ingo, what is the status about these patches?
> They don't appear in rc2.

Will send it today-ish. -rc2 was strictly for brown paperbag bugs 
crashing more than half of all testsystems.

	Ingo

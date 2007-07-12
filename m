Return-Path: <linux-kernel-owner+w=401wt.eu-S932621AbXGLQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbXGLQOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbXGLQOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:14:31 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45733 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbXGLQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:14:29 -0400
Date: Thu, 12 Jul 2007 17:13:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Bill Irwin <wli@holomorphy.com>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bob Tracy <rct@gherkin.frus.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6 bad page error
In-Reply-To: <20070712134606.A10012@jurassic.park.msu.ru>
Message-ID: <Pine.LNX.4.64.0707121708180.4887@blonde.wat.veritas.com>
References: <20070709185324.387ACDBA1@gherkin.frus.com>
 <Pine.LNX.4.64.0707102120550.7594@blonde.wat.veritas.com>
 <20070711170245.A1148@jurassic.park.msu.ru> <Pine.LNX.4.64.0707111743580.22786@blonde.wat.veritas.com>
 <20070712134606.A10012@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAbGludXgtYWxwaGFAdmdlci5rZXJuZWwub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAaW5rQGp1cmFzc2ljLnBhcmsubXN1LnJ1AHdsaUBob2xvbW9ycGh5LmNvbQBtaWNoYWwuay5rLnBpb3Ryb3dza2lAZ21haWwuY29tAHJjdEBnaGVya2luLmZydXMuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Ivan Kokshaysky wrote:
> On Wed, Jul 11, 2007 at 06:07:59PM +0100, Hugh Dickins wrote:
> 
> > > +	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
> > 
> > I was going to ask you why that needs to be GFP_ATOMIC on Alpha.
> > But find you're following the example of asm-generic and others.
> > So really should be asking Sparc how it gets away with GFP_KERNEL.
> 
> According to DMA-mapping.txt GFP_ATOMIC is mandatory for
> pci_alloc_consistent() since it can be called from interrupt context.
> So sparc code is probably incorrect...

Hi Bill, we've veered away from the original topic, and are wondering
how the sparc32 pci_alloc_consistent() gets away with using GFP_KERNEL,
when GFP_ATOMIC seems to be required?

Hugh

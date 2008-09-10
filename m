Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYIJMTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYIJMTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYIJMSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:18:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYIJMSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:18:54 -0400
Date: Wed, 10 Sep 2008 14:18:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
	IOMMU's alloc_coherent
Message-ID: <20080910121835.GA14757@elte.hu>
References: <20080910201851R.fujita.tomonori@lab.ntt.co.jp> <20080910120310.GD6329@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910120310.GD6329@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > +	get_device_resources(dev, &iommu, &domain, &devid);
> > +
> > +	if (iommu && domain)
> > +		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> > +
> 
> These flags are already removed in the dma_alloc_coherent function 
> which calls this one. Further I think in the case of a remapping IOMMU 
> like this one we should avoid implementing any gfp hacks and just 
> trust the caller.

or add a WARN_ON_ONCE() instead, to document and enforce that 
assumption.

	Ingo

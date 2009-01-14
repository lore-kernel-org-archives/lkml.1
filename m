Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbZANLpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbZANLpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZANLoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:44:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761799AbZANLon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:44:43 -0500
Date: Wed, 14 Jan 2009 12:43:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090114114347.GG8625@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-4-git-send-email-joerg.roedel@amd.com> <20090113005118.82f5037b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113005118.82f5037b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4796]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 9 Jan 2009 17:19:17 +0100 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +struct hash_bucket {
> > +	struct list_head list;
> > +	spinlock_t lock;
> > +} ____cacheline_aligned;
> 
> __cacheline_aligned_in_smp.
> 
> This all looks like an exotically large amount of code for a debug 
> thingy?

this code checks the DMA usage of ~1 million lines of kernel code - all 
the DMA using drivers. I think Joerg's feature is hugely relevant as DMA 
scribbles are one of the hardest to debug kernel bugs: they can end up in 
permanent data corruption or other hard to find bugs. In fact i think his 
patchset is rather simple and even having 10 times as much debug code 
would pay for its existence in the long run.

	Ingo

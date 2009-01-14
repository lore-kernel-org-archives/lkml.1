Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZANRoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZANRoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZANRoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:44:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZANRoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:44:20 -0500
Date: Wed, 14 Jan 2009 18:43:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090114174326.GA31983@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-4-git-send-email-joerg.roedel@amd.com> <20090113005118.82f5037b.akpm@linux-foundation.org> <20090114114347.GG8625@elte.hu> <20090114093918.e7b0ae46.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114093918.e7b0ae46.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2009 12:43:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Fri, 9 Jan 2009 17:19:17 +0100 Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > +struct hash_bucket {
> > > > +	struct list_head list;
> > > > +	spinlock_t lock;
> > > > +} ____cacheline_aligned;
> > > 
> > > __cacheline_aligned_in_smp.
> > > 
> > > This all looks like an exotically large amount of code for a debug 
> > > thingy?
> > 
> > this code checks the DMA usage of ~1 million lines of kernel code - 
> > all the DMA using drivers. I think Joerg's feature is hugely relevant 
> > as DMA scribbles are one of the hardest to debug kernel bugs: they can 
> > end up in permanent data corruption or other hard to find bugs. In 
> > fact i think his patchset is rather simple and even having 10 times as 
> > much debug code would pay for its existence in the long run.
> 
> Have we previously found bugs by other means which this facility would 
> have detected?  I don't recall any...

this facility found a handful of real bugs already - Joerg, do you have 
more specifics about that?

Also, such a facility would be useful during driver development, when such 
bugs occur en masse. Faster driver development under Linux is certainly 
desirable.

This facility basically adds a sandbox to all DMA ops and tracks the 
lifetime and validity of DMA operations. Given how ugly DMA bugs can be in 
practice and how hard to debug they are, i see this as good step forward.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbXF0UdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbXF0UdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXF0UdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:33:05 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:33071 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbXF0UdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:33:02 -0400
Date: Wed, 27 Jun 2007 16:32:58 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Message-ID: <20070627203258.GE4344@rhun.congress.lan>
References: <200706271041.21937.yinghai.lu@sun.com> <200706272222.25153.ak@suse.de> <86802c440706271325w3a8b6d9aybb8a346b9b2eb345@mail.gmail.com> <200706272226.29231.ak@suse.de> <86802c440706271329m62f4d132nddd250bd3931db97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440706271329m62f4d132nddd250bd3931db97@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 01:29:46PM -0700, Yinghai Lu wrote:
> On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> >On Wednesday 27 June 2007 22:25:11 Yinghai Lu wrote:
> >> On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> >> > On Wednesday 27 June 2007 19:41:21 Yinghai Lu wrote:
> >> > > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> >> > >
> >> > > there function is called via dma_ops->.., so change it to static
> >> >
> >> > Actually all these functions shouldn't be inline in the first place.
> >>
> >> do you mean pci_map_single==>dma_map_single==>gart_map_single?
> >
> >dma_map_single. pci_map_single is ok because it doesn't really
> >change anything.
> 
> move dma_map_single from include/asm-x86_64/dma_mapping.h to
> arch/x86_64/pci-dma.c?

If yes, why? it's not exactly a big function:

static inline dma_addr_t
dma_map_single(struct device *hwdev, void *ptr, size_t size,
	       int direction)
{
	BUG_ON(!valid_dma_direction(direction));
	return dma_ops->map_single(hwdev, ptr, size, direction);
}

I'd rather we not make it out-of-line without a compelling (numerical)
reason.

Cheers,
Muli

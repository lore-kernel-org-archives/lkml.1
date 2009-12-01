Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZLAQIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZLAQIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZLAQIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:08:34 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:33191 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZLAQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:08:34 -0500
Date: Tue, 1 Dec 2009 10:08:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Jonathan Miles <jon@cybus.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B14E8A2.4020500@cybus.co.uk>
Message-ID: <alpine.DEB.2.00.0912010949400.8841@router.home>
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Jonathan Miles wrote:

> On 30/11/09 18:57 Christoph Lameter said the following:
> > On Mon, 30 Nov 2009, Jonathan Miles wrote:
> >
> >> I'm running kernel 2.6.31.
> >
> > Are you using a 32 bit kernel?

32 bit kernels are forced to use memory below 1G for some allocations. You
may be running out of memory because the kernel is not able to use all of
memory.

> Yep, that's what I intended. I want to tune my workstation so that it
> doesn't need to use swap. With my workload you can assume that nearly
> all processes are loaded for a reason and that at some point I want to
> use any one of them *now*.

Anonymous page use may fluctuate unpredictably based on the processes
being started. A spike may take out your system.

> > In order to find the reason for the OOM (which has not much to do with
> > memory, the kernel has been unable to reclaim memmory for some reason)
> > you need to look at the debug output that the kernel generates.
>
> I've attached a good example which shows Xorg invoking the OOM killer
> when the page-cache is using ~1.3GB out of 2GB. My understanding from
> reading linux-mm.org is that the kernel actually prefers to swap than
> reclaim from the page-cache... is this accurate? However, what if there
> is no swap, or it's configured not to use it? Should the kernel then try
> to reclaim instead?

The kernel will prefer to reclaim from clean page cache over
swapping in general. The aggressiveness of swap can be controlled via
/proc/sys/vm/swappiness.

The OOM killer output shows that the DMA is zone is marked as
unreclaimable but the allocation causing it is not using DMA. Other zones
all seem to have enough memory. Is this straight 2.6.31? No use of
containers, memory policies etc right?



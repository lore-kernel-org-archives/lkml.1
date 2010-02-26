Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385Ab0BZQng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:43:36 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:47152 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965359Ab0BZQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:43:35 -0500
Date: Fri, 26 Feb 2010 10:43:05 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Frans Pop <elendil@planet.nl>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
Subject: Re: Memory management woes - order 1 allocation failures
In-Reply-To: <201002261633.17437.elendil@planet.nl>
Message-ID: <alpine.DEB.2.00.1002261042020.7719@router.home>
References: <201002261232.28686.elendil@planet.nl> <84144f021002260601o7ab345fer86b8bec12dbfc31e@mail.gmail.com> <201002261633.17437.elendil@planet.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Frans Pop wrote:

> On Friday 26 February 2010, Pekka Enberg wrote:
> > > Isn't it a bit strange that cache claims so much memory that real
> > > processes get into allocation failures?
> >
> > All of the failed allocations seem to be GFP_ATOMIC so it's not _that_
> > strange.
>
> It's still very ugly though. And I would say it should be unnecessary.
>
> > Dunno if anything changed recently. What's the last known good kernel for
> > you?
>
> I've not used that box very intensively in the past, but I first saw the
> allocation failure with aptitude with either .31 or .32. I would be
> extremely surprised if I could reproduce the problem with .30.
> And I have done large rsyncs to the box without any problems in the past,
> but that must have been with .24 or so kernels.
>
> It seems likely to me that it's related to all the other swap and
> allocation issues we've been seeing after .30.

Hmmm.. How long is the allocation that fails? SLUB can always fall back to
order 0 allocs if the object is < PAGE_SIZE. SLAB cannot do so if it has
decided to use a higher order slab cache for a kmalloc cache.


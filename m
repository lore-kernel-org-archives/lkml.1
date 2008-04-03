Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbYDCIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbYDCIco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYDCIce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:32:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYDCIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:32:32 -0400
Date: Thu, 3 Apr 2008 10:32:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc] SLQB: YASA
Message-ID: <20080403083231.GB20132@wotan.suse.de>
References: <20080403072550.GC25932@wotan.suse.de> <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com> <20080403075725.GA7514@wotan.suse.de> <20080403081338.GA18337@wotan.suse.de> <84144f020804030124m4cc0bc1en2e11218f1f8bdc55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804030124m4cc0bc1en2e11218f1f8bdc55@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 11:24:00AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Thu, Apr 03, 2008 at 09:57:25AM +0200, Nick Piggin wrote:
> > > It's a completely different design of the core allocator algorithms
> > > really.
> > >
> > > It probably looks quite similar because I started with slub.c, but
> > > really is just the peripheral supporting code and structure. I'm never
> > > intending to try to go through the pain of incrementally changing SLUB
> > > into SLQB. If SLQB is found to be a good idea, then it could maybe get
> > > merged.
> 
> On Thu, Apr 3, 2008 at 11:13 AM, Nick Piggin <npiggin@suse.de> wrote:
> >  And also I guess I don't think Christoph would be very happy about
> >  it :) He loves higher order allocations :)
> >
> >  The high level choices are pretty clear and I simply think there might
> >  be a better way to do it. I'm not saying it *is* better because I simply
> >  don't know, and there are areas where the tradeoffs I've made means that
> >  in some situations SLQB cannot match SLUB.
> 
> So do you disagree with Christoph's statement that we should fix page
> allocator performance instead of adding queues to SLUB?

It's not just adding queues to SLUB, by any means (SLUB effectively
already has queues anyway, with it's MIN_PARTIAL thing).

I think some page allocator performance can be improved (see my patch
to remove the atomic refcounting for example). But in other cases
the page allocator just has to do a lot more work and fixing it would
just involve removing some of those things.

> I also don't
> think higher order allocations are the answer for regular boxes but I
> can see why they're useful for HPC people with huge machines.

I don't disagree with what you say. SLQB doesn't prevent them from being
used.



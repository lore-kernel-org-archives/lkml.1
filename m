Return-Path: <linux-kernel-owner+w=401wt.eu-S1766847AbXEBTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766847AbXEBTxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766852AbXEBTxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:53:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55567 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766847AbXEBTxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:53:19 -0400
Date: Wed, 2 May 2007 21:54:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-ID: <20070502195412.GC9044@uranus.ravnborg.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com> <20070501125559.9ab42896.akpm@linux-foundation.org> <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com> <20070501133618.93793687.akpm@linux-foundation.org> <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com> <Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com> <20070502121105.de3433d5.akpm@linux-foundation.org> <Pine.LNX.4.64.0705021234470.1543@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705021234470.1543@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:42:54PM -0700, Christoph Lameter wrote:
> On Wed, 2 May 2007, Andrew Morton wrote:
> 
> > > At some point I dream that SLUB could become the default but I thought 
> > > this would take at least 6 month or so. If want to force this now then I 
> > > will certainly have some busy weeks ahead.
> > 
> > s/dream/promise/ ;)
> > 
> > Six months sounds reasonable - I was kind of hoping for less.  Make it
> > default-to-on in 2.6.23-rc1, see how it goes.
> 
> Here is how I think the future could develop
> 
> Cycle	SLAB		SLUB		SLOB		SLxB
> 
> 2.6.22	API fixes	Stabilization	API fixes
> 
> Major event: SLUB availability as experimental
> 
> 2.6.23	API upgrades	Perf. Valid.	EOL
> 
> Major events: SLUB performance validation. Switch off
> 	experimental (could even be the default) 
> 	Slab allocators support targeted reclaim for at
> 	least one slab cache (dentry?)
> 	(vacate/move all objects in a slab)

To facilitate this do NOT introduce CONFIG_SLAB until we decide
that SLUB are default. In this way we can make CONFIG_SLUB be default
and people will not continue with CONFIG_SLAB because they had it in their
.config already.
Or just rename CONFIG_SLAB to CONFIG_SLAB_DEPRECATED or something.

The point is make sure that LSUB becomes default for people that does
an make oldconfig (explicit or implicit).

	Sam

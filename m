Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZAZRhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZAZRhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZAZRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:37:44 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:60336 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZAZRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:37:44 -0500
Date: Mon, 26 Jan 2009 12:34:21 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090123161017.GC14517@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0901261230540.1908@qirst.com>
References: <20090114150900.GC25401@wotan.suse.de> <Pine.LNX.4.64.0901141158090.26507@quilx.com> <20090115060330.GB17810@wotan.suse.de> <Pine.LNX.4.64.0901151320250.26467@quilx.com> <20090116031940.GL17810@wotan.suse.de> <Pine.LNX.4.64.0901161500080.27283@quilx.com>
 <20090119054730.GA22584@wotan.suse.de> <alpine.DEB.1.10.0901211914140.18367@qirst.com> <20090123041756.GH20098@wotan.suse.de> <alpine.DEB.1.10.0901231042380.32253@qirst.com> <20090123161017.GC14517@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nick Piggin wrote:

> > SLUB can directly free an object to any slab page. "Queuing" on free via
> > the per cpu slab is only possible if the object came from that per cpu
> > slab. This is typically only the case for objects that were recently
> > allocated.
>
> Ah yes ok that's right. But then you don't get LIFO allocation
> behaviour for those cases.

But you get more TLB local allocations.

> > > hot objects when you switch to different "fast" pages. I don't consider
> > > this to be "queueing done right".
> >
> > Yes you can loose track of caching hot objects. That is one of the
> > concerns with the SLUB approach. On the other hand: Caching architectures
> > get more and more complex these days (especially in a NUMA system). The
>
> Because it is more important to get good cache behaviour.

Its going to be quite difficult to realize algorithm that guestimate what
information the processor keeps in its caches. The situation is quite
complex in NUMA systems.

> So I think it is wrong to say it requires more metadata handling. SLUB
> will have to switch pages more often or free objects to pages other than
> the "fast" page (what do you call it?), so quite often I think you'll
> find SLUB has just as much if not more metadata handling.

Its the per cpu slab. SLUB does not switch pages often but frees objects
not from the per cpu slab directly with minimal overhead compared to a per
cpu slab free. The overhead is much less than the SLAB slowpath which has
to be taken for alien caches etc.


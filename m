Return-Path: <linux-kernel-owner+w=401wt.eu-S1422940AbXCBGJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422940AbXCBGJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422941AbXCBGJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:09:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:34319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422940AbXCBGJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:09:07 -0500
Date: Fri, 2 Mar 2007 07:08:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302060831.GF15867@wotan.suse.de>
References: <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com> <20070302035751.GA15867@wotan.suse.de> <Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com> <20070302042149.GB15867@wotan.suse.de> <Pine.LNX.4.64.0703012022320.14299@schroedinger.engr.sgi.com> <20070302050625.GD15867@wotan.suse.de> <Pine.LNX.4.64.0703012137580.1768@schroedinger.engr.sgi.com> <20070302054944.GE15867@wotan.suse.de> <Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 09:53:42PM -0800, Christoph Lameter wrote:
> On Fri, 2 Mar 2007, Nick Piggin wrote:
> 
> > > You do not have to deal with TLB entries if you do buffered I/O.
> > 
> > Where does the data come from?
> 
> >From the I/O controller and from the application. 

Why doesn't the application need to deal with TLB entries?


> > > We currently have problems with the kernel limits of 128 SG 
> > > entries but the fundamental issue is that we can only do 2 Meg of I/O in 
> > > one go given the default limits of the block layer. Typically the number 
> > > of hardware SG entrie is also limited. We never will be able to put a 
> > 
> > Seems like changing the default limits would be the easiest way to
> > fix it then?
> 
> This would only be a temporary fix pushing the limits to the double or so?

And using slightly larger page sizes isn't?

> > As far as hardware limits go, I don't think you need to scale that
> > number linearly with the amount of memory you have, or even with the
> > IO throughput. You should reach a point where your command overhead
> > is amortised sufficiently, and the controller will be pipelining the
> > commands.
> 
> Amortized? The controller still would have to hunt down the 4kb page 
> pieces that we have to feed him right now. Result: Huge scatter gather 
> lists that may themselves create issues with higher page order.

What sort of numbers do you have for these controllers that aren't
very good at doing sg?

Isn't the issue was something like your IO controllers have only a
limited number of sg entries, which is fine with 16K pages, but with
4K pages that doesn't give enough data to cover your RAID stripe?

We're never going to do a variable sized pagecache just because of that.


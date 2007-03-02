Return-Path: <linux-kernel-owner+w=401wt.eu-S1422658AbXCBIiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422658AbXCBIiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 03:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXCBIiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 03:38:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658AbXCBIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 03:38:53 -0500
Date: Fri, 2 Mar 2007 09:38:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302083832.GF5557@wotan.suse.de>
References: <20070302054944.GE15867@wotan.suse.de> <Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com> <20070302060831.GF15867@wotan.suse.de> <Pine.LNX.4.64.0703012213130.1917@schroedinger.engr.sgi.com> <20070302062950.GG15867@wotan.suse.de> <Pine.LNX.4.64.0703012236160.1979@schroedinger.engr.sgi.com> <20070302071955.GA5557@wotan.suse.de> <Pine.LNX.4.64.0703012335250.13224@schroedinger.engr.sgi.com> <20070302081210.GD5557@wotan.suse.de> <Pine.LNX.4.64.0703020015080.14651@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703020015080.14651@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 12:21:49AM -0800, Christoph Lameter wrote:
> On Fri, 2 Mar 2007, Nick Piggin wrote:
> 
> > > If there are billions of pages in the system and we are allocating and 
> > > deallocating then pages need to be aged. If there are just few pages 
> > > freeable then we run into issues.
> > 
> > page writeout and vmscan don't work too badly. What are the issues?
> 
> Slow downs up to livelocks with large memory configurations.
> 
> > So what problems that you commonly see now? Some of us here don't
> > have 4TB of memory, so you actually have to tell us ;)
> 
> Oh just run a 32GB SMP system with sparsely freeable pages and lots of 
> allocs and frees and you will see it too. F.e try Linus tree and mlock 
> a large portion of the memory and then see the fun starting. See also 
> Rik's list of pathological cases on this.

Ah, so your problem is lots of unreclaimable pages. There are heaps
of things we can try to reduce the rate at which we scan those.


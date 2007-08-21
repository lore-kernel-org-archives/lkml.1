Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXHUAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXHUAcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXHUAcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:32:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:37116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXHUAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:32:13 -0400
Date: Tue, 21 Aug 2007 02:32:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Message-ID: <20070821003212.GC8414@wotan.suse.de>
References: <20070814142103.204771292@sgi.com> <20070815122253.GA15268@wotan.suse.de> <1187183526.6114.45.camel@twins> <20070816032921.GA32197@wotan.suse.de> <1187581894.6114.169.camel@twins> <Pine.LNX.4.64.0708201210440.29092@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201210440.29092@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 12:15:01PM -0700, Christoph Lameter wrote:
> On Mon, 20 Aug 2007, Peter Zijlstra wrote:
> 
> > > > <> What Christoph is proposing is doing recursive reclaim and not
> > > > initiating writeout. This will only work _IFF_ there are clean pages
> > > > about. Which in the general case need not be true (memory might be
> > > > packed with anonymous pages - consider an MPI cluster doing computation
> > > > stuff). So this gets us a workload dependant solution - which IMHO is
> > > > bad!
> > > 
> > > Although you will quite likely have at least a couple of MB worth of
> > > clean program text. The important part of recursive reclaim is that it
> > > doesn't so easily allow reclaim to blow all memory reserves (including
> > > interrupt context). Sure you still have theoretical deadlocks, but if
> > > I understand correctly, they are going to be lessened. I would be
> > > really interested to see if even just these recursive reclaim patches
> > > eliminate the problem in practice.
> > 
> > were we much bothered by the buffered write deadlock? - why accept a
> > known deadlock if a solid solution is quite attainable?
> 
> Buffered write deadlock? How does that exactly occur? Memory allocation in 
> the writeout path while we hold locks?

Different topic. Peter was talking about the write(2) write deadlock
where we take a page fault while holding a page lock (which leads to
lock inversion, taking the lock twice etc.)


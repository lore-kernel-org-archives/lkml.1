Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXIKHlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXIKHlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbXIKHl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:41:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbXIKHl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:41:27 -0400
Date: Tue, 11 Sep 2007 09:41:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Message-ID: <20070911074125.GA27679@wotan.suse.de>
References: <20070814142103.204771292@sgi.com> <200709050220.53801.phillips@phunq.net> <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com> <20070905114242.GA19938@wotan.suse.de> <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com> <20070905121937.GA9246@wotan.suse.de> <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 12:29:32PM -0700, Christoph Lameter wrote:
> On Wed, 5 Sep 2007, Nick Piggin wrote:
> 
> > Implementation issues aside, the problem is there and I would like to
> > see it fixed regardless if some/most/or all users in practice don't
> > hit it.
> 
> I am all for fixing the problem but the solution can be much simpler and 
> more universal. F.e. the amount of tcp data in flight may be controlled 
> via some limit so that other subsystems can continue to function even if 
> we are overwhelmed by network traffic. Peter's approach establishes the 
> limit by failing PF_MEMALLOC allocations. If that occurs then other 

Can you to propose a solution that is much simpler and more universal?


> subsystems (like the disk, or even fork/exec or memory management 
> allocation) will no longer operate since their allocations no longer 
> succeed which will make the system even more fragile and may lead to 
> subsequent failures.

You're saying we shouldn't fix an out of memory deadlocks because
that might result in ENOMEM errors being returned, rather than the
system locking up?


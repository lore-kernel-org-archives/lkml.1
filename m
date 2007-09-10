Return-Path: <linux-kernel-owner+w=401wt.eu-S1761015AbXIJT3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015AbXIJT3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXIJT3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:29:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49240 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822AbXIJT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:29:32 -0400
Date: Mon, 10 Sep 2007 12:29:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Daniel Phillips <phillips@phunq.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
In-Reply-To: <20070905121937.GA9246@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0709101225350.24735@schroedinger.engr.sgi.com>
References: <20070814142103.204771292@sgi.com> <200709050220.53801.phillips@phunq.net>
 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
 <20070905114242.GA19938@wotan.suse.de> <Pine.LNX.4.64.0709050507050.9141@schroedinger.engr.sgi.com>
 <20070905121937.GA9246@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007, Nick Piggin wrote:

> Implementation issues aside, the problem is there and I would like to
> see it fixed regardless if some/most/or all users in practice don't
> hit it.

I am all for fixing the problem but the solution can be much simpler and 
more universal. F.e. the amount of tcp data in flight may be controlled 
via some limit so that other subsystems can continue to function even if 
we are overwhelmed by network traffic. Peter's approach establishes the 
limit by failing PF_MEMALLOC allocations. If that occurs then other 
subsystems (like the disk, or even fork/exec or memory management 
allocation) will no longer operate since their allocations no longer 
succeed which will make the system even more fragile and may lead to 
subsequent failures.


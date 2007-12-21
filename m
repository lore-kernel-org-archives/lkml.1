Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbXLUQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbXLUQpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXLUQp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:45:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbXLUQp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:45:28 -0500
Date: Fri, 21 Dec 2007 08:44:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu>
 <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Dec 2007, Christoph Lameter wrote:
> 
> So we have 3 different regimes here (order 0):
[ ... ]
> The regression is contained because:
[ ... ]

Christoph, *NONE* of these arguments matter at all.

The only thing that matters is the simple fact that real-life benchmarks 
show that SLUB is worse. It doesn't matter one whit that you can say that 
it's better under some circumstance that either isn't triggered, or when 
setting unrealistic and unusable parameters (ie big internal slab orders).

> We could address this issue by:
[...]
> But given all the boundaries for the contention I would think that it is 
> not worth addressing. 

.. and this seems to be the single biggest reason to just say "revert SLUB 
entirely".

If you aren't even motivated to fix the problems that have been reported, 
then SLUB isn't even a _potential_ solution, it's purely a problem, and 
since I am not IN THE LEAST interested in having three different 
allocators around, SLUB is going to get axed.

In other words, here's the low-down:

 a) either SLUB can replace SLAB, or SLUB is going away

    This isn't open for discussion, Christoph. This was the rule back when 
    it got merged in the first place.

 b) if SLUB performs worse than SLAB on real loads (TPC-C certainly being 
    one, and while hackbench may be borderline, it's certainly less 
    borderline than others), then SLUB cannot replace SLAB.

    See (a)

 c) If you aren't even interested in trying to fix it and are ignoring 
    the reports, there is not even a _potential_ for SLUB for getting over 
    these problems, and I should disable it and we should get over it as 
    soon as possible, and this whole discussion is pretty much ended.

See? It really is that simple. Either you say "Hell yes, I'll fix it", or 
SLUB goes away. There simply is no orther choice.

When you say "not worth addressing", that to me is a clear an unambiguous 
"let's remove SLUB".

The main reason for SLUB in the first place was SGI concerns. You seem to 
think that _only_ SGI concerns matter. Wrong. If SLUB remains a SGI-only 
thing and you don't fix it for other users, then SLUB gets reverted from 
the standard kernel.

That's all. And it's not really worth discussing. 

			Linus



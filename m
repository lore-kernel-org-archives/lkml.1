Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXGJGXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXGJGXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXGJGW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:22:58 -0400
Received: from waste.org ([66.93.16.53]:56003 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXGJGW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:22:57 -0400
Date: Tue, 10 Jul 2007 01:22:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070710062215.GE11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com> <4692E3BF.9010305@yahoo.com.au> <Pine.LNX.4.64.0707091849590.2860@schroedinger.engr.sgi.com> <4692E7D4.6060909@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4692E7D4.6060909@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:58:44AM +1000, Nick Piggin wrote:
> Christoph Lameter wrote:
> >On Tue, 10 Jul 2007, Nick Piggin wrote:
> >
> >
> >>>O(n) memory savings? What is that?
> >>
> >>Allocate n things and your memory waste is proportional to n (well that's
> >>O(n) waste, so I guess by savings I mean that SLOB's memory saving 
> >>compared
> >>to SLUB are proportional to n).
> >
> >
> >n is the size of the object?
> 
> n things -- n number of things (n calls to kmem_cache_alloc()).
> 
> Just a fancy way of saying roughly that memory waste will increase as
> the size of the system increases. But that aspect of it I think is
> not really a problem for non-tiny systems anyway because the waste
> tends not to be too bad (and possibly the number of active allocations
> does not increase O(n) with the size of RAM either).

If active allocations doesn't increase O(n) with the size of RAM,
what's all that RAM for?

If your memory isn't getting used for large VMAs or large amounts of
page cache, that means it's getting used by task structs,
radix_tree_nodes, sockets, dentries, inodes, etc.

-- 
Mathematics is the supreme nostalgia of our time.

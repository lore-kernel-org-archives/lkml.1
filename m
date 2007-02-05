Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXBEQwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXBEQwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXBEQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:52:16 -0500
Received: from waste.org ([66.93.16.53]:41013 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbXBEQwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:52:15 -0500
Date: Mon, 5 Feb 2007 10:38:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Message-ID: <20070205163847.GI16722@waste.org>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> <20070203005316.eb0b4042.akpm@linux-foundation.org> <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com> <1170525860.3073.1054.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com> <20070203172242.e5bf2534.akpm@linux-foundation.org> <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com> <1170576977.3073.1100.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com> <1170664774.3073.1236.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170664774.3073.1236.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 09:39:34AM +0100, Arjan van de Ven wrote:
> On Sun, 2007-02-04 at 23:57 -0800, Christoph Lameter wrote:
> > Hmmm.. I have had no time to test this one yet but I think this should 
> > work. It uses the delayed method and a new page flag PageMlocked() with 
> > different semantics. Fix for page migration is also included.
> > 
> > Patch avoids to put new anonymous mlocked pages on the LRU. Maybe the same 
> > could be done for new pagecache pages?
> > 
> > I still need a solution for the problem of not having enough page flag 
> > bits on i386 NUMA.
> 
> I still don't get why you *really* need such a bit. 

There are three possibilities mentioned so far:

1) slow accounting - scan each attached VMA on each mmap/munmap
2) lazy accounting - the same as above, with the work all moved to the
LRU sweep
3) accounting with an extra page flag - still needs to scan VMAs on munmap

Christoph seems to prefer the third.

I wonder if we couldn't stick a rough counter in address_space to
fast-path the slow accounting - we'll typically only have 0 or 1 locks
active.

-- 
Mathematics is the supreme nostalgia of our time.

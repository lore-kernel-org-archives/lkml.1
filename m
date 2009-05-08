Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbZEHW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbZEHW4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEHW4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:56:04 -0400
Received: from ultra7.eskimo.com ([204.122.16.70]:2562 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZEHW4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:56:04 -0400
Date: Fri, 8 May 2009 15:53:49 -0700
From: Elladan <elladan@eskimo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, fengguang.wu@intel.com,
       hannes@cmpxchg.org, peterz@infradead.org, riel@redhat.com,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org,
       elladan@eskimo.com, npiggin@suse.de, cl@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090508225349.GA9883@eskimo.com>
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090508230045.5346bd32@lxorguk.ukuu.org.uk> <20090508151532.6769e702.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508151532.6769e702.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 03:15:32PM -0700, Andrew Morton wrote:
> On Fri, 8 May 2009 23:00:45 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > The patch seems reasonable but the changelog and the (non-existent)
> > > design documentation could do with a touch-up.
> > 
> > Is it right that I as a user can do things like mmap my database
> > PROT_EXEC to get better database numbers by making other
> > stuff swap first ?
> >
> > You seem to be giving everyone a "nice my process up" hack.
> 
> Yep.
> 
> But prior to 2.6.27(?) the same effect could be had by mmap()ing the
> file with or without PROT_EXEC.  The patch restores a
> probably-beneficial heuristic which got lost in the LRU rewrite.
> 
> So we're no worse than pre-2.6.27 kernels here.  Plus there are
> probably more effective ways of getting that sort of boost, such as
> having a process running which simply touches your favoured pages
> at a suitable (and fairly low) frequency.

An example of a process which does this automatically is the Java virtual
machine (and probably other runtimes which use a mark and sweep type GC).

You can see this in practice pretty easily -- a jvm process will automatically
keep its memory paged in, even under strong VM pressure.

-E

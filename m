Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXGIV55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXGIV55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbXGIV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:57:51 -0400
Received: from waste.org ([66.93.16.53]:56689 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbXGIV5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:57:49 -0400
Date: Mon, 9 Jul 2007 16:57:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070709215724.GV11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708110224.9cd9df5b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 11:02:24AM -0700, Andrew Morton wrote:
> Guys, look at this the other way.  Suppose we only had slub, and someone
> came along and said "here's a whole new allocator which saves 4.5k of
> text", would we merge it on that basis?  Hell no, it's not worth it.  What
> we might do is to get motivated to see if we can make slub less porky under
> appropriate config settings.

Well I think we would obviously throw out SLAB and SLUB if they
weren't somewhat faster than SLOB. They're much more problematic and
one of the big features that Christoph's pushing is a fix for a
problem that SLOB simply doesn't have: huge numbers of SLAB/SLUB pages
being held down by small numbers of objects. 

> Let's not get sentimental about these things: in general, if there's any
> reasonable way in which we can rid ourselves of any code at all, we should
> do so, no?

I keep suggesting a Voyager Replacement Fund, but James isn't
interested.

But seriously, I don't think it should be at all surprising that the
allocator that's most appropriate for machines with < 32MB of RAM is
different than the one for machines with > 1TB of RAM.

The maintenance overhead of SLOB is fairly minimal. The biggest
outstanding SLOB problem is nommu's rather broken memory size
reporting.

-- 
Mathematics is the supreme nostalgia of our time.

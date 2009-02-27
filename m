Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZB0Ldt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZB0Ldt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZB0Ldk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:33:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZB0Ldj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:33:39 -0500
Date: Fri, 27 Feb 2009 12:33:33 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
Message-ID: <20090227113333.GA21296@wotan.suse.de>
References: <20090223233030.GA26562@csn.ul.ie> <20090223155313.abd41881.akpm@linux-foundation.org> <20090224115126.GB25151@csn.ul.ie> <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie> <20090225081954.8776ba9b.akpm@linux-foundation.org> <20090226163751.GG32756@csn.ul.ie> <alpine.DEB.1.10.0902261157100.7472@qirst.com> <20090226171549.GH32756@csn.ul.ie> <alpine.DEB.1.10.0902261226370.26440@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902261226370.26440@qirst.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:30:45PM -0500, Christoph Lameter wrote:
> On Thu, 26 Feb 2009, Mel Gorman wrote:
> 
> > > I tried the general use of a pool of zeroed pages back in 2005. Zeroing
> > > made sense only if the code allocating the page did not immediately touch
> > > the cachelines of the page.
> >
> > Any feeling as to how often this was the case?
> 
> Not often enough to justify the merging of my patches at the time. This
> was publicly discussed on lkml:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/0482.html
> 
> > Indeed, any gain if it existed would be avoiding zeroing the pages used
> > by userspace. The cleanup would be reducing the amount of
> > architecture-specific code.
> >
> > I reckon it's worth an investigate but there is still other lower-lying
> > fruit.
> 
> I hope we can get rid of various ugly elements of the quicklists if the
> page allocator would offer some sort of support. I would think that the

Only if it provides significant advantages over existing quicklists or
adds *no* extra overhead to the page allocator common cases. :)
 

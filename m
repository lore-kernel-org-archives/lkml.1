Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZCDJII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZCDJII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZCDJHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:07:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:50085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZCDJHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:07:52 -0500
Date: Wed, 4 Mar 2009 10:07:40 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Lin Ming <ming.m.lin@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
Message-ID: <20090304090740.GA27043@wotan.suse.de>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie> <1235647139.16552.34.camel@penberg-laptop> <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr> <20090302112122.GC21145@csn.ul.ie> <1236132307.2567.25.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236132307.2567.25.camel@ymzhang>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 10:05:07AM +0800, Zhang, Yanmin wrote:
> On Mon, 2009-03-02 at 11:21 +0000, Mel Gorman wrote:
> > (Added Ingo as a second scheduler guy as there are queries on tg_shares_up)
> > 
> > On Fri, Feb 27, 2009 at 04:44:43PM +0800, Lin Ming wrote:
> > > On Thu, 2009-02-26 at 19:22 +0800, Mel Gorman wrote: 
> > > > In that case, Lin, could I also get the profiles for UDP-U-4K please so I
> > > > can see how time is being spent and why it might have gotten worse?
> > > 
> > > I have done the profiling (oltp and UDP-U-4K) with and without your v2
> > > patches applied to 2.6.29-rc6.
> > > I also enabled CONFIG_DEBUG_INFO so you can translate address to source
> > > line with addr2line.
> > > 
> > > You can download the oprofile data and vmlinux from below link,
> > > http://www.filefactory.com/file/af2330b/
> > > 
> > 
> > Perfect, thanks a lot for profiling this. It is a big help in figuring out
> > how the allocator is actually being used for your workloads.
> > 
> > The OLTP results had the following things to say about the page allocator.
> In case we might mislead you guys, I want to clarify that here OLTP is
> sysbench (oltp)+mysql, not the famous OLTP which needs lots of disks and big
> memory.
> 
> Ma Chinang, another Intel guy, does work on the famous OLTP running.

OK, so my comments WRT cache sensitivity probably don't apply here,
but probably cache hotness of pages coming out of the allocator
might still be important for this one.

How many runs are you doing of these tests? Do you have a fairly high
confidence that the changes are significant?


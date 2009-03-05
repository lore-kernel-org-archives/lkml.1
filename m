Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZCEB5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZCEB5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZCEB5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:57:08 -0500
Received: from mga05.intel.com ([192.55.52.89]:25219 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753985AbZCEB5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:57:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,304,1233561600"; 
   d="scan'208";a="436288669"
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>, Lin Ming <ming.m.lin@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090304090740.GA27043@wotan.suse.de>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr>
	 <20090302112122.GC21145@csn.ul.ie> <1236132307.2567.25.camel@ymzhang>
	 <20090304090740.GA27043@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 09:56:38 +0800
Message-Id: <1236218198.2567.119.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 10:07 +0100, Nick Piggin wrote:
> On Wed, Mar 04, 2009 at 10:05:07AM +0800, Zhang, Yanmin wrote:
> > On Mon, 2009-03-02 at 11:21 +0000, Mel Gorman wrote:
> > > (Added Ingo as a second scheduler guy as there are queries on tg_shares_up)
> > > 
> > > On Fri, Feb 27, 2009 at 04:44:43PM +0800, Lin Ming wrote:
> > > > On Thu, 2009-02-26 at 19:22 +0800, Mel Gorman wrote: 
> > > > > In that case, Lin, could I also get the profiles for UDP-U-4K please so I
> > > > > can see how time is being spent and why it might have gotten worse?
> > > > 
> > > > I have done the profiling (oltp and UDP-U-4K) with and without your v2
> > > > patches applied to 2.6.29-rc6.
> > > > I also enabled CONFIG_DEBUG_INFO so you can translate address to source
> > > > line with addr2line.
> > > > 
> > > > You can download the oprofile data and vmlinux from below link,
> > > > http://www.filefactory.com/file/af2330b/
> > > > 
> > > 
> > > Perfect, thanks a lot for profiling this. It is a big help in figuring out
> > > how the allocator is actually being used for your workloads.
> > > 
> > > The OLTP results had the following things to say about the page allocator.
> > In case we might mislead you guys, I want to clarify that here OLTP is
> > sysbench (oltp)+mysql, not the famous OLTP which needs lots of disks and big
> > memory.
> > 
> > Ma Chinang, another Intel guy, does work on the famous OLTP running.
> 
> OK, so my comments WRT cache sensitivity probably don't apply here,
> but probably cache hotness of pages coming out of the allocator
> might still be important for this one.
Yes. We need check it.

> 
> How many runs are you doing of these tests?
We start sysbench with different thread number, for example, 8 12 16 32 64 128 for
4*4 tigerton, then get an average value in case there might be a scalability issue.

As for this sysbench oltp testing, we reran it for 7 times on tigerton this week and
found the results have fluctuations. Now we could only say there is a trend that
the result with the pathces is a little worse than the one without the patches.

>  Do you have a fairly high
> confidence that the changes are significant?
2% isn't significant on sysbench oltp.

yanmin



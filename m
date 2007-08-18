Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbXHRRVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbXHRRVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXHRRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:21:26 -0400
Received: from waste.org ([66.93.16.53]:50334 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXHRRV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:21:26 -0400
Date: Sat, 18 Aug 2007 12:22:26 -0500
From: Matt Mackall <mpm@selenic.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages
Message-ID: <20070818172225.GR30556@waste.org>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org> <20070818024831.GA7856@mail.ustc.edu.cn> <20070818064042.GQ30556@waste.org> <20070818084531.GB5277@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818084531.GB5277@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 04:45:31PM +0800, Fengguang Wu wrote:
> Matt,
> 
> On Sat, Aug 18, 2007 at 01:40:42AM -0500, Matt Mackall wrote:
> > > - On memory pressure,
> > >   - as VSZ goes up, RSS will be bounded by physical memory.
> > >     So VSZ:RSS ratio actually goes up with memory pressure.
> > 
> > And yes.
> > 
> > But that's not what I'm talking about. You're likely to have more
> > holes in your ranges with memory pressure as things that aren't active
> > get paged or swapped out and back in. And because we're walking the
> > LRU more rapidly, we'll flip over a lot of the active bits more often
> > which will mean more output.
> > 
> > >   - page range is a good unit of locality. They are more likely to be
> > >     reclaimed as a whole. So (RSS:page_ranges) wouldn't degrade as much.
> > 
> > There is that. The relative magnitude of the different effects is
> > unclear. But it is clear that the worst case for pmap is much worse
> 
> > than pagemap (two lines per page of RSS?). 
> It's one line per page. No sane app will make vmas proliferate.

Sane apps are few and far between.
 
> So let's talk about the worst case.
> 
> pagemap's data set size is determined by VSZ.
> 4GB VSZ means 1M PFNs, hence 8MB pagemap data.
> 
> pmaps's data set size is bounded by RSS hence physical memory.
> 4GB RSS means up to 1M page ranges, hence ~20M pmaps data.
> Not too bad :)

Hmmm, I've been misreading the output.

What does it do with nonlinear VMAs?

-- 
Mathematics is the supreme nostalgia of our time.

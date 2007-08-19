Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbXHSAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbXHSAk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 20:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXHSAkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 20:40:18 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52726 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753549AbXHSAkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 20:40:17 -0400
Message-ID: <387484009.29198@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 19 Aug 2007 08:40:09 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070819004008.GA5297@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org> <20070818024831.GA7856@mail.ustc.edu.cn> <20070818064042.GQ30556@waste.org> <20070818084531.GB5277@mail.ustc.edu.cn> <20070818172225.GR30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818172225.GR30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 12:22:26PM -0500, Matt Mackall wrote:
> > > >     So VSZ:RSS ratio actually goes up with memory pressure.
> > > 
> > > And yes.
> > > 
> > > But that's not what I'm talking about. You're likely to have more
> > > holes in your ranges with memory pressure as things that aren't active
> > > get paged or swapped out and back in. And because we're walking the
> > > LRU more rapidly, we'll flip over a lot of the active bits more often
> > > which will mean more output.
> > > 
> > > >   - page range is a good unit of locality. They are more likely to be
> > > >     reclaimed as a whole. So (RSS:page_ranges) wouldn't degrade as much.
> > > 
> > > There is that. The relative magnitude of the different effects is
> > > unclear. But it is clear that the worst case for pmap is much worse
> > 
> > > than pagemap (two lines per page of RSS?). 
> > It's one line per page. No sane app will make vmas proliferate.
> 
> Sane apps are few and far between.

Very likely, and they will bloat maps/smaps/pmaps alike :(

> > So let's talk about the worst case.
> > 
> > pagemap's data set size is determined by VSZ.
> > 4GB VSZ means 1M PFNs, hence 8MB pagemap data.
> > 
> > pmaps's data set size is bounded by RSS hence physical memory.
> > 4GB RSS means up to 1M page ranges, hence ~20M pmaps data.
> > Not too bad :)
> 
> Hmmm, I've been misreading the output.
> 
> What does it do with nonlinear VMAs?

The implementation gets offset from page_index(page), so will work
the same way in linear/nonlinear VMAs. Depending how one does the
remap_file_ranges() calls, the output lines may be not strictly
ordered by offset, or overlap, or have small page ranges. 


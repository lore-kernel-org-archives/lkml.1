Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbXHRIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbXHRIpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXHRIph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 04:45:37 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52917 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750967AbXHRIpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 04:45:36 -0400
Message-ID: <387426732.29114@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 18 Aug 2007 16:45:31 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       John Berthels <jjberthels@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in
	granularity of pages
Message-ID: <20070818084531.GB5277@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn> <20070816220849.472883642@mail.ustc.edu.cn> <20070817023846.GJ30556@waste.org> <20070817064727.GA6723@mail.ustc.edu.cn> <20070817165808.GM30556@waste.org> <20070818024831.GA7856@mail.ustc.edu.cn> <20070818064042.GQ30556@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818064042.GQ30556@waste.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Sat, Aug 18, 2007 at 01:40:42AM -0500, Matt Mackall wrote:
> > - On memory pressure,
> >   - as VSZ goes up, RSS will be bounded by physical memory.
> >     So VSZ:RSS ratio actually goes up with memory pressure.
> 
> And yes.
> 
> But that's not what I'm talking about. You're likely to have more
> holes in your ranges with memory pressure as things that aren't active
> get paged or swapped out and back in. And because we're walking the
> LRU more rapidly, we'll flip over a lot of the active bits more often
> which will mean more output.
> 
> >   - page range is a good unit of locality. They are more likely to be
> >     reclaimed as a whole. So (RSS:page_ranges) wouldn't degrade as much.
> 
> There is that. The relative magnitude of the different effects is
> unclear. But it is clear that the worst case for pmap is much worse

> than pagemap (two lines per page of RSS?). 
It's one line per page. No sane app will make vmas proliferate.

So let's talk about the worst case.

pagemap's data set size is determined by VSZ.
4GB VSZ means 1M PFNs, hence 8MB pagemap data.

pmaps's data set size is bounded by RSS hence physical memory.
4GB RSS means up to 1M page ranges, hence ~20M pmaps data.
Not too bad :)

> > > But there are still the downsides I have mentioned:
> > > 
> > > - you don't get page frame numbers
> > 
> > True. I guess PFNs are meaningless to a normal user?
> 
> They're useful for anyone who's trying to look at the system as a
> whole.
>  
> > > - you can't do random access
> > 
> > Not for now.
> > 
> > It would be trivial to support seek-by-address semantic: the seqfile
> > operations already iterate by addresses. Only that we cannot do it via
> > the regular read/pread/seek interfaces. They have different semantic
> > on fpos. However, tricks like ioctl(begin_addr, end_addr) can be
> > employed if necessary.
> 
> I suppose. But if you're willing to stomach that sort of thing, you
> might as well use a simple binary interface.

Python can do ioctl() :)

Anyway it's already a special interface.


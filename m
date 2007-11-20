Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbXKTMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbXKTMYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXKTMYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:24:44 -0500
Received: from mail.vapor.com ([85.114.133.49]:33344 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854AbXKTMYn (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:24:43 -0500
X-Greylist: delayed 1145 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 07:24:43 EST
Date: Tue, 20 Nov 2007 13:05:33 +0100
From: iank@bredband.net
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: pomac@vapor.com, Linux-kernel@vger.kernel.org
Subject: Re: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
Message-ID: <20071120120533.GA25851@pomac.netswarm.net>
References: <1195520355.8601.14.camel@localhost> <200711201513.36711.nickpiggin@yahoo.com.au> <1195549767.8601.22.camel@localhost> <200711202147.32354.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711202147.32354.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 09:47:32PM +1100, Nick Piggin wrote:
> On Tuesday 20 November 2007 20:09, Ian Kumlien wrote:
> > On tis, 2007-11-20 at 15:13 +1100, Nick Piggin wrote:
> 
> > > It's also used up all your 2.5GB of swap. The output of your `free` shows
> > > a fair bit of disk cache there, but it also shows a lot of swap free,
> > > which isn't the case at oom-time.
> >
> > Yes, as i said those was from several hours later...
> 
> OK, missed that.

It all happened at home while i was at work and the machine there went
down due to hardware failure, so i have no logs at all.
(It has a maxtor disk that sometimes just hangs... )

> > > Unfortunately, we don't show NR_ANON_PAGES in these stats, but at a
> > > guess, I'd say that the file cache is mostly shrunk and you still don't
> > > have enough memory. trackerd probably has a memory leak in it, or else is
> > > just trying to allocate more memory than you have. Is this a regression?
> >
> > I have had it happen twice before, without tracker running...
> 
> Does the machine recover afterward, or is the memory freed up after
> the OOM kill? How about if you kill X and do a sysrq+E then sysrq+I
> (to kill all tasks)?

Yes it recovers, it only happens during high I/O with rtorrent.
In this case, downloading a 8gb image at ~6mb/s.

> If the memory still isn't freed after that, then we could have a
> kernel memory leak.

I don't think it's a kernel memoryleak, my suspicion is that the kernel,
for some reason, doesn't want to return the cache when it needs more
memory. Perhaps due to the read and write patterns that rtorrent
creates.

> > It didn't quite get to the oom stage, it just failed alot of allocations
> > while having 1.5 or more memory locked in cache.
> >
> > http://marc.info/?l=linux-kernel&m=118895576924867&w=2
> 
> OK, yes this is a different case, and it is very far off the OOM
> killing stage. Atomic allocations can fail quite easily, but
> kswapd will have started up and will start freeing memory.

Ok, this ONLY happens with rtorrent and large images...
I'll try to reproduce it locally as soon as my schedule permits.

> Actually there are some patches gone into 2.6.24 that have fixed
> some corner cases with the network stack making order-1 allocations
> when it should be order-0. That might help your atomic allocation
> failures, but they aren't really a bug anyway (unless networking
> fails to recover).

Yeah, i remember reading about that, thats why i upgraded =)

> Thanks for reporting all this...

I just hope that something worthwhile comes out of it =)

PS. Perhaps i should have mentioned that all writes goes to a RAID5
array. but i doubt it matters..
DS.

Wow, i really need caffine =)

I/O, I/O, I/O off to work I go

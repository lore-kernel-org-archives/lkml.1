Return-Path: <linux-kernel-owner+w=401wt.eu-S1030312AbXBTRLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030312AbXBTRLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030301AbXBTRLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:11:54 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36762 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312AbXBTRLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:11:53 -0500
Date: Tue, 20 Feb 2007 20:11:20 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070220171120.GD24930@2ka.mipt.ru>
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru> <20070220170232.GA4730@outpost.ds9a.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070220170232.GA4730@outpost.ds9a.nl>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 20 Feb 2007 20:11:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 06:02:32PM +0100, bert hubert (bert.hubert@netherlabs.nl) wrote:
> On Tue, Feb 20, 2007 at 07:41:25PM +0300, Evgeniy Polyakov wrote:
> 
> > It can be recvfrom only problem - syscall overhead on my p4 (core duo,
> > debian testing) is bout 300 usec - to test I ran read('dev/zero', &data,
> > 0) in a loop.
> 
> nsec I assume?

Yes, sure - mistyped - it is about 300 nanoseconds (280-290 or so).

> The usec numbers for read(fd, &c, 0) where fd is /dev/zero:
> 1.557667, 0.627667, 0.447333, 0.440000, 0.440000, 0.440000, 0.442333,
> 0.440000, 0.440000, 0.442333, 0.442333, 0.440000, 0.440000, 0.442333,
> 0.442667, 0.440000, 0.440000, 0.440000, 0.442333, 0.442667,
> 
> In usecs. Notice the same declining figure, but not as pronounced. With a
> sleep(1) in between, we get:
> 1.692667, 1.800000, 0.782667, 1.282667, 0.665000, 0.980000, 0.925000,
> 0.887667, 0.662667, 0.862667, 1.077333, 1.442333, 0.660000, 1.890000,
> 0.672333, 0.795000, 0.647667, 0.692333, 0.750000, 0.865000,
> 
> This doesn't look all that unhealthy.
> 
> > Could you try to hack recvfrom() for your socket to always copy some
> > empty buffer and check the results without waiting for packet?
> 
> That might be out of my reach before tomorrow :-)

I would try it today - but it is a bit late in Moscow already - and
there are some things to complete yet. So, tomorrow I will create a patch
and run it, but I seriously doubt that there is _that_ high per-recvfrom 
latency.

> > If you are not hurry I can test it myself tomorrow.
> 
> Thanks. My major problem is that in my measurements, I quite often see the
> 'worst case' 4usec result. It would not be a problem if it happens only
> once, of course.

Depending on how frequent is 'quite often' - if it ever changes the
distribution picture, then there is some problem.

> 	Bert

-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S934090AbYCFNzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbYCFNzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbYCFNzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:55:38 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8748 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818AbYCFNzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:55:37 -0500
Date: Thu, 6 Mar 2008 14:55:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080306135532.GG17940@kernel.dk>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803061506.19449.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06 2008, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 March 2008, Ingo Molnar wrote:
> > 
> > * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > The problem looks very similar to the one recently reported by Anders:
> > > 
> > > http://lkml.org/lkml/2008/2/22/239
> > > 
> > > "Trying out 2.6.25-rc2 smartd always causes my box to hang. I can 
> > > switch vt:s and the keyboard seems to work.
> > > 
> > > Using sysrq-e I noticed a callpath open -> ext3 -> journals -> 
> > > sync_buffer -> io_scheduel -> generic_unplig_device. I'd guess the 
> > > open stems from smartd. Removing smartd from the startup, I'm now 
> > > using rc2 fine..."
> > > 
> > > Initially we thought that it is an IDE regression but after some 
> > > testing and further investigation it seems that IDE changes just made 
> > > it more likely to occur (yesterday it turned out that the kernel with 
> > > the "guilty" IDE commit sometimes boots fine).  The issue is easily 
> > > reproducible.
> > > 
> > > PS We've already verified that it is not PREEMPT related or a compiler 
> > > bug.
> > 
> > smartd is not active here though - and starting/restarting it doesnt 
> > provoke a hang.
> 
> I was a bit unclear on this, the problem is easily reproducible but _only_
> on Anders' system (I couldn't reproduce it with smartd here either).

What IO scheduler is Anders using (and does it have an impact, eg does
it hang with deadline as well)?

-- 
Jens Axboe


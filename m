Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbXB0LGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbXB0LGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXB0LGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:06:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:51185 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbXB0LGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:06:31 -0500
Date: Tue, 27 Feb 2007 11:59:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070227105922.GD2250@kernel.dk>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227103407.GA17819@elte.hu>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > > x60 doesn't resume from S2R either, it doesn't matter if 
> > > > CONFIG_NO_HZ is set or not though. 2.6.20 worked fine.
> > > 
> > > It somehow works for me. As long as I do not play with bluetooth and 
> > > suspend to disk...
> > 
> > It locks solid here on resume, going back to 2.6.20 makes it work 
> > perfectly again. In between 2.6.20 and 2.6.21-rc1 some ACPI change 
> > broke resume, but that got fixed. Some other change later snuck in 
> > that broke it AGAIN for me, sigh.
> > 
> > I don't use bluetooth nor suspend to disk.
> 
> resume is stock on my T60 too. So you mean v2.6.21-rc1 vanilla works 
> fine? Do you know a commit ID that works for sure? I'd like to bisect 

Nope, 2.6.21-rc1 vanilla does not work. 2.6.20 works. 2.6.20-gitX worked
until some acpi change broke it, the below patch fixed that for me. That
got merged in a later 2.6.20-gitY, but then some other patch broke it
again so that 2.6.21-rc1 is broken. Not much luck there :-)

So it looks like:

- c5a7156959e89b32260ad6072bbf5077bcdfbeee broke 2.6.20-git
- f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 should fix that.
- Something later than f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 broke it
  again.

> this, but this way i might just find that ACPI change that got already 
> fixed later on (and then got re-broken).

Yeah, it gets trickier. I'll try
f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 now and see if that works, then
bisect to 2.6.21-rc1 to find the other offender. I hope the other
offender didn't get added before
f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38, we'll see :-)

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXHQMhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXHQMhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXHQMho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:37:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27552 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbXHQMhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:37:43 -0400
Date: Fri, 17 Aug 2007 14:37:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 6] A few block-layer tidy-up patches.
Message-ID: <20070817123738.GL23758@kernel.dk>
References: <20070816211551.11839.patches@notabene> <20070816113638.GX23758@kernel.dk> <18116.61035.621593.588647@notabene.brown> <20070817061733.GD23758@kernel.dk> <18117.19602.616561.525863@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18117.19602.616561.525863@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17 2007, Neil Brown wrote:
> On Friday August 17, jens.axboe@oracle.com wrote:
> > > > Please inspect the #block-2.6.24 branch to see the result.
> > > 
> > > I don't know where to look for this.  I checked
> > >   http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git
> > > but they don't seem to be there.
> > > ??
> > 
> > That's where it is, but the kernel.org mirroring is just horrible slow.
> > Just checked now and it's there.
> 
> I discovered I was looking in the wrong place - not being very
> familiar with git terminology.
> I found them and it looks right.

Ah, good.

> I had a bit of a look at removing bio_data and ->buffer ...  the
> usages outside of drivers/ide are fairly easy to deal with - I might
> send a patch for that.  The drivers/ide stuff looks like a fairly
> substantial rewrite is in order.
> e.g.  idefloppy_packet_command_s seems to duplicate a lot of 
>   fields from 'struct request', and it should probably use the request
>   struct directly.

We can do it bits at the time, the triviel ones first. I have some
experience with drivers/ide/ myself, so I can attempt to tackle some of
that myself.

> But a number of times ->buffer points to ->cmd, and there is no bio.
> I guess we should use bio_map_kern to make a bio?

It points to ->cmd?! But yes, generally things just need to be
converted to map the data to a bio with bio_map_kern() (or
bio_map_user(), where appropriate).

> I'll see if I can come up with something.... testing it might be
> awkward.  I have an ide cdrom I can test on.  Maybe an ide disk,, but
> not an ide floppy :-)

I can help with that as well :-)

-- 
Jens Axboe


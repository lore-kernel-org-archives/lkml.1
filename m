Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbZFZJAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbZFZJAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZFZJAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:00:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49348 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZFZI77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:59:59 -0400
Date: Fri, 26 Jun 2009 11:00:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
Message-ID: <20090626090001.GA23611@kernel.dk>
References: <20090626125331.89c689f2.sfr@canb.auug.org.au> <f236aae1aa8ea7c4f3700dbca2f3ae14.squirrel@neil.brown.name> <20090626043937.GJ31415@kernel.dk> <19012.24947.650584.93908@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19012.24947.650584.93908@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26 2009, Neil Brown wrote:
> On Friday June 26, jens.axboe@oracle.com wrote:
> > On Fri, Jun 26 2009, NeilBrown wrote:
> > > On Fri, June 26, 2009 12:53 pm, Stephen Rothwell wrote:
> > > > Hi Jens,
> > > >
> > > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > > >
> > > > block/blk-core.c: In function '__make_request':
> > > > block/blk-core.c:1179: error: expected ';' before 'return'
> > > >
> > > > Caused by commit 6cf2a6c8d01514e86a8d38e4eeed402378b635dc ("Restore
> > > > barrier support for md and probably other virtual devices") which I have
> > > > reverted for today.
> > > 
> > > Arg, that's my fault - sorry.
> > > 
> > > +               bio_endio(bio, -EOPNOTSUPP)
> > > +                       return 0;
> > > 
> > > should of course be
> > > 
> > > +               bio_endio(bio, -EOPNOTSUPP);
> > > +               return 0;
> > 
> > I was certain I ran it through a compile cycle, sorry about that
> > Stephen. And Neil sending uncompiled patches, very uncool. Did you even
> > test it? I've pulled it for now.
> 
> I tested this time.
> Without the patch a 'mount -o journal=1 /dev/md0 /mnt'
> followed by writing to /mnt/something produces
> 
> Jun 26 15:34:18 dell kernel: JBD: barrier-based sync failed on md0 - disabling barriers
> 
> in the kernel logs.
> With the patch, it doesn't.
> 
> Comment updated slightly too.

Applied this one. But please in the future do let me know if you haven't
tested or even compiled a patch. When I get an official looking patch
like the previous one, I'll usually apply it directly. Breaking the
build is baaaad.

-- 
Jens Axboe


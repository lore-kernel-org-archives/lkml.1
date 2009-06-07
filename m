Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFGQIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFGQIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 12:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZFGQIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 12:08:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45611 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbZFGQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 12:08:14 -0400
Subject: Re: [git pull] IDE fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906071744.23629.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <200906071657.49513.bzolnier@gmail.com>
	 <1244387931.8262.24.camel@mulgrave.site>
	 <200906071744.23629.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 16:08:09 +0000
Message-Id: <1244390889.8262.47.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 17:44 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 07 June 2009 17:18:51 you wrote:
> > On Sun, 2009-06-07 at 16:57 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > On Sunday 07 June 2009 16:38:56 James Bottomley wrote:
> > > > On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > > > > > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > > > > > index 99e33ef..4bc2c43 100644
> > > > > > --- a/fs/partitions/check.c
> > > > > > +++ b/fs/partitions/check.c
> > > > > 
> > > > > 
> > > > > You seriously want to add code to the core partition handling logic
> > > > > moments before release when we know we have all sorts of devices with
> > > > > weird behaviours ?
> > > > > 
> > > > > This should be .31 stuff where we can take the time to see how it works
> > > > > on all sorts of weird real world devices (eg those with 2K sector size)
> > > > > and the like.
> > > > 
> > > > Absolutely seconded.
> > > > 
> > > > Plus this is only one of the proposals for dealing with IDE native sizes
> > > > moving through the process.  The other one is in libata with the gendisk
> > > > proposal for alt size instead of your set_capacity callback.   The last
> > > 
> > > ->set_capacity callback is needed for drivers/ide regardless of alt_size
> > > sysfs interface and it don't conflict with it in any way.
> > 
> > It's used as a heuristic for selecting native vs protected disk size
> > depending on what the partition table says ... I grant that's one way to
> > handle the problem.
> > 
> > > Those patches are a complimentary work to Tejun's alt_size patches. 
> > > 
> > > They don't export anything to user-space.
> > 
> > So you're trying to solve the problem heuristically, and Tejun is trying
> > to provide the user with full information.   At the end of the day it
> > would be nice to get agreement on how we do this *before* exposing it to
> > users.  It's certainly possible we could do both, but for that to happen
> 
> Sure.  My patches don't export anything to user-space.
> 
> If you find any code parts controversial please post them and I'll be
> more than happy to discuss them in details.
> 
> > libata would have to implement .get_capacity() is that going to be the
> > case?
> 
> Now we get the real source of Alan's and your complains...
> 
> Those patches (among other things) make IDE superior overt libata w.r.t.
> HPA handling so libata now has to catch up.
> 
> Honestly, this should be solved on technical basis by somebody posting
> needed libata patches instead of attempts to slow down IDE fixes.

You've got the wrong motive.  I have notice that you and Alan seem to
have a somewhat antagonistic relationship resulting in a proxy battle
over IDE/libata, so you would necessarily see this as at play in his
first post.  I hoped, by emphasizing the point, that you'd see this
adding features as bug fixes is a problem even from a more neutral
perspective.

So I have two specific problems with the way you're trying to one up
libata:

     1. You're trying to get a jump on them by adding features as bug
        fixes ... this is incredibly bad release practice.
     2. this antagonism in feature evolution is likely to lead to
        interface incompatibility between libata and IDE ... and users
        will be the ultimate losers because of this.

James



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYB1GRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYB1GRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYB1GRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:17:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:24739 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYB1GRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=Md1HYbQ/7CvJLfAjt8fY3K14Dzdld+m+DQg7suUpe70r80MKjKFmMiarOYtpHLXsoTwn601/6iIg1F0L97dD+lNLjrqEfR1LflyaZr0FqWDBEZexd1M/Nd7v2YiqiAHzkwWOPxgHAT1u/mr/2IckhmF9VnDSQi3VhFiV2EhY+tk=
Date: Thu, 28 Feb 2008 07:16:54 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Message-ID: <20080228061654.GE9545@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <200802272218.50537.bzolnier@gmail.com> <20080227221532.GB9545@gollum.tnic> <200802280001.43316.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802280001.43316.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 12:01:43AM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 27 February 2008, Borislav Petkov wrote:
> > On Wed, Feb 27, 2008 at 10:18:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > On Wednesday 27 February 2008, Borislav Petkov wrote:
> > > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > 
> > > interdiff for the merged version
> > > 
> 
> [...]
> 
> > > diff -u b/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > > --- b/drivers/ide/ide-cd.c
> > > +++ b/drivers/ide/ide-cd.c
> > > @@ -510,7 +510,7 @@
> > >  	default:
> > >  		if (!(rq->cmd_flags & REQ_QUIET))
> > >  			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
> > > -				rq->cmd[0]);
> > > +					 rq->cmd[0]);
> > 
> > why do you push the rq->cmd[0] thingy back here. Shouldn't it be aligned
> > with the opening brace as the zillion others so far?
> 
> IDE is quite consistent with the above style but maybe it is just me being
> used to it.  I could revert this change if you feel strong about it...
> 

not at all, i'm not that concerned with codestyle issues as long as it is mostly
readable :). The only issue of importance is consistency along all the source
files so i'll try to keep up with the rest of ide.

> > > @@ -819,8 +819,8 @@
> > >  static void restore_request(struct request *rq)
> > >  {
> > >  	if (rq->buffer != bio_data(rq->bio)) {
> > > -		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) /
> > > -				SECTOR_SIZE;
> > > +		sector_t n =
> > > +			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
> > 
> > i must say, lines like this one always look ugly, no matter the formatting
> > tricks.
> 
> For this case there is a simple solution: fix ide-cd to use hwif->sg_table
> instead of having it to walk rq->bio's and the whole function will vanish. ;-)

Is this hwif->sg_table walk something similar to what it is being done in
ide_build_sglist() or ide_build_dmatable()?

> [ IOW We are putting way too much time into these coding style fixes and as
>   the old code is replaced with the new one the coding style improves itself. ]

Exactly my thoughts. On the one hand, it is important to clean up the code
before you stare at it for a magnitude of hours looking for bugs and actually this
cleanup was supposed to be really brief, to begin with, but you know how things
really work out in reality :). On the other hand, there are places in ide-cd that
are just horrible and need rewriting, besides API changes.

On a different note, i'm working on ripping out pipelining from ide-tape
since this'll make ATAPI unification a lot easier. Do you happen to have figured
out what this tape->merge_stage is supposed to do, i know it is a pipeline stage
and in all r/w requests the tape->merge_stage->bh is the buffer that
receives/sends the data to/from the device but still it looks really strange.
What i've done so far is remove the pipeline control algos and have kept the
tape->merge_stage for simplicity. In a different cycle i'll have to kick it out
too replacing it with a simple data buffer.

Any ideas?

Thanks.

-- 
Regards/Gruﬂ,
    Boris.

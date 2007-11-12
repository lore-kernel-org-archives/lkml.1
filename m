Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXKLPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXKLPpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXKLPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:45:06 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:34809 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXKLPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:45:05 -0500
Date: Mon, 12 Nov 2007 16:44:56 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 improve and bugfix fasttimer
Message-ID: <20071112154456.GH6347@axis.com>
References: <20071108085430.GB6347@axis.com> <20071109151932.610bca4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109151932.610bca4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 03:19:32PM -0800, Andrew Morton wrote:
> On Thu, 8 Nov 2007 09:54:30 +0100
> Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > Improve and bugfix CRIS v10 fast timers.
> 
> I'm trying to work out what's going on with all this cris activity.  Is the
> current code really that busted, or are you adding new chip support, or are
> you resyncing mainline with some external tree or what?

The answer is actually "all of the above". Axis has a CVS tree
that has gotten out of sync with mainline (although we've continued
to merge new releases regularly into our CVS).

This means that the CRISv10 architecture has gotten broken in mainline,
but we've done the corrections in our CVS.
My patches up to now has been focused on merging the ones that
makes the architecture compile.

There's the CRISv32 architecture for the Etrax FS chip (which I'm not
sure if it actually has worked at any time, since it is missing a
number of key drivers like ethernet and serial) which is a working
architecture here at Axis.

There's also a new chip Artpec-3 which is based on the CRISv32
architecture, and shares most (if not all) drivers with Etrax FS,
but has some different hardware configuration.

Lastly, there's a number of changes that are general bugfixes or
improvements but are not required to compile.

The ultimate goal is to get where our tree tracks mainline
as close as possible.

> It _seems_ that pretty much everything you've sent over is a bugfix of some
> form.  Should we push it all into 2.6.24?

Yes, that would be great.

> > -void __INLINE__ do_gettimeofday_fast(struct timeval *tv)
> > +void __INLINE__ do_gettimeofday_fast(struct fasttime_t *tv)
> 
> You might like to dispose of __INLINE__ sometime.  I doubt if there's
> really any need for it, and using plain old inline everywhere would be
> nicer.

Yes, it is certainly so when the file defines __INLINE__ to be inline.
I'll submit a later patch that removes this.

> >      /* Has it really expired? */
> 
> heh, so the old code used a bizarre random-number-of-spaces for indenting
> and the edits use tabs.

> Suggest that you consider a large-scale cleaup during some quiet time. 
> Often people will feed the file wholesale through scripts/Lindent and will
> then fix up Lindent mistakes by hand.  If you go this way, please do it as
> two separate patches.  That way if the huge cleanup patch breaks due to
> other changes I can rerun Lindent and the manual fix-Lindents-mistakes
> patch usually applies easily on top of the newly-generated
> run-it-through-Lindent patch.

Yup, I've actually used tabs on purpose to cut down on checkpatch
warnings, with just the intention of submitting the complete reformatting
as a separate patch later.

> >      if (timeval_cmp(&t->tv_expires, &tv) <= 0)
> 
> You have a private timeval_cmp().  Please take a look at utilising
> include/linux/time.h:timeval_compare() instead.  If that doesn't suit then
> we'd entertain extensions of that interface.  Adding private code to do
> something as common as this is not a good thing.

Ok, will do.

Thanks a lot for your time!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com

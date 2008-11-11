Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKKXoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKKXoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYKKXoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:44:24 -0500
Received: from ns.suse.de ([195.135.220.2]:43943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYKKXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:44:24 -0500
Date: Tue, 11 Nov 2008 15:43:44 -0800
From: Greg KH <gregkh@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       maan@systemlinux.org, stable@kernel.org
Subject: Re: patch
	md-linear-fix-a-division-by-zero-bug-for-very-small-arrays.patch
	added to 2.6.27-stable tree
Message-ID: <20081111234344.GB5589@suse.de>
References: <20081111180958.4480949037@coco.kroah.org> <200811112328.15522.s.L-H@gmx.de> <5f46e30cc6798d8b201c2e25aa2c04e1.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f46e30cc6798d8b201c2e25aa2c04e1.squirrel@neil.brown.name>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 09:46:36AM +1100, NeilBrown wrote:
> On Wed, November 12, 2008 9:28 am, Stefan Lippers-Hollmann wrote:
> > Hi
> >
> > On Dienstag, 11. November 2008, gregkh@suse.de wrote:
> 
> >>
> >> --- a/drivers/md/linear.c
> >> +++ b/drivers/md/linear.c
> >> @@ -157,6 +157,8 @@ static linear_conf_t *linear_conf(mddev_
> >>
> >>  	min_spacing = conf->array_sectors / 2;
> >>  	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
> >> +	if (min_sectors == 0)
> >> +		min_sectors = 1;
> >>
> >>  	/* min_spacing is the minimum spacing that will fit the hash
> >>  	 * table in one PAGE.  This may be much smaller than needed.
> >
> > drivers/md/linear.c: In function 'linear_conf':
> > drivers/md/linear.c:160: error: 'min_sectors' undeclared (first use in
> > this function)
> > drivers/md/linear.c:160: error: (Each undeclared identifier is reported
> > only once
> > drivers/md/linear.c:160: error: for each function it appears in.)
> > make[5]: *** [drivers/md/linear.o] Error 1
> > make[4]: *** [drivers/md] Error 2
> > make[4]: *** Waiting for unfinished jobs....
> >
> > This one obviously depends on:
> >
> > commit 23242fbb470ff4c8c4d41f178832cf1929273d7d
> > Author: Andre Noll <maan@systemlinux.org>
> > Date:   Mon Oct 13 11:55:12 2008 +1100
> >
> >     md: linear.c: Make two local variables sector-based.
> >
> > which in turn depends on previous changes.
> 
> Yes, but only syntactically, not semantically.
> 
> In 2.6.27, it needs to be
>    if (min_spacing == 0)
>            min_spacing = 1;

Thanks, I've adjusted the patch to look like this instead.

greg k-h

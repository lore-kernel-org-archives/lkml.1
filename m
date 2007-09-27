Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbXI0SEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbXI0SEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXI0SEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:04:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39658 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbXI0SEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:04:45 -0400
Date: Thu, 27 Sep 2007 10:59:17 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
	without options
Message-ID: <20070927175917.GB8339@kroah.com>
References: <20070927142919.10b62f9b@the-village.bc.nu> <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927102343.1a113ccc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 10:23:43AM -0700, Andrew Morton wrote:
> On Thu, 27 Sep 2007 11:59:02 -0400 Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Thu, Sep 27, 2007 at 04:19:12PM +0100, Alan Cox wrote:
> > > There are real things to worry about - sysfs, sysfs, sysfs, ... and all
> > > the other crap which is continually breaking stuff, not spec compliance
> > > corrections that don't break things but move us into compliance with the
> > > standard
> > 
> > I've got to agree with Alan, the sysfs/udev breakages that we've done
> > are far more significant

I'm sorry, have I missed a breakage lately?  I don't know of one in over
a year that has not been fixed.  Do you?

> > , and the fact that we continue to expose internal data structures
> > via sysfs is a gaping open pit is far more likely to cause any kind
> > of problems than changing an error return.

Come on now, I'm _very_ tired of this kind of discussion.  Please go
read the documentation on how to _use_ sysfs from userspace in such a
way that you can properly access these data structures so that no
breakage occurs.

And if you want to propose some other kind of alternative to exporting
this kind of _needed_ information to userspace, in a simple and
easy-to-use manner, please do so.  Until then, stop complaining
unnecessarily.

> Funny you should mention that.  I was staring in astonishment at the
> pending sysfs patch pile last night.  Forty syfs patches and twenty-odd
> patches against driver core and the kobject layer.

And _none_ of them change any userspace interaction.  Well, ok, the
block one can, if the CONFIG_SYSFS_DEPRECATED is disabled, but that's
not going into 2.6.24 as I stated in my status report.

> That's a huge amount of churn for a core piece of kernel infrastructure
> which has been there for four or five years.  Not a good sign.  I mean,
> it's not as if, say, the CPU scheduler guys keep on rewriting all their
> junk.

The sysfs changes are almost all due to the need for the
containers/vserver/whatever people to be able to see different views of
sysfs depending on the user/container.  That is a radical change that
was never designed for in the beginning.  The other changes that Tejun
has made have actually cleaned up the code and made it simpler to use
and more robust and fixed bugs.

Same thing goes for the driver core changes.  We are cleaning things up,
fixing bugs that have been found when the driver core has been used in
ways that we never originally anticipated.  We are also trying to make
it easier to use, and simpler overall, as the original design was quite
half-hazard at best in numerous places (kset/subsystem/ktype anyone?)

So these aren't being done just because we like to break things, we are
trying to make things better, and fix real bugs here.

thanks,

greg k-h

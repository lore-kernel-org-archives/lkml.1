Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbXI0Vlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbXI0Vlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbXI0Vl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:41:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51412 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbXI0Vl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:41:28 -0400
Date: Thu, 27 Sep 2007 14:34:45 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
	without options
Message-ID: <20070927213445.GA7857@kroah.com>
References: <20070927070118.2bd4792e@laptopd505.fenrus.org> <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927183742.GA23734@thunk.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:37:42PM -0400, Theodore Tso wrote:
> On Thu, Sep 27, 2007 at 10:59:17AM -0700, Greg KH wrote:
> > Come on now, I'm _very_ tired of this kind of discussion.  Please go
> > read the documentation on how to _use_ sysfs from userspace in such a
> > way that you can properly access these data structures so that no
> > breakage occurs.
> 
> I've read it; the question is whether every single application
> programmer or system shell script programmer who writes code my system
> depends upon has read it this document buried in the kernel sources,
> or whether things will break spectacularly --- one of those things
> that leaves me in suspense each time I update the kernel.

Ok, how then should I advertise this better?  What can we do better to
help userspace programmers out in this regard?

> I'm reminded of Rusty's 2003 OLS Keynote, where he points out that
> what's important is not making an interface easy to use, but _hard_
> _to_ _misuse_.

Me and Pat Mochel sat in that talk and instantly had an "oh shit" moment
when it came to the in-kernel usage of sysfs and the driver model.  Ever
since then, I have been working to change the code to make it better.
With the exception of the recent help from Kay, I am the only one doing
this as Pat has been gone for a few years and isn't coming back.

> That fact that sysfs is all laid out in a directory, but for which
> some directories/symlinks are OK to use, and some are NOT OK to use
> --- is why I call the sysfs interface "an open pit".

We (well, Kay mostly) have also been working on fixing this all up to
make it much harder to use sysfs incorrectly.  We will have a single
device tree (well, almost a single tree, it's getting there), so that
all of the information is only in one place, and you don't have to go
searching all over the place for it.  That is a direct improvement over
the old design where somethings were in one place, and others in
another.

And because of the original design mistakes, we have only been able to
change things for the better in a slow manner.  We have had userspace
programs fixed up for _years_ before we are able to make the
corresponding changes in the kernel, so as to not break the distros that
are slow to upgrade packages and kernels (like Debian.)

If I had my druthers, we could instantly put some patches into the tree
to fix up the sysfs "mess" once and for all, creating a unified, single
tree, with only a handful of needed symlinks to be able to categorize
certain things.  We have the patches (Kay wrote them over a year ago),
and userspace programs work just fine with them (udev and HAL), but
because we need to support 5 year old userspace programs running
tomorrows kernel, we must take very tiny, slow steps to get there.

And yes, sysfs has slowly changed over the years, and along the way we
have kept things working, with only very minor problems.  You have no
idea the crazy mismatch of kernels and userspace programs we have had to
deal with.  And it will continue to change, slowly, until we reach the
unified-tree goal, and all of those old crufty userspace programs are
dead and buried (I got a bug report about RHEL's udev version 039 just
yesterday.)

So you can't have it both ways.  You can't complain that sysfs isn't
stable, and isn't "properly userspace friendly" at the same time.  In
order to fix the issues, we have to change it, and do it slowly, because
I don't want to break some distros that can't keep up with the others.

thanks,

greg k-h

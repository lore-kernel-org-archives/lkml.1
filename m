Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab0CAGf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 01:35:26 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60375 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750695Ab0CAGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 01:35:24 -0500
Date: Mon, 1 Mar 2010 07:35:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100301063508.GA1455@ucw.cz>
References: <20100223123321.GA1025@kernel.dk> <Pine.LNX.4.44L0.1002231016500.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002231016500.1507-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> > > is, should it be made unfreezable?
> > 
> > I'm not a big expect on what tasks should be freezable or not. As it
> > stands, the writeback tasks will attempt to freeze and thaw with the
> > system. I guess that screws the sync from resume call, since it's not
> > running and the sync will wait for it to retrieve and finish that work
> > item.
> > 
> > To the suspend experts - can we safely mark the writeback tasks as
> > non-freezable?
> 
> The reason for freezing those tasks is to avoid writebacks at random
> times during a system sleep transition, when the underlying device may
> already be suspended, right?

It is also there to avoid inconsistency between in-filesystem data and
snapshot in hibernation image.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

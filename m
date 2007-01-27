Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbXA0A5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbXA0A5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbXA0A5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:57:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXA0A5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:57:07 -0500
Date: Fri, 26 Jan 2007 16:56:57 -0800
From: Andrew Morton <akpm@osdl.org>
To: David Brownell <david-b@pacbell.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-Id: <20070126165657.663358ab.akpm@osdl.org>
In-Reply-To: <200701261642.56896.david-b@pacbell.net>
References: <20061219185223.GA13256@srcf.ucam.org>
	<200701261356.42171.david-b@pacbell.net>
	<20070126231521.GA12370@srcf.ucam.org>
	<200701261642.56896.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 16:42:56 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Friday 26 January 2007 3:15 pm, Matthew Garrett wrote:
> > On Fri, Jan 26, 2007 at 01:56:41PM -0800, David Brownell wrote:
> > 
> > > I thought the resolution was that fixing a few of those drivers
> > > should solve the problem Matthew needed resolved, and that in
> > > the meanwhile "rmmod drivername" should suffice.  There also seemed
> > > to be agreement that power management for wireless devices needed
> > > more work; there might need to be a state between "down/off" and
> > > "configured and able to talk IP".
> > 
> > It's certainly the case that fixing those drivers would result in a 
> > better long-term situation - however, nobody currently seems to have any 
> > interest in doing so...
> 
> And the way these things work, unfortunately, is that merging your patch
> would ensure nobody ever gets such interest.  Removing that "state" file
> (and its bogus infrastructure) has already taken a few years too long.
> 

No, we shouldn't just break stuff for our users in the hope that said
breakage will force some other developer to come in and fix things later.

We should revert the breakage-causing patch, with the expectation that its
submitter will ensure that all prerequisites are in place before it is
reapplied.

> 
> > As I've said before, I think it's unreasonable to cripple interfaces for 
> > (mostly) aesthetic reasons without ensuring that equivalent 
> > functionality already exists.
> 
> I don't recall anyone raising aesthetic concerns.  And bug-equivalence
> has never been a goal of Linux.
> 

Not breaking things for end-users is a goal.  Prime directive, indeed.

> 
> > This patch restores useful functionality  
> > without breaking the extra sanity checks that you've added. I appreciate 
> > that it's not an interface that you want to support in the long term 
> > (well, even the short term...),
> 
> You imply that it _was_ once supported, which is not true.  Like any
> other bug (in this case "design bug"), it was there and could be abused.
> And like some other bugs, fixing it can trigger complaints from (ab)users.

Could someone please explain in easy-to-understand terms what the
real-world impact of this bug is upon our users?  How many are affected,
and under what circumstances, and with what effects?


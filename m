Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZC3N5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZC3N5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZC3N5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:57:20 -0400
Received: from THUNK.ORG ([69.25.196.29]:42235 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZC3N5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:57:19 -0400
Date: Mon, 30 Mar 2009 09:55:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330135552.GF13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <20090330063110.GS26138@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330063110.GS26138@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 05:31:10PM +1100, Dave Chinner wrote:
> 
> Pardon my french, but that is a fucking joke.
> 
> You are making a judgement call that one application is more
> important than another application and trying to impose that on
> everyone. You are saying that we should perturb a well designed and
> written backup application that is embedded into critical scripts
> all around the world for the sake of desktop application that has
> developers that are too fucking lazy to fix their bugs.

You are welcome to argue with the desktop application writers (and
Linus, who has sided with them).  I *knew* this was a fight I was not
going to win, so I implemented the replace-via-rename workaround, even
before I started trying to convince applicaiton writers that they
should write more portable code that would be safe on filesystems such
as, say, XFS.  And it looks like we're losing that battle as well;
it's hard to get people to write correct, portable code!  (I *told*
the application writers that I was the moderate on this one, even as
they were flaming me to a crisp.  Given that I'm taking flak from both
sides, it's to me a good indication that the design choices made for
ext4 was probably the right thing.)

> If you want to trade rsync performance for desktop performance, do
> it in the filesystem that is aimed at the desktop. Don't fuck rename
> up for filesystems that are aimed at the server market and don't
> want to implement performance sucking hacks to work around fucked up
> desktop applications.

What I did was create a mount option for system administrators
interested in the server market.  And an rsync option that unlinks the
target filesystem first really isn't that big of a deal --- have you
seen how many options rsync already has?  It's been a running joke
with the rsync developers.  :-)

If XFS doesn't want to try to support the desktop market, that's fine
--- it's your choice.  But at least as far as desktop application
programmers, this is not a fight we're going to win.  It makes me sad,
but I'm enough of a realist to understand that.

	     	     	   	       	     - Ted

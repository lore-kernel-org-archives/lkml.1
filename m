Return-Path: <linux-kernel-owner+w=401wt.eu-S937342AbXG0R5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937342AbXG0R5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXG0R5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:57:47 -0400
Received: from clump.bawx.ca ([64.251.30.168]:51162 "EHLO bawx.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933002AbXG0R5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:57:46 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 13:57:46 EDT
X-Spam-Score: 1.932
Date: Fri, 27 Jul 2007 10:22:19 -0700
From: Kevin Lindsay <kevin@trakker.ca>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Douglas J Hunley <doug@hunley.homeip.net>, slocate@trakker.ca,
       linux-kernel@vger.kernel.org
Subject: Re: solving(?) the updatedb problem w/ the kernel cache
Message-ID: <20070727172219.GO3357@trakker.ca>
References: <200707270855.26997.doug@hunley.homeip.net> <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0707270942k784890a2ld44d1312dde02379@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 09:42:27AM -0700, Ray Lee wrote:

> On 7/27/07, Douglas J Hunley <doug@hunley.homeip.net> wrote:
> > I've been following lkml for a little while (not understanding it all, but
> > following nonetheless <g>) and I've noticed that in a lot of the talks about
> > schedulers, elevators, and performance, the issue of running updatedb and its
> > effects on the kernel's fs cache seems to recur. I've also yet to see anyone
> > present a solution that others think is worth pursuing. I'm curious why we're
> > trying to solve the problem, when we can simply avoid the problem to begin
> > with by making use of inotify and introducing a new user-space
> > daemon, 'located'.
> 
> inotify doesn't scale for lots of directories. I have about 18,000
> directories under ~ on my laptop, and that's with a few source trees
> that I use infrequently tarballed up.
> 
> But yes, if we had a full filesystem events notifier, then we could
> just toss updatedb aside and have the benefit of a live index into the
> system. It's been suggested before, at least by me. Other projects
> want this as well, such as an on-demand virus scanner, or a live
> backup to another site, or beagle/tracker who would like to index
> documents on the fly. beagled already uses inotify, I think, but as it
> takes over my system (in a bad way) whenever I tried to run it, I had
> no choice but to remove it.
> 
> Perhaps it was choking on the 18k subdirectories, dunno.

The interface for inotify requires you to explicity watch files and folders.
As Ray suggests, I am also skeptical that using inotify to watch 18k of inodes
is very efficient, although it would be nice to be wrong. Possibly someone
needs to take a peak into OS X's fsevents mechanism?

The other problems with this approach is that the locate DB uses incremental
encoding. Each change to the filesystem may require large protions or possibly
a complete re-encoding of the database. An alterntive DB format would need to
be considered.

Kevin

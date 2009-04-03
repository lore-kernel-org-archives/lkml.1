Return-Path: <linux-kernel-owner+w=401wt.eu-S936602AbZDCV3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936602AbZDCV3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbZDCV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:29:13 -0400
Received: from tichy.grunau.be ([85.131.189.73]:51885 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491AbZDCV3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:29:13 -0400
Date: Fri, 3 Apr 2009 23:28:47 +0200
From: Janne Grunau <j@jannau.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <lkml@rtr.ca>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090403212847.GC25887@aniel>
References: <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D66A40.5020503@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 03:57:52PM -0400, Jeff Garzik wrote:
> Mark Lord wrote:
> > 
> > I wonder if the problem with your system is really a Myth/driver issue?
> > 
> > Curiously, I have a HVR-1600 card here, and when recording analog TV with
> > it the disk lights are on constantly.  The problem with it turns out to
> > be mythbackend doing fsync() calls ten times a second.
> > 
> > My other tuner cards don't have this problem.
> > 
> > So perhaps the PVR-500 triggers the same buggy behaviour as the HVR-1600?
> > To work around it here, I decided to use a preload library that replaces
> > the frequent fsync() calls with a more moderated behaviour:
> > 
> >   http://rtr.ca/hvr1600/libfsync.tar.gz
> > 
> > Grab that file and try it out.  Instructions are included within.
> > Report back again and let us know if it makes any difference.
> > 
> > Someday I may try and chase down the exact bug that causes mythbackend
> > to go fsyncing berserk like that, but for now this workaround is fine.

that sounds if it indeed syncs every 100ms instead of once per second
over the whole recording. It's inteneded behaviour for the first 64K.

> mythtv/libs/libmythtv/ThreadedFileWriter.cpp is a good place to start 
> (Sync method... uses fdatasync if available, fsync if not).
> 
> mythtv is definitely a candidate for sync_file_range() style output, IMO.

yeah, I'm on it.

Janne

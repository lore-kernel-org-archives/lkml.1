Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZC3DbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZC3DbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 23:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZC3Day
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 23:30:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:34017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbZC3Dax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 23:30:53 -0400
Date: Sun, 29 Mar 2009 23:28:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Trenton Adams <trenton.d.adams@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330032827.GD13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Trenton Adams <trenton.d.adams@gmail.com>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <9b1675090903291829u7a69df36m65b6698290773859@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090903291829u7a69df36m65b6698290773859@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 07:29:09PM -0600, Trenton Adams wrote:
> I am slightly confused by the "data=ordered" thing that everyone is
> mentioning of late.  In theory, it made sense to me before I tried it.
>  I switched to mounting my ext3 as ext4, and I'm still seeing
> seriously delayed fsyncs.  Theodore, I used a modified version of your
> fsync-tester.c to bench 1M writes, while doing a dd, and I'm still
> getting *almost* as bad of "fsync" performance as I was on ext3.  On
> ext3, the fsync would usually not finish until the dd was complete.

How much memory do you have?  On my 4gig X61 laptop, using a 5400 rpm
laptop drive, I see typical times of 1 to 1.5 seconds, with a few
outliers at 4-5 seconds.  With ext3, the fsync times immediately
jumped up to 6-8 seconds, with the outliers in the 13-15 second range.

(This is with a filesystem formated as ext3, and mounted as either
ext3 or ext4; if the filesystem is formatted using "mke2fs -t ext4",
what you see is a very smooth 1.2-1.5 seconds fsync latency, indirect
blocks for very big files end up being quite inefficient.)

So I'm seeing a definite difference --- but also please remember that
"dd if=/dev/zero of=bigzero.img" really is an unfair, worst-case
scenario, since you are dirtying memory as fast as your CPU will dirty
pages.  Normally, even if you are running distcc, the rate at which
you can dirty pages will be throttled at your local network speed.

You might want to try more normal workloads and see whether you are
seeing distinct fsync latency differences with ext4.  Even with the
worst-case dd if=/dev/zero, I'm seeing major differences in my
testing.

							- Ted

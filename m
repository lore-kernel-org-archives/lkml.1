Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYGAVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYGAVun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGAVug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:50:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYGAVuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:50:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Date: Tue, 1 Jul 2008 23:21:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: xfs-masters@oss.sgi.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <200807011635.44696.rjw@sisk.pl> <20080701211226.GT29319@disturbed>
In-Reply-To: <20080701211226.GT29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012321.59732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Dave Chinner wrote:
> On Tue, Jul 01, 2008 at 04:35:43PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 1 of July 2008, Dave Chinner wrote:
> > > On Tue, Jul 01, 2008 at 12:38:41AM +0200, Rafael J. Wysocki wrote:
> > > > On Tuesday, 1 of July 2008, Dave Chinner wrote:
> > > > > On Mon, Jun 30, 2008 at 11:00:43PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Monday, 30 of June 2008, Dave Chinner wrote:
> > > > > > > On Sun, Jun 29, 2008 at 11:37:31PM -0700, Jeremy Fitzhardinge wrote:
> > > > > > > > Dave Chinner wrote:
> > > > > > > >> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> > > > > > > >>> Well, it seems we can handle this on the block layer level, by temporarily
> > > > > > > >>> replacing the elevator with something that will selectively prevent fs I/O
> > > > > > > >>> from reaching the layers below it.
> > > > > > > >>
> > > > > > > >> Why? What part of freeze_bdev() doesn't work for you?
> > > > > > > >
> > > > > > > > Well, my original problem - which is still an issue - is that a process  
> > > > > > > > writing to a frozen XFS filesystem is stuck in D state, and therefore  
> > > > > > > > cannot be frozen as part of suspend.
> > > > > > 
> > > > > > I thought we were talking about the post-freezer situation.
> > > > > > 
> > > > > > > Silly me - how could I forget the three headed monkey getting in
> > > > > > > the way of our happy trip to beer island?
> > > > > > > 
> > > > > > > Seriously, though, how is stopping I/O in the elevator is going to
> > > > > > > change that?
> > > > > > 
> > > > > > We can do that after creating the image and before we let devices run again.
> > > > > > This way we won't need to worry about the freezer.
> > > > > 
> > > > > You're suggesting that you let processes trying to do I/O continue
> > > > > until *after* the memory image is taken?
> > > > 
> > > > I'm not going to let the data get to the disk.
> > > 
> > > Yes, but you still haven't answered the original question - What are
> > > you going to do with sync I/O that leaves a process in D state
> > > because you've prevented the I/O from being completed?
> > 
> > I don't want to intercept those processes, just allow them to block on that I/O.
> 
> So you're going to allow them to go to D state somewhere. Ok, so
> what's the problem with blocking them in vfs_check_frozen(), then?
> 
> > Do all of the filesystems implement the freezing?
> 
> Most of the major ones - those that implement ->write_super_lockfs()
> should work just fine.

Okay, so we can do that.

I'm surely not against freezing of the filesystems before hibernation at least.
In fact we tried that in the past, but there were some locking problems I was
unable to resolve at that time.

Unfortunately I'm not very familiar with the VFS and filesystems code, so some
experts' help would be very much appreciated.

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbYCFUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbYCFUdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYCFUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:33:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752036AbYCFUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:33:42 -0500
Date: Thu, 6 Mar 2008 15:33:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: David Brownell <david-b@pacbell.net>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <20080306155553.GA3908@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0803061528460.9174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Pavel Machek wrote:

> On Tue 2008-03-04 16:00:51, Alan Stern wrote:
> > On Tue, 4 Mar 2008, David Brownell wrote:
> > 
> > > > What's wrong with a superfluous probe at resume time, besides the waste 
> > > > of a few milliseconds?
> > > 
> > > I'm more concerned with the undesirable removal of devices at suspend
> > > time ... ones with mounted filesystems etc.
> > 
> > On that we can agree.  The removal is done if the host doesn't define a 
> > resume method.  There doesn't seem to be any point to that, given that 
> > the probing during resume will determine whether a card has in fact 
> > been removed.
> 
> Hmm, if the driver is sleeping too deeply, user might have removed the
> card and put in different one, without driver noticing. That would be
> _bad_.

Ironically, the very same problem now exists with the USB mass-storage 
driver.  I don't see any way for the driver itself to solve it, 
especially during a hibernation (which can be a _very_ deep sleep).

One thing that could be done is for filesystems to verify, after a 
system sleep, that their superblocks haven't changed.  There could 
still be issues with non-mounted partitions, if they have live entries 
in the block cache, but it would be an improvement.

Do you know the right people to mention this to?  Anybody in filesystem 
development interested in suspend/hibernation issues?

Alan Stern


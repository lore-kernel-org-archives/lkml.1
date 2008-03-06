Return-Path: <linux-kernel-owner+w=401wt.eu-S935995AbYCFVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995AbYCFVcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765060AbYCFVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:32:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38501 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbYCFVcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:32:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Thu, 6 Mar 2008 22:31:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Alan Stern" <stern@rowland.harvard.edu>, "Pavel Machek" <pavel@ucw.cz>,
       "David Brownell" <david-b@pacbell.net>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
References: <20080306155553.GA3908@ucw.cz> <Pine.LNX.4.44L0.0803061528460.9174-100000@iolanthe.rowland.org> <c4e36d110803061253i7f8edd6eu97887d2e628453e2@mail.gmail.com>
In-Reply-To: <c4e36d110803061253i7f8edd6eu97887d2e628453e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062231.14773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of March 2008, Zdenek Kabelac wrote:
> 2008/3/6, Alan Stern <stern@rowland.harvard.edu>:
> > On Thu, 6 Mar 2008, Pavel Machek wrote:
> >
> >  > On Tue 2008-03-04 16:00:51, Alan Stern wrote:
> >  > > On Tue, 4 Mar 2008, David Brownell wrote:
> >  > >
> >  > > > > What's wrong with a superfluous probe at resume time, besides the waste
> >  > > > > of a few milliseconds?
> >  > > >
> >  > > > I'm more concerned with the undesirable removal of devices at suspend
> >  > > > time ... ones with mounted filesystems etc.
> >  > >
> >  > > On that we can agree.  The removal is done if the host doesn't define a
> >  > > resume method.  There doesn't seem to be any point to that, given that
> >  > > the probing during resume will determine whether a card has in fact
> >  > > been removed.
> >  >
> >  > Hmm, if the driver is sleeping too deeply, user might have removed the
> >  > card and put in different one, without driver noticing. That would be
> >  > _bad_.
> >
> >
> > Ironically, the very same problem now exists with the USB mass-storage
> >  driver.  I don't see any way for the driver itself to solve it,
> >  especially during a hibernation (which can be a _very_ deep sleep).
> >
> >  One thing that could be done is for filesystems to verify, after a
> >  system sleep, that their superblocks haven't changed.  There could
> >  still be issues with non-mounted partitions, if they have live entries
> >  in the block cache, but it would be an improvement.
> >
> >  Do you know the right people to mention this to?  Anybody in filesystem
> >  development interested in suspend/hibernation issues?

I don't really think so (but I may be wrong ...)

> IMHO the way would be to try to unmount fs if it's possible - if not -
> user should be notified on suspend/hibernation that he must preserve
> media in its place after resume and it should be checked and user
> should be notified if different devices/fs were find...

This is a very long standing issue which IMO can only be solved by making
filesystems suspend-aware.

Thanks,
Rafael

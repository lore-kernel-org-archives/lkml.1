Return-Path: <linux-kernel-owner+w=401wt.eu-S935825AbYCFUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935825AbYCFUyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935600AbYCFUxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:53:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:18769 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935602AbYCFUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:53:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rlE8wZgSQAbIc8cyZT4bbavIC6iDbsVz9c97nOcDLXniBPOFxMqkKLGSm5bWYmTIJv27KxNTizjw92DbZP6/itJ94DMajWg0nMh5cvmd9si1C032GcdhNs0rUkj4vsUo2/eXCoqqfYE6LPzCMj7Ku9ddgQloIlaO8NPihVTWeXI=
Message-ID: <c4e36d110803061253i7f8edd6eu97887d2e628453e2@mail.gmail.com>
Date: Thu, 6 Mar 2008 21:53:44 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Brownell" <david-b@pacbell.net>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0803061528460.9174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306155553.GA3908@ucw.cz>
	 <Pine.LNX.4.44L0.0803061528460.9174-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/6, Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 6 Mar 2008, Pavel Machek wrote:
>
>  > On Tue 2008-03-04 16:00:51, Alan Stern wrote:
>  > > On Tue, 4 Mar 2008, David Brownell wrote:
>  > >
>  > > > > What's wrong with a superfluous probe at resume time, besides the waste
>  > > > > of a few milliseconds?
>  > > >
>  > > > I'm more concerned with the undesirable removal of devices at suspend
>  > > > time ... ones with mounted filesystems etc.
>  > >
>  > > On that we can agree.  The removal is done if the host doesn't define a
>  > > resume method.  There doesn't seem to be any point to that, given that
>  > > the probing during resume will determine whether a card has in fact
>  > > been removed.
>  >
>  > Hmm, if the driver is sleeping too deeply, user might have removed the
>  > card and put in different one, without driver noticing. That would be
>  > _bad_.
>
>
> Ironically, the very same problem now exists with the USB mass-storage
>  driver.  I don't see any way for the driver itself to solve it,
>  especially during a hibernation (which can be a _very_ deep sleep).
>
>  One thing that could be done is for filesystems to verify, after a
>  system sleep, that their superblocks haven't changed.  There could
>  still be issues with non-mounted partitions, if they have live entries
>  in the block cache, but it would be an improvement.
>
>  Do you know the right people to mention this to?  Anybody in filesystem
>  development interested in suspend/hibernation issues?


IMHO the way would be to try to unmount fs if it's possible - if not -
user should be notified on suspend/hibernation that he must preserve
media in its place after resume and it should be checked and user
should be notified if different devices/fs were find...

Zdenek

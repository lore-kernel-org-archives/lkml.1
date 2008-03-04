Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbYCDTvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbYCDTvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYCDTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:51:40 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750912AbYCDTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:51:39 -0500
Date: Tue, 4 Mar 2008 14:51:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <200803041053.44909.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803041447090.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:

> > I don't understand this comment.  Suppose a card was inserted while the 
> > system was hibernating.  If the core didn't reprobe, when would that 
> > card be discovered?
> 
> The host controller would tell the core to check for a card, exactly
> like it does at all other times.

But how would the host controller know to do that?  Isn't card 
insertion detection often driven by interrupts?  If a card is 
inserted while the computer is off, no interrupt will be generated.

> That's the natural alternative to having the MMC core assume that card
> detection was broken in low power states, so that the core needed to
> forcibly remove the cards before suspend, and reprobe during resume
> processing.

Is that the assumption the MMC core was really making?  Are you sure it 
wasn't assuming something else (perhaps equally as bad)?

> Having the MMC core make such needless assumptions can cause problems
> for the upper layers, including filesystems.

What's wrong with a superfluous probe at resume time, besides the waste 
of a few milliseconds?

Alan Stern


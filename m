Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYCAOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYCAOgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYCAOgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:36:37 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1883 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752399AbYCAOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:36:37 -0500
Date: Sat, 1 Mar 2008 09:36:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <20080301151155.55209ebb@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0803010931090.4212-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Pierre Ossman wrote:

> On Mon, 25 Feb 2008 15:00:51 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > 
> > Maybe a better approach would be to leave the workqueue unfreezable,
> > and keep cancel_delayed_work_sync() in mmc_suspend_host().  It would
> > then be necessary to add a test to verify, if there is a card attached,
> > that the card is indeed suspended.  After all, it's possible that the
> > cancel_delayed_work_sync() ended up waiting for a job already running
> > on the workqueue to register a new card!  (The same would be true even 
> > with flush_scheduled_work.)
> 
> How would that be handled? I'd prefer a patch as I'm evidently not up to date with how to fondle the pm stuff properly. :)

The easiest way to do this will be to wait until some planned updates 
are added to the PM core; then this will be a quick and simple change.  
That probably means waiting until after 2.6.25 is released, however.

> > Also, as a bit of defensive programming, it might be a good idea to add
> > a "suspended" flag to the mmc_host structure.  If mmc_rescan() sees
> > that the flag is set then it should return immediately.  This would
> > protect against host drivers that aren't careful to disable detect
> > IRQs before calling mmc_suspend_host().
> 
> Indeed. I'll add that to my todo.

That could go in along with the previous change.  The PM update
mentioned above involves adding a "suspended" flag to every struct 
device.  With that available, this amounts to nothing more than an 
extra test added at the beginning of mmc_rescan().

Alan Stern


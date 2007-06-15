Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXFOVvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXFOVvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbXFOVvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:51:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758754AbXFOVvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:51:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH -mm 6/7] PM: Remove power_state.event checks from suspend core code
Date: Fri, 15 Jun 2007 23:57:57 +0200
User-Agent: KMail/1.9.5
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.0706142157420.30954-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706142157420.30954-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152357.58613.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 June 2007 04:00, Alan Stern wrote:
> On Fri, 15 Jun 2007, Rafael J. Wysocki wrote:
> 
> > On Thursday, 14 June 2007 16:21, David Brownell wrote:
> > > On Wednesday 13 June 2007, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > The suspend routines should be called for every device during a system sleep
> > > > transition, regardless of the device's state, so that drivers can regard these
> > > > method calls as notifications that the system is about to go to sleep, rather
> > > > than as directives to put their devices into the 'off' state.
> > > 
> > > Did you audit all the drivers to make sure this won't break things?
> > > Like for example through inappropriate pci_save_state() calls?
> > 
> > I did, but not very carefully.
> > 
> > > I'd really expect this patch would break things...
> > 
> > Well, in that case I'll have a closer look at them.
> 
> It might not be all that bad.  One would expect problems to occur only 
> in cases where devices were already suspended at the time of a system 
> sleep transition.  Since relatively few drivers currently implement 
> runtime PM -- and those that do are likely to be more careful about 
> not blindly making state changes -- there might not be too much 
> trouble.

Yes, in fact I've had no problems related to that so far (tested the patch on
four different machines).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

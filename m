Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXFOCAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXFOCAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXFOCAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:00:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4319 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751168AbXFOCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:00:38 -0400
Date: Thu, 14 Jun 2007 22:00:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 6/7] PM: Remove power_state.event checks from suspend
 core code
In-Reply-To: <200706150046.13650.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0706142157420.30954-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Rafael J. Wysocki wrote:

> On Thursday, 14 June 2007 16:21, David Brownell wrote:
> > On Wednesday 13 June 2007, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > The suspend routines should be called for every device during a system sleep
> > > transition, regardless of the device's state, so that drivers can regard these
> > > method calls as notifications that the system is about to go to sleep, rather
> > > than as directives to put their devices into the 'off' state.
> > 
> > Did you audit all the drivers to make sure this won't break things?
> > Like for example through inappropriate pci_save_state() calls?
> 
> I did, but not very carefully.
> 
> > I'd really expect this patch would break things...
> 
> Well, in that case I'll have a closer look at them.

It might not be all that bad.  One would expect problems to occur only 
in cases where devices were already suspended at the time of a system 
sleep transition.  Since relatively few drivers currently implement 
runtime PM -- and those that do are likely to be more careful about 
not blindly making state changes -- there might not be too much 
trouble.

Alan Stern


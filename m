Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXGGDok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXGGDok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 23:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXGGDoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 23:44:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:46593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXGGDob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 23:44:31 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0707061034540.3737-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707061034540.3737-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 13:44:05 +1000
Message-Id: <1183779845.3388.206.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 10:38 -0400, Alan Stern wrote:
> On Fri, 6 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> > What you propose is basically a slightly over-simplistic version of what
> > I think (and Paulus think) should be done. We do need to do it via
> > driver callbacks down the tree since only drivers can know how to deal
> > with their DMA etc... and ordering need to be respected, but that's
> > basically it.
> > 
> > And guess what ? It's what we do on powerbooks, and it works fine,
> > without a freezer :-)
> 
> I wish you'd stop saying that.  Have you ever done any serious testing?
> 
> Here's something to try:  Add a time delay to the end of hub_suspend in
> drivers/usb/core/hub.c, so you can provoke a race manually.  Then while
> one of your root hubs is being suspended and the system is waiting in
> that delay, either plug in a new USB device to that hub or unplug an
> existing device.
> 
> Be sure that CONFIG_USB_DEBUG is on so that we can figure out what 
> happened after the fact.

If you remember, one of the things I've been advocating has always been
that we should put on hold all plug activity (unplug might be alright as
long as the user events are just delayed) when we start suspending. No
new devices, no new bindings. "hub" type devices are respondible for
bringing in the new stuff after resume.

Ben.

